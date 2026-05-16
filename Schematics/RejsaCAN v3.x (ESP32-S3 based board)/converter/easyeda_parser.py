"""
EasyEDA Standard schematic JSON -> intermediate structure.

Parses the tilde/caret/hash-encoded shape mini-language used by
EasyEDA Standard editor v6.x and produces clean Python dataclasses.

Output: an EasyEDASchematic with parts, wires, junctions, labels,
no-connects, and a resolved netlist (per-pin net names).
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


# ---------- intermediate model ----------

@dataclass
class Pin:
    number: str
    x: float           # absolute port (connection) coordinate
    y: float
    name: str = ""
    rotation: int = 0


@dataclass
class Part:
    gid: str
    designator: str    # e.g. "U1", "R3"
    value: str         # e.g. "10k", "ESP32-S3-WROOM-1"
    package: str
    mfr: str
    mfr_pn: str
    supplier_pn: str
    x: float
    y: float
    rotation: int
    pins: list[Pin] = field(default_factory=list)


@dataclass
class WireSegment:
    x1: float
    y1: float
    x2: float
    y2: float


@dataclass
class Junction:
    x: float
    y: float


@dataclass
class NetLabel:
    x: float           # anchor (connection) coordinate
    y: float
    name: str          # net name (e.g. "GND", "USB5V")


@dataclass
class NoConnect:
    x: float
    y: float


@dataclass
class EasyEDASchematic:
    title: str
    parts: list[Part] = field(default_factory=list)
    wires: list[WireSegment] = field(default_factory=list)
    junctions: list[Junction] = field(default_factory=list)
    labels: list[NetLabel] = field(default_factory=list)
    no_connects: list[NoConnect] = field(default_factory=list)
    # populated by resolve_nets():
    pin_to_net: dict[tuple[str, str], str] = field(default_factory=dict)  # (designator, pin#) -> net
    nets: dict[str, list[tuple[str, str]]] = field(default_factory=dict)  # net -> [(designator, pin#), ...]
    wire_to_net: dict[int, str] = field(default_factory=dict)  # index in self.wires -> net name


# ---------- low-level helpers ----------

def _f(s: str) -> float:
    """Parse a float, tolerating empty strings."""
    return float(s) if s.strip() else 0.0


def _i(s: str, default: int = 0) -> int:
    try:
        return int(float(s))
    except (ValueError, TypeError):
        return default


def _parse_props(prop_blob: str) -> dict[str, str]:
    """
    EasyEDA encodes component metadata as backtick-delimited key/value pairs:
        "package`HDR-M-2.54`Supplier`LCSC`Manufacturer Part`ABC123`"
    Empty values are allowed (two consecutive backticks).
    """
    tokens = prop_blob.split('`')
    # tokens: ['', key1, val1, key2, val2, ..., '']  -- leading/trailing empties vary
    # Strip empties only at the ends (they come from leading/trailing `).
    while tokens and tokens[0] == '':
        tokens.pop(0)
    while tokens and tokens[-1] == '':
        tokens.pop()
    out: dict[str, str] = {}
    i = 0
    while i + 1 < len(tokens):
        out[tokens[i]] = tokens[i + 1]
        i += 2
    return out


def _rotate(dx: float, dy: float, rot: int) -> tuple[float, float]:
    """EasyEDA rotation in degrees, CCW. Pins inside a LIB are stored
    relative to the part origin; for our purposes we use absolute port
    coords directly from the pin's ^^port subfield, so this is unused
    today but kept for future use."""
    rot = rot % 360
    if rot == 0:
        return dx, dy
    if rot == 90:
        return -dy, dx
    if rot == 180:
        return -dx, -dy
    if rot == 270:
        return dy, -dx
    # arbitrary angle (rare in EasyEDA Standard)
    import math
    a = math.radians(rot)
    c, s = math.cos(a), math.sin(a)
    return dx * c - dy * s, dx * s + dy * c


# ---------- per-shape parsers ----------

def _parse_lib(shape: str) -> Part | None:
    """Parse a LIB (component instance) shape."""
    pieces = shape.split('#@$')
    head_fields = pieces[0].split('~')
    # LIB ~ x ~ y ~ propBlob ~ rotation ~ importFlag ~ uuid ~ ...
    if len(head_fields) < 8 or head_fields[0] != 'LIB':
        return None

    px = _f(head_fields[1])
    py = _f(head_fields[2])
    prop_blob = head_fields[3]
    rotation = _i(head_fields[4])
    gid = head_fields[6] if len(head_fields) > 6 else ""

    props = _parse_props(prop_blob)
    package = props.get('package', '')
    mfr = props.get('Manufacturer', '')
    mfr_pn = props.get('Manufacturer Part', '')
    supplier_pn = props.get('Supplier Part', '')
    spice_prefix = props.get('spicePre', '')   # e.g. "R", "C", "U"

    # Designator and value live in T~P~ and T~N~ pieces respectively.
    designator = ''
    value = props.get('spiceSymbolName', '')
    pins: list[Pin] = []

    for piece in pieces[1:]:
        if piece.startswith('T~'):
            tf = piece.split('~')
            # T ~ kind(P|N|L) ~ x ~ y ~ rot ~ color ~ font ~ size ~ ... ~ text ~ ...
            if len(tf) > 12:
                kind = tf[1]
                text = tf[12]
                if kind == 'P':       # Prefix / designator (e.g. U1)
                    designator = text
                elif kind == 'N':     # Name / value (e.g. ESP32-S3-WROOM-1)
                    if text:
                        value = text
        elif piece.startswith('P~'):
            sub = piece.split('^^')
            hdr = sub[0].split('~')
            # P ~ display ~ electrical ~ pinNumber ~ x ~ y ~ rotation ~ gid ~ locked
            if len(hdr) < 7:
                continue
            pin_num = hdr[3]
            pin_rot = _i(hdr[6])
            # Port coordinate is sub[1] = "x~y"
            port_xy = sub[1].split('~') if len(sub) > 1 else [hdr[4], hdr[5]]
            port_x = _f(port_xy[0])
            port_y = _f(port_xy[1])
            # Pin name is sub[3], leading "0~" or "1~" indicates visibility
            pin_name = ""
            if len(sub) > 3:
                name_fields = sub[3].split('~')
                # ex: "1~1037~-432~0~1~start~~~#000000"  -> name_fields[4] = "1"
                if len(name_fields) > 4:
                    pin_name = name_fields[4]
            pins.append(Pin(number=str(pin_num), x=port_x, y=port_y, name=pin_name, rotation=pin_rot))

    if not designator:
        # Fall back to gid-derived label so we always have something
        designator = f"U?{gid[-4:]}" if gid else "U?"

    return Part(
        gid=gid,
        designator=designator,
        value=value or spice_prefix or '',
        package=package,
        mfr=mfr,
        mfr_pn=mfr_pn,
        supplier_pn=supplier_pn,
        x=px,
        y=py,
        rotation=rotation,
        pins=pins,
    )


def _parse_wire(shape: str) -> list[WireSegment]:
    """W~x1 y1 x2 y2 [x3 y3 ...]~color~..."""
    fields = shape.split('~')
    coords = fields[1].split(' ')
    pts: list[tuple[float, float]] = []
    for i in range(0, len(coords) - 1, 2):
        pts.append((_f(coords[i]), _f(coords[i + 1])))
    segs: list[WireSegment] = []
    for a, b in zip(pts, pts[1:]):
        segs.append(WireSegment(a[0], a[1], b[0], b[1]))
    return segs


def _parse_junction(shape: str) -> Junction:
    fields = shape.split('~')
    return Junction(_f(fields[1]), _f(fields[2]))


def _parse_flag(shape: str) -> NetLabel | None:
    """
    F (flag/net label) format:
        F~part_netLabel_<style>~x~y~rotation~gid~~lock^^anchorX~anchorY^^netName~textColor~textX~textY~rot~justify~size~font~~flag_id^^...graphics
    """
    sub = shape.split('^^')
    if len(sub) < 3:
        return None
    head = sub[0].split('~')
    flag_kind = head[1] if len(head) > 1 else ''
    # Only treat real net labels / port labels as nets. Skip junction-only
    # decoration flags if any appear (none in this file).
    if not flag_kind.startswith('part_netLabel'):
        return None
    anchor = sub[1].split('~')
    if len(anchor) < 2:
        return None
    ax, ay = _f(anchor[0]), _f(anchor[1])
    name_fields = sub[2].split('~')
    if not name_fields or not name_fields[0]:
        return None
    return NetLabel(x=ax, y=ay, name=name_fields[0])


def _parse_no_connect(shape: str) -> NoConnect:
    """O~x~y~gid~path~color~locked"""
    fields = shape.split('~')
    return NoConnect(_f(fields[1]), _f(fields[2]))


# ---------- top-level parse ----------

def parse(json_path: Path | str) -> EasyEDASchematic:
    json_path = Path(json_path)
    data = json.loads(json_path.read_text(encoding='utf-8'))

    title = data.get('title', json_path.stem)
    sheets = data.get('schematics', [])
    if not sheets:
        raise ValueError("No schematics found in JSON")
    if len(sheets) > 1:
        # Multi-sheet support is a Stage 3 problem; this file is single-sheet.
        # We still accept; downstream emitters will need multi-sheet logic.
        pass

    sch = EasyEDASchematic(title=title)
    shapes: list[str] = sheets[0].get('dataStr', {}).get('shape', [])

    for s in shapes:
        prefix = s.split('~', 1)[0]
        if prefix == 'LIB':
            # Skip the page frame — it's a LIB but with package=NONE and gid frame_lib_*
            if 'frame_lib' in s[:40] or '`NONE`' in s[:200]:
                continue
            part = _parse_lib(s)
            if part is not None:
                sch.parts.append(part)
        elif prefix == 'W':
            sch.wires.extend(_parse_wire(s))
        elif prefix == 'J':
            sch.junctions.append(_parse_junction(s))
        elif prefix == 'F':
            lbl = _parse_flag(s)
            if lbl is not None:
                sch.labels.append(lbl)
        elif prefix == 'O':
            sch.no_connects.append(_parse_no_connect(s))
        # T (free text), R (frame rect), etc. are decorative — ignore.

    _split_wires_at_intersections(sch)
    resolve_nets(sch)
    return sch


def _split_wires_at_intersections(sch: EasyEDASchematic) -> None:
    """
    Find every wire segment whose interior is touched by another wire's
    endpoint, a junction, or a pin port, and split it at that point so
    the downstream union-find sees the T-intersection as a real
    connection.  Also drops degenerate (zero-length) segments that
    EasyEDA sometimes leaves in.
    """
    EPS = 0.5  # EasyEDA-units tolerance — coords are usually integer

    interesting: set[tuple[int, int]] = set()
    for part in sch.parts:
        for pin in part.pins:
            interesting.add(_key(pin.x, pin.y))
    for j in sch.junctions:
        interesting.add(_key(j.x, j.y))
    for w in sch.wires:
        interesting.add(_key(w.x1, w.y1))
        interesting.add(_key(w.x2, w.y2))
    for lbl in sch.labels:
        interesting.add(_key(lbl.x, lbl.y))

    new_wires: list[WireSegment] = []
    for w in sch.wires:
        # Drop degenerate (zero-length) wires.
        if abs(w.x1 - w.x2) < EPS and abs(w.y1 - w.y2) < EPS:
            continue

        a_key = _key(w.x1, w.y1)
        b_key = _key(w.x2, w.y2)
        interior_points: list[tuple[float, float]] = []

        if abs(w.x1 - w.x2) < EPS:
            # Vertical wire.
            x = w.x1
            ymin, ymax = (w.y1, w.y2) if w.y1 <= w.y2 else (w.y2, w.y1)
            for kx, ky in interesting:
                if (kx, ky) == a_key or (kx, ky) == b_key:
                    continue
                px = kx / 100.0
                py = ky / 100.0
                if abs(px - x) < EPS and (ymin + EPS) < py < (ymax - EPS):
                    interior_points.append((x, py))
            interior_points.sort(key=lambda p: p[1], reverse=(w.y1 > w.y2))
        elif abs(w.y1 - w.y2) < EPS:
            # Horizontal wire.
            y = w.y1
            xmin, xmax = (w.x1, w.x2) if w.x1 <= w.x2 else (w.x2, w.x1)
            for kx, ky in interesting:
                if (kx, ky) == a_key or (kx, ky) == b_key:
                    continue
                px = kx / 100.0
                py = ky / 100.0
                if abs(py - y) < EPS and (xmin + EPS) < px < (xmax - EPS):
                    interior_points.append((px, y))
            interior_points.sort(key=lambda p: p[0], reverse=(w.x1 > w.x2))
        # Diagonal wires are rare in EasyEDA schematics — leave them alone.

        prev = (w.x1, w.y1)
        for p in interior_points:
            new_wires.append(WireSegment(prev[0], prev[1], p[0], p[1]))
            prev = p
        new_wires.append(WireSegment(prev[0], prev[1], w.x2, w.y2))

    sch.wires = new_wires


# ---------- net resolution (union-find on connection points) ----------

def _key(x: float, y: float) -> tuple[int, int]:
    """Quantize coordinates so floating-point jitter doesn't break equality.
    EasyEDA Standard uses integer grid mostly; 0.01 quantum is generous."""
    return (round(x * 100), round(y * 100))


class _UF:
    def __init__(self) -> None:
        self.parent: dict[tuple[int, int], tuple[int, int]] = {}

    def add(self, k: tuple[int, int]) -> None:
        if k not in self.parent:
            self.parent[k] = k

    def find(self, k: tuple[int, int]) -> tuple[int, int]:
        self.add(k)
        path = []
        while self.parent[k] != k:
            path.append(k)
            k = self.parent[k]
        for p in path:
            self.parent[p] = k
        return k

    def union(self, a: tuple[int, int], b: tuple[int, int]) -> None:
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.parent[ra] = rb


def resolve_nets(sch: EasyEDASchematic) -> None:
    """Union pin ports + wire endpoints + junction points into nets,
    then assign net names from labels (or auto-number)."""
    uf = _UF()

    # Add every connection point.
    pin_keys: list[tuple[tuple[int, int], str, str]] = []  # (key, designator, pin#)
    for part in sch.parts:
        for pin in part.pins:
            k = _key(pin.x, pin.y)
            uf.add(k)
            pin_keys.append((k, part.designator, pin.number))

    for w in sch.wires:
        a = _key(w.x1, w.y1)
        b = _key(w.x2, w.y2)
        uf.union(a, b)

    # Junctions don't add new connectivity by themselves (they're decorative
    # markers placed where 3+ wires meet) but we add them for completeness.
    for j in sch.junctions:
        uf.add(_key(j.x, j.y))

    # Labels: a label at (x,y) names the net at that point. Multiple labels
    # with the same name on different roots imply those roots are the same
    # net (named global net like GND, +3V3, etc.).
    label_groups: dict[str, list[tuple[int, int]]] = {}
    for lbl in sch.labels:
        k = _key(lbl.x, lbl.y)
        uf.add(k)
        label_groups.setdefault(lbl.name, []).append(k)

    for keys in label_groups.values():
        first = keys[0]
        for k in keys[1:]:
            uf.union(first, k)

    # Now assign net names: priority = label name, else auto N$<n>.
    root_to_name: dict[tuple[int, int], str] = {}
    for name, keys in label_groups.items():
        root = uf.find(keys[0])
        # If two different labels collide on the same root, keep both names
        # by joining (rare). Prefer existing.
        if root in root_to_name and root_to_name[root] != name:
            root_to_name[root] = root_to_name[root] + "/" + name
        else:
            root_to_name[root] = name

    auto_counter = 1

    def _name_for(root: tuple[int, int]) -> str:
        nonlocal auto_counter
        if root not in root_to_name:
            root_to_name[root] = f"N${auto_counter}"
            auto_counter += 1
        return root_to_name[root]

    pin_to_net: dict[tuple[str, str], str] = {}
    nets: dict[str, list[tuple[str, str]]] = {}
    for k, des, pin in pin_keys:
        net = _name_for(uf.find(k))
        pin_to_net[(des, pin)] = net
        nets.setdefault(net, []).append((des, pin))

    # Assign each wire segment to its net (wires whose root is unnamed get
    # an auto net).  Both endpoints share a root after union, so we use x1,y1.
    wire_to_net: dict[int, str] = {}
    for idx, w in enumerate(sch.wires):
        wire_to_net[idx] = _name_for(uf.find(_key(w.x1, w.y1)))

    sch.pin_to_net = pin_to_net
    sch.nets = nets
    sch.wire_to_net = wire_to_net


# ---------- CLI / sanity dump ----------

def _summary(sch: EasyEDASchematic) -> str:
    lines = []
    lines.append(f"Title: {sch.title}")
    lines.append(f"Parts: {len(sch.parts)}")
    lines.append(f"Wire segments: {len(sch.wires)}")
    lines.append(f"Junctions: {len(sch.junctions)}")
    lines.append(f"Labels: {len(sch.labels)}")
    lines.append(f"No-connects: {len(sch.no_connects)}")
    lines.append(f"Resolved nets: {len(sch.nets)}")
    lines.append("")

    # Parts table
    lines.append("=== Parts (designator, value, package, pins) ===")
    for p in sorted(sch.parts, key=lambda x: x.designator):
        lines.append(f"  {p.designator:<8} {p.value:<24} {p.package:<28} pins={len(p.pins)}  mfrPN={p.mfr_pn}")
    lines.append("")

    # Top nets by pin count
    lines.append("=== Top 15 nets by pin count ===")
    for name, members in sorted(sch.nets.items(), key=lambda kv: -len(kv[1]))[:15]:
        sample = ", ".join(f"{d}.{p}" for d, p in members[:6])
        more = f" (+{len(members) - 6} more)" if len(members) > 6 else ""
        lines.append(f"  {name:<14} ({len(members):>2} pins): {sample}{more}")
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description="Parse EasyEDA schematic JSON.")
    ap.add_argument("json_path", help="path to EasyEDA schematic JSON")
    args = ap.parse_args(argv)

    sch = parse(args.json_path)
    print(_summary(sch))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

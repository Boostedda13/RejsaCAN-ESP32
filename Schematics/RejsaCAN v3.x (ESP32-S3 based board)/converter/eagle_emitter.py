"""
Eagle 9.x .sch XML emitter for the EasyEDA -> Eagle bridge.

Strategy: synthesize one Eagle symbol+device per part (no dedupe in v1).
Pins are placed at canonical (un-rotated) symbol-local coordinates, with
direction inferred from which edge of the bounding box they sit on.
Devices have no package mapping (schematic-only); user can attach
packages later in Fusion.
"""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable
from xml.sax.saxutils import escape as xml_escape

from easyeda_parser import EasyEDASchematic, Part, Pin, _rotate


# ---------- coordinate transform ----------

# EasyEDA uses 10 mil units (1 unit = 0.254 mm) and Y positive-down.
# Eagle uses millimetres with Y positive-up.
SCALE = 0.254  # mm per EasyEDA unit


def to_mm_x(x: float) -> float:
    return round(x * SCALE, 4)


def to_mm_y(y: float) -> float:
    # Flip Y so Eagle's positive-up convention puts the schematic frame
    # in the positive quadrant.
    return round(-y * SCALE, 4)


def relative_pin_mm(part: Part, pin: Pin) -> tuple[float, float]:
    """Pin position in symbol-local coords (canonical, un-rotated, mm)."""
    dx = pin.x - part.x
    dy = pin.y - part.y
    # Undo the part's rotation so the symbol is stored canonically.
    ux, uy = _rotate(dx, dy, -part.rotation)
    return round(ux * SCALE, 4), round(-uy * SCALE, 4)


def eagle_rot(degrees: int) -> str:
    deg = ((-degrees) % 360)  # EasyEDA CW vs Eagle CCW; flip Y also flips sense
    deg = round(deg / 90) * 90 % 360
    return f"R{deg}"


# ---------- pin direction inference ----------

def infer_pin_rot_from_body(pin_x: float, pin_y: float, body_bbox: tuple[float, float, float, float]) -> str:
    """
    Pick the Eagle pin rotation that points the pin INTO the symbol
    body.  body_bbox = (min_x, min_y, max_x, max_y).  Pins sit on or
    outside the body's edges; the rotation determines which edge the
    pin is attached to (and therefore which way the pin's drawn line
    extends).
    """
    bx0, by0, bx1, by1 = body_bbox
    # Negative = pin is outside that edge of the body.
    options = [
        (pin_x - bx0, "R0"),    # outside-left  -> extend right
        (bx1 - pin_x, "R180"),  # outside-right -> extend left
        (pin_y - by0, "R90"),   # below body    -> extend up
        (by1 - pin_y, "R270"),  # above body    -> extend down
    ]
    options.sort(key=lambda o: o[0])
    return options[0][1]


# ---------- name sanitisation ----------

# Eagle 9 / Fusion is fairly permissive but rejects whitespace and a few
# punctuation marks in identifiers. We preserve the user's designators
# verbatim where possible and only escape what Eagle truly cannot handle.
_BAD_NAME_CHARS = set(" \t\n\r'\"&<>")


def sane_name(name: str, fallback: str = "X") -> str:
    if not name:
        return fallback
    out = []
    for ch in name:
        if ch in _BAD_NAME_CHARS:
            out.append('_')
        else:
            out.append(ch)
    s = "".join(out)
    return s or fallback


# ---------- XML writer ----------

@dataclass
class _XmlBuf:
    parts: list[str]
    indent: int = 0

    def line(self, s: str) -> None:
        self.parts.append("  " * self.indent + s)

    def open(self, tag: str, **attrs) -> None:
        self.line(f"<{tag}{_attrs(attrs)}>")
        self.indent += 1

    def close(self, tag: str) -> None:
        self.indent -= 1
        self.line(f"</{tag}>")

    def empty(self, tag: str, **attrs) -> None:
        self.line(f"<{tag}{_attrs(attrs)}/>")


def _attrs(d: dict[str, object]) -> str:
    parts = []
    for k, v in d.items():
        if v is None:
            continue
        if isinstance(v, float):
            v = f"{v:g}"
        parts.append(f' {k}="{xml_escape(str(v), {chr(34): "&quot;"})}"')
    return "".join(parts)


# ---------- main emit ----------

PIN_LENGTH = "point"  # zero-length: pin connection IS the coord, no stub to collide
WIRE_WIDTH = 0.1524    # default Eagle net wire width
SYMBOL_LINE = 0.254
LIB_NAME = "rejsacan_synth"
NET_LAYER = "91"
SYMBOL_LAYER = "94"
NAME_LAYER = "95"
VALUE_LAYER = "96"


def _gather_symbol(part: Part) -> dict:
    """Compute symbol-local pin geometry, body box, and pin rotations."""
    pins = []
    for pin in part.pins:
        px, py = relative_pin_mm(part, pin)
        pins.append({
            "number": pin.number,
            "name": pin.name or pin.number,
            "x": px,
            "y": py,
        })
    if pins:
        xs = [p["x"] for p in pins]
        ys = [p["y"] for p in pins]
        pin_bbox = (min(xs), min(ys), max(xs), max(ys))
    else:
        pin_bbox = (0.0, 0.0, 2.54, 2.54)

    body_bbox = _build_body_bbox(pin_bbox)
    # Skip drawing body wires when pins are colinear: a thin synthesised
    # body inevitably touches neighbouring parts' pin coords on the
    # sheet (since EasyEDA original art lives elsewhere) and triggers
    # "Net X overlaps pin" / "Pins overlap" warnings.  Connectivity is
    # unaffected without a visible body.
    show_body = (pin_bbox[2] - pin_bbox[0]) >= 0.5 and (pin_bbox[3] - pin_bbox[1]) >= 0.5
    for p in pins:
        p["rot"] = infer_pin_rot_from_body(p["x"], p["y"], body_bbox)
    return {"pins": pins, "pin_bbox": pin_bbox, "body_bbox": body_bbox, "show_body": show_body}


PIN_LEN_MM = 2.54   # Eagle "short" pin length
PIN_MARGIN = 1.27   # extra body margin past extreme pin positions
DEGEN_BODY_THICKNESS = 1.27   # thin body on perpendicular axis when pins colinear


def _build_body_bbox(pin_bbox: tuple[float, float, float, float]) -> tuple[float, float, float, float]:
    """
    Pick a body rectangle that pins sit on the OUTSIDE of.  Bodies are
    kept small to avoid colliding with neighbouring parts on the sheet:
    in EasyEDA the original symbol art may sit in a different region
    than our synthesised placeholder rectangle.
    """
    min_x, min_y, max_x, max_y = pin_bbox
    width = max_x - min_x
    height = max_y - min_y

    if width < 0.5 and height < 0.5:
        # All pins coincident — small box.
        return (min_x - 0.635, min_y - 0.635, min_x + 0.635, min_y + 0.635)

    if width < 0.5:
        # All pins on a vertical line — thin body just to the right.
        return (min_x + PIN_LEN_MM,
                min_y - PIN_MARGIN,
                min_x + PIN_LEN_MM + DEGEN_BODY_THICKNESS,
                max_y + PIN_MARGIN)
    if height < 0.5:
        # All pins on a horizontal line — thin body just above.
        return (min_x - PIN_MARGIN,
                min_y + PIN_LEN_MM,
                max_x + PIN_MARGIN,
                min_y + PIN_LEN_MM + DEGEN_BODY_THICKNESS)

    # Both axes spread — inset pin bbox by pin length so the body sits
    # entirely INSIDE the pin envelope (won't intrude on neighbours).
    ix0 = min_x + PIN_LEN_MM
    iy0 = min_y + PIN_LEN_MM
    ix1 = max_x - PIN_LEN_MM
    iy1 = max_y - PIN_LEN_MM
    if ix1 - ix0 < 1.0 or iy1 - iy0 < 1.0:
        cx = (min_x + max_x) / 2
        cy = (min_y + max_y) / 2
        return (cx - 1.27, cy - 1.27, cx + 1.27, cy + 1.27)
    return (ix0, iy0, ix1, iy1)


def _coord_key(x: float, y: float) -> tuple[int, int]:
    """Quantize a coordinate for hashable equality (matches parser._key)."""
    return (round(x * 100), round(y * 100))


def _absolute_pin_coord(sch: EasyEDASchematic, designator: str, pin_num: str) -> tuple[float, float] | None:
    """Look up a pin's absolute EasyEDA coord by (designator, pin#)."""
    for part in sch.parts:
        if part.designator == designator:
            for pin in part.pins:
                if pin.number == pin_num:
                    return (pin.x, pin.y)
    return None


def _emit_partitioned_nets(buf: _XmlBuf, sch: EasyEDASchematic) -> None:
    # Index labels and junctions by net.  A label's net is its name; a
    # junction's net is found by querying any wire endpoint at its coord.
    labels_by_net: dict[str, list[tuple[float, float]]] = {}
    for lbl in sch.labels:
        labels_by_net.setdefault(lbl.name, []).append((lbl.x, lbl.y))

    # Group wires by net for partitioning.
    wires_by_net: dict[str, list[int]] = {}
    for idx, net in sch.wire_to_net.items():
        wires_by_net.setdefault(net, []).append(idx)

    # Junction coords -> set, queried per-segment
    junction_keys = {_coord_key(j.x, j.y): (j.x, j.y) for j in sch.junctions}

    all_nets = sorted(set(sch.nets.keys()) | set(wires_by_net.keys()))
    for net_name in all_nets:
        members = sch.nets.get(net_name, [])
        wire_idxs = wires_by_net.get(net_name, [])
        if not members and not wire_idxs:
            continue

        # Build connected components from wire endpoints (graph connectivity
        # WITHIN this net only — labels do not bridge components in Eagle's
        # segment model).
        # Each component = set of coord-keys.
        coord_to_comp: dict[tuple[int, int], int] = {}
        comps: list[dict] = []  # each: {keys: set, wires: list[int], pinrefs: list, labels: list, juncs: list}

        def _new_comp() -> int:
            comps.append({"keys": set(), "wires": [], "pinrefs": [], "labels": [], "juncs": []})
            return len(comps) - 1

        def _merge(ci: int, cj: int) -> int:
            if ci == cj:
                return ci
            a, b = (ci, cj) if len(comps[ci]["keys"]) >= len(comps[cj]["keys"]) else (cj, ci)
            ca, cb = comps[a], comps[b]
            for k in cb["keys"]:
                coord_to_comp[k] = a
            ca["keys"] |= cb["keys"]
            ca["wires"].extend(cb["wires"])
            ca["pinrefs"].extend(cb["pinrefs"])
            ca["labels"].extend(cb["labels"])
            ca["juncs"].extend(cb["juncs"])
            cb["keys"].clear()
            cb["wires"].clear()
            cb["pinrefs"].clear()
            cb["labels"].clear()
            cb["juncs"].clear()
            return a

        def _attach_coord(k: tuple[int, int]) -> int:
            if k in coord_to_comp:
                return coord_to_comp[k]
            ci = _new_comp()
            comps[ci]["keys"].add(k)
            coord_to_comp[k] = ci
            return ci

        # 1) Wires: merge endpoints, attach wire to a component.
        for idx in wire_idxs:
            w = sch.wires[idx]
            ka = _coord_key(w.x1, w.y1)
            kb = _coord_key(w.x2, w.y2)
            ca = _attach_coord(ka)
            cb = _attach_coord(kb)
            ci = _merge(ca, cb)
            comps[ci]["wires"].append(idx)

        # 2) Pinrefs: attach to component whose key matches the pin's coord;
        #    if no match (isolated pin), give it its own component.
        for des, pin_num in members:
            coord = _absolute_pin_coord(sch, des, pin_num)
            if coord is None:
                continue
            k = _coord_key(*coord)
            ci = _attach_coord(k)
            comps[ci]["pinrefs"].append((des, pin_num))

        # 3) Labels: attach by coord (creating own component if floating).
        for lx, ly in labels_by_net.get(net_name, []):
            k = _coord_key(lx, ly)
            ci = _attach_coord(k)
            comps[ci]["labels"].append((lx, ly))

        # 4) Junctions: attach if their coord is part of this net.
        for jk, (jx, jy) in junction_keys.items():
            if jk in coord_to_comp:
                ci = coord_to_comp[jk]
                comps[ci]["juncs"].append((jx, jy))

        # Drop emptied components after merges.
        live = [c for c in comps if c["keys"]]
        if not live:
            continue

        buf.open("net", name=net_name, **{"class": "0"})
        for c in live:
            # Skip segments with no electrical content (a stray label or
            # junction by itself is pointless and triggers ERC noise).
            if not c["wires"] and not c["pinrefs"]:
                continue

            # ---- Detect floating pinrefs and synthesise stub wires.
            # Eagle's "pin connected to NET without any net wire, junction
            # or other pin there" warning fires when a pinref's coord has
            # nothing else (wire endpoint / junction / sibling pin) at it.
            # In EasyEDA it's common to attach a label flag directly to a
            # pin port with no explicit wire — we synthesise a 1.27 mm
            # stub so Eagle sees an anchor at the pin coord.
            wire_endpoint_keys: set[tuple[int, int]] = set()
            for idx in c["wires"]:
                w = sch.wires[idx]
                wire_endpoint_keys.add(_coord_key(w.x1, w.y1))
                wire_endpoint_keys.add(_coord_key(w.x2, w.y2))
            junction_keys_in_seg = {_coord_key(jx, jy) for jx, jy in c["juncs"]}

            pinref_resolved: list[tuple[str, str, tuple[float, float]]] = []
            for des, pin_num in c["pinrefs"]:
                coord = _absolute_pin_coord(sch, des, pin_num)
                if coord is not None:
                    pinref_resolved.append((des, pin_num, coord))
            pin_coord_count: dict[tuple[int, int], int] = {}
            for _, _, coord in pinref_resolved:
                key = _coord_key(*coord)
                pin_coord_count[key] = pin_coord_count.get(key, 0) + 1

            stub_wires: list[tuple[tuple[float, float], tuple[float, float]]] = []
            for des, pin_num, coord in pinref_resolved:
                key = _coord_key(*coord)
                if key in wire_endpoint_keys:
                    continue
                if key in junction_keys_in_seg:
                    continue
                if pin_coord_count[key] > 1:
                    continue
                # Synthesise 1.27 mm horizontal stub (5 EasyEDA units in +x).
                stub_end = (coord[0] + 5.0, coord[1])
                stub_wires.append((coord, stub_end))
                wire_endpoint_keys.add(key)
                wire_endpoint_keys.add(_coord_key(*stub_end))

            # ---- Emit
            buf.open("segment")
            for des, pin_num in c["pinrefs"]:
                buf.empty("pinref", part=sane_name(des, 'X'), gate="G$1", pin=pin_num)
            for idx in c["wires"]:
                w = sch.wires[idx]
                buf.empty(
                    "wire",
                    x1=to_mm_x(w.x1),
                    y1=to_mm_y(w.y1),
                    x2=to_mm_x(w.x2),
                    y2=to_mm_y(w.y2),
                    width=WIRE_WIDTH,
                    layer=NET_LAYER,
                )
            for (sx, sy), (ex, ey) in stub_wires:
                buf.empty(
                    "wire",
                    x1=to_mm_x(sx),
                    y1=to_mm_y(sy),
                    x2=to_mm_x(ex),
                    y2=to_mm_y(ey),
                    width=WIRE_WIDTH,
                    layer=NET_LAYER,
                )
            # Junctions: emit one wherever 3+ wire endpoints coincide in
            # this segment, regardless of whether EasyEDA originally marked
            # one.  T-intersection splitting may have created new such
            # coords that the source file never knew about.
            from collections import Counter as _Counter
            endpoint_count: _Counter[tuple[int, int]] = _Counter()
            key_to_eagle: dict[tuple[int, int], tuple[float, float]] = {}
            for idx in c["wires"]:
                w = sch.wires[idx]
                k1 = _coord_key(w.x1, w.y1)
                k2 = _coord_key(w.x2, w.y2)
                endpoint_count[k1] += 1
                endpoint_count[k2] += 1
                key_to_eagle[k1] = (to_mm_x(w.x1), to_mm_y(w.y1))
                key_to_eagle[k2] = (to_mm_x(w.x2), to_mm_y(w.y2))
            for (sx, sy), (ex, ey) in stub_wires:
                k1 = _coord_key(sx, sy)
                k2 = _coord_key(ex, ey)
                endpoint_count[k1] += 1
                endpoint_count[k2] += 1
                key_to_eagle[k1] = (to_mm_x(sx), to_mm_y(sy))
                key_to_eagle[k2] = (to_mm_x(ex), to_mm_y(ey))
            # Pinrefs at a coord count toward the "3+ entities meeting"
            # rule: Eagle's "missing junction" warning fires for cases
            # like "1 pin + 2 wires meeting" where a junction dot
            # disambiguates a T-intersection at the pin.
            pinref_count: _Counter[tuple[int, int]] = _Counter()
            for des, pin_num, coord in pinref_resolved:
                key = _coord_key(*coord)
                pinref_count[key] += 1
                key_to_eagle.setdefault(key, (to_mm_x(coord[0]), to_mm_y(coord[1])))

            all_keys = set(endpoint_count) | set(pinref_count)
            for k in all_keys:
                wcnt = endpoint_count.get(k, 0)
                pcnt = pinref_count.get(k, 0)
                # Emit a junction if 3+ entities meet at the coord OR
                # if 2+ pins overlap (Eagle's "Pins overlap" warning).
                if wcnt + pcnt >= 3 or pcnt >= 2:
                    ex, ey = key_to_eagle[k]
                    buf.empty("junction", x=ex, y=ey)
            for lx, ly in c["labels"]:
                buf.empty(
                    "label",
                    x=to_mm_x(lx),
                    y=to_mm_y(ly),
                    size="1.778",
                    layer=NAME_LAYER,
                )
            buf.close("segment")
        buf.close("net")


def emit(sch: EasyEDASchematic, output_path: Path | str, eagle_version: str = "9.7.0") -> Path:
    output_path = Path(output_path)
    buf = _XmlBuf(parts=[])
    buf.line('<?xml version="1.0" encoding="utf-8"?>')
    buf.line('<!DOCTYPE eagle SYSTEM "eagle.dtd">')
    buf.open("eagle", version=eagle_version)
    buf.open("drawing")

    # Settings + grid + layers (boilerplate)
    buf.open("settings")
    buf.empty("setting", alwaysvectorfont="no")
    buf.empty("setting", verticaltext="up")
    buf.close("settings")
    buf.empty(
        "grid",
        distance="0.1",
        unitdist="inch",
        unit="inch",
        style="lines",
        multiple="1",
        display="no",
        altdistance="0.01",
        altunitdist="inch",
        altunit="inch",
    )
    buf.open("layers")
    for num, name, color in [
        (91, "Nets", 2),
        (92, "Busses", 1),
        (93, "Pins", 2),
        (94, "Symbols", 4),
        (95, "Names", 7),
        (96, "Values", 7),
        (97, "Info", 7),
        (98, "Guide", 6),
    ]:
        buf.empty(
            "layer",
            number=num,
            name=name,
            color=color,
            fill=1,
            visible="yes",
            active="yes",
        )
    buf.close("layers")

    buf.open("schematic", xreflabel="%F%N/%S.%C%R", xrefpart="/%S.%C%R")

    # Library: one symbol + one deviceset per part (no dedupe in v1)
    buf.open("libraries")
    buf.open("library", name=LIB_NAME)
    buf.line("<description>Synthesized from EasyEDA source.</description>")
    buf.empty("packages")  # schematic-only

    # Symbols
    symbols = {}
    for part in sch.parts:
        sym_name = f"SYM_{sane_name(part.designator, 'X')}"
        symbols[part.designator] = sym_name

    buf.open("symbols")
    for part in sch.parts:
        sym_name = symbols[part.designator]
        info = _gather_symbol(part)
        ix0, iy0, ix1, iy1 = info["body_bbox"]
        buf.open("symbol", name=sym_name)
        if info["show_body"]:
            for x1, y1, x2, y2 in [
                (ix0, iy0, ix1, iy0),
                (ix1, iy0, ix1, iy1),
                (ix1, iy1, ix0, iy1),
                (ix0, iy1, ix0, iy0),
            ]:
                buf.empty("wire", x1=x1, y1=y1, x2=x2, y2=y2, width=SYMBOL_LINE, layer=SYMBOL_LAYER)
        # Name and Value text fields above and below body
        buf.line(
            f'<text x="{ix0:g}" y="{iy1 + 0.5:g}" size="1.778" layer="{NAME_LAYER}">&gt;NAME</text>'
        )
        buf.line(
            f'<text x="{ix0:g}" y="{iy0 - 2.5:g}" size="1.778" layer="{VALUE_LAYER}">&gt;VALUE</text>'
        )
        # Pins
        for p in info["pins"]:
            buf.empty(
                "pin",
                name=p["number"],   # use pin NUMBER as Eagle pin name (matches connectivity)
                x=p["x"],
                y=p["y"],
                length=PIN_LENGTH,
                rot=p["rot"],
                direction="pas",
                visible="pad",
            )
        buf.close("symbol")
    buf.close("symbols")

    # Devicesets: one per part, single gate, no package mapping
    buf.open("devicesets")
    for part in sch.parts:
        sym_name = symbols[part.designator]
        ds_name = f"DS_{sane_name(part.designator, 'X')}"
        buf.open("deviceset", name=ds_name, prefix="", uservalue="yes")
        buf.line(f"<description>{xml_escape(part.mfr_pn or part.value)}</description>")
        buf.open("gates")
        buf.empty("gate", name="G$1", symbol=sym_name, x=0, y=0)
        buf.close("gates")
        buf.open("devices")
        buf.open("device", name="")
        buf.open("technologies")
        buf.empty("technology", name="")
        buf.close("technologies")
        buf.close("device")
        buf.close("devices")
        buf.close("deviceset")
    buf.close("devicesets")

    buf.close("library")
    buf.close("libraries")

    buf.empty("attributes")
    buf.empty("variantdefs")
    buf.open("classes")
    buf.empty("class", number="0", name="default", width="0", drill="0")
    buf.close("classes")

    # Parts (instances of devices)
    buf.open("parts")
    for part in sch.parts:
        ds_name = f"DS_{sane_name(part.designator, 'X')}"
        buf.empty(
            "part",
            name=sane_name(part.designator, 'X'),
            library=LIB_NAME,
            deviceset=ds_name,
            device="",
            value=part.value or part.mfr_pn,
        )
    buf.close("parts")

    # Single sheet
    buf.open("sheets")
    buf.open("sheet")
    buf.empty("plain")
    buf.open("instances")
    for part in sch.parts:
        buf.empty(
            "instance",
            part=sane_name(part.designator, 'X'),
            gate="G$1",
            x=to_mm_x(part.x),
            y=to_mm_y(part.y),
            rot=eagle_rot(part.rotation),
        )
    buf.close("instances")
    buf.empty("busses")

    # Nets: partition each net into physically-connected segments.
    # Eagle's "segment of net X has fallen apart" ERC error fires when a
    # single <segment> contains wires that aren't graph-connected.  Bridge
    # via shared label name: those become separate <segment>s under the
    # same <net>.
    buf.open("nets")
    _emit_partitioned_nets(buf, sch)
    buf.close("nets")

    buf.close("sheet")
    buf.close("sheets")

    buf.close("schematic")
    buf.close("drawing")
    buf.close("eagle")

    output_path.write_text("\n".join(buf.parts), encoding="utf-8")
    return output_path

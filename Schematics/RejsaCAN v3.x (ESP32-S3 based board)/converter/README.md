# EasyEDA Standard → Fusion/Eagle 9.x converter

Custom converter built to translate the RejsaCAN v3.4 EasyEDA Standard
schematic (`RejsaCAN v3.4 - Schematic.json`) into a Fusion-importable
Eagle 9.x `.sch` file. Fusion Electronics has no native EasyEDA
importer; the official-blessed paths (EasyEDA → Altium → Fusion, or
EasyEDA → KiCad) all failed in different ways, so we built this.

## Files

| File | Purpose |
|---|---|
| `easyeda_parser.py` | Parses the tilde/caret/hash-encoded EasyEDA JSON into clean Python dataclasses; also resolves nets via union-find and splits wires at T-intersections. |
| `eagle_emitter.py` | Synthesises an Eagle 9.x XML schematic (library + parts + sheet + nets) from the parsed structure. |
| `convert.py` | CLI: `python convert.py <input.json> [-o output.sch] [--summary]` |

Run from this `converter/` directory:

```
python convert.py "..\RejsaCAN v3.4 - Schematic.json" -o "..\RejsaCAN v3.4.sch"
```

## EasyEDA Standard JSON format (reverse-engineered)

The schematic file is a JSON wrapper around a list of "shape" strings,
each tilde-delimited. Multi-piece shapes use `#@$` between sub-pieces
and `^^` between sub-fields within a piece.

Top-level structure:
```
{
  "editorVersion": "6.5.39",
  "docType": "5",
  "title": "...",
  "schematics": [
    {
      "dataStr": {
        "shape": [ "<shape1>", "<shape2>", ... ]
      }
    }
  ]
}
```

### Shape prefixes seen in this file

| Prefix | Count | Meaning |
|---|---|---|
| `LIB` | 66 | Component instance (incl. 1 page-frame instance) |
| `W` | 144 | Wire polyline (`W~x1 y1 x2 y2 [x3 y3 ...]~color~...`) |
| `J` | 74 | Junction dot (`J~x~y~radius~color~gid~lock`) |
| `F` | 90 | Net label / flag (anchor + text + decoration) |
| `O` | 11 | No-connect marker (X-shape glyph at a coord) |
| `T` | 2 | Free text annotation |

### LIB (component) internals

A LIB shape has the header followed by `#@$`-separated sub-pieces:
```
LIB ~ x ~ y ~ propBlob ~ rotation ~ importFlag ~ uuid ~ ...
  #@$ T~P~...~designator~...     (designator)
  #@$ T~N~...~value~...           (value/name)
  #@$ R~bx~by~bw~bh~...           (body rectangle, decorative)
  #@$ P~display~elec~pinNum~px~py~rot~gid~lock^^portX~portY^^pathDef^^pinNameField^^pinNumField^^...
  #@$ ... (more pins)
```

**propBlob** is backtick-delimited key/value pairs:
```
package`HDR-M-2.54_1X2`Supplier Part`C124375`Supplier`LCSC`...`
```

**Pin** sub-piece pieces (joined by `^^`):
1. Header: `P~show~0~<pinNum>~<x>~<y>~<rot>~<gid>~<lock>`
2. Port: `<portX>~<portY>` — **this is the wire-attach coordinate**
3. Path: `M ... h ...` — pin line drawing
4. Pin name field: `1~<x>~<y>~0~<text>~start~~~<color>`
5. Pin number field
6. Optional clock/dot decorations

### F (net label) internals

```
F~part_netLabel_<style>~<x>~<y>~<rot>~<gid>~~<lock>
  ^^<anchorX>~<anchorY>
  ^^<netName>~<color>~<textX>~<textY>~...~<flag_id>
  ^^PL~<polyline...>  (label flag graphics, decoration only)
  ^^...
```

The **net name** is the first sub-field of the third `^^`-piece. The
**anchor** in the second piece is the connection point (where the flag
"points to").

### Coordinate system

EasyEDA Standard uses **10-mil units** (1 unit = 0.254 mm) with **Y
positive-down**. Eagle uses millimetres with Y positive-up. Conversion:

```
eagle_mm_x = easyeda_x * 0.254
eagle_mm_y = -easyeda_y * 0.254
```

The 1149 × 806 sheet frame is exactly A4 (291.85 × 204.72 mm) at this
scale.

## Architecture

### Stage 1 — parse → intermediate

`easyeda_parser.parse(path)` returns an `EasyEDASchematic`:

```python
@dataclass
class EasyEDASchematic:
    title: str
    parts: list[Part]              # 65 components (page frame stripped)
    wires: list[WireSegment]       # 247 segments after T-intersection split
    junctions: list[Junction]      # 74 junction markers
    labels: list[NetLabel]         # 90 named-net labels
    no_connects: list[NoConnect]   # 11 NC markers
    pin_to_net: dict[(des, pin#), net_name]
    nets: dict[net_name, list[(des, pin#)]]
    wire_to_net: dict[wire_idx, net_name]
```

Net resolution uses **union-find on coordinate keys** (quantised to
0.01 EasyEDA units). All connection points (pin ports, wire endpoints,
junction coords, label anchors) get added; wires union their two
endpoints; labels with the same name across disjoint clusters union
those clusters (named global nets like `GND`, `+3V3`).

### Stage 2 — emit Eagle 9.x XML

For each part: synthesise one symbol + one deviceset (no dedupe in v1;
65 unique symbols/devicesets, no package mapping). Then emit a single
sheet with instances + nets.

### Net partitioning

A single Eagle `<net>` may contain multiple `<segment>` elements; each
segment must be a graph-connected wire group. Bridging across
segments happens via shared label name. The emitter does its own
union-find per net (over wire endpoints only — labels do **not** bridge
segments) and emits one `<segment>` per connected component, attaching
pinrefs / labels / junctions to whichever component contains their
coord.

## Bugs we hit and fixes

These are the gotchas, in order of severity, all encountered while
iterating against Fusion's ERC. Document them so future-you doesn't
re-discover them.

### 1. T-intersection blindness (catastrophic)

EasyEDA freely allows a wire's endpoint to terminate in the **middle**
of another wire's segment, marked with a junction dot. My initial
union-find merged only on exact endpoint equality, so it missed every
T-intersection — fragmenting what should be one net into many. **Net
count dropped from 100 → 63 once T-splitting was added.**

Fix: `_split_wires_at_intersections()` in `easyeda_parser.py`. For
every wire, find any "interesting" coord (other wire endpoints,
junctions, pin ports, labels) lying on its interior, and replace the
wire with multiple sub-segments through those points. Restricted to
axis-aligned wires (EasyEDA schematics are virtually always
axis-aligned).

### 2. "Segment of net X has fallen apart" (37 errors)

First-pass emitter dumped all wires of a net into one
`<segment>`. Eagle requires each segment to be a graph-connected wire
group. Fix: `_emit_partitioned_nets()` runs union-find per net (over
wires only, not labels) and emits one segment per component.

### 3. Labels attached directly to pins ("floating pinref")

EasyEDA permits a net label flag to attach directly to a pin's port
with no explicit wire drawn. Eagle considers a pinref "floating" if
its coord has no wire endpoint, junction, or sibling pin
there. Fix: emit a 1.27 mm stub wire from each label-only-attached
pinref's coord into space (always +x direction; cosmetic-only).

### 4. Missing junction at pin + 2 wires meeting

Eagle's "missing junction" warning fires not just for 3+ wire endpoints
meeting, but also for **1 pin + 2 wire endpoints** meeting at a coord
(visually a T at the pin). Fix: junction emission rule is
`(wire_endpoints + pinref_count) >= 3 OR pinref_count >= 2`. The
second clause also handles direct pin-on-pin overlaps (the
`R10.1+R9.1`, `R15.1+YELLOW.2`, etc. cases).

### 5. Junctions created from EasyEDA coords were under-emitted

Initial logic only emitted junctions where EasyEDA originally had
one. After T-splitting, **new** multi-endpoint coords appear that
EasyEDA never marked (they were on the interior of a wire before
splitting). Fix: emit junctions self-driven from the segment's wire
endpoint counts, not from `c["juncs"]`.

### 6. Synthesised body boxes colliding with neighbours

For parts where all pins lie on a single axis (most 2-pin SMDs, header
strips, the 13-pin SD-CARD, the 16-pin USBC), the original "body" was
some EasyEDA glyph in a particular position. Our placeholder
rectangle, placed perpendicular to the pin line, ended up overlapping
neighbour parts' pins on the sheet. This triggered "Net X overlaps
pin" / "Pins overlap" warnings.

Fix tried in stages:
- Shrink degenerate-axis body to 1.27 mm thickness — reduced collisions but didn't eliminate edge-touches.
- Drop body wires entirely for degenerate-axis parts (59 of 65) — eliminates warnings but loses cosmetic body shape.
- Switch all pin lengths from `short` (2.54 mm) → `point` (0 mm) — pins can no longer extend to overlap anything.

### 7. Pin rotation pointing into colinear neighbours

For multi-pin colinear parts (SD-CARD's 13 pins all at same x), the
original `infer_pin_rot` used pin-bbox centre — which equalled each
pin's x — so adjacent pins got opposite vertical rotations and their
drawn stubs hit each other's connection points. Fix:
`infer_pin_rot_from_body` chooses rotation by the body edge each pin
is closest to (or outside of), so all pins on one face of a body
rotate the same way.

### 8. Eagle name strictness

Designators like `SD-CARD` (hyphen) and all-caps descriptive names
like `BLUE`, `POWER`, `GPIO`, `I2C` were preserved per user request.
Fusion 9 accepted them all; if a future version of Eagle/Fusion
rejects, run them through `sane_name()` with a stricter character set.

## Final state

- 65 parts, 63 nets, 117 segments, 67 junctions, 534 wires (incl. body
  wires for the 6 chip-style parts and synthesised stubs).
- ~22 ERC warnings remaining, all by design:
  - **19 single-pin nets** — 11 are EasyEDA NC markers (intentional);
    8 are named ESP32 pins not broken out in this design (GPIO6/7/15/16,
    JTAG_ENABLE, MTMS, RXD, TXD). Approve in Fusion's ERC.
  - 0–3 residual cosmetic edge cases.

## Limitations / known cosmetic issues

- **Symbol art is placeholder.** Passives show as connection points
  only (no zigzag/plate). Multi-axis-spread chips show as bounding
  rectangles. Connectivity is correct; cosmetics need manual library
  swap if visual fidelity matters.
- **No PCB output** (`.brd`). The deviceset has no package mapping —
  every part is "schematic-only". Forward-annotate from Fusion to a
  new board if you want to lay out.
- **No multi-sheet support.** Source file has 1 sheet; multi-sheet
  parsing exists in `parse()` but the emitter ignores sheets > 0.
- **NCs handled as single-pin nets**, not Eagle no-connect markers
  (Eagle 9 has no first-class `<no_connect>` element — the standard
  workaround is just an unconnected pin).
- **Stub wires are always +x direction** for label-only-attached pins.
  Could be cosmetically improved by aiming toward where the label
  text sits.

## Future work

If anyone needs to extend this:

- **KiCad emitter** as a peer to `eagle_emitter.py`. The intermediate
  `EasyEDASchematic` is format-agnostic; KiCad's S-expression schema
  is simpler than Eagle's XML. ~1 hour of work.
- **Symbol dedupe.** Currently 65 unique symbols/devicesets. A
  componentUuid-based key would collapse duplicates (all R0402s share
  one symbol).
- **Real symbol art.** Parse the `R~`, `PT~` (path), `PL~` (polyline),
  `E~` (ellipse) sub-pieces inside each LIB and emit as Eagle wire/
  arc/circle elements within the symbol.
- **Package mapping.** Devicesets currently have no `<package>`
  element. Adding a stub package per part (with pad numbers matching
  pin numbers) would enable forward-annotation to a board.
- **Multi-sheet** when source has > 1 sheet.
- **Bus support.** EasyEDA buses (B-prefix shapes) are not handled.
  This file has no buses so it didn't matter.

## Quickstart for the next person

```bash
cd "Schematics/RejsaCAN v3.x (ESP32-S3 based board)/converter"
python convert.py "../RejsaCAN v3.4 - Schematic.json" --summary
# writes ../RejsaCAN v3.4.sch and prints parts + top nets
```

Open the resulting `.sch` in Fusion Electronics 9.x. Run ERC. Approve
the by-design single-pin warnings. Edit freely.

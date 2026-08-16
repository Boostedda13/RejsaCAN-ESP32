# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A fork of MagnusThome/RejsaCAN-ESP32: an open-source ESP32/ESP32-S3/ESP32-C6 board with an onboard CAN
interface, powered directly from a car (5–24 V) with auto-shutdown so it doesn't drain the battery.

This is **primarily a hardware repository**, not a software project. Most of it is EDA design data,
manufacturing output, and 3D-print STLs. The firmware here is a set of standalone examples — there is no
application to build, no test suite, and no linter. Do not go looking for them.

## Design-source model (read this before touching any EDA file)

Understanding what is *source* versus what is *output* is the single most important thing in this repo,
and it is not obvious from the directory listing.

For every board generation, upstream ships:

| File | Role |
|---|---|
| `* - Schematic.json` | **EasyEDA Standard source** — the only editable upstream design file |
| `* - Gerber.zip` | Manufacturing output only. Copper as polygons; no netlist, no footprints |
| `* - BOM.csv` | Output. Note: actually **UTF-16, tab-delimited** despite the `.csv` name |
| `* - Pinout.h` | Authoritative GPIO map for that board revision |
| `* - Schematic.png`, `* - Part placements.zip` | Documentation images |

**There is no PCB layout source anywhere in this repo for any board generation.** Editing a board means
either re-laying it out from the schematic netlist, or using the Gerbers as a visual reference (KiCad
GerbView → Export to PCB Editor gives graphics only — not a DRC-able, netlisted design).

`Pinout.h` is the source of truth for pin assignments, and pinouts differ substantially between
generations (e.g. v3.x `CAN_RX` = GPIO13; v6.x `CAN0_RX` = GPIO23). Always check which board a code
example targets before adapting it.

## Board generations

| Directory | Chip | Notes |
|---|---|---|
| `Schematics/RejsaCAN v2.x (ESP32 based board)` | ESP32 | CP2104 USB bridge |
| `Schematics/RejsaCAN v3.x (ESP32-S3 based board)` | ESP32-S3-WROOM-1 | native USB; latest is v3.4 |
| `Schematics/RejsaCAN v6.x (ESP32-C6 based dual CAN board)` | ESP32-C6 | **dual** CAN |

v3.x boards report their own revision at runtime: set GPIO4/GPIO5 to input-pullup and read them
(v3.1 = 4 low/5 high, v3.2 = 4 high/5 low). The root `README.md` documents the electrical changes
between revisions.

## Firmware examples — two different toolchains

`Code Examples/` mixes them, distinguishable only by file type:

- **Arduino IDE** (`.ino`) — the v2.x and v3.x examples. No CLI build; opened in the Arduino IDE.
  Each example folder may carry a PNG of the required IDE board settings.
- **ESP-IDF** (`CMakeLists.txt` + `main/`) — the two v6.x dual-CAN examples, target `esp32c6`:

```bash
cd "Code Examples/RejsaCAN v6.x - ESP32-C6 - dual CAN - Self tester"
idf.py set-target esp32c6      # only if sdkconfig is absent
idf.py build
idf.py -p COM4 flash monitor   # port is per-machine; .vscode/settings.json assumes COM4
```

The Self tester pulls `espressif/led_strip` via `main/idf_component.yml`. Both v6.x projects route the
console over USB-Serial-JTAG (`CONFIG_ESP_CONSOLE_USB_SERIAL_JTAG=y`), not UART.

`Tips to setup IDE and get started/README.md` lists the CAN/TWAI libraries that work with each chip
generation — consult it before picking a library, since ESP32 and ESP32-S3/C6 have different CAN APIs.

## Fork-specific additions

### EasyEDA → Eagle converter

`Schematics/RejsaCAN v3.x (ESP32-S3 based board)/converter/` — a hand-built parser/emitter that turns the
EasyEDA Standard JSON into a Fusion/Eagle 9.x `.sch`, because Fusion has no EasyEDA importer.

```bash
cd "Schematics/RejsaCAN v3.x (ESP32-S3 based board)/converter"
python convert.py "../RejsaCAN v3.4 - Schematic.json" -o "../RejsaCAN v3.4.sch" --summary
```

Its `README.md` is unusually thorough — it documents the reverse-engineered EasyEDA Standard JSON format
(tilde/caret/hash encoding, 10-mil units, Y-down) and the netlist bugs that were hit and fixed. Read it
before modifying `easyeda_parser.py` or `eagle_emitter.py`.

**This converter is only needed for the Fusion/Eagle route.** KiCad 8+ has a native EasyEDA (JLCEDA)
Standard importer, so do not route through Eagle to reach KiCad — the converter emits placeholder symbol
art and no package mappings.

### KiCad project

`Schematics/RejsaCAN v3.x (ESP32-S3 based board)/KiCad/` holds a native KiCad 10 project derived from the
EasyEDA JSON, with footprints assigned and a PCB generated from the netlist. The board is
**31.496 × 49.530 mm** with a 18.034 × 5.969 mm notch between the top tabs, and carries four 2.59 mm NPTH
mounting holes — outline and holes both traced from the fabricated board's `Gerber.zip`/`DRL`, not drawn
by hand. Component placement reproduces the fabricated board (recovered by matching footprints against
the pad cloud in the mask-layer Gerbers); `SD-CARD1` and `JUMPER1` are on the bottom side, as on the real
board. The board is **not routed**: no tracks, no vias, no copper zones. Routing is the remaining work.

Design rules live in `.kicad_pro` (constraints + net classes) and `.kicad_dru` (two custom rules). They
target JLCPCB's economical 2-layer tier; net classes `Battery`/`Power`/`GND`/`CAN`/`USB` carry the
automotive intent. One thing to fix before ordering: the stock `ESP32-S3-WROOM-1` footprint's 12 thermal
vias drill at 0.2 mm, below the 0.3 mm that keeps the board in JLCPCB's cheapest process.

Things to know before editing it:

- The EasyEDA importer is **read-only**. It loads the `.json` but `Ctrl+S` fails with "File format is not
  supported"; a native `.kicad_sch` only exists because the project was re-saved via the project
  manager's *Save As*.
- Annotation: KiCad treats letter-only designators as unannotated, so the EasyEDA names gained numbers
  (`BLUE`→`BLUE1`, `CAN`→`CAN1`, `PROG`→`PROG1`, …). These now differ from the silkscreen on the
  fabricated v3.4 board.
- `RejsaCAN.pretty/` is a project-local footprint library registered via `fp-lib-table`. It exists because
  five parts have no usable stock equivalent:
  - `microSD_ATOM_MR01A-01211` — LCSC C479742; no stock KiCad match
  - `L_Sunltec_SLP6028S_6.0x6.0mm` — stock `L_6.3x6.3_H3` has pads 0.5 mm too far apart
  - `SW_Push_GSwitch_GT-TC029B` — stock KMR2 has 4 pads; the real part has 2
  - `USB_C_Receptacle_GT-USB-7010ASV_MergedPins` — the imported symbol merges pins the EasyEDA way
    (`A1B12`, `A4B9`, …), so stock pad names don't map
  - `MountingHole_2.59mm_NPTH` — the fabricated hole size; stock offers 2.5 mm and 2.7 mm, neither exact
- The four mounting holes (`H1`–`H4`) carry the `board_only` attribute, i.e. KiCad's "not in schematic".
  That is what stops *Update PCB from Schematic* deleting them for having no matching symbol — don't
  clear it, and don't "fix" them by adding symbols.
- Board setup's min-hole rule (0.3 mm) is stricter than the board that was actually fabricated, which used
  0.254 mm drills. DRC therefore reports ~12 `drill_out_of_range` errors against the stock
  ESP32-S3-WROOM-1 footprint's 0.2 mm thermal vias. These are a rules-vs-reality mismatch, not defects.
- Schematic and PCB must be saved together. Annotating in the schematic editor writes designators into
  the `.kicad_pcb` on *Update PCB from Schematic*, but leaves the `.kicad_sch` dirty in memory — save both
  or the two files disagree.

Validate a schematic edit without opening the GUI (this parses the file and fails loudly if malformed):

```bash
kicad-cli sch export bom --fields "Reference,Value,Footprint" -o out.csv "…/RejsaCAN v3.4 - Schematic.kicad_sch"
```

Useful technique when a footprint's real land pattern is needed: LCSC datasheet links are bot-walled, but
the geometry can be recovered from JLCEDA Pro by placing the vendor part and exporting **IPC-D-356A**
(pad coordinates, in 0.0001 inch) plus the **NPTH drill file** (mounting posts). Converting those to
KiCad coordinates is X-preserved, Y-negated — verify the transform against a known part such as a SOIC-8
before trusting it.

## Gotchas

- **Every path contains spaces and parentheses.** Quote paths in shell commands; be careful with tools
  that treat `(` specially.
- `Symbol/rejsacan.kicad_sym` is a KiCad symbol for the ESP32-S3-CAN module, intended for reuse in other
  people's projects — it is not part of the board design itself.
- `.gitignore` (fork-added) excludes KiCad local history, which contains its own nested git repo and will
  otherwise confuse `git add`.

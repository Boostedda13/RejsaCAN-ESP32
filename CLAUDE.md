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
EasyEDA JSON. It originally reproduced the fabricated v3.4 board: **31.496 × 49.530 mm**, 2 layers, fully
routed (555 tracks, 116 vias, GND pours both sides), outline and the four 2.59 mm NPTH holes traced from
the fabricated `Gerber.zip`/`DRL`, placement recovered by matching footprints against the pad cloud in
the mask-layer Gerbers. `SD-CARD1` and `JUMPER1` are on the bottom side, as on the real board.

**That state is now history — see branch `v3.5-microfit-switchable-termination`.** The board there is
**58.1 × 49.63 mm, 4 copper layers** (In1 `GND_plane`, In2 `PWR_plane`), all routing stripped, and
**not re-routed**. What changed:

- `POWER1` + `CAN1` → **`J1`**, a Molex Micro-Fit 3.0 `43045-0400` 2×2 right-angle carrying 12 V / GND /
  CAN_H / CAN_L. Its pins 1–2 land on the pre-existing 12 V and GND wires, so the D6/F1 protection chain
  is untouched.
- `TERMINATION1`'s cuttable link → **`U6`**, a photorelay in the CAN_H leg, gated by `TERM_EN` on GPIO16
  with `R21` 10 k pulling it off at reset. `CAN_H → U6 → TERM_SW → R2 120R → CAN_L`.
- **`U7` LG290P03** quad-band RTK GNSS, plus `J2` u.FL and the Quectel Fig. 17 bias tee
  (`R23` 10R, `L2` 68 nH, `C29`/`C31`, `C30` DC block, `D13` TVS). UART on GPIO43/44, 1PPS→GPIO6,
  RESET→GPIO7, RTK_STAT→`GPS1` LED and GPIO15.
- `U4` **LMR14006 → LMR14010A** and `L1` 10 → 15 µH. Peak load with the GNSS is 748 mA against the old
  600 mA part. It also fixes a latent bug: LMR14006**X** switches at 2.1 MHz with a 95 ns min on-time,
  so it can only hold 3.3 V up to **Vin ≈ 16.5 V** on a board rated 5–24 V.

Design rules live in `.kicad_pro` (constraints + net classes) and `.kicad_dru` (three custom rules).
They hold JLCPCB's economical tier — min trace 5.9 mil, min drill 0.3 mm, both confirmed against a live
quote. Net classes `Battery`/`Power`/`GND`/`CAN`/`USB`/`Battery_Sense` carry the automotive intent.
**`Battery` spacing is 0.35 mm and that is correct — do not "fix" it to 0.6 mm.** This file used to say
IPC-2221 wants 0.6 mm at 31–50 V and to raise it on the 4-layer respin. That was a misreading, and it
cost two routing attempts before it was caught. Table 6-1 is indexed by **coating**, not by layer:

| Column | Case | 31–50 V | 51–100 V |
|---|---|---|---|
| B1 | internal conductors | 0.10 mm | 0.10 mm |
| B2 | external, **uncoated** | 0.60 mm | 0.60 mm |
| B4 | external, **permanent polymer coating** | **0.13 mm** | **0.13 mm** |
| A6 | external, uncoated **terminations** (bare pads) | 0.40 mm | **0.50 mm** |

Every track here is under solder mask → **B4 → 0.13 mm**, so 0.35 mm already has 2.7× margin. 0.6 mm is
column B2 and does not apply. It was tried on 4 layers too and made the power corner unroutable for no
electrical gain. The real exposure is **bare pads (A6)**, where condensation bridges — that is what the
`.kicad_dru` A6 rule now checks, and it is a component-choice problem (0402 land patterns cannot give
0.5 mm), not a routing one.

Design band: the board is offered as 5–24 V, so ISO 16750-2 (34 V regulator failure, ~58 V suppressed
load dump) puts it in the 51–100 V row. B4 is still 0.13 mm there.

`Net-(D6-K)` and `Net-(D6-A)` are now in `Battery`. They had **no netclass pattern at all** and routed
at Default 0.2 mm while carrying 100 % of the input current — good for ~0.74 A behind a fuse that holds
at 1.1 A and trips at 2.2 A. The trace was the fuse. Check any new net gets a pattern.

**Keep-outs are not interchangeable.** `U1`'s rule area is a *radiating PCB antenna* and must be on all
four copper layers — going 2→4 layers without extending it let the new In1 plane flood 97 mm² about
0.21 mm under the antenna, which detunes it and which DRC cannot see. `J2`'s rule area is a *connector
body* and must stay F.Cu only — extending it inward deletes the ground reference under the u.FL, which
is the opposite of what an RF jack wants. Whenever the layer count changes, re-check every rule area's
layer set against what it is actually protecting.

**Ground stitching is unsolved and should be done in the GUI.** The board has one GND via; the audit
measured the RF coplanar ground 8.94 mm from any plane crossing and U7's 59 ground pads 11–17 mm.
Scripted attempts all failed: a 3.0 mm grid of 0.6 mm vias hit the RF target (2.29 mm) but added 31
errors and cut F.Cu from 4 pour islands to 9; targeted fences and a hole-aware 3.5 mm grid were pruned
to nothing because the candidate sites sit in pour voids. Place these interactively where the fill is
visible rather than scripting them.

Two open problems on that branch before it can be routed:

- **`U1` ↔ `U7` courtyards overlap 4.04 × 18.51 mm.** That is the ESP32-S3-WROOM-1 antenna keep-out
  intersecting the GNSS module; the board is not wide enough to clear it and still fit the u.FL. WiFi at
  2.4 GHz beside an RTK receiver at 1.5 GHz needs a real decision, not a nudge.
- **Quectel forbids feeding this module from a switching converter** (wants < 50 mV ripple) and the only
  rail here is the buck. `FB1` is a ferrite pi filter — a compromise, not compliance. An LDO is correct.

Things to know before editing it:

- The EasyEDA importer is **read-only**. It loads the `.json` but `Ctrl+S` fails with "File format is not
  supported"; a native `.kicad_sch` only exists because the project was re-saved via the project
  manager's *Save As*.
- Annotation: KiCad treats letter-only designators as unannotated, so the EasyEDA names gained numbers
  (`BLUE`→`BLUE1`, `CAN`→`CAN1`, `PROG`→`PROG1`, …). These now differ from the silkscreen on the
  fabricated v3.4 board.
- `RejsaCAN.pretty/` is a project-local footprint library registered via `fp-lib-table`. Eight parts live
  there — five with no usable stock equivalent, three corrected to the land pattern actually fabricated
  (measured from the Gerbers' top-copper flashes, not trusted from the library):
  - `Fuse_1812_RejsaCAN_3.706mm` — stock 1812 land is 4.276 mm pad-to-pad; the real one is 3.706 mm
  - `SOIC-8_RejsaCAN_5.544mm` — real rows span 5.544 mm with 2.045 × 0.588 pads, not 4.95 / 1.95 × 0.60
  - `ESP32-S3-WROOM-1_RejsaCAN` — thermal vias drilled out 0.2 → 0.3 mm to hold the economical tier
  - `microSD_ATOM_MR01A-01211` — LCSC C479742; no stock KiCad match
  - `L_Sunltec_SLP6028S_6.0x6.0mm` — stock `L_6.3x6.3_H3` has pads 0.5 mm too far apart
  - `SW_Push_GSwitch_GT-TC029B` — stock KMR2 has 4 pads; the real part has 2
  - `USB_C_Receptacle_GT-USB-7010ASV_MergedPins` — the imported symbol merges pins the EasyEDA way
    (`A1B12`, `A4B9`, …), so stock pad names don't map
  - `MountingHole_2.59mm_NPTH` — the fabricated hole size; stock offers 2.5 mm and 2.7 mm, neither exact
- The four mounting holes (`H1`–`H4`) carry the `board_only` attribute, i.e. KiCad's "not in schematic".
  That is what stops *Update PCB from Schematic* deleting them for having no matching symbol — don't
  clear it, and don't "fix" them by adding symbols.
- Anything corrected against fabricated geometry lives in `RejsaCAN.pretty` on purpose, so a stock library
  update cannot silently undo it. Keep the schematic's Footprint field pointing there too.
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

### Scripting the board

`"C:\Program Files\KiCad\10.0\bin\python.exe"` — KiCad's bundled interpreter, the only one with `pcbnew`.
Also has numpy and PIL; **no scipy**.

`kicad-cli pcb drc --format json -o out.json "…kicad_pcb"` — run after *every* save. The Python API
exposes no DRC engine and no PNS router, so any hand-rolled geometry check is an approximation; this is
the only real judge. Twelve shorts and twelve co-located holes reached a saved board before this became
the habit.

Use the real APIs instead of inferring geometry: `GetConnectedItems` for "is this pad actually joined",
`FillIsolatedIslandsMap` for pour islands, `GetDesignSettings()` for clearances.

KiCad 10 landmines: `GetPos0` → `GetFPRelativePosition`; `ISLAND_REMOVAL_MODE_REMOVE` → `..._ALWAYS`; and
**`PCB_VIA.GetWidth()` with no layer argument opens a native assert dialog that hangs an unattended run**
— always pass a layer, and guard `GetTracks()` loops with `isinstance(t, pcbnew.PCB_VIA)`.

### Routing and ordering

Freerouting 2.3.0, driven headless — these three flags are not optional:

```bash
--gui.enabled=false                  # the ConductionArea NPE on boards with pours is in the PAINT path
--router.optimizer.enabled=false     # no best-seen board; the optimizer overwrites a better result
--router.layers.preferred_direction_horizontal=true,false   # top horizontal / bottom vertical
```

`router.via_costs` is not a settings field (via costs live in the DSN's `(autoroute_settings …)` block).
Do not re-run the router on an already-routed DSN to "finish" it — KiCad tags wires `(type route)`, which
Freerouting reads as rip-uppable, and it destroys the routing. Freerouting also knows nothing of
`.kicad_dru` custom rules; only net-class width and clearance survive the DSN export.

JLCEDA Pro: import needs schematic **and** PCB zipped together, and the import **drops the netlist**
(`Nets (1) → None`), so Pro's DRC is meaningless on it — KiCad stays the source of truth.

JLCPCB quote gotcha: the board's via-in-pad thermal vias make Pro pre-select *Via Covering = Epoxy Filled
& Capped* (+$49.64, and it forces a +$3.30 plating method). Setting **Tented** + **Not Specified** gives
$2.00 for 5 pcs. Keep Delivery Format on **Single PCB**; "Panel by Customer" forfeits the promo tier and
adds a $4.00 engineering fee.

**There is a 50 × 50 mm tier boundary for 4-layer**, and it is worth real money: 4-layer ≤ 50 × 50 mm is
**$2.00/5 pcs — the same as 2-layer** — while ≤ 100 × 100 mm jumps to **$7.00**. The v3.5 board is
58.1 mm wide and so sits in the $7.00 tier. That is a $5 delta against a ~$400 module order, so do not
shrink the layout to chase it; noted only so the boundary is not a surprise.

Shipping dominates and the older figures in this file were wrong: **the $3.12 Global Standard Direct Line
option is no longer available to US individual customers** — they must ship DDP, which exists only on
DHL/FedEx/UPS express, quoting **~$28.57** at 0.17 kg. A **55 % tariff** is also pre-collected on FR-4
PCBs (from 17 March 2026, non-refundable, no de-minimis relief). Landed total lands near $32–40 either
way, so shipping is ~72 % of the cost and the layer count barely registers.

Sourcing landmine: **the Quectel LG290P03AAMD is not carried by LCSC at all.** DigiKey has it at ~$71–81
each in small quantities against 35 pieces of stock and a **14-week factory lead time**, which makes the
module ~95 % of the BOM and the real supply risk. Prove the design on one before buying five.

## Gotchas

- **Every path contains spaces and parentheses.** Quote paths in shell commands; be careful with tools
  that treat `(` specially.
- `Symbol/rejsacan.kicad_sym` is a KiCad symbol for the ESP32-S3-CAN module, intended for reuse in other
  people's projects — it is not part of the board design itself.
- `.gitignore` (fork-added) excludes KiCad local history, which contains its own nested git repo and will
  otherwise confuse `git add`.

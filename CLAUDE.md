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

**That state is now history — `main` carries the v3.5 board** (branch `v3.5-microfit-switchable-termination`
was merged; the project file names still say v3.4). The board is **L-shaped**: a main body plus a
bottom-right bump-out for the GNSS, 63.1 × 49.63 mm bounding but only 2970 mm² of copper, with a notch
in the top edge under the WROOM antenna (the two "ears" carry `H1`/`H2`). **4 copper layers** (In1
`GND_plane` held solid as the RF reference, In2 `PWR_plane`). **It is finished**: 0 unconnected, DRC
**0 errors** (`kicad-cli`, all severities), ~1030 tracks, 187 vias of which 98 are GND stitching, GND
poured on three layers. The remaining DRC output is warnings only: ~150 silkscreen (refdes text in the
dense power corner), 3 silk-edge (the module outline on the notch edge), and 23 courtyard-class items
that are **as-fabricated v3.4 geometry** — every one of them is also reported on the recovered v3.4
layout (which has 43), so those three checks were set to *warning* in the `.kicad_pro`, in the same
spirit as the `.kicad_dru` "as-fabricated" rules. Fabrication output for it lives in `KiCad/fabrication/`
(`RejsaCAN_v3.5_gerbers.zip`, renders, STEP; regenerable, gitignored). What changed against v3.4:

- `POWER1` + `CAN1` → **`J1`**, a Molex Micro-Fit 3.0 `43045-0400` 2×2 right-angle carrying 12 V / GND /
  CAN_H / CAN_L. Its pins 1–2 land on the pre-existing 12 V and GND wires, so the D6/F1 protection chain
  is untouched.
- `TERMINATION1`'s cuttable link → **`U6`**, a photorelay in the CAN_H leg, gated by `TERM_EN` on GPIO16
  with `R21` 10 k pulling it off at reset. `CAN_H → U6 → TERM_SW → R2 120R → CAN_L`.
- **`U7` LG290P03** quad-band RTK GNSS, plus `J2` u.FL and the Quectel Fig. 17 bias tee
  (`R23` 10R, `L2` 68 nH, `C29`/`C31`, `C30` DC block, `D13` TVS). UART on GPIO43/44, 1PPS→GPIO6,
  RESET→GPIO7, RTK_STAT→`GPS1` LED and GPIO15.
- **`U8` AP2112K-3.3 LDO** feeding `GNSS_VCC`. Quectel forbids a switching supply on this module, and a
  ferrite was only a compromise. It needs headroom to regulate, so `R9`/`R10` lift 3V3 to ~3.43 V — a
  3.3 V LDO fed from 3.29 V sits in dropout, where PSRR collapses and it filters nothing.
- **`J3`**, a JST-XH 4-pin carrying raw 12 V / GND / USB_D- / USB_D+ to an LTE module. Deliberately a
  different connector family from `J1`: two identical 4-circuit Micro-Fits invite plugging the CAN
  harness into the USB port, which would put 12 V and CAN_H onto `USB_D±` and GPIO19/20.
- **The whole front end was re-rated** — see below. `U4` is now an **LMR51610X** (65 V), not the
  LMR14010A this file used to name.
- **`SPI1` (MTDO/MTCK/MTDI) moved out from under the WROOM** to a second header column beside `GPIO1`
  (X 142.5). The recovered v3.4 placement had dropped it onto three of upstream's *rear-access* pads
  under the module; upstream's README says those pads carry GPIO6/7/15/16, MTMS, PROG, JTAG_ENABLE,
  TXD0, RXD0 (PCB-only pads, no symbols, so they never entered this netlist) and that MISO/CLK/MOSI sit
  in the header row. A header nobody can populate was a defect. Also: `D7` is rotated 180° (cathode
  toward the D6-K via), `C27`/`C32` sit rotated below U7's edge instead of physically under it, and
  U7's courtyard is the real 12.2 × 16 mm module (+0.25), not the 18 × 22 mm box it had.

**Front end: rated 5–24 V, 33 V DC ceiling.** The chain is forced by one number — a 12 V-system
*suppressed* load dump is 35 V for 40–400 ms, so the clamp must not conduct at 35 V → 33 V standoff →
clamps at 53.3 V (56 V hot) → the regulator must survive ~56 V. Every part follows from that:

```
J1.1 ┬─ D4  SMAJ33CA   bidirectional clamp, at the raw node
     ├─ F3  1206TD-4A  4 A/72 V, fuses the J3 branch (was unfused raw battery)
     └─ D6  SS110      100 V Schottky ┬─ F1 1206TD-2A ─ VCC ─ U4 LMR51610X
                          └─ D7 SS110 (USB 5 V)
```

Three traps recorded so they are not re-hit:

- **`R9`/`R10` are not optional when swapping `U4`.** LMR51610X's reference is **0.800 V**, not the
  LMR14010A's 0.765 V. Leaving the divider alone yields **3.58 V** against the ESP32-S3's **3.6 V
  absolute maximum**.
- **A P-FET is the wrong reverse-block here** even though it beats a Schottky on headroom: its gate sits
  at ground, so USB with no battery turns it on and back-feeds 5 V onto `J1` and `J3`. `D6` exists to
  stop exactly that.
- **5–36 V was investigated and declined.** It implies 24 V-system service, whose suppressed load dump is
  58 V — unsurvivable below a 58 V standoff, and a 60 V part clamps near 97 V needing a 100 V regulator.
  The only 100 V candidate will not start below 6 V.

The rating is **conditional on the installation**: fused accessory circuit, downstream of the vehicle's
own suppression, never upstream of a battery kill switch. An *unsuppressed* load dump is 79–101 V and
20–52 J; no discrete TVS closes that, only an LTC4364 and ~150 mm² this board does not have. That
sentence is in the README and the design depends on it.

Design rules live in `.kicad_pro` (constraints + net classes) and `.kicad_dru` (five custom rules).
They hold JLCPCB's economical tier — min trace 5.9 mil, min drill 0.3 mm, both confirmed against a live
quote. Net classes `Battery`/`Battery_Out`/`Power`/`GND`/`CAN`/`USB`/`Battery_Sense`/`RF` carry the intent.
`Battery_Out` is `VBAT_IN` at 0.8 mm — split out from `Battery` because it feeds the LTE module and
lives in the roomy bump-out, so it can be wide without congesting the `VCC` corner.
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

**Ground stitching is done** — 98 vias (0.6/0.3): a fence both sides of the RF trace (within ~1 mm),
a ring around U7's ground pads, and a 4 mm grid — placed by `KiCad/tools/stitch.py` with zero DRC
fallout. The earlier scripted attempts failed because their candidate sites were tested against a
hand-rolled clearance model; this one reuses the router's obstacle mask (every non-GND item inflated by
via radius + the larger of the two net-class clearances, plus hole-to-hole and the edge band) and
requires each site to be inside an outer-layer pour. Add all, let DRC prune, iterate — none needed
pruning. If more are wanted, run it again with a smaller `--grid`; it skips sites too close to
existing vias.

Both of the problems this file used to list as blocking are now closed: the **bump-out** moved the GNSS
clear of the WROOM antenna keep-out (and to the *bottom* right on purpose — the WROOM's antenna is at the
top edge, so going low roughly doubles the separation for free), and **`U8`** replaced the ferrite
compromise with a real LDO.

**The power corner is a placement problem, not a routing one.** 12 parts sat in 108 mm² of inherited
2-layer-era layout, with 21–35 non-GND items within 3 mm of the stranded pads; 146 candidate via sites
were tested and *none* were clean. The fix was to move the **low-speed** circuits out — battery-sense
divider and auto-shutdown chain — while `U4`/`L1`/`D5` stayed put, because they are the switching loop
and lengthening the SW node is a regression. Split by circuit type, not geography. The router then
finished in **131 s against 310–660 s** on every previous attempt.

**The last four connections were closed by script after all** — `KiCad/tools/miniroute.py`, an
obstacle-aware grid router (per-layer clearance-inflated raster, Dijkstra over F/In2/B with via
transitions, DRC as the gate; see `tools/README.md`). What made it work where hand-placed copper had
not: the mask uses the *real* geometry (`GetEffectivePolygon`, both nets' class clearances, holes, edge
band, keep-outs) with an extra cell of margin, and every route was accepted only when `kicad-cli` DRC
did not rise. Two of the four still needed *placement* changes first, because U4.5 and D7.1 were sealed
on every layer: `D7` was rotated 180° so its cathode faces the free F.Cu toward the existing D6-K via,
and for `VCC → U4.5` the EN (`Net-(D2-K)`) and `FORCE_ON` spaghetti plus the 3V3 F.Cu feed from `L1.2`
were stripped, the power routed first (VCC F.Cu-only from the pad to `C13.2` — 0.4 mm through the
0.6 mm gap between pads 4 and 6, which is exactly 0.35 mm from each; `L1.2 → C8.2` relinked via In2),
then EN and FORCE_ON re-routed around them in six passes. Order matters: power first, signals after.

Two placement fixes were needed for reasons DRC alone would not have shown: `C27`/`C32` were 0.15 mm
*under* U7's body edge (courtyard said 18 × 22 mm for a 12.2 × 16 mm module, so nothing complained),
and `SPI1` was under the WROOM (see above).

Things to know before editing it:

- `KiCad/tools/` holds the three scripts that finished the board (`miniroute.py`, `stitch.py`,
  `drcgate.py`) with their own README; `KiCad/fabrication/README.md` has the exact `kicad-cli` lines
  for the 4-layer Gerber set, renders and STEP.
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

**Make DRC the acceptance test for every change, not a check afterwards.** Propose a position or a piece
of copper, commit it, ask `kicad-cli`, keep it only if the error count did not rise — otherwise roll back
and try the next candidate. Hand-rolled geometry has failed here five distinct ways, every one caught by
DRC and none by reasoning: straight-line routes that ignored obstacles; a search whose *baseline already
contained the defect*, so "no worse" preserved a short; a strict "no violations mentioning this part"
test that passed a footprint placed **entirely off-board** (it touched nothing); a blanket keep-out fix
applied to two rule areas that looked alike but were not; and reading one row of a free-space map as if
the rows below it were clear.

Two useful shapes for that loop: for **placement**, search outward from the part's *electrical* target
(an earlier version minimised distance from where the part already sat and put the buck's input cap 54 mm
away — valid, useless). Courtyard-vs-courtyard rectangle overlap *is* exact and fast, unlike a bbox test
on traces. For **many small items** such as stitching vias, add them all and let DRC name the ones to
drop, iterating to a fixed point — far cheaper than one DRC run per candidate.

**SWIG ownership poisoning.** The first `Remove()`/`Delete()` breaks the type registry for the rest of the
process: later `GetFootprints()`, `GetArea()`, even `FindFootprintByReference()` on a freshly
`LoadBoard()`ed board hand back bare `SwigPyObject`s. Save-and-reload does **not** clear it. Bind every
proxy you need *before* the first removal, and run each destructive phase as its own process. `Remove()`
also fails on `ZONE` where `Delete()` works — delete zones before touching tracks.

**There is no headless "Update PCB from Schematic".** Neither `kicad-cli` nor `pcbnew` exposes one, so
push the netlist in pad by pad: build a `(ref, padnumber) → netname` map from
`kicad-cli sch export netlist`, then `pad.SetNet(NETINFO_ITEM(board, name))`. Pads with an empty pad
number (thermal slugs, connector pegs, USB shells) legitimately have no schematic net — count them, do
not clear them.

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

**Rewriting those wires to `(type protect)` does not rescue that idea** — tried twice. The first time it
came back with 26 unrouted having *broken* nets that were already fine, including the hand-routed
antenna and both USB-C CC pairs. The second time (2.3.0, everything protected except the four open
nets, fanout off) it loaded the board as **79 unrouted / 20 violations** and stalled there for
13 passes: Freerouting does not treat protected wires as connecting their pins. Re-route from a
stripped board, or use `KiCad/tools/miniroute.py` for the last few connections. Three more 2.3.0
facts from that attempt: an injected `(autoroute_settings …)` block — with or without `layer_rule`s —
**breaks the DSN parse** ("board has no SMD pins", 2 unrouted, 0-byte SES), so via costs cannot be
set that way; `--router.fanout.enabled=false` is a real setting and matters, because with fanout on
the router adds stubs and vias to every SMD pin it thinks is unconnected; and it auto-detects a
`GND_plane` layer as a power plane from the pour, so the `(type power)` edit is belt-and-braces.

**Hold the inner ground layer as a plane by editing the DSN.** KiCad exports every copper layer as
`(type signal)`, so the router will happily lay 560 mm of traces across In1 — the reference the RF trace
depends on. Change that one layer to `(type power)` after export:

```bash
# in the exported .dsn, for the GND_plane layer only
(layer GND_plane
  (type power)      # was: (type signal)
```

Freerouting accepts it, routes the other three layers, and In1 comes back with **zero** tracks. It costs
about one extra unrouted connection and is worth it.

**Do not autoroute the antenna.** Left alone, Freerouting took `GNSS_ANT` through two vias onto B.Cu and
necked `GNSS_RF_IN` to 0.225 mm against its 0.30 mm class — both change the impedance. Strip those nets
after import and hand-route: ~8 mm total, F.Cu only, constant 0.30 mm, zero vias. 0.30 mm is right for
grounded CPW at a 0.25 mm pour gap on JLCPCB's 4-layer 1.6 mm stackup (~50.9 Ω); keep the gap uniform,
and do not "fix" the F.Cu zone's 0.25 mm local clearance down to the RF class's 0.20 mm.

**Loaded taps on an RF line want to be under 1 mm.** The bias choke and ESD diode originally branched off
the u.FL pad 3.6 and 3.9 mm away, which cost **0.49 dB at L1** — not because the stubs radiate but because
the line *transforms* their loads: 3.9 mm nearly doubles the TVS's effective capacitance and 3.6 mm flips
the inductor from inductive to capacitive, so instead of partly cancelling they add. Tapping the
through-line at ~1 mm brings it to 0.09 dB.

JLCEDA Pro: import needs schematic **and** PCB zipped together, and the import **drops the netlist**
(`Nets (1) → None`), so Pro's DRC is meaningless on it — KiCad stays the source of truth.

JLCPCB quote gotcha: the board's via-in-pad thermal vias make Pro pre-select *Via Covering = Epoxy Filled
& Capped* (+$49.64, and it forces a +$3.30 plating method). Setting **Tented** + **Not Specified** gives
$2.00 for 5 pcs. Keep Delivery Format on **Single PCB**; "Panel by Customer" forfeits the promo tier and
adds a $4.00 engineering fee.

**There is a 50 × 50 mm tier boundary for 4-layer**, and it is worth real money: 4-layer ≤ 50 × 50 mm is
**$2.00/5 pcs — the same as 2-layer** — while ≤ 100 × 100 mm jumps to **$7.00**. The v3.5 board is
63.1 mm wide and so sits in the $7.00 tier. That is a $5 delta against a ~$400 module order, so do not
shrink the layout to chase it; noted only so the boundary is not a surprise.

**Quote for the finished board (18 Aug 2026, cart.jlcpcb.com, parameters entered by hand: 4 layers,
63.1 × 49.63 mm, 5 pcs, 1.6 mm FR4 TG135, HASL, green, 1 oz/0.5 oz, single PCB, "Plugged" via cover
at $0.00): PCB $7.00, DHL Express DDP $28.57 (0.18 kg, 2–4 days) → $35.57 before the tariff line
below.** Typing into the dimension fields on that page *appends* to the default "10" (→ "1063.1", a
$97 quote with a $25 engineering fee); set the field value directly or select-all first.

**Assembly estimate (18 Aug 2026, from JLCPCB's published fee structure + LCSC prices, not a live PCBA
quote — the quote page's assembly panel needs a BOM/CPL upload and login):** JLC fees are setup ~$8
(Economic) or +$25/+$50 (Standard, one/two-sided), stencil $1.50, $0.0017 per SMT joint, $1.50 per
*extended* part type (was $3 before Dec 2025), THT $0.0135/pin + $3.50. This board: 81 top parts /
308 SMT joints (D5, R19 DNP), 2 bottom parts (SD-CARD1, JUMPER1), 23 THT pins (J1, J3, USB-C shell,
headers), ~22 extended part types → **~$45 (Economic, top SMT only) or ~$95 (Standard, both sides +
THT) for 5 boards**. LCSC parts ≈ **$12/board** excluding the GNSS module (ESP32-S3-WROOM-1-N16R8
$5.16, SN65HVD230 $0.77, LMR51610X $0.68 C20539658, AQY212GS $1.18 C719745, tantalum $0.53, Micro-Fit
$0.45 C122413, the rest pennies). **The LG290P03 dominates: ~$71–81 each at DigiKey**, not at LCSC —
either consign it or use JLC Global Sourcing (modules can carry 3–30 % duty). All-in for 5 assembled
boards ≈ $490–590 + shipping/tariff → **~$100–120 per board, of which ~$75–85 is the GNSS module.**

**The BOM is JLC-ready as of 18 Aug 2026**: every schematic symbol carries `Manufacturer Part`,
`Manufacturer` and `Supplier Part` (LCSC C-number) verified against stock that day, and
`fabrication/bom.csv` exports them. Before that, most of those fields were stale copies from cloned
symbols (D13 said a Samsung capacitor, F1/F3 the old 1812 PTC, U4 LMR14006, J2 a pin header) — a
BOM upload would have matched wrong parts, silently. Substitutions made because the specified part
was unstocked, with the land pattern compared numerically via EasyEDA's footprint API
(`https://easyeda.com/api/products/<Cnnn>/components?version=6.4.19.5`, reachable from the in-app
browser, 403 from curl): SD-CARD1 → **SOFNG TF-015 (C113206)**, same TF-015-family land within
0.1 mm including the two Ø1.0 pegs (XYECONN/SHOU HAN clones put the pegs 0.35 mm further out and would
not seat); L1 → **SLP6028S100MTT 10 µH (C254862)** — no 15 µH with adequate Isat exists in this land
at LCSC (SXN 15 µH saturates at 1.0 A; Sunlord's is delisted); L2 → **LQW15AN47NJ00D 47 nH
(C192855)** — the 68 nH LQW15AN is out of stock and the ferrite-core 68 nH parts have SRF 750–800 MHz,
i.e. capacitive at L1/L5; U8 → **RT9013-33GB (C47773)**, same SOT-23-5 pinout, AP2112K-3.3 has 5 pcs;
D6/D7 → **MBR1H100SFT3G (C235757)** because every "SS110F" at LCSC is SMAF, not SOD-123F; D13 →
**ESD9L5.0ST5G 0.5 pF (C82326)**, SOD-923 terminals sit inside the 0402 land; F1 **0466002.NRHF**
(C3105), F3 **1206T4A63V** (C354899); C6 **CL32B225KCJSNNE** (C55151); C13 **CL10B104KC8NNNC**
(C15725). Only U7 (LG290P03AAMD, DigiKey) and three E96 0402 resistors (69.8k/22.1k/390, MPN given,
let JLC match) lack C-numbers.

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

# tools/

Scripts that finished the v3.5 board without the GUI. They run under KiCad's own Python
(`"C:\Program Files\KiCad\10.0\bin\python.exe"`, the only interpreter with `pcbnew`) and operate on
`../RejsaCAN v3.4 - Schematic.kicad_pcb`. Scratch output goes to `tools/out/` (gitignored) or to
`$REJSA_OUT`.

| Script | What it does |
|---|---|
| `miniroute.py NET [--w 0.2] [--via 0.6/0.3] [--layers F,I2,B] [--window x0 y0 x1 y1] [--viacost 120] [--src REF.PAD --dst REF.PAD] [--apply]` | Obstacle-aware grid router for **one connection**: rasterises every copper item that is not on `NET` into per-layer masks inflated by `w/2 + max(clearance of both net classes) + 1 cell`, plus a via mask (all layers, hole-to-hole, edge band), then runs Dijkstra from the smallest island of the net to the largest over F/In2/B with via transitions. Without `--apply` it only writes `<tag>_path_<layer>.png` overlays. With `--apply` it adds the copper, snaps route ends to pad centres, refills zones and keeps a `.bak`. Run it repeatedly for a net with more than two islands. |
| `stitch.py [--grid 4.0] [--minsp 1.2] [--via 0.6/0.3] [--apply]` | GND stitching vias: a fence both sides of the RF trace, a ring around U7's ground pads, and a grid — every candidate filtered by the router's via mask and by outer-layer pour membership, then added all at once so DRC can prune. |
| `drcgate.py TAG [--show type1,type2]` | `kicad-cli pcb drc --severity-all --all-track-errors`, summarised as error/warning counts by type plus the unconnected list. **This is the acceptance test**: apply one change, run it, keep the change only if errors did not rise. |

The router is deliberately not a full autorouter: it knows nothing about the `.kicad_dru` custom
rules beyond net-class clearance, it does not shove, and it will happily route the last connection
through an ugly place if that is the only free one. It exists because the interactive router needs a
GUI session and Freerouting cannot be told to finish a nearly-complete board (see CLAUDE.md).

Things learned the hard way, all encoded above:

- `NETINFO_ITEM.GetNetClass()` returns a bare `SwigPyObject`; use `GetNetClassName()` and read the
  clearance table from the `.kicad_pro` JSON. Getting this wrong routed Battery-class copper at
  0.15 mm and produced 11 clearance errors.
- PIL rasterises to integer pixels, so a shape can end up half a cell short — hence the extra cell of
  inflation. Without it one route landed 0.01 mm inside a pad's clearance.
- A track hugging the board edge leaves a hair-thin GND pour strip outside it (`connection_width`
  0.0004 mm); the edge band keeps tracks ≥ 0.85 mm from the outline so the strip is a real pour or
  nothing.
- Route ends are snapped to pad centres. KiCad's connectivity is shape-based and accepts a track
  ending on a pad edge, but it looks like a mistake and is fragile.

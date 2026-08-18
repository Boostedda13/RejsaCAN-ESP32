"""GND stitching vias: RF fence + U7 ring + coarse grid. Candidates filtered by the router's via mask
and by outer-layer pour membership; then added all at once for DRC to prune.
usage: stitch.py [--apply] [--via 0.6/0.3] [--grid 3.5]
"""
import os as _os
_HERE = _os.path.dirname(_os.path.abspath(__file__))
BRD = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_pcb")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import pcbnew, sys, math, shutil, os
import numpy as np, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import miniroute as MR

mm = lambda v: v / 1e6
P = lambda x, y: pcbnew.VECTOR2I(pcbnew.FromMM(x), pcbnew.FromMM(y))
via_d, via_drill = [float(v) for v in MR.arg('--via', '0.6/0.3').split('/')]
GRID_PITCH = float(MR.arg('--grid', '3.5'))
MIN_SPACING = float(MR.arg('--minsp', '1.0'))

bd = pcbnew.LoadBoard(BRD)
bb = bd.GetBoardEdgesBoundingBox()
x0, y0, x1, y1 = mm(bb.GetLeft()) - 0.5, mm(bb.GetTop()) - 0.5, mm(bb.GetRight()) + 0.5, mm(bb.GetBottom()) + 0.5
grid = MR.Grid(x0, y0, x1, y1, 0.05)
# via mask for GND (w irrelevant); reuse build() but only need via_mask
trk_mask, via_mask, anchors = MR.build(bd, 'GND', 0.2, via_d, via_drill, [pcbnew.F_Cu], grid)
print('via mask built; free fraction %.2f' % (1 - via_mask.mean()))

# pour polygons on F/B
pours = {}
for z in bd.Zones():
    if z.GetIsRuleArea() or z.GetNetname() != 'GND':
        continue
    for L in (pcbnew.F_Cu, pcbnew.B_Cu):
        if z.IsOnLayer(L):
            pours[L] = z.GetFilledPolysList(L)
print('pours:', {bd.GetLayerName(L): p.OutlineCount() for L, p in pours.items()})

def in_pour(x, y):
    pt = P(x, y)
    return any(p.Contains(pt) for p in pours.values())

def free(x, y):
    ix, iy = int(round((x - grid.x0) / grid.step)), int(round((y - grid.y0) / grid.step))
    if not (0 <= ix < grid.W and 0 <= iy < grid.H):
        return False
    return not via_mask[iy, ix]

existing = [(mm(t.GetPosition().x), mm(t.GetPosition().y)) for t in bd.GetTracks() if isinstance(t, pcbnew.PCB_VIA)]
cands = []   # (priority, x, y, tag)

# (a) RF fence along GNSS_RF_IN / GNSS_ANT tracks on F.Cu
rf = [t for t in bd.GetTracks() if not isinstance(t, pcbnew.PCB_VIA) and t.GetNetname() in ('GNSS_RF_IN', 'GNSS_ANT') and t.GetLayer() == pcbnew.F_Cu]
print('RF segments:', len(rf))
for t in rf:
    s, e = t.GetStart(), t.GetEnd()
    sx, sy, ex, ey = mm(s.x), mm(s.y), mm(e.x), mm(e.y)
    L = math.hypot(ex - sx, ey - sy)
    if L < 0.3:
        continue
    ux, uy = (ex - sx) / L, (ey - sy) / L
    nx, ny = -uy, ux
    n = max(1, int(L / 1.0))
    for k in range(n + 1):
        t_ = (k + 0.5) / (n + 1)
        px, py = sx + ux * L * t_, sy + uy * L * t_
        for off in (0.9, -0.9, 1.1, -1.1):
            cands.append((0, px + nx * off, py + ny * off, 'rf'))
# (b) ring around U7 pads
u7 = bd.FindFootprintByReference('U7')
xs = []; ys = []
for p in u7.Pads():
    b = p.GetBoundingBox(); xs += [mm(b.GetLeft()), mm(b.GetRight())]; ys += [mm(b.GetTop()), mm(b.GetBottom())]
rx0, rx1, ry0, ry1 = min(xs) - 0.8, max(xs) + 0.8, min(ys) - 0.8, max(ys) + 0.8
per = 2 * (rx1 - rx0 + ry1 - ry0)
n = int(per / 1.4)
for k in range(n):
    d = k * per / n
    if d < rx1 - rx0: x, y = rx0 + d, ry0
    elif d < (rx1 - rx0) + (ry1 - ry0): x, y = rx1, ry0 + (d - (rx1 - rx0))
    elif d < 2 * (rx1 - rx0) + (ry1 - ry0): x, y = rx1 - (d - (rx1 - rx0) - (ry1 - ry0)), ry1
    else: x, y = rx0, ry1 - (d - 2 * (rx1 - rx0) - (ry1 - ry0))
    cands.append((1, x, y, 'u7ring'))
# (c) coarse grid, two phase offsets to fill gaps
for ox, oy in ((0, 0), (GRID_PITCH / 2, GRID_PITCH / 2)):
    gx = x0 + 1.0 + ox
    while gx < x1:
        gy = y0 + 1.0 + oy
        while gy < y1:
            cands.append((2, gx, gy, 'grid'))
            gy += GRID_PITCH
        gx += GRID_PITCH

# filter + greedy spacing
cands.sort(key=lambda c: c[0])
chosen = []
def far_enough(x, y, minsp):
    for (cx, cy) in existing + [(c[1], c[2]) for c in chosen]:
        if math.hypot(cx - x, cy - y) < minsp:
            return False
    return True
stats = {}
for pri, x, y, tag in cands:
    stats.setdefault(tag, [0, 0, 0, 0]); stats[tag][0] += 1
    if not free(x, y):
        stats[tag][1] += 1; continue
    if not in_pour(x, y):
        stats[tag][2] += 1; continue
    minsp = 0.8 if tag == 'rf' else MIN_SPACING
    if not far_enough(x, y, minsp):
        stats[tag][3] += 1; continue
    chosen.append((pri, x, y, tag))
print('candidates: tag -> [total, blocked, not-in-pour, too-close]:', stats)
print('chosen: %d  (%s)' % (len(chosen), {t: sum(1 for c in chosen if c[3] == t) for t in stats}))
if '--apply' not in sys.argv:
    sys.exit()
shutil.copy(BRD, os.path.join(SP, 'stitch.bak.kicad_pcb'))
gnd = bd.GetNetsByName()['GND']
for pri, x, y, tag in chosen:
    v = pcbnew.PCB_VIA(bd)
    v.SetPosition(P(x, y)); v.SetViaType(pcbnew.VIATYPE_THROUGH)
    v.SetWidth(pcbnew.FromMM(via_d)); v.SetDrill(pcbnew.FromMM(via_drill))
    v.SetLayerPair(pcbnew.F_Cu, pcbnew.B_Cu); v.SetNet(gnd)
    bd.Add(v)
pcbnew.SaveBoard(BRD, bd)
bd2 = pcbnew.LoadBoard(BRD)
pcbnew.ZONE_FILLER(bd2).Fill(bd2.Zones())
bd2.BuildConnectivity()
pcbnew.SaveBoard(BRD, bd2)
print('added %d vias; unconnected %d' % (len(chosen), bd2.GetConnectivity().GetUnconnectedCount(True)))
for z in bd2.Zones():
    if not z.GetIsRuleArea() and z.GetNetname() == 'GND':
        for L in (pcbnew.F_Cu, pcbnew.B_Cu, pcbnew.In1_Cu):
            if z.IsOnLayer(L):
                print('  pour %s outlines: %d' % (bd2.GetLayerName(L), z.GetFilledPolysList(L).OutlineCount()))

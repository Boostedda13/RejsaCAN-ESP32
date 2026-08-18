"""Obstacle-aware grid router for finishing single connections on the RejsaCAN board.

usage (KiCad python):
  miniroute.py NET [--w 0.4] [--via 0.7/0.35] [--layers F,I2,B] [--grid 0.05]
               [--window x0 y0 x1 y1] [--viacost 40] [--apply] [--tag name]
               [--src REF.PAD] [--dst REF.PAD]  (optional: restrict source/target to one pad each)

Without --apply it only searches and writes <tag>_path_<layer>.png overlays.
With --apply it adds the copper to the board file (backup kept as <tag>.bak.kicad_pcb).
"""
import os as _os
_HERE = _os.path.dirname(_os.path.abspath(__file__))
BRD = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_pcb")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import pcbnew, sys, math, heapq, shutil, os, time, collections
import numpy as np
from PIL import Image, ImageDraw

mm = lambda v: v / 1e6
LAY = {'F': pcbnew.F_Cu, 'I1': pcbnew.In1_Cu, 'I2': pcbnew.In2_Cu, 'B': pcbnew.B_Cu}
ALL_CU = [pcbnew.F_Cu, pcbnew.In1_Cu, pcbnew.In2_Cu, pcbnew.B_Cu]

EDGE_CLR = 0.30
HOLE_TO_HOLE = 0.25
HOLE_CLR = 0.20
SKIP_VIAS = set()   # (x, y) rounded to 0.01 mm: vias to ignore as obstacles (e.g. stitching vias about to be removed)


def arg(name, default=None):
    if name in sys.argv:
        return sys.argv[sys.argv.index(name) + 1]
    return default


class Grid:
    def __init__(self, x0, y0, x1, y1, step):
        self.x0, self.y0, self.step = x0, y0, step
        self.W = int(round((x1 - x0) / step)) + 1
        self.H = int(round((y1 - y0) / step)) + 1
    def to_px(self, x, y):
        return ((x - self.x0) / self.step, (y - self.y0) / self.step)
    def to_mm(self, ix, iy):
        return (self.x0 + ix * self.step, self.y0 + iy * self.step)


def poly_outlines(poly):
    outs = []
    for i in range(poly.OutlineCount()):
        o = poly.Outline(i)
        outs.append([(mm(o.CPoint(k).x), mm(o.CPoint(k).y)) for k in range(o.PointCount())])
    return outs


class Painter:
    """Draws inflated shapes into a PIL 'L' image (1 = blocked)."""
    def __init__(self, grid):
        self.g = grid
        self.img = Image.new('L', (grid.W, grid.H), 0)
        self.d = ImageDraw.Draw(self.img)
    def r_px(self, r):
        # +1 cell of safety: PIL rasterizes to integer pixels, losing up to half a cell
        return (r + self.g.step) / self.g.step
    def circle(self, x, y, r):
        cx, cy = self.g.to_px(x, y); rp = self.r_px(r)
        self.d.ellipse([cx - rp, cy - rp, cx + rp, cy + rp], fill=1)
    def segment(self, x1, y1, x2, y2, halfw):
        # stadium: line + end circles
        p1 = self.g.to_px(x1, y1); p2 = self.g.to_px(x2, y2); wp = max(1, int(round(2 * self.r_px(halfw))))
        self.d.line([p1, p2], fill=1, width=wp)
        self.circle(x1, y1, halfw); self.circle(x2, y2, halfw)
    def polygon(self, pts, inflate):
        pp = [self.g.to_px(x, y) for x, y in pts]
        if len(pp) >= 3:
            self.d.polygon(pp, fill=1)
        if inflate > 0:
            n = len(pts)
            for i in range(n):
                x1, y1 = pts[i]; x2, y2 = pts[(i + 1) % n]
                self.segment(x1, y1, x2, y2, inflate)
    def array(self):
        return np.array(self.img, dtype=bool)


_CLASS_CLR = None
def class_table():
    global _CLASS_CLR
    if _CLASS_CLR is None:
        import json
        pro = json.load(open(BRD.replace('.kicad_pcb', '.kicad_pro'), encoding='utf-8'))
        _CLASS_CLR = {c['name']: float(c.get('clearance', 0.15)) for c in pro['net_settings']['classes']}
    return _CLASS_CLR

def net_clearance(bd, netname):
    ni = bd.GetNetsByName()
    if netname in ni:
        try:
            cname = ni[netname].GetNetClassName()
            return class_table().get(cname, 0.15)
        except Exception:
            pass
    return 0.15


def build(bd, net, w, via_d, via_drill, layers, grid, src_pad=None, dst_pad=None):
    """Return (trk_mask{L}, via_mask, anchors{L}: dict of cell->kind, island_id per anchor)."""
    my_clr = net_clearance(bd, net)
    clr_cache = {}
    def clr_for(other_net):
        if other_net not in clr_cache:
            clr_cache[other_net] = max(my_clr, net_clearance(bd, other_net))
        return clr_cache[other_net]

    trk_p = {L: Painter(grid) for L in layers}
    via_p = Painter(grid)
    # --- board outline: block outside + edge band
    outline = pcbnew.SHAPE_POLY_SET()
    bd.GetBoardPolygonOutlines(outline, True)
    outs = poly_outlines(outline)
    edge_extra = float(arg('--edgeband', '0.55'))   # keep room for a >=0.3 mm pour strip along the edge
    for P in list(trk_p.values()) + [via_p]:
        r = (w / 2 if P is not via_p else via_d / 2) + EDGE_CLR + edge_extra
        # fill all, clear inside outline, then band along edges
        P.d.rectangle([0, 0, grid.W, grid.H], fill=1)
        for pts in outs:
            P.d.polygon([grid.to_px(x, y) for x, y in pts], fill=0)
        # holes in outline (inner contours) would need re-fill; board has none.
        for pts in outs:
            n = len(pts)
            for i in range(n):
                x1, y1 = pts[i]; x2, y2 = pts[(i + 1) % n]
                P.segment(x1, y1, x2, y2, r)
    # --- rule areas (keepouts)
    zones = list(bd.Zones())
    for f in bd.GetFootprints():
        zones += list(f.Zones())
    for z in zones:
        if not z.GetIsRuleArea():
            continue
        for pts in poly_outlines(z.Outline()):
            for L, P in trk_p.items():
                if z.IsOnLayer(L) and z.GetDoNotAllowTracks():
                    P.polygon(pts, w / 2)
            if z.GetDoNotAllowVias() and any(z.IsOnLayer(L) for L in ALL_CU):
                via_p.polygon(pts, via_d / 2)
    # --- pads
    for f in bd.GetFootprints():
        for p in f.Pads():
            same = (p.GetNetname() == net)
            c = clr_for(p.GetNetname())
            has_hole = p.GetDrillSizeX() > 0
            drill = mm(max(p.GetDrillSizeX(), p.GetDrillSizeY()))
            for L in ALL_CU:
                if not p.IsOnLayer(L):
                    continue
                shp = poly_outlines(p.GetEffectivePolygon(L))
                if not same:
                    if L in trk_p:
                        for pts in shp:
                            trk_p[L].polygon(pts, w / 2 + c)
                    for pts in shp:
                        via_p.polygon(pts, via_d / 2 + c)
                else:
                    # same net: vias should not sit in an SMD pad (solder wicking); PTH pads are fine
                    if not has_hole and L in trk_p:
                        for pts in shp:
                            via_p.polygon(pts, via_d / 2 - 0.05)
            if has_hole:
                pos = p.GetPosition()
                rr = drill / 2 + max(HOLE_TO_HOLE + via_drill / 2, HOLE_CLR + via_d / 2)
                via_p.circle(mm(pos.x), mm(pos.y), rr)
                if not same:
                    for L, P in trk_p.items():
                        P.circle(mm(pos.x), mm(pos.y), drill / 2 + HOLE_CLR + w / 2)
    # --- tracks & vias
    for t in bd.GetTracks():
        same = (t.GetNetname() == net)
        c = clr_for(t.GetNetname())
        if isinstance(t, pcbnew.PCB_VIA):
            pos = t.GetPosition(); vx, vy = mm(pos.x), mm(pos.y)
            if (round(vx, 2), round(vy, 2)) in SKIP_VIAS:
                continue
            vr = mm(t.GetWidth(pcbnew.F_Cu)) / 2; dr = mm(t.GetDrillValue()) / 2
            if not same:
                for L, P in trk_p.items():
                    if t.IsOnLayer(L):
                        P.circle(vx, vy, vr + c + w / 2)
                via_p.circle(vx, vy, vr + c + via_d / 2)
            via_p.circle(vx, vy, dr + HOLE_TO_HOLE + via_drill / 2)
        else:
            if same:
                continue
            s, e = t.GetStart(), t.GetEnd(); hw = mm(t.GetWidth()) / 2
            L = t.GetLayer()
            if L in trk_p:
                trk_p[L].segment(mm(s.x), mm(s.y), mm(e.x), mm(e.y), hw + c + w / 2)
            via_p.segment(mm(s.x), mm(s.y), mm(e.x), mm(e.y), hw + c + via_d / 2)
    trk_mask = {L: P.array() for L, P in trk_p.items()}
    via_mask = via_p.array()

    # --- anchors: same-net copper cells, tagged with island id
    bd.BuildConnectivity()
    conn = bd.GetConnectivity()
    items = []
    for f in bd.GetFootprints():
        for p in f.Pads():
            if p.GetNetname() == net:
                items.append(p)
    for t in bd.GetTracks():
        if t.GetNetname() == net:
            items.append(t)
    ptr = {int(it.this): i for i, it in enumerate(items)}
    parent = list(range(len(items)))
    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]; a = parent[a]
        return a
    for i, it in enumerate(items):
        for c_ in conn.GetConnectedItems(it):
            j = ptr.get(int(c_.this))
            if j is not None:
                parent[find(i)] = find(j)
    island = {i: find(i) for i in range(len(items))}
    anchors = {L: {} for L in layers}   # (ix,iy) -> island
    def add_anchor(L, x, y, isl, kind):
        ix, iy = grid.to_px(x, y); ix, iy = int(round(ix)), int(round(iy))
        if 0 <= ix < grid.W and 0 <= iy < grid.H:
            anchors[L].setdefault((ix, iy), (isl, kind))
    for i, it in enumerate(items):
        isl = island[i]
        if isinstance(it, pcbnew.PAD):
            ref = '%s.%s' % (it.GetParentFootprint().GetReference(), it.GetNumber())
            if src_pad and dst_pad and ref not in (src_pad, dst_pad):
                continue
            if src_pad and dst_pad:
                isl = -1 if ref == src_pad else -2   # forced pad-to-pad: pretend they are two islands
            pos = it.GetPosition()
            for L in layers:
                if it.IsOnLayer(L):
                    # every cell inside the pad polygon
                    Ptmp = Painter(grid)
                    for pts in poly_outlines(it.GetEffectivePolygon(L)):
                        Ptmp.polygon(pts, 0)
                    ys, xs = np.nonzero(Ptmp.array())
                    for ix, iy in zip(xs, ys):
                        anchors[L].setdefault((int(ix), int(iy)), (isl, 'pad'))
                    add_anchor(L, mm(pos.x), mm(pos.y), isl, 'padc')
        elif isinstance(it, pcbnew.PCB_VIA):
            if src_pad and dst_pad:
                continue
            pos = it.GetPosition()
            for L in layers:
                add_anchor(L, mm(pos.x), mm(pos.y), isl, 'via')
        else:
            if src_pad and dst_pad:
                continue
            L = it.GetLayer()
            if L not in layers:
                continue
            s, e = it.GetStart(), it.GetEnd()
            n = max(2, int(mm((e - s).EuclideanNorm()) / grid.step) + 1)
            for k in range(n):
                t_ = k / (n - 1)
                add_anchor(L, mm(s.x) + t_ * (mm(e.x) - mm(s.x)), mm(s.y) + t_ * (mm(e.y) - mm(s.y)), isl, 'trk')
    return trk_mask, via_mask, anchors


def route(trk_mask, via_mask, anchors, layers, grid, via_cost, src_isl, dst_isl):
    """Dijkstra from all src-island anchors to any dst-island anchor. Returns list of (L, ix, iy)."""
    Ls = list(layers)
    li = {L: i for i, L in enumerate(Ls)}
    H, W = grid.H, grid.W
    INF = 1e18
    dist = np.full((len(Ls), H, W), INF, dtype=np.float64)
    prev = np.full((len(Ls), H, W, 3), -1, dtype=np.int32)
    heap = []
    tgt = set()
    for L in Ls:
        for (ix, iy), (isl, kind) in anchors[L].items():
            if isl == src_isl and not trk_mask[L][iy, ix]:
                dist[li[L], iy, ix] = 0.0
                heapq.heappush(heap, (0.0, li[L], iy, ix))
            elif isl == dst_isl:
                tgt.add((li[L], iy, ix))
    if not heap:
        print('no free source anchors'); return None
    if not tgt:
        print('no target anchors'); return None
    tgt_free = [(l, y, x) for (l, y, x) in tgt if not trk_mask[Ls[l]][y, x]]
    print('sources: %d  targets: %d (free: %d)' % (len(heap), len(tgt), len(tgt_free)))
    moves = [(1, 0, 1.0), (-1, 0, 1.0), (0, 1, 1.0), (0, -1, 1.0),
             (1, 1, 1.4142), (1, -1, 1.4142), (-1, 1, 1.4142), (-1, -1, 1.4142)]
    masks = [trk_mask[L] for L in Ls]
    t0 = time.time(); pops = 0
    end = None
    while heap:
        d, l, y, x = heapq.heappop(heap)
        if d > dist[l, y, x]:
            continue
        pops += 1
        if (l, y, x) in tgt:
            end = (l, y, x); break
        for dx, dy, c in moves:
            nx, ny = x + dx, y + dy
            if nx < 0 or ny < 0 or nx >= W or ny >= H:
                continue
            if masks[l][ny, nx]:
                continue
            # forbid diagonal squeezing between two blocked orthogonal cells
            if dx and dy and (masks[l][y, nx] and masks[l][ny, x]):
                continue
            nd = d + c
            if nd < dist[l, ny, nx]:
                dist[l, ny, nx] = nd; prev[l, ny, nx] = (l, y, x)
                heapq.heappush(heap, (nd, l, ny, nx))
        if not via_mask[y, x]:
            for l2 in range(len(Ls)):
                if l2 == l or masks[l2][y, x]:
                    continue
                nd = d + via_cost
                if nd < dist[l2, y, x]:
                    dist[l2, y, x] = nd; prev[l2, y, x] = (l, y, x)
                    heapq.heappush(heap, (nd, l2, y, x))
    print('dijkstra: %d pops in %.1fs' % (pops, time.time() - t0))
    if end is None:
        return None
    path = []
    cur = end
    while cur is not None and cur[0] >= 0:
        path.append(cur)
        p = prev[cur[0], cur[1], cur[2]]
        if p[0] < 0:
            break
        cur = (int(p[0]), int(p[1]), int(p[2]))
    path.reverse()
    print('path cost %.1f cells, %d cells' % (dist[end], len(path)))
    return [(Ls[l], x, y) for (l, y, x) in path]


def simplify(path, trk_mask, grid, Ls):
    """Split into per-layer runs, then greedy line-of-sight shortcutting restricted to H/V/45 directions."""
    runs = []
    cur = [path[0]]
    for p in path[1:]:
        if p[0] == cur[-1][0]:
            cur.append(p)
        else:
            runs.append(cur); cur = [p]
    runs.append(cur)
    def free_line(L, a, b, any_angle=False):
        x0, y0 = a; x1, y1 = b
        dx, dy = x1 - x0, y1 - y0
        m = trk_mask[L]
        if not any_angle:
            if not (dx == 0 or dy == 0 or abs(dx) == abs(dy)):
                return False
            n = max(abs(dx), abs(dy))
            sx = (dx > 0) - (dx < 0); sy = (dy > 0) - (dy < 0)
            for k in range(n + 1):
                x, y = x0 + sx * k, y0 + sy * k
                if m[y, x]:
                    return False
                if sx and sy and k < n and (m[y, x + sx] and m[y + sy, x]):
                    return False
            return True
        # any angle: supercover sampling at quarter-cell steps, checking the 4 cells around each sample
        n = int(max(abs(dx), abs(dy)) * 4) + 1
        for k in range(n + 1):
            t = k / n
            fx, fy = x0 + dx * t, y0 + dy * t
            cx, cy = int(round(fx)), int(round(fy))
            if 0 <= cy < m.shape[0] and 0 <= cx < m.shape[1] and m[cy, cx]:
                return False
        return True
    out = []
    for run in runs:
        L = run[0][0]
        pts = [(x, y) for (_, x, y) in run]
        simp = [pts[0]]
        i = 0
        while i < len(pts) - 1:
            j = len(pts) - 1
            while j > i + 1 and not free_line(L, pts[i], pts[j]):
                j -= 1
            simp.append(pts[j]); i = j
        # second pass: drop vertices whose adjacent segments are tiny (< 4 cells) if the any-angle bypass is free
        changed = True
        while changed and len(simp) > 2:
            changed = False
            for k in range(1, len(simp) - 1):
                a, b, c = simp[k - 1], simp[k], simp[k + 1]
                lab = math.hypot(b[0] - a[0], b[1] - a[1]); lbc = math.hypot(c[0] - b[0], c[1] - b[1])
                if (lab < 4 or lbc < 4) and free_line(L, a, c, any_angle=True):
                    del simp[k]; changed = True; break
        out.append((L, simp))
    return out


def apply(bd, net, segs, w, via_d, via_drill, grid, first_last_snap):
    """Add tracks (per layer runs) and vias between runs."""
    ni = bd.GetNetsByName()[net]
    added = 0
    prev_end = None
    # same-net pads, for snapping route ends to pad centres
    pads = []
    for f in bd.GetFootprints():
        for p in f.Pads():
            if p.GetNetname() == net:
                pads.append(p)
    def snap_pad(pt, L):
        for p in pads:
            if p.IsOnLayer(L) and p.HitTest(pcbnew.VECTOR2I(pcbnew.FromMM(pt[0]), pcbnew.FromMM(pt[1]))):
                c = p.GetPosition()
                return (mm(c.x), mm(c.y))
        return None
    for i, (L, pts) in enumerate(segs):
        mmpts = [grid.to_mm(x, y) for x, y in pts]
        if i == 0:
            c = snap_pad(mmpts[0], L)
            if c and c != mmpts[0]:
                mmpts.insert(0, c)
        if i == len(segs) - 1:
            c = snap_pad(mmpts[-1], L)
            if c and c != mmpts[-1]:
                mmpts.append(c)
        if prev_end is not None:
            v = pcbnew.PCB_VIA(bd)
            v.SetPosition(pcbnew.VECTOR2I(pcbnew.FromMM(mmpts[0][0]), pcbnew.FromMM(mmpts[0][1])))
            v.SetViaType(pcbnew.VIATYPE_THROUGH)
            v.SetWidth(pcbnew.FromMM(via_d)); v.SetDrill(pcbnew.FromMM(via_drill))
            v.SetLayerPair(pcbnew.F_Cu, pcbnew.B_Cu)
            v.SetNet(ni)
            bd.Add(v); added += 1
        for a, b in zip(mmpts, mmpts[1:]):
            if a == b:
                continue
            t = pcbnew.PCB_TRACK(bd)
            t.SetStart(pcbnew.VECTOR2I(pcbnew.FromMM(a[0]), pcbnew.FromMM(a[1])))
            t.SetEnd(pcbnew.VECTOR2I(pcbnew.FromMM(b[0]), pcbnew.FromMM(b[1])))
            t.SetWidth(pcbnew.FromMM(w)); t.SetLayer(L); t.SetNet(ni)
            bd.Add(t); added += 1
        prev_end = mmpts[-1]
    return added


def overlay(bd, grid, trk_mask, path, tag, layers):
    LN = {pcbnew.F_Cu: 'F', pcbnew.In2_Cu: 'I2', pcbnew.B_Cu: 'B', pcbnew.In1_Cu: 'I1'}
    for L in layers:
        m = trk_mask[L]
        img = Image.new('RGB', (grid.W, grid.H), (20, 20, 25))
        arr = np.array(img)
        arr[m] = (70, 70, 90)
        img = Image.fromarray(arr)
        d = ImageDraw.Draw(img)
        pts = [(x, y) for (l, x, y) in path if l == L]
        for x, y in pts:
            d.point((x, y), fill=(255, 255, 0))
        for gx in range(int(math.ceil(grid.x0)), int(grid.x0 + grid.W * grid.step) + 1):
            X = (gx - grid.x0) / grid.step
            d.line([(X, 0), (X, grid.H)], fill=(60, 60, 80) if gx % 5 else (110, 110, 150))
            if gx % 5 == 0: d.text((X + 2, 2), str(gx), fill=(200, 200, 255))
        for gy in range(int(math.ceil(grid.y0)), int(grid.y0 + grid.H * grid.step) + 1):
            Y = (gy - grid.y0) / grid.step
            d.line([(0, Y), (grid.W, Y)], fill=(60, 60, 80) if gy % 5 else (110, 110, 150))
            if gy % 5 == 0: d.text((2, Y + 2), str(gy), fill=(200, 200, 255))
        scale = 2 if grid.W < 600 else 1
        if scale > 1:
            img = img.resize((grid.W * scale, grid.H * scale), Image.NEAREST)
        img.save(os.path.join(SP, '%s_path_%s.png' % (tag, LN[L])))


def main():
    net = sys.argv[1]
    w = float(arg('--w', '0.2'))
    via_d, via_drill = [float(v) for v in arg('--via', '0.6/0.3').split('/')]
    layers = [LAY[s] for s in arg('--layers', 'F,I2,B').split(',')]
    step = float(arg('--grid', '0.05'))
    via_cost = float(arg('--viacost', '40'))
    tag = arg('--tag', net.replace('(', '').replace(')', '').replace('-', ''))
    src_pad, dst_pad = arg('--src'), arg('--dst')
    bd = pcbnew.LoadBoard(BRD)
    if '--window' in sys.argv:
        i = sys.argv.index('--window'); x0, y0, x1, y1 = [float(v) for v in sys.argv[i + 1:i + 5]]
    else:
        bb = bd.GetBoardEdgesBoundingBox()
        x0, y0, x1, y1 = mm(bb.GetLeft()) - 0.5, mm(bb.GetTop()) - 0.5, mm(bb.GetRight()) + 0.5, mm(bb.GetBottom()) + 0.5
    grid = Grid(x0, y0, x1, y1, step)
    print('grid %dx%d @ %.3f mm' % (grid.W, grid.H, step))
    t0 = time.time()
    trk_mask, via_mask, anchors = build(bd, net, w, via_d, via_drill, layers, grid, src_pad, dst_pad)
    print('masks built in %.1fs' % (time.time() - t0))
    isl = collections.Counter()
    for L in layers:
        for (k, (i_, kind)) in anchors[L].items():
            isl[i_] += 1
    print('islands (anchor cells):', dict(isl))
    if len(isl) < 2:
        print('net has <2 islands within window; nothing to do'); return
    # smallest island is the source (fewer starts), other = target
    order = sorted(isl.items(), key=lambda kv: kv[1])
    src_isl, dst_isl = order[0][0], order[-1][0]
    if arg('--swap'):
        src_isl, dst_isl = dst_isl, src_isl
    path = route(trk_mask, via_mask, anchors, layers, grid, via_cost, src_isl, dst_isl)
    if path is None:
        print('NO PATH'); overlay(bd, grid, trk_mask, [], tag, layers); return
    segs = simplify(path, trk_mask, grid, layers)
    LN = {pcbnew.F_Cu: 'F', pcbnew.In2_Cu: 'I2', pcbnew.B_Cu: 'B'}
    for L, pts in segs:
        print('  layer %s: %s' % (LN[L], ' -> '.join('(%.2f,%.2f)' % grid.to_mm(x, y) for x, y in pts)))
    overlay(bd, grid, trk_mask, path, tag, layers)
    if '--apply' in sys.argv:
        bak = os.path.join(SP, tag + '.bak.kicad_pcb')
        shutil.copy(BRD, bak)
        n = apply(bd, net, segs, w, via_d, via_drill, grid, None)
        pcbnew.SaveBoard(BRD, bd)
        bd2 = pcbnew.LoadBoard(BRD)
        pcbnew.ZONE_FILLER(bd2).Fill(bd2.Zones())
        bd2.BuildConnectivity()
        pcbnew.SaveBoard(BRD, bd2)
        print('applied %d items; unconnected now %d; backup %s' % (n, bd2.GetConnectivity().GetUnconnectedCount(True), bak))


if __name__ == '__main__':
    main()

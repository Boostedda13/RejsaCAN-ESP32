"""Connected clusters of the schematic (symbols + wires + labels + junctions joined by geometry)."""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import sys, collections
import schgeom as G

def near(a, b, tol=0.02):
    return abs(a[0] - b[0]) < tol and abs(a[1] - b[1]) < tol
def on_segment(p, a, b, tol=0.02):
    # p on segment a-b (axis-aligned or diagonal)
    if near(p, a) or near(p, b): return True
    dx, dy = b[0] - a[0], b[1] - a[1]
    L = (dx * dx + dy * dy) ** 0.5
    if L < 1e-9: return False
    t = ((p[0] - a[0]) * dx + (p[1] - a[1]) * dy) / (L * L)
    if t < -1e-6 or t > 1 + 1e-6: return False
    px, py = a[0] + t * dx, a[1] + t * dy
    return near(p, (px, py))

def clusters(syms, wires, labels, junctions):
    # nodes: ('S',i) ('W',i) ('L',i) ('J',i)
    parent = {}
    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]; a = parent[a]
        return a
    def union(a, b):
        parent.setdefault(a, a); parent.setdefault(b, b)
        ra, rb = find(a), find(b)
        if ra != rb: parent[ra] = rb
    for i in range(len(syms)): parent[('S', i)] = ('S', i)
    for i in range(len(wires)): parent[('W', i)] = ('W', i)
    for i in range(len(labels)): parent[('L', i)] = ('L', i)
    for i in range(len(junctions)): parent[('J', i)] = ('J', i)
    # wire endpoints and segments
    segs = []
    for wi, w in enumerate(wires):
        pts = w['pts']
        for a, b in zip(pts, pts[1:]):
            segs.append((wi, a, b))
    # symbol pins <-> wire endpoints / segments
    for si, s in enumerate(syms):
        for (_, _, p) in s['pins']:
            for (wi, a, b) in segs:
                if near(p, a) or near(p, b) or on_segment(p, a, b):
                    union(('S', si), ('W', wi))
            for li, l in enumerate(labels):
                if near(p, l['at'][:2]):
                    union(('S', si), ('L', li))
        # pin-to-pin direct contact between symbols
    for si, s in enumerate(syms):
        for sj in range(si + 1, len(syms)):
            for (_, _, p) in s['pins']:
                for (_, _, q) in syms[sj]['pins']:
                    if near(p, q):
                        union(('S', si), ('S', sj))
    # wire <-> wire (endpoint touching a segment)
    for (wi, a, b) in segs:
        for (wj, c, d) in segs:
            if wi >= wj: continue
            if on_segment(a, c, d) or on_segment(b, c, d) or on_segment(c, a, b) or on_segment(d, a, b):
                union(('W', wi), ('W', wj))
    # labels on wires
    for li, l in enumerate(labels):
        p = l['at'][:2]
        for (wi, a, b) in segs:
            if on_segment(p, a, b):
                union(('L', li), ('W', wi))
    for ji, j in enumerate(junctions):
        for (wi, a, b) in segs:
            if on_segment(j, a, b):
                union(('J', ji), ('W', wi))
    groups = collections.defaultdict(list)
    for k in parent:
        groups[find(k)].append(k)
    return groups

if __name__ == '__main__':
    text, root, syms, wires, labels, junctions = G.model()
    groups = clusters(syms, wires, labels, junctions)
    gl = sorted(groups.values(), key=lambda g: -len(g))
    print('clusters:', len(gl))
    for g in gl:
        refs = [syms[i]['ref'] for (k, i) in g if k == 'S']
        nl = sum(1 for (k, i) in g if k == 'L'); nw = sum(1 for (k, i) in g if k == 'W')
        # bbox
        xs = []; ys = []
        for (k, i) in g:
            if k == 'S': b = syms[i]['bbox']; xs += [b[0], b[2]]; ys += [b[1], b[3]]
            if k == 'W':
                for p in wires[i]['pts']: xs.append(p[0]); ys.append(p[1])
            if k == 'L': b = labels[i]['bbox']; xs += [b[0], b[2]]; ys += [b[1], b[3]]
        bb = (min(xs), min(ys), max(xs), max(ys)) if xs else None
        print('  %3d items | %2d syms %2d wires %2d labels | bbox %s | %s' % (len(g), len(refs), nw, nl, tuple(round(v, 1) for v in bb) if bb else None, ' '.join(sorted(refs))[:150]))

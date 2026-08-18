"""Auto-place visible symbol fields (Reference/Value/...) that overlap other symbols, labels or texts.
Only property (at ..) and justify are edited -> no connectivity impact. usage: schtext.py [--apply]"""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import re, sys, math
import schgeom as G, schmove as M

text, root, syms, wires, labels, junctions = G.model()
spans = M.top_level_spans(text)
kinds = {}
for sp in spans: kinds.setdefault(M.node_key(text, sp), []).append(sp)
sym_span = kinds['symbol']
OV = G.overlap

# obstacles: symbol bodies (with a small margin), labels, and texts (updated as we go)
sym_boxes = [(s['ref'], s['bbox']) for s in syms]
lab_boxes = [l['bbox'] for l in labels]
text_boxes = {}   # (ref, field) -> bbox
for s in syms:
    for (name, txt, bb, sz) in s['ptexts']:
        text_boxes[(s['ref'], name)] = bb

def conflicts(ref, field, bb):
    n = 0
    for r, sb in sym_boxes:
        if r != ref and OV(bb, sb, 0.2): n += 1
        if r == ref and OV(bb, sb, -0.05): n += 1        # own body too
    for lb in lab_boxes:
        if OV(bb, lb, 0.2): n += 1
    for (r, f), tb in text_boxes.items():
        if (r, f) != (ref, field) and OV(bb, tb, 0.2): n += 1
    return n

def size_of(txt, size=1.27):
    return len(txt) * size * 0.95, size * 1.4

moves = []   # (span, field, x, y)
fixed = 0; unfixed = []
for si, s in enumerate(syms):
    if s['ref'].startswith('#'):        # power symbols: hide nothing, but skip repositioning
        continue
    b = s['bbox']; cx, cy = (b[0] + b[2]) / 2, (b[1] + b[3]) / 2
    for (name, txt, bb, sz) in s['ptexts']:
        if conflicts(s['ref'], name, bb) == 0:
            continue
        w, h = size_of(txt, sz)
        cands = []
        for d in (0.6, 1.6, 2.8, 4.0):
            cands += [(cx, b[1] - d - h / 2), (cx, b[3] + d + h / 2),
                      (b[0] - d - w / 2, cy), (b[2] + d + w / 2, cy),
                      (b[2] + d + w / 2, b[1] + h / 2), (b[2] + d + w / 2, b[3] - h / 2),
                      (b[0] - d - w / 2, b[1] + h / 2), (b[0] - d - w / 2, b[3] - h / 2),
                      (cx - w / 2 - 1, b[1] - d - h / 2), (cx + w / 2 + 1, b[1] - d - h / 2),
                      (cx - w / 2 - 1, b[3] + d + h / 2), (cx + w / 2 + 1, b[3] + d + h / 2)]
        best = None
        for (x, y) in cands:
            nb = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
            if conflicts(s['ref'], name, nb) == 0:
                best = (x, y, nb); break
        if best is None:
            unfixed.append((s['ref'], name)); continue
        x, y, nb = best
        text_boxes[(s['ref'], name)] = nb
        moves.append((si, name, x, y)); fixed += 1
print('texts moved: %d, no free spot: %d %s' % (fixed, len(unfixed), unfixed[:20]))
if '--apply' not in sys.argv:
    sys.exit()
# apply: within each symbol span, rewrite the property's (at ...) and drop justify
by_sym = {}
for si, name, x, y in moves:
    by_sym.setdefault(si, []).append((name, x, y))
edits = []
for si, lst in by_sym.items():
    sp = sym_span[si]; seg = text[sp[0]:sp[1]]
    for name, x, y in lst:
        pat = re.compile(r'(\(property "%s" "(?:[^"\\]|\\.)*"\s*\(at )(-?\d+(?:\.\d+)?) (-?\d+(?:\.\d+)?)( -?\d+(?:\.\d+)?)?\)' % re.escape(name))
        m = pat.search(seg)
        if not m:
            print('  no property match', syms[si]['ref'], name); continue
        seg = seg[:m.start()] + '%s%s %s 0)' % (m.group(1), M.fmt(x), M.fmt(y)) + seg[m.end():]
        # strip justify inside this property's effects
        pstart = seg.index('(property "%s"' % name)
        # find end of this property block
        depth = 0; k = pstart
        while k < len(seg):
            if seg[k] == '(': depth += 1
            elif seg[k] == ')':
                depth -= 1
                if depth == 0: break
            k += 1
        block = seg[pstart:k + 1]
        block2 = re.sub(r'\s*\(justify [^)]*\)', '', block)
        seg = seg[:pstart] + block2 + seg[k + 1:]
    edits.append((sp, seg))
edits.sort(key=lambda e: e[0][0], reverse=True)
out = text
for sp, seg in edits: out = out[:sp[0]] + seg + out[sp[1]:]
open(G.SCH, 'w', encoding='utf-8', newline='\n').write(out)
print('written')

"""Rigidly translate wired clusters (symbol + its wires/labels/junctions) in the .kicad_sch by editing
only the (at x y ..) / (xy x y) numbers inside each node's text span. Connectivity is preserved by
construction; verified afterwards with netcheck.py.
usage: schmove.py [--apply]"""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import re, sys, shutil
import schgeom as G, schclusters as C

# ---- span-aware parse: returns list of top-level nodes with (kind, start, end, node)
def top_level_spans(text):
    """Return spans of top-level children of the root (kicad_sch ...) form."""
    # find the root's first '(' then iterate its children by paren depth
    i = text.index('(')
    depth = 0; j = i; spans = []; start = None
    n = len(text)
    while j < n:
        ch = text[j]
        if ch == '"':
            # skip string
            j += 1
            while j < n and text[j] != '"':
                if text[j] == '\\': j += 1
                j += 1
        elif ch == '(':
            depth += 1
            if depth == 2: start = j
        elif ch == ')':
            if depth == 2 and start is not None:
                spans.append((start, j + 1)); start = None
            depth -= 1
            if depth == 0: break
        j += 1
    return spans

def node_key(text, span):
    m = re.match(r'\((\w+)', text[span[0]:span[1]])
    return m.group(1) if m else ''

def translate_span(text, span, dx, dy):
    seg = text[span[0]:span[1]]
    def rep(m):
        x = float(m.group(2)) + dx; y = float(m.group(3)) + dy
        return '%s%s %s' % (m.group(1), fmt(x), fmt(y))
    seg2 = re.sub(r'(\((?:at|xy) )(-?\d+(?:\.\d+)?) (-?\d+(?:\.\d+)?)', rep, seg)
    return seg2

def fmt(v):
    v = round(v, 4)
    s = ('%.4f' % v).rstrip('0').rstrip('.')
    return s if s not in ('-0', '') else '0'

def main():
    text, root, syms, wires, labels, junctions = G.model()
    groups = C.clusters(syms, wires, labels, junctions)
    spans = top_level_spans(text)
    # map model nodes -> spans by matching order of appearance per kind
    kinds = {'symbol': [], 'wire': [], 'label': [], 'global_label': [], 'hierarchical_label': [], 'junction': []}
    for sp in spans:
        k = node_key(text, sp)
        if k in kinds: kinds[k].append(sp)
    # G.model iterates find(root,'symbol') etc. in file order, matching these lists
    sym_span = kinds['symbol']; wire_span = kinds['wire']; junc_span = kinds['junction']
    lab_span = kinds['label'] + kinds['global_label'] + kinds['hierarchical_label']
    assert len(sym_span) == len(syms) and len(wire_span) == len(wires) and len(lab_span) == len(labels) and len(junc_span) == len(junctions), (len(sym_span), len(syms), len(wire_span), len(wires), len(lab_span), len(labels), len(junc_span), len(junctions))
    S = {s['ref']: i for i, s in enumerate(syms)}
    def group_of(ref):
        i = S[ref]
        for g in groups.values():
            if ('S', i) in g: return g
    # ---- targets: ref -> (x, y) for the anchor symbol's (at)
    T = {
        # GNSS RF chain, row 1
        'J2': (300, 145), 'C30': (325, 145), 'L2': (350, 145), 'D13': (375, 145),
        # bias tee supply side, row 2
        'C29': (300, 170), 'C31': (325, 170), 'R23': (350, 170),
        # LDO, row 3
        'U8': (305, 197), 'C33': (335, 197), 'C32': (355, 197), 'C27': (375, 197), 'C28': (395, 197),
        # LED, row 4
        'GPS1': (305, 225), 'R22': (335, 225),
        # J3 off the USB-C connector
        'J3': (293.37, 130.0),
    }
    edits = []   # (span, dx, dy)
    moved = set()
    for ref, (tx, ty) in T.items():
        g = group_of(ref)
        s = syms[S[ref]]
        dx, dy = tx - s['at'][0], ty - s['at'][1]
        # snap to 1.27 grid to keep everything on grid
        dx = round(dx / 1.27) * 1.27; dy = round(dy / 1.27) * 1.27
        refs = [syms[i]['ref'] for (k, i) in g if k == 'S']
        print('%-5s cluster %s  d=(%.2f,%.2f)' % (ref, refs, dx, dy))
        if any(r in moved for r in refs):
            print('   already moved with another target, skipping'); continue
        moved.update(refs)
        for (k, i) in g:
            sp = {'S': sym_span, 'W': wire_span, 'L': lab_span, 'J': junc_span}[k][i]
            edits.append((sp, dx, dy))
    # D4: slide along the VBAT_IN rail wire (horizontal at y=144.78) to x=232.41 (free), labels with it
    d4 = syms[S['D4']]
    dx = round((232.41 - d4['at'][0]) / 1.27) * 1.27
    edits.append((sym_span[S['D4']], dx, 0.0))
    for li, l in enumerate(labels):
        if abs(l['at'][0] - d4['at'][0]) < 0.05 and (abs(l['at'][1] - 144.78) < 0.05 or abs(l['at'][1] - 154.94) < 0.05):
            edits.append((lab_span[li], dx, 0.0)); print('D4 label', l['text'], 'moves', dx)
    print('D4 dx', dx)
    if '--apply' not in sys.argv:
        print('dry run; %d node edits' % len(edits)); return
    shutil.copy(G.SCH, G.SCH + '.premove.bak')
    # apply edits from the end
    edits.sort(key=lambda e: e[0][0], reverse=True)
    out = text
    for (sp, dx, dy) in edits:
        out = out[:sp[0]] + translate_span(out, sp, dx, dy) + out[sp[1]:]
    open(G.SCH, 'w', encoding='utf-8', newline='\n').write(out)
    print('written')

if __name__ == '__main__':
    main()

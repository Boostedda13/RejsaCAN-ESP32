"""Parse the .kicad_sch S-expression: symbol instances with bounding boxes (from lib_symbols), labels,
wires. Report overlaps. Library, no side effects."""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import re, math, sys, collections

# ---------- minimal s-expression parser ----------
def parse(text):
    tok = re.finditer(r'\(|\)|"(?:[^"\\]|\\.)*"|[^\s()"]+', text)
    stack = [[]]
    for m in tok:
        t = m.group(0)
        if t == '(':
            stack.append([])
        elif t == ')':
            node = stack.pop(); stack[-1].append(node)
        elif t.startswith('"'):
            stack[-1].append(bytes(t[1:-1], 'utf-8').decode('unicode_escape') if '\\' in t else t[1:-1])
        else:
            try:
                stack[-1].append(float(t) if re.match(r'^-?\d+(\.\d+)?$', t) else t)
            except ValueError:
                stack[-1].append(t)
    return stack[0][0]

def find(node, key):
    return [n for n in node if isinstance(n, list) and n and n[0] == key]
def find1(node, key):
    r = find(node, key); return r[0] if r else None

def load():
    text = open(SCH, encoding='utf-8').read()
    return text, parse(text)

# ---------- library symbol geometry ----------
def lib_bbox(libsym):
    """bbox of a lib symbol's graphics + pins (all units), in symbol coords (Y up)."""
    xs, ys = [], []
    def add(x, y):
        xs.append(x); ys.append(y)
    def walk(node):
        for n in node:
            if not isinstance(n, list): continue
            k = n[0]
            if k == 'symbol':
                walk(n)
            elif k == 'rectangle':
                s = find1(n, 'start'); e = find1(n, 'end')
                add(s[1], s[2]); add(e[1], e[2])
            elif k == 'polyline' or k == 'bezier':
                for p in find(find1(n, 'pts') or [], 'xy'):
                    add(p[1], p[2])
            elif k == 'circle':
                c = find1(n, 'center'); r = find1(n, 'radius')[1]
                add(c[1] - r, c[2] - r); add(c[1] + r, c[2] + r)
            elif k == 'arc':
                for kk in ('start', 'mid', 'end'):
                    p = find1(n, kk); add(p[1], p[2])
            elif k == 'pin':
                at = find1(n, 'at'); ln = find1(n, 'length')[1]
                x, y, a = at[1], at[2], (at[3] if len(at) > 3 else 0)
                dx, dy = {0: (1, 0), 90: (0, 1), 180: (-1, 0), 270: (0, -1)}[int(a) % 360]
                add(x, y); add(x + dx * ln, y + dy * ln)
    walk(libsym)
    if not xs:
        return (0, 0, 0, 0)
    return (min(xs), min(ys), max(xs), max(ys))

def lib_pins(libsym):
    """list of (name, number, x, y, angle, length, unit) in symbol coords."""
    out = []
    def walk(node, unit):
        for n in node:
            if not isinstance(n, list): continue
            if n[0] == 'symbol':
                m = re.search(r'_(\d+)_\d+$', n[1]); walk(n, int(m.group(1)) if m else unit)
            elif n[0] == 'pin':
                at = find1(n, 'at'); ln = find1(n, 'length')[1]
                name = find1(n, 'name'); num = find1(n, 'number')
                out.append((name[1] if name else '', str(num[1]) if num else '', at[1], at[2], at[3] if len(at) > 3 else 0, ln, unit))
    walk(libsym, 0)
    return out

def xform(x, y, at, mirror):
    """symbol-local (Y up) -> sheet coords (Y down)."""
    ax, ay, rot = at[1], at[2], (at[3] if len(at) > 3 else 0)
    if mirror == 'x': y = -y
    if mirror == 'y': x = -x
    r = math.radians(rot)
    xr = x * math.cos(r) - y * math.sin(r)
    yr = x * math.sin(r) + y * math.cos(r)
    return (ax + xr, ay - yr)

def model():
    text, root = load()
    libs = {}
    for ls in find(root, 'lib_symbols'):
        for s in find(ls, 'symbol'):
            libs[s[1]] = s
    syms = []
    for s in find(root, 'symbol'):
        lib_id = find1(s, 'lib_id')[1]
        at = find1(s, 'at')
        mirror = find1(s, 'mirror'); mirror = mirror[1] if mirror else None
        unit = find1(s, 'unit'); unit = int(unit[1]) if unit else 1
        all_units = (unit == 0)   # scripted symbols were written with (unit 0): KiCad draws every unit's pins
        if unit == 0: unit = 1
        props = {p[1]: p for p in find(s, 'property')}
        ref = props['Reference'][2] if 'Reference' in props else '?'
        lb = lib_bbox(libs[lib_id]) if lib_id in libs else (0, 0, 0, 0)
        # transform 4 corners
        cs = [xform(x, y, at, mirror) for x in (lb[0], lb[2]) for y in (lb[1], lb[3])]
        bx = (min(c[0] for c in cs), min(c[1] for c in cs), max(c[0] for c in cs), max(c[1] for c in cs))
        pins = []
        for (nm, num, px, py, pa, pl, pu) in lib_pins(libs.get(lib_id, [])):
            if not all_units and pu not in (0, unit): continue
            pins.append((nm, num, xform(px, py, at, mirror)))
        # property text bboxes (visible ones)
        ptexts = []
        for name, p in props.items():
            pat = find1(p, 'at'); eff = find1(p, 'effects')
            hidden = False
            hp = find1(p, 'hide')                       # KiCad 10: (hide yes) at property level
            if hp and len(hp) > 1 and hp[1] in ('yes', True):
                hidden = True
            if eff:
                h = find1(eff, 'hide')
                if (h and len(h) > 1 and h[1] in ('yes', True)) or 'hide' in eff:
                    hidden = True
            if name in ('Footprint', 'Datasheet', 'Description') and not eff:
                hidden = True
            if hidden or not pat: continue
            font = find1(eff, 'font') if eff else None
            size = find1(font, 'size')[1] if font and find1(font, 'size') else 1.27
            txt = str(p[2]); rot = pat[3] if len(pat) > 3 else 0
            w = len(txt) * size * 0.95; h = size * 1.4
            just = find1(eff, 'justify') if eff else None
            hj = 'center'; vj = 'center'
            if just:
                for t in just[1:]:
                    if t in ('left', 'right'): hj = t
                    if t in ('top', 'bottom'): vj = t
            if int(rot) % 180 == 90:
                # vertical text: horizontal justify acts along y
                x0, x1 = pat[1] - h / 2, pat[1] + h / 2
                if hj == 'left': y0, y1 = pat[2] - w, pat[2]
                elif hj == 'right': y0, y1 = pat[2], pat[2] + w
                else: y0, y1 = pat[2] - w / 2, pat[2] + w / 2
            else:
                if hj == 'left': x0, x1 = pat[1], pat[1] + w
                elif hj == 'right': x0, x1 = pat[1] - w, pat[1]
                else: x0, x1 = pat[1] - w / 2, pat[1] + w / 2
                if vj == 'top': y0, y1 = pat[2], pat[2] + h
                elif vj == 'bottom': y0, y1 = pat[2] - h, pat[2]
                else: y0, y1 = pat[2] - h / 2, pat[2] + h / 2
            ptexts.append((name, txt, (x0, y0, x1, y1), size))
        syms.append({'ref': ref, 'lib_id': lib_id, 'at': (at[1], at[2], at[3] if len(at) > 3 else 0), 'mirror': mirror, 'unit': unit, 'bbox': bx, 'pins': pins, 'ptexts': ptexts, 'node': s})
    wires = []
    for w in find(root, 'wire'):
        pts = [(p[1], p[2]) for p in find(find1(w, 'pts'), 'xy')]
        wires.append({'pts': pts, 'node': w})
    labels = []
    for kind in ('label', 'global_label', 'hierarchical_label'):
        for l in find(root, kind):
            at = find1(l, 'at'); txt = str(l[1])
            eff = find1(l, 'effects'); font = find1(eff, 'font') if eff else None
            size = find1(font, 'size')[1] if font and find1(font, 'size') else 1.27
            rot = at[3] if len(at) > 3 else 0
            w = (len(txt) + (2 if kind != 'label' else 0)) * size * 0.85; h = size * 1.3
            # label extends from anchor in the direction of rotation
            if int(rot) % 360 == 0: bx = (at[1], at[2] - h, at[1] + w, at[2])
            elif int(rot) % 360 == 180: bx = (at[1] - w, at[2] - h, at[1], at[2])
            elif int(rot) % 360 == 90: bx = (at[1] - h, at[2] - w, at[1], at[2])
            else: bx = (at[1] - h, at[2], at[1], at[2] + w)
            labels.append({'kind': kind, 'text': txt, 'at': (at[1], at[2], rot), 'bbox': bx, 'node': l})
    junctions = [(find1(j, 'at')[1], find1(j, 'at')[2]) for j in find(root, 'junction')]
    return text, root, syms, wires, labels, junctions

def overlap(a, b, m=0.0):
    return not (a[2] + m <= b[0] or b[2] + m <= a[0] or a[3] + m <= b[1] or b[3] + m <= a[1])

if __name__ == '__main__':
    text, root, syms, wires, labels, junctions = model()
    print('symbols %d wires %d labels %d junctions %d' % (len(syms), len(wires), len(labels), len(junctions)))
    n = 0
    for i, a in enumerate(syms):
        for b in syms[i + 1:]:
            if overlap(a['bbox'], b['bbox']):
                print('SYM-SYM  %-8s %-8s' % (a['ref'], b['ref'])); n += 1
    for l in labels:
        for s in syms:
            if overlap(l['bbox'], s['bbox']):
                # ignore if the label is attached at one of this symbol's pins (that is normal)
                if any(abs(px - l['at'][0]) < 0.01 and abs(py - l['at'][1]) < 0.01 for (_, _, (px, py)) in s['pins']):
                    continue
                print('LBL-SYM  %-16s over %-8s' % (l['text'], s['ref'])); n += 1
    for i, a in enumerate(labels):
        for b in labels[i + 1:]:
            if overlap(a['bbox'], b['bbox']):
                print('LBL-LBL  %-16s %-16s' % (a['text'], b['text'])); n += 1
    for s in syms:
        for pt in s['ptexts']:
            for t in syms:
                if t is s: continue
                if overlap(pt[2], t['bbox']):
                    print('TXT-SYM  %s.%s "%s" over %s' % (s['ref'], pt[0], pt[1], t['ref'])); n += 1
    print('total overlaps:', n)

"""Label rotations + D4 re-slide. Anchor points unchanged -> connectivity unchanged."""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import re, sys
import schgeom as G, schmove as M

text, root, syms, wires, labels, junctions = G.model()
spans = M.top_level_spans(text)
kinds = {}
for sp in spans:
    kinds.setdefault(M.node_key(text, sp), []).append(sp)
lab_span = kinds.get('label', []) + kinds.get('global_label', []) + kinds.get('hierarchical_label', [])
sym_span = kinds['symbol']
S = {s['ref']: i for i, s in enumerate(syms)}

edits = []   # (span, new_text)
def set_label_rot(li, rot):
    sp = lab_span[li]; seg = text[sp[0]:sp[1]]
    seg2 = re.sub(r'(\(at -?\d+(?:\.\d+)? -?\d+(?:\.\d+)? )(-?\d+(?:\.\d+)?)\)', lambda m: '%s%g)' % (m.group(1), rot), seg, count=1)
    # KiCad also stores justify for labels; flip left/right when rotating 0<->180
    if rot in (0, 180):
        seg2 = seg2.replace('(justify left', '(justify RIGHT_TMP').replace('(justify right', '(justify left').replace('(justify RIGHT_TMP', '(justify right')
    edits.append((sp, seg2))

def label_at(x, y, textv):
    for li, l in enumerate(labels):
        if l['text'] == textv and abs(l['at'][0] - x) < 0.05 and abs(l['at'][1] - y) < 0.05:
            return li
    return None

# 1. R21's TERM_EN (208.28,45.72) rot 90 -> 180
li = label_at(208.28, 45.72, 'TERM_EN'); assert li is not None; set_label_rot(li, 180)
# 2. 3V3_SWITCHED at (201.93,54.61) rot 0 -> 180
li = label_at(201.93, 54.61, '3V3_SWITCHED'); assert li is not None; set_label_rot(li, 180)
# 3. D4 slide +5.08 (232.41 -> 237.49) with both labels; GND label rot 0 -> 180
d4 = syms[S['D4']]; dx = 5.08
edits.append((sym_span[S['D4']], M.translate_span(text, sym_span[S['D4']], dx, 0)))
li = label_at(232.41, 144.78, 'VBAT_IN'); assert li is not None
edits.append((lab_span[li], M.translate_span(text, lab_span[li], dx, 0)))
li = label_at(232.41, 154.94, 'GND'); assert li is not None
sp = lab_span[li]; seg = M.translate_span(text, sp, dx, 0)
seg = re.sub(r'(\(at -?\d+(?:\.\d+)? -?\d+(?:\.\d+)? )(-?\d+(?:\.\d+)?)\)', lambda m: '%s180)' % m.group(1), seg, count=1)
seg = seg.replace('(justify left', '(justify RIGHT_TMP').replace('(justify right', '(justify left').replace('(justify RIGHT_TMP', '(justify right')
edits.append((sp, seg))

edits.sort(key=lambda e: e[0][0], reverse=True)
out = text
for sp, seg in edits:
    out = out[:sp[0]] + seg + out[sp[1]:]
open(G.SCH, 'w', encoding='utf-8', newline='\n').write(out)
print('applied %d edits' % len(edits))

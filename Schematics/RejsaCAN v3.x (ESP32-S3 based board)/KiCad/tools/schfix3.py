"""J1's GND flag (#PWR028) clear of the CAN_H/CAN_L labels: move flag left 7.62 and extend its wire."""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import sys
import schgeom as G, schmove as M
text, root, syms, wires, labels, junctions = G.model()
spans = M.top_level_spans(text)
kinds = {}
for sp in spans: kinds.setdefault(M.node_key(text, sp), []).append(sp)
sym_span = kinds['symbol']; wire_span = kinds['wire']
S = {s['ref']: i for i, s in enumerate(syms)}
edits = [(sym_span[S['#PWR028']], M.translate_span(text, sym_span[S['#PWR028']], -7.62, 0))]
for wi, w in enumerate(wires):
    pts = [(round(a,2), round(b,2)) for a,b in w['pts']]
    if set(pts) == {(255.27, 111.76), (260.35, 111.76)}:
        sp = wire_span[wi]; seg = text[sp[0]:sp[1]].replace('(xy 255.27 111.76)', '(xy 247.65 111.76)')
        edits.append((sp, seg))
edits.sort(key=lambda e: e[0][0], reverse=True)
out = text
for sp, seg in edits: out = out[:sp[0]] + seg + out[sp[1]:]
open(G.SCH, 'w', encoding='utf-8', newline='\n').write(out)
print('schfix3 applied', len(edits))

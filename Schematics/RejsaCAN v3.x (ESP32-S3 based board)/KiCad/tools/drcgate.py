"""Run kicad-cli DRC and summarize. usage: drcgate.py <tag> [--baseline]  (writes <tag>.drc.json)
Prints: errors (by type), warnings count, unconnected count. Exit code 0 always.
"""
import os as _os
_HERE = _os.path.dirname(_os.path.abspath(__file__))
BRD = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_pcb")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import subprocess, json, sys, os, collections
CLI = r"C:\Program Files\KiCad\10.0\bin\kicad-cli.exe"
tag = sys.argv[1]
out = os.path.join(SP, tag + '.drc.json')
r = subprocess.run([CLI, 'pcb', 'drc', '--format', 'json', '--severity-all', '--all-track-errors', '-o', out, BRD], capture_output=True, text=True)
d = json.load(open(out, encoding='utf-8'))
errs = collections.Counter(); warns = collections.Counter()
for v in d['violations']:
    (errs if v['severity'] == 'error' else warns)[v['type']] += 1
unc = d.get('unconnected_items', [])
print('ERRORS %d: %s' % (sum(errs.values()), dict(errs)))
print('WARNINGS %d: %s' % (sum(warns.values()), dict(warns)))
print('UNCONNECTED %d' % len(unc))
for u in unc:
    print('   ', ' <-> '.join('%s @%.2f,%.2f' % (i['description'][:40], i['pos']['x'], i['pos']['y']) for i in u['items']))
if '--show' in sys.argv:
    kinds = sys.argv[sys.argv.index('--show') + 1].split(',')
    for v in d['violations']:
        if v['type'] in kinds:
            print('  ', v['type'], v['description'], '::', ' | '.join(i['description'][:60] + ' @%.2f,%.2f' % (i['pos']['x'], i['pos']['y']) for i in v['items']))

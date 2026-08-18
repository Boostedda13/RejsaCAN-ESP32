"""Export the schematic netlist with kicad-cli and reduce it to {frozenset(pins) -> netname}.
usage: netcheck.py save <tag>   |   netcheck.py compare <tagA> <tagB>
Connectivity is compared as pin-groupings (net names may differ); name diffs reported separately."""
import os as _os, sys as _sys
_HERE = _os.path.dirname(_os.path.abspath(__file__))
_sys.path.insert(0, _HERE)
SCH = _os.path.join(_os.path.dirname(_HERE), "RejsaCAN v3.4 - Schematic.kicad_sch")
SP = _os.environ.get("REJSA_OUT", _os.path.join(_HERE, "out"))
_os.makedirs(SP, exist_ok=True)
import subprocess, sys, os, re, json
CLI = r"C:\Program Files\KiCad\10.0\bin\kicad-cli.exe"

def export(tag):
    out = os.path.join(SP, 'net_%s.xml' % tag)
    r = subprocess.run([CLI, 'sch', 'export', 'netlist', '--format', 'kicadxml', '-o', out, SCH], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout, r.stderr); sys.exit(1)
    return out

def parse(path):
    import xml.etree.ElementTree as ET
    root = ET.parse(path).getroot()
    nets = {}
    for net in root.iter('net'):
        name = net.get('name')
        pins = frozenset('%s.%s' % (n.get('ref'), n.get('pin')) for n in net.findall('node'))
        if len(pins) >= 1:
            nets[pins] = name
    return nets

if __name__ == '__main__':
    cmd = sys.argv[1]
    if cmd == 'save':
        p = export(sys.argv[2]); n = parse(p)
        json.dump({' '.join(sorted(k)): v for k, v in n.items()}, open(os.path.join(SP, 'net_%s.json' % sys.argv[2]), 'w'), indent=0)
        print('saved %d nets' % len(n))
    else:
        a = json.load(open(os.path.join(SP, 'net_%s.json' % sys.argv[2])))
        p = export(sys.argv[3]); b = {' '.join(sorted(k)): v for k, v in parse(p).items()}
        ka, kb = set(a), set(b)
        same = ka == kb
        print('CONNECTIVITY IDENTICAL' if same else 'CONNECTIVITY DIFFERS')
        for k in sorted(ka - kb): print('  only in %s: %s = %s' % (sys.argv[2], a[k], k[:120]))
        for k in sorted(kb - ka): print('  only in %s: %s = %s' % (sys.argv[3], b[k], k[:120]))
        renamed = [(a[k], b[k]) for k in ka & kb if a[k] != b[k]]
        for r in renamed: print('  renamed: %s -> %s' % r)
        sys.exit(0 if same else 1)

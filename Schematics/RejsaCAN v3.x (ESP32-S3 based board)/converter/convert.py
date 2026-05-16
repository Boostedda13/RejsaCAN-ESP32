"""
EasyEDA Standard schematic JSON  ->  Fusion/Eagle 9.x .sch (XML)

Usage:
    python convert.py <input.json> [-o output.sch]
"""
from __future__ import annotations

import argparse
from pathlib import Path

from easyeda_parser import parse, _summary
from eagle_emitter import emit


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("input", help="path to EasyEDA schematic JSON")
    ap.add_argument("-o", "--output", help="output .sch path (default: alongside input)")
    ap.add_argument("--summary", action="store_true", help="print parsed summary")
    args = ap.parse_args(argv)

    in_path = Path(args.input)
    out_path = Path(args.output) if args.output else in_path.with_suffix(".sch")

    sch = parse(in_path)
    if args.summary:
        print(_summary(sch))
        print()

    emit(sch, out_path)
    print(f"Wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

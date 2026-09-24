#!/usr/bin/env python3
"""Acceptance check for the compiler-generated conductive entry.

Usage:
  bend conductive_entry_smoke.bend --to-hvm4-full > /tmp/conductive.hvm4
  python3 check_conductive_entry.py /tmp/conductive.hvm4

The source contains no fibre import/call. The full target itself must supply
and attach the canonical lossless process.
"""
import pathlib, sys

s = pathlib.Path(sys.argv[1]).read_text()
required = [
    "@cfDescend =",
    "@cfCoalgebra =",
    "@cfObserve =",
    "@cfObservedValue =",
    "@conductiveWholeMain = @cfCoalgebra(",
    "@conductiveMain = @cfObservedValue(",
    "@main =",
]
missing = [x for x in required if x not in s]
if missing:
    raise SystemExit("missing conductive compiler output:\n  " + "\n  ".join(missing))
print("conductive compiler entry: OK")

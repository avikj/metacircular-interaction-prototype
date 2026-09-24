#!/usr/bin/env python3
"""Static acceptance check for the first language-level conductive bridge.

Run after applying cubical-paths.patch to the Bend2 fork:

  bend conductive_entry_smoke.bend --to-hvm4-full > /tmp/conductive.hvm4
  python3 check_conductive_entry.py /tmp/conductive.hvm4

This does not substitute for running the HVM4 net; it checks that the compiler,
not application source, generated the canonical whole-process entry.
"""
import pathlib, sys

p = pathlib.Path(sys.argv[1])
s = p.read_text()
needle = "@__whole_main = @fibreCoalgebra"
if needle not in s:
    raise SystemExit(f"missing compiler-generated conductive entry: {needle}")
if "@main = " not in s:
    raise SystemExit("ordinary main missing")
print("conductive entry emitted")

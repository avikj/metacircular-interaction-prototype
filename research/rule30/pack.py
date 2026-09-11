#!/usr/bin/env python3
"""pack.py <module.agda> [expr ...] -> one wire request line on stdout.
With no expressions: a sadhana.patra request.  With expressions: sadhana.vislesana."""
import json, sys
lines = open(sys.argv[1]).read().split('\n')
if lines and lines[-1] == '': lines = lines[:-1]
exprs = sys.argv[2:]
if exprs:
    print(json.dumps({"kriya": "sadhana.vislesana", "angani": {"patra": lines, "padani": exprs}}, ensure_ascii=False))
else:
    print(json.dumps({"kriya": "sadhana.patra", "angani": {"patra": lines}}, ensure_ascii=False))

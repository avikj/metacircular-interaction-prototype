#!/usr/bin/env python3
"""Invert the kernel reference data: for each declaration, who uses it.

The presentation principle this serves: multiplicity is always the fibre
of something. "N modules import M" is unpresentable multiplicity; "these
modules rest on M.foo, those on M.bar" is structure. This index makes
the fibre of the use-relation over each declaration available to the
reader, sharded by the declaration's area for lazy loading.

Output: ide/store/uses/<area>.json
  { qualified-decl-name: [[user-module, count], ...] (desc by count) }
Route: kernel — inverted from identity/ (references extracted from
elaborated terms).
"""
from __future__ import annotations

import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"
OUT = STORE / "uses"


def main() -> int:
    idx = json.loads((STORE / "index.json").read_text())
    area_of_mod = {n["m"]: n["area"] for n in idx["nodes"]}
    mods = sorted(area_of_mod, key=len, reverse=True)

    def module_of(qname: str) -> str | None:
        for m in mods:
            if qname == m or qname.startswith(m + "."):
                return m
        return None

    uses: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    for f in sorted((STORE / "identity").glob("*.json")):
        if f.name == "_failures.json":
            continue
        for mod, decls in json.loads(f.read_text()).items():
            for _name, rec in decls.items():
                for r in rec["refs"]:
                    tm = module_of(r)
                    if tm and tm != mod:
                        uses[r][mod] += 1

    by_area: dict[str, dict] = defaultdict(dict)
    for qname, users in uses.items():
        tm = module_of(qname)
        if not tm:
            continue
        akey = re.sub(r"[^A-Za-z0-9_-]", "_", area_of_mod.get(tm, "misc"))
        by_area[akey][qname] = sorted(users.items(), key=lambda kv: -kv[1])[:60]

    OUT.mkdir(exist_ok=True)
    for akey, table in by_area.items():
        (OUT / f"{akey}.json").write_text(
            json.dumps(table, ensure_ascii=False), encoding="utf-8")
    total = sum(len(t) for t in by_area.values())
    print(f"use-fibres over {total} declarations in {len(by_area)} shards")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

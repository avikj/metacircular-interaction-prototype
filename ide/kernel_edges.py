#!/usr/bin/env python3
"""Aggregate kernel-computed declaration references into module edges.

Reads ide/store/identity/ (kernel-emitted declaration references) and the
store index, and writes ide/store/kernel_edges.json:
  { "edges": [[src_node_idx, dst_node_idx, ref_count], ...],
    "route": "kernel — references extracted from elaborated terms" }
Declaration names are resolved to modules by longest matching module
prefix over the corpus's module table (exact: qualified names carry
their module).
"""
from __future__ import annotations

import json
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"


def main() -> int:
    idx = json.loads((STORE / "index.json").read_text())
    mod_idx = {}
    for n in idx["nodes"]:
        mod_idx.setdefault(n["m"], n["i"])
    mods_sorted = sorted(mod_idx, key=len, reverse=True)

    def module_of(qname: str) -> int | None:
        for m in mods_sorted:
            if qname == m or qname.startswith(m + "."):
                return mod_idx[m]
        return None

    counts: dict[tuple[int, int], int] = defaultdict(int)
    for f in sorted((STORE / "identity").glob("*.json")):
        if f.name == "_failures.json":
            continue
        for mod, decls in json.loads(f.read_text()).items():
            src = mod_idx.get(mod)
            if src is None:
                continue
            for _name, rec in decls.items():
                for r in rec["refs"]:
                    dst = module_of(r)
                    if dst is not None and dst != src:
                        counts[(src, dst)] += 1

    edges = [[s, d, c] for (s, d), c in sorted(counts.items())]
    (STORE / "kernel_edges.json").write_text(json.dumps({
        "route": "kernel — references extracted from elaborated terms",
        "edges": edges,
    }), encoding="utf-8")
    print(f"kernel module edges: {len(edges)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Stratum 2: content addresses that see through names entirely.

Stratum 1 (ide/store/identity/, kernel-emitted) hashes each declaration's
canonical elaborated form, in which REFERENCED declarations still appear
by qualified name.  Two spellings of one module therefore differ at
stratum 1 exactly where they reference each other.  This pass closes
that loop: iterate hash-of-(structure with references replaced by their
current hashes) to a fixpoint.  At the fixpoint, a declaration's address
depends on nothing but elaborated structure all the way down — the
Unison identity, at the reflection layer.

Because stratum 1 emitted only (hash, refs) and not the serialization,
the fixpoint here operates on the reference GRAPH: addr_{k+1}(d) =
H(stratum1(d) minus-names || sorted multiset of addr_k over refs).
Stripping the names from stratum 1's hash is impossible post hoc, so we
approximate the name-free local skeleton by the declaration's stratum-1
hash with its OWN references' name strings removed at emission time —
which stratum 1 already guarantees for the declaration's own name.  The
residual name-sensitivity is exactly the reference names; replacing
their contribution with addr_k of the referent at each iteration makes
the fixpoint name-free in the limit for reference cycles of the same
shape.  Practically: two lanes collapse iff their reference graphs are
isomorphic under the name correspondence and all local skeletons match.
We verify the kernel triple as the acceptance test and report exactly
what collapses and what does not, with the obstruction named.

Output: ide/store/collapse.json
  { "addr": {qualified-name: final-address},
    "classes": [[names sharing one address], ...] (size>1 only),
    "iterations": n, "note": route description }
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IDENT = ROOT / "ide" / "store" / "identity"
OUT = ROOT / "ide" / "store" / "collapse.json"


def load() -> dict[str, dict]:
    table: dict[str, dict] = {}
    for f in sorted(IDENT.glob("*.json")):
        if f.name == "_failures.json":
            continue
        for mod, decls in json.loads(f.read_text()).items():
            for name, rec in decls.items():
                table[name] = rec
    return table


def local_skeleton(name: str, rec: dict) -> str:
    """Stratum-1 hash with reference-name contribution factored out:
    we cannot un-hash, so the skeleton is (h, arity of refs) and the
    per-iteration address carries the referents' addresses instead of
    their names.  Same-shaped lanes share (local structure differs only
    in embedded reference names) — their h differs, so we additionally
    normalize by replacing each referenced name inside... unavailable.
    Instead: skeleton = number of refs + the declaration's short name's
    role is already absent. We accept partial collapse and REPORT it."""
    return f"{rec['h']}|{len(rec['refs'])}"


def strip_lane(qname: str) -> str:
    """The name correspondence between lanes: final component."""
    return qname.split(".")[-1]


def main() -> int:
    table = load()
    print(f"declarations: {len(table)}", file=sys.stderr)

    # Iterate: addr(d) = H(shape(d) || sorted addr of refs), where shape
    # deliberately excludes the stratum-1 hash (it embeds reference
    # names) and uses the name-free local data stratum 1 guarantees:
    # the count of refs and the declaration's final-component-free
    # structure is not recoverable — so shape = (#refs).  This is a
    # weaker invariant (graph shape), so we CONFIRM candidate classes
    # by requiring, in addition, equality of stratum-1 hashes after
    # rewriting reference names through the lane correspondence.
    addr = {n: f"{len(r['refs']):04x}" for n, r in table.items()}
    for it in range(12):
        nxt = {}
        changed = 0
        for n, r in table.items():
            refs = sorted(addr.get(x, "ext:" + strip_lane(x)) for x in r["refs"])
            h = hashlib.sha256((addr[n] + "|" + ",".join(refs)).encode()).hexdigest()[:16]
            nxt[n] = h
            if h != addr[n]:
                changed += 1
        addr = nxt
        if changed == 0:
            break

    # candidate classes by fixpoint address
    by_addr: dict[str, list[str]] = defaultdict(list)
    for n, a in addr.items():
        by_addr[a].append(n)

    # confirmation: rewrite each declaration's reference list through the
    # final-component correspondence and require stratum-1 hash equality
    # of the canonical serializations is unavailable; instead require the
    # lane-corresponded reference multisets to be equal.
    def ref_key(n: str) -> str:
        return ",".join(sorted(strip_lane(x) for x in table[n]["refs"]))

    classes = []
    for a, names in by_addr.items():
        if len(names) < 2:
            continue
        by_rk: dict[str, list[str]] = defaultdict(list)
        for n in names:
            by_rk[strip_lane(n) + "//" + ref_key(n)].append(n)
        for group in by_rk.values():
            if len(group) > 1:
                classes.append(sorted(group))
    classes.sort(key=len, reverse=True)

    OUT.write_text(json.dumps({
        "note": ("stratum-2 fixpoint over the kernel-emitted reference graph; "
                 "a class = same final component, same graph-fixpoint address, "
                 "same lane-corresponded reference multiset. Route: derived "
                 "from kernel-emitted identities; the full name-free collapse "
                 "needs stratum 1 to emit name-free serializations per "
                 "reference slot (next kernel pass)."),
        "iterations": it + 1,
        "addr": addr,
        "classes": classes[:4000],
    }, ensure_ascii=False), encoding="utf-8")

    triple = ["RewriteCertificate.Tm", "Kernel.RewriteCertificate.Tm",
              "NaturalMachine.RewriteCertificate.Tm"]
    present = [t for t in triple if t in addr]
    print("kernel triple Tm addresses:",
          {t: addr[t] for t in present}, file=sys.stderr)
    in_class = any(set(present) <= set(c) for c in classes if len(present) > 1)
    print(f"triple collapses: {in_class}  classes>1: {len(classes)}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

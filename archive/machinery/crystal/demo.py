#!/usr/bin/env python3
"""The seed loop, run end to end, with the ledger printed.

Acceptance test, stated before it is run so it can fail:

    Mathematics enters the runtime as three axioms. The runtime discovers
    and verifies new structural relationships on its own, compiles them
    into reusable transformations, and thereby makes INDEPENDENT later
    problems -- problems never seen during compilation, and not used to
    produce any rule -- measurably cheaper to decide.

The theory is group theory in its minimal presentation: associativity, a
LEFT identity, and a LEFT inverse. Right identity and right inverse are
not assumed; they are theorems, and the runtime has to find them. This is
the classical Knuth-Bendix benchmark, chosen because the answer is known
independently, so a wrong result here is visible rather than plausible.

Run:  python3 machinery/crystal/demo.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import (  # noqa: E402
    LPO,
    Completion,
    Ledger,
    mk,
    search_equal,
    var,
)

# ---------------------------------------------------------------- signature
E = mk("e")


def op(a, b):
    return mk("*", a, b)


def inv(a):
    return mk("i", a)


x, y, z_ = var("x"), var("y"), var("z")

# Three axioms. Nothing else is given.
AXIOMS = [
    ("assoc", op(op(x, y), z_), op(x, op(y, z_))),
    ("left-identity", op(E, x), x),
    ("left-inverse", op(inv(x), x), E),
]

# Independent problems: fixed here, before compilation, and never consulted
# by the completion loop. Each is a true identity in every group.
a, b, c = mk("a"), mk("b"), mk("c")
PROBLEMS = [
    ("right inverse", op(a, inv(a)), E),
    ("right identity", op(a, E), a),
    ("double inverse", inv(inv(a)), a),
    ("inverse of a product", inv(op(a, b)), op(inv(b), inv(a))),
    ("inverse of the identity", inv(E), E),
    ("left cancellation", op(inv(a), op(a, b)), b),
    ("right cancellation", op(op(a, b), inv(b)), a),
    ("triple inverse", inv(inv(inv(a))), inv(a)),
    ("product with its reverse inverse", op(op(a, b), op(inv(b), inv(a))), E),
    ("inverse of a triple product", inv(op(a, op(b, c))),
     op(inv(c), op(inv(b), inv(a)))),
]

SEARCH_BUDGET = 60_000


def main() -> int:
    print("=" * 74)
    print("MATHEMATICAL RUNTIME -- seed loop")
    print("=" * 74)
    print("\nAxioms entering the runtime:")
    for name, l, r in AXIOMS:
        print(f"  {name:16s}  {l!r} = {r!r}")

    # ---------------------------------------------------------------- BEFORE
    print("\n" + "-" * 74)
    print("BEFORE  -- deciding each problem from the raw axioms, by search.")
    print("          Nothing is remembered between problems: this is what an")
    print("          uncompiled theory costs every time it is used.")
    print("-" * 74)
    before = {}
    total_before = 0
    unsolved_before = 0
    for name, l, r in PROBLEMS:
        ok, nodes = search_equal(l, r, AXIOMS, max_nodes=SEARCH_BUDGET)
        before[name] = (ok, nodes)
        total_before += nodes
        if not ok:
            unsolved_before += 1
        status = "proved" if ok else f"NOT FOUND within {SEARCH_BUDGET:,}"
        print(f"  {name:34s} {nodes:>9,} nodes   {status}")
    print(f"  {'TOTAL':34s} {total_before:>9,} nodes"
          f"   ({unsolved_before}/{len(PROBLEMS)} undecided)")

    # ----------------------------------------------------------------- COMPILE
    print("\n" + "-" * 74)
    print("COMPILE -- the runtime overlaps its own accepted transformations,")
    print("           finds where they disagree, and compiles each residual")
    print("           into a new rule carrying its derivation.")
    print("-" * 74)
    ledger = Ledger()
    comp = Completion(LPO(["i", "*", "e"]), ledger)
    rules = comp.run(AXIOMS)

    print(f"\n  critical pairs examined : {ledger.critical_pairs_examined:,}")
    print(f"  rules derived           : {ledger.rules_derived}")
    print(f"  rules retired as redundant: "
          f"{sum(1 for k, _ in ledger.events if k == 'retired')}")
    print(f"  rewrite steps spent     : {ledger.rewrite_steps:,}")
    print(f"\n  Compiled system ({len(rules)} rules):")
    for r in rules:
        origin = r.origin[0]
        print(f"    {r.lhs!r:28s} -> {r.rhs!r:22s}   [{origin}]")

    derived = [r for r in rules if r.origin[0] != "axiom"]
    print(f"\n  {len(derived)} of these were not given. They are theorems the")
    print("  runtime found, verified, and turned into executable rewrites.")

    # ------------------------------------------------------------------ AFTER
    print("\n" + "-" * 74)
    print("AFTER   -- the same independent problems, decided by normalising")
    print("           in the compiled system. No search.")
    print("-" * 74)
    total_after = 0
    failures = []
    for name, l, r in PROBLEMS:
        ok, steps = comp.decides(l, r)
        total_after += steps
        if not ok:
            failures.append(name)
        was = before[name]
        if was[0]:
            speed = f"{was[1] / max(steps, 1):>10,.0f}x cheaper"
        else:
            speed = "  was undecided"
        print(f"  {name:34s} {steps:>9} steps   "
              f"{'decided' if ok else 'FAILED':8s} {speed}")
    print(f"  {'TOTAL':34s} {total_after:>9} steps")

    # ------------------------------------------------------------ NULL CONTROL
    # Required by runtime/CRYSTAL.md §0 (sibling branch, arrived at
    # independently): "a runtime that speeds everything up is measuring its
    # own cache, not its mathematics." Enter a TRUE theory over a disjoint
    # signature. It must not move a single step count.
    print("\n" + "-" * 74)
    print("NULL CONTROL -- an unrelated true theory enters. If the ledger is")
    print("               measuring mathematics rather than caching, these")
    print("               step counts must not move at all.")
    print("-" * 74)
    zero, plus = mk("z"), lambda p, q: mk("+", p, q)
    unrelated = AXIOMS + [
        ("unrelated-assoc", plus(plus(x, y), z_), plus(x, plus(y, z_))),
        ("unrelated-unit", plus(zero, x), x),
    ]
    comp2 = Completion(LPO(["i", "*", "e", "+", "z"]), Ledger())
    comp2.run(unrelated)
    moved = []
    for name, l, r in PROBLEMS:
        ok2, steps2 = comp2.decides(l, r)
        _, steps1 = comp.decides(l, r)
        if not ok2 or steps2 != steps1:
            moved.append(f"{name}: {steps1} -> {steps2}")
    if moved:
        print("  NULL CONTROL FAILED -- unrelated mathematics changed the cost:")
        for m in moved:
            print(f"    {m}")
        return 1
    print(f"  {len(PROBLEMS)}/{len(PROBLEMS)} step counts unchanged, all still decided.")
    print("  The unrelated theory compiled to its own rules and touched none")
    print("  of these problems. The reduction above is attributable to the")
    print("  group theorems, not to having compiled something.")

    # ----------------------------------------------------------------- VERDICT
    print("\n" + "=" * 74)
    if failures:
        print("ACCEPTANCE TEST FAILED -- undecided after compilation:")
        for f in failures:
            print(f"  - {f}")
        return 1
    ratio = total_before / max(total_after, 1)
    print("ACCEPTANCE TEST PASSED")
    print(f"  every one of the {len(PROBLEMS)} independent problems is now decided;")
    print(f"  {unsolved_before} of them were beyond the search budget before.")
    print(f"  total cost {total_before:,} nodes -> {total_after} steps "
          f"({ratio:,.0f}x).")
    print()
    print("  The improvement is not a faster search. The search is gone.")
    print("  Three axioms went in; the runtime found the missing theorems,")
    print("  compiled them into transformations, and the class of problems")
    print("  that used to require unbounded search now terminates by")
    print("  normalisation. Proving something changed the cost of everything")
    print("  downstream of it. That is the whole claim, and it is measured")
    print("  above rather than argued.")
    print("=" * 74)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

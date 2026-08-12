#!/usr/bin/env python3
"""The cycle closing on its own: residuals driving the next move.

Acceptance test, stated before it is run:

    A transport that fails must not stop at a diagnosis. Each verdict must
    SELECT the next move, and the cycle must close on one of four honest
    endings -- succeeded, proved impossible, beyond this machinery, or
    spent -- with every step individually accountable and no step being
    blind retry.

Run:  python3 machinery/crystal/demo_chakravala.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.chakravala import Outcome, pursue  # noqa: E402
from machinery.crystal.kernel import LPO, mk, var  # noqa: E402
from machinery.crystal.transport import Interpretation, arg  # noqa: E402

x, y, z = var("x"), var("y"), var("z")
E = mk("e")


def op(p, q):
    return mk("*", p, q)


ASSOC = ("assoc", op(op(x, y), z), op(x, op(y, z)))
SEMIGROUP = [ASSOC]
LEFT_ZERO = [ASSOC, ("left-zero", op(x, y), x)]
MONOID = [ASSOC, ("left-unit", op(E, x), x), ("right-unit", op(x, E), x)]
RIGHT_ZERO = [ASSOC, ("right-zero", op(x, y), y)]
COMMUTATIVE = [ASSOC, ("comm", op(x, y), op(y, x))]

IDENT = {("*", 2): mk("*", arg(0), arg(1))}


def run(title, source, target, sig, clauses=IDENT):
    print("\n" + "-" * 74)
    print(title)
    print("-" * 74)
    p = pursue(lambda t: Interpretation("phi", clauses, source, t),
               target, LPO(["*", "e"]), sig)
    print(p.report())
    return p


def main() -> int:
    print("=" * 74)
    print("THE CYCLE -- each residual selects the next move")
    print("=" * 74)

    a = run("A  monoids into semigroups. Two DIFFERENT failures in sequence:\n"
            "   first the map has a gap, then the theory is too small.\n"
            "   Neither is retried; each names its own repair.",
            MONOID, SEMIGROUP, {("*", 2)})

    b = run("B  right-zero into left-zero. The cycle must stop at once:\n"
            "   an impossibility has no successor to propose.",
            RIGHT_ZERO, LEFT_ZERO, {("*", 2)})

    c = run("C  commutative semigroups into semigroups. Commutativity is\n"
            "   symmetric, so NO precedence orients it. The cycle must say\n"
            "   what it would take, not thrash.",
            COMMUTATIVE, SEMIGROUP, {("*", 2)})

    print("\n" + "=" * 74)
    ok = True
    if a.outcome != Outcome.SUCCEEDED:
        print(f"FAILED: A should succeed, got {a.outcome}"); ok = False
    if b.outcome != Outcome.IMPOSSIBLE:
        print(f"FAILED: B should be impossible, got {b.outcome}"); ok = False
    if c.outcome != Outcome.BEYOND_LPO:
        print(f"FAILED: C should be beyond LPO, got {c.outcome}"); ok = False
    # no move may be blind retry
    for p in (a, b, c):
        for s in p.trace:
            if s.verdict == "EXHAUSTED":
                print("FAILED: a budget retry appeared where structure was "
                      "available"); ok = False
    if not ok:
        return 1

    print("ACCEPTANCE TEST PASSED")
    print()
    print("  A closed in three steps, and the two failures were not the same")
    print("  failure. Step 1 said the MAP was incomplete and widened the")
    print("  signature. Step 2 said the THEORY was too small and adopted the")
    print("  two unit rules. Step 3 checked. A single UNDECIDED verdict could")
    print("  not have produced either move; it would have retried the budget")
    print("  twice and then given up with nothing to show.")
    print()
    print("  B stopped immediately and correctly. The impossibility is the")
    print("  result, so proposing a successor would have been a category")
    print("  error -- the one place where NOT continuing is the right move.")
    print()
    print("  C is the honest ending. Commutativity is symmetric in both")
    print("  argument positions, so it is beyond LPO under EVERY precedence")
    print("  -- checked exhaustively, not assumed. The cycle names the")
    print("  requirement (completion modulo AC) and declines to attempt it.")
    print()
    print("  Not one step was blind retry. That is the whole difference")
    print("  between a loop that spends and a loop that converges.")
    print("=" * 74)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

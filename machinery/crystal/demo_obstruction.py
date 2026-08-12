#!/usr/bin/env python3
"""A failed transport, read as mathematics.

Where two paths give the same result you have a commuting square. Where
they do not you have a defect -- and the defect is the seed of new
mathematics, not an error to discard.

Acceptance test, stated before it is run:

    A map that FAILS to be an interpretation must not merely be rejected.
    Its residual must be classified, and the classification must produce a
    true mathematical statement that was not put in by hand.

Three maps are offered, one per verdict. The first two answers are checkable
facts about semigroups, and neither was supplied to the machine: it derived
each by completing the theory the failed map would have needed.

Run:  python3 machinery/crystal/demo_obstruction.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import LPO, Completion, mk, var  # noqa: E402
from machinery.crystal.obstruction import Verdict, obstruction_of  # noqa: E402
from machinery.crystal.transport import Interpretation, arg  # noqa: E402

x, y, z = var("x"), var("y"), var("z")
E = mk("e")


def op(p, q):
    return mk("*", p, q)


ASSOC = ("assoc", op(op(x, y), z), op(x, op(y, z)))
LEFT_ZERO = [ASSOC, ("left-zero", op(x, y), x)]
RIGHT_ZERO = [ASSOC, ("right-zero", op(x, y), y)]
SEMIGROUP = [ASSOC]
MONOID = [ASSOC, ("left-unit", op(E, x), x), ("right-unit", op(x, E), x)]

IDENTITY_MAP = {("*", 2): mk("*", arg(0), arg(1))}
REVERSING_MAP = {("*", 2): mk("*", arg(1), arg(0))}


POINTED = {("*", 2), ("e", 0)}


def case(title, target_axioms, order, source_axioms, clauses, name,
         sig=None, budget=None):
    print("\n" + "-" * 74)
    print(title)
    print("-" * 74)
    target = Completion(order)
    target.run(target_axioms)
    interp = Interpretation(name, clauses, source_axioms, target)
    if interp.check():
        print("  the map CHECKS — no obstruction; nothing invisible to map.")
        return None
    obs = obstruction_of(interp, target_axioms, order, sig)
    if budget:
        obs.classify(max_rules=budget[0], max_rounds=budget[1])
    print("  " + obs.report().replace("\n", "\n  "))
    return obs


def main() -> int:
    print("=" * 74)
    print("OBSTRUCTION -- the map of what a transport could not see")
    print("=" * 74)

    order = LPO(["*", "e"])

    a = case(
        "CASE 1  right-zero semigroups --identity--> left-zero semigroups.\n"
        "        The map is mistyped (it should reverse). transport.py\n"
        "        rejects it and discards it. What was thrown away?",
        LEFT_ZERO, order, RIGHT_ZERO, IDENTITY_MAP, "identity (mistyped)")

    b = case(
        "CASE 2  monoids --identity--> semigroups. The map fails, because a\n"
        "        semigroup need not have a unit. But nothing is wrong here.",
        SEMIGROUP, order, MONOID, IDENTITY_MAP, "identity", sig=POINTED)

    d = case(
        "CASE 3  commutative semigroups --identity--> semigroups. The\n"
        "        obstruction is commutativity, which no reduction order can\n"
        "        orient. The machine must say so, not guess.",
        SEMIGROUP, order,
        [ASSOC, ("comm", op(x, y), op(y, x))], IDENTITY_MAP, "identity")

    e_ = case(
        "CASE 4  the same monoid map, starved of budget. A budget failure\n"
        "        must not read as a representation failure.",
        SEMIGROUP, order, MONOID, IDENTITY_MAP, "identity",
        sig=POINTED, budget=(60, 1))

    f_ = case(
        "CASE 5  a source symbol the map does not send and the target does\n"
        "        not have. This is not mathematics; it is a gap in the map.",
        SEMIGROUP, order,
        [ASSOC, ("foreign", mk("@", x), x)], IDENTITY_MAP, "identity")

    c = case(
        "CASE 6  right-zero --reversing--> left-zero. The correctly typed\n"
        "        map, for contrast.",
        LEFT_ZERO, order, RIGHT_ZERO, REVERSING_MAP, "anti-isomorphism")

    # ------------------------------------------------------------- verdict
    print("\n" + "=" * 74)
    ok = True
    if a is None or a.verdict is not Verdict.FATAL:
        print("FAILED: case 1 should be FATAL"); ok = False
    if b is None or b.verdict is not Verdict.EXTENDS:
        print("FAILED: case 2 should be EXTEND"); ok = False
    if d is None or d.verdict is not Verdict.UNORIENTABLE:
        print("FAILED: case 3 should be UNORIENTABLE"); ok = False
    if e_ is None or e_.verdict is not Verdict.EXHAUSTED:
        print("FAILED: case 4 should be EXHAUSTED"); ok = False
    if f_ is None or f_.verdict is not Verdict.OUT_OF_SCOPE:
        print("FAILED: case 5 should be OUT_OF_SCOPE"); ok = False
    if c is not None:
        print("FAILED: case 6 should have no obstruction"); ok = False
    if not ok:
        return 1

    print("ACCEPTANCE TEST PASSED")
    print()
    print("  Case 1's verdict is a theorem the machine was not told:")
    print("    a semigroup that is both left-zero and right-zero satisfies")
    print("    x = x*y = y, so it has exactly one element.")
    print("  The failed transport did not merely fail. It computed the exact")
    print("  reason the two theories cannot be glued, and the reason is a")
    print("  fact about semigroups.")
    print()
    print("  Case 2's verdict is the complementary shape: the map is not an")
    print("  interpretation into semigroups, but it IS one into semigroups")
    print("  plus the two unit rules -- and the machine named those rules.")
    print("  A failure that identifies the larger theory is not a failure.")
    print()
    print("  Cases 3-5 are the typed zero. An earlier version merged them")
    print("  into one UNDECIDED, and mutation testing found that merge")
    print("  before the reason for it was understood: the mutant deleting")
    print("  the budget check SURVIVED, because a budget failure and a")
    print("  representation failure were the same value. They are not the")
    print("  same fact and they license opposite next actions --")
    print("    UNORIENTABLE : change the ORDER; more budget is certain waste")
    print("    EXHAUSTED    : spend more; nothing is claimed about existence")
    print("    OUT_OF_SCOPE : fix the MAP; there is no mathematics here")
    print()
    print("  Same machinery, six outcomes, none of them discarded.")
    print("  An obstruction is a map of what could not be seen.")
    print("=" * 74)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

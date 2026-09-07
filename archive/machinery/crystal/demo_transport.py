#!/usr/bin/env python3
"""Transport: a theory decided without ever being compiled.

Acceptance test, stated before it is run:

    A second theory enters. It is never compiled. A single map is declared
    and checked once, and every problem in the new theory is then decided
    by the OLD theory's compiled system.

    The map must be an ANTI-isomorphism, reversing products. Declaring it
    as a plain isomorphism must be REJECTED by the kernel rather than
    quietly giving wrong answers. That rejection is the whole point of the
    edge carrying a type.

A note on how this test got here, because the first version of it was
wrong and the kernel is what caught it. The obvious example is groups:
compile the left-axiom presentation, transport the right-axiom one. The
kernel accepted the *mistyped* identity map, which looked like a bug and
was not. Group theory is self-dual -- the completed left theory proves
right identity and right inverse outright, so the identity map really is a
valid interpretation, and the anti-isomorphism is not needed. The example
could not demonstrate what it claimed. Demonstrating that the type matters
requires a theory that is NOT self-dual, which is what runs below.

Run:  python3 machinery/crystal/demo_transport.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from machinery.crystal.kernel import (  # noqa: E402
    LPO, Completion, Ledger, mk, var,
)
from machinery.crystal.transport import Interpretation, arg  # noqa: E402

x, y, z = var("x"), var("y"), var("z")
a, b, c = mk("a"), mk("b"), mk("c")


def op(p, q):
    return mk("*", p, q)


# Left-zero semigroups: a product is always its LEFT factor.
LEFT_ZERO = [
    ("assoc", op(op(x, y), z), op(x, op(y, z))),
    ("left-zero", op(x, y), x),
]

# Right-zero semigroups: a product is always its RIGHT factor. A genuinely
# different theory -- these two are not isomorphic, only anti-isomorphic.
RIGHT_ZERO = [
    ("assoc", op(op(x, y), z), op(x, op(y, z))),
    ("right-zero", op(x, y), y),
]

PROBLEMS = [
    ("a*b = b", op(a, b), b),
    ("(a*b)*c = c", op(op(a, b), c), c),
    ("a*(b*c) = c", op(a, op(b, c)), c),
    ("((a*b)*c)*a = a", op(op(op(a, b), c), a), a),
    ("a*(b*(c*b)) = b", op(a, op(b, op(c, b))), b),
]

# False in right-zero semigroups. Must be refused, or transport is worthless.
CONTROLS = [
    ("a*b = a", op(a, b), a),
    ("(a*b)*c = a", op(op(a, b), c), a),
]


def main() -> int:
    print("=" * 74)
    print("TRANSPORT -- deciding a theory that was never compiled")
    print("=" * 74)

    ledger = Ledger()
    target = Completion(LPO(["*"]), ledger)
    target.run(LEFT_ZERO)
    print("\nTarget theory compiled once: LEFT-zero semigroups.")
    for r in target.rules:
        print(f"    {r.lhs!r} -> {r.rhs!r}")
    print(f"  ({ledger.critical_pairs_examined} critical pairs examined; "
          f"associativity was absorbed and retired)")

    print("\nSource theory arriving, never compiled: RIGHT-zero semigroups.")
    for name, l, r in RIGHT_ZERO:
        print(f"  {name:12s}  {l!r} = {r!r}")

    # ---------------------------------------------------- the wrong edge type
    print("\n" + "-" * 74)
    print("The map declared with the WRONG type -- a plain isomorphism,")
    print("not reversing products.")
    print("-" * 74)
    wrong = Interpretation(
        name="identity map (mistyped)",
        clauses={("*", 2): mk("*", arg(0), arg(1))},
        source_axioms=RIGHT_ZERO,
        target=target,
    )
    if wrong.check():
        print("  BUG: a mistyped map was accepted.")
        return 1
    print("  accepted: False")
    for name, l, r in wrong.failures:
        print(f"  REJECTED on axiom {name!r}: {l!r} = {r!r} translates to")
        print(f"      {wrong.apply(l)!r} = {wrong.apply(r)!r}, "
              "which the target does not prove.")
    print("\n  This is the load-bearing rejection. The mistyped map is the")
    print("  identity on terms, so had the kernel accepted it, every")
    print("  right-zero problem would have been answered by asking the")
    print("  left-zero theory a different question -- and 'a*b = b' would")
    print("  have come back false.")

    # ------------------------------------------------------- the right edge
    print("\n" + "-" * 74)
    print("The correctly typed map: an ANTI-isomorphism.  phi(x*y) = phi(y)*phi(x)")
    print("-" * 74)
    opp = Interpretation(
        name="opposite-semigroup anti-isomorphism",
        clauses={("*", 2): mk("*", arg(1), arg(0))},   # <- the reversal
        source_axioms=RIGHT_ZERO,
        target=target,
    )
    if not opp.check():
        for name, l, r in opp.failures:
            print(f"  failed on {name}: {l!r} = {r!r}")
        return 1
    print(f"  accepted: True   (checked in {opp.cost_to_check} rewrite steps)")
    print("  Every axiom of the new theory became a theorem of the compiled")
    print("  one. The edge is checked, and may now be used.")

    # ------------------------------------------------------------- transport
    print("\n" + "-" * 74)
    print("Problems in the NEW theory, decided by the OLD theory's system.")
    print("Compilation cost for the new theory: zero.")
    print("-" * 74)
    total = 0
    bad = []
    for name, l, r in PROBLEMS:
        decided, steps = opp.decides(l, r)
        total += steps
        print(f"  {name:20s} {steps:>3} steps  "
              f"{'decided' if decided else 'FAILED':8s}"
              f"  via {opp.apply(l)!r} = {opp.apply(r)!r}")
        if not decided:
            bad.append(name)

    print("\n  Controls -- false in right-zero semigroups, must be refused:")
    for name, l, r in CONTROLS:
        decided, _ = opp.decides(l, r)
        print(f"  {name:20s}      {'DECIDED (BUG)' if decided else 'correctly refused'}")
        if decided:
            bad.append(f"control {name}")

    print("\n" + "=" * 74)
    if bad:
        print("ACCEPTANCE TEST FAILED:", ", ".join(bad))
        return 1
    print("ACCEPTANCE TEST PASSED")
    print(f"  {len(PROBLEMS)} problems in an uncompiled theory decided in "
          f"{total} steps total,")
    print(f"  on the strength of one map checked once in {opp.cost_to_check} "
          "steps.")
    print()
    print("  The new theory's compilation cost was not reduced. It was never")
    print("  paid. A theorem proved about one structure became executable")
    print("  about another because a checked map connects them -- which is")
    print("  the only reason to keep a typed graph rather than a rule list.")
    print()
    print("  And the type did work: the same map with the reversal dropped")
    print("  was rejected, not silently wrong.")
    print("=" * 74)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

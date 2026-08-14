"""A library of small equational theories, and the maps between them.

The engine's raw material. Every theory here is finitely presented by
equations over a small signature, so the kernel can actually compile it and
the obstruction machinery can actually classify failures between them.

These are deliberately *known* theories. The interpretability relations
among them are, in many cases, classical — which is the point: an engine
that produces a map of them can be checked against an external answer
rather than against its own output.
"""

from __future__ import annotations

from machinery.crystal.kernel import mk, var

x, y, z = var("x"), var("y"), var("z")
E = mk("e")
Z = mk("0")


def op(p, q):
    return mk("*", p, q)


def inv(p):
    return mk("i", p)


def f(p):
    return mk("f", p)


ASSOC = ("assoc", op(op(x, y), z), op(x, op(y, z)))
COMM = ("comm", op(x, y), op(y, x))
IDEM = ("idem", op(x, x), x)
LUNIT = ("left-unit", op(E, x), x)
RUNIT = ("right-unit", op(x, E), x)
LINV = ("left-inverse", op(inv(x), x), E)
RINV = ("right-inverse", op(x, inv(x)), E)

#: name -> (axioms, declared signature)
#:
#: The signature is DECLARED, never inferred: a theory may name a symbol its
#: axioms do not constrain (a pointed semigroup has `e` and says nothing
#: about it), and inferring would silently misclassify those as out of scope.
LIBRARY: dict[str, tuple[list, set]] = {
    "semigroup":            ([ASSOC], {("*", 2)}),
    "comm-semigroup":       ([ASSOC, COMM], {("*", 2)}),
    "band":                 ([ASSOC, IDEM], {("*", 2)}),
    "semilattice":          ([ASSOC, COMM, IDEM], {("*", 2)}),
    "left-zero":            ([ASSOC, ("left-zero", op(x, y), x)], {("*", 2)}),
    "right-zero":           ([ASSOC, ("right-zero", op(x, y), y)], {("*", 2)}),
    "rectangular-band":     ([ASSOC, ("rect", op(x, op(y, x)), x)], {("*", 2)}),
    "pointed-semigroup":    ([ASSOC], {("*", 2), ("e", 0)}),
    "monoid":               ([ASSOC, LUNIT, RUNIT], {("*", 2), ("e", 0)}),
    "comm-monoid":          ([ASSOC, COMM, LUNIT, RUNIT], {("*", 2), ("e", 0)}),
    "left-group":           ([ASSOC, LUNIT, LINV], {("*", 2), ("e", 0), ("i", 1)}),
    "group":                ([ASSOC, LUNIT, RUNIT, LINV, RINV],
                             {("*", 2), ("e", 0), ("i", 1)}),
    "abelian-group":        ([ASSOC, COMM, LUNIT, RUNIT, LINV, RINV],
                             {("*", 2), ("e", 0), ("i", 1)}),
    "zero-semigroup":       ([ASSOC, ("absorb", op(x, y), Z)], {("*", 2), ("0", 0)}),
    "involution":           ([("inv2", f(f(x)), x)], {("f", 1)}),
    "idempotent-map":       ([("idf", f(f(x)), f(x))], {("f", 1)}),
    "constant-map":         ([("const", f(x), f(y))], {("f", 1)}),
}

#: The two structure maps we know how to declare on a binary operation.
#: `identity` is the honest default; `opposite` is the anti-isomorphism that
#: `demo_transport.py` showed is rejected when it should be.
MAPS: dict[str, dict] = {
    "identity": {},
    "opposite": {("*", 2): mk("*", mk("?1"), mk("?0"))},
}


def precedence_for(sig: set) -> list:
    """A declaration order for the LPO: unary above binary above constants.

    Deterministic, and the engine records when it mattered -- an
    UNORIENTABLE verdict re-orients rather than accepting this default.
    """
    unary = sorted(s for s, a in sig if a == 1)
    binary = sorted(s for s, a in sig if a == 2)
    consts = sorted(s for s, a in sig if a == 0)
    return unary + binary + consts

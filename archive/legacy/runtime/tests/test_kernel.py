#!/usr/bin/env python3
"""Adversarial test suite for the crystal kernel (runtime/kernel).

Repo norm (collab/PROTOCOL.md Sec.7, msg 0073): a headline claim ships with its
own annihilation apparatus or it is not a claim.  So every capability test here
is paired with a *planted-false control* that must fail.  A control that passes
is a failure of the suite, and is reported as one.

Run:  python3 runtime/tests/test_kernel.py
Exit: 0 iff every capability passed AND every control failed as designed.

Output is byte-identical across runs (no hashing of object ids, no set
iteration, no floats, no wall-clock).
"""

from __future__ import annotations

import os
import sys
from fractions import Fraction

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.kernel import term as T  # noqa: E402
from runtime.kernel import edges as E  # noqa: E402
from runtime.kernel import check as C  # noqa: E402
from runtime.kernel.egraph import EGraph, EGraphError  # noqa: E402

# --------------------------------------------------------------------------
# harness
# --------------------------------------------------------------------------

CAPS: list = []
CONTROLS: list = []
LOG: list = []


def capability(name):
    def deco(fn):
        CAPS.append((name, fn))
        return fn
    return deco


def control(name):
    """A planted-false control.  The body must return a falsehood-detector:
    it returns True iff the kernel *rejected* the planted falsehood."""
    def deco(fn):
        CONTROLS.append((name, fn))
        return fn
    return deco


def rejects(fn, *exc):
    """True iff calling ``fn`` raises one of ``exc``."""
    try:
        fn()
    except exc:
        return True
    except Exception as other:  # wrong exception is still a failure
        LOG.append("    unexpected exception: %r" % (other,))
        return False
    return False


# --------------------------------------------------------------------------
# shared vocabulary
# --------------------------------------------------------------------------

N = T.base_sort("N")
B = T.base_sort("B")
NN = T.arrow(N, N)
NNN = T.arrow(N, NN)

f = T.Const("f", NN)
g = T.Const("g", NN)
a = T.Const("a", N)
b = T.Const("b", N)
c = T.Const("c", N)
d = T.Const("d", N)
e_ = T.Const("e", N)
p = T.Const("p", B)
idN = T.Lam(N, T.Var(0, N))


def fresh_ctx():
    ctx = C.CheckContext()
    ctx.declare_axiom("A:a=b/route1", a, b)
    ctx.declare_axiom("A:a=b/route2", a, b)
    ctx.declare_axiom("A:b=c", b, c)
    ctx.declare_axiom("A:a=c", a, c)
    ctx.declare_axiom("A:a=d", a, d)
    ctx.declare_axiom("A:d=e", d, e_)
    ctx.declare_axiom("A:fx=gx", T.App(f, T.Var(0, N)), T.App(g, T.Var(0, N)))
    ctx.declare_axiom("A:generic", T.App(f, a), T.App(g, a))
    return ctx


# ==========================================================================
# L0 -- exact identity
# ==========================================================================


@capability("L0 hash-consing: structural identity is physical identity")
def t_hashcons():
    x1 = T.App(f, T.App(f, a))
    x2 = T.App(f, T.App(f, a))
    assert x1 is x2, "identical constructions must be one object"
    assert x1.addr == x2.addr
    assert T.lookup(x1.addr) is x1
    assert x1.recompute_addr() == x1.addr, "address must be reproducible from structure"
    return True


@capability("L0 address embeds dependency structure, not names")
def t_address_structure():
    fa, fb = T.App(f, a), T.App(f, b)
    assert fa.addr != fb.addr, "a child change must change the address"
    ga = T.App(g, a)
    assert ga.addr != fa.addr, "a head change must change the address"
    # the address is a function of (head symbol, sort, child addresses) only
    T.bind("alpha", fa)
    before = fa.addr
    T.bind("beta", fa)
    T.bind("alpha", ga)
    assert fa.addr == before, "rebinding names must not move an address"
    return True


@capability("L0 names are mutable non-authoritative views")
def t_names():
    fa = T.App(f, a)
    T.NAMES.reset()
    T.bind("double", fa)
    T.bind("twice", fa)
    assert set(T.names_of(fa.addr)) == {"double", "twice"}, "one address, two names"
    assert T.resolve("double") == T.resolve("twice") == fa.addr
    # two DIFFERENT addresses a naive name-based system would confuse: the same
    # name "double" rebound to a genuinely different construction.
    ga = T.App(g, a)
    T.bind("double", ga)
    assert T.resolve("double") == ga.addr, "the view moved"
    assert T.names_of(fa.addr) == ("twice",), "the old address kept its other name"
    assert fa.addr != ga.addr, "two constructions once called 'double' stay distinct"
    assert T.lookup(fa.addr) is fa, "the un-named construction is still reachable by address"
    return True


@capability("L0 de Bruijn makes alpha-equivalence definitional")
def t_alpha():
    # "\\x. f x" and "\\y. f y" are the *same* construction and get one address.
    l1 = T.Lam(N, T.App(f, T.Var(0, N)))
    l2 = T.Lam(N, T.App(f, T.Var(0, N)))
    assert l1 is l2
    # but "\\x. f x" and "\\x. g x" are not
    assert T.Lam(N, T.App(g, T.Var(0, N))) is not l1
    return True


@capability("L0 beta normalisation is exact, fuel-bounded and deterministic")
def t_beta():
    t = T.App(idN, T.App(f, a))
    n = T.beta_normal(t)
    assert n is T.App(f, a)
    assert T.beta_normal(t) is n, "normalisation is a function"
    # divergent term: (\\x. x x) (\\x. x x) is not typeable here, so instead
    # check that a starved fuel budget returns None rather than a guess.
    assert T.beta_normal(T.App(idN, T.App(idN, T.App(idN, a))), fuel=2) is None
    return True


@control("CONTROL L0: ill-sorted application must fail construction")
def x_ill_sorted_app():
    ok = rejects(lambda: T.App(a, a), T.SortError)          # applying a non-function
    ok &= rejects(lambda: T.App(f, p), T.SortError)         # N->N applied to B
    ok &= rejects(lambda: T.App(f, f), T.SortError)         # N->N applied to N->N
    return ok


@control("CONTROL L0: ill-sorted binder must fail construction")
def x_ill_sorted_lam():
    body = T.App(f, T.Var(0, N))            # demands #0 : N
    ok = rejects(lambda: T.Lam(B, body), T.SortError)
    # de Bruijn index 0 used at sort N on the left and sort B on the right of
    # one application: no binder can ever satisfy both, so reject at build time.
    nb = T.Const("nb", T.arrow(N, T.arrow(B, N)))
    left = T.App(nb, T.Var(0, N))           # demands #0 : N
    ok &= rejects(lambda: T.App(left, T.Var(0, B)), T.SortError)   # demands #0 : B
    ok &= rejects(lambda: T.Var(-1, N), T.SortError)
    ok &= rejects(lambda: T.Var(0, "N"), T.SortError)
    ok &= rejects(lambda: T.Const("", N), T.SortError)
    ok &= rejects(lambda: T.Lam(N, N), T.SortError)
    ok &= rejects(lambda: T.base_sort(""), T.SortError)
    return ok


@control("CONTROL L0: structurally different terms must NOT intern to one address")
def x_no_false_interning():
    pairs = [
        (T.App(f, a), T.App(f, b)),
        (T.App(f, a), T.App(g, a)),
        (T.App(f, T.App(f, a)), T.App(f, a)),
        (T.Lam(N, T.Var(0, N)), T.Lam(N, a)),
        (T.Const("s", N), T.Const("s", B)),          # same symbol, different sort
        (T.Var(0, N), T.Var(1, N)),                  # different de Bruijn index
        (T.Lam(N, T.Lam(N, T.Var(0, N))), T.Lam(N, T.Lam(N, T.Var(1, N)))),
    ]
    for u, v in pairs:
        if u.addr == v.addr or u is v:
            LOG.append("    collided: %s vs %s" % (u.pretty(), v.pretty()))
            return False
    # and the address is not a truncation artefact: all distinct, full length
    addrs = [t.addr for pr in pairs for t in pr]
    if len(set(addrs)) != len(set(id(t) for pr in pairs for t in pr)):
        return False
    return all(len(x) == 32 for x in addrs)


# ==========================================================================
# L1 -- the typed edge algebra
# ==========================================================================

EXPECTED = {}


def _expected_table():
    if EXPECTED:
        return EXPECTED
    directed = ("Embed", "Quotient", "Implies", "Approx", "Refine", "Interp")
    for l in E.KINDS:
        for r in E.KINDS:
            EXPECTED[(l, r)] = None
    for k in E.KINDS:
        if k != "Conjecture":
            EXPECTED[("Eq", k)] = k
            EXPECTED[(k, "Eq")] = k
    for k in ("Iso", "Order") + directed:
        EXPECTED[(k, k)] = k
    for k in directed:
        EXPECTED[("Iso", k)] = k
        EXPECTED[(k, "Iso")] = k
    EXPECTED[("Iso", "Dual")] = "Dual"
    EXPECTED[("Dual", "Iso")] = "Dual"
    EXPECTED[("Dual", "Dual")] = "Iso"
    return EXPECTED


@capability("L1 composition table is total and matches the spec on all 121 pairs")
def t_table():
    exp = _expected_table()
    for l, r, got in E.composition_table():
        want = exp[(l, r)]
        if l == "Conjecture" or r == "Conjecture":
            want = None
        assert E.compose_kind(l, r) == want, "compose_kind(%s,%s)=%r want %r" % (
            l, r, E.compose_kind(l, r), want)
        assert (got if (l != "Conjecture" and r != "Conjecture") else None) == want
    n_none = sum(1 for l in E.KINDS for r in E.KINDS if E.compose_kind(l, r) is None)
    # 79 = 121 - 42 licensed.  Adding Order licensed exactly 3 new pairs
    # (Eq;Order), (Order;Eq), (Order;Order) and nothing else: notably NOT
    # (Iso;Order), because an isomorphism need not carry order data.
    assert n_none == 79, "expected 79 unlicensed ordered pairs, got %d" % n_none
    return True


@capability("L1 Approx carries an exact Fraction epsilon that adds under composition")
def t_approx():
    e1 = E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 3))
    e2 = E.Edge("Approx", b.addr, c.addr, eps=Fraction(1, 6))
    comp = E.compose(e1, e2)
    assert comp is not None and comp.kind == "Approx"
    assert comp.eps == Fraction(1, 2), comp.eps
    assert isinstance(comp.eps, Fraction) and not isinstance(comp.eps, float)
    # Approx . Iso keeps the same epsilon, in both orders
    iso = E.Edge("Iso", c.addr, d.addr, witness=None)
    both = E.compose(comp, iso)
    assert both.kind == "Approx" and both.eps == Fraction(1, 2)
    iso0 = E.Edge("Iso", d.addr, a.addr)
    lead = E.compose(iso0, e1)
    assert lead.kind == "Approx" and lead.eps == Fraction(1, 3)
    # Implies . Iso is Implies
    imp = E.Edge("Implies", a.addr, b.addr)
    isob = E.Edge("Iso", b.addr, c.addr)
    assert E.compose(imp, isob).kind == "Implies"
    assert E.compose(E.Edge("Iso", d.addr, a.addr), imp).kind == "Implies"
    return True


@capability("L1 the limitor auditor classifies origination correctly")
def t_limitor_audit_classifier():
    """The auditor's verdict is load-bearing, so test it on known code rather
    than trusting its output.  It reports zero originating sites in this
    runtime; that must mean 'none exist', not 'the classifier is broken'."""
    import ast as _ast
    from runtime.kernel import limitor_audit as LA
    fixture = (
        "Edge('Approx', a, b, eps=Fraction(1,3))\n"          # originating
        "Edge('Order', a, b, ordering='sigma+')\n"           # originating
        "E.Edge(kind='Dual', src=a, dst=b, pairing=name)\n"  # originating
        "Edge(kind=e.kind, src=e.src, dst=e.dst, eps=e.eps)\n"   # propagating
        "Edge('Approx', a, b, eps=eps)\n"                    # propagating
        "Edge('Eq', a, b)\n"                                 # unlimited
        "Edge('Iso', a, b, eps=None)\n"                      # unlimited
    )
    tree = _ast.parse(fixture)
    calls = [n for n in _ast.walk(tree) if LA.is_edge_call(n)]
    assert len(calls) == 7, len(calls)
    verdicts = [LA.classify(c)[1] for c in calls]
    kinds = [LA.classify(c)[0] for c in calls]
    assert kinds[:3] == ["Approx", "Order", "Dual"], kinds
    assert list(verdicts[0].values()) == ["originating"], verdicts[0]
    assert list(verdicts[1].values()) == ["originating"], verdicts[1]
    assert list(verdicts[2].values()) == ["originating"], verdicts[2]
    assert list(verdicts[3].values()) == ["propagating"], verdicts[3]
    assert list(verdicts[4].values()) == ["propagating"], verdicts[4]
    assert verdicts[5] == {} and verdicts[6] == {}, (verdicts[5], verdicts[6])
    return True


@capability("L1 the limitor is one mechanism, not three payload special cases")
def t_limitor_table():
    # Every payload-bearing kind is in the table, and nothing else is.
    assert set(E.LIMITORS) == {"Approx", "Dual", "Order"}
    assert E.limitor_of("Iso") is None
    # The three combination rules, which are the only thing that varies.
    ok, v = E.combine_limitors("Approx", Fraction(1, 3), Fraction(1, 6))
    assert ok and v == Fraction(1, 2), "epsilons add exactly"
    assert E.combine_limitors("Dual", "p", "p") == (True, "p")
    assert E.combine_limitors("Dual", "p", "q")[0] is False
    assert E.combine_limitors("Order", "s+", "s+") == (True, "s+")
    assert E.combine_limitors("Order", "s+", "s-")[0] is False
    # A dropped limitor never matches -- there is nothing to check against.
    assert E.combine_limitors("Order", None, None)[0] is False
    assert E.combine_limitors("Dual", None, "p")[0] is False
    # and the rules are actually wired into compose
    a1 = E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 3))
    a2 = E.Edge("Approx", b.addr, c.addr, eps=Fraction(1, 6))
    assert E.compose(a1, a2).eps == Fraction(1, 2)
    # a one-sided bearer carries its limitor through
    thru = E.compose(E.Edge("Iso", d.addr, a.addr), a1)
    assert thru.eps == Fraction(1, 3)
    return True


@capability("L1 limitor_census reports a singleton index as a latent erratum")
def t_limitor_census():
    """The machine-checkable form of the reading in POSITIVITY_HAS_A_PLACE SS9.

    A limitor whose value space is a singleton where a claim was checked cannot
    be observed to have been dropped: delimited and undelimited have the same
    extension there, so every check passes and no correction is generated.
    """
    one = [E.Edge("Order", a.addr, b.addr, ordering="sigma+"),
           E.Edge("Order", b.addr, c.addr, ordering="sigma+")]
    r = E.limitor_census(one)["ordering"]
    assert r["cardinality"] == 1 and r["latent_erratum"] is True, r
    # widen the regime and the index becomes observable
    two = one + [E.Edge("Order", a.addr, c.addr, ordering="sigma-")]
    r2 = E.limitor_census(two)["ordering"]
    assert r2["cardinality"] == 2 and r2["latent_erratum"] is False, r2
    # a sort that never appears is not a latent erratum -- absent is not unvarying
    assert E.limitor_census(one)["pairing"]["cardinality"] == 0
    assert E.limitor_census(one)["pairing"]["latent_erratum"] is False
    return True


@control("CONTROL L1: a required limitor may not be defaulted away")
def t_limitor_required():
    """The whole point: an edge whose index was dropped is correct exactly
    while the index space is a singleton, and silently wrong after."""
    for kind, kw in (("Order", {}), ("Approx", {})):
        try:
            E.Edge(kind, a.addr, b.addr, **kw)
        except E.EdgeError:
            continue
        LOG.append("%s accepted without its limitor" % kind)
        return False
    # Dual's pairing is optional by design, but an unnamed one cannot compose.
    d1 = E.Edge("Dual", a.addr, b.addr)
    d2 = E.Edge("Dual", b.addr, c.addr)
    if E.compose(d1, d2) is not None:
        LOG.append("two unnamed Duals composed")
        return False
    return True


@capability("L1 the limitor is part of an edge's identity, not a label on it")
def t_limitor_identity():
    p1 = E.Edge("Order", a.addr, b.addr, ordering="sigma+")
    p2 = E.Edge("Order", a.addr, b.addr, ordering="sigma-")
    assert p1.edge_id != p2.edge_id
    x1 = E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 3))
    x2 = E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 4))
    assert x1.edge_id != x2.edge_id
    return True


@capability("L1 Order carries its ordering as a required limitor, and composes only within it")
def t_order_limitor():
    plus = E.Edge("Order", a.addr, b.addr, ordering="sigma+")
    plus2 = E.Edge("Order", b.addr, c.addr, ordering="sigma+")
    minus = E.Edge("Order", b.addr, c.addr, ordering="sigma-")
    assert plus.preserves == frozenset({"sign"})
    assert plus.render().startswith("Order<sigma+>")
    same = E.compose(plus, plus2)
    assert same is not None and same.kind == "Order" and same.ordering == "sigma+"
    # Different limitors do not compose.  Sign is not transported between
    # orderings: over Q(sqrt2), x^2 - sqrt2*y^2 has signature (1,1) at one
    # ordering and (2,0) at the other (machinery/orderings.py).
    assert E.compose(plus, minus) is None
    # The limitor is part of the edge's identity, not a label on it.
    assert E.Edge("Order", b.addr, c.addr, ordering="sigma+").edge_id != minus.edge_id
    # An Order edge is directed: order-preserving does not invert.
    assert not plus.symmetric and E.invert(plus) is None
    return True


@control("CONTROL L1: an Order edge with no named ordering must fail construction")
def t_order_needs_limitor():
    try:
        E.Edge("Order", a.addr, b.addr)
    except E.EdgeError:
        pass
    else:
        LOG.append("Order accepted without a limitor")
        return False
    # and no other kind may carry one
    try:
        E.Edge("Iso", a.addr, b.addr, ordering="sigma+")
    except E.EdgeError:
        return True
    LOG.append("a non-Order edge accepted an ordering")
    return False


@control("CONTROL L1: no path through a Quotient or an Iso can deliver sign")
def t_sign_is_not_manufactured():
    """cf-prime msg 0110 SS2 as a fact about the lattice, not about our source.

    Every self-improvement loop in the runtime is an averaging or a quotient.
    The preservation lattice says such a step cannot carry order data, so the
    machine's blindness to parity is now something the kernel can state.
    """
    order = E.Edge("Order", a.addr, b.addr, ordering="sigma+")
    for kind in ("Quotient", "Iso", "Approx", "Refine", "Implies", "Embed", "Interp"):
        assert "sign" not in E.preserves(kind), kind
        e = E.Edge(kind, b.addr, c.addr,
                   eps=Fraction(1, 5) if kind == "Approx" else None)
        comp = E.compose(order, e)
        if comp is not None and "sign" in comp.preserves:
            LOG.append("%s manufactured sign" % kind)
            return False
    return True


@capability("L1 preservation is the intersection lattice")
def t_preserves():
    assert E.preserves("Eq") == E.ALL_PROPERTIES
    assert "presentation" not in E.preserves("Iso")
    # Iso does not carry sign: Galois conjugation on Q(sqrt2) is an
    # isomorphism that exchanges the field's two orderings.
    assert "sign" not in E.preserves("Iso")
    assert E.preserves("Order") == frozenset({"sign"})
    iso = E.Edge("Iso", a.addr, b.addr)
    imp = E.Edge("Implies", b.addr, c.addr)
    comp = E.compose(iso, imp)
    assert comp.preserves == frozenset({"truth"})
    ap = E.compose(E.Edge("Iso", a.addr, b.addr),
                   E.Edge("Approx", b.addr, c.addr, eps=Fraction(1, 4)))
    assert ap.preserves == frozenset({"bounded_error"})
    return True


@capability("L1 symmetry and inversion")
def t_symmetry():
    assert E.is_symmetric("Eq") and E.is_symmetric("Iso") and E.is_symmetric("Dual")
    for k in ("Embed", "Quotient", "Implies", "Approx", "Refine", "Interp"):
        assert not E.is_symmetric(k)
    iso = E.Edge("Iso", a.addr, b.addr)
    inv = E.invert(iso)
    assert inv is not None and (inv.src, inv.dst) == (b.addr, a.addr)
    q = E.Edge("Quotient", a.addr, b.addr)
    assert E.invert(q) is None, "a Quotient has no inverse"
    # Dual . Dual only with the same pairing
    d1 = E.Edge("Dual", a.addr, b.addr, pairing="cup")
    d2 = E.Edge("Dual", b.addr, c.addr, pairing="cup")
    assert E.compose(d1, d2).kind == "Iso"
    d3 = E.Edge("Dual", b.addr, c.addr, pairing="other")
    assert E.compose(d1, d3) is None, "different pairings must not compose"
    return True


@control("CONTROL L1: Conjecture must never enter an accepted composite")
def x_conjecture_composite():
    # Two independent defences must BOTH hold: the explicit guard in
    # compose_kind (counted, so this test fails if it is removed) and the
    # absence of any Conjecture row/column in the table itself.
    before = T.COUNTERS.get("edge.conjecture_blocked")
    for k in E.KINDS:
        if E.compose_kind(k, "Conjecture") is not None:
            return False
        if E.compose_kind("Conjecture", k) is not None:
            return False
    if T.COUNTERS.get("edge.conjecture_blocked") - before != 2 * len(E.KINDS):
        return False   # the guard was bypassed
    for l, r, got in E.composition_table():
        if (l == "Conjecture" or r == "Conjecture") and got is not None:
            return False   # the table itself would have licensed it
    conj = E.Edge("Conjecture", b.addr, c.addr, label="RH")
    eq = E.Edge("Eq", a.addr, b.addr, witness=())
    if E.compose(eq, conj) is not None:
        return False
    if E.compose_path([eq, conj, E.Edge("Eq", c.addr, d.addr, witness=())]) is not None:
        return False
    ctx = fresh_ctx()
    if C.check_edge(conj, ctx) is not False:
        return False
    if C.check_composite([eq, conj], ctx) is not None:
        return False
    # and a conjectural *step* inside a proof path
    st = C.Step(a.addr, b.addr, "assumption", C.Conjectural("RH"))
    return C.check_step(st, ctx) is False


@control("CONTROL L1: floats and malformed payloads must be rejected")
def x_edge_payloads():
    ok = rejects(lambda: E.Edge("Approx", a.addr, b.addr, eps=0.5), E.EdgeError)
    ok &= rejects(lambda: E.Edge("Approx", a.addr, b.addr), E.EdgeError)      # missing eps
    ok &= rejects(lambda: E.Edge("Iso", a.addr, b.addr, eps=Fraction(1, 2)), E.EdgeError)
    ok &= rejects(lambda: E.Edge("Approx", a.addr, b.addr, eps=Fraction(-1, 2)), E.EdgeError)
    ok &= rejects(lambda: E.Edge("Iso", a.addr, b.addr, pairing="cup"), E.EdgeError)
    ok &= rejects(lambda: E.Edge("Nonsense", a.addr, b.addr), E.EdgeError)
    return ok


@control("CONTROL L1: non-meeting endpoints must not compose")
def x_endpoints():
    e1 = E.Edge("Implies", a.addr, b.addr)
    e2 = E.Edge("Implies", c.addr, d.addr)
    return E.compose(e1, e2) is None


# ==========================================================================
# L5 -- the trusted checker
# ==========================================================================


@capability("L5 checker validates axiom, beta and instantiation witnesses")
def t_check_witnesses():
    ctx = fresh_ctx()
    assert C.check_path([C.Step(a.addr, b.addr, "assumption", C.Axiom("A:a=b/route1"))],
                        a.addr, b.addr, ctx)
    red = T.App(idN, a)
    assert C.check_path([C.Step(red.addr, a.addr, "assumption", C.Beta())],
                        red.addr, a.addr, ctx)
    inst = C.Instantiate("A:generic", (("a", b),))
    assert C.check_path([C.Step(T.App(f, b).addr, T.App(g, b).addr, "assumption", inst)],
                        T.App(f, b).addr, T.App(g, b).addr, ctx), ctx.errors
    assert C.check_path((), a.addr, a.addr, ctx), "reflexivity is the empty path"
    return True


@capability("L5 checker validates an invertible Iso witness by normalising it")
def t_check_iso():
    ctx = fresh_ctx()
    src = T.App(T.Lam(N, T.App(f, T.Var(0, N))), a)   # (\\x. f x) a
    dst = T.App(f, a)                                  # f a
    edge = E.Edge("Iso", src.addr, dst.addr, witness=C.IsoWitness(idN, idN))
    assert C.check_edge(edge, ctx), ctx.errors
    return True


@capability("L5 checker validates declared certificates for directed edges")
def t_check_certificate():
    ctx = fresh_ctx()
    ctx.declare_certificate("cert:q", "Quotient", a.addr, b.addr)
    ctx.declare_certificate("cert:ap", "Approx", b.addr, c.addr, Fraction(1, 8))
    q = E.Edge("Quotient", a.addr, b.addr, witness=C.Certificate("cert:q"))
    ap = E.Edge("Approx", b.addr, c.addr, eps=Fraction(1, 8),
                witness=C.Certificate("cert:ap"))
    assert C.check_edge(q, ctx) and C.check_edge(ap, ctx), ctx.errors
    comp = C.check_composite([q, ap], ctx)
    assert comp is None, "Quotient then Approx is not a licensed composite"
    return True


@control("CONTROL L5: a non-invertible Iso witness must be rejected")
def x_iso_not_invertible():
    ctx = fresh_ctx()
    src = T.App(T.Lam(N, T.App(f, T.Var(0, N))), a)
    dst = c
    to = T.Lam(N, c)          # collapses everything to c
    fro = T.Lam(N, src)       # maps everything back to src
    edge = E.Edge("Iso", src.addr, dst.addr, witness=C.IsoWitness(to, fro))
    if C.check_edge(edge, ctx) is not False:
        return False
    # and an Iso offered with no witness at all
    return C.check_edge(E.Edge("Iso", src.addr, dst.addr), ctx) is False


@control("CONTROL L5: undeclared axioms and mismatched certificates must be rejected")
def x_undeclared():
    ctx = fresh_ctx()
    ok = C.check_path([C.Step(a.addr, b.addr, "assumption", C.Axiom("A:never-declared"))],
                      a.addr, b.addr, ctx) is False
    # a declared axiom offered for the wrong pair
    ok &= C.check_path([C.Step(a.addr, c.addr, "assumption", C.Axiom("A:a=b/route1"))],
                       a.addr, c.addr, ctx) is False
    # a certificate for the wrong endpoints
    ctx.declare_certificate("cert:x", "Quotient", a.addr, b.addr)
    bad = E.Edge("Quotient", a.addr, c.addr, witness=C.Certificate("cert:x"))
    ok &= C.check_edge(bad, ctx) is False
    # a certificate with the wrong epsilon
    ctx.declare_certificate("cert:y", "Approx", a.addr, b.addr, Fraction(1, 5))
    bad2 = E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 4),
                  witness=C.Certificate("cert:y"))
    ok &= C.check_edge(bad2, ctx) is False
    # a Beta claim between terms with different normal forms
    ok &= C.check_path([C.Step(T.App(idN, a).addr, b.addr, "assumption", C.Beta())],
                       T.App(idN, a).addr, b.addr, ctx) is False
    # an ill-sorted instantiation
    ok &= C.check_path([C.Step(a.addr, b.addr, "assumption",
                               C.Instantiate("A:generic", (("a", p),)))],
                       a.addr, b.addr, ctx) is False
    return bool(ok)


# ==========================================================================
# L2 -- the proof-relevant e-graph
# ==========================================================================


def build_graph():
    """The standard scenario, used by several tests and by the counter demo."""
    gr = EGraph()
    fa, fb = T.App(f, a), T.App(f, b)
    gr.add(fa)
    gr.add(fb)
    gr.add(d)
    gr.add(e_)
    gr.merge(a, b, C.Axiom("A:a=b/route1"), edge_id="E1")
    gr.merge(a, b, C.Axiom("A:a=b/route2"), edge_id="E2")
    gr.merge(d, e_, C.Axiom("A:d=e"), edge_id="E3")
    return gr, fa, fb


@capability("L2 union-find + congruence closure with a proof forest")
def t_egraph_basic():
    gr, fa, fb = build_graph()
    assert gr.equal(a, b)
    assert gr.equal(fa, fb), "congruence must have fired"
    path = gr.explain(fa, fb)
    assert path is not None and len(path) == 1 and path[0].kind == "congruence"
    ctx = fresh_ctx()
    assert C.check_path(path, fa.addr, fb.addr, ctx), ctx.errors
    # the congruence step really does carry its argument subproof
    assert len(path[0].subproofs) == 2
    assert path[0].subproofs[0] == ()          # f = f by reflexivity
    assert len(path[0].subproofs[1]) == 1      # a = b by an assumption
    assert gr.steps.get("congruences") == 1
    return True


@capability("L2 proof forest reroots on union, so every pair stays explainable")
def t_proof_forest_reroot():
    # Every merge names `a` first, so after the first union `a` is no longer a
    # proof-forest root.  A flat "remember the last union" scheme silently loses
    # the earlier justification here; only path reversal keeps all of them.
    gr = EGraph()
    for t in (a, b, c, d):
        gr.add(t)
    gr.merge(a, b, C.Axiom("A:a=b/route1"), edge_id="R1")
    gr.merge(a, c, C.Axiom("A:a=c"), edge_id="R2")
    gr.merge(a, d, C.Axiom("A:a=d"), edge_id="R3")
    # exact: reroot(a) walks 1 node, then 2, then 2 as the forest deepens
    assert gr.steps.get("reroot_hop") == 5, gr.steps.get("reroot_hop")
    ctx = fresh_ctx()
    seen = {}
    for x, y in ((a, b), (a, c), (a, d), (b, c), (b, d), (c, d)):
        path = gr.explain(x, y)
        assert path is not None, "lost the justification for %s=%s" % (x.pretty(), y.pretty())
        assert C.check_path(path, x.addr, y.addr, ctx), (x.pretty(), y.pretty(), ctx.errors)
        seen[(x.pretty(), y.pretty())] = [s.edge_id for s in path]
    # the derived equalities must route through exactly two assumptions
    assert seen[("b", "c")] == ["R1", "R2"], seen[("b", "c")]
    assert seen[("c", "d")] == ["R2", "R3"], seen[("c", "d")]
    assert seen[("a", "b")] == ["R1"]
    # retracting the middle assumption splits exactly one pair off
    gr.retract("R2")
    assert gr.equal(a, b) and gr.equal(a, d) and not gr.equal(a, c)
    assert C.check_path(gr.explain(b, d), b.addr, d.addr, ctx), ctx.errors
    return True


@capability("L2 explain output is re-verified by the checker, independently")
def t_explain_checked():
    gr, fa, fb = build_graph()
    gr.merge(b, c, C.Axiom("A:b=c"), edge_id="E4")
    ctx = fresh_ctx()
    for x, y in ((a, c), (fa, fb), (a, b), (d, e_)):
        path = gr.explain(x, y)
        assert path is not None, "should be equal: %s %s" % (x.pretty(), y.pretty())
        assert C.check_path(path, x.addr, y.addr, ctx), (x.pretty(), y.pretty(), ctx.errors)
    assert gr.explain(a, d) is None, "unrelated terms are not equal"
    assert gr.explain(a, e_) is None
    return True


@capability("L2 distinct justifications are retained and both are retrievable")
def t_distinct_paths():
    gr, fa, fb = build_graph()
    paths = gr.explanations(a, b)
    assert len(paths) >= 2, "two independent reasons must survive, got %d" % len(paths)
    ids = sorted(s.edge_id for pth in paths for s in pth if s.kind == "assumption")
    assert "E1" in ids and "E2" in ids, ids
    ctx = fresh_ctx()
    for pth in paths:
        assert C.check_path(pth, a.addr, b.addr, ctx), ctx.errors
    recs = gr.justifications(a, b)
    assert len(recs) == 2 and sorted(r.edge_id for r in recs) == ["E1", "E2"]
    assert sum(1 for r in recs if r.applied) == 1, "exactly one is the spanning edge"
    return True


@capability("L2 directed edges have their own reachability query")
def t_directed():
    gr, fa, fb = build_graph()
    gr.add(c)
    q = E.Edge("Quotient", b.addr, c.addr, witness=C.Certificate("cert:q"))
    gr.add_directed(q)
    got = gr.reachable(a, c)
    assert got is not None and got.kind == "Quotient", got
    ap = E.Edge("Approx", c.addr, d.addr, eps=Fraction(1, 7))
    gr.add_directed(ap)
    far = gr.reachable(a, d)
    assert far is None, "Quotient then Approx is unlicensed, so d is unreachable"
    assert gr.reachable(c, a) is None, "a Quotient is not symmetric"
    return True


@capability("L2 retraction keeps an equality that has a second reason")
def t_retract_survives():
    gr, fa, fb = build_graph()
    assert gr.retract("E1") is True
    assert gr.equal(a, b), "the E2 route must carry the equality"
    assert gr.equal(fa, fb), "congruence must have been re-derived"
    ctx = fresh_ctx()
    path = gr.explain(a, b)
    assert path is not None and C.check_path(path, a.addr, b.addr, ctx), ctx.errors
    assert [s.edge_id for s in path] == ["E2"]
    path2 = gr.explain(fa, fb)
    assert C.check_path(path2, fa.addr, fb.addr, ctx), ctx.errors
    assert gr.retract("E2") is True
    assert not gr.equal(a, b), "with both reasons gone the equality must vanish"
    assert not gr.equal(fa, fb), "and so must its congruence consequence"
    assert gr.explain(fa, fb) is None
    assert gr.steps.get("rebuilds") == 2
    return True


@capability("L2 retraction is local: untouched classes are the same objects")
def t_retract_local():
    gr, fa, fb = build_graph()
    unrelated_before = gr.class_of(d)
    f_before = gr.class_of(f)
    assert unrelated_before == (min(d.addr, e_.addr), max(d.addr, e_.addr))
    gr.retract("E1")
    assert gr.class_of(d) is unrelated_before, "unrelated class was rebuilt"
    assert gr.class_of(f) is f_before, "the function symbol's class was rebuilt"
    gr.retract("E2")
    assert gr.class_of(d) is unrelated_before, "unrelated class was rebuilt"
    assert gr.class_of(f) is f_before
    assert gr.equal(d, e_)
    return True


@capability("L2 counters are exact and reproducible")
def t_counters():
    g1, _, _ = build_graph()
    g2, _, _ = build_graph()
    assert g1.steps.snapshot() == g2.steps.snapshot(), (g1.steps.snapshot(),
                                                        g2.steps.snapshot())
    for key in ("unions", "congruences", "explain_steps", "rebuilds"):
        assert key in g1.steps.keys() or g1.steps.get(key) == 0
    assert g1.steps.get("unions") == 3
    assert g1.steps.get("congruences") == 1
    assert g1.steps.get("rebuilds") == 0
    return True


@control("CONTROL L2: a Quotient edge must never produce an equality")
def x_quotient_not_equality():
    gr = EGraph()
    gr.add(a)
    gr.add(b)
    cls_a = gr.class_of(a)
    gr.add_directed(E.Edge("Quotient", a.addr, b.addr, witness=C.Certificate("cert:q")))
    gr.add_directed(E.Edge("Refine", a.addr, b.addr))
    gr.add_directed(E.Edge("Implies", a.addr, b.addr))
    gr.add_directed(E.Edge("Approx", a.addr, b.addr, eps=Fraction(1, 2)))
    gr.add_directed(E.Edge("Iso", a.addr, b.addr))     # symmetric, still not an equality
    if gr.equal(a, b):
        return False
    if gr.explain(a, b) is not None:
        return False
    if gr.explanations(a, b) != ():
        return False
    if gr.class_of(a) is not cls_a:
        return False
    if gr.steps.get("unions") != 0:
        return False
    # an Eq must not be smuggled in through the directed graph either
    return rejects(lambda: gr.add_directed(E.Edge("Eq", a.addr, b.addr, witness=())),
                   EGraphError)


@control("CONTROL L2: a Conjecture must never merge e-classes")
def x_conjecture_merge():
    gr = EGraph()
    gr.add(a)
    gr.add(b)
    ok = rejects(lambda: gr.merge(a, b, C.Conjectural("RH")), EGraphError)
    ok &= not gr.equal(a, b)
    ok &= gr.steps.get("unions") == 0
    # and merging across sorts is refused
    gr.add(p)
    ok &= rejects(lambda: gr.merge(a, p, C.Axiom("A:a=b/route1")), T.SortError)
    return bool(ok)


@control("CONTROL L2: fabricated explain paths must be rejected by the checker")
def x_fabricated_paths():
    gr, fa, fb = build_graph()
    ctx = fresh_ctx()
    real = gr.explain(fa, fb)
    assert C.check_path(real, fa.addr, fb.addr, ctx)
    ga = T.App(g, a)
    fakes = [
        # 1. congruence step with its argument subproof deleted
        ((C.Step(fa.addr, fb.addr, "congruence", None, "forged", ((), ())),), fa.addr, fb.addr),
        # 2. congruence step whose subproof proves the wrong pair
        ((C.Step(fa.addr, fb.addr, "congruence", None, "forged",
                 ((), (C.Step(b.addr, c.addr, "assumption", C.Axiom("A:b=c")),))),),
         fa.addr, fb.addr),
        # 3. an assumption citing an axiom that was never declared
        ((C.Step(fa.addr, ga.addr, "assumption", C.Axiom("A:f=g-by-fiat")),), fa.addr, ga.addr),
        # 4. a declared axiom cited for endpoints it does not relate
        ((C.Step(fa.addr, ga.addr, "assumption", C.Axiom("A:a=b/route1")),), fa.addr, ga.addr),
        # 5. a non-contiguous chain
        ((C.Step(a.addr, b.addr, "assumption", C.Axiom("A:a=b/route1")),
          C.Step(c.addr, d.addr, "assumption", C.Axiom("A:d=e"))), a.addr, d.addr),
        # 6. a real path re-labelled to claim a different theorem
        (real, fa.addr, ga.addr),
        # 7. congruence claimed across different head symbols
        ((C.Step(fa.addr, ga.addr, "congruence", None, "forged",
                 ((), ())),), fa.addr, ga.addr),
        # 8. an unknown step kind
        ((C.Step(a.addr, b.addr, "handwave"),), a.addr, b.addr),
        # 9. a Refl between two different addresses
        ((C.Step(a.addr, b.addr, "assumption", C.Refl()),), a.addr, b.addr),
        # 10. a step over an address that was never constructed
        ((C.Step(a.addr, "0" * 32, "assumption", C.Axiom("A:a=b/route1")),), a.addr, "0" * 32),
        # 11. two INDIVIDUALLY VALID steps with a gap between them: a=b, d=e,
        #     offered as a proof of a=e.  Only contiguity catches this one.
        ((C.Step(a.addr, b.addr, "assumption", C.Axiom("A:a=b/route1")),
          C.Step(d.addr, e_.addr, "assumption", C.Axiom("A:d=e"))), a.addr, e_.addr),
        # 12. a valid step, doubled, to claim it reaches further than it does
        ((C.Step(a.addr, b.addr, "assumption", C.Axiom("A:a=b/route1")),
          C.Step(a.addr, b.addr, "assumption", C.Axiom("A:a=b/route1"))), a.addr, b.addr),
    ]
    for i, (pth, src, dst) in enumerate(fakes):
        if C.check_path(pth, src, dst, ctx) is not False:
            LOG.append("    fabrication %d slipped through" % (i + 1))
            return False
    # the real path still checks after all that
    return C.check_path(real, fa.addr, fb.addr, fresh_ctx()) is True


@control("CONTROL L2: retraction must not disturb an unrelated class")
def x_retract_unrelated():
    gr, fa, fb = build_graph()
    before_d = gr.class_of(d)
    before_e = gr.class_of(e_)
    before_expl = gr.explain(d, e_)
    snapshot = {addr: gr.class_of(addr) for addr in gr.terms()}
    gr.retract("E1")
    gr.retract("E2")
    if gr.class_of(d) is not before_d or gr.class_of(e_) is not before_e:
        return False
    if not gr.equal(d, e_):
        return False
    after = gr.explain(d, e_)
    if [s.edge_id for s in after] != [s.edge_id for s in before_expl]:
        return False
    cone = {a.addr, b.addr, fa.addr, fb.addr}
    for addr, cls in snapshot.items():
        if addr in cone:
            continue
        if gr.class_of(addr) is not cls:
            LOG.append("    class of %s outside the cone was rebuilt" % addr[:8])
            return False
    # the planted falsehood: the cone itself HAD to change
    return gr.class_of(a) is not snapshot[a.addr]


@control("CONTROL L2: retracting an unknown edge must be a no-op, not a rebuild")
def x_retract_unknown():
    gr, fa, fb = build_graph()
    before = gr.steps.get("rebuilds")
    if gr.retract("E-does-not-exist") is not False:
        return False
    return gr.steps.get("rebuilds") == before and gr.equal(a, b)


# ==========================================================================
# runner
# ==========================================================================


def counter_demo():
    T.COUNTERS.reset()
    gr, fa, fb = build_graph()
    ctx = fresh_ctx()
    path = gr.explain(fa, fb)
    C.check_path(path, fa.addr, fb.addr, ctx)
    gr.retract("E1")
    path2 = gr.explain(fa, fb)
    C.check_path(path2, fa.addr, fb.addr, ctx)
    lines = [
        "counter demo: f(a), f(b); a=b by two routes; explain+check; retract E1; explain+check",
        "  egraph : %s" % gr.report(),
        "  check  : %s" % ctx.counters.render(),
        "  term   : %s" % T.COUNTERS.render(),
        "  classes: %d, records: %d, sorts/terms interned: %s"
        % (len(gr.classes()), len(gr.records()), T.intern_table_size()),
    ]
    return "\n".join(lines)


def main() -> int:
    passed = failed = 0
    for name, fn in CAPS:
        try:
            ok = bool(fn())
        except Exception as exc:
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s" % name)
        else:
            failed += 1
            print("FAIL  %s" % name)
    for name, fn in CONTROLS:
        try:
            ok = bool(fn())
        except Exception as exc:
            ok = False
            LOG.append("    %s: %r" % (name, exc))
        if ok:
            passed += 1
            print("PASS  %s (planted falsehood was rejected)" % name)
        else:
            failed += 1
            print("FAIL  %s (planted falsehood was ACCEPTED)" % name)
    print()
    print(counter_demo())
    if LOG:
        print()
        print("diagnostics:")
        for line in LOG:
            print(line)
    print()
    print("SUMMARY capabilities=%d controls=%d passed=%d failed=%d"
          % (len(CAPS), len(CONTROLS), passed, failed))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())

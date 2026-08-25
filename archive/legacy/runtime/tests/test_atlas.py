#!/usr/bin/env python3
"""Adversarial test suite for `runtime/atlas` -- the executable atlas of N.

Repo norm (collab/PROTOCOL.md Sec.7, msg 0073): a headline claim ships with its
own annihilation apparatus or it is not a claim.  Every capability below is
paired with planted-false controls that must fail.  A control that passes is a
failure of the suite and is reported as one.

The four controls the lane was commissioned with are C1 (a claimed bijection
that is not one), C2 (an `Iso` installed for a map that is only an embedding),
C3 (a residual claimed trivial that is not), and C5/C6 (a chart claiming an
operation extends to a completion when it does not -- the enumeration successor
on N in R being the canonical case).  C4 is the discriminating counterpart: a
residual claimed *nontrivial* that is trivial must also be refused, or the
checker is just a pessimist.

Run:  python3 runtime/tests/test_atlas.py
Exit: 0 iff every capability passed AND every control failed as designed.

Output is byte-identical across runs: no floats, no clock, no set iteration.
"""

from __future__ import annotations

import itertools
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from fractions import Fraction  # noqa: E402

from runtime.atlas import charts as CH  # noqa: E402
from runtime.atlas import residual as R  # noqa: E402
from runtime.atlas import transitions as X  # noqa: E402
from runtime.kernel import check as C  # noqa: E402
from runtime.kernel import edges as E  # noqa: E402
from runtime.kernel import term as T  # noqa: E402
from runtime.kernel.egraph import EGraph  # noqa: E402
from runtime.kernel.term import Counters  # noqa: E402

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(REPO, "runtime", "demo"))
from atlas_demo import (  # noqa: E402
    honest_embedding,
    planted_embedding_as_iso,
    planted_not_a_bijection,
    planted_trivial_residual,
)

CAPS: list = []
CONTROLS: list = []
LOG: list = []
CNT = Counters()


def capability(name):
    def deco(fn):
        CAPS.append((name, fn))
        return fn
    return deco


def control(name):
    """A planted-false control.  The body returns True iff the runtime
    *rejected* / *detected* the planted falsehood."""
    def deco(fn):
        CONTROLS.append((name, fn))
        return fn
    return deco


def fresh_ctx() -> C.CheckContext:
    return C.CheckContext(fuel=400000)


# ===========================================================================
# the charts
# ===========================================================================

@capability("A1 every chart round-trips datum/value exhaustively on its range")
def t_charts_round_trip():
    for ch in (X.PEANO, X.TALLY, X.CARD, X.ORD, X.DIG10, X.DIG2):
        for n in range(0, 9):
            assert ch.value(ch.datum(n)) == n, (ch.key, n)
    for n in range(1, 60):
        assert X.PRIME.value(X.PRIME.datum(n)) == n, n
    return True


@capability("A2 (a) the recursor computes + and x, and induction is the recursor")
def t_peano_recursor():
    p = X.PEANO
    for a in range(0, 9):
        for b in range(0, 9):
            assert p.value(p.add(p.datum(a), p.datum(b), CNT)) == a + b
            assert p.value(p.mul(p.datum(a), p.datum(b), CNT)) == a * b
    ok, defect = p.induction_holds(lambda n: n * (n + 1) % 2 == 0, 40, CNT)
    assert ok and defect is None
    return True


@capability("A3 (b) the free monoid's universal property, executed into two monoids")
def t_tally_universal():
    t = X.TALLY
    for n in range(0, 12):
        assert t.free_monoid_map(0, lambda a, b: a + b, 1, t.datum(n), CNT) == n
        assert t.free_monoid_map(1, lambda a, b: a * b, 3, t.datum(n), CNT) == 3 ** n
        assert t.free_monoid_map("", lambda a, b: a + b, "ab", t.datum(n), CNT) == "ab" * n
    assert t.concat(t.datum(3), t.datum(4), CNT) == t.datum(7)
    return True


@capability("A4 (c) S_n is an actual computed group: order n!, axioms, orbits")
def t_symmetric_group():
    fact = 1
    for n in range(0, 6):
        fact = fact * n if n else 1
        g = R.symmetric_group(n)
        expected = 1
        for k in range(2, n + 1):
            expected *= k
        assert g.order == expected, (n, g.order, expected)
        rep = g.verify(CNT)
        assert rep.is_group, rep.render()
        assert rep.abelian == (n <= 2), (n, rep.abelian)
        if n >= 1:
            orbits = g.orbits(tuple(range(n)), lambda s, i: s[i], CNT)
            assert len(orbits) == 1, "the natural action of S_n is transitive"
    return True


@capability("A5 (c)->(a) the fibre Iso(X,[n]) is an S_n-torsor of size n!")
def t_iso_torsor():
    for n in range(0, 5):
        tor = X.CARD.iso_torsor(n)
        rep = tor.verify(CNT)
        assert rep.is_torsor, rep.render()
        assert rep.point_count == rep.group_order == R.symmetric_group(n).order
        if n >= 2:
            p, q = tor.points[0], tor.points[1]
            g = tor.translate(p, q, CNT)
            assert tor.act(g, p) == q
    return True


@capability("A6 (d)->(c) linear orders on an n-set form a FREE TRANSITIVE S_n-set")
def t_order_torsor():
    for n in range(0, 5):
        tor = X.ORD.order_torsor(n)
        rep = tor.verify(CNT)
        assert rep.free and rep.transitive and rep.is_torsor, rep.render()
        assert rep.point_count == len(X.ORD.orders(X.ORD.datum(n)))
    return True


@capability("A7 (d) the total space is contractible: exactly one order-iso, always")
def t_contractible_total_space():
    for n in range(0, 5):
        pairs, lo, hi = X.ORD.contractibility_check(n, CNT)
        assert (lo, hi) == (1, 1), (n, lo, hi)
        assert pairs == len(X.ORD.orders(X.ORD.datum(n))) ** 2
    # the contrast that makes it content: n! bijections, exactly 1 of them monotone
    orders = X.ORD.orders(X.ORD.datum(4))
    assert len(orders) == 24
    assert len(X.ORD.order_isomorphisms(orders[0], orders[7], CNT)) == 1
    return True


@capability("A8 (a)<->(b) the comparison map is unique at the finite level")
def t_contractibility_report():
    rep = X.contractibility_report(5, CNT)
    assert rep.comparison_maps == 1 and rep.automorphisms == 1 and rep.unique
    assert rep.functions_enumerated == 6 ** 6
    assert "does NOT establish" in rep.scope
    return True


@capability("A9 (d) ordinal = cardinal below omega, and diverges exactly at omega")
def t_ordinal_arithmetic():
    o = X.ORD
    for m in range(0, 8):
        for n in range(0, 8):
            assert o.add(CH.Ordinal(0, m), CH.Ordinal(0, n)) == CH.Ordinal(0, m + n)
            assert o.mul(CH.Ordinal(0, m), CH.Ordinal(0, n)) == CH.Ordinal(0, m * n)
    one, two = CH.Ordinal(0, 1), CH.Ordinal(0, 2)
    assert one + CH.OMEGA == CH.OMEGA and CH.OMEGA + one != CH.OMEGA
    assert two * CH.OMEGA == CH.OMEGA and CH.OMEGA * two == CH.Ordinal(2, 0)
    assert o.divergence_at_omega() == (("1+omega", "omega", "omega+1"),
                                       ("2*omega", "omega", "omega*2"))
    return True


@capability("A10 (e) L is a bijection words->[0,b^k), and zero padding is its whole kernel")
def t_digit_bijection():
    for d in (X.DIG10, X.DIG2, CH.DigitChart(3, "big")):
        for k in range(0, 4):
            vals = sorted(d.value(w) for w in d.words(k))
            assert vals == list(range(d.b ** k)), (d.key, k)
        ok, detail = d.kernel_check(3, CNT)
        assert ok, detail
    return True


@capability("A11 (e) the carry is a normalized 2-cocycle with a nonzero class")
def t_carry_cocycle():
    for b, n in ((2, 1), (2, 2), (3, 1), (5, 1), (10, 1)):
        rep = R.carry_cocycle(b, n).verify(CNT)
        assert rep.is_cocycle and rep.normalized, rep.render()
        assert rep.class_is_nonzero, rep.render()
        lhs, rhs = R.splitting_exponent_argument(b, b ** n)
        assert lhs < rhs, (b, n, lhs, rhs)
    # exhaustive: NO section of Z/b^{n+1} -> Z/b^n is additive (A5's falsifier)
    for b, n in ((2, 1), (2, 2), (3, 1), (5, 1)):
        assert R.exhaustive_section_search(b, b ** n) is False, (b, n)
    return True


@capability("A12 (e) the endian Z/2-torsor, with the exact defect fraction")
def t_endian():
    for b in (2, 3, 10):
        d = CH.DigitChart(b, "little")
        rep = d.endian_torsor().verify(CNT)
        assert rep.is_torsor, rep.render()
        for n in (1, 2):
            agree, total, defect = d.endian_agreement(n, CNT)
            assert agree == b, (b, n, agree)                    # the b constant strings
            assert total == b ** (n + 1)
            assert defect == 1 - Fraction(1, b ** n), (b, n, defect)
        assert d.reversal_conjugates(2, CNT)
    return True


@capability("A13 (e) the base residual is rad(b), and translation is one-way")
def t_base_residual():
    ten, two, three, twelve = (CH.DigitChart(b) for b in (10, 2, 3, 12))
    assert (ten.radical(), two.radical(), twelve.radical()) == (10, 2, 6)
    assert ten.base_translates_to(two)          # rad 2 | rad 10
    assert not two.base_translates_to(ten)      # rad 10 does not divide rad 2
    assert not two.base_translates_to(three)
    rows = two.base_translation_witness(ten, 5)
    assert [g for _k, g, _h in rows] == [Fraction(1, 2 ** k) for k in range(5)]
    assert all(h == 1 for _k, _g, h in rows), "|2^k|_10 = 1 for every k"
    return True


@capability("A14 (f) FTA, and multiplication as addition of exponent vectors")
def t_prime_chart():
    p = X.PRIME
    for n in range(1, 80):
        assert p.value(p.datum(n)) == n
    for a in range(1, 20):
        for b in range(1, 20):
            assert p.value(p.mul(p.datum(a), p.datum(b), CNT)) == a * b
    assert p.completely_multiplicative(lambda q: q + 1, 12, CNT) == 3 * 3 * 4
    return True


@capability("A15 (f) the successor is not definable from the multiplicative chart")
def t_addition_residual():
    p = X.PRIME
    holds, wit = p.successor_not_definable(counters=CNT)
    assert holds and wit["sigma"] == "(2 3)"
    assert wit["sigma_hat(n+1)"] != wit["sigma_hat(n)+1"]
    # a finite parameter set does not help: a fresh transposition always exists
    for params in ((), (2,), (2, 3, 5, 7, 11), tuple(CH.primes_up_to(30))):
        holds, wit = p.successor_not_definable(params=params, counters=CNT)
        assert holds, params
        assert all(int(x) not in params
                   for x in wit["sigma"].strip("()").split())
    # the sharper form: the complete invariant cannot see succ
    a, b, ma, mb = p.invariant_collision(CNT)
    assert p.exponent_multiset(a) == p.exponent_multiset(b) == (1,)
    assert ma != mb, (ma, mb)
    return True


@capability("A16 (e)<->(f) locality of divisibility holds exactly when d | b^k")
def t_locality():
    for b in (2, 10):
        d = CH.DigitChart(b)
        for dd in range(1, 21):
            for k in range(0, 4):
                assert d.residue_is_local(dd, k, CNT) == ((b ** k) % dd == 0), (b, dd, k)
        assert d.shared_locus_with_primes() == ((2,) if b == 2 else (2, 5))
    return True


# ===========================================================================
# the transitions
# ===========================================================================

@capability("A17 every transition installs with the kind its exhaustive check licenses")
def t_all_transitions_install():
    ctx, g, c = fresh_ctx(), EGraph(), Counters()
    kinds = {}
    for t in X.TRANSITIONS:
        rep = t.install(g, ctx, c)
        assert rep.installed, (t.key, rep.reason)
        ok, why = rep.bijection.satisfies(t.kind)
        assert ok, why
        kinds[t.key] = rep.kind
    assert kinds == {"a<->b": "Iso", "c->a": "Quotient", "d->c": "Quotient",
                     "d->a": "Iso", "a->e(b=10)": "Iso", "a->e(b=2)": "Iso",
                     "a->f": "Iso", "e->f": "Implies"}, kinds
    assert g.steps.get("directed_edges") > 0
    return True


@capability("A18 every Iso edge is machine-checked by the kernel, from scratch")
def t_iso_edges_machine_checked():
    total = 0
    for t in X.TRANSITIONS:
        if t.kind != "Iso":
            continue
        ctx = fresh_ctx()                      # no certificates: nothing to lean on
        for e, ok in t.kernel_edges(ctx, CNT):
            assert e.kind == "Iso" and ok, (t.key, e.label, ctx.errors[-1:])
            assert isinstance(e.witness, C.IsoWitness)
            total += 1
    assert total >= 60, total
    return True


@capability("A19 all six presentations of n normalise to church(n), with distinct addresses")
def t_presentations_normalise():
    for n in range(0, 13):
        terms = {
            "peano": X.PEANO.term(n), "tally": X.TALLY.term(n),
            "cardinal": X.CARD.term(n), "ordinal": X.ORD.term(n),
            "digit10": X.DIG10.term(n), "digit2": X.DIG2.term(n),
        }
        if n >= 1:
            terms["prime"] = X.PRIME.term(n)
        for key, t in terms.items():
            assert CH.normal_value(t) == n, (key, n)
        addrs = sorted(set(t.addr for t in terms.values()))
        assert len(addrs) == len(terms), ("presentations collapsed at n=%d" % n, addrs)
    return True


@capability("A20 Residual 2.1 at L0: Peano's + and the free monoid's concat are one address")
def t_plus_is_concat():
    assert CH.PLUS_T is CH.CONCAT_T
    assert CH.PLUS_T.addr == CH.CONCAT_T.addr
    # and the *elements* are still two constructions, not one
    assert X.PEANO.term(5).addr != X.TALLY.term(5).addr
    return True


# ===========================================================================
# CRYSTAL.md Sec.4 -- reachability and the two completions
# ===========================================================================

@capability("A21 every chart's Sec.4 declaration is complete and checks out")
def t_reachability():
    for ch in (X.PEANO, X.TALLY, X.CARD, X.ORD, X.DIG10, X.PRIME):
        d = ch.reachability()
        for fld in (d.generated_locus, d.exact_image, d.equivalence_kernel,
                    d.omitted_locus):
            assert fld and len(fld) > 10, (ch.key, fld)
        assert d.closure and d.extends and d.finite_address_only, ch.key
        rep = ch.reachability_report(3 if isinstance(ch, CH.DigitChart) else 6, CNT)
        assert rep.ok, rep.render()
        assert rep.omitted_witness is not None
    return True


@capability("A22 N is closed and discrete in R, and dense but not closed in Z_b")
def t_two_completions_geometry():
    Rw = CH.ArchimedeanWindow()
    assert Rw.separation() == Fraction(1)
    disc, radius = Rw.discreteness_witness(CNT)
    assert disc and radius == Fraction(1, 2)
    assert Rw.cauchy_sequences_are_eventually_constant(CNT)
    x, gap = Rw.density_failure()
    assert gap == Fraction(1, 2) and x == Fraction(1, 2)
    for b in (2, 10):
        Zw = CH.BAdicWindow(b=b)
        dense, depth = Zw.density_witness(CNT)
        assert dense and depth == Zw.depth
        closed, wit = Zw.not_closed_witness(CNT)
        assert closed and wit["cauchy"] and not wit["limit_in_N"]
        assert wit["sequence"][0] == b - 1
    return True


@capability("A23 the four operation-extension verdicts, and the no-map witness")
def t_two_completions_operations():
    verdicts, nomap = CH.two_completions_report(10, CNT)
    assert len(verdicts) == 4
    for v in verdicts:
        assert v.agrees, v.render()
    got = {(v.claim.completion, v.claim.operation): v.holds for v in verdicts}
    assert got == {("R", "arithmetic successor x+1"): True,
                   ("R", "enumeration successor"): False,
                   ("Z_b", "odometer T(x)=x+1"): True,
                   ("Z_b", "order relation <"): False}, got
    gauges = [g for _k, _x, g, _a in nomap["rows"]]
    arch = [a for _k, _x, _g, a in nomap["rows"]]
    assert gauges == sorted(gauges, reverse=True) and gauges[-1] < gauges[0]
    assert arch == sorted(arch) and arch[-1] > arch[0]
    assert "compact" in nomap["obstruction_Zb_to_R"]
    assert "connected" in nomap["obstruction_R_to_Zb"]
    return True


@capability("A24 the whole atlas builds: 6 charts, 8 transitions, 19 residuals")
def t_build_atlas():
    rep = X.build_atlas()
    assert rep.all_installed, [r.reason for r in rep.installs if not r.installed]
    assert len(rep.charts) == 6 and len(rep.installs) == 8
    assert sum(len(r.residuals) for r in rep.installs) == 19
    assert all(rr.agrees and rr.ok for r in rep.installs for rr in r.residuals)
    assert rep.graph_edges == 97, rep.graph_edges
    machine = sum(r.edges_checked for r in rep.installs if r.machine_verified)
    assert machine == 84, machine
    return True


@capability("A25 the demo runs, is byte-identical across PYTHONHASHSEED, has a null control")
def t_demo_deterministic():
    path = os.path.join(REPO, "runtime", "demo", "atlas_demo.py")
    env = dict(os.environ)
    a = subprocess.run([sys.executable, path], capture_output=True, env=env)
    env["PYTHONHASHSEED"] = "12345"
    b = subprocess.run([sys.executable, path], capture_output=True, env=env)
    assert a.returncode == 0 and b.returncode == 0, (a.returncode, b.returncode)
    assert a.stdout == b.stdout, "demo output is not deterministic"
    assert b"NULL CONTROL" in a.stdout and b"PLANTED-FALSE" in a.stdout
    return True


@capability("A26 no float is constructed anywhere in the package")
def t_no_floats():
    import runtime.atlas.charts as m1
    import runtime.atlas.residual as m2
    import runtime.atlas.transitions as m3
    for mod in (m1, m2, m3):
        src = open(mod.__file__).read()
        for bad in ("float(", "math.sqrt", "0.5", "1.0", "/ 2.0"):
            assert bad not in src, (mod.__name__, bad)
    # and the metrics really are exact
    assert isinstance(CH.badic_gauge(24, 2), Fraction)
    assert CH.badic_gauge(24, 2) == Fraction(1, 8)
    assert CH.badic_gauge(0, 2) == 0
    return True


# ===========================================================================
# planted-false controls
# ===========================================================================

@control("C1 a claimed bijection that is not one must be caught by exhaustion")
def x_not_a_bijection():
    rep = planted_not_a_bijection().install(None, fresh_ctx(), CNT)
    return (not rep.installed and not rep.bijection.injective
            and rep.edges_offered == 0 and "Iso claimed" in rep.reason)


@control("C2 an Iso installed for a map that is only an embedding must be refused")
def x_embedding_as_iso():
    t = planted_embedding_as_iso()
    rep = t.install(None, fresh_ctx(), CNT)
    if rep.installed or rep.bijection.surjective or not rep.bijection.injective:
        return False
    # second, independent defence: the kernel cannot normalise n and 2n alike
    ctx = fresh_ctx()
    e = E.Edge("Iso", X.PEANO.term(3).addr, X.PEANO.term(6).addr,
               witness=C.IsoWitness(CH.ID_CH, CH.ID_CH))
    if C.check_edge(e, ctx) is not False:
        return False
    # and the same map, declared honestly as an Embed, DOES install
    return honest_embedding().install(None, fresh_ctx(), CNT).installed


@control("C15 the KIND CHECK ALONE must refuse a non-surjective Iso (no kernel backstop)")
def x_iso_surjectivity_without_kernel():
    """C2 has two independent defences and would pass on either.

    A mutation round found exactly that: weakening ``is_bijection`` to drop
    surjectivity left C2 green, because the kernel still refused to normalise
    ``n`` and ``2n`` to one numeral.  This control removes the kernel's help --
    the transition offers no term pairs at all -- so only the exhaustive kind
    check can catch it.
    """
    t = planted_embedding_as_iso()
    naked = X.Transition(key="PLANT/double-naked", src=t.src, dst=t.dst, kind="Iso",
                         range_note=t.range_note, domain=t.domain,
                         codomain=t.codomain, forward=t.forward, residuals=(),
                         note="planted", term_pairs=lambda: [])
    rep = naked.install(None, fresh_ctx(), CNT)
    return (not rep.installed and rep.edges_offered == 0
            and "surjective=False" in rep.reason
            and rep.bijection.injective and rep.bijection.well_defined)


@control("C3 a residual claimed trivial that is not must block the install")
def x_false_trivial_residual():
    rep = planted_trivial_residual().install(None, fresh_ctx(), CNT)
    return not rep.installed and "declared trivial=True" in rep.reason


@control("C4 a residual claimed NONtrivial that is trivial must also be refused")
def x_false_nontrivial_residual():
    lying = R.Residual("S_1 (claimed nontrivial)", R.GROUP, R.symmetric_group(1),
                       False, "planted: S_1 is trivial and the claim says otherwise")
    real = X.transition("c->a")
    t = X.Transition(key="PLANT/S1", src=real.src, dst=real.dst, kind=real.kind,
                     range_note=real.range_note, domain=real.domain,
                     codomain=real.codomain, forward=real.forward,
                     residuals=(lying,), note="planted", term_pairs=lambda: [],
                     certificate_name="cert:plant/s1")
    rep = t.install(None, fresh_ctx(), CNT)
    return not rep.installed and "declared trivial=False" in rep.reason


@control("C5 'the enumeration successor extends to R' must be refuted")
def x_enumeration_successor_extends():
    claim = CH.CompletionClaim("R", "enumeration successor", True)
    holds, wit = CH.ArchimedeanWindow().enumeration_successor_extends(CNT)
    v = CH.ClaimVerdict(claim, holds, wit, "")
    return (not v.agrees) and (not holds) and wit["jump"] == 1


@control("C6 'the order extends to Z_b' must be refuted")
def x_order_extends_badic():
    claim = CH.CompletionClaim("Z_b", "order relation <", True)
    holds, wit = CH.BAdicWindow(b=10).order_extends(CNT)
    v = CH.ClaimVerdict(claim, holds, wit, "")
    return (not v.agrees) and (not holds) and wit["same_gauge"] is True


@control("C7 claiming machine verification for a Quotient must raise")
def x_trust_boundary():
    real = X.transition("c->a")
    rep = real.install(None, fresh_ctx(), CNT)
    try:
        X.InstallReport(rep.key, "Quotient", True, "", rep.bijection, rep.residuals,
                        1, 1, True, 0)
    except X.TrustBoundaryError:
        return rep.machine_verified is False
    return False


@control("C8 a transitive but non-free action must not pass as a torsor")
def x_not_a_torsor():
    g = R.symmetric_group(3)
    tor = R.Torsor("S_3 on [3] (natural action)", g, (0, 1, 2), lambda s, i: s[i])
    rep = tor.verify(CNT)
    if rep.free or not rep.transitive or rep.is_torsor:
        return False
    if rep.free_defect is None:
        return False
    # translate must refuse to hand back a non-unique element
    try:
        tor.translate(0, 1, CNT)
        return False
    except R.ResidualError:
        return True


@control("C9 a carry-free digit set must not be found -- and a real coboundary must be")
def x_carry_free():
    # negative: no section of Z/4 -> Z/2 is additive, checked over all 4 sections
    if R.exhaustive_section_search(2, 2) is not False:
        return False
    if R.carry_cocycle(2, 1).verify(CNT).is_coboundary is not False:
        return False
    # positive control: a genuine coboundary IS recognised as one
    f = (0, 1, 0)
    vals = tuple(tuple((f[u] + f[v] - f[(u + v) % 3]) % 3 for v in range(3))
                 for u in range(3))
    rep = R.Cocycle("delta f", 3, 3, vals).verify(CNT)
    return (rep.is_cocycle and rep.is_coboundary is True
            and rep.class_is_nonzero is False)


@control("C10 a planted wrong successor must break the contractibility verdict")
def x_wrong_successor():
    shifted = X.contractibility_report(5, CNT, lambda x: (x + 2) % 6)
    holed = X.contractibility_report(5, CNT, lambda x: None if x == 2 else x + 1)
    constant = X.contractibility_report(5, CNT, lambda x: 0)
    # a shifted successor still admits exactly one map -- but it is NOT the
    # identity, which is precisely what `unique` tests; a hole admits none.
    return (shifted.comparison_maps == 1 and not shifted.unique
            and holed.comparison_maps == 0 and not holed.unique
            and not constant.unique)


@control("C11 a Quotient claimed for a bijection must be refused")
def x_quotient_for_bijection():
    real = X.transition("d->a")
    t = X.Transition(key="PLANT/quot", src=real.src, dst=real.dst, kind="Quotient",
                     range_note=real.range_note, domain=real.domain,
                     codomain=real.codomain, forward=real.forward,
                     residuals=(), note="planted", term_pairs=lambda: [],
                     certificate_name="cert:plant/quot")
    rep = t.install(None, fresh_ctx(), CNT)
    return not rep.installed and "Quotient claimed" in rep.reason


@control("C12 an Iso claimed for pi_0 (which is not injective) must be refused")
def x_iso_for_pi0():
    real = X.transition("c->a")
    t = X.Transition(key="PLANT/pi0iso", src=real.src, dst=real.dst, kind="Iso",
                     range_note=real.range_note, domain=real.domain,
                     codomain=real.codomain, forward=real.forward,
                     residuals=(), note="planted", term_pairs=real.term_pairs)
    rep = t.install(None, fresh_ctx(), CNT)
    return not rep.installed and not rep.bijection.injective


@control("C13 a chart must refuse to be used outside the range it declares")
def x_out_of_range():
    ok = True
    for fn in (lambda: X.ORD.datum(len(CH.ATOMS) + 1),
               lambda: X.CARD.datum(len(CH.ATOMS) + 1),
               lambda: X.PRIME.datum(0),
               lambda: CH.DigitChart(1),
               lambda: CH.DigitChart(10, "middle"),
               lambda: CH.church(-1)):
        try:
            fn()
            ok = False
        except CH.ChartError:
            pass
    try:
        R.carry_cocycle(2, 0)
        ok = False
    except R.ResidualError:
        pass
    return ok


@control("C14 an unlicensed composite of atlas edges must not be manufactured")
def x_composite():
    ctx = fresh_ctx()
    q = X.transition("c->a").kernel_edges(ctx, CNT)[0][0]
    i = X.transition("a->f").kernel_edges(ctx, CNT)[0][0]
    # Quotient then Iso is licensed (Quotient); Implies then Quotient is not
    imp = X.transition("e->f").kernel_edges(ctx, CNT)[0][0]
    bad = E.compose(imp, E.Edge("Quotient", imp.dst, q.dst))
    return bad is None and E.compose_kind("Quotient", "Iso") == "Quotient" and i.kind == "Iso"


# ===========================================================================

def counter_demo() -> str:
    c = Counters()
    ctx, g = fresh_ctx(), EGraph()
    rep = X.build_atlas(c, ctx, g)
    lines = ["counter demo: the atlas of N, built end to end",
             "  charts       : %d, all Sec.4 declarations checked" % len(rep.charts),
             "  transitions  : %d installed, %d machine-checked Iso edges"
             % (len(rep.installs),
                sum(r.edges_checked for r in rep.installs if r.machine_verified)),
             "  residuals    : %d computed objects"
             % sum(len(r.residuals) for r in rep.installs),
             "  S_n orders   : %s"
             % ", ".join("S_%d=%d" % (n, R.symmetric_group(n).order) for n in range(5)),
             "  torsors      : LinOrd(4) free+transitive over S_4 (24 = 24), "
             "Iso(X,[4]) likewise",
             "  carry class  : %s" % R.carry_cocycle(2, 1).verify(c).render(),
             "  atlas        : %s" % c.render(),
             "  kernel       : %s" % ctx.counters.render(),
             "  egraph       : %s" % g.report()]
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

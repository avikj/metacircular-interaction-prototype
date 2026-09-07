#!/usr/bin/env python3
"""Adversarial tests for derivation crystallization.

Run standalone:   python3 runtime/tests/test_crystallize.py
or under pytest:  pytest runtime/tests/test_crystallize.py

Every test that asserts a *positive* result is paired with a planted control
that must fail.  A test suite in which nothing is ever rejected is testing an
oracle, not an algorithm.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.antiunify import (antiunify, antiunify_tuples,      # noqa: E402
                                           is_strictly_more_general, recover,
                                           variable_positions)
from runtime.crystallize.derivation import (CheckFailure, Counter,           # noqa: E402
                                            Divergence, I, Lemma, LemmaIndex,
                                            P, PV, S, Step, Sub, V,
                                            check_derivation, match, normalize,
                                            poly_equal, pvars_of, render, subst)
from runtime.crystallize.install import Book, ground, solve, verify          # noqa: E402
from runtime.crystallize.mine import (Candidate, mine, reconstruction_ok,    # noqa: E402
                                      segments)

x, y, z, u, v, w = (V(n) for n in "xyzuvw")


def dos(a, b):
    return P(S(V(a), V(b)), Sub(V(a), V(b)))


def sq(a, b):
    return P(S(V(a), V(b)), S(V(a), V(b)))


def _train(pairs):
    return [normalize(t, name=n)[0] for n, t in pairs]


DSQ_TRAIN = [("P1", dos("x", "y")),
             ("P2", S(I(7), dos("u", "v"))),
             ("P3", S(dos("a", "b"), V("a")))]
SQ_TRAIN = [("Q1", sq("x", "y")),
            ("Q2", S(I(5), sq("u", "v"))),
            ("Q3", S(sq("a", "b"), V("a")))]


def _dsq_book():
    b = Book()
    c = mine(_train(DSQ_TRAIN))[0]
    assert b.install_candidate("dsq", c).ok
    return b, c


def _sq_book():
    b = Book()
    c = mine(_train(SQ_TRAIN))[0]
    assert b.install_candidate("psq", c).ok
    return b, c


# ==========================================================================
# 1. Anti-unification must not over-generalise
# ==========================================================================

def test_same_mismatch_pair_shares_one_variable():
    """POSITIVE: two positions with the SAME disagreeing subterms -> one var."""
    g, _ = antiunify([P(x, x), P(u, u)])
    vp = variable_positions(g)
    assert len(vp) == 1, "expected exactly one variable, got %s" % render(g)
    assert vp[list(vp)[0]] == [(0,), (1,)], "the one variable must cover both"


def test_different_mismatch_pairs_get_different_variables():
    """PLANTED CONTROL: sharing here would be unsound."""
    g, _ = antiunify([P(x, y), P(u, u)])
    vp = variable_positions(g)
    assert len(vp) == 2, "must NOT collapse (x,u) and (y,u): %s" % render(g)


def test_mixed_agreement_and_disagreement():
    g, _ = antiunify([P(x, y, x), P(u, v, u)])
    vp = variable_positions(g)
    assert len(vp) == 2
    names = sorted(vp)
    assert vp[names[0]] == [(0,), (2,)], "repeated x/u pair must be one var"
    assert vp[names[1]] == [(1,)]


def test_identical_subterms_are_not_abstracted():
    g, _ = antiunify([P(x, I(3)), P(u, I(3))])
    assert len(variable_positions(g)) == 1, "the shared 3 must stay concrete"


def test_lgg_is_least_not_merely_general():
    """The LGG must be strictly LESS general than the sloppy alternative."""
    rows = [(dos("x", "y"),), (dos("u", "v"),), (dos("a", "b"),)]
    (lgg,), _ = antiunify_tuples(rows)
    sloppy = P(S(PV(0), PV(1)), S(PV(2), P(I(-1), PV(3))))
    assert match(lgg, dos("m", "n")) is not None, "lgg must still generalise"
    assert is_strictly_more_general(sloppy, lgg), \
        "the 4-variable pattern must be strictly more general than the LGG"
    assert match(lgg, P(S(x, y), Sub(u, v))) is None, \
        "the LGG must NOT match a term whose two factors disagree"


def test_shared_variable_map_across_lhs_and_rhs():
    """One Generalizer over (lhs, rhs) must reuse variables on both sides."""
    rows = [(dos(a, b), S(P(V(a), V(a)), P(I(-1), V(b), V(b))))
            for a, b in [("x", "y"), ("u", "v"), ("a", "b")]]
    (lhs, rhs), g = antiunify_tuples(rows)
    assert set(v.val for v in pvars_of(rhs)) <= set(
        v.val for v in pvars_of(lhs)), "rhs must reuse the lhs parameters"
    for i in range(3):
        assert recover(lhs, i, g).addr == rows[i][0].addr
        assert recover(rhs, i, g).addr == rows[i][1].addr


def test_recover_witnesses_every_instance():
    c = mine(_train(DSQ_TRAIN))[0]
    assert reconstruction_ok(c)
    for i, seg in enumerate(c.instances):
        assert recover(c.lhs, i, c.gen).addr == seg.u.addr
        assert recover(c.rhs, i, c.gen).addr == seg.v.addr


# ==========================================================================
# 2. Mining: support must come from DIFFERENT derivations
# ==========================================================================

def test_mining_finds_the_shared_subdag():
    c = mine(_train(DSQ_TRAIN))[0]
    assert c.support == 3
    assert sorted(s.deriv.name for s in c.instances) == ["P1", "P2", "P3"]
    assert [list(s.pos) for s in c.instances] == [[], [1], [0]], \
        "the same sub-DAG must be found at three different positions"


def test_self_repetition_inside_one_derivation_is_not_support():
    """PLANTED CONTROL: a pattern repeating inside ONE problem is a loop."""
    d = _train([("R", S(dos("x", "y"), dos("u", "v")))])
    cands = mine(d, min_support=2)
    assert all(c.support >= 2 for c in cands)
    assert cands == [] or all(len({s.deriv.name for s in c.instances}) >= 2
                              for c in cands), \
        "support must count derivations, never occurrences"


def test_mining_cost_is_bounded_by_the_window():
    """The stated bound must actually hold, with no slack fudge factor.

    Charged work is one unit per (i, j) segment candidate -- at most
    ``L * window`` per derivation -- plus one unit per mined instance, of
    which there are at most one per derivation per surviving candidate.
    """
    for window in (4, 8, 24):
        ctr = Counter()
        ds = _train(DSQ_TRAIN)
        cands = mine(ds, window=window, ctr=ctr)
        seg_bound = sum(len(d) * window for d in ds)
        inst = sum(len(c.instances) for c in cands)
        assert ctr.work <= seg_bound + inst, \
            "window=%d: work %d exceeds O(D*L*window)=%d + %d instances" % (
                window, ctr.work, seg_bound, inst)


def test_mining_cost_grows_polynomially_not_exponentially():
    """Doubling the trace length must not square the work, let alone worse."""
    small = _train([("A", dos("x", "y"))])
    big = _train([("B", S(dos("x", "y"), dos("u", "v"), dos("p", "q")))])
    ca, cb = Counter(), Counter()
    mine(small + small, ctr=ca)
    mine(big + big, ctr=cb)
    ratio_len = len(big[0]) // len(small[0])
    assert cb.work <= ca.work * ratio_len * 4, \
        "mining cost is superlinear in trace length: %d -> %d" % (
            ca.work, cb.work)


# ==========================================================================
# 3. Checking: a lemma that fails must be rejected
# ==========================================================================

def test_overgeneral_lemma_is_rejected():
    """PLANTED FALSE: the anti-unification WITHOUT a consistent variable map."""
    _, c = _dsq_book()
    over = P(S(PV(0), PV(1)), S(PV(2), P(I(-1), PV(3))))
    vd = verify(over, c.rhs)
    assert not vd.ok
    assert not poly_equal(ground(over), ground(c.rhs))
    assert dict(vd.gates)["G7"] is False, "semantics must catch it"
    assert dict(vd.gates)["G5"] is False, "syntactic replay must catch it too"


def test_sign_flipped_lemma_is_rejected():
    """PLANTED FALSE: (a+b)(a-b) = a^2 + b^2."""
    vd = verify(P(S(PV(0), PV(1)), Sub(PV(0), PV(1))),
                S(P(PV(0), PV(0)), P(PV(1), PV(1))))
    assert not vd.ok and dict(vd.gates)["G7"] is False


def test_unbound_rhs_variable_is_rejected():
    """PLANTED FALSE: a rewrite that invents a value."""
    vd = verify(P(S(PV(0), PV(1)), Sub(PV(0), PV(1))),
                S(P(PV(0), PV(0)), P(I(-1), PV(2), PV(2))))
    assert not vd.ok and dict(vd.gates)["G1"] is False


def test_pattern_not_actually_shared_produces_a_lemma_that_fails_the_check():
    """PLANTED FALSE: a forged 'repeated' pattern.

    Pair a difference-of-squares segment with a perfect-square segment and
    anti-unify them as if they were the same sub-DAG.  The generalisation is
    perfectly well formed and even reconstructs both 'instances' -- and it is
    not a theorem.  The installer must destroy it.
    """
    dsq_d = _train(DSQ_TRAIN)[0]
    sq_d = _train(SQ_TRAIN)[0]
    s1 = segments(dsq_d, min_len=len(dsq_d))[0]
    s2 = segments(sq_d, min_len=len(sq_d))[0]
    assert s1.key != s2.key, "these really are different sub-DAGs"
    (lhs, rhs), g = antiunify_tuples([(s1.u, s1.v), (s2.u, s2.v)])
    forged = Candidate(s1.key, [s1, s2], lhs, rhs, g)
    assert reconstruction_ok(forged), \
        "the forgery passes the cheap LGG witness -- that is the point"
    b = Book()
    vd = b.install_candidate("forged", forged)
    assert not vd.ok, "a forged pattern must not become a lemma: %s" % vd
    assert len(b) == 0, "nothing may be installed after a rejection"


def test_true_but_differently_proved_lemma_fails_fidelity():
    """G4 is deliberately strict: a true statement whose proof is not the
    mined sub-DAG is not a crystallisation of it."""
    lhs = P(S(PV(0), PV(1)), Sub(PV(0), PV(1)))
    rhs = S(P(I(-1), PV(1), PV(1)), P(PV(0), PV(0)))
    assert verify(lhs, rhs).ok, "with no claimed provenance it is a theorem"
    vd = verify(lhs, rhs, expected_rules=["distrib", "collect"])
    assert not vd.ok and dict(vd.gates)["G4"] is False


def test_checker_catches_a_tampered_step():
    """PLANTED FALSE: forge a derivation step and demand the checker notice."""
    d, _ = normalize(P(S(x, y), Sub(x, y)), name="T")
    st = d.steps[3]
    d.steps[3] = Step(st.index, st.rule, st.pos, st.redex, I(0),
                      st.before, st.after)
    try:
        check_derivation(d, {})
    except CheckFailure:
        return
    raise AssertionError("the checker accepted a forged contractum")


def test_checker_catches_a_forged_lemma_application():
    book, _ = _dsq_book()
    lem = book.lemmas[0]
    liar = Lemma("dsq", lem.lhs, S(P(PV(0), PV(0)), P(PV(1), PV(1))))
    d, _ = normalize(P(S(x, y), Sub(x, y)), lemmas=(lem,), name="L")
    try:
        check_derivation(d, {"dsq": liar})
    except CheckFailure:
        return
    raise AssertionError("the checker accepted a lemma step it cannot justify")


def test_divergent_lemma_raises_rather_than_lying():
    """A commutativity 'lemma' is true and loops.  The guard must fire."""
    loop = Lemma("loop", S(PV(0), PV(1)), S(PV(1), PV(0)))
    try:
        normalize(S(x, y), lemmas=(loop,), name="D")
    except Divergence:
        return
    raise AssertionError("a cycling lemma was not detected")


# ==========================================================================
# 4. An installed lemma must not change any answer
# ==========================================================================

BATTERY = [
    P(S(x, y), Sub(x, y)),
    S(P(S(x, y), Sub(x, y)), I(3)),
    P(S(x, I(2)), Sub(x, I(2))),
    P(S(P(x, x), P(I(3), y)), Sub(P(x, x), P(I(3), y))),
    S(P(x, y), P(y, x)),
    P(S(x, y, z), S(u, v)),
    S(I(0), P(I(1), x)),
    P(I(0), S(x, y)),
    Sub(P(S(x, y), S(x, y)), P(I(2), x, y)),
    S(P(I(9), y, y), P(I(-9), y, y)),
    P(S(x, y), S(x, y), S(x, y)),
    S(x, Sub(y, x)),
    P(Sub(x, y), S(x, y)),
    S(P(S(u, v), Sub(u, v)), P(S(x, y), Sub(x, y))),
]


def test_installed_lemmas_never_change_an_answer():
    dsq, _ = _dsq_book()
    psq, _ = _sq_book()
    both = Book()
    both.lemmas = dsq.lemmas + psq.lemmas
    for t in BATTERY:
        base, _ = solve(t, None, name="b")
        for tag, bk in [("dsq", dsq), ("psq", psq), ("both", both)]:
            got, _ = solve(t, bk, name=tag)
            assert got.result.addr == base.result.addr, \
                "%s changed the answer for %s: %s vs %s" % (
                    tag, render(t), render(got.result), render(base.result))
        assert poly_equal(t, base.result), "normal form is not the input"


def test_lemma_steps_are_kernel_checked_in_context():
    dsq, _ = _dsq_book()
    for t in BATTERY:
        d, ctr = solve(t, dsq, name="k")
        assert d.chain_ok()
        assert ctr.checks == ctr.steps, "every step must be checked exactly once"


# ==========================================================================
# 5. The seed criterion, as a test
# ==========================================================================

P4 = S(P(S(P(x, x), P(I(3), y)), Sub(P(x, x), P(I(3), y))), P(I(9), y, y))


def test_p4_is_independent_of_the_training_problems():
    from runtime.demo.crystallize_demo import as_pattern
    for _, t in DSQ_TRAIN:
        assert match(as_pattern(t), P4) is None


def test_seed_criterion_strict_reduction_and_null_control():
    dsq, _ = _dsq_book()
    psq, _ = _sq_book()
    base, cb = solve(P4, None, name="base")
    fast, cf = solve(P4, dsq, name="fast")
    null, cn = solve(P4, psq, name="null")
    assert cf.steps < cb.steps, "no reduction: %d vs %d" % (cf.steps, cb.steps)
    assert cn.steps == cb.steps, \
        "NULL CONTROL FAILED: an irrelevant lemma changed the cost (%d vs %d)" \
        % (cn.steps, cb.steps)
    assert base.result.addr == fast.result.addr == null.result.addr
    assert poly_equal(P4, fast.result)
    assert fast.result.addr == P(x, x, x, x).addr


def test_demo_is_deterministic_and_passes():
    from runtime.demo.crystallize_demo import main
    import io
    import contextlib
    outs = []
    for _ in range(2):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = main()
        assert rc == 0, "the demo reported failure"
        outs.append(buf.getvalue())
    assert outs[0] == outs[1], "the demo is not deterministic"


# ==========================================================================
# 6. The substrate itself
# ==========================================================================

def test_addresses_are_structural_not_identity_based():
    assert P(x, y).addr == P(V("x"), V("y")).addr
    assert P(x, y).addr != P(y, x).addr


def test_poly_equal_is_a_decision_not_a_sample():
    assert poly_equal(P(S(x, y), Sub(x, y)), Sub(P(x, x), P(y, y)))
    assert not poly_equal(P(S(x, y), Sub(x, y)), S(P(x, x), P(y, y)))
    assert not poly_equal(S(x, I(1)), S(x, I(2)))
    assert poly_equal(P(S(x, I(1)), S(x, I(1))), S(P(x, x), P(I(2), x), I(1)))


def _big_book(n):
    """A book of ``n`` gate-checked lemmas: the mined one plus filler.

    The filler lemmas are true by construction and installed through the same
    seven gates, and every one of them uses a literal >= 11, which no term in
    these tests contains -- so they can only cost search, never change an
    answer.
    """
    b, _ = _dsq_book()
    c = 11
    while len(b) < n:
        lhs = P(S(PV(0), I(c)), Sub(PV(0), I(c)))
        rhs, _ = normalize(P(S(V("$g0"), I(c)), Sub(V("$g0"), I(c))), name="f")
        assert b.install("f%d" % c, lhs,
                         subst(rhs.result, {"$g0": PV(0)})).ok
        c += 1
    return b


def test_discrimination_net_returns_the_same_derivation_as_the_scan():
    """The net may only remove match attempts that were bound to fail."""
    book = _big_book(40)
    for t in (P4, dos("x", "y"), S(I(7), dos("u", "v")),
              S(dos("a", "b"), V("a")), P(S(x, y), Sub(x, y))):
        d0, c0 = normalize(t, lemmas=tuple(book.lemmas), name="scan")
        d1, c1 = normalize(t, lemmas=tuple(book.lemmas), name="net",
                           use_index=True)
        assert d0.result.addr == d1.result.addr, render(t)
        assert list(d0.rule_seq()) == list(d1.rule_seq()), render(t)
        assert c0.steps == c1.steps
        assert c1.work < c0.work, (c0.work, c1.work)


def test_discrimination_net_candidates_are_a_superset_of_the_matches():
    """The planted control for the index: whatever it drops must be unmatchable.

    Checked exhaustively -- for every node of every test term, the lemmas the
    net rejects are re-matched by brute force and every one of them must fail.
    """
    from runtime.crystallize.derivation import positions_postorder, at
    book = _big_book(30)
    lemmas = tuple(book.lemmas)
    idx = LemmaIndex(lemmas)
    checked = 0
    for t in (P4, dos("x", "y"), S(dos("a", "b"), V("a"))):
        for p in positions_postorder(t):
            node = at(t, p)
            cands = set(id(l) for l in idx.candidates(node))
            for lem in lemmas:
                if id(lem) in cands:
                    continue
                checked += 1
                assert match(lem.lhs, node) is None, \
                    "the net dropped a lemma that matches: %s" % lem.lid
    assert checked > 0, "the control tested nothing"


def test_discrimination_net_index_can_be_built_once_and_reused():
    book = _big_book(20)
    idx = LemmaIndex(tuple(book.lemmas))
    d0, c0 = normalize(P4, lemmas=tuple(book.lemmas), name="scan")
    d1, c1 = normalize(P4, lemmas=tuple(book.lemmas), name="amortised",
                       index=idx)
    assert d0.result.addr == d1.result.addr
    assert c0.steps == c1.steps
    # a reused index charges the query nothing for construction
    _, c2 = normalize(P4, lemmas=tuple(book.lemmas), name="built-in",
                      use_index=True)
    assert c1.work < c2.work < c0.work, (c0.work, c1.work, c2.work)


def test_substitution_respects_repeated_variables():
    pat = P(PV(0), PV(0))
    assert match(pat, P(x, x)) is not None
    assert match(pat, P(x, y)) is None
    sigma = match(pat, P(P(x, y), P(x, y)))
    assert sigma is not None and subst(pat, sigma).addr == P(P(x, y), P(x, y)).addr


TESTS = [(n, f) for n, f in sorted(globals().items())
         if n.startswith("test_") and callable(f)]


def main() -> int:
    bad = 0
    for name, fn in TESTS:
        try:
            fn()
            print("  ok    %s" % name)
        except Exception as exc:  # noqa: BLE001 - a test runner reports all
            bad += 1
            print("  FAIL  %s\n          %s: %s"
                  % (name, type(exc).__name__, exc))
    print("\n%d/%d passed" % (len(TESTS) - bad, len(TESTS)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

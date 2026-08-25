#!/usr/bin/env python3
"""Tests for ``runtime/execute/acmatch.py`` -- AC matching.

    python3 runtime/tests/test_acmatch.py

Adversarial, in this repo's sense: every capability test is paired with a
**planted-false control** that names the wrong answer explicitly and asserts the
machinery refuses it.  Controls are prefixed ``x_`` and every one of them is
invoked.  The four the brief named are all here:

    x_bogus_ac_match_is_refused_by_the_kernel
    x_binding_inconsistent_across_a_repeated_variable
    x_budget_exhaustion_reported_as_a_fixpoint
    x_residue_dropped_during_reassembly

Pure stdlib, exact integers, no float, no randomness, no network.
"""

from __future__ import annotations

import os
import subprocess
import sys
from typing import List, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (Counter, I, Lemma,                 # noqa: E402
                                            LemmaIndex, P, PV, S, Sub, Term,
                                            V, check_derivation, CheckFailure,
                                            match, normalize, poly_equal,
                                            render, subst)
from runtime.execute import acmatch as AC                                      # noqa: E402

PASS: List[str] = []
FAIL: List[Tuple[str, str]] = []


def check(name: str, cond: bool, detail: str = "") -> None:
    if cond:
        PASS.append(name)
    else:
        FAIL.append((name, detail))


X, Y, Z, W = V("x"), V("y"), V("z"), V("w")
XX = P(X, X)
X4 = P(XX, XX)
B3 = P(S(XX, P(I(2), Y)), Sub(XX, P(I(2), Y)), S(X4, P(I(4), Y, Y)))
DSQ = Lemma("dsq", P(S(PV(0), PV(1)), S(PV(0), P(I(-1), PV(1)))),
            S(P(PV(0), PV(0)), P(I(-1), PV(1), PV(1))))


# ==========================================================================
# capabilities
# ==========================================================================

def t_sub_multiset_match() -> None:
    """The brief's own example: `mul ?a ?a` inside `mul x y x z`."""
    res = AC.ac_match(P(PV(0), PV(0)), P(X, Y, X, Z))
    ms = res.matches
    check("sub-multiset match finds exactly one solution", len(ms) == 1,
          repr([m.key() for m in ms]))
    m = ms[0]
    check("...binding ?a := x", dict(m.sigma)["#0"].addr == X.addr)
    check("...leaving y z as the residue, in the subject's own order",
          tuple(t.addr for t in m.residue) == (Y.addr, Z.addr),
          " ".join(render(t) for t in m.residue))
    check("...and a skeleton the positional matcher reproduces",
          match(m.skeleton, P(X, Y, X, Z)) is not None)


def t_residue_reassembled() -> None:
    """The rewritten term must contain the untouched arguments."""
    m = AC.ac_match(DSQ.lhs, B3, rhs=DSQ.rhs).matches[0]
    derived = AC.derive_ac_lemma(DSQ, m)
    out = subst(derived.rhs, m.subst_map())
    residue = m.residue[0]
    check("the reassembled term is an n-ary product",
          out.kind == "prod" and len(out.args) == 2, render(out))
    check("the reassembled term CONTAINS the untouched argument",
          any(a.addr == residue.addr for a in out.args),
          "%s not in %s" % (render(residue), render(out)))
    check("the rewrite is value-preserving (poly_equal, a complete decision)",
          poly_equal(B3, out))


def t_permutation_without_residue() -> None:
    """Commutativity alone: same arity, permuted arguments."""
    subj = P(Sub(XX, P(I(2), Y)), S(XX, P(I(2), Y)))     # the two swapped
    check("the positional matcher does NOT see the permuted redex",
          match(DSQ.lhs, subj) is None)
    res = AC.ac_match(DSQ.lhs, subj, rhs=DSQ.rhs)
    check("the AC matcher does", len(res.matches) == 1, res.render())
    m = res.matches[0]
    check("...with no residue", m.residue == ())
    d = AC.derive_ac_lemma(DSQ, m)
    check("...and the derived lemma is the permuted base lemma",
          d.lhs.addr != DSQ.lhs.addr and d.rhs.addr == DSQ.rhs.addr,
          render(d.lhs))


def t_b3_moves() -> None:
    """The headline: B3 off 80, checked, with the answer unchanged."""
    c0 = Counter()
    d0, _ = normalize(B3, lemmas=(DSQ,), ctr=c0, name="b3-positional")
    run = AC.ACRun()
    c1 = Counter()
    d1, _ = AC.ac_normalize(B3, lemmas=(DSQ,), ctr=c1, name="b3-ac", run=run)
    check("B3 does not move under the positional matcher", c0.steps == 80,
          str(c0.steps))
    check("B3 moves under AC matching", c1.steps < c0.steps,
          "%d -> %d" % (c0.steps, c1.steps))
    check("the answer is unchanged, by address",
          d1.result.addr == d0.result.addr, render(d1.result))
    check("the answer is independently verified by poly_equal",
          poly_equal(B3, d1.result))
    check("the AC run reports a fixpoint", run.complete, run.status())


def t_check_derivation_accepts() -> None:
    """The substrate's own checker validates every AC step, unmodified."""
    run = AC.ACRun()
    ctr = Counter()
    d, _ = AC.ac_normalize(B3, lemmas=(DSQ,), ctr=ctr, name="b3", run=run)
    try:
        check_derivation(d, run.table(), ctr)
        ok, why = True, ""
    except CheckFailure as exc:
        ok, why = False, str(exc)
    check("check_derivation accepts the AC derivation", ok, why)
    used = [st for st in d.steps if st.lemma_id and st.lemma_id.startswith("ac|")]
    check("the derivation really contains an AC step", bool(used),
          str([st.rule for st in d.steps[:3]]))
    for st in used:
        lem = run.lemmas[st.lemma_id]
        sig = match(lem.lhs, st.redex)
        check("the derived lemma's left side matches the recorded redex "
              "SYNTACTICALLY", sig is not None)
        check("...and instantiates to the recorded contractum",
              sig is not None
              and subst(lem.rhs, sig).addr == st.contractum.addr)


def t_kernel_accepts() -> None:
    """kernel/check.py accepts an Eq edge for every AC step."""
    run = AC.ACRun()
    d, _ = AC.ac_normalize(B3, lemmas=(DSQ,), name="b3", run=run)
    edges, refused, vault = AC.kernel_check_derivation(d, run)
    check("kernel/check.py accepts an Eq edge for every AC step",
          bool(edges) and not refused,
          "%d edge(s), refused %s" % (len(edges), refused))
    check("the vault declared exactly the axioms it checked",
          len(vault) == len(edges), "%d vs %d" % (len(vault), len(edges)))


def t_gates() -> None:
    """The five gates of derive_ac_lemma, each demonstrated."""
    m = AC.ac_match(DSQ.lhs, B3, rhs=DSQ.rhs).matches[0]
    d = AC.derive_ac_lemma(DSQ, m)
    check("G4: the derived lemma is a true identity (poly_equal)",
          poly_equal(d.lhs, d.rhs), "%s vs %s" % (render(d.lhs), render(d.rhs)))
    ext = P(*(tuple(DSQ.lhs.args) + m.residue_vars))
    check("G3: the derived left side is an AC rearrangement of the base",
          AC.ac_canonical(d.lhs).addr == AC.ac_canonical(ext).addr)
    check("G5: every residue variable survives into the right side",
          all(v.val in {u.val for u in _pv(d.rhs)} for v in m.residue_vars),
          render(d.rhs))
    again = AC.derive_ac_lemma(DSQ, m)
    check("the derived lemma is cached by shape, not rebuilt per instance",
          again is d)


def t_determinism_of_the_match_order() -> None:
    """Matches come back in a canonical order independent of the search."""
    subj = P(S(X, Y), S(X, P(I(-1), Y)), S(X, Y), W)
    r1 = AC.ac_match(DSQ.lhs, subj, rhs=DSQ.rhs)
    keys = [m.key() for m in r1.matches]
    check("matches are sorted into a canonical order",
          keys == sorted(keys), repr(keys[:2]))
    r2 = AC.ac_match(DSQ.lhs, subj, rhs=DSQ.rhs)
    check("two calls agree exactly",
          [m.key() for m in r2.matches] == keys)


def t_prefilter_is_only_a_filter() -> None:
    """The head-key prefilter never removes a match."""
    subjects = [P(S(X, Y), S(X, P(I(-1), Y))),
                P(S(X, Y), S(X, P(I(-1), Y)), Z),
                P(Z, S(X, Y), W, S(X, P(I(-1), Y))),
                P(X, Y, Z)]
    for s in subjects:
        res = AC.ac_match(DSQ.lhs, s, rhs=DSQ.rhs)
        brute = _brute_force_ac(DSQ.lhs, s)
        check("prefilter agrees with brute force on %s" % render(s)[:34],
              {m.key()[1] for m in res.matches} == brute,
              "%s vs %s" % ({m.key()[1] for m in res.matches}, brute))


def t_prefilter_bails_before_searching() -> None:
    """The prefilter is a cost claim, so it is measured, not asserted."""
    cheap = AC.ac_match(DSQ.lhs, P(X, Y, Z))
    check("a subject with no sum arguments costs exactly one work unit",
          cheap.work == 1 and cheap.top == 0 and len(cheap.matches) == 0,
          cheap.render())
    real = AC.ac_match(DSQ.lhs, B3, rhs=DSQ.rhs)
    check("...against %d for a subject that does have to be searched"
          % real.work, real.work > 10 * cheap.work, real.render())
    wide = P(*([S(X, I(k)) for k in range(2, 9)]))
    scan = AC.ac_match(DSQ.lhs, wide, rhs=DSQ.rhs)
    check("a subject whose arguments all pass the prefilter but none match "
          "costs the full search and finds nothing",
          len(scan.matches) == 0 and scan.top > 0, scan.render())


def t_ac_is_off_by_default() -> None:
    """Nothing changes unless a caller asks for AC."""
    c0 = Counter()
    normalize(B3, lemmas=(DSQ,), ctr=c0, name="a")
    c1 = Counter()
    normalize(B3, lemmas=(DSQ,), ctr=c1, name="a")
    check("derivation.normalize is untouched by importing acmatch",
          (c0.steps, c0.work) == (c1.steps, c1.work) == (80, c0.work))
    check("AC has no live run outside `ac_enabled`",
          AC.current_run() is None)
    from runtime.execute.ematch import AC_HEADS
    check("ematch's AC route is off by default", AC_HEADS == ())


def t_ac_enabled_restores() -> None:
    """The rebinding is restored, even on an exception."""
    from runtime.crystallize import derivation as D
    before = D.normalize
    try:
        with AC.ac_enabled():
            check("normalize is rebound inside the context",
                  D.normalize is not before)
            raise RuntimeError("planted")
    except RuntimeError:
        pass
    check("normalize is restored after an exception", D.normalize is before)
    check("no run is left live", AC.current_run() is None)


def t_ac_normalize_equals_normalize_without_lemmas() -> None:
    run = AC.ACRun()
    c0, c1 = Counter(), Counter()
    d0, _ = normalize(B3, ctr=c0, name="n")
    d1, _ = AC.ac_normalize(B3, ctr=c1, name="n", run=run)
    check("with an empty book, ac_normalize IS normalize, step for step",
          d0.rule_seq() == d1.rule_seq()
          and (c0.steps, c0.work) == (c1.steps, c1.work),
          "%s vs %s" % (c0.snapshot(), c1.snapshot()))


def t_kernel_term_hook() -> None:
    """The additive ematch hook finds permuted matches, and only when asked."""
    from runtime.kernel import term as T
    from runtime.kernel.egraph import EGraph
    from runtime.execute.ematch import ematch, ematch_ac
    R = T.base_sort("R")
    mul = T.Const("mul", T.arrow(R, T.arrow(R, R)))

    def M(a, b):
        return T.App(T.App(mul, a), b)
    a, b, c = (T.Const(n, R) for n in ("a", "b", "c"))
    u, v = T.Const("?u", R), T.Const("?v", R)
    g = EGraph()
    g.add(M(M(a, b), c))
    pat = M(M(v, u), a)
    plain = ematch(g, pat, {"?u", "?v"})
    check("the positional e-matcher finds nothing", len(plain.matches) == 0)
    same = ematch_ac(g, pat, {"?u", "?v"})
    check("ematch_ac with no AC heads IS ematch",
          [m.key() for m in same.matches] == [m.key() for m in plain.matches])
    acm = ematch_ac(g, pat, {"?u", "?v"}, ac_heads=("mul",))
    check("declaring mul associative-commutative finds both permutations",
          len(acm.matches) == 2, repr([m.key() for m in acm.matches]))


def t_determinism_across_hashseed() -> None:
    """Byte-identical output under varied PYTHONHASHSEED."""
    script = (
        "import sys; sys.path.insert(0, %r)\n"
        "from runtime.crystallize.derivation import *\n"
        "from runtime.execute import acmatch as AC\n"
        "X,Y=V('x'),V('y'); XX=P(X,X); X4=P(XX,XX)\n"
        "B3=P(S(XX,P(I(2),Y)), Sub(XX,P(I(2),Y)), S(X4,P(I(4),Y,Y)))\n"
        "L=Lemma('dsq', P(S(PV(0),PV(1)), S(PV(0),P(I(-1),PV(1)))),"
        " S(P(PV(0),PV(0)), P(I(-1),PV(1),PV(1))))\n"
        "run=AC.ACRun(); c=Counter()\n"
        "d,_=AC.ac_normalize(B3, lemmas=(L,), ctr=c, name='b', run=run)\n"
        "print(c.snapshot(), d.result.addr, sorted(run.lemmas),"
        " run.stats.render(), run.status())\n"
        % os.path.dirname(os.path.dirname(os.path.dirname(
            os.path.abspath(__file__)))))
    outs = []
    for seed in ("0", "12345", "999"):
        env = dict(os.environ, PYTHONHASHSEED=seed)
        outs.append(subprocess.run([sys.executable, "-c", script], env=env,
                                   capture_output=True, text=True).stdout)
    check("output is byte-identical across PYTHONHASHSEED 0/12345/999",
          len(set(outs)) == 1, repr(outs))


def t_no_floats() -> None:
    here = os.path.dirname(os.path.abspath(__file__))
    src = open(os.path.join(os.path.dirname(here), "execute", "acmatch.py")).read()
    banned = [w for w in ("random.", "time.time", "float(", "1.0", "0.5")
              if w in src]
    check("acmatch.py constructs no float and consults no clock or RNG",
          not banned, repr(banned))


# ==========================================================================
# planted-false controls
# ==========================================================================

def x_bogus_ac_match_is_refused_by_the_kernel() -> None:
    """A claimed AC rewrite that is not one must not get an Eq edge."""
    run = AC.ACRun()
    d, _ = AC.ac_normalize(B3, lemmas=(DSQ,), name="b3", run=run)
    st = next(s for s in d.steps if s.lemma_id
              and s.lemma_id.startswith("ac|"))
    lem = run.lemmas[st.lemma_id]
    # the real contractum with the residue silently deleted
    bogus = S(P(XX, XX), P(I(-1), P(I(2), Y), P(I(2), Y)))
    edge, vault = AC.kernel_edge_for(st.redex, bogus, lem)
    check("x_ control: a bogus AC contractum gets NO kernel edge",
          edge is None, "edge built for %s" % render(bogus))
    check("x_ control: ...and the vault recorded a refusal, not a declaration",
          len(vault) == 0 and bool(vault.refusals),
          "%d axioms, %d refusals" % (len(vault), len(vault.refusals)))
    good, _ = AC.kernel_edge_for(st.redex, st.contractum, lem, vault)
    check("x_ control: the SAME route accepts the real step, so the refusal "
          "is not the route failing", good is not None)


def x_binding_inconsistent_across_a_repeated_variable() -> None:
    """A repeated pattern variable must bind to one address everywhere."""
    # `#0 * #0` against `x * y`: no consistent binding exists.
    res = AC.ac_match(P(PV(0), PV(0)), P(X, Y))
    check("x_ control: `?a * ?a` does not match `x * y`",
          len(res.matches) == 0, repr([m.key() for m in res.matches]))
    # ...and it does match `x * y * x`, with y as the residue.
    res2 = AC.ac_match(P(PV(0), PV(0)), P(X, Y, X))
    check("x_ control: ...but DOES match `x * y * x`, so the refusal above is "
          "the consistency check and not a dead matcher",
          len(res2.matches) == 1 and res2.matches[0].residue[0].addr == Y.addr)
    # A hand-built match claiming an inconsistent binding must fail its gates.
    fake = AC.ACMatch(sigma=(("#0", X),), skeleton=P(PV(0), PV(0), PV(1)),
                      residue=(Y,), residue_vars=(PV(1),))
    base = Lemma("sq", P(PV(0), PV(0)), P(I(1), PV(0), PV(0)))
    d = AC.derive_ac_lemma(base, fake)
    sig = match(d.lhs, P(X, Y))
    check("x_ control: the derived lemma's own left side refuses the "
          "inconsistent subject", sig is None,
          "matched with %s" % (sig,))


def x_budget_exhaustion_reported_as_a_fixpoint() -> None:
    """A search that gave up must not be reported as total."""
    wide = P(*([S(XX, P(I(2), Y)), Sub(XX, P(I(2), Y))]
               + [S(X, I(k)) for k in range(3, 10)]))
    tight = AC.ACBudget(max_assignments=3)
    res = AC.ac_match(DSQ.lhs, wide, tight, rhs=DSQ.rhs)
    check("x_ control: an exhausted search reports exhausted", res.exhausted,
          res.reason)
    raised = False
    try:
        _ = res.matches
    except AC.ACIncomplete:
        raised = True
    check("x_ control: reading `.matches` of an incomplete enumeration RAISES",
          raised, "returned %d matches as if total" % len(res.partial()))
    raised_len = False
    try:
        len(res)
    except AC.ACIncomplete:
        raised_len = True
    check("x_ control: so does len()", raised_len)
    check("x_ control: `.partial()` is the written-down way in",
          isinstance(res.partial(), tuple))

    run = AC.ACRun(tight)
    AC.ac_normalize(wide, lemmas=(DSQ,), name="starved", run=run)
    check("x_ control: a run whose search gave up is NOT a fixpoint",
          not run.complete and run.status() != "fixpoint", run.status())
    check("x_ control: ...and it records which bound bound",
          any("max_assignments" in e for e in run.exhaustions),
          repr(run.exhaustions[:1]))
    # A budget tight enough to cut the search but loose enough to have found
    # something: the partial set is NON-EMPTY, so "refuse to rewrite from a
    # subset" is actually exercised rather than trivially satisfied.
    subj = P(S(X, Y), S(X, P(I(-1), Y)), S(X, Y), W)
    partial = AC.ac_match(DSQ.lhs, subj, AC.ACBudget(max_assignments=20),
                          rhs=DSQ.rhs)
    check("x_ control: the tight search found SOME matches, so the next check "
          "is not vacuous",
          partial.exhausted and len(partial.partial()) > 0,
          "%d found" % len(partial.partial()))
    full = AC.ac_match(DSQ.lhs, subj, rhs=DSQ.rhs)
    check("x_ control: ...and fewer than the complete search finds",
          len(partial.partial()) < len(full.matches),
          "%d vs %d" % (len(partial.partial()), len(full.matches)))
    starved2 = AC.ACRun(AC.ACBudget(max_assignments=20))
    d2, _ = AC.ac_normalize(subj, lemmas=(DSQ,), name="partial", run=starved2)
    check("x_ control: ac_normalize takes NO AC step from a partial match set",
          not any(st.lemma_id and st.lemma_id.startswith("ac|")
                  for st in d2.steps),
          repr([st.rule for st in d2.steps[:3]]))
    check("x_ control: ...and says so in its status", not starved2.complete,
          starved2.status())
    ok = AC.ACRun()
    d3, _ = AC.ac_normalize(subj, lemmas=(DSQ,), name="full", run=ok)
    check("x_ control: the SAME term with a real budget DOES take the AC step",
          any(st.lemma_id and st.lemma_id.startswith("ac|") for st in d3.steps)
          and ok.complete, ok.status())

    generous = AC.ACRun()
    AC.ac_normalize(wide, lemmas=(DSQ,), name="ok", run=generous)
    check("x_ control: the SAME task with a real budget IS a fixpoint, so the "
          "verdict tracks the budget and not the task", generous.complete,
          generous.status())


def x_residue_dropped_during_reassembly() -> None:
    """The classic AC rewriting bug, planted three ways."""
    m = AC.ac_match(DSQ.lhs, B3, rhs=DSQ.rhs).matches[0]
    # (1) a right side that forgets the residue variable
    dropper = Lemma("dropper", DSQ.lhs, S(P(PV(0), PV(0)), I(0)))
    m2 = AC.ac_match(dropper.lhs, B3, rhs=dropper.rhs).matches[0]
    try:
        AC.derive_ac_lemma(dropper, m2)
        caught = ""
    except AC.ACError as exc:
        caught = str(exc)
    check("x_ control: a derived lemma whose right side is not the base's "
          "value is refused (G4)", caught.startswith("G4"), caught[:70])
    # (2) a skeleton that is not an AC rearrangement (a residue slot reused)
    fake = AC.ACMatch(sigma=m.sigma,
                      skeleton=P(S(PV(0), PV(1)), S(PV(0), PV(1)), PV(2)),
                      residue=m.residue, residue_vars=(PV(2),))
    try:
        AC.derive_ac_lemma(DSQ, fake)
        caught2 = ""
    except AC.ACError as exc:
        caught2 = str(exc)
    check("x_ control: a skeleton that is not an AC rearrangement is "
          "refused (G3)", caught2.startswith("G3"), caught2[:70])
    # (3) the real rewrite, asserted to keep the residue
    derived = AC.derive_ac_lemma(DSQ, m)
    out = subst(derived.rhs, m.subst_map())
    check("x_ control: the accepted rewrite DOES contain the untouched "
          "argument, so (1) and (2) are not a matcher that never works",
          any(a.addr == m.residue[0].addr for a in out.args), render(out))


def x_a_positional_index_would_be_unsound_under_ac() -> None:
    """LemmaIndex drops a lemma whose AC redex is at a permuted position."""
    subj = P(Sub(XX, P(I(2), Y)), S(XX, P(I(2), Y)))
    idx = LemmaIndex((DSQ,))
    cands = idx.candidates(subj)
    check("x_ control: the discrimination net keeps this one anyway",
          len(cands) == 1, repr(cands))
    # the net is keyed on positions, so a *different* permuted lemma is dropped
    other = Lemma("k", P(S(PV(0), PV(1)), I(7)), P(I(7), PV(0)))
    idx2 = LemmaIndex((other,))
    check("x_ control: ...but drops one whose constant sits at the other "
          "position, which AC matching would still fire",
          idx2.candidates(P(I(7), S(X, Y))) == [],
          repr(idx2.candidates(P(I(7), S(X, Y)))))
    res = AC.ac_match(other.lhs, P(I(7), S(X, Y)), rhs=other.rhs)
    check("x_ control: the AC matcher fires there, which is why "
          "ac_normalize refuses to use the net", len(res.matches) == 2,
          res.render())


def x_ac_does_not_change_an_answer() -> None:
    """AC may shorten a route; it may never change what the route reaches."""
    tasks = [B3, P(S(X, Y), Sub(X, Y)), S(P(S(XX, P(I(3), Y)),
                                           Sub(XX, P(I(3), Y))),
                                         P(I(9), Y, Y))]
    for t in tasks:
        d0, c0 = normalize(t, lemmas=(DSQ,), name="p")
        run = AC.ACRun()
        d1, c1 = AC.ac_normalize(t, lemmas=(DSQ,), name="a", run=run)
        check("x_ control: AC preserves the answer of %s" % render(t)[:28],
              d0.result.addr == d1.result.addr,
              "%s vs %s" % (render(d0.result), render(d1.result)))
        check("x_ control: ...and never lengthens the derivation",
              c1.steps <= c0.steps, "%d vs %d" % (c1.steps, c0.steps))


def x_derived_lemma_is_not_accepted_without_the_registry() -> None:
    """An AC step is not checkable against the base book alone."""
    run = AC.ACRun()
    ctr = Counter()
    d, _ = AC.ac_normalize(B3, lemmas=(DSQ,), ctr=ctr, name="b3", run=run)
    try:
        check_derivation(d, {"dsq": DSQ}, ctr)
        refused = False
        why = ""
    except CheckFailure as exc:
        refused = True
        why = str(exc)
    check("x_ control: the checker REFUSES an AC step whose derived lemma it "
          "was not given -- the registry is not a rubber stamp", refused,
          why[:70])


# ==========================================================================

def _pv(t: Term):
    from runtime.crystallize.derivation import pvars_of
    return pvars_of(t)


def _brute_force_ac(pattern: Term, subject: Term):
    """Every AC match, by unoptimised enumeration.  The reference."""
    from itertools import permutations
    if pattern.kind not in AC.AC_KINDS or subject.kind != pattern.kind:
        return set()
    p, n = len(pattern.args), len(subject.args)
    if p > n:
        return set()
    out = set()
    for pick in permutations(range(n), p):
        sigma = {}
        ok = True
        for i, j in enumerate(pick):
            got = _ac_bijective(pattern.args[i], subject.args[j], sigma)
            if got is None:
                ok = False
                break
            sigma = got
        if ok:
            out.add(tuple((k, v.ckey) for k, v in sorted(sigma.items())))
    return out


def _ac_bijective(p: Term, t: Term, sigma):
    """Reference sub-match: bijective at inner AC nodes, no residue."""
    from itertools import permutations
    from runtime.crystallize.derivation import is_pvar
    if is_pvar(p):
        got = sigma.get(p.val)
        if got is None:
            out = dict(sigma)
            out[p.val] = t
            return out
        return sigma if got.addr == t.addr else None
    if p.kind != t.kind or p.val != t.val or len(p.args) != len(t.args):
        return None
    if p.kind in AC.AC_KINDS:
        for perm in permutations(range(len(t.args))):
            cur = sigma
            ok = True
            for i, j in enumerate(perm):
                cur = _ac_bijective(p.args[i], t.args[j], cur)
                if cur is None:
                    ok = False
                    break
            if ok:
                return cur
        return None
    cur = sigma
    for a, b in zip(p.args, t.args):
        cur = _ac_bijective(a, b, cur)
        if cur is None:
            return None
    return cur


TESTS = [
    t_sub_multiset_match,
    t_residue_reassembled,
    t_permutation_without_residue,
    t_b3_moves,
    t_check_derivation_accepts,
    t_kernel_accepts,
    t_gates,
    t_determinism_of_the_match_order,
    t_prefilter_is_only_a_filter,
    t_prefilter_bails_before_searching,
    t_ac_is_off_by_default,
    t_ac_enabled_restores,
    t_ac_normalize_equals_normalize_without_lemmas,
    t_kernel_term_hook,
    t_determinism_across_hashseed,
    t_no_floats,
    x_bogus_ac_match_is_refused_by_the_kernel,
    x_binding_inconsistent_across_a_repeated_variable,
    x_budget_exhaustion_reported_as_a_fixpoint,
    x_residue_dropped_during_reassembly,
    x_a_positional_index_would_be_unsound_under_ac,
    x_ac_does_not_change_an_answer,
    x_derived_lemma_is_not_accepted_without_the_registry,
]


def main() -> int:
    controls = 0
    for fn in TESTS:
        if fn.__name__.startswith("x_"):
            controls += 1
        try:
            fn()
        except Exception as exc:                    # a raising test is a fail
            FAIL.append((fn.__name__, "raised %s: %s" % (type(exc).__name__, exc)))
    for name, detail in FAIL:
        print("FAIL  %s%s" % (name, ("  -- " + detail) if detail else ""))
    total = len(PASS) + len(FAIL)
    print("%d/%d passed  (%d planted controls, every one invoked)"
          % (len(PASS), total, controls))
    return 1 if FAIL else 0


if __name__ == "__main__":
    sys.exit(main())

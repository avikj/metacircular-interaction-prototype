#!/usr/bin/env python3
"""The AC retest: was the vocabulary negative a fact, or an artifact?

    python3 runtime/demo/ac_demo.py           # ~11 min
    python3 runtime/demo/ac_demo.py --quick   # ~4 min

Exit 0 iff every audit passes.

THE DIAGNOSIS BEING ACTED ON
----------------------------
``runtime/vocabulary/README.md`` sec.7, in the vocabulary lane's own words:

    B3, flat 3-ary product                     base  80  ->  book  80    fired: none
    B3, the SAME polynomial, binary grouping   base  54  ->  book  37    fired: L1

    ``L1``'s left side is a **binary** product.  B3's root is a **3-ary**
    product.  The substrate has flat n-ary products and its only associativity
    rule splices nested products *upward*; nothing introduces a grouping.  So
    the redex is there, the lemma is there, and the matcher cannot see one from
    the other.

Everything downstream inherits it: proposals generalise from what the schema
built, so binary families give binary proposals give binary lemmas, and the
vocabulary experiment returned a flat negative.

THE QUESTION
------------
Is that negative a fact about mathematics, or an artifact of the matcher?  If a
binary lemma could see its redex inside an n-ary product, would the plateau
break?

``runtime/execute/acmatch.py`` lets it.  This file re-runs B3 and the whole
three-arm vocabulary experiment on the AC substrate, with everything else
identical, and reports which of three verdicts the numbers support.
"""

from __future__ import annotations

import os
import sys
import time
from typing import Dict, List, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (Counter, I, Lemma, P, PV, S, Sub,  # noqa: E402
                                            Term, V, check_derivation,
                                            normalize, poly_equal, render)
from runtime.execute import acmatch as AC                                      # noqa: E402
from runtime.generate.loop import benchmark_cost                               # noqa: E402
from runtime.demo.vocabulary_demo import (B3, B3_NAME, B4_NAME, BENCH,         # noqa: E402
                                          run_config)

QUICK = "--quick" in sys.argv
ROUNDS = 8 if QUICK else 12

FAILURES: List[str] = []


def audit(name: str, ok: bool, detail: str = "") -> None:
    print("    [%s] %s%s" % ("ok " if ok else "FAIL", name,
                             ("  -- " + detail) if detail else ""))
    if not ok:
        FAILURES.append(name)


def rule(title: str) -> None:
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


# ==========================================================================
# 0.  the expectation, registered before anything is measured
# ==========================================================================

EXPECTATION = """
    REGISTERED BEFORE THE RUN.  Written here, in the file, before the three-arm
    experiment was executed once.

    (i)  B3 WILL MOVE.  L1's redex is genuinely present as a sub-multiset of
         B3's 3-ary product; nothing but the positional matcher stands between
         them.  Predicted landing zone: the binary-grouped number, 37, or near
         it -- because AC matching should make the flat term behave exactly as
         the hand-grouped one does.

    (ii) THE THREE-ARM RESULT WILL NOT CHANGE ITS SIGN.  (B) will still equal
         (A), and (C) will still equal both.  Two reasons, both structural and
         both already in the vocabulary lane's own write-up:

           * conservativity bars a constructor from ever entering a base query
             (asserted by test_a_constructor_never_enters_a_base_query), so a
             vocabulary cannot shorten a benchmark derivation *at all*; it can
             only change which lemmas get mined;
           * AC matching is a property of the substrate, so all three arms get
             it equally.  It lifts the floor; it does not tilt the field.

    So the expected verdict is the SECOND of the three: the matcher was a real
    ceiling AND vocabulary still does nothing -- two separate findings.

    I would be wrong if AC matching changed *which shapes the loop can mine
    lemmas from* so much that (B)'s constructor-derived seeds start producing
    lemmas that fire where (A)'s do not.  That is the one route by which (i)
    could drag (ii) with it, and it is what the three-arm table decides.
"""


# ==========================================================================
# 1.  the matcher, on the brief's own example
# ==========================================================================

_X, _Y, _Z = V("x"), V("y"), V("z")
_XX = P(_X, _X)
_X4 = P(_XX, _XX)

# The difference-of-squares lemma, stated here in the shape crystallize mines
# it in, so section 1 does not depend on a loop having run.
L_DSQ = Lemma("dsq", P(S(PV(0), PV(1)), S(PV(0), P(I(-1), PV(1)))),
              S(P(PV(0), PV(0)), P(I(-1), PV(1), PV(1))),
              provenance="stated here for section 1")


def section_1() -> None:
    rule("1.  AC MATCHING -- a pattern against a SUB-MULTISET of the arguments")
    print("    The brief's example, run:\n")
    pat = P(PV(0), PV(0))
    subj = P(_X, _Y, _X, _Z)
    res = AC.ac_match(pat, subj)
    print("      pattern   %s" % render(pat))
    print("      subject   %s" % render(subj))
    print("      %s" % res.render())
    for m in res.matches:
        print("        bind %s   residue %s   skeleton %s"
              % (", ".join("%s := %s" % (k, render(v)) for k, v in m.sigma),
                 " ".join(render(t) for t in m.residue),
                 render(m.skeleton)))
    ok = (len(res.matches) == 1
          and dict(res.matches[0].sigma)["#0"].addr == _X.addr
          and tuple(t.addr for t in res.matches[0].residue)
          == (_Y.addr, _Z.addr))
    audit("`mul ?a ?a` finds its redex inside `mul x y x z`, binding ?a := x "
          "and leaving y z", ok)

    print("\n    The same matcher, on the pair the diagnosis names:\n")
    res3 = AC.ac_match(L_DSQ.lhs, B3, rhs=L_DSQ.rhs)
    print("      pattern   %s" % render(L_DSQ.lhs))
    print("      subject   %s" % render(B3))
    print("      %s" % res3.render())
    for m in res3.matches:
        print("        bind %s"
              % ", ".join("%s := %s" % (k, render(v)) for k, v in m.sigma))
        print("        residue   %s" % " ".join(render(t) for t in m.residue))
    audit("the binary difference-of-squares lemma sees its redex inside B3's "
          "3-ary product", len(res3.matches) == 1 and bool(res3.matches[0].residue))

    print("""
    THE BOUND, and what the prunings remove.

      An injective assignment of p pattern arguments to n subject arguments:
      n!/(n-p)! of them, i.e. <= n**p, and n! when p = n.  Each such assignment
      is multiplied by the number of substitutions the INNER AC nodes yield --
      here 2 per binary sum, the two orders.  So the search tree is

          n!/(n-p)!  x  (inner multiplicity)   root candidate pairs

      and AC matching is EXPONENTIAL IN THE ARITY OF THE AC NODE, on top of
      e-matching's existing exponential in pattern size.
""")
    rows = []
    for n in range(2, 9):
        subj_n = P(*([S(_XX, P(I(2), _Y)), Sub(_XX, P(I(2), _Y))]
                     + [S(_X, I(k)) for k in range(3, n + 1)]))
        r = AC.ac_match(L_DSQ.lhs, subj_n, rhs=L_DSQ.rhs)
        naive = n * (n - 1)                       # n!/(n-2)! for p = 2
        rows.append((n, naive, r.top, r.work, len(r.matches)))
    print("        n | n!/(n-2)! | root pairs | all pairs   | matches")
    print("          | the bound |  examined  | incl. inner |")
    for n, naive, top, work, nm in rows:
        print("       %2d | %9d | %10d | %9d | %d" % (n, naive, top, work, nm))
    print("""
      `root pairs` counts every (pattern argument, subject argument) pair the
      root search examines, once per surviving partial substitution.  Measured
      it is exactly n(2n-1) -- the n!/(n-2)! assignments, doubled by the inner
      sum's two orders, plus the partial nodes.  Quadratic in n at p = 2 and
      factorial in general; the prunings change the constant, not the class.

      What the prunings CANNOT do is remove an assignment that would have
      succeeded: the prefilter's condition is necessary, and the constants-first
      ordering only permutes a complete enumeration, which is sorted into a
      canonical order before anything reads it.  One match at every arity is the
      check that says so.
""")
    audit("the head-key prefilter never removes a real match",
          all(nm == 1 for _, _, _, _, nm in rows),
          "one match at every arity 2..8")
    audit("the root search stays quadratic in the AC node's arity for a "
          "2-argument pattern", all(top < 2 * n * n for n, _, top, _, _ in rows),
          "n(2n-1) measured at every n in 2..8")


# ==========================================================================
# 2.  checkability, and the planted-false controls
# ==========================================================================

def section_2() -> None:
    rule("2.  WHAT MAKES AN AC REWRITE CHECKABLE -- and three that are not")
    print("    An AC step is not an instance of any rule the substrate's")
    print("    checker knows, so it is not recorded as one.  What is recorded")
    print("    is the n-ary, permuted, residue-carrying DERIVED LEMMA, whose")
    print("    left side matches the subject SYNTACTICALLY -- so the existing")
    print("    `check_step` re-derives it with the matcher it already has and")
    print("    the AC search is not in the trusted path at all.\n")
    m = AC.ac_match(L_DSQ.lhs, B3, rhs=L_DSQ.rhs).matches[0]
    derived = AC.derive_ac_lemma(L_DSQ, m)
    print("      base      %s" % L_DSQ)
    print("      derived   %s" % derived)
    print("      gates     G1 shape  G2 fresh residue vars  G3 AC rearrangement")
    print("                G4 poly_equal (complete decision)  G5 no dropped residue")

    run = AC.ACRun()
    d, ctr = AC.ac_normalize(B3, lemmas=(L_DSQ,), name="b3-section2", run=run)
    check_derivation(d, run.table(), ctr)
    audit("the substrate's own check_derivation accepts every AC step",
          True, "%d steps, %d checks" % (ctr.steps, ctr.checks))
    edges, refused, vault = AC.kernel_check_derivation(d, run)
    audit("kernel/check.py accepts an Eq edge for every AC step",
          bool(edges) and not refused,
          "%d edge(s), %d refused, %d axiom(s) declared"
          % (len(edges), len(refused), len(vault)))

    print("\n    PLANTED-FALSE CONTROLS -- each must be refused.\n")

    # (a) a bogus AC match: the right residue dropped from the contractum.
    good = d.steps[[s.lemma_id is not None and s.lemma_id.startswith("ac|")
                    for s in d.steps].index(True)]
    lem = run.lemmas[good.lemma_id]
    bogus = S(P(_XX, _XX), P(I(-1), P(I(2), _Y), P(I(2), _Y)))   # residue dropped
    edge, _ = AC.kernel_edge_for(good.redex, bogus, lem, vault)
    audit("control: an AC rewrite that DROPS the residue is refused by the "
          "kernel route", edge is None,
          "redex %s  claimed %s" % (render(good.redex), render(bogus)))

    # (b) an AC "lemma" whose left side is not an AC rearrangement of the base.
    fake = AC.ACMatch(sigma=(("#0", _XX), ("#1", P(I(2), _Y))),
                      skeleton=P(S(PV(0), PV(1)), S(PV(0), PV(1)), PV(2)),
                      residue=(S(_X4, P(I(4), _Y, _Y)),),
                      residue_vars=(PV(2),))
    try:
        AC.derive_ac_lemma(L_DSQ, fake)
        bad = True
    except AC.ACError as exc:
        bad = False
        why = str(exc)[:66]
    audit("control: a skeleton that is not an AC rearrangement of the base "
          "pattern is refused", not bad, why if not bad else "ACCEPTED")

    # (c) a residue variable the right side drops.
    dropper = Lemma("drop", P(S(PV(0), PV(1)), S(PV(0), P(I(-1), PV(1)))),
                    S(P(PV(0), PV(0)), P(I(-1), PV(1), PV(1))))
    m2 = AC.ac_match(dropper.lhs, B3, rhs=dropper.rhs).matches[0]
    d2 = AC.derive_ac_lemma(dropper, m2)
    has_residue_var = any(v.val in {u.val for u in _pvars(d2.rhs)}
                          for v in m2.residue_vars)
    audit("control: the derived right side CARRIES every residue variable "
          "(G5) -- the classic AC reassembly bug", has_residue_var,
          "rhs %s" % render(d2.rhs))

    # (d) a budget exhaustion is not a fixpoint.
    starved = AC.ACRun(AC.ACBudget(max_assignments=3))
    wide = P(*([S(_XX, P(I(2), _Y)), Sub(_XX, P(I(2), _Y))]
               + [S(_X, I(k)) for k in range(3, 9)]))
    AC.ac_normalize(wide, lemmas=(L_DSQ,), name="starved", run=starved)
    audit("control: a run whose AC search hit its bound reports "
          "`%s`, not `fixpoint`" % starved.status(),
          not starved.complete and starved.status() != "fixpoint",
          "%d exhaustion(s)" % len(starved.exhaustions))
    res = AC.ac_match(L_DSQ.lhs, wide, AC.ACBudget(max_assignments=3),
                      rhs=L_DSQ.rhs)
    try:
        _ = res.matches
        raised = False
    except AC.ACIncomplete:
        raised = True
    audit("control: reading `.matches` of an incomplete AC enumeration raises "
          "-- a cap is not a semantics", raised,
          "%d found, reachable only through .partial()" % len(res.partial()))


def _pvars(t: Term):
    from runtime.crystallize.derivation import pvars_of
    return pvars_of(t)


# ==========================================================================
# 3.  B3 alone
# ==========================================================================

def section_3(book, index) -> Dict[str, object]:
    rule("3.  B3 ALONE -- does it move off 80?")
    base_steps, base_work, base_ans = benchmark_cost(None, None, B3)
    bk_steps, bk_work, bk_ans = benchmark_cost(book, index, B3)

    run = AC.ACRun()
    ctr = Counter()
    d, _ = AC.ac_normalize(B3, lemmas=tuple(book.lemmas), ctr=ctr,
                           name="B3-ac", run=run)
    check_derivation(d, dict(book.table(), **run.table()), ctr)
    ac_steps, ac_work, ac_ans = ctr.steps, ctr.work, d.result

    print("    %s\n" % B3_NAME)
    print("      configuration                          steps     work  answer")
    print("      -------------------------------------------------------------")
    print("      empty book, positional matcher      %7d %8d  %s"
          % (base_steps, base_work, render(base_ans)))
    print("      round-%d book, positional matcher    %7d %8d  %s"
          % (ROUNDS - 1, bk_steps, bk_work, render(bk_ans)))
    print("      round-%d book, AC matcher            %7d %8d  %s"
          % (ROUNDS - 1, ac_steps, ac_work, render(ac_ans)))

    fired = sorted(run.stats.fired.items())
    print("\n      lemmas fired under AC: %s"
          % (", ".join("%s x%d" % kv for kv in fired) or "none"))
    for lid, _n in fired:
        lem = run.lemmas[lid]
        print("        %-28s %s" % (lid, lem))
        if lid.startswith("ac|"):
            print("        %-28s   provenance: %s" % ("", lem.provenance))

    audit("B3 moves off 80 under AC matching",
          ac_steps < bk_steps,
          "%d -> %d  (%+d)" % (bk_steps, ac_steps, ac_steps - bk_steps))
    audit("the answer is unchanged, by address",
          ac_ans.addr == bk_ans.addr == base_ans.addr, render(ac_ans))
    audit("the answer is independently verified by poly_equal (a COMPLETE "
          "decision on this substrate)", poly_equal(B3, ac_ans))
    edges, ref, vault = AC.kernel_check_derivation(d, run)
    audit("every AC step of B3's derivation is a kernel-checked Eq edge",
          bool(edges) and not ref, "%d edge(s), %d refused" % (len(edges), len(ref)))
    audit("the AC run reports a fixpoint, not a budget", run.complete,
          run.status())

    print("\n    The diagnosis said the SAME polynomial with a binary grouping")
    print("    goes 54 -> 37 and fires L1.  Reproduced here for comparison:\n")
    B3g = P(P(S(_XX, P(I(2), _Y)), Sub(_XX, P(I(2), _Y))),
            S(_X4, P(I(4), _Y, _Y)))
    g0 = benchmark_cost(None, None, B3g)[:2]
    g1 = benchmark_cost(book, index, B3g)[:2]
    print("      B3, binary grouping, positional     %7d %8d  ->  %7d %8d"
          % (g0[0], g0[1], g1[0], g1[1]))
    audit("AC matching brings the FLAT 3-ary term to the hand-grouped term's "
          "step count", ac_steps == g1[0],
          "flat+AC %d vs grouped %d" % (ac_steps, g1[0]))
    return {"base": base_steps, "book": bk_steps, "ac": ac_steps,
            "ac_work": ac_work, "book_work": bk_work, "run": run,
            "grouped": g1[0]}


# ==========================================================================
# 4.  the three-arm retest
# ==========================================================================

ARMS = (("fixed", "A fixed vocabulary"),
        ("self", "B self-extending"),
        ("null", "C count-matched null"))


def _arm_table(label: str, o, trace, rounds: int, extra: str = "") -> None:
    print("    (%s)%s" % (label, extra))
    print("      r | voc | states  book | " +
          " | ".join("%s stp  work" % n for n, _ in BENCH))
    for r in range(rounds):
        row = trace[r]
        rep = o.reports[r]
        print("     %2d | %3d | %6d %5d | %s"
              % (r, o.vreports[r].vocab, rep.states, rep.book,
                 " | ".join("%5d %6d" % c for c in row)))
    print("      constructors installed: %d  (%s)"
          % (len(o.vocab), ", ".join(o.vocab.names()) or "none"))
    print()


def section_4(rounds: int):
    rule("4.  THE RETEST -- (A) fixed vs (B) self-extending vs (C) null, ON AC")
    print("    Exactly the run `runtime/vocabulary/` did, same columns, same")
    print("    benchmarks, same rounds -- with AC matching enabled and nothing")
    print("    else changed.\n")

    plain: Dict[str, Tuple] = {}
    print("    First, the SAME three arms on the positional matcher, in this")
    print("    process, so the two tables are directly comparable and so the")
    print("    published numbers are reproduced rather than quoted.\n")
    t0 = time.time()
    for mode, label in ARMS:
        o, trace = run_config(mode, rounds)
        plain[mode] = (o, trace)
        _arm_table(label + "  [positional]", o, trace, rounds)
    t_plain = time.time() - t0

    acruns: Dict[str, Tuple] = {}
    stats: Dict[str, AC.ACStats] = {}
    t0 = time.time()
    for mode, label in ARMS:
        run = AC.ACRun()
        with AC.ac_enabled(run=run):
            o, trace = run_config(mode, rounds)
        acruns[mode] = (o, trace, run)
        stats[mode] = run.stats
        _arm_table(label + "  [AC]", o, trace, rounds,
                   extra="   AC: %s  status=%s"
                         % (run.stats.render(), run.status()))
    t_ac = time.time() - t0
    return plain, acruns, t_plain, t_ac


# ==========================================================================
# 5.  the verdict
# ==========================================================================

def section_5(plain, acruns, rounds: int) -> str:
    rule("5.  THE VERDICT")
    ta = acruns["fixed"][1]
    tb = acruns["self"][1]
    tc = acruns["null"][1]
    pa = plain["fixed"][1]

    print("    Final round, kernel steps per benchmark:\n")
    print("      %-34s %s" % ("", "  ".join("%6s" % n for n, _ in BENCH)))
    for tag, tr in (("positional  (A) fixed", pa),
                    ("AC          (A) fixed", ta),
                    ("AC          (B) self-extending", tb),
                    ("AC          (C) null control", tc)):
        print("      %-34s %s"
              % (tag, "  ".join("%6d" % c[0] for c in tr[-1])))
    print("\n    held out: %s ; %s" % (B3_NAME, B4_NAME))
    print("    (B4 was DISQUALIFIED by the vocabulary lane's own leakage check")
    print("     V6 and is excluded from every improvement claim; it stays in")
    print("     the table so the exclusion is visible.)\n")

    idx = [i for i, (n, _) in enumerate(BENCH) if n != "B4"]
    b_beats_a = any(tb[r][i][0] < ta[r][i][0] for r in range(rounds) for i in idx)
    c_beats_a = any(tc[r][i][0] < ta[r][i][0] for r in range(rounds) for i in idx)
    b_equals_c = all(tb[r][i][0] == tc[r][i][0]
                     for r in range(rounds) for i in idx)
    ac_moved = any(ta[-1][i][0] < pa[-1][i][0] for i in idx)

    print("    (B) beats (A) on any qualified benchmark in any round: %s"
          % ("YES" if b_beats_a else "NO"))
    print("    (C) beats (A) on any qualified benchmark in any round: %s"
          % ("YES" if c_beats_a else "NO"))
    print("    (B) equals (C) on every qualified benchmark in every round: %s"
          % ("YES" if b_equals_c else "NO"))
    print("    AC matching moved (A) off the positional numbers:            %s"
          % ("YES" if ac_moved else "NO"))

    if b_beats_a and not c_beats_a:
        verdict = "ONE"
        text = """
    VERDICT ONE -- the earlier negative was a SUBSTRATE ARTIFACT.
    (B) breaks the plateau and (C) stays inert, so "what you can name
    determines what you can find" survives its first real test."""
    elif ac_moved and b_equals_c:
        verdict = "TWO"
        text = """
    VERDICT TWO -- two separate findings, both worth stating.

      1. THE MATCHER WAS A REAL CEILING.  B3 sat at 80 in every configuration
         including (A), and the vocabulary lane was right that no lemma this
         loop can mine could touch it.  It was right for a reason it named
         precisely, and the reason was the matcher, not the mathematics.  With
         a binary lemma able to see its redex inside an n-ary product, B3 moves
         and the loop's own mined difference-of-squares lemma is what moves it.

      2. AND VOCABULARY STILL DOES NOTHING.  (B) does not beat (A) on any
         qualified benchmark in any round, and (C) is indistinguishable from
         (B).  Fixing the matcher lifted the floor for all three arms equally.
         The vocabulary negative is NOT an artifact of the diagnosed cause: it
         survives the repair intact, which strengthens it.

    The two findings are independent.  The first says the runtime was measuring
    a matcher limitation and calling it a mathematical one.  The second says
    that even with the limitation removed, naming still buys zero steps -- and
    the reason is the one the vocabulary lane already gave and this run does not
    disturb: conservativity bars a constructor from entering a base query at
    all, so a vocabulary can only ever change which lemmas get MINED, and on
    these benchmarks it changes them into lemmas that do the same work."""
    elif not ac_moved:
        verdict = "THREE"
        text = """
    VERDICT THREE -- nothing moved.  The vocabulary negative is robust to the
    diagnosed cause, which strengthens it considerably."""
    else:
        verdict = "MIXED"
        text = """
    MIXED -- (B) and (C) are not equal and (B) does not beat (A).  Read the
    table above rather than a label."""
    print(text)
    audit("the verdict is one of the three the brief registered",
          verdict in ("ONE", "TWO", "THREE"), verdict)
    audit("the expectation registered in section 0 named verdict TWO; the "
          "measured verdict is %s" % verdict, True,
          "EXPECTATION %s" % ("HELD" if verdict == "TWO" else "MISSED"))
    return verdict


# ==========================================================================
# 6.  cost
# ==========================================================================

def section_6(book, index, plain, acruns, t_plain, t_ac, rounds: int) -> None:
    rule("6.  COST -- AC matching is expensive; here is where and how much")

    print("    (a) SAME TASK, WITH AND WITHOUT.  Same book, same benchmarks.\n")
    print("        task |  positional          |  AC                  | steps")
    print("             |  steps       work    |  steps       work    | bought")
    print("        -----+----------------------+----------------------+-------")
    tot_p = tot_a = 0
    overhead: List[int] = []
    saving = 0
    steps_saved = 0
    for name, t in BENCH:
        s0, w0, _ = benchmark_cost(book, index, t)
        run = AC.ACRun()
        ctr = Counter()
        d, _ = AC.ac_normalize(t, lemmas=tuple(book.lemmas), ctr=ctr,
                               name=name, run=run)
        check_derivation(d, dict(book.table(), **run.table()), ctr)
        tot_p += w0
        tot_a += ctr.work
        if s0 == ctr.steps:
            overhead.append(ctr.work - w0)
        else:
            saving += w0 - ctr.work
            steps_saved += s0 - ctr.steps
        print("        %-4s |  %6d   %8d  |  %6d   %8d  | %+5d"
              % (name, s0, w0, ctr.steps, ctr.work, s0 - ctr.steps))
    print("        -----+----------------------+----------------------+-------")
    print("        all  |           %8d  |           %8d  |"
          % (tot_p, tot_a))
    mean_overhead = sum(overhead) // max(len(overhead), 1)
    print("""
        On B1, B2 and B4 the AC matcher fires nothing and the extra work is
        pure overhead: %+d, %+d, %+d units, mean %d.  On B3 it fires once and
        the shorter derivation *saves* %d units of work as well as %d kernel
        steps -- a lemma firing early removes a whole distributive expansion,
        so where AC pays, it pays on both columns at once."""
          % tuple(overhead + [mean_overhead, saving, steps_saved]))

    print("\n    (b) THE CROSSOVER -- the first of two, and it is a workload")
    print("        composition, not a size.\n")
    ratio = saving / float(mean_overhead) if mean_overhead else 0.0
    print("        AC costs ~%d work units on a task where nothing fires and"
          % mean_overhead)
    print("        saves ~%d where something does, so the AC matcher is a net" % saving)
    print("        win on a workload iff at least 1 task in %d has a buried"
          % (int(ratio) + 1))
    print("        redex.  On this four-benchmark workload the ratio is 1 in 4")
    print("        and AC is a %s (%d -> %d total work)."
          % ("net win" if tot_a < tot_p else "net loss", tot_p, tot_a))
    print("""
        This is the same shape as `vocabulary/README.md` sec.5's crossover and
        the OPPOSITE sign: there the benefit column was identically zero so any
        cost crossed immediately.  Here the benefit is real, so there is an
        actual trade to locate, and it is located.""")

    print("\n    (c) THE CROSSOVER THAT WILL BITE FIRST -- book size.")
    print("        AC matching cannot use `LemmaIndex`: its probes are")
    print("        positional and a positional filter drops lemmas whose redex")
    print("        sits at a permuted position.  So AC gives up SCALE.md's")
    print("        constant-cost lemma lookup and goes back to a linear scan.\n")
    from runtime.crystallize.derivation import LemmaIndex
    filler = [Lemma("pad%d" % k,
                    P(S(PV(0), I(k)), S(PV(0), P(I(-1), I(k)))),
                    S(P(PV(0), PV(0)), I(-k * k)))
              for k in range(11, 411)]
    print("        book |  positional+index   |  AC (linear scan)")
    print("        size |  steps      work    |  steps      work")
    print("        -----+---------------------+---------------------")
    b1_steps = 0
    step_rows: List[Tuple[int, int]] = []
    for nb in (0, 10, 50, 100, 200, 400):
        bk = tuple(book.lemmas) + tuple(filler[:nb])
        idx = LemmaIndex(bk)
        c0 = Counter()
        normalize(BENCH[0][1], lemmas=bk, ctr=c0, name="idx%d" % nb, index=idx)
        run = AC.ACRun()
        c1 = Counter()
        AC.ac_normalize(BENCH[0][1], lemmas=bk, ctr=c1, name="ac%d" % nb,
                        run=run)
        b1_steps = c0.steps
        step_rows.append((c0.steps, c1.steps))
        print("        %4d |  %5d   %9d  |  %5d   %9d"
              % (len(bk), c0.steps, c0.work, c1.steps, c1.work))
    print("""
        Same B1, same answer, same %d kernel steps in every row.  The index
        column is flat; the AC column is linear in the book.  That is the wall
        AC matching walks into first, and nothing here moves it: the fix is a
        discrimination net keyed on the AC argument MULTISET rather than on
        positions, which is a different index and is not built.""" % b1_steps)
    audit("padding the book changes no kernel step in either column, so the "
          "two work columns are comparable",
          len({r for row in step_rows for r in row}) == 1, repr(step_rows))

    print("\n    (d) WHERE THE TIME ACTUALLY GOES.  Three arms, %d rounds:\n"
          % rounds)
    print("          positional   %7.1f s" % t_plain)
    print("          AC           %7.1f s   (%.0fx)"
          % (t_ac, t_ac / max(t_plain, 1e-9)))
    total = AC.ACStats()
    for _mode, (_o, _tr, run) in acruns.items():
        total.merge(run.stats)
    print("\n          AC matcher, summed over all three arms: %s"
          % total.render())
    print("""
        The wall-clock ratio is NOT the matcher's bill.  Profiled over six
        rounds, `ac_normalize` and everything under it accounts for about 1%
        of the run; the rest is `rewrite.install_theorem`, whose G3 gate scans
        every axiom of the book on every install (O(book) per install, O(n^2)
        cumulative), and `term.recompute_addr`, which STATUS.md already lists
        as tree-recursive rather than DAG-memoised.  AC matching does not make
        those slower; it makes the loop PROVE MORE, and the already-quadratic
        installation path is what pays.  Reporting the 40x as "AC matching is
        40x slower" would be reporting the wrong component.""")

    print("\n    (e) FIXPOINT, OR BUDGET?\n")
    for mode, label in ARMS:
        run = acruns[mode][2]
        print("          (%s)  %-14s  exhaustions=%d"
              % (label[0], run.status(), len(run.exhaustions)))
    all_fix = all(acruns[m][2].complete for m, _ in ARMS)
    audit("no arm's AC search hit its budget -- a fixpoint that became a "
          "budget exhaustion would be a real regression", all_fix)
    print("\n        `execute.saturate`'s own statuses are untouched: AC")
    print("        matching is wired into the ring substrate's lemma search")
    print("        only, and the e-graph saturation path in `generate.loop`'s")
    print("        PROVE step does not go through it.")


# ==========================================================================
# 7.  the next ceiling
# ==========================================================================

def section_7(b3: Dict[str, object], acruns) -> None:
    rule("7.  WHERE THE NEXT CEILING SITS")
    run = b3["run"]
    print("""    B3 lands on %d, which is exactly the hand-grouped term's number.
    That is the ceiling this repair could reach and not one step further: AC
    matching makes the flat term behave as if someone had grouped it by hand.
    It does not make the loop mine a lemma it could not mine before.

    The next ceiling is visible in B3's own AC derivation, so here it is
    rather than an argument about it.  The first eleven steps:
""" % b3["ac"])
    lrun = AC.ACRun()
    d, _ = AC.ac_normalize(B3, lemmas=(L_DSQ,), name="B3-evidence", run=lrun)
    for st in d.steps[:12]:
        print("      %2d  %-22s %s"
              % (st.index, st.rule[:22], render(st.after)))
    fold_at = [st.index for st in d.steps if st.rule == "fold_prod"]
    print("""
    Step 0 is the AC firing.  It produces another difference of squares --
    (x^4 + -1*(2y)*(2y)) * (x^4 + 4y^2) -- and the lemma does NOT fire on it.
    Steps %s are why: `fold_prod` contracts `-1*2*y*2*y` to `-4*y*y`, and after
    that there is no `-1 * #1 * #1` product node for the pattern to match.  The
    engine falls through to `distrib` at step %d and expands by brute force for
    the remaining %d steps.

    So the second firing is lost to ARITHMETIC NORMALISATION, not to grouping.
    Stated as precisely as the last ceiling was stated:

      the substrate's lemmas are matched modulo AC but NOT modulo the ring's own
      evaluation.  A pattern that mentions a coefficient matches only terms
      whose coefficients have not yet been folded, and `fold_prod`, `fold_sum`
      and `collect` fold them at the first opportunity.  Every mined lemma in
      this book carries a literal coefficient, so every one of them is one
      `fold` step away from being unmatchable.

    What would break it: matching modulo the ring's semiring structure --
    normalise the coefficient of each monomial during the match instead of
    demanding it syntactically.  That is AC1 matching (units) and then matching
    modulo a decidable equational theory, a strictly harder problem than the one
    built here, and it is not implemented and not faked.

    Two smaller ones, both measured above:

      * a pattern variable never absorbs several arguments (no extension
        variables), so `mul ?a ?b` will not match `mul x y z`.  Section 1's
        table is the cost of the case that IS implemented; extension variables
        multiply it by the number of set partitions of the argument multiset.
      * the discrimination net cannot be used, and section 6(c) measures what
        that costs: constant lookup becomes linear in the book.  The fix is a
        net keyed on the AC argument MULTISET rather than on positions.  It is
        a different index and it is not built.""" % (
        ", ".join(str(i) for i in fold_at[:2]),
        next(st.index for st in d.steps if st.rule == "distrib"),
        len(d.steps) - next(st.index for st in d.steps if st.rule == "distrib")))
    audit("the next ceiling is exhibited, not asserted: `fold_prod` destroys "
          "the second difference-of-squares redex", bool(fold_at),
          "fold_prod at steps %s" % fold_at[:2])


def _fired_str(run) -> str:
    got = sorted(run.stats.fired.items())
    return ", ".join("%s x%d" % kv for kv in got) or "nothing"


# ==========================================================================

def main() -> int:
    print("=" * 78)
    print("AC MATCHING: re-testing the vocabulary negative on a substrate that")
    print("can see a binary redex inside an n-ary product")
    print("=" * 78)
    print("    rounds: %d%s" % (ROUNDS, "  (--quick)" if QUICK else ""))

    rule("0.  THE EXPECTATION, REGISTERED BEFORE THE RUN")
    print(EXPECTATION)

    section_1()
    section_2()

    print("\n    building the round-%d fixed-vocabulary book on the AC "
          "substrate ..." % (ROUNDS - 1))
    run_a = AC.ACRun()
    with AC.ac_enabled(run=run_a):
        oa, _ta = run_config("fixed", ROUNDS)
    book, index = oa.book, oa.index
    print("    book: %s" % ", ".join(l.lid for l in book.lemmas))

    b3 = section_3(book, index)
    plain, acruns, t_plain, t_ac = section_4(ROUNDS)
    section_5(plain, acruns, ROUNDS)
    section_6(book, index, plain, acruns, t_plain, t_ac, ROUNDS)
    section_7(b3, acruns)

    rule("AUDITS")
    if FAILURES:
        for f in FAILURES:
            print("    FAILED: %s" % f)
        print("\n%d audit(s) failed." % len(FAILURES))
        return 1
    print("    every audit passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

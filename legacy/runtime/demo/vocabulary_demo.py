#!/usr/bin/env python3
"""The vocabulary experiment: does naming change what the loop can find?

    python3 runtime/demo/vocabulary_demo.py           # ~3 min
    python3 runtime/demo/vocabulary_demo.py --quick   # ~1 min

Exit 0 iff every audit passes.  The audits are: the kernel accepts every
defining equation and every unfolding edge; every theorem the extended loop
proves unfolds to a proof that checks in the base vocabulary; base answers are
unchanged; the planted non-definitions are all refused; and the leakage report
is produced (it is *not* required to be clean -- see section 8, where it fires
on a real run and disqualifies one of the held-out problems).

THE CEILING BEING ATTACKED
--------------------------
``generate/README.md`` sec.7 item 1: *the construction schema is finite and
human-written -- nothing inside the loop invents a constructor family.*  Both
held-out benchmarks drop exactly once and ten further rounds buy nothing.

THE EXPERIMENT
--------------
Because a definitional extension is **conservative**, the new vocabulary proves
nothing new.  So if it changes anything it changes *reachability under budget*.
Three configurations, same everything else:

    (A) fixed      the loop as it is
    (B) self       propose and install constructors from the loop's own history
    (C) null       install the same number, from a disjoint pool

The question: does (B) keep improving after the round where (A) plateaus, and
does (C) fail to?
"""

from __future__ import annotations

import os
import sys
from typing import Dict, List, Optional, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (I, P, PV, S, Sub, Term, V,        # noqa: E402
                                            Counter, normalize, render)
from runtime.generate.loop import (BENCHMARK, BENCHMARK2, Config,             # noqa: E402
                                   benchmark_cost)
from runtime.kernel import check as C                                          # noqa: E402
from runtime.vocabulary.conservativity import (GATES, admissible, admit,       # noqa: E402
                                               base_answers_unchanged, unfolds)
from runtime.vocabulary.define import (Definition, Vocabulary, def_app,        # noqa: E402
                                       fold, is_base, unfold, unfold_edge,
                                       vrender)
from runtime.vocabulary.propose import (RANK_RULE, VocabConfig,                # noqa: E402
                                        VocabularyOrganism,
                                        null_pool_candidates,
                                        propose_from_quotients,
                                        propose_from_subterms, to_definition,
                                        vocab_leakage_report)

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
# the held-out problems, fixed here, before any vocabulary run
# ==========================================================================
#
# B1 and B2 are ``generate/loop.py``'s, unchanged.  B3 and B4 were written
# before the first vocabulary round, in one sitting, to be *harder* than B1/B2
# in the specific way a self-extending vocabulary should help with: they need a
# shape the four hand-written families do not enumerate.  That choice is a
# human prior and is declared as one, exactly as ``generate/README.md`` sec.5
# declares its own.

_X, _Y = V("x"), V("y")
_XX = P(_X, _X)
_X4 = P(_XX, _XX)

B3: Term = P(S(_XX, P(I(2), _Y)), Sub(_XX, P(I(2), _Y)),
             S(_X4, P(I(4), _Y, _Y)))
B3_NAME = "B3  (x^2+2y)(x^2-2y)(x^4+4y^2)"

B4: Term = Sub(Sub(P(S(_X, _Y), S(_X, _Y)), P(Sub(_X, _Y), Sub(_X, _Y))),
               P(I(4), _X, _Y))
B4_NAME = "B4  ((x+y)^2 - (x-y)^2) - 4xy"

BENCH: Tuple[Tuple[str, Term], ...] = (
    ("B1", BENCHMARK), ("B2", BENCHMARK2), ("B3", B3), ("B4", B4))


def bench_row(book, index) -> Tuple[Tuple[int, int], ...]:
    return tuple(benchmark_cost(book, index, t)[:2] for _, t in BENCH)


# ==========================================================================
# 1. definitional extension
# ==========================================================================

def section_1() -> Vocabulary:
    rule("1.  DEFINITIONAL EXTENSION -- a constructor is defined, never posited")
    v = Vocabulary()
    sqr = Definition("sqr", 1, P(PV(0), PV(0)), provenance="hand (section 1)")
    inst = admit(v, sqr)
    print("    %s" % inst.render())
    audit("the defining equation is a kernel-checked Eq edge",
          inst.edge is not None and C.check_edge(inst.edge, v.ctx),
          inst.edge.render() if inst.edge else "")

    dsq = Definition("dsq", 2, P(S(PV(0), PV(1)), Sub(PV(0), PV(1))),
                     provenance="hand (section 1)")
    inst2 = admit(v, dsq)
    print("    %s" % inst2.render())

    # a definition may use an earlier definition -- and only an earlier one
    tri = Definition("gap", 2, S(sqr.head(PV(0)), P(I(-1), sqr.head(PV(1)))),
                     provenance="hand (section 1)")
    inst3 = admit(v, tri)
    print("    %s" % inst3.render())

    t = tri.head(S(_X, I(3)), _Y)
    u = unfold(t, v)
    print("\n    unfolding:  %s" % vrender(t))
    print("            ->  %s" % render(u))
    e = unfold_edge(t, v)
    audit("the unfolding is itself a kernel-checked Eq edge",
          C.check_edge(e, v.ctx), "%s, %d step(s)" % (e.render(), len(e.witness)))
    audit("the unfolded term is base", is_base(u))

    back = fold(u, v)
    print("    re-folding: %s" % vrender(back))
    audit("fold . unfold returns to the base term",
          unfold(back, v).addr == u.addr)

    print("\n    the seven admission gates:")
    for g, why in GATES:
        print("      %s  %s" % (g, why))
    return v


# ==========================================================================
# 2. the refusals
# ==========================================================================

def section_2(v: Vocabulary) -> None:
    rule("2.  WHAT IS REFUSED -- four things that are not definitional extensions")
    attacks: Tuple[Tuple[str, Definition, str], ...] = (
        ("an equation about OLD symbols wearing a definition's clothes",
         Definition("bad_old", 2, S(PV(0), PV(1)),
                    raw_lhs=P(PV(0), PV(1))), "D3"),
        ("a recursive body -- not eliminable",
         Definition("bad_rec", 1,
                    P(def_app("bad_rec", (PV(0),)), PV(0))), "D4"),
        ("a body with a parameter the left side does not bind",
         Definition("bad_free", 1, S(PV(0), PV(1))), "D5"),
        ("a definition with a side equation riding along",
         Definition("bad_side", 1, P(PV(0), PV(0)),
                    extra_axioms=((P(_X, _Y), S(_X, _Y)),)), "D7"),
    )
    for label, defn, want in attacks:
        rep = admissible(defn, v)
        fired = tuple(r.gate for r in rep.refusals)
        print("    %-58s %s" % (label[:58], " ".join(fired)))
        audit("refused: " + label[:44], (not rep.ok) and want in fired,
              "expected %s, got %s" % (want, list(fired)))
    before = len(v)
    for _, defn, _ in attacks:
        admit(v, defn)
    audit("a refused definition declares no axiom and installs nothing",
          len(v) == before)


# ==========================================================================
# 3. proposal from the loop's own history
# ==========================================================================

def section_3() -> None:
    rule("3.  PROPOSAL -- constructors mined from the loop's own history")
    print("    ranking rule:  %s\n" % RANK_RULE)
    o = VocabularyOrganism(Config(rounds=4), VocabConfig(mode="fixed"))
    for r in range(4):
        o.round(r)
    print("    history: %d derivation records, %d recorded terms, "
          "%d proved identifications" % (o.history.records, len(o.history),
                                         len(o.history.quotients)))
    subs = propose_from_subterms(o.history)
    quos = propose_from_quotients(o.history)
    print("\n    recurring OBJECTS (source 1) -- top 6 of %d:" % len(subs))
    for c in subs[:6]:
        print("      " + c.render())
    print("\n    proved QUOTIENTS (source 2) -- top 4 of %d:" % len(quos))
    for c in quos[:4]:
        print("      " + c.render())
    nulls = null_pool_candidates(o.history)
    print("\n    the NULL POOL (the control) -- top 4 of %d:" % len(nulls))
    for c in nulls[:4]:
        print("      " + c.render())
    shapes = set()
    for src in o.history.order:
        for t in o.history.terms[src]:
            shapes.add(t.addr)
    audit("no null-pool candidate occurs in the history (disjointness checked)",
          all(c.body.addr not in shapes for c in nulls))
    audit("every proposal has non-trivial spread",
          all(c.spread >= 3 for c in subs))
    audit("nothing is proposed at random",
          all(c.provenance in ("subterm", "quotient") for c in subs + quos))


# ==========================================================================
# 4. the experiment
# ==========================================================================

def run_config(mode: str, rounds: int, vcfg_kw: Optional[Dict] = None
               ) -> Tuple[VocabularyOrganism, List[Tuple[Tuple[int, int], ...]]]:
    kw = dict(mode=mode)
    kw.update(vcfg_kw or {})
    o = VocabularyOrganism(Config(rounds=rounds), VocabConfig(**kw))
    trace: List[Tuple[Tuple[int, int], ...]] = []
    for r in range(rounds):
        o.round(r)
        trace.append(bench_row(o.book, o.index))
    return o, trace


def section_4(rounds: int):
    rule("4.  THE EXPERIMENT -- (A) fixed vs (B) self-extending vs (C) null")
    base = tuple(benchmark_cost(None, None, t)[:2] for _, t in BENCH)
    print("    baseline, empty book:  " +
          "  ".join("%s %d steps" % (n, base[i][0])
                    for i, (n, _) in enumerate(BENCH)))
    print("\n    held out: %s ; %s" % (B3_NAME, B4_NAME))
    print("    (B1, B2 are generate/loop.py's own, unchanged)\n")

    runs = {}
    for mode, label in (("fixed", "A fixed"), ("self", "B self-extending"),
                        ("null", "C null control")):
        o, trace = run_config(mode, rounds)
        runs[mode] = (o, trace)
        print("    (%s)" % label)
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
    return runs


def section_5(runs, rounds: int) -> None:
    rule("5.  THE COST SIDE -- routes shortened vs search work added")
    A, ta = runs["fixed"]
    B, tb = runs["self"]
    Cn, tc = runs["null"]
    print("    Per round, summed over the four held-out problems.")
    print("      saved     = steps(A) - steps(X)        [kernel steps bought]")
    print("      bench dW  = work(X)  - work(A)         [search work on the")
    print("                                             benchmarks]")
    print("      lane work = what the proposal step itself costs, which only")
    print("                  (B) and (C) pay\n")
    print("        |     |        (B) self-extending       |    (C) null control")
    print("      r | voc | saved  bench dW  lane   total   | saved  bench dW  lane")
    print("     ---+-----+--------------------------------+----------------------")
    crossover_b = None
    crossover_c = None
    for r in range(rounds):
        sa = sum(c[0] for c in ta[r])
        sb = sum(c[0] for c in tb[r])
        sc = sum(c[0] for c in tc[r])
        wa = sum(c[1] for c in ta[r])
        wb = sum(c[1] for c in tb[r])
        wc = sum(c[1] for c in tc[r])
        vwb = B.vreports[r].vocab_work
        vwc = Cn.vreports[r].vocab_work
        kb = B.vreports[r].vocab
        kc = Cn.vreports[r].vocab
        if crossover_b is None and kb > 0 and (wb - wa) + vwb > 0 and sa - sb <= 0:
            crossover_b = kb
        if crossover_c is None and kc > 0 and (wc - wa) + vwc > 0 and sa - sc <= 0:
            crossover_c = kc
        print("     %2d | %3d | %5d %9d %6d %7d | %5d %9d %6d"
              % (r, kb, sa - sb, wb - wa, vwb, (wb - wa) + vwb,
                 sa - sc, wc - wa, vwc))

    total_bench = sum(c[1] for c in ta[-1])
    dwb = sum(c[1] for c in tb[-1]) - total_bench
    dwc = sum(c[1] for c in tc[-1]) - total_bench
    kb = max(1, len(B.vocab))
    kc = max(1, len(Cn.vocab))
    print("\n    THE CROSSOVER")
    print("      (B) self-extending: cost first exceeds benefit at constructor "
          "#%s" % crossover_b)
    print("      (C) null control  : cost first exceeds benefit at constructor "
          "#%s" % crossover_c)
    print("""
      Both answers are #1, and the reason is blunt rather than subtle: the
      benefit column is identically zero, so *any* cost crosses at the first
      constructor.  SCALE.md's 22-lemma crossover was a real trade -- lemmas
      bought 17 steps and search caught up at 22.  Here nothing is bought, so
      there is no trade to locate.""")
    print("\n    THE COSTS, SEPARATED -- and they are not the same size")
    print("      1. benchmark search work.  Total over the four problems in the")
    print("         final round is %d units.  (B) differs from (A) by %+d"
          % (total_bench, dwb))
    print("         (%+d per constructor), (C) by %+d (%+d per constructor)."
          % (dwb // kb, dwc, dwc // kc))
    signs = {(1 if sum(c[1] for c in tb[r]) > sum(c[1] for c in ta[r])
              else (-1 if sum(c[1] for c in tb[r]) < sum(c[1] for c in ta[r])
                    else 0))
             for r in range(rounds)}
    print("         That is %s%% and %s%% of the total; across the %d rounds it"
          % (_pct(dwb, total_bench), _pct(dwc, total_bench), rounds))
    print("         takes %s, and the books end at %d / %d / %d lemmas -- so"
          % ("both signs" if {1, -1} <= signs else "one sign",
             len(A.book.lemmas), len(B.book.lemmas), len(Cn.book.lemmas)))
    print("         this column tracks book size, not vocabulary.  Stated")
    print("         plainly: on the *query* side a constructor costs nothing")
    print("         measurable, because a constructor never enters a base query.")
    print("      2. the proposal step's own work.  %d units in round 0 and %d in"
          % (B.vreports[0].vocab_work, B.vreports[-1].vocab_work))
    print("         round %d -- growing by roughly %d per round, because mining"
          % (rounds - 1,
             (B.vreports[-1].vocab_work - B.vreports[0].vocab_work) //
             max(1, rounds - 1)))
    print("         re-walks the *whole* history every round.  Cumulative cost")
    print("         is therefore quadratic in rounds: %d units over %d rounds."
          % (sum(v.vocab_work for v in B.vreports), rounds))
    print("         This is the same defect shape as AxiomVault's monotonic")
    print("         growth (generate/README.md sec.7 item 6) and it, not the")
    print("         query side, is what a self-extending vocabulary actually")
    print("         costs here.")
    print("      3. generation displacement.  States are pinned at the budget")
    print("         cap (%d) in every round of every configuration, so a"
          % A.reports[-1].states)
    print("         constructor's seeds do not *add* reachable states -- they")
    print("         take budget from the hand-written families.  Naming is not")
    print("         free even when it is conservative.")


def _pct(part: int, whole: int) -> str:
    if whole == 0:
        return "0.00"
    sign = "-" if part < 0 else "+"
    scaled = abs(part) * 10000 // whole
    return "%s%d.%02d" % (sign, scaled // 100, scaled % 100)


# ==========================================================================
# 6. where the new ceiling sits
# ==========================================================================

def section_6(runs) -> None:
    rule("6.  DIAGNOSIS -- where the new ceiling sits")
    A, _ = runs["fixed"]
    lemmas = tuple(A.book.lemmas)
    B3g = P(P(S(_XX, P(I(2), _Y)), Sub(_XX, P(I(2), _Y))),
            S(_X4, P(I(4), _Y, _Y)))
    rows = []
    for name, t in (("B3, flat 3-ary product", B3),
                    ("B3, the SAME polynomial, binary grouping", B3g)):
        c0 = Counter()
        normalize(t, ctr=c0)
        c1 = Counter()
        d1, _ = normalize(t, lemmas=lemmas, ctr=c1, index=A.index)
        fires = [s.rule for s in d1.steps if s.lemma_id is not None]
        rows.append((name, c0.steps, c1.steps, fires))
        print("    %-44s  base %3d -> book %3d   fires %s"
              % (name, c0.steps, c1.steps, fires or "none"))
    audit("the flat form fires no lemma at all", not rows[0][3])
    audit("the grouped form fires one and is strictly shorter",
          bool(rows[1][3]) and rows[1][2] < rows[1][1])
    print("""
    That pair is the whole diagnosis.  The substrate has FLAT n-ary products,
    and its only associativity rule splices nested products upward -- nothing
    introduces a grouping.  A mined lemma whose left side is a *binary* product
    therefore cannot see its own redex inside a 3-ary product, and B3's 80
    steps are untouchable by any lemma the loop can mine, in every
    configuration including (A).

    A constructor does not fix this, and the reason is exact:

      * a constructor is proposed by generalising shapes that ALREADY OCCUR in
        the history, so the set of shapes it can name is closed under
        "already built".  Naming re-describes the reachable set; it does not
        enlarge its shape space.  The loop's four hand-written families build
        binary products, so every proposal is a binary product, so every lemma
        mined from a constructor's seeds is a binary lemma.
      * and it may not be used on a base problem anyway.  That is
        conservativity, and it is not a technicality: the extended vocabulary
        is barred from the benchmark by the same argument that makes it safe.

    So the ceiling moved from "the schema is finite" to "the proposal
    mechanism is closed under what the schema already built".  It moved by
    exactly one level and it is still a ceiling.""")


# ==========================================================================
# 7. conservativity
# ==========================================================================

def section_7(runs) -> None:
    rule("7.  CONSERVATIVITY -- executed, not cited")
    B, _ = runs["self"]
    ok, rows = B.conservativity_audit()
    print("    %d theorem(s) proved in the extended vocabulary; every one "
          "unfolded\n    and re-checked in the base:" % len(rows))
    for r in rows[:6]:
        print("      " + r.render())
    if len(rows) > 6:
        print("      ... %d more, all ok" % (len(rows) - 6))
    audit("every extended theorem unfolds to a base proof that checks", ok,
          "; ".join(r.reason for r in rows if not r.ok)[:200])

    probes = [t for _, t in BENCH] + [P(S(_X, _Y), Sub(_X, _Y)),
                                      S(P(_X, _X), P(I(-1), _Y, _Y))]
    rep = base_answers_unchanged(probes, B.vocab, tuple(B.book.lemmas))
    audit("base answers are unchanged by the extension", rep.ok, rep.render())

    # the planted control: a theorem whose unfolding does not check
    v = Vocabulary()
    admit(v, Definition("sq", 1, P(PV(0), PV(0)), provenance="control"))
    lhs = v.get("sq").head(_X)
    bad = unfolds(lhs, P(_X, _X, _X), v, label="x_unfolding_does_not_check")
    audit("planted control: an extended 'theorem' whose unfolding fails is "
          "refused", not bad.ok, bad.reason)


# ==========================================================================
# 8. leakage
# ==========================================================================

def section_8(runs) -> None:
    rule("8.  LEAKAGE -- four base routes plus four the vocabulary opens")
    for mode, label in (("fixed", "A"), ("self", "B"), ("null", "C")):
        o, _ = runs[mode]
        rep = vocab_leakage_report(o, BENCH)
        print("    (%s) %s" % (label, rep.render()))
        audit("leakage report is total over (%s)'s definitions" % label,
              rep.definitions_checked == len(o.vocab))
        audit("(%s): no finding touches B1, B2 or B3" % label,
              not any(("B1" in f or "B2" in f or "B3" in f)
                      for f in rep.findings + rep.base_findings),
              "; ".join(f for f in rep.findings + rep.base_findings
                        if "B1" in f or "B2" in f or "B3" in f)[:160])

    # ---- the planted cheat: a constructor that leaked the benchmark ------
    print("\n    PLANTED CONTROL -- the subtle cheat, and it must be caught.")
    print("    Poison the history with the benchmark's own derivation, exactly")
    print("    as a loop that had been allowed to look would have recorded it,")
    print("    then let the proposer do its ordinary job:")
    cheat = VocabularyOrganism(Config(rounds=1), VocabConfig(mode="self"))
    ctr = Counter()
    d, _ = normalize(BENCHMARK, ctr=ctr, name="benchmark-poison")
    traj = [BENCHMARK] + [st.after for st in d.steps]
    for i in range(3):                       # three "independent" records
        cheat.history.add_terms("poisoned-%d" % i, traj)
    cands = propose_from_subterms(cheat.history, min_spread=3)
    installed = 0
    for c in cands[:6]:
        inst = admit(cheat.vocab, to_definition("p%d" % installed, c))
        if inst.ok:
            installed += 1
    print("      %d constructor(s) installed from the poisoned history"
          % installed)
    rep = vocab_leakage_report(cheat, BENCH)
    print("      " + rep.render().replace("\n", "\n      "))
    audit("planted control: a constructor that leaked the benchmark is "
          "detected", not rep.clean)
    audit("planted control: the findings name the provenance routes",
          any(f.startswith("V5") for f in rep.findings)
          and any(f.startswith("V6") for f in rep.findings))

    print("""
    TWO REAL FIRINGS, RECORDED RATHER THAN QUIETLY FIXED

    1. The first constructor configuration (B) ever proposed was
       ``c1(#0,#1) := #0 + (-1*#1)`` -- subtraction itself.  Its instances are
       seeds, and a bare subtraction seed makes *every* term whose root is a
       subtraction an instance of a seed, so ``leakage_report``'s L4 and this
       module's V2 both fired on B4.  The response is gate **P1** in
       propose.py: a constructor may not rename syntax the substrate already
       has (its flat Sum/Prod heads and its one abbreviation, Sub).  The
       generate lane changed its embedding when L4 fired at it
       (generate/README.md sec.5); this is the same event one layer up.

    2. In the default configuration, printed above, **V6 fires on (B) against
       B4**: constructors were generalised from witnesses lying in B4's own
       derivation closure.  B4 is ((x+y)^2 - (x-y)^2) - 4xy, and everything in
       it is something the loop builds from x and y anyway, so B4 is **not
       independent of the loop's history**.  It is therefore excluded from
       every improvement claim here, and it stays in the tables so the
       exclusion is visible rather than tidied away.  (At
       ``installs_per_round=2, min_size=4`` the coarser V1 fires on B4 as
       well.)  B1, B2 and B3 draw no finding in any configuration, which is
       asserted above rather than eyeballed.""")


# ==========================================================================
# 9. verdict
# ==========================================================================

def section_9(runs, rounds: int) -> None:
    rule("9.  VERDICT")
    A, ta = runs["fixed"]
    B, tb = runs["self"]
    Cn, tc = runs["null"]
    print("    steps, final round, per held-out problem (B4 disqualified,")
    print("    see section 8):")
    print("      %-6s %s" % ("", "  ".join("%6s" % n for n, _ in BENCH)))
    for label, tr in (("A", ta), ("B", tb), ("C", tc)):
        print("      %-6s %s" % (label, "  ".join("%6d" % c[0] for c in tr[-1])))
    plateau_a = next((r for r in range(1, rounds)
                      if all(ta[r][i][0] == ta[r - 1][i][0]
                             for i in range(len(BENCH)))), rounds)
    improved_b = any(tb[-1][i][0] < ta[-1][i][0] for i in range(len(BENCH)))
    improved_c = any(tc[-1][i][0] < ta[-1][i][0] for i in range(len(BENCH)))
    ever_b = any(tb[r][i][0] < ta[r][i][0]
                 for r in range(rounds) for i in range(len(BENCH)))
    print("\n    (A) plateaus from round %d." % plateau_a)
    print("    (B) breaks the plateau: %s" % ("YES" if improved_b else "NO"))
    print("    (C) breaks the plateau: %s" % ("YES" if improved_c else "NO"))
    print("    (B) beats (A) on any benchmark in any round: %s"
          % ("YES" if ever_b else "NO"))

    # (B) is not a no-op: it really changed the loop it ran inside
    same_book = ([repr(l) for l in A.book.lemmas]
                 == [repr(l) for l in B.book.lemmas])
    print("\n    and (B) is not a no-op -- it changed the loop it ran inside:")
    print("      constructors installed        %d" % len(B.vocab))
    print("      seeds contributed to GENERATE %d" % len(B.vocab_seed_log))
    print("      final book, (A) / (B) / (C)   %d / %d / %d lemmas"
          % (len(A.book.lemmas), len(B.book.lemmas), len(Cn.book.lemmas)))
    print("      extended theorems checked     %d" % len(B.theorems))
    audit("(B) really did change the loop's book", not same_book)
    audit("(B) really did contribute seeds to GENERATE",
          len(B.vocab_seed_log) > 0)

    print("""
    So the answer is the one the brief flagged as the more likely, and it is
    negative.  (B) does not keep improving after (A) plateaus.  (C) does not
    either.  Neither buys a single kernel step on any held-out problem.

    On cost, the honest reading is narrower than "B costs more than C".  The
    benchmark search-work differences between the three configurations are a
    fraction of a percent and change sign across rounds -- they track book
    size, not vocabulary.  What (B) genuinely costs, and (A) does not pay at
    all, is the proposal step itself, whose per-round work grows linearly with
    the history it re-walks.  Provenance changed *which* constructors got
    installed and therefore which lemmas got mined; it did not change the sign
    of the benefit, which was zero in both.

    Two things were established rather than assumed:

      1. a self-extending vocabulary can be built so that it is *safe* -- 7
         admission gates, every defining equation a kernel-checked Eq edge,
         every extended theorem unfolded and re-checked in the base, base
         answers provably unmoved, and a leakage check that fired on a real
         run rather than only on a plant;
      2. the reason it does not pay is locatable, and it is not "definitions
         are useless".  It is section 6: proposal by generalisation from
         history is *closed* under what the schema already built, and this
         substrate's flat n-ary products then make binary lemmas invisible to
         wider products.  The ceiling moved from "the schema is finite" to
         "the proposal mechanism cannot leave the schema's shape space".

    What would break it, stated so that the next lane does not have to guess:
    a proposer that reads the *residual* of a failed match -- why did L1 not
    fire on B3? because its redex is buried in a 3-ary product -- and names
    the missing grouping, rather than one that generalises the shapes that did
    occur.  That is a different mechanism, it is not implemented here, and
    nothing in this package pretends otherwise.""")


def main() -> int:
    print(__doc__)
    print("mode: %s, %d rounds per configuration" % (
        "quick" if QUICK else "full", ROUNDS))
    v = section_1()
    section_2(v)
    section_3()
    runs = section_4(ROUNDS)
    section_5(runs, ROUNDS)
    section_6(runs)
    section_7(runs)
    section_8(runs)
    section_9(runs, ROUNDS)
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

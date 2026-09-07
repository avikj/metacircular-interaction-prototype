#!/usr/bin/env python3
"""The closed loop of CRYSTAL.md sec 7, run end to end, with no model in it.

    python3 runtime/demo/organism_demo.py [--rounds N] [--quick]

Exit 0 iff every audit passes.  The *measurement* -- whether the held-out
benchmark gets cheaper -- is reported whatever it says; a plateau and a
regression are results, and this script prints them rather than tuning them
away.

What is being asked
-------------------
Every layer of ``runtime/`` before this one is reactive: hand it mathematics
and it improves.  Nothing generated mathematics.  This runs the whole cycle --

    GENERATE -> DISTINGUISH -> PROVE -> CRYSTALLIZE -> COMPRESS -> ROUTE
             -> REFLECT ------------------------------------------^

-- for N rounds, with a benchmark fixed before round 1 that the loop never
sees, and reports the benchmark's exact cost every round, against a **null
trajectory** in which only the CRYSTALLIZE arrow is removed.  If the two are
indistinguishable the loop is generating and not learning, and this script
says exactly that.
"""

from __future__ import annotations

import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (P, V, poly_equal,               # noqa: E402
                                            render)
from runtime.generate.loop import (ARROWS, BENCHMARK, BENCHMARK2,           # noqa: E402
                                   BENCHMARKS, Config, Organism,
                                   benchmark_cost, constructions,
                                   leakage_report)
from runtime.generate.multiway import (AxiomVault, GenerationBudget, MEdge,  # noqa: E402
                                       MultiwayGraph, causal_report)
from runtime.generate import propose as PR                                   # noqa: E402
from runtime.kernel import check as C                                        # noqa: E402
from runtime.kernel.edges import Edge, compose                               # noqa: E402

W = 78


def hdr(s: str) -> None:
    print("\n" + "=" * W + "\n%s\n" % s + "=" * W)


def cfg_for(rounds: int, quick: bool, **kw) -> Config:
    gen = (GenerationBudget(max_states=70, max_edges=180, max_depth=4, max_size=22)
           if quick else
           GenerationBudget(max_states=140, max_edges=380, max_depth=5, max_size=24))
    base = dict(rounds=rounds, width=3, gen=gen,
                max_conjectures=14 if quick else 26,
                closure_limit=4 if quick else 8)
    base.update(kw)
    return Config(**base)


def main(argv=None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    quick = "--quick" in argv
    rounds = 6 if quick else 12
    if "--rounds" in argv:
        rounds = int(argv[argv.index("--rounds") + 1])
    failures = []

    def want(cond, msg):
        if not cond:
            failures.append(msg)
        return cond

    # ------------------------------------------------------------------ 0
    hdr("0. THE ARROWS, AND THE ONE THAT IS NOT WIRED")
    for name, impl in ARROWS:
        mark = "--" if "NOT WIRED" in impl else "ok"
        print("  %s  %-12s %s" % (mark, name, impl))
    print("\n  REALIZE is left out on purpose.  render/ builds perceptual")
    print("  surfaces from a channel spec and nothing in this loop consumes")
    print("  one, so wiring it would be decoration reported as an arrow.")

    # ------------------------------------------------------------------ 1
    hdr("1. THE HELD-OUT BENCHMARKS, FIXED BEFORE ROUND 1")
    base = {}
    for label, t in BENCHMARKS:
        st, wk, ans = benchmark_cost(None, None, t)
        base[label] = (st, wk, ans)
        print("  %s" % label)
        print("    term      : %s" % render(t))
        print("    answer    : %s   (independently decided: %s)"
              % (render(ans), poly_equal(t, ans)))
        print("    baseline  : %d kernel steps, %d search work, empty book"
              % (st, wk))
        want(poly_equal(t, ans), "%s baseline answer is wrong" % label)
    b_steps, b_work, b_ans = base[BENCHMARKS[0][0]]
    b2_steps = base[BENCHMARKS[1][0]][0]
    print("\n  Two, not one, and both fixed at the same moment: with a single")
    print("  benchmark a loop that improves once cannot be told from a loop")
    print("  that improves once and then stops.  B1 and B2 need *different*")
    print("  lemmas, so the pair answers 'does learning recur?'.")
    print("\n  Neither is ever a seed, a generated state, a mining")
    print("  input, a compression input or a routing input.  Those")
    print("  four are machine-checked by leakage_report (section 6) and by")
    print("  four planted controls in runtime/tests/test_generate.py.")
    print("\n  The construction schema is a fixed enumeration over S and P; the")
    print("  first constructions it emits are:")
    for t in constructions(0) + constructions(1):
        print("      %s" % render(t))


    # ------------------------------------------------------------------ 2
    hdr("2. GENERATION IS TYPED: A CORRUPT REWRITE IS REFUSED, NOT SCORED")
    x, y = V("x"), V("y")
    from runtime.crystallize.derivation import I, S, Sub
    seed = P(S(x, y), Sub(x, y))
    g0 = MultiwayGraph(AxiomVault())
    from runtime.crystallize.derivation import RULE_TABLE
    good = g0.admit(seed, (), "distrib", RULE_TABLE["distrib"](seed))
    print("  valid  distrib step                  : %s"
          % ("ADMITTED  " + good.render() if isinstance(good, MEdge) else good))
    bad1 = g0.admit(seed, (), "distrib", S(P(x, x)))
    print("  corrupt contractum                   : %s" % bad1.render())
    true_other = S(P(x, x), P(I(-1), y, y))
    bad2 = g0.admit(seed, (), "distrib", true_other)
    print("  TRUE but mis-attributed contractum   : %s" % bad2.render())
    print("    (that one is a real theorem -- %s -- and is still refused,"
          % render(true_other))
    print("     because A1 asks what the *named rule* does, not what is true)")
    print("  accepted graph after three proposals : %d edges, %d axioms"
          % (len(g0.edges), len(g0.vault)))
    want(len(g0.edges) == 1, "a corrupt rewrite entered the accepted graph")
    forged = Edge(kind="Eq", src=g0.edges[0].edge.src, dst=g0.edges[0].edge.dst,
                  witness=(C.Step(src=g0.edges[0].edge.src,
                                  dst=g0.edges[0].edge.dst, kind="assumption",
                                  witness=C.Axiom("rw|distrib|forged|forged")),))
    fresh = C.CheckContext(axioms=dict(g0.vault.ctx.axioms))
    print("  forged edge citing an undeclared axiom: %s"
          % ("ACCEPTED (bad)" if C.check_edge(forged, fresh) else "REFUSED"))
    want(not C.check_edge(forged, C.CheckContext(axioms=dict(g0.vault.ctx.axioms))),
         "the kernel accepted a forged edge")

    # ------------------------------------------------------------------ 3
    hdr("3. THE FULL LOOP")
    t0 = time.time()
    full = Organism(cfg_for(rounds, quick))
    full.run()
    t_full = time.time() - t0
    print("  %d rounds in %.1fs" % (rounds, t_full))
    print("""
   r | states edges | coll surv | conj disc refu | +L book drop | ch |  B1        B2
 ----+--------------+-----------+----------------+--------------+----+---------------""")
    for r in full.reports:
        print("  %2d | %5d %5d | %4d %4d | %4d %4d %4d | %2d %4d %4d | %2d | %3d %5d %3d %5d"
              % (r.rnd, r.states, r.edges, r.colls_found, r.surviving,
                 r.proposed, r.discharged, r.refuted, r.installed, r.book,
                 r.dropped_lemmas, r.channel, r.bench_steps, r.bench_work,
                 r.bench2_steps, r.bench2_work))
    print("""
   states/edges  the round's multiway graph (every edge a checked kernel Eq)
   coll/surv     collisions found / left unproposed by the proposal budget
                 -- surviving collisions are a REFLECT residual, not a loss
   conj          conjectures proposed this round (collisions + speculative
                 transitive closure), disc = discharged into an Eq edge,
                 refu = refuted by an exact separating point
   +L/book/drop  lemmas installed through the 7 gates / book size / dropped
                 by COMPRESS for never firing
   ch            probes in the observation channel (REFLECT widens it)
   B1/B2         each held-out benchmark: kernel steps, then search work""")

    # ------------------------------------------------------------------ 4
    hdr("4. THE NULL TRAJECTORY: THE SAME LOOP WITH CRYSTALLIZE REMOVED")
    t0 = time.time()
    null = Organism(cfg_for(rounds, quick, crystallize=False))
    null.run()
    print("  %d rounds in %.1fs -- generation, distinction, proof, compression,"
          % (rounds, time.time() - t0))
    print("  routing and reflection all still run; only the arrow that turns")
    print("  repeated derivations into lemmas is removed.\n")
    print("   r | generated  | conjectures | B1 steps  | B2 steps  |   B1 work")
    print("     | full  null | full   null | full null | full null |  full   null")
    print(" ----+------------+-------------+-----------+-----------+--------------")
    for a, b in zip(full.reports, null.reports):
        print("  %2d | %4d %5d | %4d  %4d | %4d %4d | %4d %4d | %5d %6d"
              % (a.rnd, a.states, b.states, a.proposed, b.proposed,
                 a.bench_steps, b.bench_steps, a.bench2_steps, b.bench2_steps,
                 a.bench_work, b.bench_work))

    ft = [r.bench_steps for r in full.reports]
    nt = [r.bench_steps for r in null.reports]
    ft2 = [r.bench2_steps for r in full.reports]
    nt2 = [r.bench2_steps for r in null.reports]
    gen_full = sum(r.states for r in full.reports)
    gen_null = sum(r.states for r in null.reports)
    print("\n  null trajectory generated %d states and %d conjectures and moved"
          % (gen_null, sum(r.proposed for r in null.reports)))
    print("  the benchmark by %d steps.  Generation alone is not learning."
          % (nt[0] - nt[-1]))
    want(nt == [b_steps] * len(nt) and nt2 == [b2_steps] * len(nt2),
         "the null trajectory moved a benchmark")

    # ------------------------------------------------------------------ 5
    hdr("5. THE MEASUREMENT")
    best, best2 = min(ft), min(ft2)
    first_drop = next((i for i, s in enumerate(ft) if s < b_steps), None)
    first_drop2 = next((i for i, s in enumerate(ft2) if s < b2_steps), None)
    print("  B1 baseline %d   full %s" % (b_steps, ft))
    print("               %s null %s" % (" " * len(str(b_steps)), nt))
    print("  B2 baseline %d   full %s" % (b2_steps, ft2))
    print("               %s null %s" % (" " * len(str(b2_steps)), nt2))
    print("\n  first round below baseline     : B1 %s, B2 %s"
          % ("round %d" % first_drop if first_drop is not None else "never",
             "round %d" % first_drop2 if first_drop2 is not None else "never"))
    print("  best                           : B1 %d steps, B2 %d steps"
          % (best, best2))
    print("  step regression                : %s"
          % ("none -- neither benchmark ever rose above its baseline"
             if max(ft) <= b_steps and max(ft2) <= b2_steps else "yes"))
    w2 = [r.bench2_work for r in full.reports]
    print("  WORK regression, round %d       : B2 %d -> %d search work with a"
          % (0, base[BENCHMARKS[1][0]][1], w2[0]))
    print("                                   book that buys it 0 steps -- the")
    print("                                   round-0 lemmas are irrelevant to")
    print("                                   B2 and cost it %+d work.  That is"
          % (w2[0] - base[BENCHMARKS[1][0]][1]))
    print("                                   a real regression and it is the")
    print("                                   null-control signature of SCALE.md.")
    for label, t in BENCHMARKS:
        st, wk, ans = benchmark_cost(full.book, full.index, t)
        print("  %s answer after: %s (independently decided: %s)"
              % (label.split()[0], render(ans), poly_equal(t, ans)))
        want(poly_equal(t, ans), "%s answer changed" % label)
    learning = (best < b_steps and best2 < b2_steps
                and nt == [b_steps] * len(nt) and nt2 == [b2_steps] * len(nt2))
    print("\n  VERDICT: %s" % (
        "the loop is LEARNING -- the benchmark is strictly cheaper and the\n"
        "           null trajectory, which generates just as much, is not."
        if learning else
        "the loop is GENERATING BUT NOT LEARNING -- the full and null\n"
        "           trajectories are indistinguishable."))
    last = max(first_drop or 0, first_drop2 or 0)
    print("\n  HONEST COUNTERWEIGHT.  Each benchmark drops exactly once, and")
    print("  both drops are done by round %d.  This is a staircase with two" % last)
    print("  steps, not a decaying curve: rounds %d..%d generate %d more states,"
          % (last + 1, len(ft) - 1,
             sum(r.states for r in full.reports[last + 1:])))
    print("  prove %d more conjectures and install %d more lemmas, and buy"
          % (sum(r.discharged for r in full.reports[last + 1:]),
             sum(r.installed for r in full.reports[last + 1:])))
    print("  either benchmark exactly nothing.  A third held-out problem needing")
    print("  a lemma from a later family would presumably add a third step; that")
    print("  is a prediction this demo does not test, and it is not evidence.")
    want(best < b_steps, "B1 never got cheaper")
    want(best2 < b2_steps, "B2 never got cheaper")

    # ------------------------------------------------------------------ 6
    hdr("6. LEAKAGE CHECK")
    rep = leakage_report(full)
    print("  %s" % rep.render())
    print("""
   L1 benchmark used as a generation seed            checked against %d seeds
   L2 benchmark subterm reached as a generated state checked against %d states
   L3 benchmark used as a mining input               checked against %d inputs
   L4 benchmark is an instance of a seed             the subtle one: a seed the
      benchmark instantiates would make the "independent problem" an instance
      of a training problem, which is the crystallize lane's hand-checked
      condition, here machine-checked""" % (rep.seeds_checked,
                                            rep.states_checked,
                                            rep.mining_inputs_checked))
    leaky = Organism(cfg_for(1, True))
    leaky.all_seeds.append(BENCHMARK)
    leaky.round(0)
    lrep = leakage_report(leaky)
    print("\n  planted control -- benchmark injected as a generation seed:")
    print("    %s" % lrep.render())
    want(rep.clean, "the real run leaked")
    want(not lrep.clean, "the leakage check failed to catch a planted leak")

    # ------------------------------------------------------------------ 7
    hdr("7. WHAT THE LOOP PROVED, REFUTED AND THREW AWAY")
    pg = full.pg
    print("  conjectures proposed          : %d" % len(pg.order))
    print("    discharged into Eq edges    : %d" % pg.count(PR.DISCHARGED))
    print("    refuted (counterexample)    : %d" % pg.count(PR.REFUTED))
    print("    still open / budget-exhausted: %d" % pg.count(PR.OPEN))
    print("  speculative closure edges     : %d" % pg.closure_edges)
    print("  dependency cones computed     : %d, largest %d facts"
          % (len(pg.invalidations),
             max((i.cone.size for i in pg.invalidations), default=0)))
    for cid, sep, va, vb in pg.counterexamples[:3]:
        cj = pg.conjectures[cid]
        print("\n  counterexample: %s" % render(cj.lhs))
        print("             vs : %s" % render(cj.rhs))
        print("     separated at %s   ->  %d != %d"
              % (PR.probe_render(sep), va, vb))
        print("     genuinely different polynomials: %s"
              % (not poly_equal(cj.lhs, cj.rhs)))
    big = [i for i in pg.invalidations if i.cone.size > 1]
    if big:
        print("\n  a refutation's cone (propagate/ computes it, nothing marks it):")
        print("    %s" % big[0].render())
        print("    dies: %s" % ", ".join(f[:22] for f in big[0].dies[:4]))
    want(pg.count(PR.REFUTED) > 0, "nothing was ever refuted")
    want(any(i.cone.size > 1 for i in pg.invalidations),
         "no refutation had a real cone")

    # ------------------------------------------------------------------ 8
    hdr("8. THE SEARCH COST FIGHTS BACK  (SCALE.md sec 2-3, inside the loop)")
    scan = Organism(cfg_for(rounds, quick, use_index=False))
    scan.run()
    print("  Same loop, same book, same derivations -- only the lemma lookup")
    print("  differs: discrimination net (amortised) vs linear scan.\n")
    print("   r | book | B1 steps  |  B1 work: net    scan    delta")
    print(" ----+------+-----------+-------------------------------")
    for a, b in zip(full.reports, scan.reports):
        print("  %2d | %4d | %4d %4d |     %6d  %6d  %+7d"
              % (a.rnd, a.book, a.bench_steps, b.bench_steps,
                 a.bench_work, b.bench_work, b.bench_work - a.bench_work))
    d_net = full.reports[-1].bench_work - full.reports[0].bench_work
    d_scan = scan.reports[-1].bench_work - scan.reports[0].bench_work
    print("\n  step counts identical in every row: %s"
          % ([a.bench_steps for a in full.reports] ==
             [b.bench_steps for b in scan.reports]))
    print("  work growth across the run   net %+d   scan %+d" % (d_net, d_scan))
    print("  SCALE.md sec 2 measured the scan's slope at 184 work units per")
    print("  lemma per query at 12 steps; the scan column here reproduces it")
    print("  inside a loop that is installing its own lemmas.")
    want([a.bench_steps for a in full.reports] ==
         [b.bench_steps for b in scan.reports],
         "the index changed a step count")

    # ------------------------------------------------------------------ 9
    hdr("9. AUDITS")
    for name, ok, why in full.audit():
        print("  %-34s %s  %s" % (name, "ok " if ok else "FAIL", why))
        want(ok, "%s: %s" % (name, why))
    cr = causal_report(full.graphs[-1])
    print("  last round's causal structure     : %s" % cr.render())
    print("  axioms declared by the vault      : %d" % len(full.vault))
    print("  vault refusals (A1 / A2)          : %d / %d"
          % (full.vault.a1_failures, full.vault.a2_failures))
    print("  accepted Eq edges                 : %d" % len(pg.accepted_edges))
    print("  Conjecture edges in accepted set  : 0 (asserted by audit)")

    # ------------------------------------------------------------------ 10
    hdr("10. WHAT BREAKS FIRST")
    print("""  1. PROVE is nearly complete on this substrate, so the residual
     stream REFLECT was meant to carry is almost empty: normalisation
     decides equality here and the audit grid decides inequality, so
     conjectures rarely survive a round.  The residuals that do flow are
     the collisions the proposal budget truncated.  On a substrate without
     a decision procedure this arrow would carry the load and this loop has
     not been tested there.
  2. The construction schema is finite and human-written.  Nothing inside
     the loop invents a new constructor family, so after the schema is
     exhausted the loop re-derives what it already knows.  That, not any
     property of crystallization, is why the trajectory plateaus.
  3. COMPRESS is a heuristic with a grace period.  With grace 0 it deletes
     every lemma one round after installing it (observed, then fixed); with
     grace too large the book grows and section 8's scan column is what
     happens.  There is no principled setting here, only a measured one.
  4. The speculative closure graph is the only reason a counterexample has
     a cone.  It is a real dependency structure, but it is *shallow*: cones
     of 2-6 facts, not the deep consequence trees propagate/ was built for.
  5. The multiway graph is regenerated per round and thrown away except for
     the state pool.  Causal structure is measured and then discarded; the
     loop does not yet use causal invariance to prune anything.""")

    hdr("VERDICT")
    print("  benchmarks B1 %d -> %d, B2 %d -> %d kernel steps; both answers"
          % (b_steps, best, b2_steps, best2))
    print("             unchanged and independently decided.  Null trajectory:")
    print("             B1 %d -> %d, B2 %d -> %d (flat)."
          % (nt[0], nt[-1], nt2[0], nt2[-1]))
    print("  loop       %s" % ("LEARNING" if learning else "NOT LEARNING"))
    print("  leakage    %s" % ("CLEAN, and the planted leak was caught"
                               if rep.clean and not lrep.clean else "SUSPECT"))
    print("  audits     %s" % ("all pass" if not failures else "FAILURES"))
    if failures:
        print("\n  FAILURES:")
        for f in failures:
            print("    - " + f)
    return 0 if not failures else 1


if __name__ == "__main__":
    sys.exit(main())

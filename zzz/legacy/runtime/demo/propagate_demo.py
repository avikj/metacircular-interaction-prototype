#!/usr/bin/env python3
"""L4 demo -- incremental consequence propagation, with exact counters.

Run:  python3 runtime/demo/propagate_demo.py

Reports, per CRYSTAL.md Sec.0 (every demo carries its numbers and its null
control):

  (a) cone size vs total graph size                     -- locality, in numbers
  (b) a consequence with an independent second proof that SURVIVES,
      and one with only the retracted proof that DIES
  (b') the same decision taken at L2, by the same homotopy quotient
  (c) exact recomputation cost vs rebuilding everything -- incrementality
  (d) NULL CONTROL: retracting a fact nothing depends on dirties nothing
  (e) object-identity check: everything outside the cone is the same object
  (f) routes: what lengthened, vanished, and (after a crystallised shortcut)
      shortened
  (g) obligations: discharged / sharper / irrelevant
  (h) what breaks first at scale, demonstrated rather than asserted

Everything is exact integer arithmetic.  No floats, no randomness, no clock:
two runs are byte-identical.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.kernel import check as C  # noqa: E402
from runtime.kernel import term as T  # noqa: E402
from runtime.kernel.egraph import EGraph, IncompleteEnumeration  # noqa: E402
from runtime.propagate import (  # noqa: E402
    DependencyGraph,
    Derivation,
    Fact,
    Obligation,
    apply,
    brute_force_dependents,
    invalidate,
    justification_classes,
    route_delta,
    route_table,
    verify_no_stale_reuse,
    verify_untouched,
)
from runtime.propagate.recompute import intact_cache_ids  # noqa: E402

SECTORS = 4
PER_SECTOR = 6


def mix(v):
    """A deterministic, exact-integer 'computation' standing in for real work."""
    acc = 1
    for k in sorted(v):
        acc = (acc * 1000003 + int(v[k])) % 999999937
    return acc


def build_library() -> DependencyGraph:
    """Four independent sectors, two theorems over them, two corollaries.

    THEOREM_A has two derivations resting on disjoint sectors: an independent
    second proof.  THEOREM_B has one.  ISOLATED is a primitive nothing uses.
    """
    g = DependencyGraph()
    for s in range(SECTORS):
        for i in range(PER_SECTOR):
            n = s * PER_SECTOR + i
            g.add_fact(Fact("P%02d" % n, "primitive %d" % n, value=n * 7 + 1))
    g.add_fact(Fact("ISOLATED", "a true fact nothing uses", value=42))

    for s in range(SECTORS):
        for j in range(3):
            g.add_fact(Fact("S%d_%d" % (s, j), "sector %d block %d" % (s, j)))
        g.add_fact(Fact("S%d_top" % s, "sector %d summary" % s))
    for s in range(SECTORS):
        for j in range(3):
            a = "P%02d" % (s * PER_SECTOR + 2 * j)
            b = "P%02d" % (s * PER_SECTOR + 2 * j + 1)
            g.add_derivation(Derivation("d.S%d_%d" % (s, j), "S%d_%d" % (s, j),
                                        (a, b), 11 + j, "block", mix))
        g.add_derivation(Derivation("d.S%d_top" % s, "S%d_top" % s,
                                    tuple("S%d_%d" % (s, j) for j in range(3)),
                                    17, "summary", mix))

    g.add_fact(Fact("THEOREM_A", "the theorem with two independent proofs"))
    g.add_fact(Fact("THEOREM_B", "the theorem with one proof"))
    g.add_fact(Fact("COROLLARY", "downstream of THEOREM_A"))
    g.add_fact(Fact("REPORT", "downstream of THEOREM_B"))
    g.add_derivation(Derivation("d.A.route1", "THEOREM_A",
                                ("S0_top", "S1_top"), 23, "route1", mix))
    g.add_derivation(Derivation("d.A.route2", "THEOREM_A",
                                ("S2_top", "S3_top"), 29, "route2", mix))
    g.add_derivation(Derivation("d.B", "THEOREM_B", ("S0_top",), 19, "only", mix))
    g.add_derivation(Derivation("d.cor", "COROLLARY", ("THEOREM_A",), 13, "cor", mix))
    g.add_derivation(Derivation("d.rep", "REPORT", ("THEOREM_B",), 13, "rep", mix))
    return g


OBLIGATIONS = (
    Obligation("O1", "THEOREM_A", frozenset({"P00", "P01"}),
               "sharpen the sector-0 blocks THEOREM_A leans on"),
    Obligation("O2", "REPORT", frozenset({"P02"}),
               "check the REPORT's sector-0 input"),
    Obligation("O3", "COROLLARY", frozenset({"P12", "P13"}),
               "sector-2 inputs under the corollary"),
)


def rule(title: str) -> str:
    return "\n" + title + "\n" + "-" * len(title)


def main() -> int:
    out = []
    P = out.append

    g = build_library()
    full0 = g.build()
    P("L4 -- incremental consequence propagation")
    P("=" * 72)
    P("library: %d facts, %d derivations, full build cost %d exact steps"
      % (len(g.facts()), len(g.derivations()), full0))

    # ---------------------------------------------------------------- (a)
    P(rule("(a) the exact dependency cone -- locality in numbers"))
    cone = g.forward_cone("P00")
    P("  " + cone.render())
    P("  cone facts: %s" % ", ".join(cone.facts))
    P("  cone/total = %d/%d facts (%d%%), %d/%d derivations (%d%%)"
      % (cone.size, cone.total_facts, cone.size * 100 // cone.total_facts,
         len(cone.derivations), cone.total_derivations,
         len(cone.derivations) * 100 // cone.total_derivations))
    oracle = brute_force_dependents(g, "P00")
    P("  cross-check against a full reread of the library: %s (%d facts)"
      % ("EXACT MATCH" if oracle == frozenset(cone.facts) else "MISMATCH",
         len(oracle)))
    P("  index lookups spent: %d.  Facts never looked at: %d."
      % (cone.steps, cone.total_facts - cone.size))

    # ---------------------------------------------------------------- (b)
    P(rule("(b) survival: two independent proofs vs one"))
    plan = invalidate(g, "P00", OBLIGATIONS)
    for fid in cone.facts:
        P("  " + plan.survivals[fid].render())
    P("")
    P("  THEOREM_A SURVIVES: %d of its %d homotopy classes avoid P00 entirely."
      % (len(plan.survivals["THEOREM_A"].surviving),
         len(plan.survivals["THEOREM_A"].surviving)
         + len(plan.survivals["THEOREM_A"].killed)))
    P("  THEOREM_B DIES: every one of its %d classes runs through P00."
      % len(plan.survivals["THEOREM_B"].killed))
    P("  survive=%s" % (", ".join(plan.survives) or "-"))
    P("  die    =%s" % (", ".join(plan.dies) or "-"))

    # --------------------------------------------------------------- (b')
    P(rule("(b') the same decision, taken at L2 by the same quotient"))
    N = T.base_sort("N")
    a, b = T.Const("pa", N), T.Const("pb", N)
    eg = EGraph()
    eg.add(a)
    eg.add(b)
    eg.merge(a, b, C.Axiom("ax:route1"), edge_id="E1")
    eg.merge(a, b, C.Axiom("ax:route2"), edge_id="E2")
    before = eg.explanation_classes(a, b)
    P("  a=b by two independent axioms : %s -> %d classes %s"
      % (before.render(), len(before), [c.render() for c in before.classes]))
    eg.retract("E1")
    after = eg.explanation_classes(a, b)
    P("  after retracting E1           : %d classes %s  => equality SURVIVES"
      % (len(after), [c.render() for c in after.classes]))
    eg.retract("E2")
    gone = eg.explanation_classes(a, b)
    P("  after retracting E2 as well   : %d classes => equality DIES" % len(gone))

    # the reassociation case: two raw paths, one class
    idN = T.Lam(N, T.Var(0, N))
    t1, t2 = T.App(idN, a), T.App(idN, b)
    eg2 = EGraph()
    eg2.add(t1)
    eg2.add(t2)
    eg2.merge(a, b, C.Axiom("ax:route1"), edge_id="X1")
    eg2.merge(t1, a, C.Beta(), edge_id="X2")
    eg2.merge(t2, b, C.Beta(), edge_id="X3")
    sq = eg2.explanation_classes(t1, t2)
    P("  (id a)=(id b): beta-then-axiom vs congruence -- %d raw paths, %d class %s"
      % (sq.raw_paths, len(sq), [c.render() for c in sq.classes]))
    P("  the naturality square of beta against congruence is ONE proof, and the")
    P("  L4 survival rule inherits exactly that: reassociation is not a second reason.")

    # ---------------------------------------------------------------- (c)
    P(rule("(c) incremental recomputation cost vs rebuilding everything"))
    snapshot = g.cache_snapshot()
    intact = intact_cache_ids(g, plan)
    P("  caches: %d stale (survive, value garbage), %d dead, %d intact"
      % (len(plan.stale_caches), len(plan.dead_caches), len(intact)))
    P("  stale : %s" % (", ".join(plan.stale_caches) or "-"))
    P("  dead  : %s" % (", ".join(plan.dead_caches) or "-"))
    rep = apply(g, plan)
    P("  " + rep.render())
    P("  re-executed: %s" % (", ".join(rep.recomputed) or "-"))
    P("  incremental %d vs full rebuild %d exact steps -- saved %d (%d%% of the"
      " rebuild avoided)" % (rep.cost, rep.full_cost, rep.saved,
                             rep.saved * 100 // rep.full_cost))

    # ---------------------------------------------------------------- (e)
    P(rule("(e) locality verified by object identity, not by equal values"))
    ok, bad = verify_untouched(snapshot, g, intact)
    P("  %d cache entries outside the cone: %s"
      % (len(intact),
         "ALL `is`-identical" if ok else "CHANGED: %s" % (bad,)))
    ok2, bad2 = verify_no_stale_reuse(g, plan, snapshot)
    P("  every stale cache was genuinely replaced (not reused): %s"
      % ("yes" if ok2 else "NO -- %s" % (bad2,)))

    # ---------------------------------------------------------------- (f)
    P(rule("(f) routes: lengthened, vanished, and then shortened"))
    g2 = build_library()
    g2.build()
    routes_before = route_table(g2, ("THEOREM_A", "THEOREM_B", "COROLLARY", "REPORT"))
    plan2 = invalidate(g2, "P00", OBLIGATIONS)
    apply(g2, plan2)
    routes_after = route_table(g2, ("THEOREM_A", "THEOREM_B", "COROLLARY", "REPORT"))
    for d in route_delta(routes_before, routes_after):
        P("  " + d.render())
    g2.add_derivation(Derivation("d.A.lemma", "THEOREM_A", ("S2_top",), 5,
                                 "crystallised shortcut", mix))
    routes_lemma = route_table(g2, ("THEOREM_A", "COROLLARY"))
    P("  after installing a crystallised shortcut lemma (CRYSTAL Sec.3.1):")
    for d in route_delta(routes_after, routes_lemma):
        P("  " + d.render())

    # ---------------------------------------------------------------- (g)
    P(rule("(g) open obligations: discharged / sharper / irrelevant"))
    for v in plan.obligations:
        P("  " + v.render())

    # ---------------------------------------------------------------- (d)
    P(rule("(d) NULL CONTROL -- retract a fact nothing depends on"))
    g3 = build_library()
    g3.build()
    snap3 = g3.cache_snapshot()
    null_plan = invalidate(g3, "ISOLATED", OBLIGATIONS)
    null_rep = apply(g3, null_plan)
    spent = null_plan.steps + null_rep.steps
    P("  " + null_plan.cone.render())
    P("  " + null_plan.render())
    P("  " + null_rep.render())
    ok3, bad3 = verify_untouched(snap3, g3, intact_cache_ids(g3, null_plan))
    P("  every OTHER cache entry in the graph (%d of %d) is `is`-identical: %s"
      % (len(g3.facts()) - 1, len(g3.facts()),
         "yes" if ok3 else "NO -- %s" % (bad3,)))
    P("  total L4 steps for the null retraction: %d (vs %d for P00) -- O(1),"
      " and not one derivation re-executed (cost %d)."
      % (spent, plan.steps + rep.steps, null_rep.cost))
    P("  A runtime that dirtied something here would be measuring its own cache.")

    # ---------------------------------------------------------------- (h)
    P(rule("(h) what breaks first at scale -- demonstrated, not asserted"))
    dense = EGraph()
    chain = [T.Const("q%d" % i, N) for i in range(7)]
    for t in chain:
        dense.add(t)
    k = 0
    for i in range(len(chain) - 1):
        for r in range(3):            # three parallel axioms per link
            dense.merge(chain[i], chain[i + 1], C.Axiom("ax:%d:%d" % (i, r)),
                        edge_id="D%03d" % k)
            k += 1
    total = dense.explanation_classes(chain[0], chain[-1])
    P("  6 links x 3 parallel axioms: %s" % total.render())
    P("  3^6 = %d genuinely distinct classes -- exponential in the graph, and"
      " correctly so: they are different transports." % (3 ** 6))
    tight = dense.explanation_classes(chain[0], chain[-1], max_paths=100)
    P("  same query with max_paths=100: %s" % tight.render())
    try:
        len(tight)
        P("  len() on the incomplete result: RETURNED A NUMBER -- BUG")
    except IncompleteEnumeration as exc:
        P("  len() on the incomplete result raises IncompleteEnumeration:")
        P("    %s" % str(exc).split(".  Call")[0])
    P("  partial() still hands over what was found, but the caller has to say so:"
      " %d classes." % len(tight.partial()))
    P("  This is the failure mode that used to be a silent subset.  It is now a")
    P("  type error at the call site.  What still breaks at scale is the *cost*")
    P("  of completeness, not the honesty of the answer.")

    # ---------------------------------------------------------------- counters
    P(rule("exact counters"))
    P("  propagate : %s" % g.report())
    P("  egraph    : %s" % eg.report())
    P("  term      : %s" % T.COUNTERS.render())

    print("\n".join(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())

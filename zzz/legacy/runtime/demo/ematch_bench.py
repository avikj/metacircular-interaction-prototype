#!/usr/bin/env python3
"""E-matching: the compiled automaton against the memoised recursive matcher.

`runtime/SCALE.md` §4 reports these numbers; this is the script that produces
them, so the claim is reproducible rather than remembered.

The workload is an **AC-saturated** e-graph: associativity and commutativity of
a product of ``k`` atoms, run to a fixpoint.  AC merges structurally *different*
nodes into one class, so a class carries many distinct child-class signatures
and a multi-variable pattern really does branch at every level.  That is the
regime where "e-matching is exponential in pattern size" bites; the demo's own
graph is far narrower.

Both engines are run against **the same e-graph object**, so the comparison is
exact and not a comparison of two builds.  Both must return the same matches in
the same order; the script fails if they do not.

Usage:  python3 runtime/demo/ematch_bench.py [k]      (default k=5; k=6 is ~30s)
"""

from __future__ import annotations

import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.execute import ematch as _ematch_fn                      # noqa: E402,F401
import runtime.execute.ematch as EM                                    # noqa: E402
from runtime.execute.ematch import COUNTERS, EMatchBudget              # noqa: E402
from runtime.execute.rewrite import rule_from_axiom                    # noqa: E402
from runtime.execute.saturate import Budget, saturate                  # noqa: E402
from runtime.kernel import check as C                                  # noqa: E402
from runtime.kernel import term as T                                   # noqa: E402
from runtime.kernel.egraph import EGraph                               # noqa: E402

# ``runtime.execute`` re-exports the *function* ``ematch`` under the package
# attribute of the same name, so reach the module through sys.modules.
EM = sys.modules["runtime.execute.ematch"]

Z = T.base_sort("Z")
ZZ = T.arrow(Z, Z)
ZZZ = T.arrow(Z, ZZ)
MUL = T.Const("mul", ZZZ)


def mul(a, b):
    return T.App(T.App(MUL, a), b)


VA, VB, VC, VU, VV, VW = (T.Const(s, Z) for s in
                          ("?a", "?b", "?c", "?u", "?v", "?w"))

PATTERNS = [
    ("Q1 mul(mul(a,b),c)                   3 vars",
     mul(mul(VA, VB), VC), {"?a", "?b", "?c"}),
    ("Q2 mul(mul(a,b),mul(c,u))            4 vars",
     mul(mul(VA, VB), mul(VC, VU)), {"?a", "?b", "?c", "?u"}),
    ("Q3 mul(mul(mul(a,b),c),u)            4 vars",
     mul(mul(mul(VA, VB), VC), VU), {"?a", "?b", "?c", "?u"}),
    ("Q4 mul(mul(a,b),mul(b,a))            2 rep",
     mul(mul(VA, VB), mul(VB, VA)), {"?a", "?b"}),
    ("Q5 mul(mul(mul(a,b),c),mul(a,b))     3 rep",
     mul(mul(mul(VA, VB), VC), mul(VA, VB)), {"?a", "?b", "?c"}),
    ("Q6 mul(mul(mul(a,b),mul(c,u)),mul(v,w)) 6 vars",
     mul(mul(mul(VA, VB), mul(VC, VU)), mul(VV, VW)),
     {"?a", "?b", "?c", "?u", "?v", "?w"}),
]


def build(k: int):
    ctx = C.CheckContext()
    ctx.declare_axiom("assoc", mul(mul(VA, VB), VC), mul(VA, mul(VB, VC)))
    ctx.declare_axiom("comm", mul(VA, VB), mul(VB, VA))
    rules = [rule_from_axiom(ctx, "assoc", ("?a", "?b", "?c")),
             rule_from_axiom(ctx, "comm", ("?a", "?b"))]
    t = T.Const("a0", Z)
    for i in range(1, k):
        t = mul(t, T.Const("a%d" % i, Z))
    g = EGraph()
    g.add(t)
    t0 = time.time()
    sat = saturate(g, rules, ctx,
                   Budget(max_iterations=8,
                          ematch=EMatchBudget(max_visits=50000000)), tag="ac")
    return g, sat, time.time() - t0


def run(g, pat, variables, engine):
    v0 = COUNTERS.get("ematch.visit")
    h0 = COUNTERS.get("ematch.memo_hit") + COUNTERS.get("ematch.entry_hit")
    t0 = time.time()
    res = EM.ematch(g, pat, variables, engine=engine)
    dt = time.time() - t0
    return (res, COUNTERS.get("ematch.visit") - v0,
            COUNTERS.get("ematch.memo_hit") + COUNTERS.get("ematch.entry_hit") - h0,
            dt)


def main() -> int:
    k = int(sys.argv[1]) if len(sys.argv) > 1 else 5
    g, sat, dt = build(k)
    print("AC-saturated product of %d atoms" % k)
    print("  %s" % sat.render())
    print("  e-graph: %d terms, %d classes, widest class %d  (%.0f ms)"
          % (len(g.terms()), len(g.classes()),
             max(len(c) for c in g.classes()), dt * 1000))
    print("  graph built once, under the default engine (%s); both engines are"
          % EM.DEFAULT_ENGINE)
    print("  then queried against that same object.\n")
    print("  %-44s %8s | %9s %9s %9s | %9s %9s %9s"
          % ("pattern", "matches", "rec vis", "rec hits", "rec ms",
             "aut vis", "aut hits", "aut ms"))
    print("  " + "-" * 118)
    bad = 0
    tot = [0, 0, 0.0, 0, 0, 0.0]
    for label, pat, vs in PATTERNS:
        r_res, r_v, r_h, r_t = run(g, pat, vs, "recursive")
        a_res, a_v, a_h, a_t = run(g, pat, vs, "automaton")
        same = ([m.key() for m in r_res.matches] == [m.key() for m in a_res.matches])
        if not same or not (r_res.complete and a_res.complete):
            bad += 1
        print("  %-44s %8d | %9d %9d %9.1f | %9d %9d %9.1f%s"
              % (label, len(a_res.matches), r_v, r_h, r_t * 1000,
                 a_v, a_h, a_t * 1000, "" if same else "   ENGINES DISAGREE"))
        tot[0] += r_v; tot[1] += r_h; tot[2] += r_t
        tot[3] += a_v; tot[4] += a_h; tot[5] += a_t
    print("  " + "-" * 118)
    print("  %-44s %8s | %9d %9d %9.1f | %9d %9d %9.1f"
          % ("TOTAL", "", tot[0], tot[1], tot[2] * 1000,
             tot[3], tot[4], tot[5] * 1000))
    print("\n  total lookups (visits + cache hits): recursive %d, automaton %d"
          % (tot[0] + tot[1], tot[3] + tot[4]))
    print("  NOTE: 'visits' is a per-engine budget unit, not a cross-engine")
    print("  metric -- the recursive matcher charges nothing for a memo hit and")
    print("  the automaton nothing for an entry-cache hit.  Compare the total")
    print("  lookup column, or the wall clock.  See runtime/SCALE.md sec 4.4.")
    if bad:
        print("\n  FAILURE: %d pattern(s) on which the engines disagree." % bad)
        return 1
    print("\n  the two engines returned identical matches, in identical order,")
    print("  on every pattern.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

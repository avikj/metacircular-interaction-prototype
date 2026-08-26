#!/usr/bin/env python3
"""The atlas of N, executed: six charts, seven transitions, every residual computed.

    python3 runtime/demo/atlas_demo.py

Prints, with exact counters and no floats:

  1. the six charts with their CRYSTAL.md Sec.4 declarations, each field checked
  2. every transition installed as a typed kernel edge of the verified kind
  3. every residual as a computed object -- S_n with its order and Cayley digest,
     the two torsors with their freeness reports, the carry cocycle with its
     coboundary search, the Sym(P) obstruction with its witness
  4. the contractibility check for (a)<->(b), with an explicit statement of what
     a finite check does and does not establish about the infinite claim
  5. the two incomparable completions, with the four operation verdicts and the
     two-sided no-continuous-map witness
  6. PLANTED-FALSE CONTROLS: four falsehoods the installer must refuse
  7. a NULL CONTROL: a true but irrelevant transition changes no verdict

Output is byte-identical across runs and across PYTHONHASHSEED.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from runtime.atlas import charts as CH  # noqa: E402
from runtime.atlas import residual as R  # noqa: E402
from runtime.atlas import transitions as X  # noqa: E402
from runtime.kernel import check as C  # noqa: E402
from runtime.kernel.egraph import EGraph  # noqa: E402
from runtime.kernel.term import Counters  # noqa: E402

RULE = "=" * 78


# ---------------------------------------------------------------------------
# planted falsehoods -- shared with runtime/tests/test_atlas.py
# ---------------------------------------------------------------------------

def planted_not_a_bijection() -> X.Transition:
    """An `Iso` claimed for ``n |-> n // 2``, which is not injective."""
    return X.Transition(
        key="PLANT/halve", src="peano", dst="peano", kind="Iso",
        range_note="n in [0,12]",
        domain=lambda: [X.PEANO.datum(n) for n in range(13)],
        codomain=lambda: [X.PEANO.datum(n) for n in range(13)],
        forward=lambda p: X.PEANO.datum(X.PEANO.value(p) // 2),
        residuals=(),
        note="planted: a claimed bijection that is not one",
        term_pairs=lambda: [(X.PEANO.term(n), X.PEANO.term(n // 2)) for n in range(9)],
    )


def planted_embedding_as_iso() -> X.Transition:
    """An `Iso` claimed for ``n |-> 2n``: well defined and injective into [0,24],
    and *not* surjective.  Exactly "an Iso installed for an embedding"."""
    return X.Transition(
        key="PLANT/double", src="peano", dst="peano", kind="Iso",
        range_note="n in [0,12] -> [0,24]",
        domain=lambda: [X.PEANO.datum(n) for n in range(13)],
        codomain=lambda: [X.PEANO.datum(n) for n in range(25)],
        forward=lambda p: X.PEANO.datum(2 * X.PEANO.value(p)),
        residuals=(),
        note="planted: an Iso installed for a map that is only an embedding",
        term_pairs=lambda: [(X.PEANO.term(n), X.PEANO.term(2 * n)) for n in range(9)],
    )


def honest_embedding() -> X.Transition:
    """The same map, declared honestly as an `Embed`.  This one must install."""
    t = planted_embedding_as_iso()
    return X.Transition(
        key="a>->a", src=t.src, dst=t.dst, kind="Embed", range_note=t.range_note,
        domain=t.domain, codomain=t.codomain, forward=t.forward,
        residuals=(R.Residual("image 2N", R.INVARIANT, (("index of 2N in N", 2),), False,
                              "the residual of the doubling embedding is its index",
                              trivial_test=lambda pairs: pairs[0][1] == 1),),
        note="doubling, declared as what it is",
        term_pairs=lambda: [], certificate_name="cert:atlas/double")


def planted_trivial_residual() -> X.Transition:
    """The true pi_0 map, but with S_3 declared trivial."""
    real = X.transition("c->a")
    lying = R.Residual("S_3 (claimed trivial)", R.GROUP, R.symmetric_group(3), True,
                       "planted: decategorification claimed to lose nothing at n=3")
    return X.Transition(
        key="PLANT/pi0", src=real.src, dst=real.dst, kind=real.kind,
        range_note=real.range_note, domain=real.domain, codomain=real.codomain,
        forward=real.forward, residuals=(lying,), note="planted: false trivial residual",
        term_pairs=real.term_pairs, certificate_name="cert:atlas/plant-pi0")


PLANTED_COMPLETION_CLAIMS = (
    CH.CompletionClaim("R", "enumeration successor", True),
    CH.CompletionClaim("Z_b", "order relation <", True),
)


def planted_completion_verdicts(counters: Counters):
    """Two charts claiming an operation extends to a completion when it does not."""
    R_win, Z_win = CH.ArchimedeanWindow(), CH.BAdicWindow(b=10)
    holds_r, wit_r = R_win.enumeration_successor_extends(counters)
    holds_z, wit_z = Z_win.order_extends(counters)
    return (
        CH.ClaimVerdict(PLANTED_COMPLETION_CLAIMS[0], holds_r, wit_r,
                        "jump at every natural: %s" % (wit_r,)),
        CH.ClaimVerdict(PLANTED_COMPLETION_CLAIMS[1], holds_z, wit_z,
                        "order flip at the same gauge: %s" % (wit_z,)),
    )


def planted_iso_edge(ctx: C.CheckContext) -> bool:
    """A kernel `Iso` between two *different* numbers.  The kernel must refuse."""
    from runtime.kernel import edges as E
    a, b = X.PEANO.term(3), X.PEANO.term(4)
    e = E.Edge("Iso", a.addr, b.addr, witness=C.IsoWitness(CH.ID_CH, CH.ID_CH))
    return C.check_edge(e, ctx)


# ---------------------------------------------------------------------------
# report
# ---------------------------------------------------------------------------

def main() -> int:
    counters = Counters()
    ctx = C.CheckContext(fuel=400000)
    graph = EGraph()

    print(RULE)
    print("THE ATLAS OF N, EXECUTED   (notes/ATLAS_OF_N.md -> runtime/atlas)")
    print(RULE)

    print("\n1. THE SIX CHARTS  (CRYSTAL.md Sec.4 -- every field declared and checked)\n")
    for ch in (X.PEANO, X.TALLY, X.CARD, X.ORD, X.DIG10, X.PRIME):
        print(ch.render())
        print(ch.reachability().render())
        bound = 3 if isinstance(ch, CH.DigitChart) else 6
        print("  CHECK  " + ch.reachability_report(bound, counters).render())
        print()

    print(RULE)
    print("\n2. THE TRANSITIONS  (typed kernel edges; kind verified against the map)\n")
    installs = []
    for t in X.TRANSITIONS:
        rep = t.install(graph, ctx, counters)
        installs.append(rep)
        print("  " + t.render())
        print("    " + rep.bijection.render())
        print("    " + rep.render().replace("\n", "\n    "))
        print("    " + rep.trust_note())
        print()

    print(RULE)
    print("\n3. THE RESIDUALS  (computed objects, not labels)\n")
    for rep in installs:
        for rr in rep.residuals:
            print("  " + rr.render())
    print()
    print("  S_n as an actual group, with orbits of the natural action:")
    for n in range(1, 6):
        g = R.symmetric_group(n)
        grep = g.verify(counters)
        orbits = g.orbits(tuple(range(n)), lambda s, i: s[i], counters)
        print("    %-5s order=%-4d cayley=%s  orbits of [n]: %d  %s"
              % (g.name, g.order, g.digest(), len(orbits), grep.render().split(" ", 1)[1]))
    print()
    print("  the S_n-torsor of linear orders (ATLAS_OF_N Thm 2.5 / Thm 3.2):")
    for n in range(2, 5):
        tor = X.ORD.order_torsor(n)
        trep = tor.verify(counters)
        pairs, lo, hi = X.ORD.contractibility_check(n, counters)
        print("    n=%d  %s" % (n, trep.render()))
        print("         %d ordered pairs of orders, order-isos between them: min=%d max=%d"
              " -> the total space is contractible at this level" % (pairs, lo, hi))
    print()
    print("  the endian Z/2 and the exact defect fraction (DIGIT_CRYSTAL Thm 4.2):")
    for b in (2, 10):
        d = CH.DigitChart(b, "little")
        for n in (1, 2):
            agree, total, defect = d.endian_agreement(n, counters)
            print("    b=%-2d n=%d  pi_n = sigma_n on %d of %d words (the %d constant "
                  "strings); defect fraction exactly %s = 1 - b^-%d"
                  % (b, n, agree, total, b, defect, n))
        print("    b=%-2d reversal conjugates pi into sigma on every word: %s"
              % (b, d.reversal_conjugates(2, counters)))
    print()
    print("  the carry class (ATLAS_OF_N Prop. 2.11, Cor. 2.11.1):")
    for b, n in ((2, 1), (2, 2), (3, 1), (10, 1)):
        rep = R.carry_cocycle(b, n).verify(counters)
        print("    " + rep.render())
    print()
    print("  the multiplicative chart cannot see addition (Thm 2.13):")
    holds, wit = X.PRIME.successor_not_definable(counters=counters)
    print("    no-parameter witness   : %s" % (wit,))
    holds2, wit2 = X.PRIME.successor_not_definable(params=(2, 3, 5, 7, 11), counters=counters)
    print("    5 primes as parameters : %s" % (wit2,))
    a, b, ma, mb = X.PRIME.invariant_collision(counters)
    print("    complete invariant     : %d and %d have the same exponent multiset (1,), "
          "but succ(%d) has multiset %s and succ(%d) has %s -- so no function of the "
          "invariant computes succ" % (a, b, a, ma, b, mb))

    print()
    print(RULE)
    print("\n4. CONTRACTIBILITY OF THE (a)<->(b) COMPARISON\n")
    con = X.contractibility_report(5, counters)
    print("  " + con.render())
    print("  PLUS_T and CONCAT_T are the same L0 address: %s  (%s)"
          % (CH.PLUS_T is CH.CONCAT_T, CH.PLUS_T.addr))
    import textwrap
    for line in textwrap.wrap(X.CONTRACTIBILITY_SCOPE, 74):
        print("  | " + line)

    print()
    print(RULE)
    print("\n5. TWO INCOMPARABLE COMPLETIONS  (ATLAS_OF_N Sec.5.5, Thm 5.3)\n")
    verdicts, nomap = CH.two_completions_report(10, counters)
    Rw, Zw = CH.ArchimedeanWindow(), CH.BAdicWindow(b=10)
    disc, radius = Rw.discreteness_witness(counters)
    dens, depth = Zw.density_witness(counters)
    closed, esc = Zw.not_closed_witness(counters)
    print("  N in R    : closed and discrete -- separation exactly %s, no two naturals "
          "within %s: %s" % (Rw.separation(), radius, disc))
    print("              not dense: the rational %s is at distance %s from every natural"
          % Rw.density_failure())
    print("  N in Z_10 : dense -- every residue at depth <= %d is hit: %s" % (depth, dens))
    print("              not closed: %s is Cauchy with limit %s, which is not a natural: %s"
          % (esc["sequence"], esc["limit"], closed))
    print()
    for v in verdicts:
        print("  " + v.render())
    print()
    print("  no continuous map either way restricting to the identity on N:")
    print("    %-4s %-12s %-14s %s" % ("k", "b^k", "|b^k|_10", "|b^k| in R"))
    for k, x, g, arch in nomap["rows"]:
        print("    %-4d %-12d %-14s %s" % (k, x, g, arch))
    print("    Z_b -> R : %s" % nomap["obstruction_Zb_to_R"])
    print("    R -> Z_b : %s" % nomap["obstruction_R_to_Zb"])
    print("    SCOPE    : the table exhibits the sequences the proof uses; compactness")
    print("               and connectedness are NOT verified computationally here.")

    print()
    print(RULE)
    print("\n6. PLANTED-FALSE CONTROLS  (each must be REFUSED)\n")
    plants = [planted_not_a_bijection(), planted_embedding_as_iso(),
              planted_trivial_residual()]
    refusals = []
    for t in plants:
        rep = t.install(None, ctx, counters)
        refusals.append(rep.render())
        print("  " + rep.render().replace("\n", "\n  "))
    bad_edge = planted_iso_edge(ctx)
    print("  kernel Iso between peano(3) and peano(4): accepted=%s (must be False)"
          % bad_edge)
    for v in planted_completion_verdicts(counters):
        print("  " + v.render())
    print()
    print("  the machinery is not a universal rejector -- the same map declared honestly:")
    ok_rep = honest_embedding().install(None, ctx, counters)
    print("  " + ok_rep.render().replace("\n", "\n  "))

    print()
    print(RULE)
    print("\n7. NULL CONTROL  (a true but irrelevant transition changes no verdict)\n")
    before = tuple(refusals)
    spent = counters.get("atlas.map.probe")
    extra = X.Transition(
        key="NULL/b->a", src="tally", dst="peano", kind="Iso",
        range_note="n in [0,12]",
        domain=lambda: [X.TALLY.datum(n) for n in range(13)],
        codomain=lambda: [X.PEANO.datum(n) for n in range(13)],
        forward=lambda w: X.PEANO.datum(X.TALLY.value(w)),
        residuals=(R.Residual("trivial (b->a)", R.GROUP, R.trivial_group(), True,
                              "the inverse of a<->b; true, and irrelevant to the "
                              "planted falsehoods"),),
        note="a valid extra transition",
        term_pairs=lambda: [(X.TALLY.term(n), X.PEANO.term(n)) for n in range(9)])
    null_rep = extra.install(graph, ctx, counters)
    after = tuple(t.install(None, ctx, counters).render() for t in plants)
    print("  installed a genuinely true extra transition: %s" % null_rep.render())
    print("  the three refusals afterwards are bit-identical: %s" % (before == after))
    print("  cost of re-deciding them: %d exhaustive probes (it does not get cheaper "
          "or easier because an unrelated truth arrived)"
          % (counters.get("atlas.map.probe") - spent - null_rep.bijection.steps))

    print()
    print(RULE)
    print("\n8. EXACT COUNTERS\n")
    print("  atlas : %s" % counters.render())
    print("  kernel: %s" % ctx.counters.render())
    print("  egraph: %s" % graph.report())
    print("  directed kernel edges in the graph: %d"
          % graph.steps.get("directed_edges"))

    bad = [r for r in installs if not r.installed]
    print()
    print("SUMMARY charts=6 transitions=%d installed=%d machine_checked_edges=%d "
          "residuals=%d refused_plants=%d"
          % (len(installs), len(installs) - len(bad),
             sum(r.edges_checked for r in installs if r.machine_verified),
             sum(len(r.residuals) for r in installs),
             sum(1 for t in plants if not t.install(None, ctx, counters).installed)))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

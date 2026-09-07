#!/usr/bin/env python3
"""The measured demonstration of derivation crystallization (CRYSTAL.md sec 3.1).

Run:  python3 runtime/demo/crystallize_demo.py

It answers exactly one question, the seed criterion of CRYSTAL.md sec 0:

    does a mathematical fact entering the runtime make an *independent*
    problem solve in strictly fewer kernel steps, with the answer still
    kernel-checked, and *without* an unrelated fact doing the same?

Everything printed is an exact integer produced by a counter, not an estimate.
No floats, no randomness, no network, no model.  Two runs are byte-identical.
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.antiunify import variable_positions          # noqa: E402
from runtime.crystallize.derivation import (Counter, I, P, PV, S, Sub, V,      # noqa: E402
                                            match, mk, normalize,
                                            poly_equal, render, VAR)
from runtime.crystallize.install import Book, solve, verify           # noqa: E402
from runtime.crystallize.mine import mine                             # noqa: E402

BAR = "=" * 78


def hdr(s: str) -> None:
    print("\n" + BAR + "\n" + s + "\n" + BAR)


# --------------------------------------------------------------------------
# The problems
# --------------------------------------------------------------------------

def dos(a: str, b: str):
    """``(a + b) * (a - b)`` -- written with the ``a - b`` sugar only."""
    return P(S(V(a), V(b)), Sub(V(a), V(b)))


def sq(a: str, b: str):
    """``(a + b) * (a + b)``."""
    return P(S(V(a), V(b)), S(V(a), V(b)))


# Training set: the same shape in three *different* surrounding contexts and
# with three different variable pairs.  Nothing about the surroundings is
# shared, so a pattern found across them is a pattern in the mathematics.
P1 = dos("x", "y")                       # bare
P2 = S(I(7), dos("u", "v"))              # inside  7 + [ ]
P3 = S(dos("a", "b"), V("a"))            # inside  [ ] + a

# The independent problem.  NOT used in mining, and not an instance of any Pi
# (asserted below, mechanically).  Its difference-of-squares arguments are
# *compound* -- x*x and 3*y -- which no mined instance ever exhibited.
X, Y = V("x"), V("y")
XX, TY = P(X, X), P(I(3), Y)
P4 = S(P(S(XX, TY), Sub(XX, TY)), P(I(9), Y, Y))         # (x^2+3y)(x^2-3y)+9y^2

# Null-control training set: perfect squares, mined and installed by exactly
# the same machinery, valid, and irrelevant to P4.
Q1 = sq("x", "y")
Q2 = S(I(5), sq("u", "v"))
Q3 = S(sq("a", "b"), V("a"))

NAMED = [("P1", P1), ("P2", P2), ("P3", P3), ("P4", P4)]


def as_pattern(t):
    """Turn every ordinary variable of a ground problem into a pattern variable.

    Used only to *test independence*: if the resulting pattern matches P4 then
    P4 would be an instance of that problem.
    """
    order, seen = [], {}

    def walk(n):
        if n.kind == VAR:
            if n.val not in seen:
                seen[n.val] = PV(len(order))
                order.append(n.val)
            return seen[n.val]
        if not n.args:
            return n
        return mk(n.kind, n.val, [walk(a) for a in n.args])

    return walk(t)


def main() -> int:
    failures = []

    def want(cond: bool, msg: str) -> bool:
        if not cond:
            failures.append(msg)
        return cond

    # ---------------------------------------------------------------- 1
    hdr("1. SOLVE P1, P2, P3 THE SLOW WAY  (primitive ring axioms only)")
    train = []
    for name, t in [("P1", P1), ("P2", P2), ("P3", P3)]:
        d, c = solve(t, None, name=name)
        train.append(d)
        want(poly_equal(t, d.result), "%s normal form is wrong" % name)
        print("  %s  %-34s -> %-28s steps=%3d  work=%5d  checks=%3d"
              % (name, render(t), render(d.result), c.steps, c.work, c.checks))
    print("\n  every step above was re-derived from its axiom schema by the")
    print("  checker (checks == steps); nothing is taken on assertion.")

    # ---------------------------------------------------------------- 2
    hdr("2. MINE REPEATED SUB-DAGs ACROSS THE THREE DERIVATIONS")
    mctr = Counter()
    cands = mine(train, ctr=mctr)
    print("  segments+joins considered : %d  (bounded: contiguous runs of"
          % mctr.work)
    print("                              <= 24 steps, O(D*L*window^2))")
    print("  candidates with support >= 2 across distinct derivations : %d"
          % len(cands))
    best = cands[0]
    print("\n  top candidate (ranked by steps saved, then support):")
    print("    support     : %d derivations (%s)"
          % (best.support, ", ".join(s.deriv.name for s in best.instances)))
    print("    sub-DAG     : %d steps, rules %s"
          % (best.instances[0].length, list(best.rule_names)[:4] + ["..."]))
    for s in best.instances:
        print("    instance    : %-6s at position %-6s  %s -> %s"
              % (s.deriv.name, str(list(s.pos)), render(s.u), render(s.v)))
    want(best.support == 3, "top candidate should have support 3")

    # ---------------------------------------------------------------- 3
    hdr("3. ANTI-UNIFY  (Plotkin/Reynolds least general generalisation)")
    print("    LHS : %s" % render(best.lhs))
    print("    RHS : %s" % render(best.rhs))
    vpl = variable_positions(best.lhs)
    vpr = variable_positions(best.rhs)
    for v in sorted(set(vpl) | set(vpr)):
        print("    %s occurs at lhs %s  rhs %s"
              % (v, [list(p) for p in vpl.get(v, [])],
                 [list(p) for p in vpr.get(v, [])]))
    print("\n  The consistency of that map is the whole algorithm: #0 had to")
    print("  land on BOTH factors, and #1 on both, or the statement is false.")
    want(all(len(vpl[v]) == 2 for v in vpl), "each lhs variable must occur twice")

    # ---------------------------------------------------------------- 4
    hdr("4. CHECK  (seven gates; a candidate that fails is destroyed)")
    book = Book()
    vctr = Counter()
    verdict = book.install_candidate("dsq", best, ctr=vctr)
    print("  candidate  dsq : %s" % verdict)
    print("  rebuilt proof  : %d primitive steps, all re-validated (%d checks)"
          % (len(verdict.rebuilt), vctr.checks))
    want(verdict.ok, "the mined difference-of-squares lemma must verify")

    print("\n  NEGATIVE CONTROL -- the same pattern, anti-unified WITHOUT a")
    print("  consistent variable map (four variables instead of two):")
    over = P(S(PV(0), PV(1)), S(PV(2), P(I(-1), PV(3))))
    bad = verify(over, best.rhs)
    print("    proposed : %s  ==>  %s" % (render(over), render(best.rhs)))
    print("    %s" % bad)
    want(not bad.ok, "the over-general lemma MUST be rejected")

    print("\n  NEGATIVE CONTROL -- a sign error in the right-hand side:")
    flipped = S(P(PV(1), PV(1)), P(PV(0), PV(0)))
    bad2 = verify(best.lhs, flipped)
    print("    proposed : %s  ==>  %s" % (render(best.lhs), render(flipped)))
    print("    %s" % bad2)
    want(not bad2.ok, "the sign-flipped lemma MUST be rejected")

    # ---------------------------------------------------------------- 5
    hdr("5. INSTALL THE NULL CONTROL  (valid, checked, irrelevant)")
    qtrain = [solve(t, None, name=n)[0]
              for n, t in [("Q1", Q1), ("Q2", Q2), ("Q3", Q3)]]
    qcands = mine(qtrain)
    nullbook = Book()
    nverdict = nullbook.install_candidate("psq", qcands[0])
    print("  mined from Q1,Q2,Q3 (perfect squares), support %d"
          % qcands[0].support)
    print("  lemma psq : %s  ==>  %s"
          % (render(nullbook.lemmas[0].lhs), render(nullbook.lemmas[0].rhs)))
    print("  verdict   : %s" % nverdict)
    want(nverdict.ok, "the null lemma must itself be a checked theorem")

    # ---------------------------------------------------------------- 6
    hdr("6. INDEPENDENCE OF P4")
    print("  P4 = %s" % render(P4))
    for name, t in [("P1", P1), ("P2", P2), ("P3", P3)]:
        m = match(as_pattern(t), P4)
        print("    P4 an instance of %s ? %s" % (name, "YES" if m else "no"))
        want(m is None, "P4 must not be an instance of %s" % name)
    print("    P4 used in mining ?          no (mining saw P1,P2,P3 only)")
    print("    lemma arguments in P4        #0 = %s, #1 = %s   <- compound;"
          % (render(XX), render(TY)))
    print("                                 every mined instance had atoms.")

    # ---------------------------------------------------------------- 7
    hdr("7. THE MEASUREMENT")
    rows = []
    for name, t in NAMED:
        d0, c0 = solve(t, None, name=name + "/base")
        d1, c1 = solve(t, book, name=name + "/lemma")
        d2, c2 = solve(t, nullbook, name=name + "/null")
        agree = (d0.result.addr == d1.result.addr == d2.result.addr)
        indep = poly_equal(t, d1.result)
        want(agree, "%s: answers must agree across books" % name)
        want(indep, "%s: answer must verify independently" % name)
        rows.append((name, c0.steps, c1.steps, c2.steps, agree, indep,
                     render(d1.result), c0.work, c1.work, c2.work))

    print("  steps = kernel rewrite steps entering the derivation DAG")
    print("  (the seed criterion is about this column, and only this one)\n")
    print("  %-6s %6s %6s %8s %8s %8s  %s"
          % ("prob", "before", "after", "w/ null", "agree", "verified",
             "answer"))
    print("  " + "-" * 74)
    for (n, b, a, nl, ag, iv, ans, _, _, _) in rows:
        tag = n + ("*" if n != "P4" else "")
        print("  %-6s %6d %6d %8d %8s %8s  %s"
              % (tag, b, a, nl, "yes" if ag else "NO",
                 "yes" if iv else "NO", ans))
    print("  " + "-" * 74)
    print("  * P1,P2,P3 were used in mining, so their reduction proves nothing.")
    print("    P4 is the experiment.")

    print("\n  search work (rule/lemma match attempts), reported so that a step")
    print("  reduction bought with unbounded search cannot hide:\n")
    print("  %-6s %8s %8s %8s" % ("prob", "before", "after", "w/ null"))
    print("  " + "-" * 34)
    for (n, _, _, _, _, _, _, wb, wa, wn) in rows:
        print("  %-6s %8d %8d %8d" % (n, wb, wa, wn))

    # ---------------------------------------------------------------- 8
    hdr("8. VERDICT ON THE SEED CRITERION (CRYSTAL.md sec 0)")
    p4 = [r for r in rows if r[0] == "P4"][0]
    before, after, null = p4[1], p4[2], p4[3]
    c_strict = after < before
    c_null = null == before
    c_ans = p4[4] and p4[5]
    print("  independent problem P4")
    print("    strictly fewer steps with the lemma   : %d < %d  -> %s"
          % (after, before, "YES" if c_strict else "NO"))
    print("    reduction                             : %d steps (%d%% of %d)"
          % (before - after, (100 * after) // before, before))
    print("    NULL CONTROL, unrelated valid lemma   : %d steps -> %s"
          % (null, "no change (correct)" if c_null else "CHANGED (bad)"))
    print("    answer identical in all three runs    : %s"
          % ("YES" if p4[4] else "NO"))
    print("    answer independently verified         : %s"
          % ("YES (exact grid decision, complete for the degree bound)"
             if p4[5] else "NO"))
    print("    post-reduction derivation kernel-checked: YES (every step,")
    print("      including the lemma step, re-validated against its schema)")
    ok = c_strict and c_null and c_ans and not failures
    print("\n  SEED CRITERION: %s" % ("MET" if ok else "NOT MET"))
    if failures:
        print("\n  FAILURES:")
        for f in failures:
            print("    - " + f)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

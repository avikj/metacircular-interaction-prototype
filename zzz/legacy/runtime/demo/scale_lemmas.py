#!/usr/bin/env python3
"""Does the crystallisation result survive a large lemma book?

`runtime/crystallize/README.md` §6.1 makes a prediction and this script tests it:

    Lemma matching is a linear scan over positions x book ... At a few hundred
    lemmas the search cost overtakes the step savings and the headline number
    becomes a lie told with a true counter.

The experiment.  Take the demo's independent problem P4, whose seed-criterion
number is 29 steps -> 12 steps with one mined lemma.  Grow the book with
mechanically generated lemmas -- each one *installed through the same seven
gates*, so every lemma in the book is a checked theorem, not a decoration --
and measure P4's step count and its search work at each size.

Two books are grown, because the honest question has two halves:

    "useful"  the mined difference-of-squares lemma **plus** N-1 generated ones
    "null"    N generated ones and no mined lemma at all

The step column of the null book is the control: if it ever moves, a generated
lemma is firing on P4 and the experiment is contaminated.

Everything printed is an exact integer from a counter.  Wall clock is printed
separately and is not used for any claim.

Usage:  python3 runtime/demo/scale_lemmas.py [--sizes 1,10,50,...] [--index]
        --index  additionally measure the discrimination-net lemma lookup
"""

from __future__ import annotations

import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))))

from runtime.crystallize.derivation import (Counter, I, LemmaIndex, P, PV,  # noqa: E402
                                            S, Sub, V, normalize, poly_equal,
                                            pvars_of, render, subst)
from runtime.crystallize.install import GROUND_PREFIX, Book, ground, solve  # noqa: E402
from runtime.crystallize.mine import mine                                  # noqa: E402

BAR = "=" * 78


def hdr(s: str) -> None:
    print("\n" + BAR + "\n" + s + "\n" + BAR)


# --------------------------------------------------------------------------
# the demo's problems, imported by value so this script is self-contained
# --------------------------------------------------------------------------

def dos(a: str, b: str):
    return P(S(V(a), V(b)), Sub(V(a), V(b)))


P1 = dos("x", "y")
P2 = S(I(7), dos("u", "v"))
P3 = S(dos("a", "b"), V("a"))

X, Y = V("x"), V("y")
XX, TY = P(X, X), P(I(3), Y)
P4 = S(P(S(XX, TY), Sub(XX, TY)), P(I(9), Y, Y))


def mined_lemma():
    """The difference-of-squares lemma, mined exactly as the demo mines it."""
    train = [solve(t, None, name=n)[0]
             for n, t in [("P1", P1), ("P2", P2), ("P3", P3)]]
    return mine(train)[0]


# --------------------------------------------------------------------------
# mechanically generated lemmas: valid by construction, checked by the gates
# --------------------------------------------------------------------------
#
# Every generated left-hand side uses an integer literal >= 11.  P4's derivation
# only ever contains the literals -1, 3, 9 (and the coefficients they produce:
# -9, 9), so no generated lemma can fire on it.  That is asserted, not assumed:
# the "null" column below must stay at 29 steps for every book size, and this
# script fails if it does not.

FAMILIES = ("dsq", "factor", "distrib", "square")


def family_lhs(kind: str, c: int):
    if kind == "dsq":                       # (#0 + c)*(#0 - c)
        return P(S(PV(0), I(c)), Sub(PV(0), I(c)))
    if kind == "factor":                    # (#0 + #1)*c
        return P(S(PV(0), PV(1)), I(c))
    if kind == "distrib":                   # #0 * (#1 + c)
        return P(PV(0), S(PV(1), I(c)))
    return P(S(PV(0), I(c)), S(PV(0), I(c)))  # (#0 + c)^2


def rhs_of(lhs):
    """The normal form of ``lhs``, generalised back to pattern variables.

    Computing the right-hand side this way is what makes the lemma *true* by
    construction; the seven gates then check it anyway, from scratch, and a
    generated lemma that failed a gate would be dropped and reported.
    """
    g = ground(lhs)
    nf, _ = normalize(g, lemmas=(), name="gen")
    back = {("%s%d" % (GROUND_PREFIX, int(x.val[1:]))): x for x in pvars_of(lhs)}
    return subst(nf.result, back)


def generated(n: int):
    """``n`` distinct, genuinely valid lemma statements, deterministically."""
    out = []
    c = 11
    while len(out) < n:
        for fam in FAMILIES:
            if len(out) >= n:
                break
            lhs = family_lhs(fam, c)
            out.append(("%s%d" % (fam, c), lhs, rhs_of(lhs)))
        c += 1
    return out


def build_book(n: int, with_mined: bool, cand=None, mined_first: bool = True):
    """A book of exactly ``n`` installed, gate-checked lemmas.

    Returns ``(book, install_counter, rejects)``.
    """
    ctr = Counter()
    book = Book()
    rejects = []
    n_gen = n - 1 if with_mined else n
    if with_mined and mined_first:
        v = book.install_candidate("dsq", cand, ctr=ctr)
        if not v.ok:
            rejects.append(("dsq", v))
    for lid, lhs, rhs in generated(max(n_gen, 0)):
        v = book.install(lid, lhs, rhs, ctr=ctr)
        if not v.ok:
            rejects.append((lid, v))
    if with_mined and not mined_first:
        v = book.install_candidate("dsq", cand, ctr=ctr)
        if not v.ok:
            rejects.append(("dsq", v))
    return book, ctr, rejects


def measure(book, use_index=False, index=None):
    """Solve P4 against ``book``.  Returns (steps, work, derivation, ok, secs).

    ``index`` is a net built once for the book and reused, so its construction
    is charged to whoever built it rather than to this query.
    """
    t0 = time.time()
    ctr = Counter()
    d, ctr = normalize(P4, lemmas=tuple(book.lemmas), ctr=ctr, name="P4",
                       use_index=use_index, index=index)
    dt = time.time() - t0
    ok = poly_equal(P4, d.result)
    return ctr.steps, ctr.work, d, ok, dt


def build_index(book):
    """The net, built once, with its construction cost counted separately."""
    ctr = Counter()
    idx = LemmaIndex(tuple(book.lemmas), ctr)
    return idx, ctr.work


def main() -> int:
    sizes = [1, 10, 50, 100, 300, 1000]
    use_index = "--index" in sys.argv
    for a in sys.argv[1:]:
        if a.startswith("--sizes"):
            sizes = [int(x) for x in a.split("=", 1)[1].split(",")]

    failures = []

    def want(cond, msg):
        if not cond:
            failures.append(msg)
        return cond

    hdr("0. BASELINE  (no book at all)")
    b_steps, b_work, b_d, b_ok, b_dt = measure(Book())
    print("  P4 with an empty book : steps=%d  work=%d  answer=%s  verified=%s"
          % (b_steps, b_work, render(b_d.result), b_ok))
    want(b_steps == 29, "baseline P4 must be 29 steps, got %d" % b_steps)

    cand = mined_lemma()

    hdr("1. THE CURVE  (each book fully installed through the seven gates)")
    print("  useful book = the mined lemma + (N-1) generated ones")
    print("  null   book = N generated ones, no mined lemma\n")
    print("  %6s %7s %9s %8s %7s %9s %10s %9s"
          % ("N", "steps", "work", "vs base", "null", "null work",
             "install", "wall ms"))
    print("  " + "-" * 76)
    rows = []
    for n in sizes:
        bk, ictr, rej = build_book(n, True, cand)
        want(not rej, "book of %d: %d lemma(s) failed a gate" % (n, len(rej)))
        want(len(bk) == n, "book of %d installed %d" % (n, len(bk)))
        s, w, d, ok, dt = measure(bk)
        nbk, nictr, nrej = build_book(n, False, cand)
        want(not nrej, "null book of %d: %d failed a gate" % (n, len(nrej)))
        ns, nw, nd, nok, _ = measure(nbk)
        want(ok and nok, "N=%d: the answer must still verify" % n)
        want(d.result.addr == b_d.result.addr == nd.result.addr,
             "N=%d: the answer must not change" % n)
        want(ns == b_steps,
             "N=%d: a generated lemma fired on P4 (null steps %d)" % (n, ns))
        rows.append((n, s, w, ns, nw, ictr.work, dt))
        print("  %6d %7d %9d %+8d %7d %9d %10d %9.0f"
              % (n, s, w, w - b_work, ns, nw, ictr.work, dt * 1000))
    print("  " + "-" * 76)
    print("  vs base = search work against the %d of the empty book" % b_work)

    hdr("2. THE CROSSOVER")
    print("  The lemma saves %d - %d = %d kernel steps at every book size --"
          % (b_steps, rows[0][1], b_steps - rows[0][1]))
    print("  that never decays, because the lemma still fires.  What decays is")
    print("  the total cost: search work grows linearly in |book|.\n")
    cross = [r for r in rows if r[2] > b_work]
    if cross:
        first = cross[0]
        print("  first book size whose search work exceeds the no-lemma"
              " baseline: N = %d" % first[0])
        print("    work %d > %d, while steps stay at %d" % (first[2], b_work, first[1]))
        prev = [r for r in rows if r[2] <= b_work]
        if prev:
            print("    (at N = %d the book was still ahead: work %d <= %d)"
                  % (prev[-1][0], prev[-1][2], b_work))
    else:
        print("  no measured book size costs more search work than the baseline;")
        print("  the README's prediction does NOT reproduce at these sizes.")

    if use_index:
        hdr("3. THE SAME CURVE WITH THE DISCRIMINATION NET")
        print("  net work  = index built inside the query (cost charged here)")
        print("  amortised = index built once for the book and reused\n")
        print("  %6s %7s %9s %9s %8s %9s %8s %9s"
              % ("N", "steps", "scan work", "net work", "ratio",
                 "amortised", "ratio", "build"))
        print("  " + "-" * 76)
        net_rows = []
        for n in sizes:
            bk, _, _ = build_book(n, True, cand)
            s0, w0, d0, _, _ = measure(bk)
            s1, w1, d1, ok1, dt1 = measure(bk, use_index=True)
            idx, bwork = build_index(bk)
            s2, w2, d2, ok2, _ = measure(bk, index=idx)
            want(s0 == s1 == s2, "N=%d: the net must not change the steps" % n)
            want(d0.result.addr == d1.result.addr == d2.result.addr,
                 "N=%d: the net must not change the derivation" % n)
            net_rows.append((n, w0, w1, w2, bwork))
            print("  %6d %7d %9d %9d %8s %9d %8s %9d"
                  % (n, s1, w0, w1, ("%.1fx" % (w0 / w1)) if w1 else "-",
                     w2, ("%.1fx" % (w0 / w2)) if w2 else "-", bwork))
        print("  " + "-" * 76)
        print("  the net is required to return the same derivation, step for")
        print("  step; only the work column may move.")
        over = [r for r in net_rows if r[2] > b_work]
        print("\n  crossover with the net, index built per query : %s"
              % ("N = %d" % over[0][0] if over else "not reached at N <= %d"
                 % max(sizes)))
        over2 = [r for r in net_rows if r[3] > b_work]
        print("  crossover with the net, index amortised      : %s"
              % ("N = %d" % over2[0][0] if over2 else "not reached at N <= %d"
                 % max(sizes)))

    hdr("VERDICT")
    if failures:
        print("  FAILURES:")
        for f in failures:
            print("    - " + f)
        return 1
    print("  every book installed cleanly, every answer verified, the null")
    print("  column never moved: the curve above is a measurement of search")
    print("  cost alone.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

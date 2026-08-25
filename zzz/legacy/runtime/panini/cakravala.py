"""Cakravāla — the cyclic method for x² − D y² = 1 — in exact integers.

Why this file exists
--------------------
`code/exp64_geodesic_spectrum.py` computes closed geodesics on the modular
surface and cross-checks their count against the class-number sum over
discriminants.  To do that it needs the fundamental solution of the Pell
equation, and it gets it like this::

    def fundamental_pell(D, tmax):
        umax = ...
        for u in range(1, umax + 1):
            v = D * u * u + 4
            t = math.isqrt(v)
            if t * t == v:
                return t, u

That is trial division over u.  It is correct, it is bounded by a search
window, and it cites nothing.  The equation is not Pell's (Euler misattributed
it — MacTutor: Euler "confused Brouncker and Pell"), and the first general
method for it is not Lagrange's: it is the cakravāla of Jayadeva (c. 950–1000
CE, known only through Udayadivākara's quotation) and Bhāskara II (1150 CE,
*Bījagaṇita*).  See `notes/IMPORTED_MACHINERY.md` §2 for the fetched sources
and for what is and is not established about its optimality.

This module implements cakravāla exactly, verifies every result by
substitution, and measures it against the standard continued-fraction method
on the same counter.

Contents
--------
* `bhavana` — Brahmagupta's composition (samāsa-bhāvanā), 628 CE.
* `cakravala` — the cyclic method.
* `pell_continued_fraction` — the textbook √D continued-fraction solver.
* `pell_brute_force` — the exp64-style search, kept as an independent oracle.
* `verify_solution` — exact substitution check; nothing leaves this module
  unverified.

Pure Python 3 stdlib, exact integers, no floats anywhere (`math.isqrt` is
integer-valued and exact).  Deterministic.
"""

from __future__ import annotations

import math

# ---------------------------------------------------------------------------
# Operation counting
# ---------------------------------------------------------------------------


class Ops:
    """An exact arithmetic-operation counter, shared by both solvers.

    Every solver in this file routes *all* of its arithmetic through these
    methods, so the counts are comparable.  A comparison between two engines
    that count differently is not a comparison; `runtime/SCALE.md` §4.4 makes
    the same point about e-matching visit budgets.
    """

    __slots__ = ("add", "mul", "div", "isqrt", "cmp", "iterations", "max_bits")

    def __init__(self):
        self.add = 0
        self.mul = 0
        self.div = 0
        self.isqrt = 0
        self.cmp = 0
        self.iterations = 0
        self.max_bits = 0

    @property
    def total(self):
        return self.add + self.mul + self.div + self.isqrt + self.cmp

    def note(self, *values):
        """Record the widest integer the algorithm has had to hold."""
        for v in values:
            b = int(v).bit_length()
            if b > self.max_bits:
                self.max_bits = b

    # -- counted primitives -------------------------------------------------
    def a(self, x, y):
        self.add += 1
        r = x + y
        self.note(r)
        return r

    def s(self, x, y):
        self.add += 1
        r = x - y
        self.note(r)
        return r

    def m(self, x, y):
        self.mul += 1
        r = x * y
        self.note(r)
        return r

    def q(self, x, y):
        self.div += 1
        r = x // y
        self.note(r)
        return r

    def r(self, x, y):
        self.div += 1
        return x % y

    def sq(self, x):
        self.isqrt += 1
        return math.isqrt(x)

    def c(self):
        self.cmp += 1

    def snapshot(self):
        return {
            "add": self.add, "mul": self.mul, "div": self.div,
            "isqrt": self.isqrt, "cmp": self.cmp, "total": self.total,
            "iterations": self.iterations, "max_bits": self.max_bits,
        }


# ---------------------------------------------------------------------------
# Verification — the only thing in this file that is trusted
# ---------------------------------------------------------------------------


class NotASolution(Exception):
    pass


def verify_solution(D, x, y, k=1):
    """Exact check that x² − D y² = k with x, y > 0.  Raises otherwise.

    This is deliberately independent of every solver: it recomputes from x, y
    and D alone.  A planted-false solver result must die here, and
    `runtime/tests/test_panini.py` plants one to prove it does.
    """
    if not isinstance(x, int) or not isinstance(y, int):
        raise NotASolution("x, y must be exact integers, got %r, %r" % (type(x), type(y)))
    if x <= 0 or y <= 0:
        raise NotASolution("x=%d, y=%d: a fundamental solution has x,y > 0" % (x, y))
    got = x * x - D * y * y
    if got != k:
        raise NotASolution(
            "x²−Dy² = %d, expected %d  (D=%d, x=%d, y=%d)" % (got, k, D, x, y))
    return True


def is_square(n):
    if n < 0:
        return False
    r = math.isqrt(n)
    return r * r == n


# ---------------------------------------------------------------------------
# Brahmagupta's bhāvanā (composition), 628 CE
# ---------------------------------------------------------------------------


def bhavana(D, a1, b1, k1, a2, b2, k2, ops=None):
    """samāsa-bhāvanā: compose two solutions of a²−Db²=k.

    (a₁,b₁,k₁) ∘ (a₂,b₂,k₂) = (a₁a₂ + D b₁b₂, a₁b₂ + a₂b₁, k₁k₂)

    MacTutor states Brahmagupta's rule in the equivalent form "if (a,b) and
    (c,d) are solutions to Pell's equation then so are (bc+ad, bd+nac)".
    """
    ops = ops or Ops()
    a = ops.a(ops.m(a1, a2), ops.m(D, ops.m(b1, b2)))
    b = ops.a(ops.m(a1, b2), ops.m(a2, b1))
    k = ops.m(k1, k2)
    return a, b, k


def _shortcut(D, a, b, k, ops):
    """Brahmagupta's k ∈ {±1, ±2, 4} shortcuts: jump straight to k = 1.

    Returns (x, y) or None.

    **This is off by default and the reason is a measured counterexample, not
    caution.**  The shortcut composes the *current* (a, b, k) with itself, and
    that is only the fundamental solution when the current triple is itself
    the minimal solution of a² − Db² = k.  Cakravāla's m-minimisation does not
    guarantee that.  At D = 21 the iteration reaches (23, 5, 4); the classical
    k = 4, a odd identity then yields (6049, 1320), which satisfies
    x² − 21y² = 1 exactly and is **not fundamental** — it is the bhāvanā
    square of (55, 12).  Running the loop on instead gives (55, 12) in one
    more iteration.

    That counterexample is kept as a test (`test_shortcut_can_return_a
    _verified_but_non_fundamental_solution`), because it is precisely the
    failure a verification-by-substitution check cannot see: the answer is
    *true* and *wrong*.
    """
    if k == 1:
        return a, b
    if k == -1:
        # (a+b√D)² has norm 1.
        x = ops.a(ops.m(a, a), ops.m(D, ops.m(b, b)))
        y = ops.m(2, ops.m(a, b))
        return x, y
    if k in (2, -2):
        # (a²+Db²)/2 is an integer because a²−Db² = ±2 ⇒ a²+Db² = 2a² ∓ 2.
        x = ops.q(ops.a(ops.m(a, a), ops.m(D, ops.m(b, b))), 2)
        y = ops.m(a, b)
        return x, y
    if k == 4:
        if a % 2 == 0 and b % 2 == 0:
            return ops.q(a, 2), ops.q(b, 2)
        # a, b odd: ((a+b√D)/2)³ = (a(a²−3) + b(a²−1)√D)/2, both halves even.
        x = ops.q(ops.m(a, ops.s(ops.m(a, a), 3)), 2)
        y = ops.q(ops.m(b, ops.s(ops.m(a, a), 1)), 2)
        return x, y
    if k == -4 and a % 2 == 0 and b % 2 == 0:
        a2, b2 = ops.q(a, 2), ops.q(b, 2)               # a2² − D b2² = −1
        x = ops.a(ops.m(a2, a2), ops.m(D, ops.m(b2, b2)))
        y = ops.m(2, ops.m(a2, b2))
        return x, y
    # k = −4 with a, b odd needs α⁶ and is not shipped: an unverified identity
    # in a file whose whole point is exactness would be the wrong trade.
    return None


def is_bhavana_square(D, x, y):
    """True iff (x, y) is the self-composition of a strictly smaller solution.

    (u,v) ∘ (u,v) = (u²+Dv², 2uv), so (x,y) is a square exactly when
    (x+1)/2 and (x−1)/(2D) are both perfect squares.  This is a *necessary*
    condition for non-minimality of the commonest kind, not a decision
    procedure for minimality; the full check in this module is agreement with
    `pell_continued_fraction`.
    """
    if (x + 1) % 2 or (x - 1) % (2 * D):
        return False
    u2 = (x + 1) // 2
    v2 = (x - 1) // (2 * D)
    if not (is_square(u2) and is_square(v2)):
        return False
    u, v = math.isqrt(u2), math.isqrt(v2)
    return v > 0 and 2 * u * v == y


def verify_fundamental(D, x, y):
    """`verify_solution` plus the square-composite screen.  Raises on failure."""
    verify_solution(D, x, y, 1)
    if is_bhavana_square(D, x, y):
        raise NotASolution(
            "(x=%d, y=%d) satisfies x²−%dy²=1 but is the bhāvanā square of a "
            "smaller solution — verified and still not fundamental" % (x, y, D))
    return True


# ---------------------------------------------------------------------------
# Cakravāla
# ---------------------------------------------------------------------------


class CakravalaResult:
    __slots__ = ("D", "x", "y", "ops", "trace", "used_shortcut", "shortcut_k")

    def __init__(self, D, x, y, ops, trace, used_shortcut, shortcut_k):
        self.D = D
        self.x = x
        self.y = y
        self.ops = ops
        self.trace = trace          # tuple of (a, b, k, m) per iteration
        self.used_shortcut = used_shortcut
        self.shortcut_k = shortcut_k

    def __repr__(self):
        return "CakravalaResult(D=%d, x=%d, y=%d, %d iterations)" % (
            self.D, self.x, self.y, self.ops.iterations)


def cakravala(D, ops=None, use_shortcut=False, max_iterations=10000):
    """The cyclic method for x² − D y² = 1.  D > 0, not a perfect square.

    One iteration, as stated in the fetched source (Wikipedia, *Chakravala
    method*, quoting Bhāskara's lemma and the update rules):

        a ← (a·m + D·b)/|k|,   b ← (a + b·m)/|k|,   k ← (m² − D)/k

    with m > 0 chosen so that (a + b·m) ≡ 0 (mod |k|) — which makes both new
    values integral — and, among those, so as to **minimise |m² − D|**.  That
    minimisation is the whole of the method's cleverness and the thing Selenius
    analysed.

    Seed: a = ⌊√D⌋, b = 1, k = a² − D, which is Bhāskara's usual start (the
    nearest square below D).

    Every returned pair is checked by `verify_solution` before it is returned.
    """
    if D <= 0:
        raise ValueError("D must be positive")
    if is_square(D):
        raise ValueError("D = %d is a perfect square; x²−Dy²=1 has no solution "
                         "with y > 0" % D)
    ops = ops or Ops()

    s = ops.sq(D)
    a, b = s, 1
    k = ops.s(ops.m(a, a), D)
    trace = []

    if k == 1:                       # D = s²−1, immediate
        verify_fundamental(D, a, b)
        return CakravalaResult(D, a, b, ops, tuple(trace), False, None)

    for _ in range(max_iterations):
        ops.iterations += 1
        ak = k if k > 0 else -k
        m = _choose_m(D, a, b, ak, s, ops)
        trace.append((a, b, k, m))

        na = ops.q(ops.a(ops.m(a, m), ops.m(D, b)), ak)
        nb = ops.q(ops.a(a, ops.m(b, m)), ak)
        nk = ops.q(ops.s(ops.m(m, m), D), k)
        a, b, k = na, nb, nk

        ops.c()
        if k == 1:
            verify_fundamental(D, a, b)
            return CakravalaResult(D, a, b, ops, tuple(trace), False, None)

        if use_shortcut and k in (-1, 2, -2, 4, -4):
            got = _shortcut(D, a, b, k, ops)
            if got is not None:
                x, y = got
                verify_solution(D, x, y, 1)
                return CakravalaResult(D, x, y, ops, tuple(trace), True, k)

    raise RuntimeError("cakravāla did not reach k = 1 for D = %d in %d "
                       "iterations" % (D, max_iterations))


def _choose_m(D, a, b, ak, s, ops):
    """The m of one cakravāla step.

    Constraint: (a + b·m) ≡ 0 (mod ak).  gcd(b, k) = 1 is an invariant of the
    iteration, so b is invertible mod ak and the constraint fixes m in one
    residue class m ≡ −a·b⁻¹ (mod ak).

    Objective: minimise |m² − D| over that class, subject to m ≥ 1.  Since
    m ↦ |m² − D| is unimodal about √D, the minimiser is one of the two class
    members bracketing ⌊√D⌋, so only those are examined — exactly, with no
    search.  Ties go to the smaller m (a deterministic choice; Bhāskara's rule
    as transmitted does not disambiguate them).
    """
    if ak == 1:
        m0 = 0
    else:
        binv = pow(b % ak, -1, ak)
        m0 = (-a * binv) % ak
    ops.div += 1  # the modular inverse / residue reduction

    # largest m ≡ m0 (mod ak) with m ≤ s, and the next one above it
    lo = m0 + ((s - m0) // ak) * ak if s >= m0 else m0 - ak
    cands = []
    for cand in (lo, lo + ak):
        if cand >= 1:
            cands.append(cand)
    if not cands:                                   # m0 = 0 and ak = 1 edge
        cands = [1]
    best = None
    best_gap = None
    for cand in cands:
        gap = ops.s(ops.m(cand, cand), D)
        if gap < 0:
            gap = -gap
        ops.c()
        if best_gap is None or gap < best_gap or (gap == best_gap and cand < best):
            best, best_gap = cand, gap
    return best


# ---------------------------------------------------------------------------
# The continued-fraction method (Lagrange, 1771) — the comparison baseline
# ---------------------------------------------------------------------------


class CFResult:
    __slots__ = ("D", "x", "y", "ops", "period")

    def __init__(self, D, x, y, ops, period):
        self.D = D
        self.x = x
        self.y = y
        self.ops = ops
        self.period = period

    def __repr__(self):
        return "CFResult(D=%d, x=%d, y=%d, %d iterations)" % (
            self.D, self.x, self.y, self.ops.iterations)


def pell_continued_fraction(D, ops=None, max_iterations=200000):
    """Fundamental solution from the regular continued fraction of √D.

    The standard exact-integer (P, Q, a) recurrence:

        P₀ = 0, Q₀ = 1, a₀ = ⌊√D⌋
        P_{n+1} = a_n Q_n − P_n
        Q_{n+1} = (D − P_{n+1}²)/Q_n
        a_{n+1} = ⌊(a₀ + P_{n+1})/Q_{n+1}⌋

    with convergents p_n/q_n by the usual two-term recurrence; the first
    convergent with p² − D q² = 1 is the fundamental solution.  Same `Ops`
    counter as `cakravala`, so the two totals are directly comparable.
    """
    if D <= 0:
        raise ValueError("D must be positive")
    if is_square(D):
        raise ValueError("D = %d is a perfect square" % D)
    ops = ops or Ops()

    a0 = ops.sq(D)
    P, Q, a = 0, 1, a0
    p_prev, p = 1, a0
    q_prev, q = 0, 1
    ops.note(a0)

    for _ in range(max_iterations):
        ops.iterations += 1
        ops.c()
        if ops.s(ops.m(p, p), ops.m(D, ops.m(q, q))) == 1:
            verify_fundamental(D, p, q)
            return CFResult(D, p, q, ops, ops.iterations)
        P = ops.s(ops.m(a, Q), P)
        Q = ops.q(ops.s(D, ops.m(P, P)), Q)
        a = ops.q(ops.a(a0, P), Q)
        p, p_prev = ops.a(ops.m(a, p), p_prev), p
        q, q_prev = ops.a(ops.m(a, q), q_prev), q

    raise RuntimeError("continued fraction did not terminate for D = %d" % D)


# ---------------------------------------------------------------------------
# The exp64 oracle — brute force, kept as an independent check
# ---------------------------------------------------------------------------


def pell_brute_force(D, ymax=10 ** 6, ops=None):
    """Trial search over y, in the shape `code/exp64_geodesic_spectrum.py`
    uses.  Returns (x, y) or None if the window was exhausted — the window is
    a real limitation and is reported as `None`, never as 'no solution'."""
    ops = ops or Ops()
    for y in range(1, ymax + 1):
        ops.iterations += 1
        v = ops.a(ops.m(D, ops.m(y, y)), 1)
        x = ops.sq(v)
        ops.c()
        if ops.m(x, x) == v:
            verify_solution(D, x, y, 1)
            return x, y, ops
    return None


# ---------------------------------------------------------------------------
# The measurement
# ---------------------------------------------------------------------------

# D values whose fundamental solutions are famously large; D=61 is Fermat's
# 1657 challenge to the English mathematicians, solved by Bhāskara ~500 years
# earlier (MacTutor).
HARD_D = (61, 67, 97, 103, 109, 149, 151, 157, 166, 181, 193, 199,
          211, 214, 227, 241, 313, 331, 397, 409, 421, 526, 541, 601,
          613, 661, 727, 811, 919, 991, 1021, 1069, 1381, 1621, 1741)


def compare(D):
    """Run both methods on one D and return a comparable record."""
    oc = Ops()
    rc = cakravala(D, oc)
    of = Ops()
    rf = pell_continued_fraction(D, of)
    if (rc.x, rc.y) != (rf.x, rf.y):
        raise AssertionError(
            "the two methods disagree on D=%d: cakravāla (%d,%d) vs "
            "continued fraction (%d,%d)" % (D, rc.x, rc.y, rf.x, rf.y))
    return {
        "D": D,
        "x": rc.x,
        "y": rc.y,
        "cak_iters": oc.iterations,
        "cf_iters": of.iterations,
        "cak_ops": oc.total,
        "cf_ops": of.total,
        "cak_bits": oc.max_bits,
        "cf_bits": of.max_bits,
        "shortcut": rc.shortcut_k if rc.used_shortcut else None,
    }


def sweep(dmax=200):
    """Every non-square D in [2, dmax]."""
    return [compare(D) for D in range(2, dmax + 1) if not is_square(D)]


def totals(rows):
    return {
        "n": len(rows),
        "cak_iters": sum(r["cak_iters"] for r in rows),
        "cf_iters": sum(r["cf_iters"] for r in rows),
        "cak_ops": sum(r["cak_ops"] for r in rows),
        "cf_ops": sum(r["cf_ops"] for r in rows),
        "cak_wins_iters": sum(1 for r in rows if r["cak_iters"] < r["cf_iters"]),
        "cf_wins_iters": sum(1 for r in rows if r["cf_iters"] < r["cak_iters"]),
        "tie_iters": sum(1 for r in rows if r["cf_iters"] == r["cak_iters"]),
        "cak_wins_ops": sum(1 for r in rows if r["cak_ops"] < r["cf_ops"]),
        "cf_wins_ops": sum(1 for r in rows if r["cf_ops"] < r["cak_ops"]),
        "tie_ops": sum(1 for r in rows if r["cf_ops"] == r["cak_ops"]),
    }

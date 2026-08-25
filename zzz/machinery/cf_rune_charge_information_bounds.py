"""Exact instantiation of the contributed charge-information bounds
(Theorems 4/23/24 and Corollary 4.2 of the relational-contracts corpus,
msg 0373) on objects the repository already owns.

World: x uniform on Z/24. Local information Y = (x mod 4, x mod 6) — the
README's glue-remainders view, whose hidden fiber {x, x+12} has size
gcd(4,6) = 2 (notes/VIEW_GLUING_TWO_FAILURES.md). Hidden charge
C = +1 if x < 12 else -1: the fiber bit, conditionally balanced given Y
by construction (E[C|Y] = 0 exactly).

Three probes Z, all deterministic in x, spanning the regimes:

  Z_full = x mod 8      resolves the fiber: I(C;Z|Y) = log 2 exactly
                        (Thm 23: exact recovery costs the full bit) and
                        max advantage 1/2 <= sqrt(log2 / 2)  (Thm 4).
  Z_null = x mod 3      a function of Y: I(C;Z|Y) = 0, and EVERY
                        estimator has advantage exactly 0 (Cor 4.2) —
                        checked over all 2^|range| decision rules.
  Z_half = x mod 8 on even x, else constant
                        partial: I(C;Z|Y) = (1/2) log 2, best advantage
                        1/4 < sqrt((1/2)(1/2)log2) — strict, bound
                        non-tight, as Pinsker-type bounds are.

Probabilities are exact rationals (Fraction); logs are the only floats
and enter only comparisons with wide margins. This replays a proved
theorem on exact finite objects; it is a certificate replay, not a
measurement.  Run: python3 <this file>.
"""

from fractions import Fraction
from math import log, sqrt
WORLD = range(24)
P = Fraction(1, 24)

def Y(x):
    return (x % 4, x % 6)

def C(x):
    return 1 if x < 12 else -1

# E[C|Y] = 0 exactly
ys = sorted({Y(x) for x in WORLD})
for y in ys:
    fib = [x for x in WORLD if Y(x) == y]
    assert len(fib) == 2 and sum(C(x) for x in fib) == 0
print("setup: fiber size gcd(4,6)=2, C conditionally balanced: OK")

def cond_mi(Zf):
    """I(C; Z | Y) in nats, probabilities exact, log at the end."""
    total = 0.0
    for y in ys:
        fib = [x for x in WORLD if Y(x) == y]
        py = P * len(fib)
        pj = {}
        for x in fib:
            k = (C(x), Zf(x))
            pj[k] = pj.get(k, Fraction(0)) + Fraction(1, len(fib))
        pc, pz = {}, {}
        for (c, z), p in pj.items():
            pc[c] = pc.get(c, Fraction(0)) + p
            pz[z] = pz.get(z, Fraction(0)) + p
        s = sum(float(p) * log(p / (pc[c] * pz[z]))
                for (c, z), p in pj.items() if p)
        total += float(py) * s
    return total

def advantage(Zf):
    """Best advantage over ALL estimators chat(y,z): the optimum picks
    the majority sign per (y,z) cell, so max E[C chat] = sum over cells
    of P * |sum of C in cell|, and advantage = that / 2. Exact."""
    e_cchat = Fraction(0)
    for y in ys:
        fib = [x for x in WORLD if Y(x) == y]
        cells = {}
        for x in fib:
            cells.setdefault(Zf(x), []).append(C(x))
        for cs in cells.values():
            e_cchat += P * abs(sum(cs))
    return e_cchat / 2

LOG2 = log(2)

# --- Z_full: x mod 8 ---
i_full = cond_mi(lambda x: x % 8)
a_full = advantage(lambda x: x % 8)
assert abs(i_full - LOG2) < 1e-12          # Thm 23: exactly log 2
assert a_full == Fraction(1, 2)
assert float(a_full) <= sqrt(i_full / 2) + 1e-12   # Thm 4
print("Z=x mod 8 : I = log 2 exactly, advantage 1/2 <= sqrt(log2/2): OK")

# --- Z_null: x mod 3 (function of Y) ---
i_null = cond_mi(lambda x: x % 3)
assert abs(i_null) < 1e-15
# Cor 4.2: EVERY estimator chat(y,z) has advantage exactly 0. The max of
# |E[C rule]| over all rules factors per (y,z) cell (choose the sign of
# each cell independently), so it equals sum_cells P * |sum of C in cell|
# — exactly the majority-margin quantity, no enumeration needed.
worst = advantage(lambda x: x % 3) * 2   # = max |E[C rule]| over rules
assert worst == 0
print("Z=x mod 3 : I = 0 and the best of all estimators has advantage 0"
      " (exact cellwise maximization): OK")

# --- Z_half: informative on even fibers only ---
zh = lambda x: x % 8 if x % 2 == 0 else 9
i_half = cond_mi(zh)
a_half = advantage(zh)
assert abs(i_half - LOG2 / 2) < 1e-12
assert a_half == Fraction(1, 4)
assert float(a_half) < sqrt(i_half / 2) - 0.1   # strictly non-tight
print("Z=half    : I = (1/2)log 2, advantage 1/4 < sqrt(I/2) strictly: OK")

# Cor 4.1 direction on the same data: advantage 1/4 forces I >= 2*(1/4)^2
assert i_half >= 2 * float(a_half) ** 2
print("Cor 4.1   : I >= 2 delta^2 on the partial probe: OK")

print("ALL CHECKS PASSED — charge-information bounds hold exactly on the"
      " corpus's own gluing fiber")

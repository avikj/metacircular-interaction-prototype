#!/usr/bin/env python3
"""exp54: definitional rigidity + homometric counterexample catalog (FIDELITY program).

Claim-anchored checks for notes/DEFINITIONAL_RIGIDITY.md (packet R0018).

Anchored statements:
  (R)  Theorem R: in the class C = {completely multiplicative a, |a_p| <= 1},
       the web {Euler fragment, D(2) = zeta(2)} pins a == 1.  Mechanism:
       |1 - a p^{-2}| >= 1 - p^{-2} with equality iff a = 1.
  (H1) Special-values web {s=2, s=4} WITHOUT the Euler fragment is homometric:
       P(s) = 5 - 128*2^{-s} + 243*3^{-s} vanishes at s=2 and s=4 exactly,
       so zeta and zeta+P share the web.
  (H2) Euler fragment + special value WITHOUT boundedness is homometric:
       two-prime witness (a_2,a_3) = (1,1) vs (0,3) share the value 3/2
       of prod_{p in {2,3}} (1 - a_p p^{-2})^{-1}.
  (H4) Pure homometry paradigm: a minimal integer homometric multiset pair
       (same difference multiset, inequivalent under translation/reflection).

Controls (statement-known-false detectors, per PROTOCOL section 4):
  (C1) unit-modulus impostor a_2 = e^{0.3i} must FAIL the value web with a
       strictly positive margin (rigidity detector fires);
  (C2) the H2 impostor (0,3) must FAIL the boundedness axiom (|a_3| <= 1),
       i.e. the added axiom kills the homometry — the web-thickening works;
  (C3) a WRONG Dirichlet polynomial (5, -128, 242) must NOT vanish at s=4
       (the H1 construction is not vacuously satisfiable).
"""
from fractions import Fraction as F
import cmath
import itertools

ok = 0
def check(name, cond):
    global ok
    assert cond, name
    ok += 1
    print(f"PASS {name}")

# ---- H1: exact vanishing of P at s=2,4 (rational arithmetic) ----
def P(coeffs, s):  # Dirichlet polynomial sum c_n n^{-s}, s integer, exact
    return sum(F(c, n**s) for n, c in coeffs.items())
P1 = {1: 5, 2: -128, 3: 243}
check("H1: P(2) = 0 exactly", P(P1, 2) == 0)
check("H1: P(4) = 0 exactly", P(P1, 4) == 0)
check("H1: P is not the zero polynomial (P(3) != 0)", P(P1, 3) != 0)

# ---- H2: two-prime Euler-value collision, exact rationals ----
def euler_val(a2, a3):  # prod over p in {2,3} of (1 - a_p p^-2)^{-1}
    return 1 / ((1 - F(a2, 4)) * (1 - F(a3, 9)))
check("H2: (1,1) and (0,3) collide at s=2 (both 3/2)",
      euler_val(1, 1) == euler_val(0, 3) == F(3, 2))
check("C2: impostor (0,3) fails boundedness |a_3| <= 1", abs(3) > 1)

# ---- R: extremality lemma margin on the unit circle ----
# |1 - a/4| >= 3/4 with equality iff a = 1, for |a| = 1.
worst = min(abs(1 - cmath.exp(1j * t / 1000) / 4)
            for t in range(1, 6284))  # excludes a=1 (t=0)
check("R: strict extremality off a=1 (min |1-a/4| > 3/4 on grid)",
      worst > 0.75)
check("R: equality at a=1", abs(1 - 1 / 4) == 0.75)

# ---- C1: planted-false unit-modulus impostor is detected ----
a2 = cmath.exp(0.3j)
val = 1 / ((1 - a2 / 4) * (1 - 1 / 9))
margin = abs(abs(val) - 1 / ((1 - 1 / 4) * (1 - 1 / 9)))
check(f"C1: impostor a_2=e^0.3i fails value web, margin {margin:.3e} > 1e-3",
      margin > 1e-3)

# ---- C3: wrong polynomial does not vanish ----
check("C3: (5,-128,242) does not vanish at s=4", P({1: 5, 2: -128, 3: 242}, 4) != 0)

# ---- H4: exhaustive minimal homometric pair search ----
def diffs(S):
    return tuple(sorted(abs(x - y) for x, y in itertools.combinations(S, 2)))
def canon(S):  # translation + reflection normal form
    S = tuple(sorted(x - min(S) for x in S))
    R = tuple(sorted(max(S) - x for x in S))
    return min(S, R)
found = None
empty_sizes = []
for k in range(3, 7):
    table = {}
    for S in itertools.combinations(range(18), k):
        c = canon(S)
        table.setdefault(diffs(S), set()).add(c)
    pairs = [(d, sorted(v)) for d, v in table.items() if len(v) > 1]
    if pairs:
        found = (k, sorted(pairs)[0])
        break
    empty_sizes.append(k)
k, (d, pair) = found
check(f"H4: homometric pair at size {k}: {pair[0]} vs {pair[1]}, "
      f"shared difference multiset {d}", len(pair) >= 2)
check("H4: pair is genuinely inequivalent (distinct canonical forms)",
      pair[0] != pair[1])
check(f"H4: exhaustively NO pair at sizes {empty_sizes} within diameter 17 "
      "(size 6 is minimal in this range)", empty_sizes == [3, 4, 5])

print(f"\nALL {ok} CHECKS PASS")

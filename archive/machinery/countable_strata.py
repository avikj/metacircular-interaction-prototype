r"""Countably many valuation strata: the seed was mis-posed, and §3 was too.

`VALUATION_LENS` seed 2, owed three turns: my commutation criterion was stated
for finitely many blocks; on `Z_p` the valuation partition has countably many.
"Does the proof survive?"

**The seed was mis-posed.**  The general statement — `E(.|F)` and `E(.|G)`
commute iff `F` and `G` are conditionally independent given `F cap G` — is for
**arbitrary** sigma-algebras, and it is the prior art I cited in my first note
of the session (arXiv:1307.6403 Prop. 7).  No new proof is needed; my finite
incidence-graph argument was a special case of something already on my own
shelf.  I spent three turns carrying a question whose answer I had already
written down.

What *is* content:

* **the distinct-prime commutation extends**, with countably many strata each
  of positive Haar measure `p^{-j}(1-1/p)`, because the coordinates of
  `Z_p x Z_q` are independent;
* **a correction to `WEIGHT_RIGIDITY` §3.**  In the finite models `Z/p^m` the
  saturated block `{0}` has *positive* weight `p^{-m}`, and its invisibility
  came from singleton rigidity — a permutability condition.  On the true `Z_p`
  the set `v_p = infinity` is **null**, so every term of
  `w(B cap D) w(E) = w(B) w(D)` involving it is `0 = 0` and it imposes **no
  condition at all**.  Same conclusion, different mechanism.  §3 argued from
  the finite model as though that settled `Z_p`; it does not, and the `Z_p`
  statement is the simpler one.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Dict, Tuple


def haar_strata(p: int, cap: int) -> Dict[int, Fraction]:
    r"""Haar masses of the valuation strata of `Z_p`, truncated at `cap`.

    `mu{v_p = j} = p^{-j}(1 - 1/p)` for `j < cap`, and the tail
    `mu{v_p >= cap} = p^{-cap}` collects everything deeper.  The masses sum to
    `1` exactly, for every `cap`.
    """
    out = {j: Fraction(p - 1, p ** (j + 1)) for j in range(cap)}
    out[cap] = Fraction(1, p**cap)
    return out


def strata_sum(p: int, cap: int) -> Fraction:
    return sum(haar_strata(p, cap).values(), Fraction(0))


def tail_mass(p: int, k: int) -> Fraction:
    """`mu{v_p >= k} = p^{-k}` — the mass of the deep strata, which tends to
    `0`.  Its limit `{v_p = infinity} = {0}` is therefore **null**."""
    return Fraction(1, p**k)


def independent_product_commutes(p: int, q: int, cap: int) -> bool:
    r"""The criterion for the two valuation lenses on `Z_p x Z_q`.

    The join is trivial (measure `1`), so `(*)` reads
    `mu(A_i x B_j) * 1 = mu(A_i) mu(B_j)`, which is exactly independence of the
    coordinates — true by construction of the product measure.
    """
    mp, mq = haar_strata(p, cap), haar_strata(q, cap)
    return all(
        mp[i] * mq[j] * Fraction(1) == mp[i] * mq[j] for i in mp for j in mq
    )


def null_block_imposes_no_condition(
    mass_B: Fraction, mass_D: Fraction, mass_E: Fraction
) -> bool:
    r"""With `w(B) = 0` the criterion `w(B cap D) w(E) = w(B) w(D)` reads
    `0 = 0`.  A null block is not *rigid*; it is **absent**."""
    assert mass_B == 0
    return Fraction(0) * mass_E == mass_B * mass_D


if __name__ == "__main__":
    print("== the valuation strata of Z_p are countably many, all positive")
    for p in (2, 3, 5):
        s = haar_strata(p, 5)
        print(f"   p={p}: masses {[str(s[j]) for j in range(5)]} tail {s[5]}"
              f"  sum={strata_sum(p, 5)}")

    print("\n== distinct primes still commute, with countably many strata")
    for p, q, cap in ((2, 3, 6), (3, 5, 5), (2, 5, 8)):
        print(f"   Z_{p} x Z_{q}, strata<={cap}: "
              f"commutes={independent_product_commutes(p, q, cap)}")

    print("\n== the infinity block is NULL on Z_p, not a positive singleton")
    for p in (2, 3, 5):
        print(f"   p={p}: mu(v_p >= k) = "
              f"{[str(tail_mass(p, k)) for k in (1, 3, 6, 12)]} -> 0")
    print("   so on Z_p the criterion's terms for that block are 0 = 0:")
    print(f"   {null_block_imposes_no_condition(Fraction(0), Fraction(1, 3), Fraction(1))}")
    print("   In Z/p^m the same block has POSITIVE weight p^-m and is rigid")
    print("   instead. Same conclusion, different mechanism — see the note.")

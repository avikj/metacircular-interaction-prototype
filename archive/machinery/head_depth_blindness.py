#!/usr/bin/env python3
"""The cyclotomic head depth IS the blindness depth of a base.

Session 8 (`notes/EXPOSED_SET.md`, Corollary W2) found that
`e_2(q) >= 2 <=> q Wieferich <=> base 2 fails to refute q^2` -- one arithmetic
event wearing two names in two notes. That was the case `b = 2`, `a = 2`.

The general statement is exact and has no exceptional cases.

  **Theorem W3.**  For an odd prime `q`, an integer `a >= 1`, and `b` coprime
  to `q`, write `d = ord_q(b)` and let

      e_b(q) = v_q(b^d - 1)

  be the head depth of `CYCLOTOMIC_SENSOR`'s sensor at base `b`.  Then

      b fails to refute q^a by the Fermat test   <==>   e_b(q) >= a,

  hence  `e_b(q) = max{ a : b is blind on q^a }`.

So the head depth is not merely an internal parameter of the cyclotomic organ:
it is the exact depth to which base `b` cannot see powers of `q`.  Its level
sets are subgroups (Corollary W4), so the *structure* of `e` is completely
determined even though no individual value is predicted.

Prior art consumed, not reproved: Fermat, Euler, the lifting-the-exponent lemma
(via `CYCLOTOMIC_SENSOR` Theorem 1), and the standard heuristic for Wieferich
density -- which, as noted below, is Corollary W4 read across `q` instead of
across `b`.
"""

from __future__ import annotations


def valuation(number: int, prime: int) -> int:
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def multiplicative_order(base: int, modulus: int) -> int:
    order, power = 1, base % modulus
    while power != 1:
        power = power * base % modulus
        order += 1
    return order


def head_depth(base: int, prime: int) -> int:
    """`e_b(q) = v_q(b^ord_q(b) - 1)`, the CYCLOTOMIC_SENSOR head depth."""
    if base % prime == 0:
        raise ValueError("the head depth needs a base prime to q")
    return valuation(base ** multiplicative_order(base, prime) - 1, prime)


def is_fermat_blind(base: int, prime: int, power: int) -> bool:
    """Does `base` fail to refute `q^a` by the Fermat test?

    For `a = 1` this is vacuously true and correct -- `q` is prime and must not
    be refuted.  The content is at `a >= 2`, where `q^a` is composite.
    """
    modulus = prime ** power
    return pow(base, modulus - 1, modulus) == 1


def blindness_depth(base: int, prime: int, ceiling: int = 8) -> int:
    """`max{a : b is blind on q^a}`, computed directly rather than from `e`."""
    depth = 0
    while depth < ceiling and is_fermat_blind(base, prime, depth + 1):
        depth += 1
    return depth


def theorem_w3(base: int, prime: int, power: int) -> bool:
    """Blindness on `q^a` iff `e_b(q) >= a`.

    *Proof.*  `b` is blind on `q^a` iff `b^(q^a - 1) = 1 (mod q^a)`.  The order
    of `b` in `(Z/q^a)^*` divides both `q^a - 1` and `q^(a-1)(q-1)`, whose gcd
    is `q - 1` because `gcd(q^a - 1, q) = 1` and `(q-1) | (q^a - 1)`; so
    blindness is equivalent to `b^(q-1) = 1 (mod q^a)`, i.e. to
    `v_q(b^(q-1) - 1) >= a`.  Now `d = ord_q(b)` divides `q - 1`, so
    `CYCLOTOMIC_SENSOR` Theorem 1 gives
    `v_q(b^(q-1) - 1) = e_b(q) + v_q(q-1) = e_b(q)`, since `q` does not divide
    `q - 1`.  Hence blindness iff `e_b(q) >= a`.  []
    """
    return is_fermat_blind(base, prime, power) == (head_depth(base, prime) >= power)


def deep_bases(prime: int, power: int) -> set[int]:
    """`{b mod q^a : e_b(q) >= a}` -- the bases blind to depth `a`.

    **Corollary W4.**  This is the unique subgroup of order `q - 1` in the
    cyclic group `(Z/q^a)^*`, hence has index `q^(a-1)`: exactly a fraction
    `q^(1-a)` of bases are blind at depth `a`.

    So `e` is not predictable pointwise but is completely structured: its level
    sets are subgroups of known index.  `CYCLOTOMIC_SENSOR`'s rigor boundary
    says "`e` is *observed* once per `(p,a)`, never predicted" -- true of a
    single base, and this is the exact statement of what is nevertheless known.

    Read across `q` rather than across `b`, the index `q^(a-1)` at `a = 2` is
    the standard `1/q` heuristic for Wieferich primes.  That reading is a
    heuristic and is **not** claimed here; the subgroup statement is a theorem.
    """
    modulus = prime ** power
    return {b for b in range(1, modulus)
            if b % prime and pow(b, prime - 1, modulus) == 1}


def main() -> None:
    print("Theorem W3:  e_b(q) = max{ a : b is Fermat-blind on q^a }\n")
    print("  q    b    e_b(q)   blindness depth   agree")
    for prime in (5, 7, 11, 13):
        for base in (2, 3, 7, 10):
            if base % prime == 0:
                continue
            depth, blind = head_depth(base, prime), blindness_depth(base, prime)
            flag = "yes" if depth == blind else "NO"
            marker = "   <-- deep base" if depth >= 2 else ""
            print(f"  {prime:3}  {base:3}   {depth:6}   {blind:15}   {flag}{marker}")
    print("\nCorollary W4: the level sets are subgroups of index q^(a-1)")
    print("  q    a    |{b : e_b >= a}|    phi(q^a)    index")
    for prime in (5, 7, 11, 13):
        for power in (1, 2, 3):
            found = len(deep_bases(prime, power))
            totient = prime ** (power - 1) * (prime - 1)
            print(f"  {prime:3}  {power:3}   {found:14}   {totient:9}"
                  f"    {totient // found:5}")
    print("\n  session 8's Wieferich bridge is the case b = 2, a = 2")
    for prime in (1093, 3511, 1091):
        print(f"    q={prime:5}: e_2(q) = {head_depth(2, prime)},"
              f"  blind on q^2 = {is_fermat_blind(2, prime, 2)}")


if __name__ == "__main__":
    main()

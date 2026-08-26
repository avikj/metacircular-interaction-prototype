#!/usr/bin/env python3
"""Localizing my own open case: which composites can lose a dropped sensor?

`notes/PINNING.md` seed 1 left open whether the hybrid anatomy (each prime
sensor `p` refuting `n` when `p | n` **or** `p` is a strong witness for `n`)
keeps its permanence at every frontier.  I recorded that I had no instinct.

The question localizes.  Dropping `q` from `P(<=B)` can only lose soundness on
the **exposed set**

    E_q(B) = { n <= B^2 : the only prime factor of n that is <= B is q },

since every other composite still has a divisibility refuter.  Each exposed `n`
is `q^a` with `a >= 2`, or `q^a * r` with `r` prime `> B` -- there is no room
for two primes above `B` under `n <= B^2`.

The prime-power half is then settled outright by Lemma W below, and the residue
is a statement about strong pseudoprimes that I do **not** prove.

A by-product worth more than the localization: Lemma W's exceptional case is the
Wieferich condition, and the Wieferich condition is *the same arithmetic event*
as the anomalous head depth of `CYCLOTOMIC_SENSOR` at base 2 (Corollary W2).
The two organs fail at the same primes, for one reason.
"""

from __future__ import annotations


def sieve(limit: int) -> bytearray:
    flags = bytearray([1]) * (limit + 1)
    flags[0] = flags[1] = 0
    candidate = 2
    while candidate * candidate <= limit:
        if flags[candidate]:
            flags[candidate * candidate::candidate] = bytearray(
                len(flags[candidate * candidate::candidate]))
        candidate += 1
    return flags


def strong_refutes(base: int, number: int) -> bool:
    if number % 2 == 0:
        return number > 2
    if base % number == 0:
        return False
    odd, twos = number - 1, 0
    while odd % 2 == 0:
        odd //= 2
        twos += 1
    residue = pow(base, odd, number)
    if residue in (1, number - 1):
        return False
    for _ in range(twos - 1):
        residue = residue * residue % number
        if residue == number - 1:
            return False
    return True


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


def small_factors(number: int, primes: list[int], bound: int) -> set[int]:
    """The prime factors of `number` that are at most `bound`."""
    found, remaining = set(), number
    for prime in primes:
        if prime * prime > remaining:
            break
        if remaining % prime == 0:
            found.add(prime)
            while remaining % prime == 0:
                remaining //= prime
    if 1 < remaining <= bound:
        found.add(remaining)
    return found


def exposed_set(bound: int) -> dict[int, list[int]]:
    """`E_q(B)` for every prime `q <= B`, as a map q -> the exposed composites."""
    limit = bound * bound
    flags = sieve(limit)
    primes = [n for n in range(2, bound + 1) if flags[n]]
    exposed: dict[int, list[int]] = {}
    for number in range(4, limit + 1):
        if flags[number]:
            continue
        factors = small_factors(number, primes, bound)
        if len(factors) == 1:
            exposed.setdefault(next(iter(factors)), []).append(number)
    return exposed


def unwitnessed(bound: int) -> list[tuple[int, int]]:
    """Exposed `n` with no strong witness among the retained primes.

    Empty means: dropping any single sensor keeps the hybrid anatomy sound at
    this frontier.  A nonempty result would refute the permanence half of
    `PINNING.md` and partly rehabilitate the slogan it struck.
    """
    primes = [n for n in range(2, bound + 1) if sieve(bound)[n]]
    failures = []
    for dropped, numbers in exposed_set(bound).items():
        retained = [p for p in primes if p != dropped]
        for number in numbers:
            if not any(strong_refutes(p, number) for p in retained):
                failures.append((dropped, number))
    return failures


def fermat_nonwitnesses_of_prime_power(prime: int, power: int) -> list[int]:
    """Bases failing to refute `q^a` by Fermat -- Lemma W's subgroup.

    **Lemma W.**  Let `q` be an odd prime, `a >= 2`, `n = q^a`.  For `b` prime
    to `q`,
        b^(n-1) = 1 (mod n)   <==>   b^(q-1) = 1 (mod q^a),
    and these `b` form the unique subgroup of order `q-1` in the cyclic group
    `(Z/q^a)^*`, hence of index `q^(a-1)`.

    *Proof.*  `ord(b)` divides `n - 1 = q^a - 1` and also
    `|(Z/q^a)^*| = q^(a-1)(q-1)`.  Since `gcd(q^a - 1, q) = 1`, the gcd of
    those two is `gcd(q^a - 1, q - 1) = q - 1`, because `(q-1) | (q^a - 1)`.
    So `ord(b) | q - 1`, which is the stated congruence; and the elements of
    order dividing `q-1` in a cyclic group form its unique subgroup of that
    order.  []
    """
    modulus = prime ** power
    return [b for b in range(2, modulus)
            if b % prime and pow(b, modulus - 1, modulus) == 1]


def is_wieferich(prime: int) -> bool:
    """`2^(q-1) = 1 (mod q^2)`.  Corollary W1: exactly when base 2 fails on q^2."""
    return pow(2, prime - 1, prime * prime) == 1


def cyclotomic_head_depth(prime: int) -> int:
    """`e = v_q(2^ord_q(2) - 1)`, the CYCLOTOMIC_SENSOR head depth at base 2."""
    return valuation(2 ** multiplicative_order(2, prime) - 1, prime)


def head_depth_equals_wieferich(prime: int) -> bool:
    """**Corollary W2.**  `e_q >= 2  <==>  q is Wieferich  <==>  2 fails on q^2`.

    *Proof.*  Write `d = ord_q(2)`.  If `q^2 | 2^d - 1` then, since `d | q-1`,
    also `q^2 | 2^(q-1) - 1`.  Conversely if `q^2 | 2^(q-1) - 1` then
    `ord_{q^2}(2)` divides `q - 1`; but `ord_{q^2}(2)` is `d` or `qd`, and `qd`
    cannot divide `q - 1` because `q` does not; so it is `d`, giving
    `q^2 | 2^d - 1`.  []

    So the cyclotomic organ's anomalous head and the failure of base 2 to
    remove pinning at `q^2` are one event, not two.
    """
    return (cyclotomic_head_depth(prime) >= 2) == is_wieferich(prime)


def main() -> None:
    print("Localization: only the exposed set can lose a dropped sensor.\n")
    print("  B    N = B^2   exposed   unwitnessed")
    for bound in (60, 100, 200):
        failures = unwitnessed(bound)
        total = sum(len(v) for v in exposed_set(bound).values())
        print(f"  {bound:3}   {bound*bound:7}   {total:7}   {len(failures)}")
    print("\nLemma W: on q^a the Fermat non-witnesses are a subgroup of index q^(a-1)")
    for prime in (5, 7, 11):
        for power in (2, 3):
            found = len(fermat_nonwitnesses_of_prime_power(prime, power))
            print(f"  q={prime} a={power}: {found} non-witnesses below q^a,"
                  f" subgroup order q-1 = {prime-1}")
    print("\nCorollary W1/W2: the exception is Wieferich, and it is the same event")
    print("  q      ord_q(2)   head depth e   Wieferich   base 2 refutes q^2")
    for prime in (11, 13, 1091, 1093, 3511):
        print(f"  {prime:5}   {multiplicative_order(2, prime):8}"
              f"   {cyclotomic_head_depth(prime):12}"
              f"   {str(is_wieferich(prime)):9}"
              f"   {strong_refutes(2, prime * prime)}")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Sensor freedom exists only where the anatomy cannot be permanent.

`notes/ARITHMETIC_LIFE_ADVERSARIAL_AUDIT.md` T5 showed that under the
residue-divisibility certificate the organism's sensor set has *zero* degrees of
freedom: soundness holds iff every prime below the frontier is active, and any
omission is falsified by a prime square.  The escape recorded there (seed 1')
was that T5 is conditional on the certificate form, and that under a
Fermat/Pratt-style certificate the sensor is a *base* rather than a modulus --
and bases are not forced by divisibility, so the anatomy might finally have
choices to make.

This module settles seed 1'.  The answer is: choices exist, but exactly where
they exist the anatomy cannot be retained.

* **Fermat scheme.**  On a Carmichael number the Fermat test degenerates to
  trial division: a base refutes `n` if and only if it shares a prime factor
  with `n`.  So the freedom is illusory on precisely the inputs where the test
  is weakest, and T5's forcing returns.
* **Strong (Miller-Rabin) scheme.**  No Carmichael analogue: by Rabin's
  theorem at least 3/4 of bases witness every odd composite, so at each `n`
  there is genuine choice.  But no *fixed* base set is sound -- `{2}` fails at
  2047, `{2,3}` at 1373653, both verified least here by exhaustive scan.

Hence sensor selection is a real phenomenon only under the strong certificate,
and only for anatomies chosen per encounter and discarded.  The permanent
anatomy of `ARITHMETIC_LIFE_FIRST_EXECUTION` (5) is incompatible with the only
certificate class that offers a choice.

Prior art consumed, not rediscovered: Korselt's criterion (1899); Carmichael's
numbers (1910); Rabin's 3/4 witness bound (1980); the least strong pseudoprimes
to small base sets (Pomerance-Selfridge-Wagstaff 1980).  Nothing here claims
novelty for those.  What is new is only the reading: which certificate forms
leave the anatomy free, and at what cost.
"""

from __future__ import annotations

from math import gcd


def is_prime(number: int) -> bool:
    """Exact trial division -- the organism's own divisibility certificate."""
    if number < 2:
        return False
    divisor = 2
    while divisor * divisor <= number:
        if number % divisor == 0:
            return False
        divisor += 1
    return True


def squarefree_factors(number: int) -> list[int] | None:
    """Distinct primes of `number`, or None if a square divides it."""
    remaining, primes, divisor = number, [], 2
    while divisor * divisor <= remaining:
        if remaining % divisor == 0:
            exponent = 0
            while remaining % divisor == 0:
                remaining //= divisor
                exponent += 1
            if exponent > 1:
                return None
            primes.append(divisor)
        divisor += 1
    if remaining > 1:
        primes.append(remaining)
    return primes


def is_carmichael(number: int) -> bool:
    """Korselt: composite, squarefree, and `(p-1) | (n-1)` for every `p | n`."""
    if number < 2 or number % 2 == 0 or is_prime(number):
        return False
    primes = squarefree_factors(number)
    if primes is None or len(primes) < 2:
        return False
    return all((number - 1) % (prime - 1) == 0 for prime in primes)


def fermat_refutes(base: int, number: int) -> bool:
    """Does this base certify `number` composite by the Fermat test?"""
    return pow(base, number - 1, number) != 1


def strong_refutes(base: int, number: int) -> bool:
    """Does this base certify `number` composite by the strong (MR) test?"""
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


def fermat_degenerates(number: int) -> bool:
    """Theorem F, checked at one `number`: refuters are exactly the non-units.

    **Theorem F.**  Let `n` be a Carmichael number and `2 <= a <= n-1`.  Then
    `a^(n-1) != 1 (mod n)` if and only if `gcd(a, n) > 1`.

    *Proof.*  (<=)  Put `g = gcd(a,n) > 1`.  If `a^(n-1) = 1 (mod n)` then
    `g | n | a^(n-1) - 1`, while `g | a | a^(n-1)`; so `g | 1`, contradiction.
    (=>)  Suppose `gcd(a,n) = 1`.  For each prime `p | n` the order of `a`
    modulo `p` divides `p - 1`, which divides `n - 1` by Korselt, so
    `a^(n-1) = 1 (mod p)`.  As `n` is squarefree, CRT gives
    `a^(n-1) = 1 (mod n)`.  []

    **Corollary.**  A Fermat anatomy `A` refutes a Carmichael `n` iff some
    element of `A` shares a prime factor with `n`.  The minimal such elements
    are the primes dividing `n`, so soundness on the Carmichael family forces
    the anatomy to contain a prime divisor of each -- which is T5's divisibility
    forcing, recovered inside the Fermat scheme.
    """
    if not is_carmichael(number):
        raise ValueError("Theorem F is a statement about Carmichael numbers")
    refuters = {a for a in range(2, number) if fermat_refutes(a, number)}
    non_units = {a for a in range(2, number) if gcd(a, number) > 1}
    return refuters == non_units


def carmichael_numbers(limit: int) -> list[int]:
    return [n for n in range(3, limit, 2) if is_carmichael(n)]


def least_strong_pseudoprime(bases: tuple[int, ...], limit: int) -> int | None:
    """Least odd composite passing every base, by exhaustive scan -- a proof."""
    candidate = 9
    while candidate < limit:
        if not is_prime(candidate) and not any(
                strong_refutes(base, candidate) for base in bases):
            return candidate
        candidate += 2
    return None


def freedom_at(number: int, scheme: str = "strong") -> int:
    """How many bases in [2, n-2] certify `number` composite.

    This counts the admissible one-sensor anatomies at `number`.  Under
    divisibility the analogous count is 1 (only the least prime factor is
    minimal, and T5 forces the whole set); under Fermat on a Carmichael number
    it is exactly the non-unit count; under the strong test it is a large
    fraction of everything.
    """
    refutes = strong_refutes if scheme == "strong" else fermat_refutes
    return sum(refutes(a, number) for a in range(2, number - 1))


def main() -> None:
    carmichaels = carmichael_numbers(10_000)
    print("Theorem F -- on a Carmichael number the Fermat test IS trial division")
    print("  n      Fermat refuters == non-units?   units (all inert)")
    for number in carmichaels:
        units = sum(1 for a in range(2, number) if gcd(a, number) == 1)
        print(f"  {number:5}        {str(fermat_degenerates(number)):5}"
              f"                    {units}")
    print(f"  verified for every Carmichael number below 10000\n")

    print("Strong scheme -- genuine choice at each n, no sound fixed anatomy")
    for number in carmichaels[:4]:
        witnesses = freedom_at(number, "strong")
        print(f"  n={number:5}  strong witnesses {witnesses}/{number - 3}"
              f"   Fermat witnesses {freedom_at(number, 'fermat')}/{number - 3}")
    for bases, known in (((2,), 2047), ((2, 3), 1373653)):
        least = least_strong_pseudoprime(bases, known + 2)
        print(f"  fixed anatomy {bases}: least composite it certifies prime"
              f" = {least} (known {known})")


if __name__ == "__main__":
    main()

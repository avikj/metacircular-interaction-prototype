#!/usr/bin/env python3
"""Exact/200-bit normalization checks for RATIONAL_FIBER_SPECTRUM.md.

This is a falsifier for formulas (1.1)--(1.3) and (2.2), not evidence for a
new number-theoretic theorem.
"""

from fractions import Fraction
from math import gcd

import mpmath as mp


mp.mp.dps = 70  # More than 200 binary bits.


def require(condition: bool, message: object) -> None:
    if not condition:
        raise AssertionError(message)


def prime_factors(n: int) -> list[int]:
    factors = []
    p = 2
    while p * p <= n:
        if n % p == 0:
            factors.append(p)
            while n % p == 0:
                n //= p
        p += 1
    if n > 1:
        factors.append(n)
    return factors


def mobius(n: int) -> int:
    result = 1
    p = 2
    while p * p <= n:
        if n % p == 0:
            n //= p
            result = -result
            if n % p == 0:
                return 0
            while n % p == 0:
                n //= p
        p += 1
    return -result if n > 1 else result


def phi(n: int) -> int:
    result = n
    for p in prime_factors(n):
        result = result // p * (p - 1)
    return result


def divisors(n: int) -> list[int]:
    return [d for d in range(1, n + 1) if n % d == 0]


def ramanujan_sum(q: int, h: int) -> int:
    d = gcd(q, h)
    quotient = q // d
    return mobius(quotient) * phi(q) // phi(quotient)


def local_correlation_spectral(W: int, h: int) -> Fraction:
    return sum(
        (
            Fraction(mobius(q), phi(q)) ** 2
            * ramanujan_sum(q, h)
        )
        for q in divisors(W)
    )


def local_correlation_direct(W: int, h: int) -> Fraction:
    phi_W = phi(W)
    joint = sum(
        gcd(x, W) == 1 and gcd((x + h) % W, W) == 1
        for x in range(W)
    )
    return Fraction(joint * W, phi_W * phi_W)


def q5_character(j: int, n: int) -> mp.mpc:
    """The four characters mod 5, with generator 2 and chi_j(2)=i^j."""
    residue = n % 5
    if residue == 0:
        return mp.mpc(0)
    discrete_log = {1: 0, 2: 1, 4: 2, 3: 3}[residue]
    return mp.exp(2j * mp.pi * j * discrete_log / 4)


def e5(n: int) -> mp.mpc:
    return mp.exp(2j * mp.pi * n / 5)


def tau_conjugate_q5(j: int) -> mp.mpc:
    return sum(mp.conj(q5_character(j, r)) * e5(r) for r in range(5))


def mangoldt(n: int) -> mp.mpf:
    """Exact support test with a high-precision logarithmic value."""
    if n < 2:
        return mp.mpf(0)
    factors = prime_factors(n)
    if len(factors) != 1:
        return mp.mpf(0)
    return mp.log(factors[0])


def check_q5_unweighted_character_identity() -> mp.mpf:
    """Check (1.1), extended by its full nonunit indicator."""
    worst = mp.mpf("0")
    for a in range(1, 5):
        for n in range(1, 21):
            character_part = sum(
                tau_conjugate_q5(j)
                * q5_character(j, a)
                * q5_character(j, n)
                for j in range(4)
            ) / 4
            nonunit_correction = e5(a * n) if gcd(n, 5) > 1 else 0
            error = abs(e5(a * n) - character_part - nonunit_correction)
            worst = max(worst, error)

    # The principal Gauss sum is the pole residue numerator mu(5)=-1.
    worst = max(worst, abs(tau_conjugate_q5(0) - mobius(5)))
    return worst


def check_q5_mangoldt_identity() -> mp.mpf:
    """Check the actual von Mangoldt identity (1.2)--(1.3)."""
    worst = mp.mpf("0")
    for a in range(1, 5):
        for n in range(1, 201):
            weight = mangoldt(n)
            character_part = sum(
                tau_conjugate_q5(j)
                * q5_character(j, a)
                * weight
                * q5_character(j, n)
                for j in range(4)
            ) / 4
            # Among nonunits, Lambda is supported only on 5^k.
            local_correction = weight * e5(a * n) if prime_factors(n) == [5] else 0
            error = abs(weight * e5(a * n) - character_part - local_correction)
            worst = max(worst, error)

    # Explicitly include both sides of the support distinction that the
    # unweighted identity cannot test.
    require(all(mangoldt(n) == 0 for n in [10, 15, 20, 30, 45]),
            "composite non-prime-power support failure")
    require(all(mangoldt(n) == mp.log(5) for n in [5, 25, 125]),
            "p|q prime-power support failure")
    return worst


def main() -> None:
    if not __debug__:
        raise RuntimeError("Do not run this certificate with python -O")

    character_error = check_q5_unweighted_character_identity()
    require(character_error < mp.mpf("1e-60"), character_error)
    mangoldt_error = check_q5_mangoldt_identity()
    require(mangoldt_error < mp.mpf("1e-60"), mangoldt_error)

    q6_values = []
    for h in range(6):
        direct = local_correlation_direct(6, h)
        spectral = local_correlation_spectral(6, h)
        require(direct == spectral, (h, direct, spectral))
        q6_values.append(direct)
    require(q6_values == [
        Fraction(3),
        Fraction(0),
        Fraction(3, 2),
        Fraction(0),
        Fraction(3, 2),
        Fraction(0),
    ], q6_values)

    W = 30030
    checked_shifts = [0, 1, 2, 6, 30, 210, 2310]
    for h in checked_shifts:
        direct = local_correlation_direct(W, h)
        spectral = local_correlation_spectral(W, h)
        require(direct == spectral, (W, h, direct, spectral))

    print(f"q=5 character identity worst error: {mp.nstr(character_error, 6)}")
    print(f"q=5 Mangoldt identity worst error: {mp.nstr(mangoldt_error, 6)}")
    print(f"q=6 exact correlations: {q6_values}")
    print(f"W={W} exact shifts checked: {checked_shifts}")
    print("PASS")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Ramanujan sums as divisor convolution and exact cyclotomic traces."""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd

Polynomial = tuple[int, ...]  # ascending coefficients


def divisors(n: int) -> tuple[int, ...]:
    return tuple(d for d in range(1, n + 1) if n % d == 0)


def mobius(n: int) -> int:
    primes = 0
    p = 2
    remaining = n
    while p * p <= remaining:
        if remaining % p == 0:
            remaining //= p
            primes += 1
            if remaining % p == 0:
                return 0
            while remaining % p == 0:
                remaining //= p
        p += 1
    if remaining > 1:
        primes += 1
    return -1 if primes % 2 else 1


def monic_divide(numerator: Polynomial, denominator: Polynomial) -> Polynomial:
    if not denominator or denominator[-1] != 1:
        raise ValueError("denominator must be monic")
    work = list(numerator)
    degree = len(denominator) - 1
    quotient = [0] * max(len(work) - degree, 0)
    while len(work) - 1 >= degree:
        coefficient = work[-1]
        shift = len(work) - len(denominator)
        quotient[shift] = coefficient
        for i, value in enumerate(denominator):
            work[shift + i] -= coefficient * value
        while work and work[-1] == 0:
            work.pop()
    if any(work):
        raise ValueError("polynomial division was not exact")
    return tuple(quotient)


def cyclotomic_polynomials(up_to: int) -> dict[int, Polynomial]:
    result: dict[int, Polynomial] = {}
    for n in range(1, up_to + 1):
        polynomial = (-1,) + (0,) * (n - 1) + (1,)
        for d in divisors(n)[:-1]:
            polynomial = monic_divide(polynomial, result[d])
        result[n] = polynomial
    return result


def multiply_mod(left: Polynomial, right: Polynomial, modulus: Polynomial) -> Polynomial:
    degree = len(modulus) - 1
    work = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            work[i + j] += a * b
    for k in range(len(work) - 1, degree - 1, -1):
        coefficient = work[k]
        if coefficient:
            for j in range(degree):
                work[k - degree + j] -= coefficient * modulus[j]
    return tuple((work + [0] * degree)[:degree])


def power_x_mod(exponent: int, modulus: Polynomial) -> Polynomial:
    degree = len(modulus) - 1
    result = (1,) + (0,) * (degree - 1)
    base = ((0, 1) + (0,) * (degree - 2)) if degree > 1 else (-modulus[0],)
    power = exponent
    while power:
        if power & 1:
            result = multiply_mod(result, base, modulus)
        base = multiply_mod(base, base, modulus)
        power //= 2
    return result


def multiplication_trace(element: Polynomial, modulus: Polynomial) -> int:
    degree = len(modulus) - 1
    trace = 0
    for column in range(degree):
        basis = (0,) * column + (1,) + (0,) * (degree - column - 1)
        image = multiply_mod(element, basis, modulus)
        trace += image[column]
    return trace


def ramanujan_convolution(modulus: int, exponent: int) -> int:
    return sum(d * mobius(modulus // d)
               for d in divisors(gcd(modulus, exponent)))


@dataclass(frozen=True)
class RamanujanTraceCertificate:
    modulus: int
    cyclotomic: Polynomial
    values: tuple[int, ...]
    spectral_traces: tuple[int, ...]
    full_group_algebra_traces: tuple[int, ...]


def compile_ramanujan_trace(modulus: int) -> RamanujanTraceCertificate:
    """Check c_q(n) in arithmetic and cyclotomic trace coordinates."""
    if modulus < 2:
        raise ValueError("modulus must be at least two")
    phi = cyclotomic_polynomials(modulus)[modulus]
    arithmetic = tuple(ramanujan_convolution(modulus, n)
                       for n in range(modulus))
    spectral = tuple(multiplication_trace(power_x_mod(n, phi), phi)
                     for n in range(modulus))
    if arithmetic != spectral:
        raise AssertionError("divisor convolution and cyclotomic trace disagree")
    # False-control carrier Q[x]/(x^q-1): its regular trace retains all q-th
    # roots, not only the primitive spectrum.
    full = tuple(modulus if n == 0 else 0 for n in range(modulus))
    return RamanujanTraceCertificate(modulus, phi, arithmetic, spectral, full)


if __name__ == "__main__":
    result = compile_ramanujan_trace(12)
    print(result)
    print("ALL EXACT CHECKS PASS")

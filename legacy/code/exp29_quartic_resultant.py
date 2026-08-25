#!/usr/bin/env python3
"""Exact finite checks for the parity-resultant quartic reduction.

For a quartic

    g(x) = x^4 + a*x^3 + b*x^2 + c*x + 1

dividing a polynomial with P(x)+P(-x)=2, notes/PARITY_RESULTANT.md proves

    a^2 - a*b*c + c^2 = +/-1.

The odd-support annulus and conjugate-pair Vieta bounds give
|a|,|c| <= 4 and -1 <= b <= 6.  This
script enumerates that exact Diophantine box.  Optionally it also divides
every odd-support 0-1 polynomial

    1 + x + x^3 + sum_{odd 5 <= j <= N} epsilon_j*x^j

by every candidate, using integer arithmetic only.  The bounded scan is
corroboration, not a proof about arbitrary degree.
"""

from __future__ import annotations

import argparse
import itertools
from collections import Counter


def quartic_candidates() -> list[tuple[int, int, int, int]]:
    """Return (a,b,c,D) in the proved Vieta box with D=+/-1."""
    out: list[tuple[int, int, int, int]] = []
    for a in range(-4, 5):
        for b in range(-1, 7):
            for c in range(-4, 5):
                discriminant_unit = a * a - a * b * c + c * c
                if abs(discriminant_unit) == 1:
                    out.append((a, b, c, discriminant_unit))
    return out


def divides(coefficients: list[int], divisor: list[int]) -> bool:
    """Exact monic polynomial division; coefficients are ascending."""
    remainder = coefficients[:]
    while remainder and remainder[-1] == 0:
        remainder.pop()
    while len(remainder) >= len(divisor):
        quotient_term = remainder[-1]
        offset = len(remainder) - len(divisor)
        if quotient_term:
            for index, value in enumerate(divisor):
                remainder[offset + index] -= quotient_term * value
        while remainder and remainder[-1] == 0:
            remainder.pop()
    return not remainder


def scan_odd_support(
    candidates: list[tuple[int, int, int, int]], max_degree: int
) -> tuple[int, Counter[tuple[int, int, int]]]:
    if max_degree < 5 or max_degree % 2 == 0:
        raise ValueError("--max-odd-degree must be an odd integer at least 5")
    optional_exponents = list(range(5, max_degree + 1, 2))
    hits: Counter[tuple[int, int, int]] = Counter()
    tested = 0
    for bits in itertools.product((0, 1), repeat=len(optional_exponents)):
        polynomial = [0] * (max_degree + 1)
        polynomial[0] = polynomial[1] = polynomial[3] = 1
        for bit, exponent in zip(bits, optional_exponents):
            polynomial[exponent] = bit
        tested += 1
        for a, b, c, _ in candidates:
            # ascending coefficients: 1 + c*x + b*x^2 + a*x^3 + x^4
            if divides(polynomial, [1, c, b, a, 1]):
                hits[(a, b, c)] += 1
    return tested, hits


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--max-odd-degree",
        type=int,
        default=19,
        help="largest optional odd exponent in the bounded scan (default: 19)",
    )
    args = parser.parse_args()

    candidates = quartic_candidates()
    print("# parity-resultant quartic candidates")
    print(f"raw_unit_equation_candidates={len(candidates)}")
    print(
        "D_sign_counts="
        f"{dict(sorted(Counter(item[3] for item in candidates).items()))}"
    )

    tested, hits = scan_odd_support(candidates, args.max_odd_degree)
    print(f"odd_support_polynomials_tested={tested}")
    print(f"max_odd_degree={args.max_odd_degree}")
    print(f"quartic_hit_counts={dict(sorted(hits.items()))}")


if __name__ == "__main__":
    main()

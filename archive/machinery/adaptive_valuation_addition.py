#!/usr/bin/env python3
"""Adaptive prime-power sensing for the valuation of an integer sum."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


def _validate_prime(prime: int) -> None:
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")


@dataclass(frozen=True)
class RefinementStep:
    depth: int
    modulus: int
    left_residue: int
    right_residue: int
    sum_residue: int


@dataclass(frozen=True)
class ValuationCertificate:
    prime: int
    valuation: int | None
    is_zero: bool
    steps: tuple[RefinementStep, ...]


def adaptive_sum_valuation(a: int, b: int, prime: int) -> ValuationCertificate:
    """Return v_p(a+b) using the least sufficient residue depth.

    ``valuation=None`` denotes infinity and is accompanied by the exact
    equality certificate ``a == -b``. For a nonzero sum of valuation v, the
    trace has exactly v+1 entries.
    """
    _validate_prime(prime)
    if a == -b:
        return ValuationCertificate(prime, None, True, ())

    steps: list[RefinementStep] = []
    modulus = 1
    depth = 0
    while True:
        depth += 1
        modulus *= prime
        left = a % modulus
        right = b % modulus
        total = (left + right) % modulus
        steps.append(RefinementStep(depth, modulus, left, right, total))
        if total != 0:
            return ValuationCertificate(prime, depth - 1, False, tuple(steps))


def verify_certificate(a: int, b: int, certificate: ValuationCertificate) -> bool:
    """Independently replay exactness and minimality of a certificate."""
    _validate_prime(certificate.prime)
    if certificate.is_zero:
        return certificate.valuation is None and not certificate.steps and a == -b
    if certificate.valuation is None or not certificate.steps:
        return False
    prime = certificate.prime
    for expected_depth, step in enumerate(certificate.steps, 1):
        modulus = prime ** expected_depth
        if step != RefinementStep(
            expected_depth, modulus, a % modulus, b % modulus, (a + b) % modulus
        ):
            return False
        if expected_depth < len(certificate.steps) and step.sum_residue != 0:
            return False
    last = certificate.steps[-1]
    return (
        last.sum_residue != 0
        and certificate.valuation == len(certificate.steps) - 1
    )


if __name__ == "__main__":
    example = adaptive_sum_valuation(1, 3**7 - 1, 3)
    print(example)
    print("certificate valid:", verify_certificate(1, 3**7 - 1, example))


#!/usr/bin/env python3
"""Optimal adaptive identification by p-adic valuation probes."""

from __future__ import annotations

from dataclasses import dataclass

from valuation_future_residue import truncated_valuation


@dataclass(frozen=True)
class AdaptiveProbeStep:
    level: int
    candidate_digit: int
    center: int
    response: int


@dataclass(frozen=True)
class AdaptiveProbeCertificate:
    prime: int
    depth: int
    residue: int
    steps: tuple[AdaptiveProbeStep, ...]


def identify_residue(
    residue: int, prime: int, depth: int
) -> AdaptiveProbeCertificate:
    """Identify a residue digitwise using at most k(p-1) probes."""
    modulus = prime**depth
    truncated_valuation(0, prime, depth)  # validate chart
    target = residue % modulus
    prefix = 0
    place = 1
    steps: list[AdaptiveProbeStep] = []
    for level in range(depth):
        chosen = prime - 1
        for digit in range(prime - 1):
            center = prefix + digit * place
            response = truncated_valuation(target - center, prime, depth)
            steps.append(AdaptiveProbeStep(level, digit, center, response))
            if response >= level + 1:
                chosen = digit
                break
        prefix += chosen * place
        place *= prime
    if prefix != target:
        raise AssertionError("adaptive reconstruction failed")
    return AdaptiveProbeCertificate(prime, depth, target, tuple(steps))


def verify_adaptive_certificate(certificate: AdaptiveProbeCertificate) -> bool:
    """Replay the decision transcript and its exact reconstruction."""
    try:
        expected = identify_residue(
            certificate.residue, certificate.prime, certificate.depth
        )
    except (ValueError, AssertionError):
        return False
    return (
        certificate == expected
        and len(certificate.steps) <= certificate.depth * (certificate.prime - 1)
    )


def worst_case_residue(prime: int, depth: int) -> int:
    """All digits p-1 force every test at every level."""
    truncated_valuation(0, prime, depth)
    return prime**depth - 1


if __name__ == "__main__":
    for prime, depth in ((2, 5), (3, 4), (5, 3)):
        residue = worst_case_residue(prime, depth)
        certificate = identify_residue(residue, prime, depth)
        print(
            f"p={prime}, k={depth}, residue={residue}, "
            f"probes={len(certificate.steps)}, bound={depth * (prime - 1)}, "
            f"valid={verify_adaptive_certificate(certificate)}"
        )

#!/usr/bin/env python3
"""Minimum translation-probe bases for truncated p-adic valuation."""

from __future__ import annotations

from dataclasses import dataclass

from valuation_future_residue import truncated_valuation


def canonical_probe_basis(prime: int, depth: int) -> tuple[int, ...]:
    """Choose all but the last leaf in every mod-p^(k-1) sibling block."""
    # Validate before using depth in an exponent.
    truncated_valuation(0, prime, depth)
    modulus = prime**depth
    parent_modulus = prime ** (depth - 1)
    return tuple(
        parent + digit * parent_modulus
        for parent in range(parent_modulus)
        for digit in range(prime - 1)
        if parent + digit * parent_modulus < modulus
    )


def response_vector(
    residue: int, centers: tuple[int, ...], prime: int, depth: int
) -> tuple[int, ...]:
    return tuple(
        truncated_valuation(residue - center, prime, depth)
        for center in centers
    )


def collision(
    centers: tuple[int, ...], prime: int, depth: int
) -> tuple[int, int] | None:
    """Return the first unresolved pair, or None when centers separate."""
    modulus = prime**depth
    seen: dict[tuple[int, ...], int] = {}
    for residue in range(modulus):
        signature = response_vector(residue, centers, prime, depth)
        if signature in seen:
            return seen[signature], residue
        seen[signature] = residue
    return None


@dataclass(frozen=True)
class ProbeBasisCertificate:
    prime: int
    depth: int
    centers: tuple[int, ...]
    sibling_blocks: tuple[tuple[int, ...], ...]


def form_minimum_probe_basis(prime: int, depth: int) -> ProbeBasisCertificate:
    centers = canonical_probe_basis(prime, depth)
    parent_modulus = prime ** (depth - 1)
    blocks = tuple(
        tuple(parent + digit * parent_modulus for digit in range(prime))
        for parent in range(parent_modulus)
    )
    return ProbeBasisCertificate(prime, depth, centers, blocks)


def verify_minimum_certificate(certificate: ProbeBasisCertificate) -> bool:
    """Replay separation and the sharp sibling-block lower bound."""
    prime, depth = certificate.prime, certificate.depth
    try:
        expected = form_minimum_probe_basis(prime, depth)
    except (ValueError, ZeroDivisionError):
        return False
    if certificate != expected:
        return False
    if collision(certificate.centers, prime, depth) is not None:
        return False
    center_set = set(certificate.centers)
    if any(sum(value in center_set for value in block) != prime - 1
           for block in certificate.sibling_blocks):
        return False
    return len(certificate.centers) == (prime - 1) * prime ** (depth - 1)


if __name__ == "__main__":
    certificate = form_minimum_probe_basis(3, 3)
    print("minimum size:", len(certificate.centers))
    print("centers:", certificate.centers)
    print("certificate valid:", verify_minimum_certificate(certificate))
    reduced = certificate.centers[:-1]
    print("collision after deleting one center:", collision(reduced, 3, 3))

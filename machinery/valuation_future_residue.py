#!/usr/bin/env python3
"""Formation of exact residues from the future behavior of truncated valuation."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


def _chart(prime: int, depth: int) -> int:
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")
    if depth < 1:
        raise ValueError("depth must be positive")
    return prime**depth


def truncated_valuation(residue: int, prime: int, depth: int) -> int:
    """Return min(v_p(residue), depth) on Z/p^depth."""
    modulus = _chart(prime, depth)
    value = residue % modulus
    if value == 0:
        return depth
    valuation = 0
    while value % prime == 0:
        valuation += 1
        value //= prime
    return valuation


def future_signature(residue: int, prime: int, depth: int) -> tuple[int, ...]:
    """All truncated-valuation responses after translations c in Z/p^depth."""
    modulus = _chart(prime, depth)
    return tuple(
        truncated_valuation(residue + continuation, prime, depth)
        for continuation in range(modulus)
    )


def reconstruct_residue(signature: tuple[int, ...], prime: int, depth: int) -> int:
    """Recover r from the unique continuation c with depth-k response."""
    modulus = _chart(prime, depth)
    if len(signature) != modulus:
        raise ValueError("signature length does not match the chart")
    zeros = [continuation for continuation, value in enumerate(signature) if value == depth]
    if len(zeros) != 1:
        raise ValueError("signature must have exactly one zero-producing continuation")
    residue = (-zeros[0]) % modulus
    if future_signature(residue, prime, depth) != signature:
        raise ValueError("signature is not a lawful valuation future")
    return residue


@dataclass(frozen=True)
class ProfileCollision:
    prime: int
    depth: int
    left: tuple[int, int]
    right: tuple[int, int]
    continuation: int


def noncongruence_control(prime: int) -> ProfileCollision:
    """Return uniform fixed-profile pairs separated by one common append."""
    if prime == 2:
        return ProfileCollision(2, 3, (1, 2), (1, 6), 1)
    if prime == 3:
        return ProfileCollision(3, 2, (1, 1), (1, 4), 4)
    _chart(prime, 1)
    return ProfileCollision(prime, 2, (1, 1), (1, 2), prime - 2)


def pair_profile(pair: tuple[int, int], prime: int, depth: int) -> tuple[int, int, int]:
    return (
        truncated_valuation(pair[0], prime, depth),
        truncated_valuation(pair[1], prime, depth),
        truncated_valuation(pair[0] + pair[1], prime, depth),
    )


if __name__ == "__main__":
    signature = future_signature(17, 3, 3)
    print("formed residue:", reconstruct_residue(signature, 3, 3))
    for prime in (2, 3, 5, 7):
        control = noncongruence_control(prime)
        print(prime, control, pair_profile(control.left, prime, control.depth),
              pair_profile(control.right, prime, control.depth))

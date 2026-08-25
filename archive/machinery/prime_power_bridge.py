#!/usr/bin/env python3
"""Exact bridge between prime-power residues and truncated valuations."""

from __future__ import annotations

from math import isqrt


def _validate(prime: int, depth: int) -> None:
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")
    if depth < 1:
        raise ValueError("depth must be positive")


def truncated_valuation(n: int, prime: int, depth: int) -> int:
    """Return min(v_p(n), depth), with v_p(0)=infinity."""
    _validate(prime, depth)
    residue = n % (prime ** depth)
    if residue == 0:
        return depth
    value = 0
    while residue % prime == 0:
        value += 1
        residue //= prime
    return value


def residue_coordinates(n: int, prime: int, depth: int) -> tuple[int, int | None]:
    """Decompose n mod p^k into depth j and its unit mod p^(k-j)."""
    _validate(prime, depth)
    modulus = prime ** depth
    residue = n % modulus
    valuation = truncated_valuation(residue, prime, depth)
    if valuation == depth:
        return depth, None
    return valuation, (residue // (prime ** valuation)) % (prime ** (depth - valuation))


def reconstruct_residue(
    valuation: int, unit: int | None, prime: int, depth: int,
) -> int:
    """Invert residue_coordinates on its exact finite codomain."""
    _validate(prime, depth)
    if not 0 <= valuation <= depth:
        raise ValueError("truncated valuation outside its range")
    if valuation == depth:
        if unit is not None:
            raise ValueError("zero stratum has no unit coordinate")
        return 0
    unit_modulus = prime ** (depth - valuation)
    if unit is None or not 0 <= unit < unit_modulus or unit % prime == 0:
        raise ValueError("unit coordinate must be a canonical local unit")
    return (prime ** valuation) * unit

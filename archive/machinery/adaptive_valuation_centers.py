#!/usr/bin/env python3
"""Adaptive exact reconstruction in Z/p^k from translated valuations."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


def _validate(prime: int, depth: int) -> None:
    if depth < 1:
        raise ValueError("depth must be positive")
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")


def truncated_valuation(value: int, prime: int, depth: int) -> int:
    modulus = prime**depth
    value %= modulus
    if value == 0:
        return depth
    result = 0
    while value % prime == 0:
        value //= prime
        result += 1
    return result


@dataclass(frozen=True)
class CenterQuery:
    digit_depth: int
    tested_digit: int
    center: int
    response: int


@dataclass(frozen=True)
class Reconstruction:
    residue: int
    queries: tuple[CenterQuery, ...]


def reconstruct_residue(residue: int, prime: int, depth: int) -> Reconstruction:
    """Reconstruct residue with at most (p-1)k adaptive valuation queries."""
    _validate(prime, depth)
    modulus = prime**depth
    hidden = residue % modulus
    prefix = 0
    queries: list[CenterQuery] = []
    for level in range(depth):
        place = prime**level
        chosen = prime - 1
        for digit in range(prime - 1):
            candidate = prefix + digit * place
            center = (-candidate) % modulus
            response = truncated_valuation(hidden + center, prime, depth)
            queries.append(CenterQuery(level + 1, digit, center, response))
            if response >= level + 1:
                chosen = digit
                break
        prefix += chosen * place
    if prefix != hidden:
        raise AssertionError("adaptive reconstruction failed")
    return Reconstruction(prefix, tuple(queries))


def nonadaptive_minimum_centers(prime: int, depth: int) -> int:
    _validate(prime, depth)
    return (prime - 1) * prime ** (depth - 1)


def adaptive_upper_bound(prime: int, depth: int) -> int:
    _validate(prime, depth)
    return (prime - 1) * depth


if __name__ == "__main__":
    result = reconstruct_residue(73, 3, 4)
    print({
        "residue": result.residue,
        "queries": len(result.queries),
        "adaptive_bound": adaptive_upper_bound(3, 4),
        "nonadaptive_minimum": nonadaptive_minimum_centers(3, 4),
    })

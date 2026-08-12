#!/usr/bin/env python3
"""Reversible boundary cost of rolling multiplication modulo p^k."""

from __future__ import annotations

from quantum_quotient_dilation import coherent_environment_dimension


def rolling_outputs(prime: int, depth: int, steps: int = 1) -> tuple[int, ...]:
    if prime < 2 or depth < 1 or steps < 0:
        raise ValueError("require prime>=2, depth>=1, steps>=0")
    modulus = prime**depth
    multiplier = prime**steps
    return tuple((multiplier * value) % modulus for value in range(modulus))


def rolling_environment_dimension(prime: int, depth: int, steps: int = 1) -> int:
    return coherent_environment_dimension(rolling_outputs(prime, depth, steps))


def expected_rolling_dimension(prime: int, depth: int, steps: int = 1) -> int:
    if steps < 0:
        raise ValueError("steps must be nonnegative")
    return prime ** min(steps, depth)


def promised_ladder_transition(depth: int) -> tuple[tuple[int, int], ...]:
    """Injective level/value transition before the terminal ladder endpoint."""
    if depth < 1:
        raise ValueError("depth must be positive")
    return tuple((level + 1, level + 1) for level in range(depth))


if __name__ == "__main__":
    print({
        "one_step": rolling_environment_dimension(3, 4, 1),
        "three_steps": rolling_environment_dimension(3, 4, 3),
        "saturated": rolling_environment_dimension(3, 4, 5),
    })

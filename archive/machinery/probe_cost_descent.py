#!/usr/bin/env python3
"""Construction-cost descent obstruction for residue-valued probe centers."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt

from valuation_future_residue import truncated_valuation


def _modulus(prime: int, depth: int) -> int:
    truncated_valuation(0, prime, depth)
    return prime**depth


def successor_cost(representative: int) -> int:
    if representative < 0:
        raise ValueError("successor construction requires a nonnegative lift")
    return representative


def binary_method_cost(representative: int) -> int:
    """Additions in the standard left-to-right binary construction from 1."""
    if representative < 1:
        raise ValueError("binary construction requires a positive lift")
    return representative.bit_length() - 1 + representative.bit_count() - 1


def probe_signature(
    representative: int, prime: int, depth: int
) -> tuple[int, ...]:
    modulus = _modulus(prime, depth)
    return tuple(
        truncated_valuation(state - representative, prime, depth)
        for state in range(modulus)
    )


@dataclass(frozen=True)
class LiftCostWitness:
    prime: int
    depth: int
    residue: int
    low_lift: int
    high_lift: int
    successor_costs: tuple[int, int]
    binary_costs: tuple[int, int]


def form_lift_cost_witness(
    prime: int, depth: int, residue: int, lift_index: int
) -> LiftCostWitness:
    modulus = _modulus(prime, depth)
    if lift_index < 1:
        raise ValueError("lift index must be positive")
    low = residue % modulus
    if low == 0:
        low = modulus
    high = low + lift_index * modulus
    if probe_signature(low, prime, depth) != probe_signature(high, prime, depth):
        raise AssertionError("congruent lifts must induce identical probes")
    return LiftCostWitness(
        prime,
        depth,
        residue % modulus,
        low,
        high,
        (successor_cost(low), successor_cost(high)),
        (binary_method_cost(low), binary_method_cost(high)),
    )


def canonical_nonnegative_lift(residue: int, prime: int, depth: int) -> int:
    return residue % _modulus(prime, depth)


if __name__ == "__main__":
    for index in (1, 10, 1000):
        witness = form_lift_cost_witness(3, 3, 1, index)
        print(witness)

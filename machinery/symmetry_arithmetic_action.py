#!/usr/bin/env python3
"""Permutation action on fixed-port arithmetic registers, exactly mod 5."""

from __future__ import annotations

Permutation = tuple[int, ...]
Registers = tuple[int, ...]


def compose(left: Permutation, right: Permutation) -> Permutation:
    """left after right."""
    return tuple(left[right[i]] for i in range(len(left)))


def permute_registers(permutation: Permutation, registers: Registers) -> Registers:
    return tuple(registers[permutation[i]] for i in range(len(permutation)))


def evaluate(registers: Registers, weights: Registers, modulus: int) -> int:
    if len(registers) != len(weights):
        raise ValueError("register and port counts differ")
    return sum(x * w for x, w in zip(registers, weights)) % modulus


def fixed_port_execution(
    permutation: Permutation, registers: Registers, weights: Registers, modulus: int
) -> int:
    return evaluate(permute_registers(permutation, registers), weights, modulus)


def covariant_execution(
    permutation: Permutation, registers: Registers, weights: Registers, modulus: int
) -> int:
    """Relabel both registers and dual weights; the pairing is invariant."""
    moved_registers = permute_registers(permutation, registers)
    moved_weights = permute_registers(permutation, weights)
    return evaluate(moved_registers, moved_weights, modulus)


def two_port_witness() -> dict[str, int]:
    identity, swap = (0, 1), (1, 0)
    registers, weights = (1, 2), (1, 2)
    return {
        "symmetry_count": 2,
        "identity_fixed": fixed_port_execution(identity, registers, weights, 5),
        "swap_fixed": fixed_port_execution(swap, registers, weights, 5),
        "identity_covariant": covariant_execution(identity, registers, weights, 5),
        "swap_covariant": covariant_execution(swap, registers, weights, 5),
    }


if __name__ == "__main__":
    print(two_port_witness())

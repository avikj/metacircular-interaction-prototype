#!/usr/bin/env python3
"""Exact finite certificates for reversible dilations of quotient sensors."""

from __future__ import annotations

from collections import Counter
from math import ceil, log2
from typing import Hashable, Sequence


def fiber_sizes(outputs: Sequence[Hashable]) -> dict[Hashable, int]:
    """Return the nonempty fiber cardinalities of a finite deterministic map."""
    if not outputs:
        raise ValueError("a quotient needs a nonempty input set")
    return dict(Counter(outputs))


def coherent_environment_dimension(outputs: Sequence[Hashable]) -> int:
    """Minimum environment dimension when the input register is overwritten."""
    return max(fiber_sizes(outputs).values())


def coherent_environment_qubits(outputs: Sequence[Hashable]) -> int:
    """Minimum number of qubits whose Hilbert space can contain that environment."""
    dimension = coherent_environment_dimension(outputs)
    return 0 if dimension == 1 else ceil(log2(dimension))


def measurement_environment_dimension(outputs: Sequence[Hashable]) -> int:
    """Kraus/Choi rank of the basis-measure-and-prepare quotient channel."""
    if not outputs:
        raise ValueError("a quotient needs a nonempty input set")
    return len(outputs)


def residue_outputs(size: int, modulus: int) -> tuple[int, ...]:
    """The formed residue sensor on the finite chart {0,...,size-1}."""
    if size <= 0 or modulus <= 0:
        raise ValueError("size and modulus must be positive")
    return tuple(value % modulus for value in range(size))


def residue_dilation_certificate(size: int, modulus: int) -> dict[str, int]:
    outputs = residue_outputs(size, modulus)
    dimension = coherent_environment_dimension(outputs)
    expected = ceil(size / modulus)
    if dimension != expected:
        raise AssertionError("residue fiber formula failed")
    return {
        "input_dimension": size,
        "output_labels": min(size, modulus),
        "coherent_environment_dimension": dimension,
        "coherent_environment_qubits": coherent_environment_qubits(outputs),
        "measurement_environment_dimension": measurement_environment_dimension(outputs),
    }


if __name__ == "__main__":
    print(residue_dilation_certificate(91, 7))

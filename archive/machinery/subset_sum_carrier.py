#!/usr/bin/env python3
"""Composable finite-depth carriers for labeled and symmetric subset sums."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


def _modulus(prime: int, depth: int) -> int:
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")
    if depth < 1:
        raise ValueError("depth must be positive")
    return prime**depth


def cyclic_convolution(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    """Multiply two elements of Z[C_m] in coefficient coordinates."""
    if not left or len(left) != len(right):
        raise ValueError("coefficient vectors must have the same positive length")
    modulus = len(left)
    result = [0] * modulus
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[(i + j) % modulus] += a * b
    return tuple(result)


@dataclass(frozen=True)
class SubsetSumCarrier:
    prime: int
    depth: int
    modulus: int
    coefficients: tuple[int, ...]

    @property
    def subset_count(self) -> int:
        return sum(self.coefficients)


def form_subset_sum_carrier(
    inputs: tuple[int, ...], prime: int, depth: int
) -> SubsetSumCarrier:
    """Return coefficients of product (1+X^a) in Z[X]/(X^m-1)."""
    modulus = _modulus(prime, depth)
    coefficients = (1,) + (0,) * (modulus - 1)
    for value in inputs:
        factor = [0] * modulus
        factor[0] += 1
        factor[value % modulus] += 1
        coefficients = cyclic_convolution(coefficients, tuple(factor))
    return SubsetSumCarrier(prime, depth, modulus, coefficients)


def compose_carriers(
    left: SubsetSumCarrier, right: SubsetSumCarrier
) -> SubsetSumCarrier:
    """Compose carriers for disjoint input families."""
    if (left.prime, left.depth, left.modulus) != (
        right.prime, right.depth, right.modulus
    ):
        raise ValueError("carrier charts do not match")
    return SubsetSumCarrier(
        left.prime,
        left.depth,
        left.modulus,
        cyclic_convolution(left.coefficients, right.coefficients),
    )


def labeled_subset_sum(
    inputs: tuple[int, ...], indices: tuple[int, ...], prime: int, depth: int
) -> int:
    """The labeled subset response modulo p^depth."""
    modulus = _modulus(prime, depth)
    if len(set(indices)) != len(indices) or any(
        index < 0 or index >= len(inputs) for index in indices
    ):
        raise ValueError("indices must specify a subset of input positions")
    return sum(inputs[index] for index in indices) % modulus


if __name__ == "__main__":
    left = form_subset_sum_carrier((1, 4), 3, 2)
    right = form_subset_sum_carrier((7,), 3, 2)
    joined = compose_carriers(left, right)
    direct = form_subset_sum_carrier((1, 4, 7), 3, 2)
    print("left:", left.coefficients)
    print("right:", right.coefficients)
    print("composed equals direct:", joined == direct)
    print("subsets represented:", direct.subset_count)

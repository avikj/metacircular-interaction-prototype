#!/usr/bin/env python3
"""Universal behavioral carrier for declared linear fact weightings."""

from __future__ import annotations

from fractions import Fraction
from typing import Iterable, Sequence

Vector = tuple[Fraction, ...]


def _vector(values: Sequence[int | Fraction]) -> Vector:
    return tuple(Fraction(x) for x in values)


def row_basis(weights: Iterable[Sequence[int | Fraction]]) -> tuple[Vector, ...]:
    """Reduced-row-echelon basis of the rational span of the given weights."""
    rows = [_vector(row) for row in weights]
    if not rows:
        return ()
    width = len(rows[0])
    if any(len(row) != width for row in rows):
        raise ValueError("weight vectors must have one common dimension")
    pivot_row = 0
    for column in range(width):
        pivot = next((i for i in range(pivot_row, len(rows))
                      if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = rows[pivot_row][column]
        rows[pivot_row] = tuple(x / scale for x in rows[pivot_row])
        for i, row in enumerate(rows):
            if i == pivot_row or not row[column]:
                continue
            factor = row[column]
            rows[i] = tuple(x - factor * y for x, y in zip(row, rows[pivot_row]))
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return tuple(row for row in rows if any(row))


def carrier(state: Sequence[int | Fraction],
            weights: Iterable[Sequence[int | Fraction]]) -> Vector:
    """Evaluate a state on a canonical basis of the admissible weight span."""
    x = _vector(state)
    basis = row_basis(weights)
    if basis and len(basis[0]) != len(x):
        raise ValueError("state and weights must have the same dimension")
    return tuple(sum(wi * xi for wi, xi in zip(w, x)) for w in basis)


def future_equivalent(left: Sequence[int | Fraction],
                      right: Sequence[int | Fraction],
                      weights: Iterable[Sequence[int | Fraction]]) -> bool:
    weights = tuple(tuple(w) for w in weights)
    return carrier(left, weights) == carrier(right, weights)


def quotient_fibers(states: Iterable[Sequence[int | Fraction]],
                    weights: Iterable[Sequence[int | Fraction]]) -> dict[Vector, tuple[Vector, ...]]:
    weights = tuple(tuple(w) for w in weights)
    fibers: dict[Vector, list[Vector]] = {}
    for state in states:
        x = _vector(state)
        fibers.setdefault(carrier(x, weights), []).append(x)
    return {key: tuple(values) for key, values in fibers.items()}


if __name__ == "__main__":
    states = ((0, 0), (1, 0), (0, 1), (1, 1))
    total = ((1, 1),)
    split = ((1, 1), (1, 0))
    print("total-only fibers", quotient_fibers(states, total))
    print("after one new weighting", quotient_fibers(states, split))

#!/usr/bin/env python3
"""Exact finite cut invariants for process-first models."""

from __future__ import annotations

from fractions import Fraction
from math import ceil, log2
from typing import Sequence


def rational_rank(rows: Sequence[Sequence[int | Fraction]]) -> int:
    """Rank over Q, computed by exact Gaussian elimination."""
    matrix = [[Fraction(value) for value in row] for row in rows]
    if not matrix:
        return 0
    width = len(matrix[0])
    if any(len(row) != width for row in matrix):
        raise ValueError("matrix must be rectangular")
    rank = 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = matrix[rank][column]
        matrix[rank] = [value / scale for value in matrix[rank]]
        for row in range(len(matrix)):
            if row == rank or not matrix[row][column]:
                continue
            scale = matrix[row][column]
            matrix[row] = [
                value - scale * basis
                for value, basis in zip(matrix[row], matrix[rank])
            ]
        rank += 1
        if rank == len(matrix):
            break
    return rank


def cut_dimension(rows: Sequence[Sequence[int | Fraction]]) -> int:
    """Minimum Q-linear interface dimension across a finite process cut."""
    return rational_rank(rows)


def compose_process_tables(
    past_to_boundary: Sequence[Sequence[int | Fraction]],
    boundary_to_future: Sequence[Sequence[int | Fraction]],
) -> tuple[tuple[Fraction, ...], ...]:
    """Contract two finite process tables across their shared boundary."""
    left = _rectangular_fraction_matrix(past_to_boundary)
    right = _rectangular_fraction_matrix(boundary_to_future)
    if not left or not right or len(left[0]) != len(right):
        raise ValueError("process tables need a nonempty shared boundary")
    return tuple(
        tuple(
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        )
        for i in range(len(left))
    )


def cut_gluing_defect(
    past_to_boundary: Sequence[Sequence[int | Fraction]],
    boundary_to_future: Sequence[Sequence[int | Fraction]],
) -> int:
    """Dimension produced at the boundary and killed by the past table.

    If the matrices are A and B, this returns rank(B) - rank(AB), equal to
    dim(im(B) intersect ker(A)) by rank-nullity for A restricted to im(B).
    """
    composite = compose_process_tables(past_to_boundary, boundary_to_future)
    return rational_rank(boundary_to_future) - rational_rank(composite)


def memoryless_at_cut(rows: Sequence[Sequence[int | Fraction]]) -> bool:
    """Whether a nonzero joint-weight tensor factors across this cut."""
    if not rows or not rows[0]:
        raise ValueError("cut needs nonempty past and future alphabets")
    return rational_rank(rows) <= 1


def predictive_profiles(
    rows: Sequence[Sequence[int | Fraction]],
) -> tuple[tuple[int, ...], ...]:
    """Partition pasts by identical normalized future distributions."""
    profiles: list[tuple[Fraction, ...]] = []
    classes: list[list[int]] = []
    for index, raw_row in enumerate(rows):
        row = tuple(Fraction(value) for value in raw_row)
        total = sum(row)
        if total <= 0 or any(value < 0 for value in row):
            raise ValueError("each past needs a positive nonnegative future row")
        profile = tuple(value / total for value in row)
        if profile in profiles:
            classes[profiles.index(profile)].append(index)
        else:
            profiles.append(profile)
            classes.append([index])
    return tuple(tuple(indices) for indices in classes)


def deterministic_memory_bits(
    rows: Sequence[Sequence[int | Fraction]],
) -> int:
    """Worst-case bits needed to label the predictive-state quotient."""
    count = len(predictive_profiles(rows))
    return 0 if count <= 1 else ceil(log2(count))


def marginals(
    rows: Sequence[Sequence[int | Fraction]],
) -> tuple[tuple[Fraction, ...], tuple[Fraction, ...]]:
    """Normalized past and future marginals of a joint-weight matrix."""
    matrix = [[Fraction(value) for value in row] for row in rows]
    if not matrix or not matrix[0] or any(len(row) != len(matrix[0]) for row in matrix):
        raise ValueError("joint weights must form a nonempty rectangle")
    if any(value < 0 for row in matrix for value in row):
        raise ValueError("joint weights must be nonnegative")
    total = sum(value for row in matrix for value in row)
    if total <= 0:
        raise ValueError("joint weights need positive mass")
    past = tuple(sum(row) / total for row in matrix)
    future = tuple(
        sum(matrix[row][column] for row in range(len(matrix))) / total
        for column in range(len(matrix[0]))
    )
    return past, future


def is_nonnegative_fooling_set(rows, positions) -> bool:
    """Check a fooling-set certificate for a nonnegative-rank lower bound."""
    matrix = tuple(tuple(Fraction(value) for value in row) for row in rows)
    if not matrix or not matrix[0] or any(len(row) != len(matrix[0]) for row in matrix):
        raise ValueError("matrix must be a nonempty rectangle")
    if any(value < 0 for row in matrix for value in row):
        raise ValueError("fooling-set matrix must be nonnegative")
    picks = tuple(positions)
    if len(set(picks)) != len(picks):
        return False
    height, width = len(matrix), len(matrix[0])
    if any(not (0 <= i < height and 0 <= j < width) or matrix[i][j] <= 0
           for i, j in picks):
        return False
    return all(matrix[i][column] == 0 or matrix[row][j] == 0
               for index, (i, j) in enumerate(picks)
               for row, column in picks[index + 1:])


def _rectangular_fraction_matrix(
    rows: Sequence[Sequence[int | Fraction]],
) -> list[list[Fraction]]:
    matrix = [[Fraction(value) for value in row] for row in rows]
    if not matrix or not matrix[0] or any(len(row) != len(matrix[0]) for row in matrix):
        raise ValueError("matrix must be a nonempty rectangle")
    return matrix

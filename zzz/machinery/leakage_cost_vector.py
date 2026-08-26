#!/usr/bin/env python3
"""Exact correction rank and plural cost boundary for projected execution."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction

try:
    from machinery.amortized_certificate_walk import CostCertificate
    from machinery.primitive_character_projector import (
        Matrix,
        multiply,
        primitive_projector,
        rank_fraction,
        translation_matrix,
    )
except ModuleNotFoundError:  # direct script execution
    from amortized_certificate_walk import CostCertificate
    from primitive_character_projector import (
        Matrix,
        multiply,
        primitive_projector,
        rank_fraction,
        translation_matrix,
    )


def identity(n: int) -> Matrix:
    return tuple(tuple(Fraction(int(i == j)) for j in range(n)) for i in range(n))


def subtract(left: Matrix, right: Matrix) -> Matrix:
    return tuple(tuple(left[i][j] - right[i][j] for j in range(len(left[0])))
                 for i in range(len(left)))


def position(n: int) -> Matrix:
    return tuple(tuple(Fraction(i if i == j else 0) for j in range(n))
                 for i in range(n))


def leakage(projector: Matrix, operator: Matrix) -> Matrix:
    complement = subtract(identity(len(projector)), projector)
    return multiply(complement, multiply(operator, projector))


def independent_columns(matrix: Matrix) -> tuple[int, ...]:
    chosen: list[int] = []
    current_rank = 0
    for column in range(len(matrix[0])):
        candidate = tuple(tuple(row[j] for j in chosen + [column]) for row in matrix)
        new_rank = rank_fraction(candidate)
        if new_rank > current_rank:
            chosen.append(column)
            current_rank = new_rank
    return tuple(chosen)


def solve_full_column_rank(basis: Matrix, target: tuple[Fraction, ...]) -> tuple[Fraction, ...]:
    """Solve Bc=target when B has independent columns and target is in im B."""
    rows, columns = len(basis), len(basis[0])
    work = [list(basis[i]) + [target[i]] for i in range(rows)]
    pivot_row = 0
    pivots = []
    for column in range(columns):
        pivot = next(i for i in range(pivot_row, rows) if work[i][column])
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        scale = work[pivot_row][column]
        work[pivot_row] = [x / scale for x in work[pivot_row]]
        for i in range(rows):
            if i != pivot_row and work[i][column]:
                scale = work[i][column]
                work[i] = [a - scale * b for a, b in zip(work[i], work[pivot_row])]
        pivots.append(pivot_row)
        pivot_row += 1
    for row in work:
        if all(x == 0 for x in row[:columns]) and row[-1] != 0:
            raise ValueError("target is not in the column span")
    return tuple(work[pivots[j]][-1] for j in range(columns))


def rank_factorization(matrix: Matrix) -> tuple[Matrix, Matrix]:
    """Return L=B C through a carrier of minimal dimension rank(L)."""
    pivots = independent_columns(matrix)
    if not pivots:
        empty_b = tuple(() for _ in matrix)
        empty_c: Matrix = ()
        return empty_b, empty_c
    b = tuple(tuple(row[j] for j in pivots) for row in matrix)
    columns = tuple(tuple(matrix[i][j] for i in range(len(matrix)))
                    for j in range(len(matrix[0])))
    coefficients = tuple(solve_full_column_rank(b, column) for column in columns)
    c = tuple(tuple(coefficients[j][i] for j in range(len(coefficients)))
              for i in range(len(pivots)))
    if multiply(b, c) != matrix:
        raise AssertionError("rank factorization does not reconstruct leakage")
    return b, c


@dataclass(frozen=True)
class ExecutionCostVector:
    baseline_operations: int
    correction_scalars: int
    exact: bool


@dataclass(frozen=True)
class LeakageRouteComparison:
    leakage_rank: int
    old: ExecutionCostVector
    restricted: ExecutionCostVector
    corrected: ExecutionCostVector


def compare_routes(cost: CostCertificate, queries: int,
                   projector: Matrix, operator: Matrix) -> LeakageRouteComparison:
    if queries < 0:
        raise ValueError("query horizon must be nonnegative")
    leak = leakage(projector, operator)
    correction_rank = rank_fraction(leak)
    # rank_factorization is the executable attainability certificate.
    b, c = rank_factorization(leak)
    if correction_rank:
        assert len(c) == correction_rank and multiply(b, c) == leak
    return LeakageRouteComparison(
        correction_rank,
        ExecutionCostVector(cost.old_total(queries), 0, True),
        ExecutionCostVector(cost.compiled_total(queries), 0,
                            correction_rank == 0),
        ExecutionCostVector(cost.compiled_total(queries),
                            queries * correction_rank, True),
    )


def q6_examples(queries: int = 4):
    p = primitive_projector(6)
    cost = CostCertificate(72, 30, 8)
    translation = compare_routes(cost, queries, p, translation_matrix(6, 1))
    position_sensitive = compare_routes(cost, queries, p, position(6))
    assert translation.leakage_rank == 0
    assert position_sensitive.leakage_rank == 2
    return translation, position_sensitive


def main():
    translation, position_sensitive = q6_examples()
    assert translation.corrected == ExecutionCostVector(104, 0, True)
    assert position_sensitive.old == ExecutionCostVector(120, 0, True)
    assert position_sensitive.restricted == ExecutionCostVector(104, 0, False)
    assert position_sensitive.corrected == ExecutionCostVector(104, 8, True)
    print({"translation": translation, "position": position_sensitive})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

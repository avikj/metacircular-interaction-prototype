#!/usr/bin/env python3
"""A residual-driven, certificate-producing Smith reducer for 2x2 matrices."""

from __future__ import annotations

from dataclasses import dataclass

Matrix = tuple[tuple[int, int], tuple[int, int]]
IDENTITY: Matrix = ((1, 0), (0, 1))


def multiply(a: Matrix, b: Matrix) -> Matrix:
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )  # type: ignore[return-value]


def determinant(a: Matrix) -> int:
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


@dataclass(frozen=True)
class ResidualStep:
    kind: str
    residual: int
    quotient: int | None
    pivot_before: int
    pivot_after: int
    state: Matrix


@dataclass(frozen=True)
class SmithCertificate:
    source: Matrix
    left: Matrix
    diagonal: Matrix
    right: Matrix
    steps: tuple[ResidualStep, ...]

    def verify(self) -> bool:
        d1, d2 = self.diagonal[0][0], self.diagonal[1][1]
        return (
            multiply(multiply(self.left, self.source), self.right)
            == self.diagonal
            and determinant(self.left) in (-1, 1)
            and determinant(self.right) in (-1, 1)
            and self.diagonal[0][1] == self.diagonal[1][0] == 0
            and d1 >= 0
            and d2 >= 0
            and (d1 != 0 or d2 == 0)
            and (d1 == 0 or d2 % d1 == 0)
        )


def smith_reduce(source: Matrix) -> SmithCertificate:
    """Return unimodular L,R and Smith D with L*source*R=D.

    A nonzero off-axis remainder is not merely reported: it selects the row
    or column reduction that makes that remainder the next, smaller pivot.
    If the axes clear but the two diagonal entries violate divisibility, the
    divisibility residual is injected onto an axis and drives the same descent.
    """
    a = [list(source[0]), list(source[1])]
    left = [[1, 0], [0, 1]]
    right = [[1, 0], [0, 1]]
    steps: list[ResidualStep] = []

    def freeze(x: list[list[int]]) -> Matrix:
        return ((x[0][0], x[0][1]), (x[1][0], x[1][1]))

    def row_swap() -> None:
        a[0], a[1] = a[1], a[0]
        left[0], left[1] = left[1], left[0]

    def col_swap() -> None:
        for x in (a, right):
            x[0][0], x[0][1] = x[0][1], x[0][0]
            x[1][0], x[1][1] = x[1][1], x[1][0]

    def row_add(target: int, source_row: int, coefficient: int) -> None:
        for j in range(2):
            a[target][j] += coefficient * a[source_row][j]
            left[target][j] += coefficient * left[source_row][j]

    def col_add(target: int, source_col: int, coefficient: int) -> None:
        for i in range(2):
            a[i][target] += coefficient * a[i][source_col]
            right[i][target] += coefficient * right[i][source_col]

    def row_negate(i: int) -> None:
        for j in range(2):
            a[i][j] *= -1
            left[i][j] *= -1

    while True:
        if a[0][0] == 0:
            positions = [(i, j) for i in range(2) for j in range(2) if a[i][j]]
            if not positions:
                break
            i, j = positions[0]
            if i:
                row_swap()
            if j:
                col_swap()

        if a[0][0] < 0:
            row_negate(0)
        pivot = a[0][0]

        q, residual = divmod(a[1][0], pivot)
        row_add(1, 0, -q)
        if residual:
            row_swap()
            if a[0][0] < 0:
                row_negate(0)
            steps.append(ResidualStep(
                "column-residual", residual, q, pivot, a[0][0], freeze(a)
            ))
            assert 0 < a[0][0] < pivot
            continue

        q, residual = divmod(a[0][1], pivot)
        col_add(1, 0, -q)
        if residual:
            col_swap()
            if a[0][0] < 0:
                row_negate(0)
            steps.append(ResidualStep(
                "row-residual", residual, q, pivot, a[0][0], freeze(a)
            ))
            assert 0 < a[0][0] < pivot
            continue

        if a[1][1] < 0:
            row_negate(1)
        if a[1][1] % pivot == 0:
            break

        # The diagonal residual itself forms the next constructor: expose the
        # lower diagonal entry in the first row, then Euclidean column descent.
        residual = a[1][1] % pivot
        row_add(0, 1, 1)
        q, exposed = divmod(a[0][1], pivot)
        assert exposed == residual != 0
        col_add(1, 0, -q)
        col_swap()
        if a[0][0] < 0:
            row_negate(0)
        steps.append(ResidualStep(
            "divisibility-residual", residual, q, pivot, a[0][0], freeze(a)
        ))
        assert 0 < a[0][0] < pivot

    diagonal = freeze(a)
    certificate = SmithCertificate(
        source, freeze(left), diagonal, freeze(right), tuple(steps)
    )
    if not certificate.verify():
        raise AssertionError("constructed Smith certificate failed replay")
    return certificate


if __name__ == "__main__":
    example = smith_reduce(((84, 14), (30, 10)))
    print(example.diagonal)
    for step in example.steps:
        print(step)

#!/usr/bin/env python3
"""Primitive cyclotomic idempotent and weighted fixed-sector trace."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import gcd

try:
    from machinery.ramanujan_trace import ramanujan_convolution
except ModuleNotFoundError:  # direct script execution
    from ramanujan_trace import ramanujan_convolution

Matrix = tuple[tuple[Fraction, ...], ...]


def multiply(left: Matrix, right: Matrix) -> Matrix:
    return tuple(tuple(sum((left[i][k] * right[k][j]
                            for k in range(len(right))), Fraction(0))
                       for j in range(len(right[0])))
                 for i in range(len(left)))


def trace(matrix: Matrix) -> Fraction:
    return sum((matrix[i][i] for i in range(len(matrix))), Fraction(0))


def translation_matrix(q: int, shift: int) -> Matrix:
    """Regular C_q action: basis x is sent to x+shift."""
    return tuple(tuple(Fraction(int(i == (j + shift) % q))
                       for j in range(q)) for i in range(q))


def primitive_projector(q: int) -> Matrix:
    """e_prim=(1/q) sum_k c_q(-k) rho(k) on Q[C_q]."""
    matrices = tuple(translation_matrix(q, k) for k in range(q))
    weights = tuple(ramanujan_convolution(q, -k) for k in range(q))
    return tuple(tuple(sum((Fraction(weights[k], q) * matrices[k][i][j]
                            for k in range(q)), Fraction(0))
                       for j in range(q)) for i in range(q))


def rank_fraction(matrix: Matrix) -> int:
    work = [list(row) for row in matrix]
    rows, columns = len(work), len(work[0]) if work else 0
    rank = 0
    for column in range(columns):
        pivot = next((i for i in range(rank, rows) if work[i][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = work[rank][column]
        work[rank] = [x / scale for x in work[rank]]
        for i in range(rows):
            if i != rank and work[i][column]:
                scale = work[i][column]
                work[i] = [a - scale * b for a, b in zip(work[i], work[rank])]
        rank += 1
    return rank


@dataclass(frozen=True)
class PrimitiveProjectorCertificate:
    modulus: int
    projector_rank: int
    projected_traces: tuple[int, ...]
    weighted_sector_traces: tuple[int, ...]
    ramanujan_values: tuple[int, ...]


def compile_primitive_projector(q: int) -> PrimitiveProjectorCertificate:
    if q < 2:
        raise ValueError("modulus must be at least two")
    projector = primitive_projector(q)
    if multiply(projector, projector) != projector:
        raise AssertionError("primitive character element is not idempotent")
    rank = rank_fraction(projector)
    phi = sum(gcd(a, q) == 1 for a in range(q))
    if rank != phi or trace(projector) != phi:
        raise AssertionError("primitive projector has wrong dimension")

    expected = tuple(ramanujan_convolution(q, n) for n in range(q))
    projected = tuple(int(trace(multiply(translation_matrix(q, n), projector)))
                      for n in range(q))
    weighted = []
    for n in range(q):
        # trace(rho(n+k)) is the fixed-point count of translation by n+k.
        sectors = tuple(int(trace(translation_matrix(q, n + k)))
                        for k in range(q))
        value = sum(Fraction(ramanujan_convolution(q, -k), q) * sectors[k]
                    for k in range(q))
        weighted.append(int(value))
    if projected != expected or tuple(weighted) != expected:
        raise AssertionError("projected, sector, and Ramanujan traces disagree")
    return PrimitiveProjectorCertificate(q, rank, projected,
                                         tuple(weighted), expected)


def main():
    q3 = compile_primitive_projector(3)
    q12 = compile_primitive_projector(12)
    assert q3.ramanujan_values == (2, -1, -1)
    assert q12.projector_rank == 4
    print({"q3": q3, "q12": q12})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

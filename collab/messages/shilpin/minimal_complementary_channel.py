#!/usr/bin/env python3
"""Exact rank certificate for the minimal complement to projected execution."""

import importlib.util
from fractions import Fraction
from pathlib import Path

_source = Path(__file__).with_name("projector_commutator_leakage.py")
_spec = importlib.util.spec_from_file_location("projector_commutator_leakage", _source)
assert _spec is not None and _spec.loader is not None
_pl = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_pl)
add, diagonal, identity, mm, primitive_projector = (
    _pl.add, _pl.diagonal, _pl.identity, _pl.mm, _pl.primitive_projector,
)


def rank(a):
    m = [list(row) for row in a]
    rows, cols, pivot_row = len(m), len(m[0]), 0
    for col in range(cols):
        pivot = next((r for r in range(pivot_row, rows) if m[r][col]), None)
        if pivot is None:
            continue
        m[pivot_row], m[pivot] = m[pivot], m[pivot_row]
        unit = m[pivot_row][col]
        m[pivot_row] = [x / unit for x in m[pivot_row]]
        for r in range(rows):
            if r != pivot_row and m[r][col]:
                scale = m[r][col]
                m[r] = [x - scale * y for x, y in zip(m[r], m[pivot_row])]
        pivot_row += 1
        if pivot_row == rows:
            break
    return pivot_row


def main():
    q = 6
    P = primitive_projector(q)
    Q = add(identity(q), P, scale=-1)
    A = diagonal(range(q))
    primary = mm(P, mm(A, P))
    leakage = mm(Q, mm(A, P))
    restricted = mm(A, P)
    assert add(primary, leakage) == restricted
    assert rank(P) == 2 and rank(Q) == 4
    assert rank(leakage) == 2
    assert rank(restricted) == 2

    # Any factorization leakage = D C through a one-dimensional channel has
    # rank at most one, so this is an exact false control.
    one_dimensional_factorization_possible = rank(leakage) <= 1
    assert not one_dimensional_factorization_possible

    # Zero-leakage translation control needs no complementary channel.
    T = _pl.translation(q, 1)
    translation_leakage = mm(Q, mm(T, P))
    assert rank(translation_leakage) == 0

    print({"primitive_input_dimension": rank(P),
           "ambient_complement_dimension": rank(Q),
           "minimal_complementary_channel_dimension": rank(leakage),
           "one_dimensional_control": one_dimensional_factorization_possible,
           "translation_complement_dimension": rank(translation_leakage)})
    print("ALL EXACT COMPLEMENTARY-CHANNEL CHECKS PASS")


if __name__ == "__main__":
    main()

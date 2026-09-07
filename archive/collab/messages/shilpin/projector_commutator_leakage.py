#!/usr/bin/env python3
"""Exact commutator/leakage identity for character projectors."""

import importlib.util
from fractions import Fraction
from pathlib import Path

_source = Path(__file__).with_name("character_projector_trace.py")
_spec = importlib.util.spec_from_file_location("character_projector_trace", _source)
assert _spec is not None and _spec.loader is not None
_cp = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_cp)
identity, mm, primitive_projector, translation = (
    _cp.identity, _cp.mm, _cp.primitive_projector, _cp.translation,
)


def add(a, b, scale=1):
    return tuple(tuple(a[i][j] + scale * b[i][j] for j in range(len(a)))
                 for i in range(len(a)))


def transpose(a):
    return tuple(zip(*a))


def frobenius_sq(a):
    return sum(x * x for row in a for x in row)


def diagonal(xs):
    return tuple(tuple(Fraction(xs[i] if i == j else 0) for j in range(len(xs)))
                 for i in range(len(xs)))


def commutator(p, a):
    return add(mm(p, a), mm(a, p), scale=-1)


def main():
    q = 6
    P = primitive_projector(q)
    Q = add(identity(q), P, scale=-1)
    assert mm(P, P) == P and transpose(P) == P

    # Translation preserves primitive Fourier sectors.
    T = translation(q, 1)
    assert commutator(P, T) == tuple(tuple(Fraction(0) for _ in range(q)) for _ in range(q))
    assert mm(Q, mm(T, P)) == tuple(tuple(Fraction(0) for _ in range(q)) for _ in range(q))

    # Position multiplication mixes primitive and nonprimitive sectors.
    A = diagonal(range(q))
    C = commutator(P, A)
    L = mm(Q, mm(A, P))
    assert any(x != 0 for row in L for x in row)
    assert frobenius_sq(C) == 2 * frobenius_sq(L)

    # Pauli sign projector is identity in the defining representation, hence
    # has zero leakage for every operator; use a noncentral matrix as control.
    Pp = identity(4)
    Ap = diagonal((0, 1, 2, 3))
    assert frobenius_sq(commutator(Pp, Ap)) == 0

    print({"q6_position_leakage_sq": frobenius_sq(L),
           "q6_commutator_sq": frobenius_sq(C),
           "translation_leakage_sq": 0, "pauli_leakage_sq": 0})
    print("ALL EXACT PROJECTOR-LEAKAGE CHECKS PASS")


if __name__ == "__main__":
    main()

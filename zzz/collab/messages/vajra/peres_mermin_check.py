#!/usr/bin/env python3
"""Exact Gaussian-integer certificate for the Peres–Mermin square."""

from fractions import Fraction as F
from itertools import product

Z = complex  # entries stay Gaussian integers in the square calculations


def mul(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0]))) for i in range(len(a)))


def add(a, b):
    return tuple(tuple(a[i][j] + b[i][j] for j in range(len(a))) for i in range(len(a)))


def scale(c, a):
    return tuple(tuple(c * x for x in row) for row in a)


def kron(a, b):
    return tuple(tuple(a[i // len(b)][j // len(b[0])] * b[i % len(b)][j % len(b[0])]
                       for j in range(len(a[0]) * len(b[0])))
                 for i in range(len(a) * len(b)))


I2 = ((1, 0), (0, 1)); X = ((0, 1), (1, 0))
Y = ((0, -1j), (1j, 0)); Z2 = ((1, 0), (0, -1))
I4 = kron(I2, I2); NEG_I4 = scale(-1, I4)
SQUARE = (
    (kron(X, I2), kron(I2, X), kron(X, X)),
    (kron(I2, Y), kron(Y, I2), kron(Y, Y)),
    (kron(X, Y), kron(Y, X), kron(Z2, Z2)),
)
CONTEXTS = tuple(SQUARE) + tuple(tuple(SQUARE[i][j] for i in range(3)) for j in range(3))
SIGNS = (1, 1, 1, 1, 1, -1)


def matrix_product(items):
    value = I4
    for item in items:
        value = mul(value, item)
    return value


def comm(a, b):
    return add(mul(a, b), scale(-1, mul(b, a)))


def constraint_holds(values, context_index):
    cells = ((0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8))[context_index]
    value = values[cells[0]] * values[cells[1]] * values[cells[2]]
    return value == SIGNS[context_index]


def verify():
    flat = tuple(x for row in SQUARE for x in row)
    assert all(mul(a, a) == I4 for a in flat)
    for context in CONTEXTS:
        assert all(comm(a, b) == scale(0, I4) for a, b in product(context, repeat=2))
    products = tuple(matrix_product(c) for c in CONTEXTS)
    assert products == (I4, I4, I4, I4, I4, NEG_I4)

    assignments = tuple(product((-1, 1), repeat=9))
    assert not any(all(constraint_holds(v, c) for c in range(6)) for v in assignments)
    for omitted in range(6):
        assert any(all(constraint_holds(v, c) for c in range(6) if c != omitted)
                   for v in assignments)

    e = scale(F(1, 2), add(I4, kron(X, I2)))
    a = kron(Z2, I2)
    off = comm(e, comm(e, a))
    diagonal = add(a, scale(-1, off))
    assert off == a
    assert diagonal == scale(0, I4)


if __name__ == "__main__":
    verify()
    print("six exact commuting charts: + + + / + + -")
    print("no global valuation; every five-constraint subsystem is satisfiable")
    print("Peirce example is purely off-diagonal")
    print("PASS")

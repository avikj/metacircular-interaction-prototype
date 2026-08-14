#!/usr/bin/env python3
"""Exact Peres--Mermin operator signs and global-section obstruction."""

from itertools import product

I = ((1, 0), (0, 1))
X = ((0, 1), (1, 0))
Y = ((0, -1j), (1j, 0))
Z = ((1, 0), (0, -1))


def mm(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0]))) for i in range(len(a)))


def kron(a, b):
    return tuple(tuple(a[i // 2][j // 2] * b[i % 2][j % 2]
                       for j in range(4)) for i in range(4))


I4 = kron(I, I)
NEG_I4 = tuple(tuple(-x for x in row) for row in I4)

SQUARE = (
    (kron(X, I), kron(I, X), kron(X, X)),
    (kron(I, Y), kron(Y, I), kron(Y, Y)),
    (kron(X, Y), kron(Y, X), kron(Z, Z)),
)

CONTEXTS = ((0, 1, 2), (3, 4, 5), (6, 7, 8),
            (0, 3, 6), (1, 4, 7), (2, 5, 8))


def context_signs():
    flat = sum(SQUARE, ())
    signs = []
    for context in CONTEXTS:
        a, b, c = (flat[i] for i in context)
        assert mm(a, b) == mm(b, a)
        p = mm(mm(a, b), c)
        assert p in (I4, NEG_I4)
        signs.append(int(p == NEG_I4))
    return tuple(signs)


def assignments(signs):
    return tuple(v for v in product((0, 1), repeat=9)
                 if all(sum(v[i] for i in c) % 2 == s
                        for c, s in zip(CONTEXTS, signs)))


def main():
    signs = context_signs()
    assert signs == (0, 0, 0, 0, 0, 1)
    assert assignments(signs) == ()
    # Every observable occurs twice, so summing all left sides is zero while
    # summing the operator-derived right sides is one.
    assert all(sum(i in c for c in CONTEXTS) == 2 for i in range(9))
    assert sum(signs) % 2 == 1

    control = signs[:-1] + (0,)
    assert len(assignments(control)) == 16
    print({"operator_signs": signs, "global_sections": 0,
           "trivial_phase_control_sections": len(assignments(control))})
    print("ALL EXACT PERES-MERMIN CHECKS PASS")


if __name__ == "__main__":
    main()

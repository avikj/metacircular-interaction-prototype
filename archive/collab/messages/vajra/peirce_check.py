#!/usr/bin/env python3
"""Dependency-free exact replay of the idempotent commutator identities."""

from fractions import Fraction as F


def add(a, b):
    return tuple(tuple(a[i][j] + b[i][j] for j in range(len(a))) for i in range(len(a)))


def neg(a):
    return tuple(tuple(-x for x in row) for row in a)


def mul(a, b):
    n = len(a)
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(n)) for j in range(n)) for i in range(n))


def comm(a, b):
    return add(mul(a, b), neg(mul(b, a)))


def verify():
    e = ((F(1), F(0)), (F(0), F(0)))
    one = ((F(1), F(0)), (F(0), F(1)))
    q = add(one, neg(e))
    a = ((F(2), F(3)), (F(5), F(7)))
    off = comm(e, comm(e, a))
    diagonal = add(a, neg(off))
    assert comm(e, a) == ((0, 3), (-5, 0))
    assert off == ((0, 3), (5, 0))
    assert diagonal == ((2, 0), (0, 7))
    assert diagonal == add(mul(mul(e, a), e), mul(mul(q, a), q))
    assert off == add(mul(mul(e, a), q), mul(mul(q, a), e))
    assert comm(e, comm(e, comm(e, a))) == comm(e, a)


if __name__ == "__main__":
    verify()
    print("PASS: Peirce blocks and ad_e^3=ad_e")

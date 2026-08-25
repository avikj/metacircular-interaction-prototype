#!/usr/bin/env python3
"""Exact F2 Peirce-choice and Z/5 generator automorphism obstruction."""

from itertools import product


MATRICES = tuple(product((0, 1), repeat=4))
ZERO, ONE = (0, 0, 0, 0), (1, 0, 0, 1)


def mul(a, b):
    return (
        (a[0] * b[0] + a[1] * b[2]) % 2,
        (a[0] * b[1] + a[1] * b[3]) % 2,
        (a[2] * b[0] + a[3] * b[2]) % 2,
        (a[2] * b[1] + a[3] * b[3]) % 2,
    )


def determinant(a):
    return (a[0] * a[3] - a[1] * a[2]) % 2


def inverse(a):
    assert determinant(a) == 1
    return (a[3], a[1], a[2], a[0])  # minus equals plus over F2


def rank(a):
    if a == ZERO:
        return 0
    return 2 if determinant(a) else 1


def conjugate(g, e):
    return mul(mul(g, e), inverse(g))


def verify():
    group = tuple(a for a in MATRICES if determinant(a))
    idempotents = tuple(a for a in MATRICES if mul(a, a) == a)
    rank_one = tuple(a for a in idempotents if rank(a) == 1)
    fixed = tuple(e for e in rank_one if all(conjugate(g, e) == e for g in group))
    orbit = {conjugate(g, rank_one[0]) for g in group}
    assert len(group) == 6
    assert len(idempotents) == 8  # 0, 1, and six rank-one cuts
    assert len(rank_one) == 6
    assert len(orbit) == 6
    assert fixed == ()

    generators = {1, 2, 3, 4}
    reflection = {(-x) % 5 for x in generators}
    fixed_generators = {x for x in generators if (-x) % 5 == x}
    assert reflection == generators and fixed_generators == set()
    assert (-0) % 5 == 0
    return group, rank_one


if __name__ == "__main__":
    group, cuts = verify()
    print(f"|GL(2,F2)|={len(group)}, rank-one idempotents={len(cuts)}")
    print("one conjugacy orbit; no invariant rank-one cut")
    print("Z/5 reflection fixes zero and no generator")
    print("PASS")

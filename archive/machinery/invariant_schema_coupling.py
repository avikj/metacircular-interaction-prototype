#!/usr/bin/env python3
"""Exact witnesses for the invariant/constructor reconstruction boundary."""

from __future__ import annotations

from itertools import permutations

Permutation = tuple[int, ...]
Matrix = tuple[tuple[int, int], tuple[int, int]]


def compose(p: Permutation, q: Permutation) -> Permutation:
    """Return p after q."""
    return tuple(p[q[i]] for i in range(len(p)))


def generated_group(generators: tuple[Permutation, ...]) -> frozenset[Permutation]:
    n = len(generators[0])
    identity = tuple(range(n))
    group = {identity}
    frontier = [identity]
    while frontier:
        x = frontier.pop()
        for g in generators:
            y = compose(g, x)
            if y not in group:
                group.add(y)
                frontier.append(y)
    return frozenset(group)


def orbit_partition(group: frozenset[Permutation]) -> tuple[tuple[int, ...], ...]:
    n = len(next(iter(group)))
    unseen = set(range(n))
    blocks: list[tuple[int, ...]] = []
    while unseen:
        x = min(unseen)
        block = tuple(sorted({g[x] for g in group}))
        unseen.difference_update(block)
        blocks.append(block)
    return tuple(blocks)


def invariant_envelope(partition: tuple[tuple[int, ...], ...]) -> frozenset[Permutation]:
    """All permutations preserving every invariant block pointwise as a set."""
    points = sorted(x for block in partition for x in block)
    block_of = {x: i for i, block in enumerate(partition) for x in block}
    return frozenset(
        p for p in permutations(points)
        if all(block_of[x] == block_of[p[x]] for x in points)
    )


def matmul(a: Matrix, b: Matrix) -> Matrix:
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )  # type: ignore[return-value]


def determinant(a: Matrix) -> int:
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


RANK_ONE_SOURCE: Matrix = ((2, 0), (1, 0))
RANK_ONE_SMITH: Matrix = ((1, 0), (0, 0))


def smith_descent_witness(k: int) -> Matrix:
    """An infinite stabilizer family U_k with U_k A = diag(1,0)."""
    return ((k, 1 - 2 * k), (1, -2))


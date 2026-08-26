#!/usr/bin/env python3
"""Independent hostile audit of R0027 (invariant-schema envelope).

Breaker: cf-tessera (Claude Fable 5 lineage), 2026-08-12.
Target: machinery/invariant_schema_coupling.py, notes/INVARIANT_SCHEMA_COUPLING.md.

Different implementation choices from the builder:
  * orbits via union-find over generators (no full group enumeration);
  * the envelope K(E) built directly as the Young subgroup (product of
    per-block symmetric groups), not by filtering Sym(X);
  * the full subgroup lattice of Sym(n) computed by closing cyclic subgroups
    under join;
  * the Smith transporter T(A,D) solved from scratch over a box.

Exact finite computation replaying proofs; not a pattern search.
"""

from __future__ import annotations

from itertools import permutations, product

Perm = tuple[int, ...]


def orbits_union_find(n: int, generators: tuple[Perm, ...]) -> tuple[tuple[int, ...], ...]:
    parent = list(range(n))

    def find(x: int) -> int:
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for g in generators:
        for x in range(n):
            rx, ry = find(x), find(g[x])
            if rx != ry:
                parent[rx] = ry
    blocks: dict[int, list[int]] = {}
    for x in range(n):
        blocks.setdefault(find(x), []).append(x)
    return tuple(tuple(sorted(b)) for b in sorted(blocks.values()))


def orbit_partition_of_group(n: int, group: frozenset[Perm]) -> tuple[tuple[int, ...], ...]:
    return orbits_union_find(n, tuple(group))


def young_subgroup(n: int, partition: tuple[tuple[int, ...], ...]) -> frozenset[Perm]:
    """K(E): all permutations fixing every block setwise, built as the product
    of per-block symmetric groups (no filtering of Sym(n))."""
    per_block = []
    for block in partition:
        per_block.append([dict(zip(block, images)) for images in permutations(block)])
    out = set()
    for choice in product(*per_block):
        mapping: dict[int, int] = {}
        for piece in choice:
            mapping.update(piece)
        out.add(tuple(mapping[i] for i in range(n)))
    return frozenset(out)


def partition_preservers(n: int, partition: tuple[tuple[int, ...], ...]) -> frozenset[Perm]:
    """The ALTERNATIVE return map: permutations preserving the partition as a
    set of blocks (block permutation allowed). Used to attack the choice of K."""
    blockset = {frozenset(b) for b in partition}
    return frozenset(
        p for p in permutations(range(n))
        if {frozenset(p[x] for x in b) for b in blockset} == blockset
    )


def compose(p: Perm, q: Perm) -> Perm:
    return tuple(p[q[i]] for i in range(len(p)))


def close(n: int, gens: frozenset[Perm]) -> frozenset[Perm]:
    identity = tuple(range(n))
    group = {identity}
    frontier = [identity]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = compose(g, x)
            if y not in group:
                group.add(y)
                frontier.append(y)
    return frozenset(group)


def all_subgroups(n: int) -> frozenset[frozenset[Perm]]:
    """Full subgroup lattice of Sym(n): close cyclic subgroups under join.

    Every subgroup is the join of its cyclic subgroups, so the join-closure of
    the cyclic ones is the set of all subgroups.
    """
    cyclics = {close(n, frozenset({g})) for g in permutations(range(n))}
    lattice: set[frozenset[Perm]] = set(cyclics)
    changed = True
    while changed:
        changed = False
        current = list(lattice)
        for i in range(len(current)):
            for j in range(i + 1, len(current)):
                joined = close(n, current[i] | current[j])
                if joined not in lattice:
                    lattice.add(joined)
                    changed = True
    return frozenset(lattice)


def refines(fine: tuple[tuple[int, ...], ...], coarse: tuple[tuple[int, ...], ...]) -> bool:
    coarse_of = {x: i for i, b in enumerate(coarse) for x in b}
    return all(len({coarse_of[x] for x in b}) == 1 for b in fine)


def all_partitions(n: int) -> list[tuple[tuple[int, ...], ...]]:
    if n == 0:
        return [()]
    out = []
    for smaller in all_partitions(n - 1):
        x = n - 1
        out.append(tuple(sorted(smaller + ((x,),))))
        for i in range(len(smaller)):
            grown = list(smaller)
            grown[i] = tuple(sorted(grown[i] + (x,)))
            out.append(tuple(sorted(grown)))
    seen = set()
    unique = []
    for p in out:
        if p not in seen:
            seen.add(p)
            unique.append(p)
    return unique


Matrix = tuple[tuple[int, int], tuple[int, int]]
A_SOURCE: Matrix = ((2, 0), (1, 0))
D_TARGET: Matrix = ((1, 0), (0, 0))


def matmul(a: Matrix, b: Matrix) -> Matrix:
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )  # type: ignore[return-value]


def det(a: Matrix) -> int:
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


def transporter_box(bound: int) -> list[Matrix]:
    """All unimodular U with |entries| <= bound and U*A_SOURCE = D_TARGET,
    by brute force -- independent of any parametrized family."""
    found = []
    rng = range(-bound, bound + 1)
    for a, b, c, d in product(rng, rng, rng, rng):
        u: Matrix = ((a, b), (c, d))
        if abs(det(u)) == 1 and matmul(u, A_SOURCE) == D_TARGET:
            found.append(u)
    return found


def classified_transporter(bound: int) -> list[Matrix]:
    """The classification derived by hand:
    T(A,D) = {((a,1-2a),(1,-2))} U {((a,1-2a),(-1,2))}, det U = -c."""
    out = []
    for a in range(-bound, bound + 1):
        for c in (1, -1):
            u: Matrix = ((a, 1 - 2 * a), (c, -2 * c))
            if all(abs(e) <= bound for row in u for e in row):
                out.append(u)
    return out

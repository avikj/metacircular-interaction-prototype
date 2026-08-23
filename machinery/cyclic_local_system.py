#!/usr/bin/env python3
"""Exact F_p local systems on a finite cyclic action groupoid."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Hashable, Mapping, Sequence

State = Hashable
Matrix = tuple[tuple[int, ...], ...]


def identity(rank: int) -> Matrix:
    return tuple(tuple(int(i == j) for j in range(rank)) for i in range(rank))


def multiply(left: Matrix, right: Matrix, prime: int) -> Matrix:
    return tuple(tuple(sum(left[i][k] * right[k][j]
                           for k in range(len(right))) % prime
                       for j in range(len(right[0])))
                 for i in range(len(left)))


def rank_mod_prime(matrix: Matrix, prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    rows, columns = len(work), len(work[0]) if work else 0
    rank = 0
    for column in range(columns):
        pivot = next((i for i in range(rank, rows)
                      if work[i][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [(entry * inverse) % prime for entry in work[rank]]
        for i in range(rows):
            if i != rank and work[i][column]:
                scale = work[i][column]
                work[i] = [(a - scale * b) % prime
                           for a, b in zip(work[i], work[rank])]
        rank += 1
    return rank


@dataclass(frozen=True)
class OrbitLocalInvariant:
    orbit: tuple[State, ...]
    monodromy: Matrix
    invariant_dimension: int


@dataclass(frozen=True)
class CyclicLocalSystem:
    group_order: int
    prime: int
    fiber_rank: int
    orbit_invariants: tuple[OrbitLocalInvariant, ...]

    @property
    def global_section_dimension(self) -> int:
        return sum(item.invariant_dimension for item in self.orbit_invariants)


def compile_cyclic_local_system(
    carrier: Sequence[State],
    generator: Mapping[State, State],
    transports: Mapping[State, Matrix],
    group_order: int,
    prime: int,
) -> CyclicLocalSystem:
    """Compile a representation of `C_group_order // X` over `F_prime`.

    `transports[x]` maps column vectors in the fiber at x to the fiber at
    generator[x]. Products compose on the left, so a length-l orbit based at
    x has monodromy `T_(H^(l-1)x) ... T_(Hx) T_x`. The product along
    `group_order` arrows must be identity: this is the group
    relation, and is the exact false-control boundary between a local system
    and arbitrary edge labels.
    """
    states = tuple(carrier)
    state_set = set(states)
    if not states or len(state_set) != len(states):
        raise ValueError("carrier must be nonempty and duplicate-free")
    if group_order <= 0 or prime < 2:
        raise ValueError("group order and prime must be positive/nontrivial")
    if set(generator) != state_set or set(generator.values()) != state_set:
        raise ValueError("generator must be a permutation")
    if set(transports) != state_set:
        raise ValueError("transport must cover the carrier")
    first = transports[states[0]]
    rank = len(first)
    if rank == 0:
        raise ValueError("fiber rank must be positive")
    for matrix in transports.values():
        if len(matrix) != rank or any(len(row) != rank for row in matrix):
            raise ValueError("transport matrices must have one square shape")
        if rank_mod_prime(matrix, prime) != rank:
            raise ValueError("transport matrix is not invertible")

    unit = identity(rank)
    for start in states:
        point, total = start, unit
        for _ in range(group_order):
            total = multiply(transports[point], total, prime)
            point = generator[point]
        if point != start or total != unit:
            raise ValueError("transport violates the cyclic group relation")

    unseen, answer = set(states), []
    while unseen:
        start = next(state for state in states if state in unseen)
        orbit, point, monodromy = [], start, unit
        while not orbit or point != start:
            orbit.append(point)
            monodromy = multiply(transports[point], monodromy, prime)
            point = generator[point]
        unseen.difference_update(orbit)
        difference = tuple(tuple((monodromy[i][j] - int(i == j)) % prime
                                 for j in range(rank)) for i in range(rank))
        fixed_dimension = rank - rank_mod_prime(difference, prime)
        answer.append(OrbitLocalInvariant(tuple(orbit), monodromy,
                                          fixed_dimension))
    return CyclicLocalSystem(group_order, prime, rank, tuple(answer))


def smith_example() -> CyclicLocalSystem:
    try:
        from machinery.smith_holonomy_predictive_control import carrier
        from machinery.smith_path_holonomy import act, witness
    except ModuleNotFoundError:  # direct script execution
        from smith_holonomy_predictive_control import carrier
        from smith_path_holonomy import act, witness

    *_, h, _, _, _ = witness()
    states = carrier()
    permutation = {state: act(h, state) for state in states}
    unit = identity(2)
    irreducible_c3 = ((0, 1), (1, 1))
    transports = {state: (irreducible_c3 if permutation[state] == state else unit)
                  for state in states}
    return compile_cyclic_local_system(states, permutation, transports, 3, 2)


if __name__ == "__main__":
    result = smith_example()
    print({"orbit_lengths": tuple(len(x.orbit) for x in result.orbit_invariants),
           "fixed_dimensions": tuple(x.invariant_dimension
                                     for x in result.orbit_invariants),
           "global_section_dimension": result.global_section_dimension})
    print("ALL EXACT CHECKS PASS")

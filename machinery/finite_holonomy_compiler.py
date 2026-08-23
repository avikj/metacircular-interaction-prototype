#!/usr/bin/env python3
"""Exact finite compiler for task-facing holonomy and additive coinvariants."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from math import gcd
from typing import Callable, Hashable, Mapping, Sequence

try:
    from machinery.natural_crystal import Crystal, crystallize, explain_distinctions
except ModuleNotFoundError:  # direct script execution
    from natural_crystal import Crystal, crystallize, explain_distinctions

State = Hashable
Generator = Hashable
Matrix = tuple[tuple[int, ...], ...]


@dataclass(frozen=True)
class PredictiveHolonomy:
    crystal: Crystal
    orbit_fibers: tuple[tuple[State, ...], ...]
    shortest_witnesses: Mapping[tuple[State, State], tuple[Generator, ...] | None]
    erasure: "HistoryErasureAudit | None"


@dataclass(frozen=True)
class HistoryErasureAudit:
    """Certificate for a proposed quotient relation Theta."""

    fibers: tuple[tuple[State, ...], ...]
    action_violations: tuple[tuple[State, State, Generator], ...]
    excluded_observations: tuple[tuple[int, State, State], ...]

    @property
    def is_action_congruence(self) -> bool:
        return not self.action_violations


def compile_predictive_holonomy(
    carrier: Sequence[State],
    generators: Mapping[Generator, Mapping[State, State]],
    observations: Sequence[Callable[[State], Hashable]],
    theta: Mapping[State, Hashable] | None = None,
) -> PredictiveHolonomy:
    """Compile a finite permutation action to its minimal task quotient."""
    states = tuple(carrier)
    if not states or len(set(states)) != len(states):
        raise ValueError("carrier must be finite, nonempty, and duplicate-free")
    actions = tuple(generators)
    state_set = set(states)
    transition = {}
    for name, permutation in generators.items():
        if set(permutation) != state_set or set(permutation.values()) != state_set:
            raise ValueError(f"generator {name!r} is not a permutation of the carrier")
        transition.update({(state, name): permutation[state] for state in states})
    observation = {state: tuple(view(state) for view in observations) for state in states}
    crystal = crystallize(states, actions, transition, observation)
    witnesses = explain_distinctions(states, actions, transition, observation)

    # The orbit quotient forgets where inside a holonomy orbit a history lands.
    # It is independent of the task-facing predictive quotient above.
    unseen = set(states)
    orbit_fibers = []
    while unseen:
        seed = next(state for state in states if state in unseen)
        orbit, frontier = {seed}, [seed]
        while frontier:
            source = frontier.pop()
            for action in actions:
                target = transition[source, action]
                if target not in orbit:
                    orbit.add(target)
                    frontier.append(target)
        fiber = tuple(state for state in states if state in orbit)
        orbit_fibers.append(fiber)
        unseen.difference_update(orbit)

    erasure = None
    if theta is not None:
        if set(theta) != state_set:
            raise ValueError("theta must label every carrier state exactly once")
        labels = tuple(dict.fromkeys(theta[state] for state in states))
        fibers = tuple(tuple(state for state in states if theta[state] == label)
                       for label in labels)
        violations = tuple(
            (left, right, action)
            for fiber in fibers
            for index, left in enumerate(fiber)
            for right in fiber[index + 1:]
            for action in actions
            if theta[transition[left, action]] != theta[transition[right, action]]
        )
        excluded = tuple(
            (view_index, left, right)
            for view_index, view in enumerate(observations)
            for fiber in fibers
            for index, left in enumerate(fiber)
            for right in fiber[index + 1:]
            if view(left) != view(right)
        )
        erasure = HistoryErasureAudit(fibers, violations, excluded)
    return PredictiveHolonomy(crystal, tuple(orbit_fibers), witnesses, erasure)


def bareiss_determinant(matrix: Matrix) -> int:
    """Fraction-free determinant with exact divisions."""
    n = len(matrix)
    if any(len(row) != n for row in matrix):
        raise ValueError("determinant requires a square matrix")
    if n == 0:
        return 1
    work = [list(row) for row in matrix]
    sign, previous = 1, 1
    for pivot_index in range(n - 1):
        if work[pivot_index][pivot_index] == 0:
            swap = next((i for i in range(pivot_index + 1, n)
                         if work[i][pivot_index] != 0), None)
            if swap is None:
                return 0
            work[pivot_index], work[swap] = work[swap], work[pivot_index]
            sign *= -1
        pivot = work[pivot_index][pivot_index]
        for i in range(pivot_index + 1, n):
            for j in range(pivot_index + 1, n):
                numerator = (work[i][j] * pivot
                             - work[i][pivot_index] * work[pivot_index][j])
                if numerator % previous:
                    raise AssertionError("Bareiss exact division failed")
                work[i][j] = numerator // previous
        previous = pivot
    return sign * work[-1][-1]


def smith_invariants_from_presentation(relations: Matrix) -> tuple[int, ...]:
    """Invariant factors from determinantal divisors of a full-row-rank matrix."""
    rows = len(relations)
    columns = len(relations[0]) if rows else 0
    if any(len(row) != columns for row in relations):
        raise ValueError("ragged relation matrix")
    deltas = [1]
    for size in range(1, rows + 1):
        divisor = 0
        for row_indices in combinations(range(rows), size):
            for column_indices in combinations(range(columns), size):
                minor = tuple(tuple(relations[i][j] for j in column_indices)
                              for i in row_indices)
                divisor = gcd(divisor, abs(bareiss_determinant(minor)))
        if divisor == 0:
            raise ValueError("presentation is not full row rank")
        deltas.append(divisor)
    invariants = tuple(deltas[i] // deltas[i - 1] for i in range(1, len(deltas)))
    if any(right % left for left, right in zip(invariants, invariants[1:])):
        raise AssertionError("determinantal divisors did not form Smith factors")
    return invariants


@dataclass(frozen=True)
class CoinvariantPresentation:
    moduli: tuple[int, ...]
    generators: tuple[Matrix, ...]
    relations: Matrix
    invariant_factors: tuple[int, ...]
    determinantal_divisors: tuple[int, ...]

    @property
    def nontrivial_factors(self) -> tuple[int, ...]:
        return tuple(value for value in self.invariant_factors if value > 1)


def compile_coinvariants(
    moduli: Sequence[int], action_generators: Sequence[Matrix]
) -> CoinvariantPresentation:
    """Present F_G = F / <Hz-z> for F = direct sum Z/d_i.

    The relation columns are the original diagonal relations followed by every
    column of `H-I`. Each H must preserve the diagonal relation lattice and be
    unimodular; these checks are an exact certificate that H acts on F.
    """
    ds = tuple(moduli)
    if not ds or any(value <= 0 for value in ds):
        raise ValueError("moduli must be positive")
    rank = len(ds)
    checked = []
    for h in action_generators:
        if len(h) != rank or any(len(row) != rank for row in h):
            raise ValueError("action matrix has wrong shape")
        if abs(bareiss_determinant(h)) != 1:
            raise ValueError("action matrix is not unimodular")
        # D^-1 H D must be integral, equivalently d_i divides H_ij d_j.
        if any((h[i][j] * ds[j]) % ds[i] for i in range(rank) for j in range(rank)):
            raise ValueError("action matrix does not preserve the relation lattice")
        checked.append(h)

    columns = []
    for j, modulus in enumerate(ds):
        columns.append(tuple(modulus if i == j else 0 for i in range(rank)))
    for h in checked:
        for j in range(rank):
            columns.append(tuple(h[i][j] - int(i == j) for i in range(rank)))
    relations = tuple(tuple(columns[j][i] for j in range(len(columns)))
                      for i in range(rank))
    invariants = smith_invariants_from_presentation(relations)
    deltas = [1]
    for factor in invariants:
        deltas.append(deltas[-1] * factor)
    return CoinvariantPresentation(ds, tuple(checked), relations, invariants,
                                   tuple(deltas))


def main() -> None:
    try:
        from machinery.smith_path_holonomy import act, witness
        from machinery.smith_holonomy_predictive_control import carrier, element_order
    except ModuleNotFoundError:
        from smith_path_holonomy import act, witness
        from smith_holonomy_predictive_control import carrier, element_order

    *_, h, _, _, _ = witness()
    states = carrier()
    permutation = {state: act(h, state) for state in states}
    predictive = compile_predictive_holonomy(
        states, {"H": permutation}, (element_order,)
    )
    assert len(predictive.crystal.fibers) == 4
    coinvariants = compile_coinvariants((1, 2, 6), (h,))
    assert coinvariants.nontrivial_factors == (3,)
    print({
        "raw_states": len(states),
        "predictive_states": len(predictive.crystal.fibers),
        "coinvariant_factors": coinvariants.nontrivial_factors,
        "relation_matrix": coinvariants.relations,
    })
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

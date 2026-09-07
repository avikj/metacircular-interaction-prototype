#!/usr/bin/env python3
"""Exact finite checks for the reflected-interval Morse obstruction.

This is a dependency-free certificate kernel for one bounded example.  It is
not a general discrete-Morse implementation.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations
from math import gcd
from typing import Hashable, Mapping, Sequence

Cell = Hashable
Pair = tuple[Cell, Cell]
Vector = Mapping[Cell, int]
SignedAction = Mapping[Cell, tuple[int, Cell]]


def apply_action(vector: Vector, action: SignedAction) -> dict[Cell, int]:
    """Apply a signed permutation action to an integral cellular vector."""
    result: dict[Cell, int] = {}
    for cell, coefficient in vector.items():
        sign, target = action[cell]
        result[target] = result.get(target, 0) + sign * coefficient
    return {cell: coefficient for cell, coefficient in result.items() if coefficient}


def boundary_of_action_commutes(
    boundaries: Mapping[Cell, Vector], action: SignedAction
) -> bool:
    """Check d(g cell) = g(d cell) on every declared positive-degree cell."""
    for cell, boundary in boundaries.items():
        sign, target = action[cell]
        target_boundary = {
            face: sign * coefficient
            for face, coefficient in boundaries[target].items()
            if sign * coefficient
        }
        if target_boundary != apply_action(boundary, action):
            return False
    return True


def unit_incidences(boundaries: Mapping[Cell, Vector]) -> tuple[Pair, ...]:
    """Return high/low incidence pairs whose integral coefficient is a unit."""
    return tuple(
        (high, low)
        for high, boundary in boundaries.items()
        for low, coefficient in boundary.items()
        if abs(coefficient) == 1
    )


def _acyclic_matching(
    cells: Sequence[Cell], boundaries: Mapping[Cell, Vector], matching: frozenset[Pair]
) -> bool:
    """Test acyclicity of the Hasse orientation reversed on matched pairs."""
    arrows = {cell: set() for cell in cells}
    for high, boundary in boundaries.items():
        for low, coefficient in boundary.items():
            if not coefficient:
                continue
            if (high, low) in matching:
                arrows[low].add(high)
            else:
                arrows[high].add(low)

    visiting: set[Cell] = set()
    visited: set[Cell] = set()

    def visit(cell: Cell) -> bool:
        if cell in visiting:
            return False
        if cell in visited:
            return True
        visiting.add(cell)
        if not all(visit(target) for target in arrows[cell]):
            return False
        visiting.remove(cell)
        visited.add(cell)
        return True

    return all(visit(cell) for cell in cells)


def acyclic_matchings(
    cells: Sequence[Cell], boundaries: Mapping[Cell, Vector]
) -> tuple[frozenset[Pair], ...]:
    """Exhaust all integral unit acyclic matchings for a finite based complex."""
    incidences = unit_incidences(boundaries)
    result = []
    for size in range(len(incidences) + 1):
        for candidate in combinations(incidences, size):
            used = [cell for pair in candidate for cell in pair]
            matching = frozenset(candidate)
            if len(set(used)) != len(used):
                continue
            if _acyclic_matching(cells, boundaries, matching):
                result.append(matching)
    return tuple(result)


def translate_matching(
    matching: frozenset[Pair], action: SignedAction
) -> frozenset[Pair]:
    """Transport incidence pairs; orientation signs do not change cell use."""
    return frozenset((action[high][1], action[low][1]) for high, low in matching)


def stable_matchings(
    matchings: Sequence[frozenset[Pair]], actions: Sequence[SignedAction]
) -> tuple[frozenset[Pair], ...]:
    """Select matchings invariant under every declared signed permutation."""
    return tuple(
        matching
        for matching in matchings
        if all(translate_matching(matching, action) == matching for action in actions)
    )


def invariant_augmentation_image_generator() -> int:
    """Return the positive generator of epsilon((Z^2)^(C2))."""
    # Invariants under coordinate swap are k(1,1); augmentation sends this to 2k.
    return gcd(2, 0)


def rational_half_section() -> tuple[Fraction, Fraction]:
    """The C2-invariant rational section of augmentation."""
    section = (Fraction(1, 2), Fraction(1, 2))
    assert section[0] == section[1]
    assert sum(section) == 1
    return section


def invariant_augmentation_generator(orbit_sizes: Sequence[int]) -> int:
    """Generator of augmentation on invariants of a finite permutation set."""
    if not orbit_sizes or any(size <= 0 for size in orbit_sizes):
        raise ValueError("orbit sizes must be a nonempty sequence of positives")
    result = orbit_sizes[0]
    for size in orbit_sizes[1:]:
        result = gcd(result, size)
    return result


def reflected_interval_certificate() -> dict[str, object]:
    cells = ("v0", "v1", "e")
    boundaries = {"e": {"v1": 1, "v0": -1}}
    reflection = {
        "v0": (1, "v1"),
        "v1": (1, "v0"),
        "e": (-1, "e"),
    }
    matchings = acyclic_matchings(cells, boundaries)
    stable = stable_matchings(matchings, (reflection,))
    return {
        "chain_action": boundary_of_action_commutes(boundaries, reflection),
        "ordinary_matchings": matchings,
        "stable_matchings": stable,
        "best_ordinary_critical_cells": len(cells) - 2 * max(map(len, matchings)),
        "best_stable_critical_cells": len(cells) - 2 * max(map(len, stable)),
        "integral_augmentation_image_generator": invariant_augmentation_image_generator(),
        "integral_section_exists": invariant_augmentation_image_generator() == 1,
        "rational_section": rational_half_section(),
    }


def orbitwise_control_certificate() -> dict[str, object]:
    """Two intervals exchanged by C2 admit a nonempty orbitwise matching."""
    cells = ("v0", "v1", "w0", "w1", "e", "f")
    boundaries = {
        "e": {"v1": 1, "v0": -1},
        "f": {"w1": 1, "w0": -1},
    }
    swap = {
        "v0": (1, "w0"), "v1": (1, "w1"), "e": (1, "f"),
        "w0": (1, "v0"), "w1": (1, "v1"), "f": (1, "e"),
    }
    orbit_matching = frozenset({("e", "v0"), ("f", "w0")})
    matchings = acyclic_matchings(cells, boundaries)
    return {
        "chain_action": boundary_of_action_commutes(boundaries, swap),
        "matching_is_acyclic": orbit_matching in matchings,
        "matching_is_stable": translate_matching(orbit_matching, swap) == orbit_matching,
        "matched_cells_are_disjoint": len({cell for pair in orbit_matching for cell in pair}) == 4,
        "critical_cells": len(cells) - 2 * len(orbit_matching),
    }


def rotated_triangle_certificate() -> dict[str, object]:
    """The filled triangle has ordinary but no nonempty C3-stable matching."""
    cells = ("v0", "v1", "v2", "e01", "e12", "e20", "t")
    boundaries = {
        "e01": {"v1": 1, "v0": -1},
        "e12": {"v2": 1, "v1": -1},
        "e20": {"v0": 1, "v2": -1},
        "t": {"e01": 1, "e12": 1, "e20": 1},
    }
    rotation = {
        "v0": (1, "v1"), "v1": (1, "v2"), "v2": (1, "v0"),
        "e01": (1, "e12"), "e12": (1, "e20"), "e20": (1, "e01"),
        "t": (1, "t"),
    }
    rotation_squared = {
        cell: (rotation[cell][0] * rotation[rotation[cell][1]][0],
               rotation[rotation[cell][1]][1])
        for cell in cells
    }
    matchings = acyclic_matchings(cells, boundaries)
    stable = stable_matchings(matchings, (rotation, rotation_squared))
    maximum_size = max(map(len, matchings))
    return {
        "chain_action": boundary_of_action_commutes(boundaries, rotation),
        "ordinary_matching_count": len(matchings),
        "ordinary_optimum_count": sum(
            len(matching) == maximum_size for matching in matchings
        ),
        "stable_matchings": stable,
        "best_ordinary_critical_cells": len(cells) - 2 * maximum_size,
        "best_stable_critical_cells": len(cells) - 2 * max(map(len, stable)),
        "vertex_augmentation_image_generator": invariant_augmentation_generator((3,)),
        "rational_vertex_section": (Fraction(1, 3),) * 3,
    }
if __name__ == "__main__":
    reflected = reflected_interval_certificate()
    control = orbitwise_control_certificate()
    triangle = rotated_triangle_certificate()
    assert reflected["chain_action"]
    assert reflected["best_ordinary_critical_cells"] == 1
    assert reflected["best_stable_critical_cells"] == 3
    assert not reflected["integral_section_exists"]
    assert reflected["rational_section"] == (Fraction(1, 2), Fraction(1, 2))
    assert all(control.values())
    assert triangle["chain_action"]
    assert triangle["ordinary_matching_count"] == 40
    assert triangle["ordinary_optimum_count"] == 9
    assert triangle["stable_matchings"] == (frozenset(),)
    assert triangle["best_ordinary_critical_cells"] == 1
    assert triangle["best_stable_critical_cells"] == 7
    assert triangle["vertex_augmentation_image_generator"] == 3
    print("PASS: reflected interval obstructs integral C2-equivariant Morse matching")
    print("PASS: a disjoint orbit of matched pairs gives an equivariant control")
    print("PASS: rotated triangle exposes the C3 fixed-point obstruction")

"""Exact finite criteria for an operational site of experiments.

No external packages are used.  Objects are finite sets, covers are families
of subsets, and observation records are ordinary finite mappings.
"""

from __future__ import annotations

from itertools import combinations
from typing import Hashable, Iterable, Mapping, Sequence


def restricted_yoneda_profile(
    subset: frozenset[Hashable], probes: Sequence[frozenset[Hashable]]
) -> tuple[bool, ...]:
    """The truth-valued profile E |-> Hom(E, subset) in a powerset poset."""
    return tuple(probe <= subset for probe in probes)


def restricted_yoneda_is_faithful(
    universe: frozenset[Hashable], probes: Sequence[frozenset[Hashable]]
) -> bool:
    """Decide whether profiles distinguish every subset of ``universe``."""
    subsets = _powerset(universe)
    profiles = [restricted_yoneda_profile(a, probes) for a in subsets]
    return len(set(profiles)) == len(subsets)


def density_certificate(
    universe: frozenset[Hashable], probes: Sequence[frozenset[Hashable]]
) -> dict[str, object]:
    """Certify the finite powerset density theorem.

    A full probe subcategory of P(Omega) has faithful restricted Yoneda nerve
    exactly when it contains every singleton.
    """
    missing = tuple(x for x in sorted(universe, key=repr) if frozenset({x}) not in probes)
    brute = restricted_yoneda_is_faithful(universe, probes)
    criterion = not missing
    if brute != criterion:
        raise AssertionError("density theorem and exhaustive check disagree")
    return {"faithful": criterion, "missing_singletons": missing}


def observation_partition(
    states: Sequence[Hashable], observations: Sequence[Mapping[Hashable, Hashable]]
) -> tuple[frozenset[Hashable], ...]:
    """Return the contextual crystal: fibers of the joint observation map."""
    fibers: dict[tuple[Hashable, ...], set[Hashable]] = {}
    for state in states:
        signature = tuple(observation[state] for observation in observations)
        fibers.setdefault(signature, set()).add(state)
    return tuple(
        sorted((frozenset(fiber) for fiber in fibers.values()), key=lambda b: tuple(map(repr, b)))
    )


def minimum_separating_family(
    states: Sequence[Hashable], observations: Sequence[Mapping[Hashable, Hashable]]
) -> tuple[int, ...] | None:
    """Return a lexicographically first smallest jointly separating family."""
    target = len(states)
    for size in range(len(observations) + 1):
        for indices in combinations(range(len(observations)), size):
            if len(observation_partition(states, [observations[i] for i in indices])) == target:
                return indices
    return None


def descent_equalizer(
    global_sections: Sequence[Hashable],
    local_sections: Sequence[Sequence[Hashable]],
    restrict_global,
    compatible,
) -> dict[str, object]:
    """Check finite separatedness and effective descent by exhaustive equality.

    ``restrict_global(s)`` is the local tuple of a global section.  The
    ``compatible`` predicate recognizes matching local tuples.  The check is
    exact because every declared section set is finite.
    """
    local_tuples = _cartesian(local_sections)
    matching = {local for local in local_tuples if compatible(local)}
    fibers: dict[tuple[Hashable, ...], list[Hashable]] = {}
    for section in global_sections:
        local = tuple(restrict_global(section))
        if local not in matching:
            raise ValueError("a global section restricts to a non-matching family")
        fibers.setdefault(local, []).append(section)
    injective = all(len(fiber) == 1 for fiber in fibers.values())
    image = set(fibers)
    surjective = image == matching
    return {
        "separated": injective,
        "effective_descent": injective and surjective,
        "matching_count": len(matching),
        "image_count": len(image),
        "invisible_pairs": sum(len(f) * (len(f) - 1) // 2 for f in fibers.values()),
        "missing_matching_families": tuple(sorted(matching - image, key=repr)),
    }


def _powerset(universe: frozenset[Hashable]) -> list[frozenset[Hashable]]:
    items = tuple(universe)
    return [frozenset(c) for n in range(len(items) + 1) for c in combinations(items, n)]


def _cartesian(parts: Sequence[Sequence[Hashable]]) -> list[tuple[Hashable, ...]]:
    out: list[tuple[Hashable, ...]] = [()]
    for part in parts:
        out = [prefix + (value,) for prefix in out for value in part]
    return out

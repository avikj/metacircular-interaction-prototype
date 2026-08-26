#!/usr/bin/env python3
"""Replayability and diminishing returns for minimal proof supports."""

from __future__ import annotations

from itertools import combinations
from typing import FrozenSet, Iterable

Support = FrozenSet[str]


def minimal_supports(supports: Iterable[Iterable[str]]) -> frozenset[Support]:
    """Canonical inclusion-minimal support antichain."""
    family = {frozenset(s) for s in supports}
    return frozenset(s for s in family if not any(t < s for t in family))


def replayable(retained: Iterable[str], supports: Iterable[Iterable[str]]) -> int:
    """Whether some complete derivation support has been retained."""
    kept = frozenset(retained)
    return int(any(s <= kept for s in minimal_supports(supports)))


def submodular_iff_singleton(supports: Iterable[Iterable[str]]) -> bool:
    """The exact classification for a nonseed fact's replayability indicator."""
    antichain = minimal_supports(supports)
    if not antichain or frozenset() in antichain:
        raise ValueError("classification expects a derivable nonseed fact")
    return all(len(s) == 1 for s in antichain)


def first_submodularity_violation(
    supports: Iterable[Iterable[str]],
) -> tuple[Support, Support] | None:
    """Return A,B with f(A)+f(B)<f(A union B)+f(A intersection B)."""
    antichain = minimal_supports(supports)
    universe = sorted(set().union(*antichain) if antichain else set())
    subsets = [frozenset(c) for n in range(len(universe) + 1)
               for c in combinations(universe, n)]
    for a in subsets:
        for b in subsets:
            if (replayable(a, antichain) + replayable(b, antichain)
                    < replayable(a | b, antichain) + replayable(a & b, antichain)):
                return a, b
    return None


def addition_three_event(retained: Iterable[str]) -> frozenset[int]:
    """Least closure of seed 1 under retained r2 and r3 addition rules."""
    kept = set(retained)
    formed = {1}
    changed = True
    while changed:
        changed = False
        if "r2" in kept and 1 in formed and 2 not in formed:
            formed.add(2)
            changed = True
        if "r3" in kept and {1, 2} <= formed and 3 not in formed:
            formed.add(3)
            changed = True
    return frozenset(formed)


if __name__ == "__main__":
    support = ({"r2", "r3"},)
    for retained in (set(), {"r2"}, {"r3"}, {"r2", "r3"}):
        print(sorted(retained), "formed", sorted(addition_three_event(retained)),
              "replayable(3)", replayable(retained, support))
    print("violation", first_submodularity_violation(support))

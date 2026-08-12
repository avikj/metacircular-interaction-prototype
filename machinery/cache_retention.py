#!/usr/bin/env python3
"""Bounded retention for fixed binary-prefix construction paths."""

from __future__ import annotations

from itertools import combinations
from typing import Iterable, Mapping

from cache_relative_formation import binary_prefixes


def saved_work(
    retained: Iterable[int], target_weights: Mapping[int, int]
) -> int:
    """Weighted additions saved by resuming at the deepest retained prefix.

    The formed unit 1 is always available and has depth zero.  Candidate
    retained values are assumed to have been formed already; this function
    prices their future option value, not their acquisition cost.
    """
    kept = set(retained) | {1}
    total = 0
    for target, weight in target_weights.items():
        if target < 1 or weight < 0:
            raise ValueError("targets must be positive and weights nonnegative")
        path = binary_prefixes(target)
        deepest = max(i for i, value in enumerate(path) if value in kept)
        total += weight * deepest
    return total


def candidate_nodes(target_weights: Mapping[int, int]) -> frozenset[int]:
    """Non-root nodes lying on at least one positively weighted target path."""
    return frozenset(
        value
        for target, weight in target_weights.items()
        if weight > 0
        for value in binary_prefixes(target)[1:]
    )


def greedy_retention(
    target_weights: Mapping[int, int], budget: int
) -> tuple[frozenset[int], tuple[tuple[int, int], ...]]:
    """Greedily retain a node of maximum marginal saved work at each step."""
    if budget < 0:
        raise ValueError("budget must be nonnegative")
    chosen: set[int] = set()
    trace: list[tuple[int, int]] = []
    candidates = candidate_nodes(target_weights)
    for _ in range(min(budget, len(candidates))):
        present = saved_work(chosen, target_weights)
        node, gain = max(
            ((x, saved_work(chosen | {x}, target_weights) - present)
             for x in candidates - chosen),
            key=lambda pair: (pair[1], -pair[0]),
        )
        chosen.add(node)
        trace.append((node, gain))
    return frozenset(chosen), tuple(trace)


def exact_retention(
    target_weights: Mapping[int, int], budget: int
) -> tuple[frozenset[int], int]:
    """Exhaustive finite oracle for checking small retention instances."""
    if budget < 0:
        raise ValueError("budget must be nonnegative")
    candidates = sorted(candidate_nodes(target_weights))
    best_set: frozenset[int] = frozenset()
    best_value = 0
    for size in range(min(budget, len(candidates)) + 1):
        for subset in combinations(candidates, size):
            value = saved_work(subset, target_weights)
            if value > best_value:
                best_set, best_value = frozenset(subset), value
    return best_set, best_value


if __name__ == "__main__":
    instance = {10: 1, 11: 1, 12: 1, 13: 1}
    chosen, trace = greedy_retention(instance, 2)
    optimum, value = exact_retention(instance, 2)
    print("targets", instance)
    print("greedy", sorted(chosen), trace, saved_work(chosen, instance))
    print("exact", sorted(optimum), value)

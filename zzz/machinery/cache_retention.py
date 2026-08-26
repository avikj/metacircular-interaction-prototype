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


def trace_parent(node: int) -> int:
    """Unique predecessor in the recorded binary construction trace."""
    if node <= 1:
        raise ValueError("only non-root positive nodes have a parent")
    return node // 2 if node % 2 == 0 else node - 1


def is_ancestor_closed(retained: Iterable[int]) -> bool:
    """Whether every retained node carries its complete non-root proof path."""
    kept = set(retained)
    if any(x <= 1 for x in kept):
        return False
    return all(set(binary_prefixes(x)[1:]) <= kept for x in kept)


def subtree_demand(target_weights: Mapping[int, int]) -> dict[int, int]:
    """Reward of retaining each node when complete proof paths are retained."""
    rewards = {node: 0 for node in candidate_nodes(target_weights)}
    for target, weight in target_weights.items():
        if target < 1 or weight < 0:
            raise ValueError("targets must be positive and weights nonnegative")
        for node in binary_prefixes(target)[1:]:
            rewards[node] += weight
    return rewards


def ancestor_closed_retention(
    target_weights: Mapping[int, int], budget: int
) -> tuple[frozenset[int], tuple[tuple[int, int], ...]]:
    """Exact top-reward retention when each kept node must retain its proof."""
    if budget < 0:
        raise ValueError("budget must be nonnegative")
    rewards = subtree_demand(target_weights)
    depth = {x: len(binary_prefixes(x)) - 1 for x in rewards}
    ranked = sorted(rewards, key=lambda x: (-rewards[x], depth[x], x))
    chosen = frozenset(ranked[:budget])
    if not is_ancestor_closed(chosen):
        raise AssertionError("monotone path rewards failed to form an ideal")
    return chosen, tuple((x, rewards[x]) for x in ranked[:budget])


def exact_ancestor_closed_retention(
    target_weights: Mapping[int, int], budget: int
) -> tuple[frozenset[int], int]:
    """Exhaustive oracle for small replayable-provenance instances."""
    if budget < 0:
        raise ValueError("budget must be nonnegative")
    candidates = sorted(candidate_nodes(target_weights))
    best_set: frozenset[int] = frozenset()
    best_value = 0
    for size in range(min(budget, len(candidates)) + 1):
        for subset in combinations(candidates, size):
            if not is_ancestor_closed(subset):
                continue
            value = saved_work(subset, target_weights)
            if value > best_value:
                best_set, best_value = frozenset(subset), value
    return best_set, best_value


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
    replayable, replay_trace = ancestor_closed_retention(instance, 2)
    print("replayable", sorted(replayable), replay_trace,
          saved_work(replayable, instance))

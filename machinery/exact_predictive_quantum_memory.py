#!/usr/bin/env python3
"""Exact predictive profiles and their zero-error quantum memory dimension."""

from __future__ import annotations

from collections import deque
from math import ceil, log2
from typing import Iterable


def addition_distance(cache: Iterable[int], target: int) -> int:
    """Least additions needed to form target from a persistent positive cache."""
    start = frozenset(cache)
    if not start or min(start) <= 0 or target <= 0:
        raise ValueError("cache and target must be positive")
    if target in start:
        return 0
    queue = deque(((start, 0),))
    seen = {start}
    while queue:
        state, depth = queue.popleft()
        values = tuple(state)
        new_values = {
            left + right
            for left in values
            for right in values
            if left + right <= target and left + right not in state
        }
        for value in new_values:
            if value == target:
                return depth + 1
            next_state = state | {value}
            if next_state not in seen:
                seen.add(next_state)
                queue.append((next_state, depth + 1))
    raise ValueError("target is unreachable under the declared positive bound")


def distance_profile(cache: Iterable[int], targets: Iterable[int]) -> tuple[int, ...]:
    frozen = frozenset(cache)
    return tuple(addition_distance(frozen, target) for target in targets)


def exact_quantum_memory_dimension(
    caches: Iterable[Iterable[int]], targets: Iterable[int]
) -> int:
    """Minimum Hilbert dimension for zero-error readout of every exact profile."""
    target_tuple = tuple(targets)
    profiles = {distance_profile(cache, target_tuple) for cache in caches}
    if not profiles:
        raise ValueError("at least one cache is required")
    return len(profiles)


def exact_quantum_memory_qubits(
    caches: Iterable[Iterable[int]], targets: Iterable[int]
) -> int:
    dimension = exact_quantum_memory_dimension(caches, targets)
    return 0 if dimension == 1 else ceil(log2(dimension))


if __name__ == "__main__":
    caches = ({1, 2, 3, 6}, {1, 2, 4, 6})
    targets = (9,)
    print({
        "profiles": tuple(distance_profile(cache, targets) for cache in caches),
        "dimension": exact_quantum_memory_dimension(caches, targets),
        "qubits": exact_quantum_memory_qubits(caches, targets),
    })

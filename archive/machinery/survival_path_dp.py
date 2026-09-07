"""Subset DP for survival-weighted valuation-center schedules."""

from functools import lru_cache
from itertools import permutations

from center_order_latency import expected_pair


def survival_cost(order, masses, lam):
    remaining = sum(masses)
    query = 0
    motion = 0
    current = 0
    for t, child in enumerate(order):
        if t < len(order) - 1:
            query += remaining
        motion += remaining * abs(child - current)
        remaining -= masses[child]
        current = child
    return query + lam * motion


def subset_optimum(masses, lam):
    p = len(masses)
    full = (1 << p) - 1

    @lru_cache(None)
    def solve(mask, current):
        remaining = [d for d in range(p) if not (mask >> d) & 1]
        weight = sum(masses[d] for d in remaining)
        if len(remaining) == 1:
            child = remaining[0]
            return lam * masses[child] * abs(child - current), (child,)
        choices = []
        for child in remaining:
            tail_cost, tail = solve(mask | (1 << child), child)
            cost = weight * (1 + lam * abs(child - current)) + tail_cost
            choices.append((cost, (child,) + tail))
        return min(choices)

    result = solve(0, 0)
    assert full == (1 << p) - 1
    return result


def permutation_optimum(masses, lam):
    candidates = []
    for order in permutations(range(len(masses))):
        q, s = expected_pair(order, masses)
        candidates.append((q + lam * s, order))
    return min(candidates)


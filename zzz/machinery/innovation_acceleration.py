"""Exact accounting for capability-forming sequential work.

This module deliberately does not predict innovation.  It checks whether a
declared chain of reusable macros can support a claimed time-equivalence.
"""

from __future__ import annotations

from math import prod
from typing import Iterable, Mapping


def nested_span(radices: Iterable[int]) -> int:
    """Primitive trace length denoted by the final nested macro."""
    values = tuple(radices)
    if any(r < 1 for r in values):
        raise ValueError("every reuse count must be positive")
    return prod(values)


def cumulative_work(radices: Iterable[int]) -> int:
    """Primitive-equivalent work if each successively formed macro runs once."""
    span = 1
    total = 0
    for radix in radices:
        if radix < 1:
            raise ValueError("every reuse count must be positive")
        total += span
        span *= radix
    return total


def net_saving(*, old_cost: float, new_cost: float, future_uses: float,
               formation_cost: float, verification_cost: float = 0) -> float:
    """Saving after charging formation and verification exactly once."""
    if min(old_cost, new_cost, future_uses, formation_cost, verification_cost) < 0:
        raise ValueError("costs and uses must be nonnegative")
    return future_uses * (old_cost - new_cost) - formation_cost - verification_cost


def workload_cost(costs: Mapping[str, float], weights: Mapping[str, float]) -> float:
    """Expected cost under an explicitly declared normalized workload."""
    if set(costs) != set(weights):
        raise ValueError("costs and weights must have identical task keys")
    if any(c < 0 for c in costs.values()) or any(w < 0 for w in weights.values()):
        raise ValueError("costs and weights must be nonnegative")
    mass = sum(weights.values())
    if abs(mass - 1.0) > 1e-12:
        raise ValueError("workload weights must sum to one")
    return sum(weights[q] * costs[q] for q in costs)


def throughput_gain(old_costs: Mapping[str, float], new_costs: Mapping[str, float],
                    weights: Mapping[str, float]) -> float:
    """Baseline-equivalent throughput ratio for a stationary workload."""
    old = workload_cost(old_costs, weights)
    new = workload_cost(new_costs, weights)
    if new == 0:
        return float("inf")
    return old / new


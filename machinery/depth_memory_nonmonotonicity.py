#!/usr/bin/env python3
"""Exact comparison of semantic chart depth and coherent overwrite memory."""

from __future__ import annotations

from typing import Callable, Hashable, Iterable

from quantum_quotient_dilation import coherent_environment_dimension


def least_sufficient_depth(
    world: Iterable[int],
    observable: Callable[[int], Hashable],
    charts: tuple[Callable[[int], Hashable], ...],
) -> int:
    points = tuple(world)
    if not points:
        raise ValueError("world must be nonempty")
    for depth, chart in enumerate(charts):
        seen: dict[Hashable, Hashable] = {}
        sufficient = True
        for point in points:
            label, value = chart(point), observable(point)
            if label in seen and seen[label] != value:
                sufficient = False
                break
            seen[label] = value
        if sufficient:
            return depth
    raise ValueError("declared chart chain is insufficient")


def selected_chart_memory(
    world: Iterable[int], charts: tuple[Callable[[int], Hashable], ...], depth: int
) -> int:
    points = tuple(world)
    return coherent_environment_dimension(tuple(charts[depth](x) for x in points))


def valuation(n: int, prime: int) -> int:
    if n == 0:
        raise ValueError("finite valuation example excludes zero")
    depth = 0
    while n % prime == 0:
        n //= prime
        depth += 1
    return depth


def residue_charts(prime: int, max_depth: int):
    return tuple(
        (lambda n, modulus=prime**depth: n % modulus)
        for depth in range(max_depth + 1)
    )


def valuation_world_profile(world: Iterable[int], prime: int, max_depth: int):
    points = tuple(world)
    charts = residue_charts(prime, max_depth)
    depth = least_sufficient_depth(points, lambda n: valuation(n, prime), charts)
    return depth, selected_chart_memory(points, charts, depth)


if __name__ == "__main__":
    before = valuation_world_profile((5, 10, 15, 20), 5, 2)
    after = valuation_world_profile((5, 10, 15, 20, 25), 5, 2)
    print({"before": before, "after": after})

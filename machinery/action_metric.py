#!/usr/bin/env python3
"""Install a derived generator into a finite transformation monoid metric."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Hashable, Mapping, Sequence

from proof_metric import MacroCertificate, ProofEdge, all_pairs_shortest_paths

Transformation = tuple[int, ...]


def then(left: Transformation, right: Transformation) -> Transformation:
    """Apply left first and right second."""
    if len(left) != len(right):
        raise ValueError("transformations act on different carriers")
    return tuple(right[left[index]] for index in range(len(left)))


@dataclass(frozen=True)
class WeightedGenerator:
    name: str
    action: Transformation
    cost: Fraction | int


@dataclass(frozen=True)
class DerivedGenerator:
    name: str
    expansion: tuple[str, ...]
    access_cost: Fraction | int


@dataclass(frozen=True)
class ActionMetricCompilation:
    elements: tuple[Transformation, ...]
    derived_action: Transformation
    validation_cost: Fraction
    before: Mapping[tuple[Transformation, Transformation], Fraction | None]
    after: Mapping[tuple[Transformation, Transformation], Fraction | None]
    influence_cone: tuple[
        tuple[Transformation, Transformation, Fraction, Fraction], ...
    ]


def _validate_generators(
    carrier_size: int, generators: Sequence[WeightedGenerator]
) -> tuple[WeightedGenerator, ...]:
    if carrier_size < 0:
        raise ValueError("carrier size must be nonnegative")
    result = []
    names = set()
    for generator in generators:
        if generator.name in names:
            raise ValueError("generator names must be unique")
        if len(generator.action) != carrier_size:
            raise ValueError("generator has wrong carrier size")
        if any(value < 0 or value >= carrier_size for value in generator.action):
            raise ValueError("generator leaves the carrier")
        cost = Fraction(generator.cost)
        if cost < 0:
            raise ValueError("generator costs must be nonnegative")
        names.add(generator.name)
        result.append(WeightedGenerator(generator.name, generator.action, cost))
    return tuple(result)


def generated_monoid(
    carrier_size: int, generators: Sequence[WeightedGenerator]
) -> tuple[Transformation, ...]:
    checked = _validate_generators(carrier_size, generators)
    identity = tuple(range(carrier_size))
    seen = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop(0)
        for generator in checked:
            successor = then(current, generator.action)
            if successor not in seen:
                seen.add(successor)
                frontier.append(successor)
    return tuple(sorted(seen))


def compile_derived_generator(
    carrier_size: int,
    generators: Sequence[WeightedGenerator],
    derived: DerivedGenerator,
) -> ActionMetricCompilation:
    """Adjoin an already-generated action as a cheaper generator.

    The semantic transformation monoid is unchanged.  The macro supplies an
    edge s -> s*m from every monoid element s, so the update is context-indexed
    rather than a single rank-one relaxation.
    """
    checked = _validate_generators(carrier_size, generators)
    by_name = {generator.name: generator for generator in checked}
    if derived.name in by_name:
        raise ValueError("derived name collides with a generator")
    if not derived.expansion:
        raise ValueError("derived generator needs a nonempty expansion")
    action = tuple(range(carrier_size))
    validation_cost = Fraction(0)
    for name in derived.expansion:
        try:
            generator = by_name[name]
        except KeyError as exc:
            raise ValueError(f"unknown generator in expansion: {name}") from exc
        action = then(action, generator.action)
        validation_cost += Fraction(generator.cost)
    access_cost = Fraction(derived.access_cost)
    if access_cost < 0:
        raise ValueError("derived access cost must be nonnegative")

    elements = generated_monoid(carrier_size, checked)
    base_edges = tuple(
        ProofEdge(
            f"{generator.name}@{index}", state, then(state, generator.action),
            generator.cost,
        )
        for index, state in enumerate(elements)
        for generator in checked
    )
    before, _ = all_pairs_shortest_paths(elements, base_edges)
    macro_edges = tuple(
        ProofEdge(f"{derived.name}@{index}", state, then(state, action), access_cost)
        for index, state in enumerate(elements)
    )
    after, _ = all_pairs_shortest_paths(elements, base_edges + macro_edges)
    if set(generated_monoid(
        carrier_size, checked + (WeightedGenerator(derived.name, action, access_cost),)
    )) != set(elements):
        raise AssertionError("certified derived generator changed semantic closure")
    influence = tuple(
        (source, target, before[source, target], after[source, target])
        for source in elements for target in elements
        if before[source, target] is not None
        and after[source, target] is not None
        and after[source, target] < before[source, target]
    )
    return ActionMetricCompilation(
        elements, action, validation_cost, before, after, influence
    )

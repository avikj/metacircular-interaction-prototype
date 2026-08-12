#!/usr/bin/env python3
"""Finite syntactic/observational algebra: contexts make quotient compositional."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Hashable, Mapping, Sequence

Element = Hashable
Output = Hashable


@dataclass(frozen=True)
class Operation:
    name: str
    arity: int
    table: Mapping[tuple[Element, ...], Element]


@dataclass(frozen=True)
class CompositionalCrystal:
    fibers: tuple[tuple[Element, ...], ...]
    observations: tuple[Output, ...]
    operations: tuple[tuple[str, int, tuple[tuple[tuple[int, ...], int], ...]], ...]
    equations: tuple[tuple[Element, Element], ...]


def _validate(elements: tuple[Element, ...], operations: tuple[Operation, ...]) -> None:
    universe = set(elements)
    for operation in operations:
        if operation.arity < 0:
            raise ValueError("operation arity must be nonnegative")
        inputs = tuple(product(elements, repeat=operation.arity))
        if any(args not in operation.table for args in inputs):
            raise ValueError(f"operation {operation.name} is not total")
        if any(operation.table[args] not in universe for args in inputs):
            raise ValueError(f"operation {operation.name} is not closed")


def _translations(elements: tuple[Element, ...], operations: tuple[Operation, ...]):
    """All elementary one-hole contexts f(a0,...,-,...,an)."""
    result = []
    for operation in operations:
        for slot in range(operation.arity):
            for fixed in product(elements, repeat=operation.arity - 1):
                def translate(value, op=operation, index=slot, constants=fixed):
                    args = list(constants)
                    args.insert(index, value)
                    return op.table[tuple(args)]
                result.append(translate)
    return tuple(result)


def crystallize_algebra(
    elements: Sequence[Element],
    operations: Sequence[Operation],
    observation: Mapping[Element, Output],
) -> CompositionalCrystal:
    """Compute the greatest algebra congruence contained in ker(observation)."""
    xs, ops = tuple(elements), tuple(operations)
    if len(set(xs)) != len(xs):
        raise ValueError("elements must be unique")
    if any(x not in observation for x in xs):
        raise ValueError("observation must be total")
    _validate(xs, ops)
    contexts = _translations(xs, ops)
    block = {x: 0 for x in xs}
    while True:
        signatures = {
            x: (observation[x], tuple(block[context(x)] for context in contexts))
            for x in xs
        }
        unique = sorted(set(signatures.values()), key=repr)
        codes = {signature: index for index, signature in enumerate(unique)}
        refined = {x: codes[signatures[x]] for x in xs}
        if all(refined[x] == block[x] for x in xs):
            break
        block = refined

    fibers = tuple(tuple(x for x in xs if block[x] == index)
                   for index in range(max(block.values(), default=-1) + 1))
    quotient_ops = []
    for operation in ops:
        table = {}
        for classes in product(range(len(fibers)), repeat=operation.arity):
            representatives = tuple(fibers[index][0] for index in classes)
            table[classes] = block[operation.table[representatives]]
        quotient_ops.append((operation.name, operation.arity,
                             tuple(sorted(table.items(), key=repr))))
    equations = tuple((left, right) for i, left in enumerate(xs)
                      for right in xs[i + 1:] if block[left] == block[right])
    return CompositionalCrystal(
        fibers,
        tuple(observation[fiber[0]] for fiber in fibers),
        tuple(quotient_ops),
        equations,
    )


def factor_map(crystal: CompositionalCrystal,
               mapping: Mapping[Element, Hashable]) -> tuple[Hashable, ...]:
    """Unique quotient factor, or fail if mapping distinguishes an equation."""
    result = []
    for fiber in crystal.fibers:
        images = {mapping[element] for element in fiber}
        if len(images) != 1:
            raise ValueError("map does not coequalize the observational equations")
        result.append(next(iter(images)))
    return tuple(result)

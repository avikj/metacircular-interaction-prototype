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
    distinctions: tuple[tuple[Element, Element, tuple[tuple[str, int, tuple[Element, ...]], ...], Output, Output], ...]
    separating_contexts: tuple[tuple[tuple[str, int, tuple[Element, ...]], ...], ...]


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
                result.append(((operation.name, slot, fixed), translate))
    return tuple(result)


def _distinguishing_contexts(elements, translations, observation, block):
    """Shortest elementary-context words separating every inequivalent pair."""
    index = {element: i for i, element in enumerate(elements)}
    pairs = tuple((i, j) for i in range(len(elements)) for j in range(i + 1, len(elements)))
    witnesses = {
        pair: () for pair in pairs
        if observation[elements[pair[0]]] != observation[elements[pair[1]]]
    }
    changed = True
    while changed:
        changed = False
        for pair in pairs:
            if pair in witnesses:
                continue
            left, right = elements[pair[0]], elements[pair[1]]
            for translation_index, (_, translation) in enumerate(translations):
                image = tuple(sorted((index[translation(left)], index[translation(right)])))
                if image[0] != image[1] and image in witnesses:
                    witnesses[pair] = (translation_index,) + witnesses[image]
                    changed = True
                    break
    result = []
    for i, j in pairs:
        left, right = elements[i], elements[j]
        if block[left] == block[right]:
            continue
        word = witnesses[(i, j)]
        out_left, out_right = left, right
        labels = []
        for translation_index in word:
            label, translation = translations[translation_index]
            labels.append(label)
            out_left, out_right = translation(out_left), translation(out_right)
        result.append((left, right, tuple(labels),
                       observation[out_left], observation[out_right]))
    return tuple(result)


def _minimum_context_basis(elements, translations, observation, block):
    """Exact minimum contexts separating all quotient classes."""
    identity = tuple(elements)
    transformations = {identity: ()}
    frontier = [identity]
    while frontier:
        current = frontier.pop(0)
        word = transformations[current]
        for label, translation in translations:
            composite = tuple(translation(value) for value in current)
            if composite not in transformations:
                transformations[composite] = word + (label,)
                frontier.append(composite)
    pairs = tuple((i, j) for i in range(len(elements)) for j in range(i + 1, len(elements))
                  if block[elements[i]] != block[elements[j]])
    candidates = []
    for transformation, word in transformations.items():
        separated = frozenset(
            pair for pair in pairs
            if observation[transformation[pair[0]]] != observation[transformation[pair[1]]]
        )
        if separated:
            candidates.append((word, separated))
    target = frozenset(pairs)
    for size in range(len(candidates) + 1):
        from itertools import combinations
        for indices in combinations(range(len(candidates)), size):
            covered = frozenset().union(
                *(candidates[i][1] for i in indices)
            )
            if covered == target:
                return tuple(candidates[i][0] for i in indices)
    raise AssertionError("all inequivalent pairs have a distinguishing context")


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
            x: (observation[x], tuple(block[context(x)] for _, context in contexts))
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
    distinctions = _distinguishing_contexts(xs, contexts, observation, block)
    separating_contexts = _minimum_context_basis(xs, contexts, observation, block)
    return CompositionalCrystal(
        fibers,
        tuple(observation[fiber[0]] for fiber in fibers),
        tuple(quotient_ops),
        equations,
        distinctions,
        separating_contexts,
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

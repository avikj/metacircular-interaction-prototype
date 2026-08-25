#!/usr/bin/env python3
"""Exact finite certificates for transferable observable formation."""

from __future__ import annotations

from collections import deque
from typing import Hashable, Mapping, Sequence

State = Hashable
Output = Hashable


def restriction_collision(
    states: Sequence[State], training: Sequence[State],
    observables: Sequence[Mapping[State, Output]],
) -> tuple[int, int, State] | None:
    """Return two admissible observables fitting training but differing outside."""
    xs, seen = tuple(states), set(training)
    if not seen <= set(xs):
        raise ValueError("training states must belong to the domain")
    candidates = tuple(observables)
    if any(set(candidate) != set(xs) for candidate in candidates):
        raise ValueError("every observable must cover exactly the domain")
    for left in range(len(candidates)):
        for right in range(left + 1, len(candidates)):
            if any(candidates[left][x] != candidates[right][x] for x in seen):
                continue
            witness = next((x for x in xs if
                            candidates[left][x] != candidates[right][x]), None)
            if witness is not None:
                return left, right, witness
    return None


def orbit_closure(
    states: Sequence[State], training: Sequence[State],
    generators: Sequence[Mapping[State, State]],
) -> tuple[State, ...]:
    """Compute states generated from training by declared transformations."""
    xs, seeds, actions = tuple(states), tuple(training), tuple(generators)
    universe = set(xs)
    if not set(seeds) <= universe:
        raise ValueError("training states must belong to the domain")
    if any(set(action) != universe or any(action[x] not in universe for x in xs)
           for action in actions):
        raise ValueError("every generator must be a total endomap")
    reached, queue = set(seeds), deque(seeds)
    while queue:
        state = queue.popleft()
        for action in actions:
            image = action[state]
            if image not in reached:
                reached.add(image)
                queue.append(image)
    return tuple(x for x in xs if x in reached)


def is_equivariant(
    states: Sequence[State], observable: Mapping[State, Output],
    state_generators: Sequence[Mapping[State, State]],
    output_generators: Sequence[Mapping[Output, Output]],
) -> bool:
    """Check q(gx)=gq(x) for paired state/output generators."""
    xs = tuple(states)
    if len(state_generators) != len(output_generators):
        raise ValueError("state and output generators must be paired")
    if set(observable) != set(xs):
        raise ValueError("observable must cover exactly the domain")
    return all(observable[g[x]] == h[observable[x]]
               for g, h in zip(state_generators, output_generators)
               for x in xs)

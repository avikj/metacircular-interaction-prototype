#!/usr/bin/env python3
"""Exact predictive memory for persistent addition-chain caches."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable


@dataclass(frozen=True)
class AdditionEvent:
    left: int
    right: int
    result: int


@dataclass(frozen=True)
class ChainState:
    endpoint: int
    formed: frozenset[int]
    events: tuple[AdditionEvent, ...]


def execute_chain(events: Iterable[tuple[int, int]], seed: int = 1) -> ChainState:
    """Execute additions, retaining every formed intermediate value."""
    formed = {seed}
    replay = []
    endpoint = seed
    for left, right in events:
        if left not in formed or right not in formed:
            raise ValueError("every operand must already be formed")
        endpoint = left + right
        formed.add(endpoint)
        replay.append(AdditionEvent(left, right, endpoint))
    return ChainState(endpoint, frozenset(formed), tuple(replay))


def available(state: ChainState, value: int) -> bool:
    """An admitted future observation of the persistent formed-value cache."""
    return value in state.formed


def separating_values(left: ChainState, right: ChainState) -> tuple[int, ...]:
    """Shortest one-step cache queries separating two histories."""
    return tuple(sorted(left.formed.symmetric_difference(right.formed)))


def endpoint_partition(states: Iterable[ChainState]):
    groups: dict[int, list[int]] = {}
    for index, state in enumerate(states):
        groups.setdefault(state.endpoint, []).append(index)
    return tuple(tuple(group) for group in groups.values())


def predictive_partition(states: Iterable[ChainState], probes: Iterable[int]):
    groups: dict[tuple[bool, ...], list[int]] = {}
    probe_tuple = tuple(probes)
    for index, state in enumerate(states):
        profile = tuple(available(state, value) for value in probe_tuple)
        groups.setdefault(profile, []).append(index)
    return tuple(tuple(group) for group in groups.values())


if __name__ == "__main__":
    via_three = execute_chain(((1, 1), (1, 2), (3, 3)))
    via_four = execute_chain(((1, 1), (2, 2), (2, 4)))
    print({
        "endpoint_partition": endpoint_partition((via_three, via_four)),
        "predictive_partition": predictive_partition((via_three, via_four), (3, 4)),
        "separating_values": separating_values(via_three, via_four),
    })

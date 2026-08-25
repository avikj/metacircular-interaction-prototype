#!/usr/bin/env python3
"""Zero-error process discrimination for finite deterministic actions."""

from __future__ import annotations

from collections import deque
from itertools import product
from typing import Callable, Hashable, Iterable


State = Hashable
Action = tuple[str, Callable[[State], State]]
Observation = tuple[str, Callable[[State], Hashable]]


def apply_word(state: State, word: tuple[int, ...], actions: tuple[Action, ...]):
    for index in word:
        state = actions[index][1](state)
    return state


def deterministic_trace_distance(left: Hashable, right: Hashable) -> int:
    """Trace distance of two diagonal point-mass density matrices."""
    return 0 if left == right else 1


def shortest_discrimination_experiment(
    left: State,
    right: State,
    actions: Iterable[Action],
    observations: Iterable[Observation],
    max_depth: int,
):
    action_tuple = tuple(actions)
    observation_tuple = tuple(observations)
    for depth in range(max_depth + 1):
        for word in product(range(len(action_tuple)), repeat=depth):
            x = apply_word(left, word, action_tuple)
            y = apply_word(right, word, action_tuple)
            for name, observation in observation_tuple:
                ox, oy = observation(x), observation(y)
                if deterministic_trace_distance(ox, oy) == 1:
                    return {
                        "action_depth": depth,
                        "word": tuple(action_tuple[i][0] for i in word),
                        "observation": name,
                        "outcomes": (ox, oy),
                    }
    return None


def bfs_discrimination_depths(
    states: Iterable[State],
    actions: Iterable[Action],
    observations: Iterable[Observation],
):
    """Reverse-BFS depths from immediate perfect-discrimination seeds."""
    state_tuple = tuple(states)
    action_tuple = tuple(actions)
    observation_tuple = tuple(observations)
    pairs = tuple((x, y) for x in state_tuple for y in state_tuple)
    predecessors = {pair: [] for pair in pairs}
    for pair in pairs:
        for name, action in action_tuple:
            target = (action(pair[0]), action(pair[1]))
            predecessors[target].append((pair, name))
    depths = {}
    queue = deque()
    for pair in pairs:
        if any(observation(pair[0]) != observation(pair[1])
               for _, observation in observation_tuple):
            depths[pair] = 0
            queue.append(pair)
    while queue:
        target = queue.popleft()
        for source, _ in predecessors[target]:
            if source not in depths:
                depths[source] = depths[target] + 1
                queue.append(source)
    return depths


if __name__ == "__main__":
    actions = (("a", lambda x: min(x + 1, 3)),)
    observations = (("is3", lambda x: x == 3),)
    print(shortest_discrimination_experiment(0, 1, actions, observations, 4))

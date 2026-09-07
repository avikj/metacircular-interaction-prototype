#!/usr/bin/env python3
"""Exact finite bridge from predictive splits to reversible memory costs."""

from __future__ import annotations

from collections import defaultdict, deque
from typing import Callable, Hashable, Iterable, Sequence


def split_multiplicities(
    old_labels: Sequence[Hashable], refined_labels: Sequence[Hashable]
) -> dict[Hashable, int]:
    """Count refined quotient classes over each old quotient class.

    The tables are indexed by the same finite underlying states.  A refined
    label must determine a unique old label; otherwise it is not a refinement.
    """
    if not old_labels or len(old_labels) != len(refined_labels):
        raise ValueError("nonempty label tables of equal length are required")
    refined_to_old: dict[Hashable, Hashable] = {}
    old_to_refined: dict[Hashable, set[Hashable]] = defaultdict(set)
    for old, refined in zip(old_labels, refined_labels):
        previous = refined_to_old.setdefault(refined, old)
        if previous != old:
            raise ValueError("the proposed new quotient does not refine the old one")
        old_to_refined[old].add(refined)
    return {old: len(labels) for old, labels in old_to_refined.items()}


def forgetting_environment_dimension(
    old_labels: Sequence[Hashable], refined_labels: Sequence[Hashable]
) -> int:
    """Minimum environment dimension for coherent refined-to-old overwrite."""
    return max(split_multiplicities(old_labels, refined_labels).values())


def old_state_can_reconstruct_refinement(
    old_labels: Sequence[Hashable], refined_labels: Sequence[Hashable]
) -> bool:
    """Whether the refined label is a deterministic function of the old one."""
    return forgetting_environment_dimension(old_labels, refined_labels) == 1


def shortest_new_witnesses(
    states: Sequence[int],
    actions: Iterable[tuple[str, Callable[[int], int]]],
    old_label: Callable[[int], Hashable],
    observations: Iterable[tuple[str, Callable[[int], Hashable]]],
) -> dict[tuple[int, int], tuple[tuple[str, ...], str]]:
    """Reverse-BFS shortest witnesses, restricted to unresolved old blocks."""
    action_list = tuple(actions)
    observation_list = tuple(observations)
    pairs = tuple(
        (x, y) for x in states for y in states if old_label(x) == old_label(y)
    )
    pair_set = set(pairs)
    predecessors: dict[tuple[int, int], list[tuple[tuple[int, int], str]]] = {
        pair: [] for pair in pairs
    }
    for pair in pairs:
        for name, action in action_list:
            image = (action(pair[0]), action(pair[1]))
            if image not in pair_set:
                raise ValueError("actions must preserve the old predictive blocks")
            predecessors[image].append((pair, name))

    found: dict[tuple[int, int], tuple[tuple[str, ...], str]] = {}
    queue: deque[tuple[int, int]] = deque()
    for pair in pairs:
        for name, observation in observation_list:
            if observation(pair[0]) != observation(pair[1]):
                found[pair] = ((), name)
                queue.append(pair)
                break
    while queue:
        image = queue.popleft()
        suffix, observation = found[image]
        for source, action_name in predecessors[image]:
            if source not in found:
                found[source] = ((action_name,) + suffix, observation)
                queue.append(source)
    return found


def mod_six_certificate() -> dict[str, object]:
    """The parity -> (parity, mod 3 predictive signature) arithmetic example."""
    states = tuple(range(6))
    old = tuple(x % 2 for x in states)
    refined = tuple(x for x in states)  # CRT: parity together with mod 3.
    witnesses = shortest_new_witnesses(
        states,
        (("+2", lambda x: (x + 2) % 6),),
        lambda x: x % 2,
        (("3|x", lambda x: x % 3 == 0),),
    )
    unresolved_distinct = [
        (x, y) for x in states for y in states
        if x < y and old[x] == old[y]
    ]
    if not all(pair in witnesses for pair in unresolved_distinct):
        raise AssertionError("new observation failed to split a parity block")
    maximum_length = max(len(witnesses[pair][0]) for pair in unresolved_distinct)
    return {
        "old_classes": len(set(old)),
        "refined_classes": len(set(refined)),
        "split_multiplicities": split_multiplicities(old, refined),
        "forgetting_environment_dimension": forgetting_environment_dimension(old, refined),
        "old_state_can_reconstruct": old_state_can_reconstruct_refinement(old, refined),
        "maximum_shortest_new_witness_length": maximum_length,
        "witness_2_vs_4": witnesses[(2, 4)],
        "witness_1_vs_5": witnesses[(1, 5)],
    }


if __name__ == "__main__":
    print(mod_six_certificate())

#!/usr/bin/env python3
"""Minimal compositional crystal of a finite observed dynamical system.

A finite natural machine is a deterministic Moore system (X, A, delta, obs).
Two states crystallize together exactly when no finite word of interventions
can distinguish their observations. Partition refinement computes the unique
minimal quotient while retaining every dependent-origin fiber.
"""

from __future__ import annotations

from dataclasses import dataclass
from collections import deque
from typing import Hashable, Mapping, Sequence

State = Hashable
Action = Hashable
Output = Hashable


@dataclass(frozen=True)
class Crystal:
    fibers: tuple[tuple[State, ...], ...]
    observations: tuple[Output, ...]
    transitions: tuple[tuple[int, ...], ...]
    actions: tuple[Action, ...]

    def validate(self) -> None:
        count = len(self.fibers)
        if len(self.observations) != count or len(self.transitions) != count:
            raise ValueError("quotient tables disagree")
        if any(len(row) != len(self.actions) for row in self.transitions):
            raise ValueError("transition row has wrong arity")
        if any(target < 0 or target >= count
               for row in self.transitions for target in row):
            raise ValueError("transition leaves quotient")


def run_word(
    state: State,
    word: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
) -> State:
    """Apply a finite experiment to a state."""
    current = state
    for action in word:
        current = transition[current, action]
    return current


def shortest_distinguishing_word(
    left: State,
    right: State,
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> tuple[Action, ...] | None:
    """Return a shortest future experiment separating two states, if one exists.

    Breadth-first search occurs on pairs of states.  Returning ``None`` means
    no finite action word can distinguish the pair in the supplied finite
    total system.
    """
    if observation[left] != observation[right]:
        return ()
    start = (left, right)
    queue = deque([(start, ())])
    seen = {start}
    for_pair = tuple(actions)
    while queue:
        (x, y), word = queue.popleft()
        for action in for_pair:
            next_pair = (transition[x, action], transition[y, action])
            next_word = word + (action,)
            if observation[next_pair[0]] != observation[next_pair[1]]:
                return next_word
            if next_pair not in seen:
                seen.add(next_pair)
                queue.append((next_pair, next_word))
    return None


def explain_distinctions(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> dict[tuple[State, State], tuple[Action, ...] | None]:
    """Give every unordered state pair its shortest separating experiment."""
    xs = tuple(states)
    return {
        (left, right): shortest_distinguishing_word(
            left, right, actions, transition, observation
        )
        for index, left in enumerate(xs)
        for right in xs[index + 1:]
    }


def crystallize(
    states: Sequence[State],
    actions: Sequence[Action],
    transition: Mapping[tuple[State, Action], State],
    observation: Mapping[State, Output],
) -> Crystal:
    """Compute behavioral/contextual equivalence by stable refinement."""
    xs = tuple(states)
    acts = tuple(actions)
    if len(set(xs)) != len(xs) or len(set(acts)) != len(acts):
        raise ValueError("states and actions must be unique")
    if any((x, a) not in transition for x in xs for a in acts):
        raise ValueError("transition must be total")
    if any(x not in observation for x in xs):
        raise ValueError("observation must be total")
    if any(transition[x, a] not in set(xs) for x in xs for a in acts):
        raise ValueError("transition must be closed")

    block = {x: 0 for x in xs}
    while True:
        signatures = {
            x: (observation[x], tuple(block[transition[x, a]] for a in acts))
            for x in xs
        }
        ordered = sorted(set(signatures.values()), key=repr)
        code = {signature: index for index, signature in enumerate(ordered)}
        refined = {x: code[signatures[x]] for x in xs}
        if all(refined[x] == block[x] for x in xs):
            break
        block = refined

    fibers = tuple(
        tuple(x for x in xs if block[x] == index)
        for index in range(max(block.values(), default=-1) + 1)
    )
    observations = tuple(observation[fiber[0]] for fiber in fibers)
    transitions = tuple(
        tuple(block[transition[fiber[0], action]] for action in acts)
        for fiber in fibers
    )
    result = Crystal(fibers, observations, transitions, acts)
    result.validate()
    return result


def twelve_link_machine() -> Crystal:
    """A minimal intervention toy, not a historical or physical model.

    State i means the first active link is i. `arise` advances conditioning;
    `cease` interrupts at the present link and returns to quiescence. State 12
    is quiescence. Each link has a distinct declared observation, so this
    fixture tests that the runtime does not manufacture identifications.
    """
    states = tuple(range(13))
    actions = ("arise", "cease")
    transition = {}
    for state in states:
        transition[state, "arise"] = min(state + 1, 12)
        transition[state, "cease"] = 12
    observation = {state: ("quiescent" if state == 12 else f"link-{state + 1}")
                   for state in states}
    return crystallize(states, actions, transition, observation)

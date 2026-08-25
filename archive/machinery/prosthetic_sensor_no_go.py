#!/usr/bin/env python3
"""Exact boundary for conservative repair of an out-of-model probe outcome."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Hashable, Mapping, Sequence

State = Hashable
Output = Hashable


@dataclass(frozen=True)
class PreservationDefect:
    new_state: State
    projected_state: State
    revised_output: Output
    old_output: Output


def preservation_defects(
    old_response: Mapping[State, Output],
    new_states: Sequence[State],
    state_projection: Mapping[State, State],
    revised_response: Mapping[State, Output],
) -> tuple[PreservationDefect, ...]:
    """Return every failure of q' = q o pi; reject incomplete data."""
    xs = tuple(new_states)
    if set(state_projection) != set(xs) or set(revised_response) != set(xs):
        raise ValueError("projection and revised response must cover new states exactly")
    if any(state_projection[x] not in old_response for x in xs):
        raise ValueError("projection targets an unknown old state")
    return tuple(
        PreservationDefect(x, state_projection[x], revised_response[x],
                           old_response[state_projection[x]])
        for x in xs
        if revised_response[x] != old_response[state_projection[x]]
    )


def absent_outcome_witness(
    old_response: Mapping[State, Output],
    new_states: Sequence[State],
    revised_response: Mapping[State, Output],
) -> tuple[State, Output] | None:
    """Return a revised state realizing an output outside the old image."""
    image = set(old_response.values())
    return next(((x, revised_response[x]) for x in new_states
                 if revised_response[x] not in image), None)


def conservative_absorption_possible(
    old_response: Mapping[State, Output],
    new_states: Sequence[State],
    state_projection: Mapping[State, State],
    revised_response: Mapping[State, Output],
) -> bool:
    """Whether the square commutes and no genuinely absent output is added."""
    return (not preservation_defects(old_response, new_states, state_projection,
                                     revised_response)
            and absent_outcome_witness(old_response, new_states,
                                       revised_response) is None)

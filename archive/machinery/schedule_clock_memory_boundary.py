"""Exact boundary between external schedule metadata and predictive memory."""

from dataclasses import dataclass
from typing import Callable, Hashable, Sequence


@dataclass(frozen=True)
class ScheduledState:
    terminal: Hashable
    arrival_time: int


Future = Callable[[ScheduledState], Hashable]


def predictive_classes(
    states: Sequence[ScheduledState], futures: Sequence[Future]
) -> tuple[tuple[int, ...], ...]:
    """Partition schedules by every admitted future response."""
    signatures: list[tuple[Hashable, ...]] = []
    classes: list[list[int]] = []
    for index, state in enumerate(states):
        signature = tuple(future(state) for future in futures)
        if signature in signatures:
            classes[signatures.index(signature)].append(index)
        else:
            signatures.append(signature)
            classes.append([index])
    return tuple(tuple(indices) for indices in classes)


def terminal_future(action: Callable[[Hashable], Hashable]) -> Future:
    return lambda state: action(state.terminal)


def age_query(state: ScheduledState) -> int:
    return state.arrival_time


def deadline_query(deadline: int) -> Future:
    return lambda state: state.arrival_time <= deadline


def memory_profile(arrival_times: Sequence[int]) -> dict[str, int]:
    """Compare terminal-only and clock-readable predictive dimensions."""
    if not arrival_times or any(time < 0 for time in arrival_times):
        raise ValueError("arrival times must be a nonempty nonnegative family")
    states = tuple(ScheduledState("same-terminal-record", time) for time in arrival_times)
    terminal_classes = predictive_classes(states, (terminal_future(lambda x: x),))
    clock_classes = predictive_classes(states, (age_query,))
    return {
        "schedules": len(states),
        "terminal_only_dimension": len(terminal_classes),
        "clock_readable_dimension": len(clock_classes),
    }


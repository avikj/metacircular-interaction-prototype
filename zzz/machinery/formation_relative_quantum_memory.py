"""Coherent overwrite cost relative to a formed subset of the source."""

from collections import Counter
from typing import Callable, Hashable, Iterable, TypeVar


X = TypeVar("X", bound=Hashable)
Y = TypeVar("Y", bound=Hashable)


def formed_memory_dimension(formed: Iterable[X], sensor: Callable[[X], Y]) -> int:
    """Exact environment dimension for overwriting the formed basis states."""
    states = tuple(formed)
    if not states or len(set(states)) != len(states):
        raise ValueError("formed states must be a nonempty finite set")
    fibers = Counter(sensor(state) for state in states)
    return max(fibers.values())


def restriction_profile(
    ambient: Iterable[X], formed: Iterable[X], sensor: Callable[[X], Y]
) -> dict[str, int | bool]:
    """Compare exact coherent costs on a finite ambient set and its subset."""
    universe = tuple(ambient)
    states = tuple(formed)
    if not universe or len(set(universe)) != len(universe):
        raise ValueError("ambient states must be a nonempty finite set")
    if not set(states) <= set(universe):
        raise ValueError("formed states must lie in the ambient set")
    ambient_cost = formed_memory_dimension(universe, sensor)
    formed_cost = formed_memory_dimension(states, sensor)
    return {
        "ambient_size": len(universe),
        "formed_size": len(states),
        "ambient_dimension": ambient_cost,
        "formed_dimension": formed_cost,
        "restriction_is_lower_bound": formed_cost <= ambient_cost,
        "certifies_ambient_dimension": formed_cost == ambient_cost,
    }


def residue_formed_cost(formed: Iterable[int], modulus: int) -> int:
    if modulus < 1:
        raise ValueError("modulus must be positive")
    return formed_memory_dimension(formed, lambda value: value % modulus)


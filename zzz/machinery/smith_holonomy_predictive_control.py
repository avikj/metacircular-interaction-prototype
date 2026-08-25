#!/usr/bin/env python3
"""Predictive control where nontrivial Smith holonomy is task-invisible."""

from __future__ import annotations

from math import gcd, lcm
from typing import Callable, Hashable

try:
    from machinery.natural_crystal import Crystal, crystallize
    from machinery.smith_path_holonomy import act, witness
except ModuleNotFoundError:  # direct `python3 machinery/...py` execution
    from natural_crystal import Crystal, crystallize
    from smith_path_holonomy import act, witness

Element = tuple[int, int, int]


def carrier() -> tuple[Element, ...]:
    return tuple((0, a, b) for a in range(2) for b in range(6))


def element_order(value: Element) -> int:
    """Additive order in Z/1 + Z/2 + Z/6."""
    _, a, b = value
    order_two = 1 if a == 0 else 2
    order_six = 1 if b == 0 else 6 // gcd(b, 6)
    return lcm(order_two, order_six)


def holonomy_world(observation: Callable[[Element], Hashable]) -> Crystal:
    """Minimize the C3 holonomy action for one declared observation."""
    *_, h, _, _, _ = witness()
    states = carrier()
    actions = ("H",)
    transition = {(state, "H"): act(h, state) for state in states}
    observations = {state: observation(state) for state in states}
    return crystallize(states, actions, transition, observations)


def invariant_observation_collapses_future(
    observation: Callable[[Element], Hashable],
) -> bool:
    """Finite replay of the general invariant-observation lemma.

    If O(Hx)=O(x), then O(H^k x)=O(x) for every future k. Consequently the
    predictive quotient is exactly the current O-fiber partition.
    """
    *_, h, _, _, _ = witness()
    states = carrier()
    if not all(observation(act(h, x)) == observation(x) for x in states):
        return False
    crystal = holonomy_world(observation)
    observed_fibers = {
        frozenset(x for x in states if observation(x) == value)
        for value in {observation(x) for x in states}
    }
    return {frozenset(fiber) for fiber in crystal.fibers} == observed_fibers


def main() -> None:
    *_, h, before, after, _ = witness()
    assert before != after
    assert element_order(before) == element_order(after) == 6
    assert invariant_observation_collapses_future(element_order)

    order_crystal = holonomy_world(element_order)
    assert set(order_crystal.observations) == {1, 2, 3, 6}
    assert len(order_crystal.fibers) == 4

    # False control: the second Smith coordinate is not holonomy-invariant.
    coordinate = lambda value: value[1]
    assert coordinate(before) != coordinate(after)
    assert not invariant_observation_collapses_future(coordinate)
    coordinate_crystal = holonomy_world(coordinate)
    # The current observation has two fibers, but one future holonomy step
    # splits each: the predictive quotient therefore has four states.
    assert len(coordinate_crystal.fibers) == 4

    print({
        "raw_states": 12,
        "nontrivial_transport": (before, after),
        "order_predictive_states": len(order_crystal.fibers),
        "order_outputs": sorted(order_crystal.observations),
        "coordinate_current_outputs": 2,
        "coordinate_predictive_states": len(coordinate_crystal.fibers),
    })
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

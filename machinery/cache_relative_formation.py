#!/usr/bin/env python3
"""Cache-relative marginal cost for a fixed binary construction policy."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class AdditionStep:
    left: int
    right: int
    result: int


@dataclass(frozen=True)
class CacheTransition:
    target: int
    initial_cache: frozenset[int]
    steps: tuple[AdditionStep, ...]
    final_cache: frozenset[int]

    @property
    def new_additions(self) -> int:
        return len(self.steps)

    @property
    def new_intermediates(self) -> frozenset[int]:
        return self.final_cache - self.initial_cache

    @property
    def present_cost_vector(self) -> tuple[int, int]:
        return self.new_additions, len(self.final_cache)


def binary_prefixes(target: int) -> tuple[int, ...]:
    """Values visited by left-to-right binary construction, including 1."""
    if target < 1:
        raise ValueError("target must be positive")
    prefixes = [1]
    value = 1
    for bit in bin(target)[3:]:
        value *= 2
        prefixes.append(value)
        if bit == "1":
            value += 1
            prefixes.append(value)
    return tuple(prefixes)


def form_from_cache(target: int, cache: frozenset[int]) -> CacheTransition:
    """Resume the fixed binary trace from its latest cached prefix."""
    if 1 not in cache:
        raise ValueError("cache must contain the formed unit 1")
    prefixes = binary_prefixes(target)
    start = max(index for index, value in enumerate(prefixes) if value in cache)
    available = set(cache)
    steps: list[AdditionStep] = []
    current = prefixes[start]
    for next_value in prefixes[start + 1 :]:
        if next_value == 2 * current:
            step = AdditionStep(current, current, next_value)
        elif next_value == current + 1:
            step = AdditionStep(current, 1, next_value)
        else:
            raise AssertionError("malformed binary prefix trace")
        if next_value not in available:
            if step.left not in available or step.right not in available:
                raise AssertionError("construction used an unavailable operand")
            steps.append(step)
            available.add(next_value)
        current = next_value
    return CacheTransition(target, cache, tuple(steps), frozenset(available))


def verify_transition(transition: CacheTransition) -> bool:
    if 1 not in transition.initial_cache:
        return False
    available = set(transition.initial_cache)
    for step in transition.steps:
        if step.left not in available or step.right not in available:
            return False
        if step.left + step.right != step.result or step.result in available:
            return False
        available.add(step.result)
    return (
        transition.target in available
        and transition.final_cache == frozenset(available)
        and transition == form_from_cache(transition.target, transition.initial_cache)
    )


def future_cost_profile(
    cache: frozenset[int], targets: tuple[int, ...]
) -> tuple[int, ...]:
    """Marginal fixed-policy additions for a declared future target family."""
    return tuple(form_from_cache(target, cache).new_additions for target in targets)


if __name__ == "__main__":
    for cache in (frozenset({1}), frozenset({1, 2, 3}), frozenset({1, 2, 3, 6}),
                  frozenset({1, 2, 3, 6, 12, 13})):
        transition = form_from_cache(13, cache)
        print(cache, "->", transition.new_additions, transition.steps)
    five = form_from_cache(5, frozenset({1}))
    six = form_from_cache(6, frozenset({1}))
    print("equal present vectors:", five.present_cost_vector, six.present_cost_vector)
    print("future (3,4):", future_cost_profile(five.final_cache, (3, 4)),
          future_cost_profile(six.final_cache, (3, 4)))

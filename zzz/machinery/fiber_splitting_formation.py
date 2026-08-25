#!/usr/bin/env python3
"""Universal refinement when a new observable fails to descend."""

from __future__ import annotations

from collections import defaultdict
from typing import Callable, Hashable, Iterable, TypeVar

X = TypeVar("X", bound=Hashable)
Y = TypeVar("Y", bound=Hashable)
Z = TypeVar("Z", bound=Hashable)


def fibers(states: Iterable[X], observable: Callable[[X], Y]) -> dict[Y, tuple[X, ...]]:
    result: dict[Y, list[X]] = defaultdict(list)
    for state in states:
        result[observable(state)].append(state)
    return {value: tuple(block) for value, block in result.items()}


def descends(states: Iterable[X], current: Callable[[X], Y],
             new: Callable[[X], Z]) -> bool:
    """Whether new = h after current on the declared state locus."""
    for block in fibers(states, current).values():
        if len({new(x) for x in block}) > 1:
            return False
    return True


def joint_fibers(states: Iterable[X], current: Callable[[X], Y],
                 new: Callable[[X], Z]) -> dict[tuple[Y, Z], tuple[X, ...]]:
    return fibers(states, lambda x: (current(x), new(x)))


def square_cube_reconstruct(square: int, cube: int) -> int:
    """Inverse of x -> (x^2,x^3) on its integer image."""
    if square == 0:
        if cube != 0:
            raise ValueError("not in the square-cube image")
        return 0
    if cube % square:
        raise ValueError("not in the square-cube image")
    x = cube // square
    if x * x != square or x * x * x != cube:
        raise ValueError("not in the square-cube image")
    return x


if __name__ == "__main__":
    chart = tuple(range(-4, 5))
    square = lambda x: x * x
    cube = lambda x: x * x * x
    print("square fibers", fibers(chart, square))
    print("cube descends through square", descends(chart, square, cube))
    print("joint fibers", joint_fibers(chart, square, cube))
    print("reconstruction", [square_cube_reconstruct(square(x), cube(x)) for x in chart])

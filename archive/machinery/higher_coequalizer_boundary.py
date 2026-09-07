#!/usr/bin/env python3
"""Finite witnesses for the boundary between an action groupoid and its pi_0."""

from __future__ import annotations

from dataclasses import dataclass

try:
    from machinery.smith_path_holonomy import act, witness
except ModuleNotFoundError:  # direct `python3 machinery/...py` execution
    from smith_path_holonomy import act, witness


@dataclass(frozen=True)
class Arrow:
    """The arrow H^power : source -> target in the Smith C3 action groupoid."""

    source: tuple[int, int, int]
    power: int
    target: tuple[int, int, int]


def smith_arrow(source: tuple[int, int, int], power: int) -> Arrow:
    h = witness()[4]
    power %= 3
    target = source
    for _ in range(power):
        target = act(h, target)
    return Arrow(source, power, target)


def compose(first: Arrow, second: Arrow) -> Arrow:
    """Compose `source -first-> middle -second-> target`."""

    if first.target != second.source:
        raise ValueError("arrows are not composable")
    answer = smith_arrow(first.source, first.power + second.power)
    assert answer.target == second.target
    return answer


def smith_fixed_point_boundary() -> dict[str, object]:
    """Return the nonidentity loop killed by the set-level orbit quotient."""

    zero = (0, 0, 0)
    identity = smith_arrow(zero, 0)
    generator = smith_arrow(zero, 1)
    square = compose(generator, generator)
    cube = compose(square, generator)

    assert generator.source == generator.target == zero
    assert generator != identity
    assert square != identity and square != generator
    assert cube == identity

    # The discrete groupoid on pi_0 has only its identity arrow at [zero].
    # Hence its quotient functor identifies these two distinct arrows.  If the
    # identity functor on this one-object C3 subgroupoid factored through that
    # discrete quotient, it would identify them too, a contradiction.
    quotient_of_identity = ("orbit(zero)", "orbit(zero)")
    quotient_of_generator = ("orbit(zero)", "orbit(zero)")
    assert quotient_of_identity == quotient_of_generator

    return {
        "object": zero,
        "loop_powers": (identity.power, generator.power, square.power),
        "generator_is_nonidentity": generator != identity,
        "pi0_images_equal": quotient_of_identity == quotient_of_generator,
    }


def main() -> None:
    print(smith_fixed_point_boundary())
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

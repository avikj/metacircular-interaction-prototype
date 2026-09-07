"""Unbounded exact controller memory hidden by a coarse Smith residual record."""

from smith_residual_machine import smith_reduce


def witness_matrix(quotient: int):
    if quotient < 0:
        raise ValueError("quotient must be nonnegative")
    return ((2, 0), (2 * quotient + 1, 7))


def first_record(quotient: int):
    step = smith_reduce(witness_matrix(quotient)).steps[0]
    coarse = (step.kind, step.pivot_before, step.residual)
    exact_constructor_coefficient = -step.quotient
    return coarse, exact_constructor_coefficient


def response_classes(count: int):
    if count < 0:
        raise ValueError("count must be nonnegative")
    by_coarse = {}
    for quotient in range(count):
        coarse, coefficient = first_record(quotient)
        by_coarse.setdefault(coarse, set()).add(coefficient)
    return {coarse: frozenset(values) for coarse, values in by_coarse.items()}


def minimum_controller_dimension(count: int) -> int:
    return max((len(values) for values in response_classes(count).values()), default=0)

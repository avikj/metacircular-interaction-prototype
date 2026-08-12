"""Exact memory of a ternary port history hidden behind one nominal endpoint."""

from itertools import product


def histories(depth: int, radix: int = 3):
    if depth < 0 or radix < 2:
        raise ValueError("depth nonnegative and radix at least two")
    return tuple(product(range(radix), repeat=depth))


def digit_response(history, query: int) -> int:
    if query < 0 or query >= len(history):
        raise ValueError("query outside history")
    return history[query]


def response_function(history):
    return tuple(digit_response(history, query) for query in range(len(history)))


def fixed_domain_memory_dimension(depth: int, radix: int = 3) -> int:
    """Distinct future response functions behind the common endpoint."""
    return len({response_function(history) for history in histories(depth, radix)})


def memoryless_nominal_equivalent(depth: int, radix: int = 3) -> bool:
    """A constant endpoint with no memory has one response function."""
    return fixed_domain_memory_dimension(depth, radix) <= 1


def restricted_nominal_memory_dimension(depth: int, radix: int = 3) -> int:
    """After restricting the admitted domain to the all-zero history."""
    if depth < 0 or radix < 2:
        raise ValueError("depth nonnegative and radix at least two")
    return 1

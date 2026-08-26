"""Exact finite resource accounting for the ported ternary endpoint encoder."""

from itertools import product


def endpoints(levels: int, radix: int = 3):
    if levels < 0 or radix < 2:
        raise ValueError("levels nonnegative and radix at least two")
    return {
        bits: sum(bit * radix**k for k, bit in enumerate(bits))
        for bits in product((0, 1), repeat=levels)
    }


def is_injective(levels: int, radix: int = 3) -> bool:
    values = tuple(endpoints(levels, radix).values())
    return len(values) == len(set(values))


def coherent_environment_dimension(levels: int, radix: int = 3) -> int:
    """Maximum fiber size of the port-history to endpoint map."""
    values = tuple(endpoints(levels, radix).values())
    return max((values.count(value) for value in set(values)), default=0)


def zero_error_endpoint_dimension(levels: int, radix: int = 3) -> int:
    """Dimension needed to recover every realized port history exactly."""
    return len(set(endpoints(levels, radix).values()))


def fixed_all_ones_domain_size(levels: int) -> int:
    """Fixing every port changes the admitted domain to a singleton."""
    if levels < 0:
        raise ValueError("levels must be nonnegative")
    return 1

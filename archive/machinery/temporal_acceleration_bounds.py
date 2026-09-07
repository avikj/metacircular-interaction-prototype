"""Lower bounds and false controls for claimed temporal acceleration."""

from math import prod
from typing import Iterable


TWELVE_YEAR_TO_TWELVE_HOUR_RATIO = 36525 * 24 // 100  # 8766


def nested_span(radices: Iterable[int]) -> int:
    values = tuple(radices)
    if any(r < 1 for r in values):
        raise ValueError("radices must be positive")
    return prod(values)


def independent_span(radices: Iterable[int]) -> int:
    """Known-false control: independent, noncomposing improvements add."""
    values = tuple(radices)
    if any(r < 0 for r in values):
        raise ValueError("spans must be nonnegative")
    return sum(values)


def break_even_uses(*, old_cost: int, new_cost: int, overhead: int) -> int | None:
    """Least integer M with M*old_cost > overhead + M*new_cost."""
    if min(old_cost, new_cost, overhead) < 0:
        raise ValueError("costs must be nonnegative")
    per_use = old_cost - new_cost
    if per_use <= 0:
        return None
    return overhead // per_use + 1


def critical_path(latencies: Iterable[int]) -> int:
    """Lower bound for stages connected by strict data dependency."""
    values = tuple(latencies)
    if any(x < 0 for x in values):
        raise ValueError("latencies must be nonnegative")
    return sum(values)


def interpreted_cost(radices: Iterable[int]) -> int:
    """Known-false control: a macro name that fully expands saves no work."""
    return nested_span(radices)


if __name__ == "__main__":
    radices = [3] * 12
    print("nested span:", nested_span(radices))
    print("independent control:", independent_span(radices))
    print("uncompiled execution cost:", interpreted_cost(radices))
    print("12-year / 12-hour rate ratio:", TWELVE_YEAR_TO_TWELVE_HOUR_RATIO)
    print("ten doublings and two triplings:", nested_span([2] * 10 + [3] * 2))
    print("twelve-stage unit-latency critical path:", critical_path([1] * 12))

"""One-shot formation update extracted from Euclid, Elements VII.1--2."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class EuclideanFormation:
    inputs: tuple[int, int]
    old_operations: tuple[str, ...]
    obstruction: str
    descent_trace: tuple[tuple[int, int, int, int], ...]
    formed_invariant: int
    common_divisors_before: tuple[int, ...]
    common_divisors_after: tuple[int, ...]
    immediate_frontier: str


def form_greatest_common_measure(a: int, b: int) -> EuclideanFormation:
    """Compile comparison/subtraction into a gcd and an exact frontier update.

    Each trace row `(x,y,q,r)` records `x=q*y+r`, with `x>=y>0`.
    The returned divisor sets are an executable certificate of the invariant
    `CommonDivisors(x,y) = CommonDivisors(y,r)` at every descent step.
    """
    if isinstance(a, bool) or isinstance(b, bool) or a <= 0 or b <= 0:
        raise ValueError("Euclidean formation needs two positive integers")
    original = (a, b)
    before = _common_divisors(a, b)
    trace: list[tuple[int, int, int, int]] = []
    x, y = max(a, b), min(a, b)
    while y:
        q, r = divmod(x, y)
        trace.append((x, y, q, r))
        if _common_divisors(x, y) != _common_divisors(y, r):
            raise AssertionError("common-divisor invariant failed")
        x, y = y, r
    gcd = x
    after = _common_divisors(gcd, 0)
    if before != after:
        raise AssertionError("terminal measure does not preserve divisors")
    coprime = gcd == 1
    obstruction = (
        "unit is the terminal remainder: no non-unit common measure"
        if coprime
        else "descent terminates at a non-unit common measure"
    )
    frontier = (
        "coprime: common-measure search is closed; Bezout construction is opened"
        if coprime
        else f"reduce ({a},{b}) to coprime quotient pair ({a // gcd},{b // gcd})"
    )
    return EuclideanFormation(
        inputs=original,
        old_operations=("compare", "subtract a multiple", "repeat"),
        obstruction=obstruction,
        descent_trace=tuple(trace),
        formed_invariant=gcd,
        common_divisors_before=before,
        common_divisors_after=after,
        immediate_frontier=frontier,
    )


def _common_divisors(a: int, b: int) -> tuple[int, ...]:
    bound = max(a, b)
    return tuple(d for d in range(1, bound + 1) if a % d == 0 and b % d == 0)

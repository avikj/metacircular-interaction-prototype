#!/usr/bin/env python3
"""Exponent coordinates formed by recursive multiplicative origins."""

from __future__ import annotations

from collections import Counter
from math import isqrt
from typing import Callable, Hashable, Mapping, TypeVar

A = TypeVar("A")


def recursive_origins(n: int) -> tuple[int, ...]:
    """Return prime leaves of a recursive factor-origin tree, without a table."""
    if n < 1:
        raise ValueError("multiplicative origins require a positive integer")
    if n == 1:
        return ()
    divisor = next((d for d in range(2, isqrt(n) + 1) if n % d == 0), None)
    if divisor is None:
        return (n,)
    return recursive_origins(divisor) + recursive_origins(n // divisor)


def exponent_vector(n: int) -> tuple[tuple[int, int], ...]:
    """Count recursively formed prime leaves in canonical finite-support order."""
    return tuple(sorted(Counter(recursive_origins(n)).items()))


def universal_evaluate(
    n: int, prime_values: Mapping[int, A], identity: A,
    combine: Callable[[A, A], A],
) -> A:
    """Evaluate the unique commutative-monoid map fixed on prime generators."""
    result = identity
    for prime, exponent in exponent_vector(n):
        if prime not in prime_values:
            raise ValueError(f"missing image of prime generator {prime}")
        for _ in range(exponent):
            result = combine(result, prime_values[prime])
    return result


def local_addition_counterexample(prime: int, height: int) -> tuple[int, int]:
    """Return v_p(a)=v_p(b)=0 but v_p(a+b)=height."""
    if prime < 2 or any(prime % d == 0 for d in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")
    if height < 1:
        raise ValueError("height must be positive")
    return 1, prime ** height - 1

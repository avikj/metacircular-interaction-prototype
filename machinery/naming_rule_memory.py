#!/usr/bin/env python3
"""Exact finite certificates for naming-rule random-access memory."""

from __future__ import annotations

from itertools import product
from typing import Callable, Hashable, Iterable, Sequence


Table = tuple[Hashable, ...]


def distinct_tables(
    addresses: Sequence[int], rules: Iterable[Callable[[int], Hashable]]
) -> set[Table]:
    """Extensional behaviors of rules on the declared finite address set."""
    return {tuple(rule(i) for i in addresses) for rule in rules}


def exact_memory_dimension(
    addresses: Sequence[int], rules: Iterable[Callable[[int], Hashable]]
) -> int:
    """Minimum zero-error random-access Hilbert dimension."""
    tables = distinct_tables(addresses, rules)
    if not tables:
        raise ValueError("at least one naming rule is required")
    return len(tables)


def arbitrary_tables(alphabet_size: int, address_count: int) -> tuple[Table, ...]:
    if alphabet_size <= 0 or address_count < 0:
        raise ValueError("alphabet must be positive and address count nonnegative")
    return tuple(product(range(alphabet_size), repeat=address_count))


def affine_tables(prime: int) -> tuple[Table, ...]:
    if prime <= 1:
        raise ValueError("modulus must exceed one")
    # Primality is part of the advertised field example; the count below also
    # remains valid over Z/nZ because values at 0 and 1 recover b and a.
    return tuple(
        tuple((a * i + b) % prime for i in range(prime))
        for a in range(prime) for b in range(prime)
    )


def affine_certificate(prime: int = 5) -> dict[str, int]:
    unrestricted = arbitrary_tables(prime, prime)
    affine = affine_tables(prime)
    if len(set(affine)) != prime * prime:
        raise AssertionError("affine parameter recovery failed")
    return {
        "addresses": prime,
        "alphabet_size": prime,
        "arbitrary_table_dimension": len(set(unrestricted)),
        "affine_rule_dimension": len(set(affine)),
        "compression_factor": len(set(unrestricted)) // len(set(affine)),
        "fixed_public_rule_dimension": 1,
    }


if __name__ == "__main__":
    print(affine_certificate())

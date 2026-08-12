#!/usr/bin/env python3
"""Exact higher-arity cancellation formation and pairwise-ledger collisions."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations

from cancellation_observable import valuation_nonzero


@dataclass(frozen=True)
class ArityRefinementStep:
    depth: int
    modulus: int
    residues: tuple[int, ...]
    sum_residue: int


@dataclass(frozen=True)
class HigherCancellationCertificate:
    prime: int
    common_depth: int
    cancellation: int | None
    is_zero_sum: bool
    normalized_inputs: tuple[int, ...]
    steps: tuple[ArityRefinementStep, ...]


def form_higher_cancellation(
    inputs: tuple[int, ...], prime: int
) -> HigherCancellationCertificate:
    """Form v_p(sum inputs)-min v_p(inputs) with a least-depth trace."""
    if len(inputs) < 2:
        raise ValueError("at least two inputs are required")
    depths = tuple(valuation_nonzero(value, prime) for value in inputs)
    common = min(depths)
    scale = prime**common
    normalized = tuple(value // scale for value in inputs)
    if sum(normalized) == 0:
        return HigherCancellationCertificate(
            prime, common, None, True, normalized, ()
        )
    steps: list[ArityRefinementStep] = []
    modulus = 1
    depth = 0
    while True:
        depth += 1
        modulus *= prime
        residues = tuple(value % modulus for value in normalized)
        total = sum(residues) % modulus
        steps.append(ArityRefinementStep(depth, modulus, residues, total))
        if total != 0:
            return HigherCancellationCertificate(
                prime, common, depth - 1, False, normalized, tuple(steps)
            )


def pairwise_ledger(inputs: tuple[int, ...], prime: int) -> tuple[int, ...]:
    """Input valuations followed by all finite pairwise residuals."""
    depths = tuple(valuation_nonzero(value, prime) for value in inputs)
    residuals: list[int] = []
    for i in range(len(inputs)):
        for j in range(i + 1, len(inputs)):
            certificate = form_higher_cancellation((inputs[i], inputs[j]), prime)
            if certificate.cancellation is None:
                raise ValueError("pairwise ledger excludes zero pair sums")
            residuals.append(certificate.cancellation)
    return depths + tuple(residuals)


def collision_family(prime: int, height: int) -> tuple[int, int, int]:
    """A fixed-ledger triple with higher residual equal to ``height``."""
    if height < (2 if prime == 2 else 1):
        raise ValueError("height is below the fixed-ledger range")
    # Prime validation is delegated without making a large integer.
    valuation_nonzero(1, prime)
    return (1, 1, prime**height - 2)


def strict_hierarchy_family(prime: int, arity: int, height: int) -> tuple[int, ...]:
    """An arity-``arity`` tuple whose full cancellation is ``height``."""
    if arity < 2:
        raise ValueError("arity must be at least two")
    valuation_nonzero(1, prime)
    threshold = 0
    for k in range(1, arity):
        threshold = max(threshold, valuation_nonzero(k, prime))
    if height <= threshold or prime**height <= arity - 1:
        raise ValueError("height is below the stable positive range")
    return (1,) * (arity - 1) + (prime**height - (arity - 1),)


def proper_context_ledger(inputs: tuple[int, ...], prime: int) -> tuple[tuple[tuple[int, ...], int], ...]:
    """Valuations of all nonempty proper subset sums, indexed by positions."""
    if len(inputs) < 2:
        raise ValueError("at least two inputs are required")
    ledger: list[tuple[tuple[int, ...], int]] = []
    for size in range(1, len(inputs)):
        for indices in combinations(range(len(inputs)), size):
            subtotal = sum(inputs[index] for index in indices)
            ledger.append((indices, valuation_nonzero(subtotal, prime)))
    return tuple(ledger)


if __name__ == "__main__":
    for prime in (2, 3, 5):
        start = 2 if prime == 2 else 1
        examples = []
        for height in range(start, start + 3):
            inputs = collision_family(prime, height)
            formed = form_higher_cancellation(inputs, prime)
            examples.append((inputs, pairwise_ledger(inputs, prime), formed.cancellation))
        print(f"p={prime}: {examples}")
    family = strict_hierarchy_family(3, 5, 4)
    print("strict arity-5 example:", family)
    print("proper ledger:", proper_context_ledger(family, 3))
    print("full residual:", form_higher_cancellation(family, 3).cancellation)

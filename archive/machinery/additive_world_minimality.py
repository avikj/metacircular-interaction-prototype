#!/usr/bin/env python3
"""Internal witnesses for valuation minimality on an additive subgroup dZ."""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


def _prime_check(prime: int) -> None:
    if prime < 2 or any(prime % q == 0 for q in range(2, isqrt(prime) + 1)):
        raise ValueError("prime must be prime")


def valuation_nonzero(value: int, prime: int) -> int:
    _prime_check(prime)
    if value == 0:
        raise ValueError("valuation requires a nonzero integer")
    value = abs(value)
    depth = 0
    while value % prime == 0:
        value //= prime
        depth += 1
    return depth


@dataclass(frozen=True)
class SubgroupWitness:
    generator: int
    prime: int
    left: int
    right: int
    valuation: int
    coefficient: int
    witness_left: int
    witness_right: int
    witness_valuation: int


def internal_witness(generator: int, prime: int, left: int, right: int) -> SubgroupWitness:
    """Construct the depth-v distinguishing witness inside (dZ)^2."""
    _prime_check(prime)
    generator = abs(generator)
    if generator == 0:
        raise ValueError("generator must be nonzero")
    if left % generator or right % generator:
        raise ValueError("inputs must lie in the declared subgroup")
    total = left + right
    valuation = valuation_nonzero(total, prime)

    p_part = 1
    while generator % (p_part * prime) == 0:
        p_part *= prime
    prime_free = generator // p_part
    unit = (total // (prime**valuation)) % prime

    # CRT for C=0 mod prime_free and C=-unit mod prime. Since the moduli are
    # coprime, stepping through multiples of prime_free reaches one solution.
    coefficient = next(
        c for c in range(0, prime * prime_free, prime_free)
        if c % prime == (-unit) % prime
    )
    if coefficient == -(total // (prime**valuation)):
        coefficient += prime * prime_free

    witness_left = left
    witness_right = right + coefficient * (prime**valuation)
    witness_total = witness_left + witness_right
    witness_valuation = valuation_nonzero(witness_total, prime)
    certificate = SubgroupWitness(
        generator, prime, left, right, valuation, coefficient,
        witness_left, witness_right, witness_valuation,
    )
    if not verify_witness(certificate):
        raise AssertionError("constructed subgroup witness failed")
    return certificate


def verify_witness(witness: SubgroupWitness) -> bool:
    try:
        _prime_check(witness.prime)
        if witness.generator <= 0:
            return False
        if any(x % witness.generator for x in (
            witness.left, witness.right, witness.witness_left, witness.witness_right
        )):
            return False
        valuation = valuation_nonzero(witness.left + witness.right, witness.prime)
        witness_valuation = valuation_nonzero(
            witness.witness_left + witness.witness_right, witness.prime
        )
    except ValueError:
        return False
    modulus = witness.prime**valuation
    return (
        witness.valuation == valuation
        and witness.witness_valuation == witness_valuation
        and witness.witness_left % modulus == witness.left % modulus
        and witness.witness_right % modulus == witness.right % modulus
        and witness_valuation > valuation
    )


if __name__ == "__main__":
    print(internal_witness(6, 3, 6, 12))

#!/usr/bin/env python3
"""Exact typed operations for the defect-calculus nucleus.

This module is a preservation-ledger runtime, not a theorem prover.  It keeps
residue support, homological degree, ramification, and logarithmic grading
separate instead of prematurely collapsing them to one scalar.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import isqrt, log
from typing import Iterable


def _is_prime(value: int) -> bool:
    if value < 2:
        return False
    return all(value % divisor for divisor in range(2, isqrt(value) + 1))


@dataclass(frozen=True, order=True)
class PrimePowerDefect:
    """Cyclotomic identity defect at a declared prime-power level."""

    prime: int
    exponent: int

    def __post_init__(self) -> None:
        if not _is_prime(self.prime):
            raise ValueError("prime must be prime")
        if self.exponent < 1:
            raise ValueError("exponent must be positive")

    @property
    def index(self) -> int:
        return self.prime**self.exponent

    @property
    def mangoldt_weight(self) -> float:
        return log(self.prime)

    @property
    def height(self) -> float:
        return self.exponent * log(self.prime)

    def tower_step(self) -> "RamifiedStep":
        return RamifiedStep(
            lower=self,
            upper=PrimePowerDefect(self.prime, self.exponent + 1),
            residue_degree=1,
            ramification_index=self.prime,
            conormal_rank=1,
            conormal_map_rank=0,
            height_increment=log(self.prime),
        )


@dataclass(frozen=True)
class RamifiedStep:
    lower: PrimePowerDefect
    upper: PrimePowerDefect
    residue_degree: int
    ramification_index: int
    conormal_rank: int
    conormal_map_rank: int
    height_increment: float

    def validate(self) -> None:
        if self.lower.prime != self.upper.prime:
            raise ValueError("tower step changed residue characteristic")
        if self.upper.exponent != self.lower.exponent + 1:
            raise ValueError("tower step must advance exactly one level")
        if self.residue_degree != 1:
            raise ValueError("cyclotomic prime-power step has residue degree one")
        if self.ramification_index != self.lower.prime:
            raise ValueError("cyclotomic prime-power step has ramification index p")
        if (self.conormal_rank, self.conormal_map_rank) != (1, 0):
            raise ValueError("residue conormal line must map to zero")


@dataclass(frozen=True)
class DerivedIncidence:
    """Homology orders of D_m tensor^L_Z D_n, keyed by degree."""

    left: PrimePowerDefect
    right: PrimePowerDefect
    homology_orders: tuple[tuple[int, int], ...]

    @property
    def is_zero(self) -> bool:
        return not self.homology_orders

    @property
    def support_prime(self) -> int | None:
        return None if self.is_zero else self.left.prime

    @property
    def alternating_order(self) -> Fraction:
        result = Fraction(1, 1)
        for degree, order in self.homology_orders:
            result = result / order if degree % 2 else result * order
        return result

    def degree_order(self, degree: int) -> int:
        return dict(self.homology_orders).get(degree, 1)


def derived_incidence(left: PrimePowerDefect,
                      right: PrimePowerDefect) -> DerivedIncidence:
    """Return the exact tensor/Tor profile without scalarizing its degrees."""
    homology = () if left.prime != right.prime else (
        (0, left.prime), (1, left.prime))
    return DerivedIncidence(left, right, homology)


@dataclass(frozen=True)
class LocalDefectLength:
    """Prime-local length vector for a finite cokernel."""

    lengths: tuple[tuple[int, int], ...]

    def __post_init__(self) -> None:
        if any(not _is_prime(prime) or length <= 0
               for prime, length in self.lengths):
            raise ValueError("local entries require a prime and positive length")
        if tuple(sorted(self.lengths)) != self.lengths:
            raise ValueError("local entries must be sorted")
        if len({prime for prime, _ in self.lengths}) != len(self.lengths):
            raise ValueError("each prime may occur only once")

    def compose(self, other: "LocalDefectLength") -> "LocalDefectLength":
        merged = dict(self.lengths)
        for prime, length in other.lengths:
            merged[prime] = merged.get(prime, 0) + length
        return LocalDefectLength(tuple(sorted(merged.items())))

    @property
    def cokernel_order(self) -> int:
        result = 1
        for prime, length in self.lengths:
            result *= prime**length
        return result

    @property
    def logarithmic_length(self) -> float:
        return sum(length * log(prime) for prime, length in self.lengths)


def local_defect(entries: Iterable[tuple[int, int]]) -> LocalDefectLength:
    """Canonicalize and combine repeated prime-local length entries."""
    merged: dict[int, int] = {}
    for prime, length in entries:
        if length <= 0:
            raise ValueError("length must be positive")
        merged[prime] = merged.get(prime, 0) + length
    return LocalDefectLength(tuple(sorted(merged.items())))

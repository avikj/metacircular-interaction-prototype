#!/usr/bin/env python3
"""Localize generalized-CRT incompatibility in prime-exponent coordinates."""
from __future__ import annotations

from dataclasses import dataclass
from math import gcd

from exponent_world import ExponentWorld
from kuttaka_update import CongruenceState, Incompatibility, add_constraint


@dataclass(frozen=True)
class LocalDefect:
    prime: int
    required_exponent: int
    available_exponent: int

    @property
    def missing_exponent(self) -> int:
        return self.required_exponent - self.available_exponent


@dataclass(frozen=True)
class LocalCompatibility:
    common_prime_powers: tuple[tuple[int, int], ...]
    difference_powers: tuple[tuple[int, int], ...]
    defects: tuple[LocalDefect, ...]

    @property
    def compatible(self) -> bool:
        return not self.defects


def localize(
    state: CongruenceState, residue: int, modulus: int,
    world: ExponentWorld | None = None,
) -> LocalCompatibility:
    """Return every prime-exponent deficit in gcd(M,m) | (a-r)."""
    if modulus <= 0:
        raise ValueError("modulus must be positive")
    chart = world or ExponentWorld()
    difference = residue % modulus - state.residue
    common = chart.gcd(state.modulus, modulus).powers
    difference_powers = () if difference == 0 else chart.form(abs(difference)).powers
    available = dict(difference_powers)
    defects = () if difference == 0 else tuple(
        LocalDefect(prime, required, available.get(prime, 0))
        for prime, required in common
        if available.get(prime, 0) < required
    )
    return LocalCompatibility(common, difference_powers, defects)


def verify_against_kuttaka(
    state: CongruenceState, residue: int, modulus: int,
    report: LocalCompatibility,
) -> bool:
    """Cross-check the local report against the scalar gcd obstruction."""
    result = add_constraint(state, residue, modulus)
    scalar_compatible = not isinstance(result, Incompatibility)
    difference = residue % modulus - state.residue
    return (report.compatible == scalar_compatible
            and report.compatible == (difference % gcd(state.modulus, modulus) == 0))


if __name__ == "__main__":
    for residue in (23, 35):
        state = CongruenceState(17, 72)
        report = localize(state, residue, 90)
        print(f"add x={residue} mod 90: {report}")
        print(f"cross-check: {verify_against_kuttaka(state, residue, 90, report)}")

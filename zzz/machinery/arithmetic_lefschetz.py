#!/usr/bin/env python3
"""Exact arithmetic character and finite Lefschetz/Burnside certificate."""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd

try:
    from machinery.cyclic_local_system import compile_cyclic_local_system
except ModuleNotFoundError:  # direct script execution
    from cyclic_local_system import compile_cyclic_local_system


@dataclass(frozen=True)
class ArithmeticLefschetzCertificate:
    modulus: int
    multiplier: int
    order: int
    traces: tuple[int, ...]
    arithmetic_counts: tuple[int, ...]
    enumerated_counts: tuple[int, ...]
    orbit_count: int
    global_section_dimension: int


def compile_multiplicative_lefschetz(
    modulus: int, multiplier: int, order: int
) -> ArithmeticLefschetzCertificate:
    """Certify the permutation character of C_order acting on Z/modulus.

    The generator sends x to multiplier*x. For 0 <= k < order, the trace on
    the integer permutation module Z[Z/modulus] is both the number of fixed
    residues and gcd(multiplier**k - 1, modulus). Burnside averaging gives the
    dimension of invariant functions, independently replayed as the section
    dimension of the trivial F_2 local system on the action groupoid.
    """
    if modulus <= 0 or order <= 0:
        raise ValueError("modulus and order must be positive")
    a = multiplier % modulus
    if gcd(a, modulus) != 1:
        raise ValueError("multiplier must be a unit modulo the modulus")
    if pow(a, order, modulus) != 1:
        raise ValueError("declared order does not satisfy the group relation")
    # Require the declared action group to be faithful, avoiding a silently
    # inflated period in the certificate.
    if any(pow(a, k, modulus) == 1 for k in range(1, order)):
        raise ValueError("declared order is not minimal")

    states = tuple(range(modulus))
    generator = {x: (a * x) % modulus for x in states}
    arithmetic = tuple(gcd(pow(a, k) - 1, modulus) for k in range(order))
    enumerated = tuple(sum((pow(a, k, modulus) * x - x) % modulus == 0
                           for x in states) for k in range(order))
    if arithmetic != enumerated:
        raise AssertionError("arithmetic and fixed-point traces disagree")
    total = sum(arithmetic)
    if total % order:
        raise AssertionError("Burnside trace average is not integral")
    orbit_count = total // order

    trivial_transports = {x: ((1,),) for x in states}
    local = compile_cyclic_local_system(
        states, generator, trivial_transports, order, 2,
    )
    if local.global_section_dimension != orbit_count:
        raise AssertionError("orbit average and global sections disagree")
    return ArithmeticLefschetzCertificate(
        modulus, a, order, arithmetic, arithmetic, enumerated, orbit_count,
        local.global_section_dimension,
    )


if __name__ == "__main__":
    result = compile_multiplicative_lefschetz(15, 2, 4)
    print(result)
    print("ALL EXACT CHECKS PASS")

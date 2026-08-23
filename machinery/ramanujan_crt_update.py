#!/usr/bin/env python3
"""Exact CRT update for certified Ramanujan rows and wheel correlations."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import gcd

try:
    from machinery.ramanujan_sieve_ingestion import (
        certified_ramanujan_rows, compile_sieve_ingestion, euler_phi,
    )
    from machinery.ramanujan_trace import compile_ramanujan_trace, divisors, mobius
except ModuleNotFoundError:  # direct script execution
    from ramanujan_sieve_ingestion import (
        certified_ramanujan_rows, compile_sieve_ingestion, euler_phi,
    )
    from ramanujan_trace import compile_ramanujan_trace, divisors, mobius


def is_prime(n: int) -> bool:
    return n >= 2 and all(n % d for d in range(2, int(n ** 0.5) + 1))


@dataclass(frozen=True)
class CRTWheelUpdate:
    old_wheel: int
    prime: int
    new_wheel: int
    old_cells_reused: int
    new_cells_formed: int
    total_cells: int
    scratch_cells: int
    old_correlation: Fraction
    local_factor: Fraction
    updated_correlation: Fraction
    rebuilt_correlation: Fraction


def extend_rows_by_prime(
    old_rows: dict[int, tuple[int, ...]], prime: int
) -> dict[int, tuple[int, ...]]:
    """Use c_(qp)(h)=c_q(h)c_p(h) to extend a divisor-row cache."""
    if not is_prime(prime) or any(q % prime == 0 for q in old_rows):
        raise ValueError("extension requires a new coprime prime")
    prime_row = compile_ramanujan_trace(prime).spectral_traces
    answer = dict(old_rows)
    for q, row in old_rows.items():
        answer[q * prime] = tuple(row[h % q] * prime_row[h % prime]
                                  for h in range(q * prime))
    return answer


def compile_crt_wheel_update(wheel: int, prime: int, shift: int) -> CRTWheelUpdate:
    if wheel <= 0 or gcd(wheel, prime) != 1 or not is_prime(prime):
        raise ValueError("prime must be prime and coprime to the wheel")
    old_rows = certified_ramanujan_rows(wheel)
    extended = extend_rows_by_prime(old_rows, prime)
    new_wheel = wheel * prime

    # Independent expensive control: every CRT-formed row must equal its
    # primitive cyclotomic trace row.
    independent_rows = {}
    for q in divisors(new_wheel):
        independent = (1,) if q == 1 else compile_ramanujan_trace(q).spectral_traces
        independent_rows[q] = independent
        if extended[q] != independent:
            raise AssertionError("CRT row and independent cyclotomic row disagree")

    old = compile_sieve_ingestion(wheel, shift).spectral_value
    cp = extended[prime][shift % prime]
    local_factor = 1 + Fraction(cp, (prime - 1) ** 2)
    updated = old * local_factor
    # Consume the independently rebuilt rows rather than compiling them a
    # second time merely to evaluate the downstream divisor sum.
    rebuilt = sum(
        Fraction(mobius(q), euler_phi(q)) ** 2
        * independent_rows[q][shift % q]
        for q in divisors(new_wheel)
    )
    if updated != rebuilt:
        raise AssertionError("local-factor update and rebuilt correlation disagree")

    old_cells = sum(len(row) for row in old_rows.values())
    new_cells = sum(len(extended[q * prime]) for q in old_rows)
    scratch_cells = sum(divisors(new_wheel))
    return CRTWheelUpdate(
        wheel, prime, new_wheel, old_cells, new_cells, old_cells + new_cells,
        scratch_cells, old, local_factor, updated, rebuilt,
    )


if __name__ == "__main__":
    result = compile_crt_wheel_update(30, 7, 6)
    print(result)
    print("ALL EXACT CHECKS PASS")

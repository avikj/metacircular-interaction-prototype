#!/usr/bin/env python3
"""Feed certified cyclotomic traces into the exact rational-fiber correlator."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import gcd

try:
    from machinery.ramanujan_trace import compile_ramanujan_trace, divisors, mobius
except ModuleNotFoundError:  # direct script execution
    from ramanujan_trace import compile_ramanujan_trace, divisors, mobius


def euler_phi(n: int) -> int:
    return sum(gcd(k, n) == 1 for k in range(1, n + 1))


@dataclass(frozen=True)
class SieveIngestionCertificate:
    wheel: int
    shift: int
    spectral_value: Fraction
    direct_value: Fraction
    spectral_terms: int
    direct_residue_checks: int
    compiled_trace_cells: int


def certified_ramanujan_rows(wheel: int) -> dict[int, tuple[int, ...]]:
    """Compile the primitive trace row for every divisor of a wheel."""
    if wheel <= 0:
        raise ValueError("wheel must be positive")
    rows = {1: (1,)}
    for q in divisors(wheel):
        if q > 1:
            rows[q] = compile_ramanujan_trace(q).spectral_traces
    return rows


def compile_sieve_ingestion(wheel: int, shift: int) -> SieveIngestionCertificate:
    """Recompute exp39's local correlation using cyclotomic trace rows."""
    rows = certified_ramanujan_rows(wheel)
    spectral = sum(
        Fraction(mobius(q), euler_phi(q)) ** 2 * rows[q][shift % q]
        for q in divisors(wheel)
    )
    phi_w = euler_phi(wheel)
    joint = sum(gcd(x, wheel) == 1 and gcd((x + shift) % wheel, wheel) == 1
                for x in range(wheel))
    direct = Fraction(joint * wheel, phi_w * phi_w)
    if spectral != direct:
        raise AssertionError("cyclotomic spectral route and wheel count disagree")
    return SieveIngestionCertificate(
        wheel, shift, spectral, direct, len(divisors(wheel)), wheel,
        sum(len(row) for row in rows.values()),
    )


if __name__ == "__main__":
    result = compile_sieve_ingestion(30, 6)
    print(result)
    print("ALL EXACT CHECKS PASS")

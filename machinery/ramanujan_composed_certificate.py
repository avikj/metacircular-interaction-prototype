#!/usr/bin/env python3
"""Compose old and prime Ramanujan certificates under a CRT wheel update."""

from __future__ import annotations

from dataclasses import dataclass

try:
    from machinery.amortized_certificate_walk import CostCertificate
    from machinery.ramanujan_sieve_ingestion import certified_ramanujan_rows
    from machinery.ramanujan_trace import (
        RamanujanTraceCertificate, compile_ramanujan_trace, divisors,
        ramanujan_convolution,
    )
except ModuleNotFoundError:  # direct script execution
    from amortized_certificate_walk import CostCertificate
    from ramanujan_sieve_ingestion import certified_ramanujan_rows
    from ramanujan_trace import (
        RamanujanTraceCertificate, compile_ramanujan_trace, divisors,
        ramanujan_convolution,
    )


@dataclass(frozen=True)
class UpdateCostVector:
    old_cells_reused: int
    new_cells_formed: int
    scratch_cells: int
    full_cache_lookups_per_shift: int
    factor_route_lookups_per_shift: int
    cached_old_factor_lookups_per_shift: int


@dataclass(frozen=True)
class ComposedCRTCertificate:
    wheel: int
    prime: int
    rows: dict[int, tuple[int, ...]]
    cost: UpdateCostVector
    full_cache_break_even: int | None
    factor_route_break_even: int | None
    cached_old_factor_break_even: int | None


def compose_certificates(
    wheel: int,
    old_rows: dict[int, tuple[int, ...]],
    prime_certificate: RamanujanTraceCertificate,
) -> ComposedCRTCertificate:
    """Construct the Wp certificate without composite cyclotomic rebuilds.

    Old rows and the prime row are proof inputs. The checker validates their
    arithmetic faces, then validates CRT products against Ramanujan's divisor
    convolution. The theorem c_qp=c_q*c_p transports the already checked
    cyclotomic interpretation; no Q(zeta_qp) matrix is reconstructed.
    """
    p = prime_certificate.modulus
    if set(old_rows) != set(divisors(wheel)):
        raise ValueError("old certificate must contain exactly the wheel divisors")
    for q, row in old_rows.items():
        if len(row) != q or any(value != ramanujan_convolution(q, h)
                                for h, value in enumerate(row)):
            raise ValueError("old row fails its arithmetic certificate")
    if any(value != ramanujan_convolution(p, h)
           for h, value in enumerate(prime_certificate.spectral_traces)):
        raise ValueError("prime row fails its arithmetic certificate")

    if any(q % p == 0 for q in old_rows):
        raise ValueError("prime certificate must be coprime to the old wheel")
    prime_row = prime_certificate.spectral_traces
    rows = dict(old_rows)
    for q, row in old_rows.items():
        rows[q * p] = tuple(row[h % q] * prime_row[h % p]
                            for h in range(q * p))
    for q in divisors(wheel):
        composite = q * p
        if any(value != ramanujan_convolution(composite, h)
               for h, value in enumerate(rows[composite])):
            raise AssertionError("CRT product fails the divisor-convolution face")

    old_cells = sum(len(row) for row in old_rows.values())
    new_cells = p * old_cells
    tau_w = len(old_rows)
    cost = UpdateCostVector(
        old_cells, new_cells, old_cells + new_cells,
        2 * tau_w, tau_w + 1, 1,
    )
    direct = wheel * p
    full = CostCertificate(new_cells, direct, 2 * tau_w)
    factor = CostCertificate(p, direct, tau_w + 1)
    cached = CostCertificate(p, direct, 1)
    return ComposedCRTCertificate(
        wheel, p, rows, cost,
        full.least_profitable_queries(), factor.least_profitable_queries(),
        cached.least_profitable_queries(),
    )


def wheel30_to_210() -> ComposedCRTCertificate:
    return compose_certificates(
        30, certified_ramanujan_rows(30), compile_ramanujan_trace(7)
    )


if __name__ == "__main__":
    result = wheel30_to_210()
    print({"cost": result.cost,
           "break_even": (result.full_cache_break_even,
                          result.factor_route_break_even,
                          result.cached_old_factor_break_even)})
    print("ALL EXACT CHECKS PASS")

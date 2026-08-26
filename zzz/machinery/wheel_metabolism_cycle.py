#!/usr/bin/env python3
"""One end-to-end representation-changing arithmetic task cycle."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction

try:
    from machinery.amortized_certificate_walk import CostCertificate, choose_route
    from machinery.ramanujan_sieve_ingestion import (
        certified_ramanujan_rows, compile_sieve_ingestion, euler_phi,
    )
    from machinery.ramanujan_trace import divisors, mobius
except ModuleNotFoundError:  # direct script execution
    from amortized_certificate_walk import CostCertificate, choose_route
    from ramanujan_sieve_ingestion import (
        certified_ramanujan_rows, compile_sieve_ingestion, euler_phi,
    )
    from ramanujan_trace import divisors, mobius


@dataclass(frozen=True)
class MetabolismCycle:
    wheel: int
    shifts: tuple[int, ...]
    route: str
    cost_certificate: CostCertificate
    charged_cost: int
    answers: tuple[Fraction, ...]
    direct_controls: tuple[Fraction, ...]
    installed_cells: int


def answer_from_rows(
    wheel: int, shift: int, rows: dict[int, tuple[int, ...]]
) -> Fraction:
    return sum(Fraction(mobius(q), euler_phi(q)) ** 2 * rows[q][shift % q]
               for q in divisors(wheel))


def run_wheel_cycle(wheel: int, shifts: tuple[int, ...]) -> MetabolismCycle:
    """Choose and certify direct vs primitive-trace representation by horizon."""
    if not shifts:
        raise ValueError("task must contain at least one shift query")
    probe = compile_sieve_ingestion(wheel, shifts[0])
    certificate = CostCertificate(
        probe.compiled_trace_cells,
        probe.direct_residue_checks,
        probe.spectral_terms,
    )
    decision = choose_route(certificate, len(shifts))
    controls = tuple(compile_sieve_ingestion(wheel, h).direct_value for h in shifts)
    if decision.route == "old":
        answers = controls
        installed = 0
    else:
        rows = certified_ramanujan_rows(wheel)
        answers = tuple(answer_from_rows(wheel, h, rows) for h in shifts)
        installed = sum(len(row) for row in rows.values())
        if answers != controls:
            raise AssertionError("installed representation leaks task answers")
    return MetabolismCycle(
        wheel, shifts, decision.route, certificate, decision.chosen_cost,
        answers, controls, installed,
    )


if __name__ == "__main__":
    short = run_wheel_cycle(30, (1, 2, 6))
    long = run_wheel_cycle(30, (1, 2, 6, 10))
    print({"short": short, "long": long})
    print("ALL EXACT CHECKS PASS")

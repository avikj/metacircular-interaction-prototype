#!/usr/bin/env python3
"""Exact compression of nested adaptive residue histories."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from adaptive_valuation_addition import (
    RefinementStep,
    ValuationCertificate,
    adaptive_sum_valuation,
)
from quantum_quotient_dilation import coherent_environment_dimension


@dataclass(frozen=True)
class TerminalResidueRecord:
    prime: int
    depth: int | None
    left_residue: int | None
    right_residue: int | None
    is_zero: bool


def terminal_record(certificate: ValuationCertificate) -> TerminalResidueRecord:
    """Compress a nested trace to its final residue pair plus the zero flag."""
    if certificate.is_zero:
        return TerminalResidueRecord(certificate.prime, None, None, None, True)
    if not certificate.steps:
        raise ValueError("a nonzero certificate needs a terminal step")
    last = certificate.steps[-1]
    return TerminalResidueRecord(
        certificate.prime, last.depth, last.left_residue, last.right_residue, False
    )


def reconstruct_trace(record: TerminalResidueRecord) -> tuple[RefinementStep, ...]:
    """Regenerate every nested residue observation from the terminal record."""
    if record.is_zero:
        if any(value is not None for value in (
            record.depth, record.left_residue, record.right_residue
        )):
            raise ValueError("zero record must not pretend to have a finite chart")
        return ()
    if record.depth is None or record.depth < 1:
        raise ValueError("nonzero record needs positive terminal depth")
    if record.left_residue is None or record.right_residue is None:
        raise ValueError("nonzero record needs both terminal residues")
    steps = []
    for depth in range(1, record.depth + 1):
        modulus = record.prime**depth
        left = record.left_residue % modulus
        right = record.right_residue % modulus
        steps.append(RefinementStep(depth, modulus, left, right, (left + right) % modulus))
    return tuple(steps)


def trace_and_terminal_costs(
    pairs: Iterable[tuple[int, int]], prime: int
) -> dict[str, int]:
    """Compare quotient-fiber dilation costs on a declared finite pair chart."""
    certificates = tuple(adaptive_sum_valuation(a, b, prime) for a, b in pairs)
    if not certificates:
        raise ValueError("finite pair chart must be nonempty")
    traces = tuple(certificate.steps for certificate in certificates)
    terminals = tuple(terminal_record(certificate) for certificate in certificates)
    if any(reconstruct_trace(record) != trace
           for record, trace in zip(terminals, traces)):
        raise AssertionError("terminal record failed to reconstruct trace")
    trace_cost = coherent_environment_dimension(traces)
    terminal_cost = coherent_environment_dimension(terminals)
    if trace_cost != terminal_cost:
        raise AssertionError("trace and terminal quotient fibers differ")
    return {
        "input_pairs": len(certificates),
        "trace_outputs": len(set(traces)),
        "terminal_outputs": len(set(terminals)),
        "coherent_environment_dimension": trace_cost,
    }


if __name__ == "__main__":
    chart = tuple((a, b) for a in range(-6, 7) for b in range(-6, 7))
    print(trace_and_terminal_costs(chart, 3))

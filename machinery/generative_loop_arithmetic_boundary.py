#!/usr/bin/env python3
"""Exact boundary between shape-generation and arithmetic task semantics."""

from __future__ import annotations

from dataclasses import dataclass

try:
    from machinery.task_generated_projector import (
        compile_task_projector, cyclic_autocorrelation,
    )
except ModuleNotFoundError:
    from task_generated_projector import compile_task_projector, cyclic_autocorrelation


@dataclass(frozen=True)
class UnaryTerm:
    """Python replay of Obstruction.Tm: a unary chain of natural heads."""

    heads: tuple[int, ...]


def projector_shape_term(signal: tuple[int, ...]) -> UnaryTerm:
    """The strongest coefficient-free encoding into Obstruction's head terms."""
    return UnaryTerm(compile_task_projector(signal).supported_orders)


@dataclass(frozen=True)
class BoundaryWitness:
    left_term: UnaryTerm
    right_term: UnaryTerm
    left_correlation: tuple[int, ...]
    right_correlation: tuple[int, ...]


def coefficient_erasure_witness(modulus: int = 30) -> BoundaryWitness:
    left = (1,) * modulus
    right = (2,) * modulus
    left_term = projector_shape_term(left)
    right_term = projector_shape_term(right)
    left_corr = cyclic_autocorrelation(left)
    right_corr = cyclic_autocorrelation(right)
    if left_term != right_term or left_corr == right_corr:
        raise AssertionError("expected same shape term but different arithmetic task")
    return BoundaryWitness(left_term, right_term, left_corr, right_corr)


if __name__ == "__main__":
    result = coefficient_erasure_witness()
    print(result)
    print("ALL EXACT CHECKS PASS")

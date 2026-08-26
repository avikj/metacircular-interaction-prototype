#!/usr/bin/env python3
"""End-to-end certificate cycle: derive, install, execute, or reopen."""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache

try:
    from machinery.amortized_certificate_walk import CostCertificate, choose_route
    from machinery.leakage_cost_vector import (
        ExecutionCostVector,
        compare_routes,
        position,
    )
    from machinery.primitive_character_projector import (
        compile_primitive_projector,
        primitive_projector,
        translation_matrix,
    )
    from machinery.ramanujan_sieve_ingestion import compile_sieve_ingestion
except ModuleNotFoundError:  # direct script execution
    from amortized_certificate_walk import CostCertificate, choose_route
    from leakage_cost_vector import ExecutionCostVector, compare_routes, position
    from primitive_character_projector import (
        compile_primitive_projector,
        primitive_projector,
        translation_matrix,
    )
    from ramanujan_sieve_ingestion import compile_sieve_ingestion


@dataclass(frozen=True)
class CycleState:
    phase: str
    representation: str
    exact: bool
    costs: tuple[ExecutionCostVector, ...]
    evidence: tuple[str, ...]


@lru_cache(maxsize=1)
def derive_wheel30() -> tuple[CostCertificate, object, object]:
    sieve = compile_sieve_ingestion(30, 6)
    projector = compile_primitive_projector(30)
    assert sieve.compiled_trace_cells == 72
    assert sieve.direct_residue_checks == 30
    assert sieve.spectral_terms == 8
    assert projector.projector_rank == 8
    return CostCertificate(72, 30, 8), projector, primitive_projector(30)


def decide_initial(horizon: int) -> CycleState:
    cost, projector, _ = derive_wheel30()
    decision = choose_route(cost, horizon)
    if decision.route == "old":
        return CycleState(
            "retained", "residue-enumeration", True,
            (ExecutionCostVector(decision.chosen_cost, 0, True),),
            (f"horizon={horizon}", "amortized inequality rejects compilation"),
        )
    return CycleState(
        "installed", "primitive-character-sector", True,
        (ExecutionCostVector(decision.chosen_cost, 0, True),),
        (f"horizon={horizon}", f"projector-rank={projector.projector_rank}",
         "amortized inequality installs compilation"),
    )


def expose_operator(installed: CycleState, operator_name: str, horizon: int) -> CycleState:
    if installed.phase != "installed":
        raise ValueError("operator exposure requires an installed compiled sector")
    cost, _, p = derive_wheel30()
    if operator_name == "translation":
        operator = translation_matrix(30, 1)
    elif operator_name == "position":
        operator = position(30)
    else:
        raise ValueError("unknown future operator")
    comparison = compare_routes(cost, horizon, p, operator)
    if comparison.leakage_rank == 0:
        return CycleState(
            "executed", installed.representation, True,
            (comparison.corrected,),
            installed.evidence + ("leakage-rank=0", "sector remains installed"),
        )
    return CycleState(
        "reopened", "Pareto-frontier", True,
        (comparison.old, comparison.corrected),
        installed.evidence +
        (f"leakage-rank={comparison.leakage_rank}",
         "sector-only execution rejected", "complementary channel required"),
    )


def cycle():
    short = decide_initial(3)
    installed = decide_initial(4)
    control = expose_operator(installed, "translation", 4)
    changed = expose_operator(installed, "position", 4)
    assert short.phase == "retained"
    assert installed.phase == "installed"
    assert control.phase == "executed"
    assert changed.phase == "reopened"
    assert changed.costs == (
        ExecutionCostVector(120, 0, True),
        ExecutionCostVector(104, 32, True),
    )
    return short, installed, control, changed


def main():
    print(dict(zip(("short", "installed", "control", "changed"), cycle())))
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

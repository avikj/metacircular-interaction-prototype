"""GENERATE -- the missing arrow of CRYSTAL.md sec 7, and the loop it closes.

Every other layer of ``runtime/`` is reactive: hand it mathematics and it gets
better.  Nothing produced mathematics.  This package does, and it does it with
no model anywhere in the cycle -- that is the thesis, not a limitation.

    multiway.py   a typed, proof-carrying multiway system: all rules at all
                  positions, all histories retained as a DAG, but every edge a
                  kernel ``Eq`` edge admitted through two exact gates, so a
                  corrupt rewrite is *refused* rather than merely unlikely
    propose.py    collisions in a cheap exact channel become ``Conjecture``
                  edges in a separate proposal graph; each is discharged into a
                  kernel-checked ``Eq``, refuted by an exact separating point
                  (whose dependency cone ``propagate/`` then invalidates), or
                  left standing as a residual that is never used
    loop.py       GENERATE -> DISTINGUISH -> PROVE -> CRYSTALLIZE -> COMPRESS
                  -> ROUTE -> REFLECT -> GENERATE, with a held-out benchmark
                  fixed before round 1 and a machine leakage check

CPU-only, pure stdlib, exact integers, deterministic across ``PYTHONHASHSEED``.
"""

from .loop import (ARROWS, BENCHMARK, BENCHMARK_NAME, Config, LeakageReport,
                   Organism, RoundReport, benchmark_cost, constructions,
                   leakage_report)
from .multiway import (AxiomVault, CausalReport, GenerationBudget, MEdge,
                       MultiwayGraph, R_SORT, Refusal, arrow_n, causal_report,
                       encode, generate, kernel_dirs, lift_path)
from .propose import (AUDIT_GRID, DEFAULT_CHANNEL, DISCHARGED, EXHAUSTED, OPEN,
                      REFUTED, Conjecture, Discharge, Probe, ProposalGraph,
                      collisions, discharge_by_rewriting,
                      discharge_by_saturation, eq_edge_from_derivations, probe,
                      signature, triage, variables_of)

__all__ = [
    # multiway
    "R_SORT", "encode", "arrow_n", "kernel_dirs", "lift_path", "AxiomVault",
    "MEdge", "Refusal", "MultiwayGraph", "CausalReport", "GenerationBudget",
    "generate", "causal_report",
    # propose
    "Probe", "probe", "signature", "variables_of", "collisions", "Conjecture",
    "Discharge", "ProposalGraph", "eq_edge_from_derivations",
    "discharge_by_rewriting", "discharge_by_saturation", "triage",
    "OPEN", "DISCHARGED", "REFUTED", "EXHAUSTED", "AUDIT_GRID",
    "DEFAULT_CHANNEL",
    # loop
    "ARROWS", "BENCHMARK", "BENCHMARK_NAME", "Config", "RoundReport",
    "Organism", "constructions", "leakage_report", "LeakageReport",
    "benchmark_cost",
]

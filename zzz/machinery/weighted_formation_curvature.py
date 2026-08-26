#!/usr/bin/env python3
"""Exact unlock/redundancy curvature of weighted replayable facts."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from typing import Iterable, Mapping

from proof_support_complementarity import minimal_supports, replayable


@dataclass(frozen=True)
class CurvatureReport:
    left: frozenset[str]
    right: frozenset[str]
    redundant_weight: int
    jointly_unlocked_weight: int

    @property
    def slack(self) -> int:
        """Submodularity slack F(A)+F(B)-F(A union B)-F(A intersection B)."""
        return self.redundant_weight - self.jointly_unlocked_weight


def weighted_value(
    retained: Iterable[str],
    fact_supports: Mapping[str, Iterable[Iterable[str]]],
    weights: Mapping[str, int],
) -> int:
    if set(fact_supports) != set(weights) or any(w < 0 for w in weights.values()):
        raise ValueError("facts need exactly one nonnegative weight each")
    return sum(weights[fact] * replayable(retained, supports)
               for fact, supports in fact_supports.items())


def curvature_report(
    left: Iterable[str],
    right: Iterable[str],
    fact_supports: Mapping[str, Iterable[Iterable[str]]],
    weights: Mapping[str, int],
) -> CurvatureReport:
    a, b = frozenset(left), frozenset(right)
    if set(fact_supports) != set(weights) or any(w < 0 for w in weights.values()):
        raise ValueError("facts need exactly one nonnegative weight each")
    redundant = unlocked = 0
    for fact, supports in fact_supports.items():
        qa = replayable(a, supports)
        qb = replayable(b, supports)
        qu = replayable(a | b, supports)
        qi = replayable(a & b, supports)
        if qa and qb and not qi:
            redundant += weights[fact]
        elif qu and not qa and not qb:
            unlocked += weights[fact]
    return CurvatureReport(a, b, redundant, unlocked)


def all_curvatures(
    fact_supports: Mapping[str, Iterable[Iterable[str]]],
    weights: Mapping[str, int],
) -> tuple[CurvatureReport, ...]:
    universe = sorted({rule for supports in fact_supports.values()
                       for support in minimal_supports(supports) for rule in support})
    subsets = [frozenset(c) for n in range(len(universe) + 1)
               for c in combinations(universe, n)]
    return tuple(curvature_report(a, b, fact_supports, weights)
                 for a in subsets for b in subsets)


def is_submodular(
    fact_supports: Mapping[str, Iterable[Iterable[str]]],
    weights: Mapping[str, int],
) -> bool:
    return all(report.slack >= 0 for report in all_curvatures(fact_supports, weights))


if __name__ == "__main__":
    facts = {"either": ({"a"}, {"b"}), "both": ({"a", "b"},)}
    for alpha, beta in ((2, 1), (2, 2), (2, 3)):
        weights = {"either": beta, "both": alpha}
        report = curvature_report({"a"}, {"b"}, facts, weights)
        print("alpha", alpha, "beta", beta, "report", report,
              "submodular", is_submodular(facts, weights))

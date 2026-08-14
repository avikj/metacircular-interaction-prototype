#!/usr/bin/env python3
"""A cost certificate that changes route only relative to a query horizon."""

from __future__ import annotations

from dataclasses import dataclass

try:
    from machinery.ramanujan_sieve_ingestion import compile_sieve_ingestion
except ModuleNotFoundError:  # direct script execution
    from ramanujan_sieve_ingestion import compile_sieve_ingestion


@dataclass(frozen=True)
class CostCertificate:
    compile_once: int
    old_per_query: int
    new_per_query: int

    def validate(self) -> None:
        if min(self.compile_once, self.old_per_query, self.new_per_query) < 0:
            raise ValueError("costs must be nonnegative")

    def old_total(self, queries: int) -> int:
        self.validate()
        if queries < 0:
            raise ValueError("query horizon must be nonnegative")
        return queries * self.old_per_query

    def compiled_total(self, queries: int) -> int:
        self.validate()
        if queries < 0:
            raise ValueError("query horizon must be nonnegative")
        return self.compile_once + queries * self.new_per_query

    def strict_gain(self, queries: int) -> bool:
        return self.compiled_total(queries) < self.old_total(queries)

    def least_profitable_queries(self) -> int | None:
        """Least k with C+kS<kD, or None when strict gain is impossible."""
        self.validate()
        saving = self.old_per_query - self.new_per_query
        if saving <= 0:
            return None
        return self.compile_once // saving + 1


@dataclass(frozen=True)
class RouteDecision:
    route: str
    queries: int
    chosen_cost: int
    rejected_cost: int
    strict_gain: int


def choose_route(certificate: CostCertificate, queries: int) -> RouteDecision:
    """The walk derives its route from a checked cost inequality."""
    old = certificate.old_total(queries)
    compiled = certificate.compiled_total(queries)
    if compiled < old:
        return RouteDecision("compile", queries, compiled, old, old - compiled)
    return RouteDecision("old", queries, old, compiled, compiled - old)


def wheel30_certificate() -> CostCertificate:
    ingestion = compile_sieve_ingestion(30, 6)
    certificate = CostCertificate(
        ingestion.compiled_trace_cells,
        ingestion.direct_residue_checks,
        ingestion.spectral_terms,
    )
    assert certificate == CostCertificate(72, 30, 8)
    return certificate


def indistinguishable_prefix_no_go(certificate: CostCertificate):
    """One pre-query state has optimal continuations requiring opposite acts."""
    threshold = certificate.least_profitable_queries()
    if threshold is None or threshold == 0:
        raise ValueError("certificate has no nontrivial break-even boundary")
    short = choose_route(certificate, threshold - 1)
    long = choose_route(certificate, threshold)
    if short.route != "old" or long.route != "compile":
        raise AssertionError("claimed boundary does not separate decisions")
    # Before either future begins, the installed state and certificate are
    # identical. Therefore no horizon-free function of that state can equal
    # both optimal decisions.
    return short, long


def main():
    certificate = wheel30_certificate()
    short, long = indistinguishable_prefix_no_go(certificate)
    assert certificate.least_profitable_queries() == 4
    assert short == RouteDecision("old", 3, 90, 96, 6)
    assert long == RouteDecision("compile", 4, 104, 120, 16)
    print({"certificate": certificate, "short": short, "long": long})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

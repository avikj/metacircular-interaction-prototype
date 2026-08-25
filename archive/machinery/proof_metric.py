#!/usr/bin/env python3
"""Proof-carrying min-plus compilation for finite directed proof graphs.

A checked old path may be installed as a cheaper macro edge.  The macro does
not change reachability, while one O(n^2) min-plus relaxation computes every
changed shortest access cost.  Validation provenance remains the old path.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Hashable, Iterable, Mapping, Sequence

Vertex = Hashable
Cost = Fraction
Distance = Fraction | None  # None is positive infinity.


@dataclass(frozen=True)
class ProofEdge:
    name: str
    source: Vertex
    target: Vertex
    cost: Fraction | int


@dataclass(frozen=True)
class HyperRule:
    """Boundary marker: multi-premise rules are not ordinary proof edges."""

    name: str
    premises: tuple[Vertex, ...]
    conclusion: Vertex
    cost: Fraction | int


@dataclass(frozen=True)
class MacroCertificate:
    name: str
    source: Vertex
    target: Vertex
    access_cost: Fraction | int
    expansion: tuple[str, ...]


@dataclass(frozen=True)
class CompilationResult:
    macro: ProofEdge
    expansion: tuple[str, ...]
    validation_cost: Cost
    before: Mapping[tuple[Vertex, Vertex], Distance]
    after: Mapping[tuple[Vertex, Vertex], Distance]
    influence_cone: tuple[tuple[Vertex, Vertex, Cost, Cost], ...]
    witnesses: Mapping[tuple[Vertex, Vertex], tuple[str, ...] | None]


def _cost(value: Fraction | int) -> Cost:
    result = Fraction(value)
    if result < 0:
        raise ValueError("proof access costs must be nonnegative")
    return result


def _validated_edges(
    vertices: Sequence[Vertex], edges: Iterable[ProofEdge]
) -> tuple[tuple[Vertex, ...], tuple[ProofEdge, ...]]:
    xs = tuple(vertices)
    if len(set(xs)) != len(xs):
        raise ValueError("vertices must be unique")
    universe = set(xs)
    checked = []
    names = set()
    for edge in edges:
        if not isinstance(edge, ProofEdge):
            if isinstance(edge, HyperRule):
                raise TypeError(
                    "hyperrules require an AND/OR proof hypergraph; flattening them "
                    "to ordinary edges can certify conclusions without every premise"
                )
            raise TypeError("every graph edge must be a ProofEdge")
        if edge.name in names:
            raise ValueError(f"duplicate edge name: {edge.name}")
        if edge.source not in universe or edge.target not in universe:
            raise ValueError(f"edge {edge.name} has an undeclared endpoint")
        names.add(edge.name)
        checked.append(ProofEdge(edge.name, edge.source, edge.target, _cost(edge.cost)))
    return xs, tuple(checked)


def all_pairs_shortest_paths(
    vertices: Sequence[Vertex], edges: Iterable[ProofEdge]
) -> tuple[
    dict[tuple[Vertex, Vertex], Distance],
    dict[tuple[Vertex, Vertex], tuple[str, ...] | None],
]:
    """Exact Floyd--Warshall distances and one replayable witness per pair."""
    xs, es = _validated_edges(vertices, edges)
    dist: dict[tuple[Vertex, Vertex], Distance] = {
        (x, y): (Fraction(0) if x == y else None) for x in xs for y in xs
    }
    witness: dict[tuple[Vertex, Vertex], tuple[str, ...] | None] = {
        (x, y): (() if x == y else None) for x in xs for y in xs
    }
    for edge in es:
        key = (edge.source, edge.target)
        old = dist[key]
        if old is None or edge.cost < old:
            dist[key] = Fraction(edge.cost)
            witness[key] = (edge.name,)
    for middle in xs:
        for source in xs:
            left = dist[source, middle]
            if left is None:
                continue
            for target in xs:
                right = dist[middle, target]
                if right is None:
                    continue
                candidate = left + right
                old = dist[source, target]
                if old is None or candidate < old:
                    dist[source, target] = candidate
                    first = witness[source, middle]
                    second = witness[middle, target]
                    assert first is not None and second is not None
                    witness[source, target] = first + second
    return dist, witness


def _validate_certificate(
    edges: tuple[ProofEdge, ...], certificate: MacroCertificate
) -> tuple[Cost, ProofEdge]:
    by_name = {edge.name: edge for edge in edges}
    if certificate.name in by_name:
        raise ValueError("macro name collides with an existing edge")
    if not certificate.expansion:
        raise ValueError("a macro certificate must contain an existing nonempty path")
    current = certificate.source
    validation_cost = Fraction(0)
    for name in certificate.expansion:
        edge = by_name.get(name)
        if edge is None:
            raise ValueError(f"certificate cites unknown edge: {name}")
        if edge.source != current:
            raise ValueError(f"certificate is discontinuous before edge: {name}")
        validation_cost += Fraction(edge.cost)
        current = edge.target
    if current != certificate.target:
        raise ValueError("certificate path does not reach the macro target")
    return validation_cost, ProofEdge(
        certificate.name,
        certificate.source,
        certificate.target,
        _cost(certificate.access_cost),
    )


def compile_macro(
    vertices: Sequence[Vertex],
    edges: Iterable[ProofEdge],
    certificate: MacroCertificate,
) -> CompilationResult:
    """Install a certified macro and verify its O(n^2) distance update.

    The update is
      D'(x,y) = min(D(x,y), D(x,u) + c + D(v,y)).
    A fresh exact APSP computation is performed as a fail-closed replay check.
    """
    xs, es = _validated_edges(vertices, edges)
    if certificate.source not in xs or certificate.target not in xs:
        raise ValueError("macro has an undeclared endpoint")
    validation_cost, macro = _validate_certificate(es, certificate)
    before, old_witnesses = all_pairs_shortest_paths(xs, es)
    after = dict(before)
    witnesses = dict(old_witnesses)
    influence = []
    for source in xs:
        prefix = before[source, macro.source]
        if prefix is None:
            continue
        for target in xs:
            suffix = before[macro.target, target]
            if suffix is None:
                continue
            candidate = prefix + Fraction(macro.cost) + suffix
            old = before[source, target]
            if old is None or candidate < old:
                after[source, target] = candidate
                first = old_witnesses[source, macro.source]
                last = old_witnesses[macro.target, target]
                assert first is not None and last is not None
                witnesses[source, target] = first + (macro.name,) + last
                if old is not None:
                    influence.append((source, target, old, candidate))

    fresh, _ = all_pairs_shortest_paths(xs, es + (macro,))
    if after != fresh:
        raise AssertionError("rank-one min-plus update disagrees with fresh APSP")

    return CompilationResult(
        macro,
        certificate.expansion,
        validation_cost,
        before,
        after,
        tuple(influence),
        witnesses,
    )

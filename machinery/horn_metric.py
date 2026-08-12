#!/usr/bin/env python3
"""Exact context-indexed compilation for finite fact-adding Horn systems."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations
from typing import Hashable, Iterable, Mapping, Sequence

from machinery.proof_metric import ProofEdge, all_pairs_shortest_paths

Atom = Hashable
State = frozenset[Atom]
Distance = Fraction | None


@dataclass(frozen=True)
class HornRule:
    name: str
    premises: frozenset[Atom]
    conclusion: Atom
    cost: Fraction | int


@dataclass(frozen=True)
class DeletionRule:
    name: str
    premises: frozenset[Atom]
    deleted: Atom
    cost: Fraction | int


@dataclass(frozen=True)
class LinearResourceRule:
    name: str
    consumed: tuple[Atom, ...]
    produced: tuple[Atom, ...]
    cost: Fraction | int


@dataclass(frozen=True)
class HornMacroCertificate:
    name: str
    premises: frozenset[Atom]
    conclusion: Atom
    access_cost: Fraction | int
    expansion: tuple[str, ...]


@dataclass(frozen=True)
class HornCompilationResult:
    certificate: HornMacroCertificate
    validation_cost: Fraction
    states: tuple[State, ...]
    macro_edges: tuple[ProofEdge, ...]
    before: Mapping[tuple[State, State], Distance]
    after: Mapping[tuple[State, State], Distance]
    influence_cone: tuple[tuple[State, State, Distance, Fraction], ...]
    witnesses: Mapping[tuple[State, State], tuple[str, ...] | None]


def _cost(value: Fraction | int) -> Fraction:
    result = Fraction(value)
    if result < 0:
        raise ValueError("Horn access costs must be nonnegative")
    return result


def subset_states(atoms: Sequence[Atom]) -> tuple[State, ...]:
    xs = tuple(atoms)
    if len(set(xs)) != len(xs):
        raise ValueError("atoms must be unique")
    return tuple(
        frozenset(choice)
        for size in range(len(xs) + 1)
        for choice in combinations(xs, size)
    )


def _validate_rules(
    atoms: Sequence[Atom], rules: Iterable[HornRule]
) -> tuple[tuple[Atom, ...], tuple[HornRule, ...]]:
    xs = tuple(atoms)
    if len(set(xs)) != len(xs):
        raise ValueError("atoms must be unique")
    universe = set(xs)
    checked = []
    names = set()
    for rule in rules:
        if isinstance(rule, DeletionRule):
            raise TypeError("deletion rules are not fact-adding Horn rules")
        if isinstance(rule, LinearResourceRule):
            raise TypeError("linear-resource rules require resource-sensitive states")
        if not isinstance(rule, HornRule):
            raise TypeError("every rule must be a HornRule")
        if rule.name in names:
            raise ValueError(f"duplicate rule name: {rule.name}")
        if not set(rule.premises) <= universe or rule.conclusion not in universe:
            raise ValueError(f"rule {rule.name} uses an undeclared atom")
        names.add(rule.name)
        checked.append(HornRule(
            rule.name, frozenset(rule.premises), rule.conclusion, _cost(rule.cost)
        ))
    return xs, tuple(checked)


def horn_state_graph(
    atoms: Sequence[Atom], rules: Iterable[HornRule]
) -> tuple[tuple[State, ...], tuple[ProofEdge, ...]]:
    """Compile fact-adding Horn rules to the full partial-knowledge state graph."""
    xs, checked = _validate_rules(atoms, rules)
    states = subset_states(xs)
    index = {state: number for number, state in enumerate(states)}
    edges = []
    for rule in checked:
        for state in states:
            if rule.premises <= state and rule.conclusion not in state:
                target = state | {rule.conclusion}
                edges.append(ProofEdge(
                    f"{rule.name}@{index[state]}", state, target, rule.cost
                ))
    return states, tuple(edges)


def _validate_certificate(
    atoms: tuple[Atom, ...],
    rules: tuple[HornRule, ...],
    certificate: HornMacroCertificate,
) -> Fraction:
    universe = set(atoms)
    if not set(certificate.premises) <= universe or certificate.conclusion not in universe:
        raise ValueError("macro certificate uses an undeclared atom")
    if certificate.conclusion in certificate.premises:
        raise ValueError("macro conclusion is already a premise")
    _cost(certificate.access_cost)
    if not certificate.expansion:
        raise ValueError("a Horn macro requires a nonempty derivation certificate")
    by_name = {rule.name: rule for rule in rules}
    if certificate.name in by_name:
        raise ValueError("macro name collides with a primitive rule")
    facts = set(certificate.premises)
    validation_cost = Fraction(0)
    for name in certificate.expansion:
        rule = by_name.get(name)
        if rule is None:
            raise ValueError(f"certificate cites unknown rule: {name}")
        if not rule.premises <= facts:
            raise ValueError(f"certificate invokes disabled rule: {name}")
        facts.add(rule.conclusion)
        validation_cost += Fraction(rule.cost)
    if certificate.conclusion not in facts:
        raise ValueError("certificate does not derive the macro conclusion")
    return validation_cost


def compile_horn_macro(
    atoms: Sequence[Atom],
    rules: Iterable[HornRule],
    certificate: HornMacroCertificate,
) -> HornCompilationResult:
    """Install one certified derived Horn rule in every weakening context.

    The exact update is the minimum, over every enabling state S, of the
    outer-product relaxation through S -> S union {conclusion}.
    """
    xs, checked = _validate_rules(atoms, rules)
    validation_cost = _validate_certificate(xs, checked, certificate)
    states, old_edges = horn_state_graph(xs, checked)
    index = {state: number for number, state in enumerate(states)}
    macro_cost = _cost(certificate.access_cost)
    enabling = tuple(
        state for state in states
        if certificate.premises <= state and certificate.conclusion not in state
    )
    macro_edges = tuple(
        ProofEdge(
            f"{certificate.name}@{index[state]}",
            state,
            state | {certificate.conclusion},
            macro_cost,
        )
        for state in enabling
    )

    before, old_witnesses = all_pairs_shortest_paths(states, old_edges)
    after = dict(before)
    witnesses = dict(old_witnesses)
    for source in states:
        for target in states:
            best = before[source, target]
            best_witness = old_witnesses[source, target]
            for edge in macro_edges:
                prefix = before[source, edge.source]
                suffix = before[edge.target, target]
                if prefix is None or suffix is None:
                    continue
                candidate = prefix + Fraction(edge.cost) + suffix
                if best is None or candidate < best:
                    first = old_witnesses[source, edge.source]
                    last = old_witnesses[edge.target, target]
                    assert first is not None and last is not None
                    best = candidate
                    best_witness = first + (edge.name,) + last
            after[source, target] = best
            witnesses[source, target] = best_witness

    fresh, _ = all_pairs_shortest_paths(states, old_edges + macro_edges)
    if after != fresh:
        raise AssertionError("context-indexed update disagrees with fresh APSP")

    influence = tuple(
        (source, target, before[source, target], after[source, target])
        for source in states for target in states
        if after[source, target] is not None
        and (before[source, target] is None
             or after[source, target] < before[source, target])
    )
    return HornCompilationResult(
        certificate,
        validation_cost,
        states,
        macro_edges,
        before,
        after,
        influence,
        witnesses,
    )

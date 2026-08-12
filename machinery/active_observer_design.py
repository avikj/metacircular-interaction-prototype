#!/usr/bin/env python3
"""Exact one-step experimental design for finite observational systems."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Hashable, Mapping, Sequence

State = Hashable
Output = Hashable


@dataclass(frozen=True)
class Probe:
    name: str
    cost: int
    response: Mapping[State, Output]


@dataclass(frozen=True)
class ProbeChoice:
    probe: str
    cost: int
    disagreement_gain: Fraction
    gain_per_cost: Fraction
    outcome_masses: tuple[tuple[Output, Fraction], ...]


def _validate(states: tuple[State, ...], probes: tuple[Probe, ...]) -> None:
    if len(set(states)) != len(states):
        raise ValueError("states must be unique")
    if len({probe.name for probe in probes}) != len(probes):
        raise ValueError("probe names must be unique")
    for probe in probes:
        if probe.cost <= 0:
            raise ValueError("probe costs must be positive integers")
        if any(state not in probe.response for state in states):
            raise ValueError(f"probe {probe.name} is not total")


def posterior(
    states: Sequence[State],
    probes: Sequence[Probe],
    prior: Mapping[State, Fraction | int],
    evidence: Sequence[tuple[str, Output]] = (),
) -> tuple[tuple[State, Fraction], ...]:
    """Condition an exact finite prior on deterministic probe outcomes."""
    xs, ps = tuple(states), tuple(probes)
    _validate(xs, ps)
    by_name = {probe.name: probe for probe in ps}
    weights = {state: Fraction(prior[state]) for state in xs}
    if any(weight < 0 for weight in weights.values()):
        raise ValueError("prior weights must be nonnegative")
    for name, output in evidence:
        if name not in by_name:
            raise ValueError(f"unknown probe {name}")
        probe = by_name[name]
        weights = {state: weight for state, weight in weights.items()
                   if probe.response[state] == output}
    total = sum(weights.values(), Fraction())
    if total == 0:
        raise ValueError("evidence has zero prior mass")
    return tuple((state, weights.get(state, Fraction()) / total) for state in xs
                 if weights.get(state, 0) > 0)


def choose_next_probe(
    states: Sequence[State],
    probes: Sequence[Probe],
    prior: Mapping[State, Fraction | int],
    evidence: Sequence[tuple[str, Output]] = (),
    budget: int | None = None,
) -> ProbeChoice | None:
    """Maximize exact pair-disagreement probability per unit probe cost.

    If the true state and an independent posterior rival are sampled, a probe
    eliminates the rival exactly when their outputs differ.  Its gain is thus
    ``1 - sum_y P(output=y)^2``.  This routine maximizes gain/cost, breaking
    ties by larger raw gain, lower cost, then probe name.
    """
    xs, ps = tuple(states), tuple(probes)
    _validate(xs, ps)
    post = dict(posterior(xs, ps, prior, evidence))
    used = {name for name, _ in evidence}
    choices = []
    for probe in ps:
        if probe.name in used or (budget is not None and probe.cost > budget):
            continue
        masses: dict[Output, Fraction] = {}
        for state, mass in post.items():
            output = probe.response[state]
            masses[output] = masses.get(output, Fraction()) + mass
        gain = 1 - sum((mass * mass for mass in masses.values()), Fraction())
        choices.append(ProbeChoice(
            probe.name,
            probe.cost,
            gain,
            gain / probe.cost,
            tuple(sorted(masses.items(), key=lambda item: repr(item[0]))),
        ))
    if not choices:
        return None
    return min(choices, key=lambda choice: (
        -choice.gain_per_cost,
        -choice.disagreement_gain,
        choice.cost,
        choice.probe,
    ))


def resource_distinguishability(
    states: Sequence[State], probes: Sequence[Probe]
) -> tuple[tuple[State, State, int | None, tuple[str, ...]], ...]:
    """Return minimum one-probe cost and all cheapest witnesses for each pair."""
    xs, ps = tuple(states), tuple(probes)
    _validate(xs, ps)
    result = []
    for i, left in enumerate(xs):
        for right in xs[i + 1:]:
            witnesses = [probe for probe in ps
                         if probe.response[left] != probe.response[right]]
            if not witnesses:
                result.append((left, right, None, ()))
                continue
            cost = min(probe.cost for probe in witnesses)
            names = tuple(sorted(probe.name for probe in witnesses
                                 if probe.cost == cost))
            result.append((left, right, cost, names))
    return tuple(result)


def shortest_context_probes(elements, operations, observation, crystal):
    """Compile a crystal's shortest context words into executable probes.

    The pool is the union of the identity, every pairwise shortest witness,
    and the minimum separating basis.  Cost is one for observation plus the
    number of elementary translations.
    """
    operation_by_name = {operation.name: operation for operation in operations}
    words = {()}
    words.update(item[2] for item in crystal.distinctions)
    words.update(crystal.separating_contexts)

    def apply_word(value, word):
        for operation_name, slot, fixed in word:
            operation = operation_by_name[operation_name]
            args = list(fixed)
            args.insert(slot, value)
            value = operation.table[tuple(args)]
        return value

    ordered = sorted(words, key=lambda word: (len(word), repr(word)))
    return tuple(Probe(
        "identity" if not word else repr(word),
        len(word) + 1,
        {element: observation[apply_word(element, word)] for element in elements},
    ) for word in ordered)

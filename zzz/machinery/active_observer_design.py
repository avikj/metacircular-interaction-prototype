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


@dataclass(frozen=True)
class FormationPressure:
    """A witnessed model-closure defect, carrying no evidentiary authority."""
    kind: str
    model_states: tuple[State, ...]
    probe_names: tuple[str, ...]
    evidence_prefix: tuple[tuple[str, Output], ...]
    witness: tuple[str, Output]
    live_support: tuple[State, ...]


@dataclass(frozen=True)
class RevisionAudit:
    """Exact ledger for a proposed translation into a revised observer."""
    state_fibers: tuple[tuple[State, tuple[State, ...]], ...]
    forgotten_states: tuple[State, ...]
    preserved_probes: tuple[str, ...]
    violated_probes: tuple[tuple[str, tuple[State, ...]], ...]
    new_probes: tuple[str, ...]


@dataclass(frozen=True)
class RevisionCompositionAudit:
    """Pointwise old/intermediate/new response comparisons for two revisions."""
    comparisons: tuple[tuple[str, State, Output, Output, Output], ...]
    first_defects: tuple[tuple[str, tuple[State, ...]], ...]
    second_defects: tuple[tuple[str, tuple[State, ...]], ...]
    composite_defects: tuple[tuple[str, tuple[State, ...]], ...]


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


def condition_or_pressure(
    states: Sequence[State], probes: Sequence[Probe],
    prior: Mapping[State, Fraction | int],
    evidence: Sequence[tuple[str, Output]] = (),
) -> tuple[tuple[State, Fraction], ...] | FormationPressure:
    """Condition, or preserve the first impossible outcome as a witness."""
    xs, ps, history = tuple(states), tuple(probes), tuple(evidence)
    _validate(xs, ps)
    by_name = {probe.name: probe for probe in ps}
    weights = {state: Fraction(prior[state]) for state in xs}
    if any(weight < 0 for weight in weights.values()):
        raise ValueError("prior weights must be nonnegative")
    if sum(weights.values(), Fraction()) == 0:
        raise ValueError("prior must have positive total mass")
    for index, (name, output) in enumerate(history):
        if name not in by_name:
            raise ValueError(f"unknown probe {name}")
        live = tuple(state for state in xs if weights.get(state, 0) > 0)
        probe = by_name[name]
        narrowed = {state: weight for state, weight in weights.items()
                    if probe.response[state] == output}
        if sum(narrowed.values(), Fraction()) == 0:
            return FormationPressure(
                "out_of_model_outcome", xs, tuple(p.name for p in ps),
                history[:index], (name, output), live,
            )
        weights = narrowed
    total = sum(weights.values(), Fraction())
    return tuple((state, weights[state] / total) for state in xs
                 if weights.get(state, 0) > 0)


def choose_next_probe(
    states: Sequence[State],
    probes: Sequence[Probe],
    prior: Mapping[State, Fraction | int],
    evidence: Sequence[tuple[str, Output]] = (),
    budget: int | None = None,
) -> ProbeChoice | FormationPressure | None:
    """Maximize exact pair-disagreement probability per unit probe cost.

    If the true state and an independent posterior rival are sampled, a probe
    eliminates the rival exactly when their outputs differ.  Its gain is thus
    ``1 - sum_y P(output=y)^2``.  This routine maximizes gain/cost, breaking
    ties by larger raw gain, lower cost, then probe name.
    """
    xs, ps = tuple(states), tuple(probes)
    _validate(xs, ps)
    assessment = condition_or_pressure(xs, ps, prior, evidence)
    if isinstance(assessment, FormationPressure):
        return assessment
    post = dict(assessment)
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


def audit_revision(
    old_states: Sequence[State], old_probes: Sequence[Probe],
    new_states: Sequence[State], new_probes: Sequence[Probe],
    state_projection: Mapping[State, State],
    probe_translation: Mapping[str, str],
) -> RevisionAudit:
    """Audit commuting response squares for a proposed model revision."""
    old_xs, old_qs = tuple(old_states), tuple(old_probes)
    new_xs, new_qs = tuple(new_states), tuple(new_probes)
    _validate(old_xs, old_qs)
    _validate(new_xs, new_qs)
    if set(state_projection) != set(new_xs):
        raise ValueError("state projection must cover exactly the new states")
    if any(state_projection[x] not in old_xs for x in new_xs):
        raise ValueError("state projection targets an unknown old state")
    if set(probe_translation) != {q.name for q in old_qs}:
        raise ValueError("probe translation must cover exactly the old probes")
    old_by_name = {q.name: q for q in old_qs}
    new_by_name = {q.name: q for q in new_qs}
    if any(name not in new_by_name for name in probe_translation.values()):
        raise ValueError("probe translation targets an unknown new probe")
    fibers = tuple((old, tuple(new for new in new_xs
                               if state_projection[new] == old))
                   for old in old_xs)
    forgotten = tuple(old for old, fiber in fibers if not fiber)
    preserved: list[str] = []
    violated: list[tuple[str, tuple[State, ...]]] = []
    for old_name, new_name in probe_translation.items():
        old_probe, new_probe = old_by_name[old_name], new_by_name[new_name]
        failures = tuple(new for new in new_xs if
                         new_probe.response[new] !=
                         old_probe.response[state_projection[new]])
        if failures:
            violated.append((old_name, failures))
        else:
            preserved.append(old_name)
    translated = set(probe_translation.values())
    return RevisionAudit(
        fibers, forgotten, tuple(preserved), tuple(violated),
        tuple(q.name for q in new_qs if q.name not in translated),
    )


def audit_revision_composition(
    old_states: Sequence[State], old_probes: Sequence[Probe],
    middle_states: Sequence[State], middle_probes: Sequence[Probe],
    new_states: Sequence[State], new_probes: Sequence[Probe],
    middle_to_old: Mapping[State, State], old_to_middle_probe: Mapping[str, str],
    new_to_middle: Mapping[State, State], middle_to_new_probe: Mapping[str, str],
) -> RevisionCompositionAudit:
    """Retain the comparison span needed to compose observation revisions."""
    old_xs, middle_xs, new_xs = tuple(old_states), tuple(middle_states), tuple(new_states)
    old_qs, middle_qs, new_qs = tuple(old_probes), tuple(middle_probes), tuple(new_probes)
    _validate(old_xs, old_qs); _validate(middle_xs, middle_qs); _validate(new_xs, new_qs)
    if set(middle_to_old) != set(middle_xs) or set(new_to_middle) != set(new_xs):
        raise ValueError("state projections must cover their source states exactly")
    if set(old_to_middle_probe) != {q.name for q in old_qs}:
        raise ValueError("first probe translation must cover the old probes")
    if any(name not in middle_to_new_probe for name in old_to_middle_probe.values()):
        raise ValueError("second probe translation misses an intermediate image probe")
    old_by = {q.name: q for q in old_qs}; mid_by = {q.name: q for q in middle_qs}; new_by = {q.name: q for q in new_qs}
    comparisons = []
    first, second, composite = [], [], []
    for old_name, middle_name in old_to_middle_probe.items():
        new_name = middle_to_new_probe[middle_name]
        if middle_name not in mid_by or new_name not in new_by:
            raise ValueError("probe translation targets an unknown probe")
        d1, d2, dc = [], [], []
        for new_state in new_xs:
            middle_state = new_to_middle[new_state]
            if middle_state not in middle_to_old:
                raise ValueError("composite state projection is undefined")
            old_state = middle_to_old[middle_state]
            a = old_by[old_name].response[old_state]
            b = mid_by[middle_name].response[middle_state]
            c = new_by[new_name].response[new_state]
            comparisons.append((old_name, new_state, a, b, c))
            if a != b: d1.append(new_state)
            if b != c: d2.append(new_state)
            if a != c: dc.append(new_state)
        first.append((old_name, tuple(d1))); second.append((old_name, tuple(d2))); composite.append((old_name, tuple(dc)))
    return RevisionCompositionAudit(tuple(comparisons), tuple(first), tuple(second), tuple(composite))


def shortest_context_probes(elements, operations, observation, crystal):
    """Compile shortest elementary-context words into executable probes.

    The pool is the union of the identity, every pairwise shortest witness,
    and the minimum separating basis.  Cost is one for observation plus the
    number of elementary translations.
    """
    from context_monoid import build_context_monoid

    monoid = build_context_monoid(elements, operations, observation)
    if tuple(map(frozenset, monoid.fibers)) != tuple(map(frozenset, crystal.fibers)):
        raise ValueError("context monoid and supplied crystal disagree")
    class_of = {
        element: index
        for index, fiber in enumerate(monoid.fibers)
        for element in fiber
    }
    words = {()}
    words.update(word for _, _, word in monoid.witnesses)
    ordered = sorted(words, key=lambda word: (len(word), word))
    return tuple(Probe(
        "identity" if not word else repr(tuple(
            monoid.generators[index].name for index in word
        )),
        len(word) + 1,
        {element: monoid.observations[monoid.apply_word(class_of[element], word)]
         for element in elements},
    ) for word in ordered)

#!/usr/bin/env python3
"""Finite dependent rule closure: a compact initial-crystal nucleus.

This realizes only Voevodsky's minimal closure requirement, not general
dependent type theory or the Initiality Conjecture.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Hashable, Iterable, Mapping

Sentence = Hashable


@dataclass(frozen=True)
class Rule:
    name: str
    premises: frozenset[Sentence]
    conclusion: Sentence
    requires_rules: frozenset[str] = frozenset()


@dataclass(frozen=True)
class Derivation:
    sentence: Sentence
    rule: str | None
    parents: tuple[Sentence, ...]


@dataclass(frozen=True)
class GeneratedCrystal:
    sentences: frozenset[Sentence]
    derivations: tuple[Derivation, ...]

    def origin(self, sentence: Sentence) -> tuple[Derivation, ...]:
        return tuple(item for item in self.derivations if item.sentence == sentence)


def validate_rules(rules: Iterable[Rule]) -> tuple[Rule, ...]:
    system = tuple(rules)
    names = [rule.name for rule in system]
    if len(set(names)) != len(names):
        raise ValueError("rule names must be unique")
    known = set(names)
    missing = {dependency for rule in system for dependency in rule.requires_rules
               if dependency not in known}
    if missing:
        raise ValueError(f"unknown rule dependencies: {sorted(missing)}")
    return system


def generate(rules: Iterable[Rule], seeds: Iterable[Sentence] = ()) -> GeneratedCrystal:
    """Compute least rule-closed set and all first-discovered derivation edges."""
    system = validate_rules(rules)
    closed = set(seeds)
    witnesses = [Derivation(sentence, None, ()) for sentence in seeds]
    changed = True
    while changed:
        changed = False
        for rule in system:
            if rule.premises <= closed and rule.conclusion not in closed:
                closed.add(rule.conclusion)
                witnesses.append(Derivation(rule.conclusion, rule.name,
                                            tuple(sorted(rule.premises, key=repr))))
                changed = True
    return GeneratedCrystal(frozenset(closed), tuple(witnesses))


def is_closed(sentences: Iterable[Sentence], rules: Iterable[Rule]) -> bool:
    system = validate_rules(rules)
    subset = set(sentences)
    return all(not (rule.premises <= subset) or rule.conclusion in subset
               for rule in system)


def interpret(crystal: GeneratedCrystal, rules: Iterable[Rule],
              images: Mapping[Sentence, Hashable],
              model_rules: Mapping[str, tuple[tuple[Hashable, ...], Hashable]]) -> dict[Sentence, Hashable]:
    """Verify a declared realization preserves each used derivation.

    General initiality is not inferred.  This checker validates one proposed
    interpretation against the retained proof-relevant derivation graph.
    """
    system = {rule.name: rule for rule in validate_rules(rules)}
    if any(sentence not in images for sentence in crystal.sentences):
        raise ValueError("interpretation is not total on generated sentences")
    for derivation in crystal.derivations:
        if derivation.rule is None:
            continue
        rule = system[derivation.rule]
        expected_parents, expected_output = model_rules[rule.name]
        actual_parents = tuple(images[parent] for parent in derivation.parents)
        if actual_parents != expected_parents or images[derivation.sentence] != expected_output:
            raise ValueError(f"interpretation does not preserve {rule.name}")
    return {sentence: images[sentence] for sentence in crystal.sentences}

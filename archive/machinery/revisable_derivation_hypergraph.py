"""Finite monotone AND/OR derivations with exact rule-deletion provenance."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Rule:
    name: str
    premises: frozenset[str]
    conclusion: str


def closure(seeds, rules, deleted=frozenset()):
    known = set(seeds)
    changed = True
    while changed:
        changed = False
        for rule in rules:
            if rule.name not in deleted and rule.premises <= known and rule.conclusion not in known:
                known.add(rule.conclusion)
                changed = True
    return frozenset(known)


def _minimal(family):
    unique = set(map(frozenset, family))
    return frozenset(s for s in unique if not any(t < s for t in unique))


def minimal_supports(seeds, rules):
    """Minimal rule-name sets deriving each fact; fixed point handles cycles."""
    supports = {seed: frozenset({frozenset()}) for seed in seeds}
    changed = True
    while changed:
        changed = False
        for rule in rules:
            if not all(p in supports for p in rule.premises):
                continue
            products = [frozenset()]
            for premise in rule.premises:
                products = [left | right for left in products for right in supports[premise]]
            candidates = [support | {rule.name} for support in products]
            revised = _minimal(tuple(supports.get(rule.conclusion, ())) + tuple(candidates))
            if revised != supports.get(rule.conclusion):
                supports[rule.conclusion] = revised
                changed = True
    return supports


def survivors_from_supports(supports, deleted):
    deleted = frozenset(deleted)
    return frozenset(fact for fact, alternatives in supports.items()
                     if any(support.isdisjoint(deleted) for support in alternatives))

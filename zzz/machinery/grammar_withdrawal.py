"""Exact constructor-withdrawal optimization for generated witness forests."""

from dataclasses import dataclass
from typing import FrozenSet, Hashable, Mapping, Sequence

Node = Hashable
Rule = Hashable


@dataclass(frozen=True)
class Production:
    """One retained derivation of a semantic observation."""

    name: str
    observation: Hashable
    support: FrozenSet[Rule]


@dataclass(frozen=True)
class GrammarWithdrawalSolution:
    worst_invalidated_weight: int
    rule_loads: dict[Rule, int]
    production: dict[Node, Production]
    parent: dict[Node, Node]


def optimize_constructor_withdrawal(
    depth: Mapping[Node, int],
    successors: Mapping[Node, Sequence[Node]],
    seed_productions: Mapping[Node, Sequence[Production]],
    weights: Mapping[Node, int] | None = None,
) -> GrammarWithdrawalSolution:
    """Minimize worst invalidated chosen-proof mass after one rule withdrawal.

    Every nonseed inherits one exact production from a depth-one-lower
    successor.  Withdrawing a rule invalidates all nodes whose inherited
    production support contains it.  Enumeration is exact and exponential.
    """

    if not depth:
        raise ValueError("the witness DAG must be nonempty")
    if weights is None:
        weights = {u: 1 for u in depth}
    if set(weights) != set(depth):
        raise ValueError("weights must be specified exactly for all nodes")
    if any(not isinstance(w, int) or w < 0 for w in weights.values()):
        raise ValueError("weights must be nonnegative integers")

    nodes = sorted(depth, key=lambda u: (depth[u], repr(u)))
    rules: set[Rule] = set()
    for u in nodes:
        d = depth[u]
        if not isinstance(d, int) or d < 0:
            raise ValueError("depths must be nonnegative integers")
        if d == 0:
            choices = tuple(seed_productions.get(u, ()))
            if not choices:
                raise ValueError(f"seed {u!r} has no production")
            if successors.get(u, ()):
                raise ValueError(f"seed {u!r} must not have a successor")
            for production in choices:
                rules.update(production.support)
        else:
            if u in seed_productions:
                raise ValueError(f"positive-depth node {u!r} cannot be a seed")
            choices = tuple(successors.get(u, ()))
            if not choices:
                raise ValueError(f"nonseed {u!r} has no shortest successor")
            for v in choices:
                if v not in depth or depth[v] != d - 1:
                    raise ValueError(
                        f"edge {u!r}->{v!r} does not decrease depth by one"
                    )

    ordered_rules = sorted(rules, key=repr)
    best: GrammarWithdrawalSolution | None = None

    def visit(
        i: int,
        selected: dict[Node, Production],
        parents: dict[Node, Node],
    ) -> None:
        nonlocal best
        if i == len(nodes):
            loads = {rule: 0 for rule in ordered_rules}
            for u, production in selected.items():
                for rule in production.support:
                    loads[rule] += weights[u]
            worst = max(loads.values(), default=0)
            candidate = GrammarWithdrawalSolution(
                worst, loads, dict(selected), dict(parents)
            )
            key = (
                worst,
                tuple(loads[r] for r in ordered_rules),
                tuple(selected[u].name for u in nodes),
            )
            if best is None:
                best = candidate
            else:
                old_key = (
                    best.worst_invalidated_weight,
                    tuple(best.rule_loads[r] for r in ordered_rules),
                    tuple(best.production[u].name for u in nodes),
                )
                if key < old_key:
                    best = candidate
            return

        u = nodes[i]
        if depth[u] == 0:
            options = [(p, None) for p in seed_productions[u]]
        else:
            first_parent: dict[Production, Node] = {}
            for v in successors[u]:
                first_parent.setdefault(selected[v], v)
            options = sorted(first_parent.items(), key=lambda item: item[0].name)

        for production, parent in options:
            selected[u] = production
            if parent is not None:
                parents[u] = parent
            visit(i + 1, selected, parents)
            selected.pop(u)
            parents.pop(u, None)

    visit(0, {}, {})
    assert best is not None
    return best


def invalidated_nodes(
    solution: GrammarWithdrawalSolution, rule: Rule
) -> frozenset[Node]:
    """Replay the exact chosen-certificate damage of withdrawing ``rule``."""

    return frozenset(
        u for u, production in solution.production.items() if rule in production.support
    )

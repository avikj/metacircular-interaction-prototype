"""Exact optimization of single-observation withdrawal in witness forests.

The input is the shortest-path DAG produced by reverse BFS.  Every nonseed
must choose one edge to a node one layer nearer a seed; every seed chooses one
observation which it immediately distinguishes.  A certificate inherits the
observation at the root reached by its chosen pointers.

This module is deliberately finite and exhaustive.  It is a replay kernel for
the exact objective, not a claim of a polynomial-time algorithm.
"""

from dataclasses import dataclass
from itertools import product
from typing import Hashable, Mapping, Sequence

Node = Hashable
Label = Hashable


@dataclass(frozen=True)
class WithdrawalSolution:
    worst_invalidated_weight: int
    loads: dict[Label, int]
    root_label: dict[Node, Label]
    parent: dict[Node, Node]


def _validate(
    depth: Mapping[Node, int],
    successors: Mapping[Node, Sequence[Node]],
    seed_labels: Mapping[Node, Sequence[Label]],
    weights: Mapping[Node, int],
) -> tuple[list[Node], list[Label]]:
    if not depth:
        raise ValueError("the witness DAG must be nonempty")
    if set(weights) != set(depth):
        raise ValueError("weights must be specified exactly for all nodes")
    if any(not isinstance(w, int) or w < 0 for w in weights.values()):
        raise ValueError("weights must be nonnegative integers")

    nodes = sorted(depth, key=lambda u: (depth[u], repr(u)))
    labels: set[Label] = set()
    for u in nodes:
        d = depth[u]
        if not isinstance(d, int) or d < 0:
            raise ValueError("depths must be nonnegative integers")
        if d == 0:
            choices = tuple(seed_labels.get(u, ()))
            if not choices:
                raise ValueError(f"depth-zero node {u!r} has no root label")
            if successors.get(u, ()):
                raise ValueError(f"seed {u!r} must not have a successor")
            labels.update(choices)
        else:
            if u in seed_labels:
                raise ValueError(f"positive-depth node {u!r} cannot be a seed")
            choices = tuple(successors.get(u, ()))
            if not choices:
                raise ValueError(f"nonseed {u!r} has no shortest successor")
            for v in choices:
                if v not in depth or depth[v] != d - 1:
                    raise ValueError(
                        f"edge {u!r}->{v!r} does not decrease depth by one"
                    )
    return nodes, sorted(labels, key=repr)


def optimize_withdrawal(
    depth: Mapping[Node, int],
    successors: Mapping[Node, Sequence[Node]],
    seed_labels: Mapping[Node, Sequence[Label]],
    weights: Mapping[Node, int] | None = None,
) -> WithdrawalSolution:
    """Minimize the maximum invalidated weight after one label withdrawal.

    Exhaustively enumerates precisely the feasible root-colorings

        seed color in its allowed labels;
        nonseed color = the color of at least one shortest successor.

    A matching successor is retained as the replay pointer.  Thus the search
    is over certificate semantics rather than over duplicate parent choices.
    """

    if weights is None:
        weights = {u: 1 for u in depth}
    nodes, labels = _validate(depth, successors, seed_labels, weights)
    best: WithdrawalSolution | None = None

    def visit(i: int, colors: dict[Node, Label], parents: dict[Node, Node]) -> None:
        nonlocal best
        if i == len(nodes):
            loads = {label: 0 for label in labels}
            for u, label in colors.items():
                loads[label] += weights[u]
            worst = max(loads.values(), default=0)
            candidate = WithdrawalSolution(worst, loads, dict(colors), dict(parents))
            key = (worst, tuple(loads[x] for x in labels), tuple(repr(colors[u]) for u in nodes))
            if best is None:
                best = candidate
            else:
                old_key = (
                    best.worst_invalidated_weight,
                    tuple(best.loads[x] for x in labels),
                    tuple(repr(best.root_label[u]) for u in nodes),
                )
                if key < old_key:
                    best = candidate
            return

        u = nodes[i]
        if depth[u] == 0:
            options = [(label, None) for label in seed_labels[u]]
        else:
            # Parent identity matters for replay, but parents of the same color
            # are semantically identical for the withdrawal objective.
            first_parent: dict[Label, Node] = {}
            for v in successors[u]:
                first_parent.setdefault(colors[v], v)
            options = sorted(first_parent.items(), key=lambda item: repr(item[0]))

        for label, parent in options:
            colors[u] = label
            if parent is not None:
                parents[u] = parent
            visit(i + 1, colors, parents)
            colors.pop(u)
            parents.pop(u, None)

    visit(0, {}, {})
    assert best is not None
    return best


def independent_reachability_lower_bound(
    depth: Mapping[Node, int],
    successors: Mapping[Node, Sequence[Node]],
    seed_labels: Mapping[Node, Sequence[Label]],
    weights: Mapping[Node, int] | None = None,
) -> int:
    """False-model lower bound obtained by coloring nodes independently.

    Each node may use any label reachable by a shortest path, without requiring
    shared suffix nodes to make one globally consistent choice.  The result is
    a valid lower bound and a deliberately known-false relaxation.
    """

    if weights is None:
        weights = {u: 1 for u in depth}
    nodes, labels = _validate(depth, successors, seed_labels, weights)
    reachable: dict[Node, set[Label]] = {}
    for u in nodes:
        if depth[u] == 0:
            reachable[u] = set(seed_labels[u])
        else:
            reachable[u] = set().union(*(reachable[v] for v in successors[u]))

    best: int | None = None
    for assignment in product(*(sorted(reachable[u], key=repr) for u in nodes)):
        loads = {label: 0 for label in labels}
        for u, label in zip(nodes, assignment):
            loads[label] += weights[u]
        score = max(loads.values(), default=0)
        best = score if best is None else min(best, score)
    assert best is not None
    return best


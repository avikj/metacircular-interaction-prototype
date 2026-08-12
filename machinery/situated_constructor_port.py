#!/usr/bin/env python3
"""A live port trivializes a constructor torsor without canonizing it.

This is a three-point executable theorem.  Learned scores may order lawful
candidates, but endpoint and port equations alone certify selection.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import permutations
from typing import Mapping

Permutation = tuple[int, ...]


def compose(p: Permutation, q: Permutation) -> Permutation:
    """Return p after q."""
    return tuple(p[q[i]] for i in range(len(p)))


def identity(n: int) -> Permutation:
    return tuple(range(n))


def transporter(n: int, source: int, target: int) -> tuple[Permutation, ...]:
    """All constructors carrying source to target."""
    return tuple(p for p in permutations(range(n)) if p[source] == target)


def target_stabilizer(n: int, target: int) -> tuple[Permutation, ...]:
    return tuple(p for p in permutations(range(n)) if p[target] == target)


def powers(generator: Permutation) -> tuple[Permutation, ...]:
    """The cyclic action grammar installed by one primitive."""
    out: list[Permutation] = []
    cursor = identity(len(generator))
    while cursor not in out:
        out.append(cursor)
        cursor = compose(generator, cursor)
    return tuple(out)


def proposal_order(
    candidates: tuple[Permutation, ...], scores: Mapping[Permutation, float]
) -> tuple[Permutation, ...]:
    """Continuous/model scores order proposals but certify nothing."""
    return tuple(sorted(candidates, key=lambda g: (-scores.get(g, 0.0), g)))


@dataclass(frozen=True)
class Port:
    """A presently supplied relation, including its causal provenance."""

    context: int
    response: int
    provenance: str


@dataclass(frozen=True)
class SelectionCertificate:
    source: int
    target: int
    port: Port
    selected: Permutation
    lawful_candidates: tuple[Permutation, ...]

    def verifies(self) -> bool:
        matching = tuple(
            g
            for g in self.lawful_candidates
            if g[self.source] == self.target
            and g[self.port.context] == self.port.response
        )
        return matching == (self.selected,)


def select_with_port(
    n: int,
    source: int,
    target: int,
    port: Port,
    scores: Mapping[Permutation, float] | None = None,
) -> SelectionCertificate:
    """Select by exact coupling; scores affect search order, never validity."""
    lawful = transporter(n, source, target)
    ordered = proposal_order(lawful, scores or {})
    matching = tuple(g for g in ordered if g[port.context] == port.response)
    if len(matching) != 1:
        raise ValueError("the declared port does not uniquely trivialize the transporter")
    cert = SelectionCertificate(source, target, port, matching[0], lawful)
    if not cert.verifies():
        raise AssertionError("internal certificate failure")
    return cert


def future_trace(generator: Permutation, point: int) -> tuple[int, ...]:
    """Responses available after the selected constructor becomes primitive."""
    return tuple(g[point] for g in powers(generator))


def three_point_world() -> dict[str, object]:
    """Return the complete smallest witness used by the theorem note."""
    n, source, target, context = 3, 0, 1, 2
    lawful = transporter(n, source, target)
    by_response = {
        response: select_with_port(
            n, source, target, Port(context, response, "live-environment")
        )
        for response in (0, 2)
    }
    return {
        "lawful": lawful,
        "stabilizer": target_stabilizer(n, target),
        "certificates": by_response,
        "grammar_orders": {
            response: len(powers(cert.selected))
            for response, cert in by_response.items()
        },
        "future_traces": {
            response: future_trace(cert.selected, source)
            for response, cert in by_response.items()
        },
    }


if __name__ == "__main__":
    world = three_point_world()
    for response, cert in world["certificates"].items():
        print(
            f"port response {response}: constructor={cert.selected}, "
            f"grammar order={world['grammar_orders'][response]}, "
            f"future trace={world['future_traces'][response]}"
        )
    print(f"port withdrawn: lawful transporter={world['lawful']}")

#!/usr/bin/env python3
"""Relativized initiality, executable: quotient, excluded task, charge bit.

Finite slice of notes/TWO_IDENTITIES.md section 2. The generated object is
the pointed unary algebra T = (Z/6, s=+1, base 0), initial among pointed
unary algebras satisfying s^6(q0) = q0 (h(k) = s^k(q0) is the unique
homomorphism). A probe family induces the greatest congruence inside its
kernel; quotienting by it keeps T initial exactly in the models validating
the congruence, and admits no homomorphism outside them. The excluded
models are recovered by adjoining the minimal charge carrier (CRT).
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Callable, Optional


@dataclass(frozen=True)
class Model:
    """Pointed unary algebra (Q, s, q0) with Q = range(size)."""

    size: int
    step: tuple[int, ...]
    base: int

    def s(self, q: int) -> int:
        return self.step[q]

    def iterate(self, k: int) -> int:
        q = self.base
        for _ in range(k):
            q = self.step[q]
        return q


def term_model(order: int) -> Model:
    return Model(order, tuple((i + 1) % order for i in range(order)), 0)


T6 = term_model(6)


def admits_unique_map(model: Model, order: int = 6) -> bool:
    """T_order is initial exactly among models with s^order(q0) = q0."""
    return model.iterate(order) == model.base


def canonical_map(model: Model, order: int = 6) -> Optional[tuple[int, ...]]:
    """The unique homomorphism h(k) = s^k(q0), if well defined."""
    if not admits_unique_map(model, order):
        return None
    return tuple(model.iterate(k) for k in range(order))


def observational_congruence(order: int, probe: Callable[[int], int]) -> list[int]:
    """Greatest congruence of (Z/order, +1) inside ker(probe), by refinement.

    Returns block labels; contexts for the single unary op are its iterates,
    so refinement is: split until probe agrees on every forward iterate.
    """
    labels = [probe(x) for x in range(order)]
    while True:
        signature = [(labels[x], labels[(x + 1) % order]) for x in range(order)]
        canon: dict[tuple[int, int], int] = {}
        fresh = []
        for sig in signature:
            if sig not in canon:
                canon[sig] = len(canon)
            fresh.append(canon[sig])
        if fresh == labels:
            return labels
        labels = fresh


def quotient_model(order: int, labels: list[int]) -> tuple[Model, tuple[int, ...]]:
    """Quotient of (Z/order, +1, 0) by a congruence given as block labels."""
    blocks = sorted(set(labels))
    index = {b: i for i, b in enumerate(blocks)}
    proj = tuple(index[labels[x]] for x in range(order))
    step = [0] * len(blocks)
    for x in range(order):
        step[proj[x]] = proj[(x + 1) % order]
    return Model(len(blocks), tuple(step), proj[0]), proj


def factors_through(model: Model, proj: tuple[int, ...], order: int = 6) -> bool:
    """ker(h_model) contains the congruence iff h is constant on blocks."""
    h = canonical_map(model, order)
    if h is None:
        return False
    seen: dict[int, int] = {}
    for k in range(order):
        block = proj[k]
        if block in seen and seen[block] != h[k]:
            return False
        seen[block] = h[k]
    return True


def homomorphisms(src: Model, dst: Model) -> list[tuple[int, ...]]:
    """All pointed unary-algebra homomorphisms src -> dst, by enumeration."""
    found = []
    for g in product(range(dst.size), repeat=src.size):
        if g[src.base] != dst.base:
            continue
        if all(g[src.s(q)] == dst.s(g[q]) for q in range(src.size)):
            found.append(g)
    return found


def word_equivalence_cost(model: Model, k1: int, k2: int) -> tuple[bool, int]:
    """Decide s^k1(q0) = s^k2(q0), charging one step per iteration visited."""
    steps = 0
    q1 = model.base
    for _ in range(k1):
        q1 = model.s(q1)
        steps += 1
    q2 = model.base
    for _ in range(k2):
        q2 = model.s(q2)
        steps += 1
    return q1 == q2, steps + model.size  # scan of the state table is charged


def charge_completion(quot: Model, charge: Model) -> Model:
    """Product carrier: the minimal re-adjoined action recovering exclusions."""
    size = quot.size * charge.size
    step = [0] * size
    for a in range(quot.size):
        for b in range(charge.size):
            step[a * charge.size + b] = quot.s(a) * charge.size + charge.s(b)
    return Model(size, tuple(step), quot.base * charge.size + charge.base)


def isomorphic_to_term(model: Model, order: int) -> bool:
    """Executable CRT check: model is one reachable cycle of length `order`."""
    seen = []
    q = model.base
    for _ in range(order):
        if q in seen:
            return False
        seen.append(q)
        q = model.s(q)
    return q == model.base and len(set(seen)) == order

#!/usr/bin/env python3
"""Exact finite witnesses for (limit X)/G -> limit (X/G)."""

from __future__ import annotations

from itertools import product


def orbits(carrier, actions):
    remaining = set(carrier)
    out = []
    while remaining:
        x = min(remaining)
        orbit = frozenset(action[x] for action in actions)
        out.append(orbit)
        remaining -= orbit
    return tuple(out)


def product_noninjective():
    # C2 acts regularly on both factors; the limit of X -> * <- Y is X x Y.
    bits = (0, 1)
    actions = ({0: 0, 1: 1}, {0: 1, 1: 0})
    pairs = tuple(product(bits, repeat=2))
    pair_actions = tuple(
        {p: (a[p[0]], a[p[1]]) for p in pairs} for a in actions
    )
    source = orbits(pairs, pair_actions)
    local = orbits(bits, actions)
    assert len(source) == 2
    assert source == (frozenset({(0, 0), (1, 1)}),
                      frozenset({(0, 1), (1, 0)}))
    assert len(local) == 1
    # Both distinct global diagonal orbits have the same pair of local orbits.
    comparison = tuple((local[0], local[0]) for _ in source)
    assert comparison[0] == comparison[1]
    return source, comparison


def equalizer_nonsurjective():
    # On the regular C2-set, id and flip are equivariant and have no equalizer.
    bits = (0, 1)
    identity = {0: 0, 1: 1}
    flip = {0: 1, 1: 0}
    raw_equalizer = tuple(x for x in bits if identity[x] == flip[x])
    assert raw_equalizer == ()
    # The orbit quotient is a singleton, so the induced maps are equal there.
    actions = (identity, flip)
    quotient = orbits(bits, actions)
    quotient_equalizer = quotient
    assert len(quotient_equalizer) == 1
    return raw_equalizer, quotient_equalizer


def tree_lift(root_value, orbit_choices, edges, maps):
    """Lift orbit choices along a rooted outward tree by unique propagation."""
    values = {0: root_value}
    for source, target in edges:
        assert source in values and target not in values
        value = maps[(source, target)][values[source]]
        assert value in orbit_choices[target]
        values[target] = value
    return values


def tree_positive_control():
    bits = (0, 1)
    whole = frozenset(bits)
    # 0 -> 1 -> 2, with flip then identity. Quotient choices are singleton
    # orbits, but propagation still returns a genuine compatible family.
    edges = ((0, 1), (1, 2))
    maps = {
        (0, 1): {0: 1, 1: 0},
        (1, 2): {0: 0, 1: 1},
    }
    values = tree_lift(0, {0: whole, 1: whole, 2: whole}, edges, maps)
    assert values == {0: 0, 1: 1, 2: 1}
    assert all(maps[e][values[e[0]]] == values[e[1]] for e in edges)
    return values


def main():
    print({"noninjective": product_noninjective(),
           "nonsurjective": equalizer_nonsurjective(),
           "tree_control": tree_positive_control()})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

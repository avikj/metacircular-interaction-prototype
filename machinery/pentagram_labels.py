#!/usr/bin/env python3
"""The pentagram's memory automaton, labelled by cliques in `K_5`.

`notes/RANK_THREE_MEMORY.md` §2 computed that the Mermin pentagram's
sequential-measurement process has `200 = 25 * 8` memory states, reaching `25`
of the `135` Lagrangians of `F_2^6`, and left `25` as an honest residue:
computed, not derived.  This module derives it.

The pentagram's incidence structure is the complete graph `K_5`: its five
contexts are the **vertices**, its ten observables are the **edges** (each
observable lies on exactly two contexts, each pair of contexts meets in exactly
one observable).  The reachable Lagrangians are then canonically labelled by
the cliques of size `1, 2, 3`:

    |S| = 1  <->  the 5 context Lagrangians   (4 observables each)
    |S| = 2  <->  10 edge Lagrangians         (1 observable each)
    |S| = 3  <->  10 triangle Lagrangians     (3 observables each)

so `25 = 5 + 10 + 10` and memory `= 25 * 2^3 = 200`.

Everything is exact and verified over the whole finite transition relation.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations
from typing import Dict, FrozenSet, List, Tuple

import machinery.pauli_context_memory as pcm
from machinery.rank_three_scenarios import PENTAGRAM, PENTAGRAM_LINES, pentagram_memory

ZERO = ((0, 0, 0), (0, 0, 0))
VERTICES = frozenset(range(5))

_NAME = {pcm.pauli(w): w for w in PENTAGRAM}
_POINTS = set(_NAME)
_LINES = [set(line) for line in PENTAGRAM_LINES]


def incidence() -> Dict[str, FrozenSet[int]]:
    """Each observable, as the pair of contexts carrying it: the `K_5` edge map."""
    out = {w: frozenset(i for i, line in enumerate(_LINES) if w in line) for w in PENTAGRAM}
    assert all(len(e) == 2 for e in out.values()), "each observable lies on two contexts"
    assert len(set(out.values())) == 10, "the ten observables are ten distinct edges"
    assert all(
        len(_LINES[i] & _LINES[j]) == 1 for i in range(5) for j in range(i + 1, 5)
    ), "each pair of contexts meets in exactly one observable"
    return out


EDGE = incidence()


def label(state) -> FrozenSet[int]:
    """The `K_5` clique labelling a reachable memory state.

    Determined by which pentagram observables the state's Lagrangian holds:
    four means a context (its vertex), three means a triangle (their three
    vertices), one means an edge (that observable's two vertices).
    """
    lagrangian = frozenset(v for _, v in state if v != ZERO)
    words = [_NAME[w] for w in lagrangian & _POINTS]
    if len(words) == 4:
        return frozenset(i for i, line in enumerate(_LINES) if all(w in line for w in words))
    if len(words) == 3:
        return frozenset().union(*[EDGE[w] for w in words])
    if len(words) == 1:
        return EDGE[words[0]]
    raise ValueError(f"unexpected overlap {len(words)}")


def successor(S: FrozenSet[int], e: FrozenSet[int]) -> FrozenSet[int]:
    """The label rule, as a closed formula on cliques.

    Measuring the observable with edge `e` from the state labelled `S`:

      * comparable (`e <= S` for `|S| >= 2`, or `S <= e` for `|S| = 1`):
        the observable is already in the Lagrangian, so nothing moves;
      * otherwise if `S | e` is still a clique of size `<= 3`, the label grows
        to `S | e`;
      * otherwise the label collapses, and how it collapses is exactly what
        the ambient symplectic geometry decides: for `|S| = 2` to `e` together
        with the one remaining vertex, and for `|S| = 3` to `S & e` -- the
        single shared vertex when the edge meets the triangle, and to `e`
        itself when it misses the triangle entirely.
    """
    if (len(S) >= 2 and e <= S) or (len(S) == 1 and S <= e):
        return S
    if len(S | e) <= 3:
        return S | e
    if len(S) == 2:
        return e | (VERTICES - (S | e))
    return S & e if S & e else e


def verify() -> dict:
    """Check the labelling and the rule against the entire transition relation."""
    states, lagrangians, _ = pentagram_memory()
    labels = {s: label(s) for s in states}
    sizes = Counter(len(v) for v in set(labels.values()))

    checked = 0
    for s in states:
        S = labels[s]
        for word in PENTAGRAM:
            outcomes = pcm.measure(s, pcm.pauli(word), 3)
            e = EDGE[word]
            comparable = (len(S) >= 2 and e <= S) or (len(S) == 1 and S <= e)
            assert (len(outcomes) == 1) == comparable, (
                "measurement is deterministic exactly when the label is comparable"
            )
            for _, _, t in outcomes:
                assert labels[t] == successor(S, e), (sorted(S), sorted(e))
                checked += 1

    return {
        "memory_states": len(states),
        "reachable_lagrangians": len(lagrangians),
        "distinct_labels": len(set(labels.values())),
        "labels_by_size": dict(sorted(sizes.items())),
        "cliques_by_size": {
            k: len(list(combinations(range(5), k))) for k in (1, 2, 3)
        },
        "transitions_checked": checked,
    }


def main() -> None:
    print("The pentagram's incidence structure is K_5:")
    print(f"    contexts (vertices)   {len(_LINES)}")
    print(f"    observables (edges)   {len(PENTAGRAM)}")
    print()
    report = verify()
    for key, value in report.items():
        print(f"    {key:24s} {value}")
    print()
    print("    25 = 5 vertices + 10 edges + 10 triangles;  memory = 25 * 2^3 = 200")


if __name__ == "__main__":
    main()

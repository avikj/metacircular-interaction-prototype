#!/usr/bin/env python3
"""Closure as triangle-freeness of the incidence graph.

`notes/RANK_THREE_MEMORY.md` §7 left two things verified but not derived: the
bound `|S| <= 3` on the pentagram's memory labels, and why the Mermin square is
closed while the pentagram is not.  Both follow from one lemma about the
*incidence graph*.

A scenario is **edge-type** when

  (E1) every observable lies on exactly two contexts, and
  (E2) two observables commute exactly when their contexts meet.

Then, writing `G` for the incidence graph (vertices = contexts, edges =
observables), the commutation graph of the scenario is the *line graph* of `G`,
and a pairwise-commuting set of observables is an intersecting family of edges.
By the classical classification, a maximal intersecting family of edges in a
graph is a **star** (all edges at one vertex) or a **triangle**.  So the memory
label -- the vertex set of that family -- has size `1` or `3`, and

    `G` triangle-free  ==>  every label has size one  ==>  closure.

The Mermin square has `G = K_{3,3}`, bipartite hence triangle-free: closed.
The Mermin pentagram has `G = K_5`, with ten triangles: not closed, and its
memory labels are exactly the `5 + 10 + 10` cliques of `K_5`.

Scope: (E1) and (E2) are genuine hypotheses.  The full Pauli set fails (E1)
badly, and the rank-three quadric fails it too -- `main()` reports both.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations
from typing import Dict, FrozenSet, List, Sequence, Tuple

import machinery.pauli_context_memory as pcm


def incidence(observables: Sequence, contexts: Sequence[FrozenSet], n: int) -> Dict:
    """The incidence graph and whether the scenario is edge-type."""
    on = {w: frozenset(i for i, L in enumerate(contexts) if w in L) for w in observables}
    e1 = all(len(v) == 2 for v in on.values())
    e2 = all(
        bool(on[u] & on[v]) == pcm.commute(u, v)
        for u, v in combinations(observables, 2)
    )
    return {"on": on, "E1": e1, "E2": e2, "edge_type": e1 and e2}


def maximal_commuting(observables: Sequence, n: int) -> List[FrozenSet]:
    """Maximal pairwise-commuting subsets, by direct enumeration."""
    families = []
    for k in range(1, len(observables) + 1):
        for S in combinations(observables, k):
            if all(pcm.commute(a, b) for a, b in combinations(S, 2)):
                families.append(frozenset(S))
        if not families:
            break
    return [S for S in families if not any(S < T for T in families)]


def stars_and_triangles(on: Dict, vertices: int) -> Dict[str, int]:
    """Classify maximal intersecting families of the incidence graph's edges."""
    edges = set(on.values())
    stars = sum(1 for v in range(vertices) if sum(1 for e in edges if v in e) >= 2)
    triangles = sum(
        1
        for t in combinations(range(vertices), 3)
        if all(frozenset(p) in edges for p in combinations(t, 2))
    )
    return {"stars": stars, "triangles": triangles}


def analyse(name: str, observables: Sequence, n: int) -> dict:
    contexts = pcm.lagrangians(observables, n)
    inc = incidence(observables, contexts, n)
    report = {
        "name": name,
        "qubits": n,
        "observables": len(observables),
        "contexts": len(contexts),
        "E1_each_observable_on_two_contexts": inc["E1"],
        "E2_commute_iff_contexts_meet": inc["E2"],
        "edge_type": inc["edge_type"],
    }
    if inc["edge_type"]:
        maximal = maximal_commuting(observables, n)
        report["maximal_commuting_sizes"] = dict(
            sorted(Counter(len(S) for S in maximal).items())
        )
        report.update(stars_and_triangles(inc["on"], len(contexts)))
        report["triangle_free"] = report["triangles"] == 0
        report["closure_predicted"] = report["triangle_free"]
        report["closure_observed"] = pcm.pure_memory(observables, n) == len(contexts) * 2 ** n
    return report


def pentagram_observables():
    from machinery.rank_three_scenarios import PENTAGRAM

    return [pcm.pauli(w) for w in PENTAGRAM]


def pentagram_contexts():
    from machinery.rank_three_scenarios import PENTAGRAM_LINES

    return [frozenset(pcm.pauli(w) for w in line) for line in PENTAGRAM_LINES]


def pentagram_report() -> dict:
    """The pentagram's contexts are not Lagrangians, so they are supplied."""
    obs = pentagram_observables()
    ctx = pentagram_contexts()
    inc = incidence(obs, ctx, 3)
    maximal = maximal_commuting(obs, 3)
    out = {
        "name": "Mermin pentagram",
        "observables": len(obs),
        "contexts": len(ctx),
        "E1_each_observable_on_two_contexts": inc["E1"],
        "E2_commute_iff_contexts_meet": inc["E2"],
        "edge_type": inc["edge_type"],
        "maximal_commuting_sizes": dict(sorted(Counter(len(S) for S in maximal).items())),
    }
    out.update(stars_and_triangles(inc["on"], len(ctx)))
    out["triangle_free"] = out["triangles"] == 0
    out["closure_predicted"] = out["triangle_free"]
    # the pentagram's contexts are not Lagrangians, so `pure_memory`'s start
    # heuristic would begin from a rank-one mixed state; use the explicit
    # pure preparation of `rank_three_scenarios` instead
    from machinery.rank_three_scenarios import pentagram_memory

    states, _, _ = pentagram_memory()
    out["memory"] = len(states)
    out["closure_observed"] = out["memory"] == len(ctx) * 2 ** 3
    return out


def context_lagrangian(context, n):
    """The Lagrangian generated by a context's observables."""
    gens, span = [], {pcm.identity(n)}
    for v in sorted(context):
        if any(v == w for _, w in span):
            continue
        gens.append((1, v))
        span = set(pcm.generate(gens, n))
    return {v for _, v in span}


def nondegenerate_triangles(observables, contexts, n) -> Dict:
    """Necessity's hypothesis, checked triangle by triangle.

    A triangle `{u,v,w}` is *non-degenerate at `u`* when the opposite edge
    `e_vw` does not already lie in the Lagrangian generated by context `u`.
    Only then is measuring `e_vw` from that context nondeterministic, and only
    then does Theorem 8.4's escape argument run.
    """
    on = incidence(observables, contexts, n)["on"]
    by_edge = {e: w for w, e in on.items()}
    lagr = [context_lagrangian(C, n) for C in contexts]
    triangles = [
        t for t in combinations(range(len(contexts)), 3)
        if all(frozenset(p) in by_edge for p in combinations(t, 2))
    ]
    degenerate = [
        (t, u)
        for t in triangles
        for u in t
        if by_edge[frozenset(set(t) - {u})] in lagr[u]
    ]
    return {
        "triangles": len(triangles),
        "vertex_checks": 3 * len(triangles),
        "degenerate": degenerate,
        "all_nondegenerate": not degenerate,
    }


def main() -> None:
    reports = [
        analyse("Mermin square", [pcm.pauli(w) for w in pcm.PERES_MERMIN], 2),
        pentagram_report(),
        analyse("all two-qubit Paulis", pcm.all_paulis(2), 2),
    ]
    for r in reports:
        print(r.pop("name"))
        for key, value in r.items():
            print(f"    {key:38s} {value}")
        print()
    nd = nondegenerate_triangles(pentagram_observables(), pentagram_contexts(), 3)
    print("pentagram triangle non-degeneracy (necessity's hypothesis)")
    for key, value in nd.items():
        print(f"    {key:38s} {value}")
    print()
    print("closure  <==>  the incidence graph is triangle-free")
    print("    square:    K_{3,3}, bipartite, 0 triangles -> closed, memory 6*4 = 24")
    print("    pentagram: K_5, 10 triangles              -> open,   memory 25*8 = 200")


if __name__ == "__main__":
    main()

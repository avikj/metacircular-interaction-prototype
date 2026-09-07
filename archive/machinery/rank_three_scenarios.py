#!/usr/bin/env python3
"""Rank-three tests of the memory formula: the quadric and the pentagram.

`notes/ARF_MERMIN_CLASSIFICATION.md` section 3 predicted, from the Arf
classification alone, that the three-qubit analogue of a Mermin square is a
`35`-observable, `30`-context scenario with memory `30 * 8 = 240`.  This module
runs that prediction, and runs the Mermin **pentagram** as the matching
negative control: its contexts are *not* full Lagrangians, so
`PAULI_MEMORY_LAGRANGIAN.md` Corollary 3.2 says the closure hypothesis must
fail there.

Both are exact finite computations over ``F_2``; see
``machinery/pauli_context_memory.py`` for the arithmetic.
"""

from __future__ import annotations

from collections import Counter
from itertools import product
from typing import Dict, List, Tuple

import machinery.pauli_context_memory as pcm

Flat6 = Tuple[int, int, int, int, int, int]

SPACE6: List[Flat6] = [v for v in product((0, 1), repeat=6)]


def symplectic6(a: Flat6, b: Flat6) -> int:
    return (
        sum(a[i] * b[i + 3] for i in range(3))
        + sum(b[i] * a[i + 3] for i in range(3))
    ) % 2


def base_quadratic6(a: Flat6) -> int:
    return sum(a[i] * a[i + 3] for i in range(3)) % 2


def to_symplectic(v: Flat6):
    """Flat 6-tuple to ``pauli_context_memory``'s ``((x1,x2,x3),(z1,z2,z3))``."""
    return ((v[0], v[1], v[2]), (v[3], v[4], v[5]))


def refinements6() -> List[Dict[Flat6, int]]:
    """All `2^6` quadratic refinements, each certified by the polarization identity."""
    out = []
    for lin in SPACE6:
        q = {
            a: (base_quadratic6(a) + sum(li * ai for li, ai in zip(lin, a))) % 2
            for a in SPACE6
        }
        for a in SPACE6:
            for b in SPACE6:
                s = tuple((p + r) % 2 for p, r in zip(a, b))
                assert (q[s] + q[a] + q[b]) % 2 == symplectic6(a, b)
        out.append(q)
    return out


def plus_type6() -> List[Dict[Flat6, int]]:
    """Plus-type forms: `2^5 + 2^2 - 1 = 35` nonzero singular vectors."""
    return [
        q for q in refinements6()
        if sum(1 for a in SPACE6 if any(a) and q[a] == 0) == 35
    ]


def quadric_scenario(q: Dict[Flat6, int]):
    return sorted(to_symplectic(a) for a in SPACE6 if any(a) and q[a] == 0)


# --------------------------------------------------------------------------
# the Mermin pentagram
# --------------------------------------------------------------------------

PENTAGRAM_LINES = [
    ["XII", "IXI", "IIX", "XXX"],
    ["XII", "IYI", "IIY", "XYY"],
    ["YII", "IXI", "IIY", "YXY"],
    ["YII", "IYI", "IIX", "YYX"],
    ["XXX", "XYY", "YXY", "YYX"],
]

PENTAGRAM = sorted({w for line in PENTAGRAM_LINES for w in line})


def line_signs() -> List[int]:
    """Exact product of each pentagram line; an odd number of `-I` is the anomaly."""
    signs = []
    for line in PENTAGRAM_LINES:
        acc = (1, pcm.pauli(line[0]))
        for word in line[1:]:
            acc = pcm.multiply(acc, (1, pcm.pauli(word)))
        sign, (x, z) = acc
        assert not any(x) and not any(z), "a pentagram line must multiply to +-I"
        signs.append(sign)
    return signs


def pentagram_memory():
    """Reachable memory from a pure preparation, plus the Lagrangian breakdown."""
    obs = [pcm.pauli(w) for w in PENTAGRAM]
    gens = [(1, pcm.pauli(w)) for w in ("XII", "IXI", "IIX")]
    states = pcm.reachable(pcm.generate(gens, 3), obs, 3)
    lagrangians = {frozenset(v for _, v in s) for s in states}
    overlap = Counter(len(L & set(obs)) for L in lagrangians)
    return states, lagrangians, dict(sorted(overlap.items()))


def main() -> None:
    print("=== rank-three quadric: the prediction of ARF_MERMIN_CLASSIFICATION section 3 ===")
    forms = refinements6()
    plus = plus_type6()
    print(f"    refinements                {len(forms)}   (predicted 2^6 = 64)")
    print(f"    plus type                  {len(plus)}   (predicted 2^5 + 2^2 = 36)")
    scenario = quadric_scenario(plus[0])
    contexts = pcm.lagrangians(scenario, 3)
    print(f"    observables                {len(scenario)}   (predicted 35)")
    print(f"    contexts                   {len(contexts)}   (predicted 30)")
    print(f"    memory                     {pcm.pure_memory(scenario, 3)}   (predicted 240)")
    print()

    print("=== Mermin pentagram: the closure hypothesis must fail ===")
    print(f"    line products              {line_signs()}")
    obs = [pcm.pauli(w) for w in PENTAGRAM]
    inside = pcm.lagrangians(obs, 3)
    print(f"    observables                {len(obs)}")
    print(f"    maximal isotropic subspaces inside the set: {len(inside)}, "
          f"sizes {sorted({len(L) for L in inside})}")
    states, lags, overlap = pentagram_memory()
    print(f"    memory                     {len(states)}")
    print(f"    reachable Lagrangians      {len(lags)}  x 2^n = {len(lags) * 8}")
    print(f"    pentagram observables per reachable Lagrangian: {overlap}")
    print(f"    predictive classes         {len(pcm.predictive_quotient(states, obs, 3))}")


if __name__ == "__main__":
    main()

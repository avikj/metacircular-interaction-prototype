#!/usr/bin/env python3
"""Shortest distinguishing measurement words between memory states.

The memory count of `notes/PAULI_MEMORY_LAGRANGIAN.md` is a **cardinality** --
a lumped statistic.  `notes/NO_PRIVILEGED_CHART.md` §5 warns that a lumped
statistic can equilibrate far sooner than the process it shadows, and that the
check separating object from observable is often never run.  This module runs
it here: it computes, for each pair of memory states, the length of the
shortest measurement sequence that tells them apart.

That length is an experimentally meaningful depth -- a number of measurements,
not a number of states -- and it is the coordinate the memory count forgets.

Method: exact Moore/Hopcroft partition refinement on the measurement-labelled
process, recording the round at which each pair first separates.  Round `k`
means a distinguishing word of length `k`.  Probabilities are `Fraction`s;
nothing is approximated.

**Forecast, registered before running** (see `notes/DISTINGUISHING_DEPTH.md`):
depth `1` for the Mermin square, credence `0.85`; depth `2` for the pentagram,
credence `0.7`, because its edge-label Lagrangians carry only one deterministic
observable among eight sign characters, so one measurement provably cannot
separate them.
"""

from __future__ import annotations

from collections import Counter
from fractions import Fraction
from typing import Dict, List, Sequence, Tuple

import machinery.pauli_context_memory as pcm


def signature(state, block: Dict, observables: Sequence, n: int) -> tuple:
    """One round of refinement data: outcome law and successor block per probe."""
    row = []
    for obs in observables:
        row.append(
            tuple(
                sorted(
                    (prob, outcome, block[succ])
                    for prob, outcome, succ in pcm.measure(state, obs, n)
                )
            )
        )
    return tuple(row)


def depths(states: Sequence, observables: Sequence, n: int) -> Dict:
    """Refine to the fixed point, recording each pair's separation round.

    Returns the per-round block counts, the round at which the partition
    stabilises, the maximum separation depth over all pairs, and the pairs
    attaining it.
    """
    block = {s: 0 for s in states}
    separated: Dict[Tuple, int] = {}
    rounds: List[int] = [1]
    depth = 0
    while True:
        depth += 1
        sig = {s: signature(s, block, observables, n) for s in states}
        labels = {v: i for i, v in enumerate(sorted(set(sig.values())))}
        new = {s: labels[sig[s]] for s in states}
        # a pair separates at this depth if it was together and now is not
        for i, s in enumerate(states):
            for t in states[i + 1 :]:
                key = (i, states.index(t))
                if key in separated:
                    continue
                if block[s] == block[t] and new[s] != new[t]:
                    separated[key] = depth
        rounds.append(len(set(new.values())))
        if len(set(new.values())) == len(set(block.values())) and depth > 1:
            break
        block = new
        if len(set(block.values())) == len(states):
            # already fully separated; one more round confirms stability
            sig = {s: signature(s, block, observables, n) for s in states}
            break

    unseparated = [
        (i, j)
        for i in range(len(states))
        for j in range(i + 1, len(states))
        if (i, j) not in separated
    ]
    return {
        "states": len(states),
        "blocks_by_round": rounds,
        "max_depth": max(separated.values()) if separated else 0,
        "depth_histogram": dict(sorted(Counter(separated.values()).items())),
        "pairs_separated": len(separated),
        "pairs_total": len(states) * (len(states) - 1) // 2,
        "unseparated_pairs": len(unseparated),
    }


def deepest_pairs(states: Sequence, observables: Sequence, n: int, depth: int):
    """The pairs that need a word of exactly `depth` measurements."""
    block = {s: 0 for s in states}
    out = []
    for d in range(1, depth + 1):
        sig = {s: signature(s, block, observables, n) for s in states}
        labels = {v: i for i, v in enumerate(sorted(set(sig.values())))}
        new = {s: labels[sig[s]] for s in states}
        if d == depth:
            for i, s in enumerate(states):
                for j in range(i + 1, len(states)):
                    t = states[j]
                    if block[s] == block[t] and new[s] != new[t]:
                        out.append((i, j))
        block = new
    return out


def square_states():
    obs = [pcm.pauli(w) for w in pcm.PERES_MERMIN]
    lags = pcm.lagrangians(obs, 2)
    gens, span = [], {pcm.identity(2)}
    for v in sorted(lags[0]):
        if any(v == w for _, w in span):
            continue
        gens.append((1, v))
        span = set(pcm.generate(gens, 2))
    return pcm.reachable(pcm.generate(gens, 2), obs, 2), obs, 2


def pentagram_states():
    from machinery.rank_three_scenarios import PENTAGRAM, pentagram_memory

    states, _, _ = pentagram_memory()
    return states, [pcm.pauli(w) for w in PENTAGRAM], 3


def qubit_states():
    obs = pcm.all_paulis(1)
    return pcm.reachable(frozenset({pcm.identity(1)}), obs, 1), obs, 1


def main() -> None:
    for name, loader in (
        ("one qubit (all 3 Paulis)", qubit_states),
        ("Mermin square", square_states),
        ("Mermin pentagram", pentagram_states),
    ):
        states, obs, n = loader()
        report = depths(states, obs, n)
        print(name)
        for key, value in report.items():
            print(f"    {key:22s} {value}")
        print()


if __name__ == "__main__":
    main()

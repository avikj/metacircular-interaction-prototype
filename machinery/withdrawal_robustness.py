r"""Minimizing worst-case proof invalidation: polynomial at depth one,
strongly NP-hard at depth two.

**Provenance.** codex-ananta closed 0248 (`WITNESS_FOREST_STORAGE_NO_GO`) with
an open question nobody took:

> optimize worst-case invalidated proofs under single-observation withdrawal
> while preserving shortest witness length.

Their setting: one canonical certificate node per split pair; seeds carry an
observation label; every non-seed stores one pointer to a candidate parent at
strictly smaller BFS distance. Storage is invariant under parent choice (their
no-go), but **the observation each certificate ultimately depends on is not** —
so parent choice is exactly a robustness knob. Withdrawing observation `n`
invalidates every node whose pointer chain roots at an `n`-seed.

Because every candidate sits at strictly smaller distance, shortest witness
length is preserved by construction, whatever is chosen. So the objective is
free to optimize:

```text
root(v)   = root(parent(v)),      root(seed) = its observation
load(n)   = #{ v : root(v) = n }
objective = minimize  max_n load(n).
```

**Answer, two-sided and sharp.**

- **Depth 1** — every non-seed points straight at a seed — is **polynomial**.
  Choices are then independent, so this is restricted-assignment makespan with
  unit jobs: binary search on the bound plus bipartite feasibility.
- **Depth exactly 2** is already **strongly NP-hard**, by reduction from
  3-PARTITION. So the boundary is one level of indirection, not an asymptotic.

The hardness is *not* caused by the number of observations, nor by forest
size. It is caused by **bundling**: once a node may point at a non-seed, one
pointer moves an indivisible subtree, and balancing indivisible loads is
packing.

**Two errors I made building this, both kept as tests.**

1. I first used **chains** of length `a_i` and then wrote the boundary as
   "depth one versus depth two". Chains have unbounded depth, so they prove
   hardness at *some* depth, not at depth two. `build_star` repairs it — same
   indivisible load, depth exactly two. `build_bundled` is kept as the more
   legible picture of bundling, explicitly marked as not carrying the claim.
2. I first checked the reduction on inputs violating `B/4 < a_i < B/2` and it
   reported "optimum small, but no 3-partition". The reduction was right and
   my inputs were not: without the side condition the gadget decides *equal-sum
   grouping*, which has no cardinality constraint and is strictly easier to
   satisfy. `satisfies_side_condition` now carries the hypothesis explicitly.

**Why 3-PARTITION and not PARTITION.** A load of `a_i` is `a_i` actual nodes,
so the construction writes its numbers in **unary**. From PARTITION — only
weakly NP-hard — the reduction would be exponential and prove nothing.
3-PARTITION is strongly NP-hard, so unary is legitimate.
"""

from __future__ import annotations

import itertools
from typing import Dict, List, Optional, Sequence, Set

Choice = Dict[str, str]


def roots(nodes: Sequence[str], seeds: Dict[str, str], choice: Choice) -> Dict[str, str]:
    """Observation each node's certificate ultimately depends on."""
    out: Dict[str, str] = {}

    def r(v: str) -> str:
        if v not in out:
            out[v] = seeds[v] if v in seeds else r(choice[v])
        return out[v]

    for v in nodes:
        r(v)
    return out


def loads(nodes: Sequence[str], seeds: Dict[str, str], choice: Choice) -> Dict[str, int]:
    L: Dict[str, int] = {}
    for n in roots(nodes, seeds, choice).values():
        L[n] = L.get(n, 0) + 1
    return L


def worst_case(nodes, seeds, choice) -> int:
    return max(loads(nodes, seeds, choice).values())


def optimum_bruteforce(nodes, seeds, cands) -> int:
    """Exact minimum of the worst case, over all parent choices."""
    free = [v for v in nodes if v not in seeds]
    best: Optional[int] = None
    for combo in itertools.product(*[cands[v] for v in free]):
        m = worst_case(nodes, seeds, dict(zip(free, combo)))
        best = m if best is None else min(best, m)
    return best if best is not None else max(loads(nodes, seeds, {}).values())


# ---------------------------------------------------------------- depth one


def is_depth_one(seeds: Dict[str, str], cands: Dict[str, List[str]]) -> bool:
    return all(all(c in seeds for c in cs) for cs in cands.values())


def _feasible(free, cands, seeds, base: Dict[str, int], T: int) -> bool:
    """Can every free node be assigned to an allowed seed within cap `T`?

    Unit jobs and restricted assignment: augmenting-path bipartite matching
    against seed capacities.
    """
    cap = {n: T - base.get(n, 0) for n in set(seeds.values())}
    if any(c < 0 for c in cap.values()):
        return False
    assigned: Dict[str, str] = {}
    used: Dict[str, int] = {n: 0 for n in cap}

    def augment(v: str, seen: Set[str]) -> bool:
        for c in cands[v]:
            n = seeds[c]
            if n in seen:
                continue
            seen.add(n)
            if used[n] < cap[n]:
                assigned[v] = c
                used[n] += 1
                return True
            for w, cw in list(assigned.items()):
                if seeds[cw] == n and augment(w, seen):
                    assigned[v] = c
                    return True
        return False

    for v in free:
        if not augment(v, set()):
            return False
    return True


def optimum_depth_one(nodes, seeds, cands) -> int:
    """Exact optimum when every candidate is a seed. Polynomial."""
    assert is_depth_one(seeds, cands), "not a depth-one instance"
    free = [v for v in nodes if v not in seeds]
    base: Dict[str, int] = {}
    for _, n in seeds.items():
        base[n] = base.get(n, 0) + 1
    lo, hi = max(base.values()), len(nodes)
    while lo < hi:
        mid = (lo + hi) // 2
        if _feasible(free, cands, seeds, base, mid):
            hi = mid
        else:
            lo = mid + 1
    return lo


# ------------------------------------------------------- the hard direction


def build_star(sizes: Sequence[int], n_obs: int):
    """The gadget the sharp claim rests on: **depth exactly two**.

    Each number `a_i` becomes a head, free to point at any seed, plus
    `a_i - 1` leaves whose only candidate is that head. One pointer choice
    moves an indivisible load of `a_i`, and nothing sits deeper than two.
    """
    nodes: List[str] = []
    seeds: Dict[str, str] = {}
    cands: Dict[str, List[str]] = {}
    for j in range(n_obs):
        z = f"z{j}"
        nodes.append(z)
        seeds[z] = f"n{j}"
    for i, a in enumerate(sizes):
        h = f"h{i}"
        nodes.append(h)
        cands[h] = [f"z{j}" for j in range(n_obs)]
        for t in range(a - 1):
            v = f"l{i}_{t}"
            nodes.append(v)
            cands[v] = [h]
    return nodes, seeds, cands


def build_bundled(chain_lengths: Sequence[int], n_obs: int):
    """Chains hanging off a free head — the legible picture of bundling.

    Kept for exposition only: it has **unbounded depth**, so it proves
    hardness at some depth rather than at depth two. `build_star` carries the
    sharp claim.
    """
    nodes: List[str] = []
    seeds: Dict[str, str] = {}
    cands: Dict[str, List[str]] = {}
    for j in range(n_obs):
        z = f"z{j}"
        nodes.append(z)
        seeds[z] = f"n{j}"
    for i, a in enumerate(chain_lengths):
        prev = None
        for t in range(a):
            v = f"c{i}_{t}"
            nodes.append(v)
            cands[v] = [f"z{j}" for j in range(n_obs)] if t == 0 else [prev]
            prev = v
    return nodes, seeds, cands


def satisfies_side_condition(sizes: Sequence[int], B: int) -> bool:
    """`B/4 < a_i < B/2` — what makes equal-sum grouping *be* 3-PARTITION.

    Without it the gadget still decides equal-sum grouping, which has no
    cardinality constraint and is strictly easier to satisfy.
    """
    return all(B / 4 < a < B / 2 for a in sizes) and sum(sizes) == B * (len(sizes) // 3)


def has_equal_sum_grouping(sizes: Sequence[int], m: int, B: int) -> bool:
    """Can `sizes` be split into `m` groups each summing to `B`?

    Under `satisfies_side_condition` this is exactly 3-PARTITION.
    """

    def rec(rem: List[int], groups: int) -> bool:
        if groups == 0:
            return not rem
        for r in range(1, len(rem) + 1):
            for combo in itertools.combinations(range(len(rem)), r):
                if sum(rem[i] for i in combo) == B:
                    left = [rem[i] for i in range(len(rem)) if i not in combo]
                    if rec(left, groups - 1):
                        return True
        return False

    return rec(list(sizes), m)


YES_INSTANCE = ([4, 4, 4, 4, 4, 4], 12)
NO_INSTANCE = ([4, 4, 4, 4, 4, 6], 13)
"""Genuine 3-PARTITION instances: both satisfy `B/4 < a_i < B/2`, so
equal-sum grouping and 3-PARTITION coincide on them."""


if __name__ == "__main__":
    print("== depth one is polynomial: flow optimum equals brute force")
    nodes = ["z0", "z1", "z2", "a", "b", "c", "d"]
    seeds = {"z0": "n0", "z1": "n1", "z2": "n2"}
    cands = {"a": ["z0", "z1"], "b": ["z0"], "c": ["z1", "z2"], "d": ["z0", "z2"]}
    print(f"   brute force {optimum_bruteforce(nodes, seeds, cands)}   "
          f"flow {optimum_depth_one(nodes, seeds, cands)}")

    print("\n== depth EXACTLY two is already hard (the sharp gadget)")
    for sizes, B in (YES_INSTANCE, NO_INSTANCE):
        m = len(sizes) // 3
        n, s, c = build_star(sizes, m)
        opt = optimum_bruteforce(n, s, c)
        print(f"   sizes {sizes}, B = {B}, side condition "
              f"{satisfies_side_condition(sizes, B)}: min-max = {opt}, "
              f"opt <= B+1 ? {opt <= B + 1}, "
              f"3-partition ? {has_equal_sum_grouping(sizes, m, B)}")

    print("\n== chains give the same optimum — depth was never what carried it")
    for sizes, B in (YES_INSTANCE, NO_INSTANCE):
        m = len(sizes) // 3
        print(f"   sizes {sizes}: star {optimum_bruteforce(*build_star(sizes, m))}"
              f"  chain {optimum_bruteforce(*build_bundled(sizes, m))}")

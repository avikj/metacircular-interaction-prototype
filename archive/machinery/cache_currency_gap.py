#!/usr/bin/env python3
"""Closure is what buys exactness, and here is the minimal witness that it is needed.

`ANCESTOR_CLOSED_CACHE_FORMATION` (codex-formation) proves that a *replayable
proof cache* -- ancestor-closed subsets of the construction trace -- makes the
saved-work function modular, `F(S) = sum_{u in S} W(u)`, so the top-`B` nodes by
subtree demand `W` are an exact optimum and greedy is exact rather than
`1 - 1/e`.  `CACHE_RETENTION_SUBMODULARITY` and `PREFIX_CACHE_SUBMODULARITY`
price the *value cache*, where `F` is submodular and the guarantee is only
`1 - 1/e`, with an exact tree DP supplied separately.

Both are correct -- I attacked all three and broke none.  What neither supplies
is the exhibit showing the two currencies genuinely differ: **an instance where
value-cache greedy is strictly suboptimal.**  Without it, "exactly greedy, not
merely `1-1/e`" is a statement about which theorem was proved, not about the
objects.

**The minimal witness.**  Root `1`, one intermediate `2`, three leaves `3,4,5`
all children of `2`.  Targets `4` and `5` at weight `8`, target `3` at weight
`2`.  Budget `B = 2`.

    F({2})    = 8*1 + 2*1 + 8*1 = 18     <- greedy's first pick
    F({2,4})  = 8*2 + 2*1 + 8*1 = 26     <- greedy's answer
    F({4,5})  = 8*2 + 2*0 + 8*2 = 32     <- the optimum

Greedy takes the shared prefix `2` because it serves all three targets, and is
then stuck: the deep nodes it still needs each subsume `2` on their own path, so
the first pick is wasted.  Ratio `26/32 = 0.8125`, comfortably above `1 - 1/e`,
which is why a bound alone could not have told the two currencies apart.

**Theorem L (what the currency change actually is).**  The set function is the
same in both cases.  On the Boolean lattice of all subsets it is monotone
submodular and **not** modular, and greedy is strictly suboptimal.  Restricted
to the distributive sublattice of ancestor-closed sets it becomes **modular**,
and there greedy is exact.  So the currency change is a restriction of the
feasible family, not a change of objective, and exactness is bought by the
sublattice.

*Proof of the modularity half is codex-formation's* (ancestor closure turns a
max over a path into a count, so `F(S) = sum_{u in S} W(u)`); the non-modularity
half is the witness above, since `F({2}) + F({4}) = 18 + 16 = 34 != 26 + 18 =
F({2,4}) + F({2} cap {4})`.
"""

from __future__ import annotations

from itertools import combinations

WITNESS_PARENT = {2: 1, 3: 2, 4: 2, 5: 2}
WITNESS_WEIGHTS = {4: 8, 3: 2, 5: 8}


def depth(parent: dict[int, int], node: int) -> int:
    steps = 0
    while node != 1:
        node = parent[node]
        steps += 1
    return steps


def path(parent: dict[int, int], target: int) -> set[int]:
    walk, node = set(), target
    while node != 1:
        walk.add(node)
        node = parent[node]
    return walk


def saved_work(cache, parent: dict[int, int], weights: dict[int, int]) -> int:
    """`F(S)`: weighted depth of the deepest retained node on each target's path."""
    total = 0
    for target, weight in weights.items():
        on_path = path(parent, target)
        total += weight * max([depth(parent, u) for u in cache if u in on_path],
                              default=0)
    return total


def greedy(nodes, parent, weights, budget: int) -> set[int]:
    chosen: set[int] = set()
    for _ in range(budget):
        chosen.add(max((u for u in nodes if u not in chosen),
                       key=lambda u: (saved_work(chosen | {u}, parent, weights), -u)))
    return chosen


def optimum(nodes, parent, weights, budget: int) -> set[int]:
    return max((set(c) for c in combinations(nodes, budget)),
               key=lambda S: saved_work(S, parent, weights))


def is_ancestor_closed(cache, parent: dict[int, int]) -> bool:
    return all(parent[u] == 1 or parent[u] in cache for u in cache)


def subtree_demand(node: int, parent: dict[int, int],
                   weights: dict[int, int]) -> int:
    """`W(u)` -- declared demand below `u`."""
    return sum(w for t, w in weights.items() if node in path(parent, t))


def modular_value(cache, parent, weights) -> int:
    return sum(subtree_demand(u, parent, weights) for u in cache)


def value_cache_gap(budget: int = 2) -> tuple[int, int]:
    """(greedy, optimum) on the witness -- strictly apart at budget 2."""
    nodes = list(WITNESS_PARENT)
    return (saved_work(greedy(nodes, WITNESS_PARENT, WITNESS_WEIGHTS, budget),
                       WITNESS_PARENT, WITNESS_WEIGHTS),
            saved_work(optimum(nodes, WITNESS_PARENT, WITNESS_WEIGHTS, budget),
                       WITNESS_PARENT, WITNESS_WEIGHTS))


def proof_cache_ranking(parent, weights) -> list[int]:
    """Top-`W` ranking, ancestors before descendants on ties."""
    return sorted(parent, key=lambda u: (-subtree_demand(u, parent, weights),
                                         depth(parent, u)))


def main() -> None:
    nodes = list(WITNESS_PARENT)
    print("Value cache: greedy is strictly suboptimal on a 5-node tree\n")
    print(f"  tree {WITNESS_PARENT}, weights {WITNESS_WEIGHTS}\n")
    for budget in (1, 2, 3):
        g = greedy(nodes, WITNESS_PARENT, WITNESS_WEIGHTS, budget)
        o = optimum(nodes, WITNESS_PARENT, WITNESS_WEIGHTS, budget)
        gv = saved_work(g, WITNESS_PARENT, WITNESS_WEIGHTS)
        ov = saved_work(o, WITNESS_PARENT, WITNESS_WEIGHTS)
        flag = "  <-- STRICTLY SUBOPTIMAL" if gv < ov else ""
        print(f"  B={budget}: greedy {sorted(g)} = {gv:3}"
              f"   optimum {sorted(o)} = {ov:3}{flag}")
    gv, ov = value_cache_gap()
    print(f"\n  ratio {gv}/{ov} = {gv/ov:.4f}, well above 1 - 1/e = 0.6321,")
    print("  so the (1-1/e) bound alone could not distinguish the currencies.")

    print("\nProof cache (ancestor-closed): F is modular and top-W is lawful\n")
    ranking = proof_cache_ranking(WITNESS_PARENT, WITNESS_WEIGHTS)
    for budget in (1, 2, 3, 4):
        cache = set(ranking[:budget])
        print(f"  B={budget}: top-W {sorted(cache)}"
              f"  closed={is_ancestor_closed(cache, WITNESS_PARENT)}"
              f"  F={saved_work(cache, WITNESS_PARENT, WITNESS_WEIGHTS):3}"
              f"  sum W={modular_value(cache, WITNESS_PARENT, WITNESS_WEIGHTS):3}")
    print("\n  same function, different feasible family: the sublattice is what")
    print("  linearizes, and the witness above shows it is doing real work.")


if __name__ == "__main__":
    main()

"""Exact future value and budget DP for retained prefixes in a rooted tree."""

from functools import lru_cache


def depths(parent):
    out = {None: -1}
    pending = set(parent)
    while pending:
        for v in tuple(pending):
            if parent[v] in out:
                out[v] = out[parent[v]] + 1
                pending.remove(v)
    out.pop(None)
    return out


def value(parent, weights, cache):
    depth = depths(parent)
    total = 0
    for target, weight in weights.items():
        v, best = target, 0
        while v is not None:
            if v in cache:
                best = max(best, depth[v])
            v = parent[v]
        total += weight * best
    return total


def optimal_value(parent, weights, budget):
    depth = depths(parent)
    children = {v: [] for v in parent}
    roots = []
    for v, p in parent.items():
        (roots if p is None else children[p]).append(v)
    assert len(roots) == 1

    @lru_cache(None)
    def solve(v, b, inherited):
        def distribute(kids, cap, ancestor):
            row = [0] + [-10**30] * cap
            for child in kids:
                nxt = [-10**30] * (cap + 1)
                for used in range(cap + 1):
                    for give in range(cap - used + 1):
                        nxt[used + give] = max(
                            nxt[used + give], row[used] + solve(child, give, ancestor)
                        )
                row = nxt
            return max(row)

        skip = weights.get(v, 0) * inherited + distribute(children[v], b, inherited)
        if b == 0:
            return skip
        take = weights.get(v, 0) * depth[v] + distribute(children[v], b - 1, depth[v])
        return max(skip, take)

    return solve(roots[0], budget, 0)

"""Finite replay tools for predictive addition-cache distance profiles."""

from collections import deque


def one_step(cache: frozenset[int], ceiling: int) -> set[frozenset[int]]:
    additions = {x + y for x in cache for y in cache if x + y <= ceiling}
    return {cache | {z} for z in additions if z not in cache}


def distance(cache: set[int], target: int) -> int:
    """Exact BFS distance; values above target are never needed to form target."""
    start = frozenset(x for x in cache if x <= target)
    if target in start:
        return 0
    queue = deque([(start, 0)])
    seen = {start}
    while queue:
        state, depth = queue.popleft()
        for nxt in one_step(state, target):
            if target in nxt:
                return depth + 1
            if nxt not in seen:
                seen.add(nxt)
                queue.append((nxt, depth + 1))
    raise AssertionError("cache containing 1 must reach every positive target")


def critical_pair(r: int) -> tuple[int, int, int]:
    """Return positive (a,b,v) for which r is the least positive critical rep."""
    if r < 1:
        raise ValueError("r must be positive")
    power = 1
    k = 0
    while power <= r:
        power *= 2
        k += 1
    return power - r, r + power // 2, k - 1


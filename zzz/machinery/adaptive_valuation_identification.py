"""Exact minimax solver for bounded adaptive p-adic valuation queries."""

from functools import lru_cache


def tau(x: int, p: int, k: int) -> int:
    modulus = p**k
    x %= modulus
    if x == 0:
        return k
    value = 0
    while x % p == 0:
        x //= p
        value += 1
    return value


def partition(states: frozenset[int], center: int, p: int, k: int):
    parts = {}
    for r in states:
        parts.setdefault(tau(r + center, p, k), set()).add(r)
    return tuple(frozenset(part) for part in parts.values())


def minimax_queries(p: int, k: int) -> int:
    modulus = p**k

    @lru_cache(None)
    def solve(states: frozenset[int]) -> int:
        if len(states) <= 1:
            return 0
        best = len(states) - 1
        for center in range(modulus):
            parts = partition(states, center, p, k)
            if len(parts) == 1:
                continue
            best = min(best, 1 + max(solve(part) for part in parts))
        return best

    return solve(frozenset(range(modulus)))


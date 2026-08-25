"""Exact finite helpers for valuation resolving-center sets."""

from itertools import combinations


def tau(x: int, p: int, k: int) -> int:
    modulus = p**k
    x %= modulus
    if x == 0:
        return k
    e = 0
    while x % p == 0:
        x //= p
        e += 1
    return e


def signature(r: int, centers: tuple[int, ...], p: int, k: int) -> tuple[int, ...]:
    return tuple(tau(r + c, p, k) for c in centers)


def separates(centers: tuple[int, ...], p: int, k: int) -> bool:
    modulus = p**k
    return len({signature(r, centers, p, k) for r in range(modulus)}) == modulus


def canonical_centers(p: int, k: int) -> tuple[int, ...]:
    """Omit one point from each class modulo p^(k-1)."""
    modulus = p**k
    base = p ** (k - 1)
    return tuple(x for x in range(modulus) if x // base != 0)


def minimum_by_exhaustion(p: int, k: int) -> int:
    modulus = p**k
    for size in range(modulus + 1):
        if any(separates(c, p, k) for c in combinations(range(modulus), size)):
            return size
    raise AssertionError


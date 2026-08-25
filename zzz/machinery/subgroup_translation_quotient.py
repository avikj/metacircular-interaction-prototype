"""Restricted translation behavior of truncated p-adic valuation."""


def truncated_valuation(r: int, p: int, k: int) -> int:
    modulus = p**k
    r %= modulus
    if r == 0:
        return k
    e = 0
    while r % p == 0:
        r //= p
        e += 1
    return e


def behavior(r: int, p: int, k: int, j: int) -> tuple[int, ...]:
    modulus = p**k
    subgroup = range(0, modulus, p**j)
    return tuple(truncated_valuation(r + h, p, k) for h in subgroup)


def behavior_classes(p: int, k: int, j: int) -> dict[tuple[int, ...], list[int]]:
    classes = {}
    for r in range(p**k):
        classes.setdefault(behavior(r, p, k, j), []).append(r)
    return classes


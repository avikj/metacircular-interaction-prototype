"""Exact costs for distribution-adaptive valuation child schedules."""

from fractions import Fraction
from itertools import permutations


def digits(r, p, k):
    return tuple((r // (p**ell)) % p for ell in range(k))


def local_cost(order, d):
    """The final item of a permutation is omitted, tying the preceding cost."""
    p = len(order)
    return min(order.index(d) + 1, p - 1)


def optimal_local(masses):
    """Return minimum unnormalized cost from child probability masses."""
    p = len(masses)
    ranked = sorted(masses, reverse=True)
    costs = list(range(1, p - 1)) + [p - 1, p - 1]
    return sum(m * c for m, c in zip(ranked, costs))


def formula_optimum(distribution, p, k):
    """Exact expected optimum; distribution values need only sum to one."""
    ds = {r: digits(r, p, k) for r in distribution}
    total = Fraction(0)
    for ell in range(k):
        prefixes = {d[:ell] for d in ds.values()}
        for prefix in prefixes:
            masses = []
            for child in range(p):
                masses.append(sum(
                    (w for r, w in distribution.items()
                     if ds[r][:ell] == prefix and ds[r][ell] == child),
                    Fraction(0),
                ))
            total += optimal_local(masses)
    return total


def brute_force_optimum(distribution, p, k):
    """Brute-force independent node minimization, used only as a falsifier."""
    ds = {r: digits(r, p, k) for r in distribution}
    total = Fraction(0)
    for ell in range(k):
        prefixes = {d[:ell] for d in ds.values()}
        for prefix in prefixes:
            candidates = []
            for order in permutations(range(p)):
                candidates.append(sum(
                    (w * local_cost(order, ds[r][ell])
                     for r, w in distribution.items()
                     if ds[r][:ell] == prefix),
                    Fraction(0),
                ))
            total += min(candidates)
    return total


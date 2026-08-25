"""Exact local query/motion costs for valuation-center schedules."""

from fractions import Fraction
from itertools import permutations


def local_costs(order, child):
    p = len(order)
    position = order.index(child)
    query = min(position + 1, p - 1)
    stop = position if position < p - 1 else p - 1
    path = (0,) + order[:stop + 1]
    motion = sum(abs(b - a) for a, b in zip(path, path[1:]))
    return query, motion


def expected_pair(order, masses):
    query = sum(m * local_costs(order, d)[0] for d, m in enumerate(masses))
    motion = sum(m * local_costs(order, d)[1] for d, m in enumerate(masses))
    return query, motion


def optimum(masses, lam):
    values = []
    for order in permutations(range(len(masses))):
        q, s = expected_pair(order, masses)
        values.append((q + lam * s, order, q, s))
    return min(values)


def ternary_envelope(masses, lam):
    x, y, z = masses
    candidates = (
        2 - x + lam * (y + 2 * z),
        2 - y + lam * min(2 * x + y + 4 * z, 4 * x + y + 2 * z),
        2 - z + lam * (4 * x + 3 * y + 2 * z),
    )
    return min(candidates)


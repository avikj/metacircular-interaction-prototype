"""Exact successor-prefix digit counts and canonical expected costs."""

from fractions import Fraction


def digit(r, p, ell):
    return (r // (p**ell)) % p


def conditional_counts(N, p, ell, prefix):
    if prefix >= N:
        return [0] * p
    T = (N - 1 - prefix) // (p**ell) + 1
    q, a = divmod(T, p)
    return [q + (d < a) for d in range(p)]


def digit_count_formula(N, p, ell, d):
    A = p**ell
    B = p * A
    c, s = divmod(N, B)
    return c * A + min(A, max(0, s - d * A))


def expected_cost_formula(N, p, k):
    query = 0
    motion = 0
    for ell in range(k):
        for d in range(p):
            count = digit_count_formula(N, p, ell, d)
            query += count * (d + 1 if d <= p - 2 else p - 1)
            motion += count * d
    return Fraction(query, N), Fraction(motion, N)


def brute_cost(N, p, k):
    query = motion = 0
    for r in range(N):
        for ell in range(k):
            d = digit(r, p, ell)
            query += d + 1 if d <= p - 2 else p - 1
            motion += d
    return Fraction(query, N), Fraction(motion, N)


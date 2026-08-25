#!/usr/bin/env python3
"""Exact counterexamples: average-energy data do not determine uniform bounds."""

from fractions import Fraction


def mean(profile):
    return sum(profile, Fraction(0)) / len(profile)


def uniform(profile):
    return max(profile)


def main():
    witnesses = []
    for n in (2, 3, 5, 10):
        concentrated = (Fraction(n),) + (Fraction(0),) * (n - 1)
        flat = (Fraction(1),) * n
        assert mean(concentrated) == mean(flat) == 1
        assert uniform(concentrated) == n and uniform(flat) == 1
        witnesses.append((n, mean(flat), uniform(concentrated), uniform(flat)))

    # The refined statistic (mean,max) answers both declared tasks, while mean
    # alone fails on every witness fiber.
    refined = lambda p: (mean(p), uniform(p))
    assert refined((2, 0)) != refined((1, 1))

    # False control: on the equidistributed subdomain, max equals mean and the
    # average quotient is sufficient.
    equidistributed = [(Fraction(k),) * 4 for k in range(5)]
    assert all(uniform(p) == mean(p) for p in equidistributed)
    print({"same_mean_unbounded_sup_ratio": witnesses,
           "equidistributed_control": "max=mean"})
    print("ALL EXACT AVERAGE/UNIFORM QUOTIENT CHECKS PASS")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Exact squarefree cyclotomic-tie scan in prime-index coordinates.

The input is a maximum prime index ``K``.  At the cutoff ``X = p_k``,
Corollary 3 of ``notes/CYCLOTOMIC_TRACE.md`` says that a squarefree modulus

    m = product(r in R) r

can be a tie only if

    k = sum(R),                 phi(m) = product(r-1) <= p_k - 2,             (1)

and the following two multisets of residue classes modulo m are equal:

    {q mod m : q <= p_k, q not in R}
      = {r + j*m/r mod m : r in R, 1 <= j < r}.                              (2)

Thus the candidates are distinct-prime partitions of k, not a range of
moduli.  The DFS below enumerates every partition satisfying (1).  Before
the exact Counter comparison in (2), it applies the necessary polynomial
moment congruences obtained by summing (2), first for H(x)=x and then for
H(x)=x^2.  In practice the first two moments leave only the genuine ties.

The scan is exact: it uses integer arithmetic throughout, and it never
constructs a cyclotomic polynomial.  A run through two million cutoffs is:

    python3 code/exp28_squarefree_ties.py --max-k 2000000

On the reference machine this takes about one minute and tests 2,417,270
scalar/degree candidates.  The default is deliberately smaller for a quick
reproducibility check.
"""

from __future__ import annotations

import argparse
import math
import time
from collections import Counter

import numpy as np

from pairfield import sieve_primes


KNOWN_TIES = {
    # (prime index k, tuple of prime factors R, squarefree modulus m)
    (2, (2,), 2),
    (5, (2, 3), 6),
}


def first_primes(k: int) -> np.ndarray:
    """Return the first k primes as int64, using a proved-safe standard bound."""
    if k < 1:
        return np.empty(0, dtype=np.int64)
    if k < 6:
        bound = 20
    else:
        # Rosser--Schoenfeld: p_k < k(log k + log log k), for k >= 6.
        bound = math.ceil(k * (math.log(k) + math.log(math.log(k)))) + 1
    while True:
        primes = np.flatnonzero(sieve_primes(bound)).astype(np.int64)
        if len(primes) >= k:
            return primes[:k]
        # Defensive only: the bound above already suffices.
        bound *= 2


def expected_first_moment(factors: tuple[int, ...] | list[int], modulus: int) -> int:
    """Sum of the forced residue representatives, modulo m."""
    total = 0
    for r in factors:
        f = modulus // r
        # sum_{j=1}^{r-1} (r + jf)
        total += r * (r - 1) + f * r * (r - 1) // 2
    return total % modulus


def expected_second_moment(factors: tuple[int, ...], modulus: int) -> int:
    """Sum of the squares of the forced representatives, modulo m."""
    total = 0
    for r in factors:
        f = modulus // r
        n = r - 1
        sum_j = n * (n + 1) // 2
        sum_j2 = n * (n + 1) * (2 * n + 1) // 6
        # sum_{j=1}^{r-1} (r + jf)^2
        total += n * r * r + 2 * r * f * sum_j + f * f * sum_j2
    return total % modulus


def exact_forced_vector_test(
    factors: tuple[int, ...], k: int, primes: np.ndarray, modulus: int
) -> bool:
    """Test the necessary-and-sufficient forced class vector (2) exactly."""
    factor_set = set(factors)
    actual = Counter(
        int(q) % modulus for q in primes[:k] if int(q) not in factor_set
    )
    forced: Counter[int] = Counter()
    for r in factors:
        f = modulus // r
        for j in range(1, r):
            forced[(r + j * f) % modulus] += 1
    return actual == forced


def scan(max_k: int) -> dict[str, object]:
    if max_k < 2:
        raise ValueError("--max-k must be at least 2")

    started = time.perf_counter()
    primes = first_primes(max_k)
    sieve_seconds = time.perf_counter() - started
    largest_cutoff = int(primes[-1])

    # Every factor r obeys r <= sum(R) = k <= max_k.
    factor_primes = [int(p) for p in primes if p <= max_k]

    # S_1(k)=sum_{i<=k}p_i fits uint64 by a huge margin in the documented
    # range (at K=2e6 it is < K*p_K < 6.5e13).
    prefix_sum = np.empty(max_k + 1, dtype=np.uint64)
    prefix_sum[0] = 0
    np.cumsum(primes, dtype=np.uint64, out=prefix_sum[1:])

    tested = 0
    by_cardinality: Counter[int] = Counter()
    first_moment_survivors: list[tuple[int, tuple[int, ...], int]] = []

    def test_scalar_candidate(
        factors: list[int], k: int, phi: int, modulus: int
    ) -> None:
        nonlocal tested
        # The DFS uses only the global p_max cap; impose the candidate's exact
        # degree condition here.
        if phi > int(primes[k - 1]) - 2:
            return
        tested += 1
        by_cardinality[len(factors)] += 1

        # sum(factors)=k by construction.
        actual = (int(prefix_sum[k]) - k) % modulus
        if actual == expected_first_moment(factors, modulus):
            first_moment_survivors.append((k, tuple(factors), modulus))

    # Enumerate all nonempty subsets R of the primes, in increasing order.
    # If phi exceeds p_max, no extension can return below the global cap.
    def dfs(
        start: int,
        factors: list[int],
        factor_sum: int,
        phi: int,
        modulus: int,
    ) -> None:
        for index in range(start, len(factor_primes)):
            r = factor_primes[index]
            new_sum = factor_sum + r
            if new_sum > max_k:
                break
            if phi > largest_cutoff // (r - 1):
                break
            new_phi = phi * (r - 1)
            new_modulus = modulus * r
            factors.append(r)
            test_scalar_candidate(factors, new_sum, new_phi, new_modulus)
            dfs(index + 1, factors, new_sum, new_phi, new_modulus)
            factors.pop()

    enumeration_started = time.perf_counter()
    dfs(0, [], 0, 1, 1)
    enumeration_seconds = time.perf_counter() - enumeration_started

    second_moment_survivors: list[tuple[int, tuple[int, ...], int]] = []
    for k, factors, modulus in first_moment_survivors:
        # There are very few first-moment survivors, so computing this prefix
        # only for them uses much less memory than storing all square sums.
        actual = (
            sum(int(q) * int(q) for q in primes[:k])
            - sum(r * r for r in factors)
        ) % modulus
        if actual == expected_second_moment(factors, modulus):
            second_moment_survivors.append((k, factors, modulus))

    exact_ties = [
        (k, factors, modulus)
        for k, factors, modulus in second_moment_survivors
        if exact_forced_vector_test(factors, k, primes, modulus)
    ]
    filter_seconds = time.perf_counter() - enumeration_started - enumeration_seconds
    total_seconds = time.perf_counter() - started

    expected = sorted(tie for tie in KNOWN_TIES if tie[0] <= max_k)
    assert sorted(exact_ties) == expected, (
        "unexpected squarefree cyclotomic-tie result; this is either a new "
        f"candidate or a bug: got {sorted(exact_ties)}, expected {expected}"
    )

    return {
        "max_k": max_k,
        "largest_cutoff": largest_cutoff,
        "tested": tested,
        "by_cardinality": dict(sorted(by_cardinality.items())),
        "first_moment_survivors": first_moment_survivors,
        "second_moment_survivors": second_moment_survivors,
        "exact_ties": exact_ties,
        "sieve_seconds": sieve_seconds,
        "enumeration_seconds": enumeration_seconds,
        "filter_seconds": filter_seconds,
        "total_seconds": total_seconds,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--max-k",
        type=int,
        default=100_000,
        help="scan prime cutoffs p_k for 2 <= k <= MAX_K (default: 100000)",
    )
    args = parser.parse_args()
    result = scan(args.max_k)

    print("# exact squarefree cyclotomic-tie scan")
    print(f"max_k={result['max_k']:,}")
    print(f"p_max_k={result['largest_cutoff']:,}")
    print(f"scalar_degree_candidates={result['tested']:,}")
    print(f"candidates_by_cardinality={result['by_cardinality']}")
    print(f"H=x survivors={result['first_moment_survivors']}")
    print(f"H=x^2 survivors={result['second_moment_survivors']}")
    print(f"exact ties (k, factors, m)={result['exact_ties']}")
    print(
        "timing_seconds="
        f"sieve:{result['sieve_seconds']:.3f},"
        f"enumeration:{result['enumeration_seconds']:.3f},"
        f"filters:{result['filter_seconds']:.3f},"
        f"total:{result['total_seconds']:.3f}"
    )


if __name__ == "__main__":
    main()

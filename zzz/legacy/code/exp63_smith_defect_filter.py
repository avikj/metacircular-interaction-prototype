#!/usr/bin/env python3
"""Exact replay for notes/SMITH_DEFECT_FILTER.md."""

from __future__ import annotations

from fractions import Fraction as Q
from math import gcd

from exact_polynomial import real_root_count, resultant
from exp48_nonreciprocal_decic_frontier import (
    mod_gcd,
    mod_power,
    mod_remainder,
    rabin_degree_ten,
    roots_in_disk,
)
from exp62_resultant_observer_defect import (
    bareiss_det,
    multiplication_matrix,
    rank_mod,
)


if not __debug__:
    raise SystemExit("refusing to run with assertions disabled")


QA = [1, -1, -1, 1, 0, 1, 1, -1, -1, 0, 1]
QB = [1, -1, 0, -1, 1, -1, 1, 0, 1, 0, 1]


def endpoint(q: list[int], sign: int) -> int:
    return sum(value * sign**exponent for exponent, value in enumerate(q))


def delta_n_minus_one(matrix: list[list[int]]) -> int:
    """Gcd of all (n-1)-minors, computed by exact Bareiss elimination."""
    n = len(matrix)
    answer = 0
    for omitted_row in range(n):
        for omitted_column in range(n):
            minor = [
                [matrix[i][j] for j in range(n) if j != omitted_column]
                for i in range(n)
                if i != omitted_row
            ]
            answer = gcd(answer, abs(bareiss_det(minor)))
    return answer


def parity_resultant(q: list[int]) -> int:
    even = q[0::2]
    odd = q[1::2]
    return resultant(list(reversed(even)), list(reversed(odd)))


def add_mod(left: list[int], right: list[int], modulus: list[int]) -> list[int]:
    size = max(len(left), len(right))
    left = left + [0] * (size - len(left))
    right = right + [0] * (size - len(right))
    return mod_remainder([(x + y) % 2 for x, y in zip(left, right)], modulus, 2)


def primes_through(limit: int) -> list[int]:
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[:2] = b"\x00\x00"
    for p in range(2, int(limit**0.5) + 1):
        if sieve[p]:
            count = (limit - p * p) // p + 1
            sieve[p * p : limit + 1 : p] = b"\x00" * count
    return [p for p in range(2, limit + 1) if sieve[p]]


def verify_candidate(q: list[int], irreducibility_prime: int) -> dict[str, object]:
    assert q[0] == q[-1] == 1 and q != q[::-1]
    assert abs(parity_resultant(q)) == 1
    assert real_root_count(list(map(Q, q))) == 0
    inner = Q(618_034, 1_000_000)
    outer = Q(1_414_213, 1_000_000)
    assert (2 * inner + 1) ** 2 > 5  # inner > (sqrt(5)-1)/2
    assert outer**2 < 2
    assert roots_in_disk(q, inner) == 0
    assert roots_in_disk(q, outer) == 10
    rabin_degree_ten(q, irreducibility_prime)

    matrix = multiplication_matrix(q, q[::-1])
    determinant = bareiss_det(matrix)
    assert determinant == 16
    delta9 = delta_n_minus_one(matrix)
    nullity2 = 10 - rank_mod(matrix, 2)
    local_gcd = mod_gcd(q, q[::-1], 2)
    assert len(local_gcd) - 1 == nullity2
    return {
        "ascending_coefficients": q,
        "endpoints": [endpoint(q, 1), endpoint(q, -1)],
        "reversal_resultant": determinant,
        "delta9": delta9,
        "mod2_nullity": nullity2,
        "mod2_gcd_ascending": local_gcd,
        "irreducible_mod": irreducibility_prime,
    }


def finite_regression(limit: int = 100_000) -> dict[str, int]:
    moduli = [[1, 1, 1], [1, 1]]
    states = [[1], [1]]  # the constant term from the prime 2
    eligible = 0
    passes = [0, 0]
    for prime_count, prime in enumerate(primes_through(limit), start=1):
        if prime > 2:
            for index, modulus in enumerate(moduli):
                monomial = mod_power([0, 1], prime - 2, modulus, 2)
                states[index] = add_mod(states[index], monomial, modulus)
        if prime_count % 8 == 2:
            eligible += 1
            for index, state in enumerate(states):
                passes[index] += state == [0]
    assert eligible == 1_199
    assert passes == [0, 1_199]
    return {
        "eligible_prime_prefix_states": eligible,
        "qA_passes": passes[0],
        "qB_passes": passes[1],
    }


def main() -> None:
    a = verify_candidate(QA, 11)
    b = verify_candidate(QB, 3)
    assert a["delta9"] == 4 and a["mod2_nullity"] == 2
    assert b["delta9"] == 1 and b["mod2_nullity"] == 1
    assert a["mod2_gcd_ascending"] == [1, 1, 1]
    assert b["mod2_gcd_ascending"] == [1, 1]

    # Planted determinant collision: the scalar is equal while the modules are
    # Z/4 and (Z/2)^2.  This catches accidental determinant-only rewrites.
    planted = ([[1, 0], [0, 4]], [[2, 0], [0, 2]])
    assert [bareiss_det(matrix) for matrix in planted] == [4, 4]
    assert [2 - rank_mod(matrix, 2) for matrix in planted] == [1, 2]

    print({
        "schema": "exp63-smith-defect-filter/v1",
        "qA": a,
        "qB": b,
        "smith_modules": ["(Z/4)^2", "Z/16"],
        "displayed_same_scalar_pair_reduction": "2 -> 1",
        "finite_regression": finite_regression(),
    })
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

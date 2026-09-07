#!/usr/bin/env python3
"""Exact replay for the global-charge no-go theorem.

The two prime cutoffs and ternomial controls are fixed theorem consequences.
This script performs no scan and makes no claim about later prime prefixes.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp51 is an exact replay and forbids python -O")

from hashlib import sha256
import json
from math import isqrt


ELL = 7
PHI6 = (1, 6, 1)  # x^2-x+1, ascending modulo 7
H7 = (1, 4, 1)  # gcd(q1,q1*) modulo 7


def trim(polynomial: tuple[int, ...], prime: int) -> tuple[int, ...]:
    answer = tuple(coefficient % prime for coefficient in polynomial)
    while len(answer) > 1 and answer[-1] == 0:
        answer = answer[:-1]
    return answer


def remainder(
    dividend: tuple[int, ...], divisor: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    work = list(trim(dividend, prime))
    divisor = trim(divisor, prime)
    inverse = pow(divisor[-1], -1, prime)
    while len(work) >= len(divisor) and any(work):
        shift = len(work) - len(divisor)
        scale = work[-1] * inverse % prime
        for index, coefficient in enumerate(divisor):
            work[index + shift] = (
                work[index + shift] - scale * coefficient
            ) % prime
        work = list(trim(tuple(work), prime))
    return tuple(work)


def gcd(
    left: tuple[int, ...], right: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    left = trim(left, prime)
    right = trim(right, prime)
    while right != (0,):
        left, right = right, remainder(left, right, prime)
    inverse = pow(left[-1], -1, prime)
    return tuple(coefficient * inverse % prime for coefficient in left)


def primes_through(limit: int) -> list[int]:
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[:2] = b"\x00\x00"
    for prime in range(2, isqrt(limit) + 1):
        if sieve[prime]:
            start = prime * prime
            sieve[start : limit + 1 : prime] = b"\x00" * (
                (limit - start) // prime + 1
            )
    return [value for value in range(2, limit + 1) if sieve[value]]


def prime_prefix(primes: list[int]) -> tuple[int, ...]:
    answer = [0] * (primes[-1] - 1)
    for prime in primes:
        answer[prime - 2] = 1
    return tuple(answer)


def phi6_closed_remainder(primes: list[int]) -> tuple[int, int]:
    count_one = sum(prime > 3 and prime % 6 == 1 for prime in primes)
    count_five = sum(prime > 3 and prime % 6 == 5 for prime in primes)
    return (
        (1 + count_one - count_five) % ELL,
        (1 - count_one) % ELL,
    )


def h7_closed_syndrome(primes: list[int]) -> tuple[int, int]:
    counts = [
        sum(prime > 2 and prime % 8 == residue for prime in primes)
        for residue in (1, 3, 5, 7)
    ]
    m1, m3, m5, m7 = counts
    return (
        (1 + 3 * m1 + 4 * m5) % ELL,
        (6 * m1 + m3 + m5 + 6 * m7) % ELL,
    )


def valuation_three(value: int) -> int | None:
    """Return v_3(value), with None representing v_3(0)=infinity."""
    value = abs(value)
    if value == 0:
        return None
    valuation = 0
    while value % 3 == 0:
        value //= 3
        valuation += 1
    return valuation


def ternomial(m: int, n: int) -> tuple[int, ...]:
    assert m >= 1 and n >= 1
    answer = [0] * (m + n + 1)
    answer[0] = answer[m] = answer[m + n] = 1
    return tuple(answer)


def predicted_ternomial_collision(m: int, n: int) -> bool:
    difference_valuation = valuation_three(m - n)
    if difference_valuation is None:
        return True
    m_valuation = valuation_three(m)
    assert m_valuation is not None
    return difference_valuation > m_valuation


def actual_ternomial_collision(m: int, n: int) -> bool:
    polynomial = ternomial(m, n)
    return len(gcd(polynomial, tuple(reversed(polynomial)), ELL)) > 1


def replay() -> dict[str, object]:
    fixed_prefixes: dict[str, object] = {}
    expected = {
        2113: {
            "prime_count": 319,
            "count_mod_6_one": 155,
            "count_mod_6_five": 162,
            "phi6_remainder": (1, 0),
        },
        2129: {
            "prime_count": 320,
            "count_mod_6_one": 155,
            "count_mod_6_five": 163,
            "phi6_remainder": (0, 0),
        },
    }
    for cutoff, target in expected.items():
        primes = primes_through(cutoff)
        assert primes[-1] == cutoff
        count_one = sum(p > 3 and p % 6 == 1 for p in primes)
        count_five = sum(p > 3 and p % 6 == 5 for p in primes)
        assert len(primes) == target["prime_count"]
        assert count_one == target["count_mod_6_one"]
        assert count_five == target["count_mod_6_five"]
        closed = phi6_closed_remainder(primes)
        assert closed == target["phi6_remainder"]
        direct = remainder(prime_prefix(primes), PHI6, ELL)
        direct += (0,) * (2 - len(direct))
        assert direct == closed
        fixed_prefixes[str(cutoff)] = {
            "prime_count": len(primes),
            "endpoint_class_mod_15": len(primes) % 15,
            "count_mod_6_one": count_one,
            "count_mod_6_five": count_five,
            "phi6_remainder_basis_1_x": list(closed),
        }

    primes2129 = primes_through(2129)
    prefix2129 = prime_prefix(primes2129)
    assert sum(prefix2129) % ELL == 5
    alternating = sum(
        coefficient * (-1) ** exponent
        for exponent, coefficient in enumerate(prefix2129)
    )
    assert alternating % ELL == 4
    assert remainder(prefix2129, PHI6, ELL) == (0,)
    h7_direct = remainder(prefix2129, H7, ELL)
    h7_direct += (0,) * (2 - len(h7_direct))
    h7_syndrome = h7_closed_syndrome(primes2129)
    assert h7_direct == h7_syndrome == (2, 2)
    fixed_prefixes["2129"].update(
        {
            "endpoint_values_mod_7": [5, 4],
            "h7_remainder_basis_1_x": list(h7_syndrome),
            "global_charge_zero_certified_by_phi6": True,
            "q1_collision_rejected": True,
        }
    )

    # Fixed algebraic controls for the corrected ternomial predicate.
    # Equality of valuations alone is deliberately rejected at (1,2).
    ternomial_controls = []
    for m, n, expected_collision in (
        (9, 9, True),
        (9, 36, True),
        (9, 18, False),
        (1, 2, False),
        (10, 13, True),
    ):
        predicted = predicted_ternomial_collision(m, n)
        actual = actual_ternomial_collision(m, n)
        assert predicted == actual == expected_collision
        polynomial = ternomial(m, n)
        assert sum(polynomial) % ELL == 3
        alternating = sum(
            coefficient * (-1) ** exponent
            for exponent, coefficient in enumerate(polynomial)
        )
        assert alternating % ELL != 0
        ternomial_controls.append(
            {
                "m": m,
                "n": n,
                "v3_m_minus_n": valuation_three(m - n),
                "v3_m": valuation_three(m),
                "collision": actual,
            }
        )

    report: dict[str, object] = {
        "experiment": "exp51_global_charge_no_go",
        "claim": {
            "certifies": (
                "the named X=2129 global reciprocal collision, its q1 "
                "h7 rejection, the X=2113 false control, and fixed "
                "ternomial predicate controls"
            ),
            "does_not_certify": (
                "nonregularity by finite computation, any all-X exclusion, "
                "or nonregularity of the actual prime-prefix stream"
            ),
        },
        "fixed_prefixes": fixed_prefixes,
        "ternomial_controls": ternomial_controls,
    }
    canonical = json.dumps(report, sort_keys=True, separators=(",", ":")).encode()
    report["sha256_without_digest"] = sha256(canonical).hexdigest()
    return report


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2, sort_keys=True))

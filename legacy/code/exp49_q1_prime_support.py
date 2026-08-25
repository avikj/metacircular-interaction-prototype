#!/usr/bin/env python3
"""Exact prime-support replay for q1 = x^10+x^8+x^2+x+1.

This certificate has one deliberately narrow purpose.  It proves that the
endpoint tether, the complete mod-2 remainder automaton, and the quadratic
cross-reversal constraint modulo 7 can all hold at the same prime cutoff.
It then excludes actual divisibility at that cutoff by a nonzero mod-3
remainder.  No probabilistic primality or floating-point arithmetic is used.
"""

from __future__ import annotations

from hashlib import sha256
import json
from math import isqrt


if not __debug__:
    raise SystemExit("exp49 requires assertions; do not run Python with -O")


Q1 = (1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1)  # ascending coefficients
X0 = 246_709


def trim(a: tuple[int, ...]) -> tuple[int, ...]:
    a = tuple(a)
    while len(a) > 1 and a[-1] == 0:
        a = a[:-1]
    return a


def mul_raw(
    a: tuple[int, ...], b: tuple[int, ...], characteristic: int
) -> tuple[int, ...]:
    c = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            c[i + j] = (c[i + j] + ai * bj) % characteristic
    return trim(tuple(c))


def reduce_polynomial(
    polynomial: tuple[int, ...],
    divisor: tuple[int, ...],
    characteristic: int,
) -> tuple[int, ...]:
    """Return the ascending remainder over a prime field."""
    work = [coefficient % characteristic for coefficient in polynomial]
    degree = len(divisor) - 1
    assert divisor[-1] % characteristic == 1
    for k in range(len(work) - 1, degree - 1, -1):
        lead = work[k]
        if lead:
            for j in range(degree + 1):
                work[k - degree + j] = (
                    work[k - degree + j] - lead * divisor[j]
                ) % characteristic
    remainder = tuple(work[:degree])
    return remainder + (0,) * (degree - len(remainder))


def mul_mod(
    a: tuple[int, ...],
    b: tuple[int, ...],
    modulus_polynomial: tuple[int, ...],
    characteristic: int,
) -> tuple[int, ...]:
    """Multiply in F_characteristic[x]/(modulus_polynomial), ascending."""
    degree = len(modulus_polynomial) - 1
    assert modulus_polynomial[-1] % characteristic == 1
    c = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            c[i + j] = (c[i + j] + ai * bj) % characteristic
    if len(c) < degree + 1:
        c.extend([0] * (degree + 1 - len(c)))
    for k in range(len(c) - 1, degree - 1, -1):
        lead = c[k] % characteristic
        if lead:
            for j in range(degree):
                c[k - degree + j] = (
                    c[k - degree + j] - lead * modulus_polynomial[j]
                ) % characteristic
    return tuple(c[:degree])


def pow_x_mod(
    exponent: int, modulus_polynomial: tuple[int, ...], characteristic: int
) -> tuple[int, ...]:
    degree = len(modulus_polynomial) - 1
    result = (1,) + (0,) * (degree - 1)
    base = (0, 1) + (0,) * (degree - 2)
    while exponent:
        if exponent & 1:
            result = mul_mod(result, base, modulus_polynomial, characteristic)
        base = mul_mod(base, base, modulus_polynomial, characteristic)
        exponent //= 2
    return result


def order_certificate(
    polynomial: tuple[int, ...],
    characteristic: int,
    order: int,
    distinct_prime_factors: tuple[int, ...],
) -> dict[str, object]:
    """Certify the exact multiplicative order of x by the standard test."""
    one = (1,) + (0,) * (len(polynomial) - 2)
    assert pow_x_mod(order, polynomial, characteristic) == one
    witnesses: dict[str, list[int]] = {}
    for prime in distinct_prime_factors:
        assert order % prime == 0
        remainder = pow_x_mod(order // prime, polynomial, characteristic)
        assert remainder != one
        witnesses[str(prime)] = list(remainder)
    return {
        "characteristic": characteristic,
        "order": order,
        "prime_divisor_witnesses": witnesses,
    }


def primes_through(limit: int) -> list[int]:
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[:2] = b"\x00\x00"
    for p in range(2, isqrt(limit) + 1):
        if sieve[p]:
            start = p * p
            sieve[start : limit + 1 : p] = b"\x00" * (
                (limit - start) // p + 1
            )
    return [n for n in range(2, limit + 1) if sieve[n]]


def power_table(
    period: int, polynomial: tuple[int, ...], characteristic: int
) -> list[tuple[int, ...]]:
    table = [pow_x_mod(0, polynomial, characteristic)]
    x = pow_x_mod(1, polynomial, characteristic)
    for _ in range(1, period):
        table.append(mul_mod(table[-1], x, polynomial, characteristic))
    assert mul_mod(table[-1], x, polynomial, characteristic) == table[0]
    return table


def add_vectors(
    left: tuple[int, ...], right: tuple[int, ...], modulus: int
) -> tuple[int, ...]:
    return tuple((a + b) % modulus for a, b in zip(left, right))


def parity_mask(primes: list[int], period: int) -> int:
    mask = 0
    for p in primes:
        mask ^= 1 << ((p - 2) % period)
    return mask


def integer_divmod_monic(
    dividend: tuple[int, ...], divisor: tuple[int, ...]
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    """Exact ascending-coefficient division by a monic integer polynomial."""
    work = list(dividend)
    degree = len(divisor) - 1
    quotient = [0] * max(1, (len(dividend) - degree))
    for k in range(len(work) - 1, degree - 1, -1):
        lead = work[k]
        quotient[k - degree] = lead
        for j in range(degree + 1):
            work[k - degree + j] -= lead * divisor[j]
    return trim(tuple(quotient)), trim(tuple(work[:degree] or [0]))


def replay() -> dict[str, object]:
    # q1 = (x^3+x^2+1)(x^7+x^6+x^4+x+1) over F_2.
    f3 = (1, 0, 1, 1)
    f7 = (1, 1, 0, 0, 1, 0, 1, 1)
    assert mul_raw(f3, f7, 2) == trim(tuple(c % 2 for c in Q1))

    factor_orders = {
        "degree_3": order_certificate(f3, 2, 7, (7,)),
        "degree_7": order_certificate(f7, 2, 127, (127,)),
        "q1_mod_2": order_certificate(Q1, 2, 889, (7, 127)),
        "q1_mod_3": order_certificate(Q1, 3, 19_682, (2, 13, 757)),
    }

    primes = primes_through(X0)
    assert len(primes) == 21_770 and primes[-1] == X0

    table2 = power_table(889, Q1, 2)
    remainder2 = (0,) * 10
    counts8 = [0] * 8
    first_endpoint_mod2: tuple[int, int] | None = None
    first_endpoint_mod2_beta7: tuple[int, int] | None = None
    for index, prime in enumerate(primes, 1):
        remainder2 = add_vectors(remainder2, table2[(prime - 2) % 889], 2)
        if prime > 2:
            counts8[(prime - 2) % 8] += 1
        if index % 15 == 5 and not any(remainder2):
            if first_endpoint_mod2 is None:
                first_endpoint_mod2 = (index, prime)
            beta7 = (
                (counts8[3] - counts8[7]) % 7 == 5
                and (counts8[1] - counts8[5]) % 7 == 2
            )
            if beta7 and first_endpoint_mod2_beta7 is None:
                first_endpoint_mod2_beta7 = (index, prime)

    assert first_endpoint_mod2 == (21_770, X0)
    assert first_endpoint_mod2_beta7 == (21_770, X0)
    assert not any(remainder2)

    # The shared q1/q1* factor x^2+4x+1 over F_7 has beta^4=-1.
    beta_polynomial = (1, 4, 1)
    assert reduce_polynomial(Q1, beta_polynomial, 7) == (0, 0)
    assert reduce_polynomial(tuple(reversed(Q1)), beta_polynomial, 7) == (0, 0)
    beta_table = power_table(8, beta_polynomial, 7)
    assert beta_table[4] == (6, 0)
    beta_remainder = (0, 0)
    for prime in primes:
        beta_remainder = add_vectors(beta_remainder, beta_table[(prime - 2) % 8], 7)
    assert beta_remainder == (0, 0)

    # Full mod-3 state at the same cutoff disproves q1 | F_X0 over Z.
    table3 = power_table(19_682, Q1, 3)
    remainder3 = (0,) * 10
    for prime in primes:
        remainder3 = add_vectors(remainder3, table3[(prime - 2) % 19_682], 3)
    expected_remainder3 = (1, 1, 1, 0, 0, 0, 1, 1, 2, 0)
    assert remainder3 == expected_remainder3

    count_residues_mod7 = [0] * 7
    count_residues_mod127 = [0] * 127
    for prime in primes:
        count_residues_mod7[(prime - 2) % 7] ^= 1
        count_residues_mod127[(prime - 2) % 127] ^= 1

    # Positive control: F_5 = 1+x+x^3, so it divides itself integrally.
    control = (1, 1, 0, 1)
    quotient, control_remainder = integer_divmod_monic(control, control)
    assert quotient == (1,) and control_remainder == (0,)

    report: dict[str, object] = {
        "claim": {
            "certifies": (
                "endpoint + full mod-2 + cross-collision mod-7 filters have "
                "a common genuine prime-prefix state"
            ),
            "does_not_certify": "q1 divides any prime-prefix polynomial",
        },
        "polynomial": "x^10+x^8+x^2+x+1",
        "cutoff": X0,
        "prime_count": len(primes),
        "endpoint_class_mod_15": len(primes) % 15,
        "orders": factor_orders,
        "mod_2": {
            "remainder_ascending": list(remainder2),
            "first_endpoint_zero": list(first_endpoint_mod2),
            "parity_mask_mod_7": hex(parity_mask(primes, 7)),
            "parity_mask_mod_127": hex(parity_mask(primes, 127)),
            "marginal_weights": [
                sum(count_residues_mod7),
                sum(count_residues_mod127),
            ],
        },
        "cross_collision_mod_7": {
            "counts_exponent_classes_1_3_5_7_mod_7": [
                counts8[r] % 7 for r in (1, 3, 5, 7)
            ],
            "c3_minus_c7": (counts8[3] - counts8[7]) % 7,
            "c1_minus_c5": (counts8[1] - counts8[5]) % 7,
            "remainder_in_F7_beta_basis": list(beta_remainder),
        },
        "mod_3_exclusion": {
            "remainder_ascending": list(remainder3),
            "is_zero": False,
        },
        "positive_control": {
            "cutoff": 5,
            "polynomial": "x^3+x+1 = F_5",
            "integer_remainder_ascending": list(control_remainder),
        },
    }
    payload = json.dumps(report, sort_keys=True, separators=(",", ":")).encode()
    report["sha256_without_digest"] = sha256(payload).hexdigest()
    return report


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2, sort_keys=True))

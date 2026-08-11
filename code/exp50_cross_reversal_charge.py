#!/usr/bin/env python3
"""Exact replay for the conserved cross-reversal charge.

The theorem kernel is ``charge(P) = det(I - wedge^2 companion(P))``.
The modular kernel turns a low-degree common reciprocal factor into a
residue-count syndrome.  Two named prime prefixes are falsifiers only; this
script performs no census and makes no all-cutoff exclusion claim.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp50 is an exact replay and forbids python -O")

from hashlib import sha256
import json
from math import isqrt

from exact_polynomial import resultant


Q1 = (1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1)  # ascending
F5 = (1, 1, 0, 1)
H7 = (1, 4, 1)


def trim(polynomial: tuple[int, ...]) -> tuple[int, ...]:
    answer = tuple(polynomial)
    while len(answer) > 1 and answer[-1] == 0:
        answer = answer[:-1]
    return answer


def multiply(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] += x * y
    return trim(tuple(answer))


def evaluate(polynomial: tuple[int, ...], value: int) -> int:
    return sum(coefficient * value**exponent
               for exponent, coefficient in enumerate(polynomial))


def bareiss_determinant(matrix: list[list[int]]) -> int:
    """Fraction-free exact determinant with row pivoting."""
    size = len(matrix)
    assert all(len(row) == size for row in matrix)
    if size == 0:
        return 1
    work = [row[:] for row in matrix]
    sign = 1
    previous = 1
    for pivot_index in range(size - 1):
        if work[pivot_index][pivot_index] == 0:
            pivot_row = next(
                (row for row in range(pivot_index + 1, size)
                 if work[row][pivot_index] != 0),
                None,
            )
            if pivot_row is None:
                return 0
            work[pivot_index], work[pivot_row] = (
                work[pivot_row], work[pivot_index]
            )
            sign *= -1
        pivot = work[pivot_index][pivot_index]
        for row in range(pivot_index + 1, size):
            for column in range(pivot_index + 1, size):
                numerator = (
                    work[row][column] * pivot
                    - work[row][pivot_index] * work[pivot_index][column]
                )
                assert numerator % previous == 0
                work[row][column] = numerator // previous
        for row in range(pivot_index + 1, size):
            work[row][pivot_index] = 0
        previous = pivot
    return sign * work[-1][-1]


def companion(polynomial: tuple[int, ...]) -> list[list[int]]:
    """Multiplication by x on Z[x]/(P), in the ascending power basis."""
    polynomial = trim(polynomial)
    degree = len(polynomial) - 1
    assert degree >= 1 and polynomial[-1] == 1
    matrix = [[0] * degree for _ in range(degree)]
    for column in range(degree - 1):
        matrix[column + 1][column] = 1
    for row in range(degree):
        matrix[row][-1] = -polynomial[row]
    return matrix


def exterior_square(matrix: list[list[int]]) -> list[list[int]]:
    """Matrix of wedge^2 A in lexicographic e_i wedge e_j basis."""
    degree = len(matrix)
    assert all(len(row) == degree for row in matrix)
    pairs = [(i, j) for i in range(degree) for j in range(i + 1, degree)]
    answer = [[0] * len(pairs) for _ in pairs]
    for column, (i, j) in enumerate(pairs):
        for row, (u, v) in enumerate(pairs):
            answer[row][column] = (
                matrix[u][i] * matrix[v][j]
                - matrix[u][j] * matrix[v][i]
            )
    return answer


def charge(polynomial: tuple[int, ...]) -> int:
    """Return C(P)=det(I-wedge^2 A_P), an exact integer."""
    compound = exterior_square(companion(polynomial))
    identity_minus = [
        [int(row == column) - compound[row][column]
         for column in range(len(compound))]
        for row in range(len(compound))
    ]
    return bareiss_determinant(identity_minus)


def reversal_resultant(polynomial: tuple[int, ...]) -> int:
    """Res(P,P*) using descending inputs expected by exact_polynomial."""
    return resultant(list(reversed(polynomial)), list(polynomial))


def cross_reversal_resultant(
    left: tuple[int, ...], right: tuple[int, ...]
) -> int:
    """Res(left,right*), with both source polynomials stored ascending."""
    return resultant(list(reversed(left)), list(right))


def mod_trim(polynomial: tuple[int, ...], prime: int) -> tuple[int, ...]:
    return trim(tuple(coefficient % prime for coefficient in polynomial))


def mod_remainder(
    dividend: tuple[int, ...], divisor: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    work = list(mod_trim(dividend, prime))
    divisor = mod_trim(divisor, prime)
    inverse = pow(divisor[-1], -1, prime)
    while len(work) >= len(divisor) and any(work):
        shift = len(work) - len(divisor)
        scale = work[-1] * inverse % prime
        for index, coefficient in enumerate(divisor):
            work[index + shift] = (
                work[index + shift] - scale * coefficient
            ) % prime
        work = list(mod_trim(tuple(work), prime))
    return tuple(work)


def mod_gcd(
    left: tuple[int, ...], right: tuple[int, ...], prime: int
) -> tuple[int, ...]:
    left = mod_trim(left, prime)
    right = mod_trim(right, prime)
    while right != (0,):
        left, right = right, mod_remainder(left, right, prime)
    inverse = pow(left[-1], -1, prime)
    return tuple(coefficient * inverse % prime for coefficient in left)


def mod_multiply(
    left: tuple[int, ...],
    right: tuple[int, ...],
    modulus: tuple[int, ...],
    prime: int,
) -> tuple[int, ...]:
    product = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            product[i + j] = (product[i + j] + x * y) % prime
    remainder = mod_remainder(tuple(product), modulus, prime)
    degree = len(modulus) - 1
    return remainder + (0,) * (degree - len(remainder))


def power_table(
    order: int, modulus: tuple[int, ...], prime: int
) -> list[tuple[int, ...]]:
    degree = len(modulus) - 1
    one = (1,) + (0,) * (degree - 1)
    x = (0, 1) + (0,) * max(0, degree - 2)
    table = [one]
    for _ in range(1, order):
        table.append(mod_multiply(table[-1], x, modulus, prime))
    assert mod_multiply(table[-1], x, modulus, prime) == one
    assert all(table[proper] != one for proper in range(1, order))
    return table


def syndrome_from_counts(
    counts: tuple[int, ...],
    table: list[tuple[int, ...]],
    prime: int,
) -> tuple[int, ...]:
    """Evaluate sum counts[a] x^a in a finite polynomial quotient."""
    assert len(counts) == len(table)
    answer = [0] * len(table[0])
    for count, power in zip(counts, table):
        for index, coefficient in enumerate(power):
            answer[index] = (answer[index] + count * coefficient) % prime
    return tuple(answer)


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


def prefix_counts(primes: list[int], order: int) -> tuple[int, ...]:
    counts = [0] * order
    for prime in primes:
        counts[(prime - 2) % order] += 1
    return tuple(counts)


def q1_closed_collision_syndrome(residue_counts: list[int]) -> tuple[int, int]:
    """Equations (4.3), with counts in prime classes 1,3,5,7 mod 8."""
    assert len(residue_counts) == 4
    m1, m3, m5, m7 = residue_counts
    return (
        (1 + 3 * m1 + 4 * m5) % 7,
        (6 * m1 + m3 + m5 + 6 * m7) % 7,
    )


def q1_full_remainder(
    primes: list[int], characteristic: int
) -> tuple[int, ...]:
    """Streaming F_X remainder in F_characteristic[x]/(q1)."""
    # A finite upper bound suffices to build powers for these named prefixes;
    # no multiplicative-order assertion is made here.
    max_exponent = primes[-1] - 2
    degree = len(Q1) - 1
    one = (1,) + (0,) * (degree - 1)
    x = (0, 1) + (0,) * (degree - 2)
    power = one
    wanted = {prime - 2 for prime in primes}
    answer = [0] * degree
    for exponent in range(max_exponent + 1):
        if exponent in wanted:
            for index, coefficient in enumerate(power):
                answer[index] = (
                    answer[index] + coefficient
                ) % characteristic
        power = mod_multiply(power, x, Q1, characteristic)
    return tuple(answer)


def replay() -> dict[str, object]:
    # The universal square law and the q1 charge.
    q1_charge = charge(Q1)
    assert q1_charge == -7
    q1_resultant = reversal_resultant(Q1)
    square_law_rhs = (
        (-1) ** (len(Q1) - 1)
        * evaluate(Q1, 1)
        * evaluate(Q1, -1)
        * q1_charge**2
    )
    assert q1_resultant == square_law_rhs == 735

    # Planted factorization control.  A deliberately corrupted charge is
    # rejected before the genuine conservation identity is accepted.
    planted_product = multiply(Q1, F5)
    product_charge = charge(planted_product)
    f5_charge = charge(F5)
    cross_charge = cross_reversal_resultant(Q1, F5)
    conservation_rhs = q1_charge * f5_charge * cross_charge
    assert q1_charge + 1 != -7  # planted false charge
    assert product_charge != (q1_charge + 1) * f5_charge * cross_charge
    assert product_charge == conservation_rhs == 728
    assert product_charge % q1_charge == 0

    # The cross-index collision polynomial and its exact order-eight table.
    collision_gcd = mod_gcd(Q1, tuple(reversed(Q1)), 7)
    assert collision_gcd == H7
    table7 = power_table(8, H7, 7)
    assert [table7[index] for index in (1, 3, 5, 7)] == [
        (0, 1), (4, 1), (0, 6), (3, 6)
    ]

    # Generic syndrome controls.  The first abstract counter state is a
    # planted zero; one increment is a planted false state and must reject.
    accepting_counts = (1, 0, 0, 5, 0, 5, 0, 0)
    rejecting_counts = list(accepting_counts)
    rejecting_counts[1] += 1
    assert syndrome_from_counts(accepting_counts, table7, 7) == (0, 0)
    assert syndrome_from_counts(tuple(rejecting_counts), table7, 7) != (0, 0)

    fixed_prefixes: dict[str, object] = {}
    assert primes_through(20) == [2, 3, 5, 7, 11, 13, 17, 19]
    for cutoff, expected_count, expected_syndrome in (
        (71, 20, (3, 5)),
        (2467, 365, (0, 0)),
    ):
        primes = primes_through(cutoff)
        assert len(primes) == expected_count and primes[-1] == cutoff
        counts8 = prefix_counts(primes, 8)
        syndrome = syndrome_from_counts(
            tuple(count % 7 for count in counts8), table7, 7
        )
        assert syndrome == expected_syndrome
        residue_counts = [
            sum(1 for prime in primes if prime > 2 and prime % 8 == residue)
            for residue in (1, 3, 5, 7)
        ]
        assert residue_counts == [counts8[(residue - 2) % 8]
                                  for residue in (1, 3, 5, 7)]
        assert q1_closed_collision_syndrome(residue_counts) == syndrome
        fixed_prefixes[str(cutoff)] = {
            "prime_count": len(primes),
            "endpoint_class_mod_15": len(primes) % 15,
            "odd_prime_counts_mod_8_classes_1_3_5_7": residue_counts,
            "collision_syndrome_basis_1_x": list(syndrome),
        }

    # The genuine prefix 2467 passes the cheap collision state but is killed
    # by the full q1 remainder modulo 13.  This is a negative boundary, not a
    # global scan or an all-X claim.
    primes2467 = primes_through(2467)
    remainder13 = q1_full_remainder(primes2467, 13)
    assert remainder13 == (0, 10, 4, 10, 12, 2, 7, 9, 12, 9)
    direct_prefix = [0] * (primes2467[-1] - 1)
    for prime in primes2467:
        direct_prefix[prime - 2] = 1
    direct_remainder13 = mod_remainder(tuple(direct_prefix), Q1, 13)
    direct_remainder13 += (0,) * (10 - len(direct_remainder13))
    assert direct_remainder13 == remainder13
    assert any(remainder13)
    fixed_prefixes["2467"]["full_q1_remainder_mod_13"] = list(remainder13)
    fixed_prefixes["2467"]["q1_divisibility_excluded"] = True

    report: dict[str, object] = {
        "experiment": "exp50_cross_reversal_charge",
        "claim": {
            "certifies": (
                "the exact compound charge, its factorization law, and the "
                "q1 mod-7 collision syndrome"
            ),
            "does_not_certify": (
                "q1 is excluded at every prime cutoff or that prime-prefix "
                "states are uniformly distributed"
            ),
        },
        "q1": {
            "ascending_coefficients": list(Q1),
            "charge": q1_charge,
            "reversal_resultant": q1_resultant,
            "collision_gcd_mod_7": list(collision_gcd),
            "collision_order": 8,
        },
        "planted_factorization_control": {
            "right_factor": "x^3+x+1",
            "product_charge": product_charge,
            "left_charge": q1_charge,
            "right_charge": f5_charge,
            "cross_resultant": cross_charge,
            "corrupted_left_charge_rejected": q1_charge + 1,
        },
        "syndrome_controls": {
            "accepting_counts_exponents_0_through_7": list(accepting_counts),
            "one_increment_mutation_rejected": rejecting_counts,
        },
        "fixed_prefix_falsifiers": fixed_prefixes,
    }
    canonical = json.dumps(report, sort_keys=True, separators=(",", ":")).encode()
    report["sha256_without_digest"] = sha256(canonical).hexdigest()
    return report


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2, sort_keys=True))

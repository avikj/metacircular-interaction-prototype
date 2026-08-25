#!/usr/bin/env python3
"""Exact replay for the sharp nonreciprocal-decic frontier witness.

The script derives the pair-aware coefficient and Graeffe boxes using exact
rational enclosures, then certifies q1=x^10+x^8+x^2+x+1.  It performs no
candidate enumeration and makes no prime-prefix divisibility claim.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp48 is an exact replay and forbids python -O")

from fractions import Fraction as Q
import json

from exact_polynomial import (
    poly_add,
    poly_multiply,
    poly_power,
    real_root_count,
    resultant,
    routh_right_half_plane,
)


DEGREE = 10
WITNESS = [1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1]  # ascending

COEFFICIENT_BOUNDS_DESCENDING = (10, 51, 142, 257, 312, 258, 144, 51, 10)
GRAEFFE_BOUNDS_ASCENDING = (13, 78, 248, 477, 581, 456, 231, 72, 12)

# Exact brackets for A=sqrt(2), B=(sqrt(5)-1)/2, C=(3+sqrt(5))/4.
RADIUS_LOWER = (Q(1_414_213, 1_000_000), Q(618_033, 1_000_000),
                Q(1_309_016, 1_000_000))
RADIUS_UPPER = (Q(1_414_214, 1_000_000), Q(618_034, 1_000_000),
                Q(1_309_017, 1_000_000))


def multiply_scalar_polynomials(left: list[Q], right: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] += x * y
    return answer


def vertex_majorant(radii: tuple[Q, Q, Q], squared: bool) -> list[Q]:
    a, b, c = radii
    pair_radii = (a, a, b, b, c)
    polynomial = [Q(1)]
    for radius in pair_radii:
        if squared:
            radius *= radius
        polynomial = multiply_scalar_polynomials(polynomial, [Q(1), radius])
        polynomial = multiply_scalar_polynomials(polynomial, [Q(1), radius])
    assert len(polynomial) == DEGREE + 1
    return polynomial


def verify_radical_brackets() -> None:
    a0, b0, c0 = RADIUS_LOWER
    a1, b1, c1 = RADIUS_UPPER
    assert a0 * a0 < 2 < a1 * a1
    assert (2 * b0 + 1) ** 2 < 5 < (2 * b1 + 1) ** 2
    assert (4 * c0 - 3) ** 2 < 5 < (4 * c1 - 3) ** 2


def verify_floor_intervals(
    lower: list[Q], upper: list[Q], expected: tuple[int, ...]
) -> None:
    assert len(lower) == len(upper) == len(expected)
    for low, high, integer in zip(lower, upper, expected):
        assert Q(integer) < low < high < Q(integer + 1)


def verify_continuous_boxes() -> dict[str, object]:
    verify_radical_brackets()

    coefficient_lower = vertex_majorant(RADIUS_LOWER, False)[1:-1]
    coefficient_upper = vertex_majorant(RADIUS_UPPER, False)[1:-1]
    verify_floor_intervals(
        coefficient_lower,
        coefficient_upper,
        COEFFICIENT_BOUNDS_DESCENDING,
    )

    graeffe_lower_descending = vertex_majorant(RADIUS_LOWER, True)[1:-1]
    graeffe_upper_descending = vertex_majorant(RADIUS_UPPER, True)[1:-1]
    graeffe_expected_descending = tuple(reversed(GRAEFFE_BOUNDS_ASCENDING))
    verify_floor_intervals(
        graeffe_lower_descending,
        graeffe_upper_descending,
        graeffe_expected_descending,
    )

    # A coarser exact bracket is enough for the endpoint integer cap.
    a, b, c = (Q(14_143, 10_000), Q(6_181, 10_000), Q(13_091, 10_000))
    assert a * a > 2
    assert (2 * b + 1) ** 2 > 5
    assert (4 * c - 3) ** 2 > 5
    endpoint_upper = (1 + a) ** 4 * (1 + b) ** 4 * (1 + c) ** 2
    assert endpoint_upper < 1242

    return {
        "coefficient_x9_through_x1": list(COEFFICIENT_BOUNDS_DESCENDING),
        "coefficient_x1_through_x9": list(reversed(COEFFICIENT_BOUNDS_DESCENDING)),
        "graeffe_y1_through_y9": list(GRAEFFE_BOUNDS_ASCENDING),
        "endpoint_integer_cap": 1241,
    }


def cayley_polynomial(polynomial: list[int], radius: Q) -> list[Q]:
    answer = [Q(0)]
    for exponent, coefficient in enumerate(polynomial):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    assert len(answer) == DEGREE + 1
    return answer


def roots_in_disk(polynomial: list[int], radius: Q) -> int:
    count = routh_right_half_plane(cayley_polynomial(polynomial, radius))
    assert count is not None
    return count


def mod_trim(polynomial: list[int], prime: int) -> list[int]:
    answer = [value % prime for value in polynomial]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def mod_remainder(
    dividend: list[int], divisor: list[int], prime: int
) -> list[int]:
    answer = mod_trim(dividend, prime)
    divisor = mod_trim(divisor, prime)
    inverse = pow(divisor[-1], -1, prime)
    while len(answer) >= len(divisor) and answer != [0]:
        shift = len(answer) - len(divisor)
        scale = answer[-1] * inverse % prime
        for index, value in enumerate(divisor):
            answer[index + shift] -= scale * value
        answer = mod_trim(answer, prime)
    return answer


def mod_gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    while mod_trim(right, prime) != [0]:
        left, right = right, mod_remainder(left, right, prime)
    answer = mod_trim(left, prime)
    inverse = pow(answer[-1], -1, prime)
    return [(inverse * value) % prime for value in answer]


def mod_multiply(
    left: list[int], right: list[int], modulus: list[int], prime: int
) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = (answer[i + j] + x * y) % prime
    return mod_remainder(answer, modulus, prime)


def mod_power(
    base: list[int], exponent: int, modulus: list[int], prime: int
) -> list[int]:
    answer = [1]
    while exponent:
        if exponent & 1:
            answer = mod_multiply(answer, base, modulus, prime)
        base = mod_multiply(base, base, modulus, prime)
        exponent //= 2
    return answer


def mod_subtract_x(polynomial: list[int], prime: int) -> list[int]:
    answer = polynomial[:]
    while len(answer) < 2:
        answer.append(0)
    answer[1] -= 1
    return mod_trim(answer, prime)


def rabin_degree_ten(polynomial: list[int], prime: int) -> dict[str, list[int]]:
    modulus = mod_trim(polynomial, prime)
    assert len(modulus) == DEGREE + 1
    x = [0, 1]
    tests: dict[str, list[int]] = {}
    for divisor in (2, 5):
        exponent = DEGREE // divisor
        difference = mod_subtract_x(
            mod_power(x, prime**exponent, modulus, prime), prime
        )
        gcd = mod_gcd(modulus, difference, prime)
        assert gcd == [1]
        tests[f"gcd_q_x^{prime}^{exponent}_minus_x"] = gcd
    final = mod_subtract_x(mod_power(x, prime**DEGREE, modulus, prime), prime)
    assert final == [0]
    tests[f"x^{prime}^{DEGREE}_minus_x_mod_q"] = final
    return tests


def first_graeffe(polynomial: list[int]) -> list[int]:
    even = polynomial[0::2]
    odd = polynomial[1::2]
    answer = poly_add(
        poly_multiply(even, even),
        [0] + [-value for value in poly_multiply(odd, odd)],
    )
    assert all(value.denominator == 1 for value in answer)
    return [int(value) for value in answer]


def evaluate_integer(polynomial: list[int], value: int) -> int:
    return sum(coefficient * value**exponent
               for exponent, coefficient in enumerate(polynomial))


def verify_witness() -> dict[str, object]:
    q = WITNESS
    assert len(q) == DEGREE + 1 and q[0] == q[-1] == 1
    assert q != list(reversed(q))
    assert all(
        abs(value) <= bound
        for value, bound in zip(reversed(q[1:-1]), COEFFICIENT_BOUNDS_DESCENDING)
    )

    even, odd = q[0::2], q[1::2]
    parity_resultant = resultant(list(reversed(even)), list(reversed(odd)))
    assert parity_resultant == 1
    endpoints = {"q(-1)": evaluate_integer(q, -1), "q(1)": evaluate_integer(q, 1)}
    assert endpoints == {"q(-1)": 3, "q(1)": 5}

    real_roots = real_root_count(list(map(Q, q)))
    disks = {
        "4/5": roots_in_disk(q, Q(4, 5)),
        "1": roots_in_disk(q, Q(1)),
        "6/5": roots_in_disk(q, Q(6, 5)),
    }
    assert real_roots == 0
    assert disks == {"4/5": 0, "1": 4, "6/5": 10}

    graeffe = first_graeffe(q)
    assert graeffe == [1, 1, 1, 0, 2, 4, 2, 0, 1, 2, 1]
    assert all(
        abs(value) <= bound
        for value, bound in zip(graeffe[1:-1], GRAEFFE_BOUNDS_ASCENDING)
    )

    rabin17 = rabin_degree_ten(q, 17)

    # 2H and K in ascending T order.  Scaling the first polynomial divides
    # the degree-three resultant by 2^3.
    twice_h = [2, 4, -4, -8, 1, 2]
    k = [0, 2, 0, -1]
    scaled_trace_resultant = resultant(list(reversed(twice_h)), list(reversed(k)))
    assert scaled_trace_resultant % 8 == 0
    cross_index = scaled_trace_resultant // 8
    assert cross_index == -7
    reversal_resultant = resultant(list(reversed(q)), q)
    assert reversal_resultant == 735
    assert reversal_resultant == endpoints["q(-1)"] * endpoints["q(1)"] * cross_index**2

    derivative = [exponent * q[exponent] for exponent in range(1, len(q))]
    collision_mod7 = mod_gcd(q, list(reversed(q)), 7)
    discriminant_mod7 = mod_gcd(q, derivative, 7)
    assert collision_mod7 == [1, 4, 1]
    assert discriminant_mod7 == [1]

    return {
        "ascending_coefficients": q,
        "nonreciprocal": True,
        "positive_on_R": "x^10+x^8+(x^2+x+1)>0",
        "parity_resultant": parity_resultant,
        "endpoint_values": endpoints,
        "necessary_prime_count_class": "pi(X) = 5 (mod 15)",
        "real_root_count": real_roots,
        "roots_in_open_disks": disks,
        "unit_disk_topology": "4 inside, 6 outside",
        "first_graeffe_ascending": graeffe,
        "irreducible_mod_17_rabin": rabin17,
        "cross_index_L": cross_index,
        "reversal_resultant": reversal_resultant,
        "mod_7": {
            "gcd_q_qstar": collision_mod7,
            "gcd_q_derivative": discriminant_mod7,
            "interpretation": "reversal collision, not ramification",
        },
        "irreducible_over_Q": True,
    }


def main() -> None:
    report = {
        "experiment": "exp48_nonreciprocal_decic_frontier",
        "arithmetic": "exact rational/integer decisions only",
        "continuous_relaxation_boxes": verify_continuous_boxes(),
        "witness": verify_witness(),
        "scope": {
            "certifies": "q1 passes the sharp support-local necessary filters",
            "does_not_certify": "q1 divides any prime-prefix polynomial F_X",
            "enumeration": False,
        },
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()

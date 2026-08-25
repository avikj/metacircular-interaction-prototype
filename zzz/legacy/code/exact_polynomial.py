"""Small exact univariate-polynomial kernel for certificate scripts.

All coefficient lists are ascending unless a function explicitly says
otherwise.  This module contains no experiment constants, candidate counts,
or certificate main routine.
"""

from __future__ import annotations

from fractions import Fraction as Q


def trim(polynomial: list[Q]) -> list[Q]:
    while len(polynomial) > 1 and polynomial[-1] == 0:
        polynomial.pop()
    return polynomial


def derivative(polynomial: list[Q]) -> list[Q]:
    if len(polynomial) <= 1:
        return [Q(0)]
    return [Q(index) * polynomial[index] for index in range(1, len(polynomial))]


def evaluate(polynomial: list[Q], value: Q) -> Q:
    answer = Q(0)
    for coefficient in reversed(polynomial):
        answer = answer * value + coefficient
    return answer


def divmod_poly(dividend: list[Q], divisor: list[Q]) -> tuple[list[Q], list[Q]]:
    dividend = trim(dividend[:])
    divisor = trim(divisor[:])
    if divisor == [0]:
        raise ZeroDivisionError("polynomial division by zero")
    if len(dividend) < len(divisor):
        return [Q(0)], dividend
    quotient = [Q(0)] * (len(dividend) - len(divisor) + 1)
    while len(dividend) >= len(divisor) and dividend != [0]:
        shift = len(dividend) - len(divisor)
        coefficient = dividend[-1] / divisor[-1]
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            dividend[shift + index] -= coefficient * value
        trim(dividend)
    return trim(quotient), trim(dividend)


def sturm_chain(polynomial: list[Q]) -> list[list[Q]]:
    polynomial = trim(polynomial[:])
    chain = [polynomial, trim(derivative(polynomial))]
    while chain[-1] != [0]:
        _, remainder = divmod_poly(chain[-2], chain[-1])
        if remainder == [0]:
            break
        chain.append([-value for value in remainder])
    return chain


def sign(value: Q) -> int:
    return (value > 0) - (value < 0)


def variations(signs: list[int]) -> int:
    nonzero = [value for value in signs if value]
    return sum(left != right for left, right in zip(nonzero, nonzero[1:]))


def variations_at_infinity(chain: list[list[Q]], positive: bool) -> int:
    signs = []
    for polynomial in chain:
        leading_sign = sign(polynomial[-1])
        if not positive and (len(polynomial) - 1) % 2:
            leading_sign = -leading_sign
        signs.append(leading_sign)
    return variations(signs)


def real_root_count(polynomial: list[Q]) -> int:
    chain = sturm_chain(polynomial)
    return variations_at_infinity(chain, False) - variations_at_infinity(chain, True)


def bareiss_determinant(matrix: list[list[int]]) -> int:
    """Fraction-free exact determinant."""
    work = [row[:] for row in matrix]
    size = len(work)
    if size == 0:
        return 1
    previous = 1
    parity = 1
    for pivot_index in range(size - 1):
        if work[pivot_index][pivot_index] == 0:
            pivot_row = next(
                (row for row in range(pivot_index + 1, size)
                 if work[row][pivot_index]),
                None,
            )
            if pivot_row is None:
                return 0
            work[pivot_index], work[pivot_row] = work[pivot_row], work[pivot_index]
            parity = -parity
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
    return parity * work[-1][-1]


def resultant(first_descending: list[int], second_descending: list[int]) -> int:
    """Sylvester resultant; both inputs use descending coefficients."""
    first_degree = len(first_descending) - 1
    second_degree = len(second_descending) - 1
    sylvester = []
    for shift in range(second_degree):
        sylvester.append(
            [0] * shift + first_descending + [0] * (second_degree - 1 - shift)
        )
    for shift in range(first_degree):
        sylvester.append(
            [0] * shift + second_descending + [0] * (first_degree - 1 - shift)
        )
    return bareiss_determinant(sylvester)


def poly_add(first: list[Q], second: list[Q]) -> list[Q]:
    answer = [Q(0)] * max(len(first), len(second))
    for index, value in enumerate(first):
        answer[index] += value
    for index, value in enumerate(second):
        answer[index] += value
    return answer


def poly_multiply(first: list[Q], second: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(first) + len(second) - 1)
    for i, left in enumerate(first):
        for j, right in enumerate(second):
            answer[i + j] += left * right
    return answer


def poly_power(polynomial: list[Q], exponent: int) -> list[Q]:
    answer = [Q(1)]
    for _ in range(exponent):
        answer = poly_multiply(answer, polynomial)
    return answer


def sign_changes(values: list[Q]) -> int:
    signs = [sign(value) for value in values]
    assert 0 not in signs
    return sum(left != right for left, right in zip(signs, signs[1:]))


def routh_right_half_plane(polynomial_ascending: list[Q]) -> int | None:
    """Return the exact right-half-plane root count, or None if degenerate."""
    coefficients = list(reversed(polynomial_ascending))
    degree = len(coefficients) - 1
    width = (degree + 2) // 2
    table = [[Q(0)] * width for _ in range(degree + 1)]
    table[0][:len(coefficients[0::2])] = coefficients[0::2]
    table[1][:len(coefficients[1::2])] = coefficients[1::2]
    if table[0][0] == 0 or table[1][0] == 0:
        return None
    for row in range(2, degree + 1):
        previous_previous = table[row - 2]
        previous = table[row - 1]
        if previous[0] == 0:
            return None
        for column in range(width - 1):
            table[row][column] = (
                previous[0] * previous_previous[column + 1]
                - previous_previous[0] * previous[column + 1]
            ) / previous[0]
        if all(value == 0 for value in table[row]):
            return None
    return sign_changes([row[0] for row in table])

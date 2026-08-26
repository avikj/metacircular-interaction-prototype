#!/usr/bin/env python3
"""Exact regression checks for the reciprocal parity-resultant theorem.

For a reciprocal monic polynomial g of even degree, split

    g(x) = E(x^2) + x O(x^2).

After the Joukowski substitution T=y+y^{-1}, the resultant Res(E,O)
is a distinguished evaluation times a square.  The accompanying proof is
in ``notes/RECIPROCAL_RESULTANT.md``.  This script checks the identity with
integer arithmetic on deterministic random examples in degrees 4, 6, 8,
10, 12, and 14, including degree drops in the odd part.
"""

from __future__ import annotations

from random import Random

from exp30_quartic_certificate import resultant


def trim_ascending(polynomial: list[int]) -> list[int]:
    answer = polynomial[:]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def add(left: list[int], right: list[int]) -> list[int]:
    answer = [0] * max(len(left), len(right))
    for index, value in enumerate(left):
        answer[index] += value
    for index, value in enumerate(right):
        answer[index] += value
    return trim_ascending(answer)


def multiply(left: list[int], right: list[int]) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] += x * y
    return trim_ascending(answer)


def evaluate(polynomial: list[int], value: int) -> int:
    answer = 0
    for coefficient in reversed(polynomial):
        answer = answer * value + coefficient
    return answer


def divide_by_y_plus_one(polynomial: list[int]) -> list[int]:
    """Exact division by y+1, preserving the nominal quotient degree."""
    quotient = [0] * (len(polynomial) - 1)
    carry = polynomial[-1]
    quotient[-1] = carry
    for exponent in range(len(polynomial) - 2, 0, -1):
        carry = polynomial[exponent] - carry
        quotient[exponent - 1] = carry
    assert polynomial[0] == quotient[0]
    return quotient


def chebyshev_traces(maximum: int) -> list[list[int]]:
    """C_j(T)=y^j+y^{-j}, with C_0=2 and C_1=T."""
    traces = [[2]]
    if maximum == 0:
        return traces
    traces.append([0, 1])
    for _ in range(2, maximum + 1):
        traces.append(
            add(multiply([0, 1], traces[-1]), [-x for x in traces[-2]])
        )
    return traces


def compress_even_reciprocal(polynomial: list[int]) -> list[int]:
    """Return A with R(y)=y^m A(y+y^{-1}), retaining nominal zeros."""
    degree = len(polynomial) - 1
    assert degree % 2 == 0
    assert polynomial == list(reversed(polynomial))
    middle = degree // 2
    traces = chebyshev_traces(middle)
    answer = [polynomial[middle]]
    for offset in range(1, middle + 1):
        answer = add(
            answer,
            [polynomial[middle + offset] * value for value in traces[offset]],
        )
    return trim_ascending(answer)


def exact_resultant(left: list[int], right: list[int]) -> int:
    left = trim_ascending(left)
    right = trim_ascending(right)
    if left == [0] or right == [0]:
        return 0
    return resultant(list(reversed(left)), list(reversed(right)))


def reciprocal_polynomial(degree: int, rng: Random) -> list[int]:
    assert degree % 2 == 0
    answer = [0] * (degree + 1)
    answer[0] = answer[-1] = 1
    for exponent in range(1, degree // 2 + 1):
        value = rng.randint(-3, 3)
        answer[exponent] = answer[degree - exponent] = value
    return answer


def check_identity(g: list[int]) -> None:
    degree = len(g) - 1
    even = g[0::2]
    odd = g[1::2]
    direct = exact_resultant(even, odd)

    if degree % 4 == 0:
        k = degree // 4
        assert len(even) - 1 == 2 * k
        a_polynomial = compress_even_reciprocal(even)
        if all(value == 0 for value in odd):
            predicted = 0
        else:
            quotient = divide_by_y_plus_one(odd)
            b_polynomial = compress_even_reciprocal(quotient)
            predicted = evaluate(even, -1) * exact_resultant(
                a_polynomial, b_polynomial
            ) ** 2
    else:
        k = (degree - 2) // 4
        quotient = divide_by_y_plus_one(even)
        a_polynomial = compress_even_reciprocal(quotient)
        b_polynomial = compress_even_reciprocal(odd)
        predicted = (
            (-1) ** k
            * evaluate(b_polynomial, -2)
            * exact_resultant(a_polynomial, b_polynomial) ** 2
        )

    assert direct == predicted, (g, direct, predicted)


def main() -> None:
    rng = Random(20260811)
    counts = {}
    for degree in (4, 6, 8, 10, 12, 14):
        examples = 500
        for _ in range(examples):
            check_identity(reciprocal_polynomial(degree, rng))
        counts[degree] = examples

    # Explicit degree drops, including the a=0 reciprocal-octic case.
    check_identity([1, 0, 2, -1, 3, -1, 2, 0, 1])
    check_identity([1, 0, 2, 0, 3, 0, 2, 0, 1])

    print("reciprocal parity-resultant identities: PASS")
    print(f"exact random examples by degree: {counts}")
    print("explicit degree-drop examples: PASS")


if __name__ == "__main__":
    main()

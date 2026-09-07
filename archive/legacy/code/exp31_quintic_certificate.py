#!/usr/bin/env python3
"""Exact certificate classifying quintic factors of prime-prefix polynomials.

This script depends only on the exact polynomial primitives in
``exp30_quartic_certificate.py``.  All assertions use integers or Fraction;
floating point is used only to print a decimal safety margin.
"""

from __future__ import annotations

from fractions import Fraction
from time import perf_counter

from exp30_quartic_certificate import (
    Q,
    divmod_poly,
    evaluate,
    real_root_count,
    resultant,
)


# Only these cutoffs are needed: after 13 the all-odd geometric tail is
# used as a rigorous majorant for every later prime contribution.
PRIMES = (2, 3, 5, 7, 11, 13)
CUTOFFS = (5, 7, 11, 13)


EXPECTED_CANDIDATES = {
    (-5, 6, 5, 1),
    (-4, 5, 4, 1),
    (-3, 4, 3, 1),
    (-2, 3, 2, 1),
    (-1, 1, -1, 0),
    (-1, 2, 1, 1),
    (0, 1, 0, 1),
    (0, 3, 0, 0),
    (0, 6, 0, -1),
    (0, 8, 0, -2),
    (0, 9, 0, -2),
    (0, 10, 0, -3),
    (0, 11, 0, -3),
    (0, 12, 0, -4),
    (0, 13, 0, -4),
    (1, 0, -1, 1),
    (1, 4, 3, 2),
    (2, 0, -3, 0),
}

EXPECTED_NEGATIVE = {
    5: set(),
    7: {
        (-1, 1, -1, 0),
        (0, 3, 0, 0),
        (0, 8, 0, -2),
        (0, 10, 0, -3),
        (0, 12, 0, -4),
        (0, 13, 0, -4),
        (1, 0, -1, 1),
        (2, 0, -3, 0),
    },
    11: {
        (-1, 2, 1, 1),
        (0, 6, 0, -1),
        (0, 11, 0, -3),
    },
    13: {(-2, 3, 2, 1)},
}

EXPECTED_BELOW = {
    (-5, 6, 5, 1),
    (-4, 5, 4, 1),
    (-3, 4, 3, 1),
    (0, 9, 0, -2),
    (1, 4, 3, 2),
}

EXPECTED_ZERO = {((0, 1, 0, 1), 7)}


def sign_a_plus_b_lambda(a: int, b: int) -> int:
    """Sign of a+b*lambda, lambda=(sqrt(5)-1)/2, exactly."""
    # 2(a+b*lambda) = (2a-b) + b*sqrt(5).
    u = 2 * a - b
    if b == 0:
        return (u > 0) - (u < 0)
    if b > 0:
        if u >= 0:
            return 1
        return (5 * b * b > u * u) - (5 * b * b < u * u)
    if u <= 0:
        return -1
    return (u * u > 5 * b * b) - (u * u < 5 * b * b)


def h_polynomial(a: int, b: int, c: int, d: int) -> list[Q]:
    """h(t)=g(-t), ascending coefficients."""
    return [Q(1), Q(-d), Q(c), Q(-b), Q(a), Q(-1)]


def h_at_lambda_sign(a: int, b: int, c: int, d: int) -> int:
    # lambda^2=1-lambda, lambda^3=2lambda-1,
    # lambda^4=2-3lambda, lambda^5=5lambda-3.
    rational = 4 + 2 * a + b + c
    lambda_coefficient = -d - c - 2 * b - 3 * a - 5
    return sign_a_plus_b_lambda(rational, lambda_coefficient)


def reducible_quintic(a: int, b: int, c: int, d: int) -> bool:
    """Exact 1+4 / 2+3 factor test in the root-bounded candidate box."""
    g = [Q(1), Q(d), Q(c), Q(b), Q(a), Q(1)]
    if evaluate(g, Q(1)) == 0 or evaluate(g, Q(-1)) == 0:
        return True

    # A quadratic factor is x^2+u*x+s, s=+-1.  Its two roots are roots
    # of the Newman polynomial and have modulus <2, so |u|<4.
    for s in (1, -1):
        for u in range(-3, 4):
            _, remainder = divmod_poly(g, [Q(s), Q(u), Q(1)])
            if remainder == [0]:
                return True
    return False


def signed_prefix_at_negative_root(cutoff: int) -> list[Q]:
    """F_cutoff(-t)=1-sum_{3<=p<=cutoff}t^(p-2), ascending."""
    degree = cutoff - 2
    answer = [Q(0)] * (degree + 1)
    answer[0] = Q(1)
    for p in PRIMES:
        if 3 <= p <= cutoff:
            answer[p - 2] = Q(-1)
    return answer


def prime_prefix_desc(cutoff: int) -> list[int]:
    degree = cutoff - 2
    exponents = {p - 2 for p in PRIMES if p <= cutoff}
    return [int(exponent in exponents) for exponent in range(degree, -1, -1)]


SIGNED_PREFIX = {q: signed_prefix_at_negative_root(q) for q in CUTOFFS}
PREFIX_DESC = {q: prime_prefix_desc(q) for q in CUTOFFS}


def isolate_t(h: list[Q], steps: int = 24) -> tuple[Q, Q]:
    """Isolate the unique root t in (3/5,2/3) by exact bisection."""
    lower = Q(3, 5)
    upper = Q(2, 3)
    assert evaluate(h, lower) > 0
    assert evaluate(h, upper) < 0
    for _ in range(steps):
        middle = (lower + upper) / 2
        value = evaluate(h, middle)
        if value > 0:
            lower = middle
        elif value < 0:
            upper = middle
        else:
            return middle, middle
    return lower, upper


def refine_t(h: list[Q], lower: Q, upper: Q) -> tuple[Q, Q]:
    middle = (lower + upper) / 2
    value = evaluate(h, middle)
    if value > 0:
        return middle, upper
    if value < 0:
        return lower, middle
    return middle, middle


def prefix_sign_at_t(
    triple: tuple[int, int, int, int], cutoff: int
) -> tuple[int, tuple[Q, Q]]:
    """Exact sign of F_cutoff(-t), exploiting its strict decrease in t."""
    a, b, c, d = triple
    g_desc = [1, a, b, c, d, 1]
    res = resultant(g_desc, PREFIX_DESC[cutoff])
    if res == 0:
        return 0, (Q(0), Q(0))

    h = h_polynomial(a, b, c, d)
    lower, upper = isolate_t(h)
    polynomial = SIGNED_PREFIX[cutoff]
    for _ in range(300):
        # F_q(-s) is strictly decreasing for s>0.
        if evaluate(polynomial, lower) < 0:
            return -1, (lower, upper)
        if evaluate(polynomial, upper) > 0:
            return 1, (lower, upper)
        lower, upper = refine_t(h, lower, upper)
    raise AssertionError((triple, cutoff, "failed to determine sign"))


def multiply(f: list[Q], g: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(f) + len(g) - 1)
    for i, x in enumerate(f):
        for j, y in enumerate(g):
            answer[i + j] += x * y
    return answer


def tail_polynomial() -> list[Q]:
    # J(t)=(1-t^2)F_13(-t)-t^15.  Positivity implies that even adding
    # every odd power t^15+t^17+... cannot reach zero.
    answer = multiply(SIGNED_PREFIX[13], [Q(1), Q(0), Q(-1)])
    if len(answer) <= 15:
        answer.extend([Q(0)] * (16 - len(answer)))
    answer[15] -= 1
    return answer


TAIL_POLYNOMIAL = tail_polynomial()


def exact_tail_margin(triple: tuple[int, int, int, int]) -> Q:
    a, b, c, d = triple
    h = h_polynomial(a, b, c, d)
    lower, upper = isolate_t(h)
    for _ in range(300):
        # On an interval where F_13(-s)>0, J'(s)<0.  Therefore J(t)>J(U).
        if (
            evaluate(SIGNED_PREFIX[13], upper) > 0
            and evaluate(TAIL_POLYNOMIAL, upper) > 0
        ):
            return evaluate(TAIL_POLYNOMIAL, upper)
        lower, upper = refine_t(h, lower, upper)
    raise AssertionError((triple, "failed to certify tail"))


def main() -> None:
    start = perf_counter()
    diophantine = []
    candidates = []

    for a in range(-5, 6):
        for b in range(-13, 14):
            for c in range(-12, 13):
                for d in range(-6, 7):
                    delta = (1 - a * d) ** 2 - (c - a * b) * (b - c * d)
                    if abs(delta) != 1:
                        continue
                    diophantine.append((a, b, c, d))

                    g = [Q(1), Q(d), Q(c), Q(b), Q(a), Q(1)]
                    h = h_polynomial(a, b, c, d)
                    if real_root_count(g) != 1:
                        continue
                    if h_at_lambda_sign(a, b, c, d) <= 0:
                        continue
                    if evaluate(h, Q(2, 3)) >= 0:
                        continue
                    assert not reducible_quintic(a, b, c, d)
                    candidates.append((a, b, c, d))

    assert len(diophantine) == 1591
    assert set(candidates) == EXPECTED_CANDIDATES
    assert len(candidates) == 18

    negative = {q: set() for q in CUTOFFS}
    below = set()
    zero = set()
    tail_margins = {}

    for triple in candidates:
        decided = False
        for cutoff in CUTOFFS:
            prefix_sign, _ = prefix_sign_at_t(triple, cutoff)
            if prefix_sign == 0:
                zero.add((triple, cutoff))
                decided = True
                break
            if prefix_sign < 0:
                negative[cutoff].add(triple)
                decided = True
                break
        if decided:
            continue

        margin = exact_tail_margin(triple)
        assert margin > 0
        below.add(triple)
        tail_margins[triple] = margin

    assert negative == EXPECTED_NEGATIVE
    assert below == EXPECTED_BELOW
    assert zero == EXPECTED_ZERO

    # The sole zero is F_7 itself.  The exact quadratic-factor test above,
    # together with absence of rational roots, certifies irreducibility.
    assert not reducible_quintic(0, 1, 0, 1)

    minimum_tail_triple = min(tail_margins, key=tail_margins.get)
    minimum_tail_margin = tail_margins[minimum_tail_triple]

    print("quintic certificate: PASS")
    print(f"D=+-1 triples: {len(diophantine)}")
    print(f"root/sign/irreducibility survivors: {len(candidates)}")
    print(
        "strict-negative groups:",
        {cutoff: len(negative[cutoff]) for cutoff in CUTOFFS},
    )
    print(f"forever-below tail certificates: {len(below)}")
    print(f"exact-zero cases: {sorted(zero)}")
    print(f"minimum tail triple: {minimum_tail_triple}")
    print(f"minimum tail margin exact: {minimum_tail_margin}")
    print(f"minimum tail margin decimal: {float(minimum_tail_margin):.12f}")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

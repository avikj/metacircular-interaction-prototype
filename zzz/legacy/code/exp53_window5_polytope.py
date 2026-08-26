#!/usr/bin/env python3
"""exp53: exact certificates for the length-five Walsh obstruction.

This is the recovered, fail-closed version of an interrupted WIP.  It uses
only integer and rational arithmetic.  It certifies the algebraic facts in
``notes/CONSTRAINT_ALGEBRA.md`` that are suitable for finite replay:

* the nine distinct affine forms and their pattern multiplicities;
* the sharp ten-zero examples at c=1/3, |a|=|b|=1/3;
* conservation of the order-four de Bruijn flow and the stationary extension;
* the complete five-window Walsh table of the countermodel;
* a direct counterexample to the flip used in the printed orbit argument; and
* four auxiliary F2[u] multiplication identities.

The continuous maximum theorem is proved from the facet classification in the
note.  No rational grid is offered as a proof of that theorem, and no finite
Liouville census is performed.
"""

from __future__ import annotations

from collections import Counter
from fractions import Fraction
from itertools import combinations, product


Q = Fraction
PATTERNS = tuple(product((1, -1), repeat=5))
FOUR_BITS = tuple(product((1, -1), repeat=4))


if not __debug__:
    raise SystemExit("exp53 requires assertions; do not run Python with -O")


def product_on(eps: tuple[int, ...], subset: tuple[int, ...]) -> int:
    result = 1
    for position in subset:
        result *= eps[position - 1]
    return result


def affine_form(eps: tuple[int, ...]) -> tuple[int, int, int, int]:
    """Coefficients of 32*mu in the ordered basis (1,a,b,c)."""
    return (
        1,
        product_on(eps, (1, 2, 3, 4)) + product_on(eps, (2, 3, 4, 5)),
        product_on(eps, (1, 3, 4, 5)) + product_on(eps, (1, 2, 3, 5)),
        product_on(eps, (1, 2, 4, 5)),
    )


def evaluate(
    form: tuple[int, int, int, int], a: Q, b: Q, c: Q
) -> Q:
    constant, ca, cb, cc = form
    return Q(constant) + ca * a + cb * b + cc * c


def density32(eps: tuple[int, ...], a: Q, b: Q, c: Q) -> Q:
    return evaluate(affine_form(eps), a, b, c)


def expected_class_forms() -> Counter[tuple[int, int, int, int]]:
    forms: Counter[tuple[int, int, int, int]] = Counter()
    # A: 1+c+2ax+2by, each (x,y) occurs twice.
    for x, y in product((1, -1), repeat=2):
        forms[(1, 2 * x, 2 * y, 1)] += 2
    # B: 1-c-2ax; C: 1-c-2by; D: 1+c.
    for x in (1, -1):
        forms[(1, -2 * x, 0, -1)] += 4
    for y in (1, -1):
        forms[(1, 0, -2 * y, -1)] += 4
    forms[(1, 0, 0, 1)] += 8
    return forms


def walsh_coefficients(
    probabilities: dict[tuple[int, ...], Q]
) -> dict[tuple[int, ...], Q]:
    result: dict[tuple[int, ...], Q] = {}
    for size in range(1, 6):
        for subset in combinations(range(1, 6), size):
            result[subset] = sum(
                mass * product_on(eps, subset)
                for eps, mass in probabilities.items()
            )
    return result


def check_class_table() -> None:
    actual = Counter(affine_form(eps) for eps in PATTERNS)
    expected = expected_class_forms()
    assert actual == expected
    assert sum(actual.values()) == 32
    print("PASS class table: 9 affine forms with multiplicities 2/4/8")


def check_sharp_countermodels() -> None:
    equality_points = []
    for sign_a, sign_b in product((1, -1), repeat=2):
        a, b, c = Q(sign_a, 3), Q(sign_b, 3), Q(1, 3)
        values = {eps: density32(eps, a, b, c) for eps in PATTERNS}
        assert min(values.values()) == 0
        assert sum(value == 0 for value in values.values()) == 10
        assert sum(values.values()) == 32
        equality_points.append((a, b, c))
    assert len(equality_points) == 4
    print("PASS sharp points: c=1/3, |a|=|b|=1/3 each have 10 zeros")


def check_stationary_extension() -> None:
    a = b = c = Q(1, 3)
    probabilities = {
        eps: density32(eps, a, b, c) / 32 for eps in PATTERNS
    }
    assert all(mass >= 0 for mass in probabilities.values())
    assert sum(probabilities.values()) == 1

    outgoing = {
        state: sum(probabilities[state + (last,)] for last in (1, -1))
        for state in FOUR_BITS
    }
    incoming = {
        state: sum(probabilities[(first,) + state] for first in (1, -1))
        for state in FOUR_BITS
    }
    expected = {
        state: (1 + a * product_on(state, (1, 2, 3, 4))) / 16
        for state in FOUR_BITS
    }
    assert outgoing == incoming == expected
    assert all(mass > 0 for mass in expected.values())

    # These are the transition probabilities of the stationary order-four
    # Markov extension; each row is stochastic exactly.
    for state in FOUR_BITS:
        row = [probabilities[state + (last,)] / expected[state]
               for last in (1, -1)]
        assert all(entry >= 0 for entry in row)
        assert sum(row) == 1

    coefficients = walsh_coefficients(probabilities)
    wanted = {
        (1, 2, 3, 4): a,
        (2, 3, 4, 5): a,
        (1, 3, 4, 5): b,
        (1, 2, 3, 5): b,
        (1, 2, 4, 5): c,
    }
    for subset, value in coefficients.items():
        assert value == wanted.get(subset, 0)

    # Planted false control: unequal consecutive coefficients destroy flow
    # conservation.  This guards against a vacuous stationarity check.
    def asymmetric_density32(eps: tuple[int, ...]) -> Q:
        return (
            1
            + Q(1, 3) * product_on(eps, (1, 2, 3, 4))
            + Q(1, 4) * product_on(eps, (2, 3, 4, 5))
        )

    asymmetric = {eps: asymmetric_density32(eps) / 32 for eps in PATTERNS}
    bad_out = {
        state: sum(asymmetric[state + (last,)] for last in (1, -1))
        for state in FOUR_BITS
    }
    bad_in = {
        state: sum(asymmetric[(first,) + state] for first in (1, -1))
        for state in FOUR_BITS
    }
    assert bad_out != bad_in
    print("PASS de Bruijn flow, Markov extension, Walsh coefficients, false control")


def check_printed_flip() -> None:
    a = b = c = Q(1, 3)
    atom = (1, 1, 1, 1, -1)
    flipped = (-atom[0], atom[1], atom[2], atom[3], -atom[4])
    assert atom[0] == -atom[4]
    assert density32(atom, a, b, c) == 0
    assert density32(flipped, a, b, c) == 0
    assert atom != flipped
    print("PASS countercontrol: the first published flip maps zero to zero")


def polynomial_multiply_f2(left: set[int], right: set[int]) -> set[int]:
    result: set[int] = set()
    for i in left:
        for j in right:
            exponent = i + j
            if exponent in result:
                result.remove(exponent)
            else:
                result.add(exponent)
    return result


def check_f2_identities() -> None:
    cases = (
        ({1, 2, 3, 4}, {0, 1}, {1, 5}),
        ({1, 2, 4, 5}, {1, 2, 3}, {2, 8}),
        ({1, 2, 3, 5}, {0, 1, 3}, {1, 8}),
        ({1, 3, 4, 5}, {0, 2, 3}, {1, 8}),
    )
    for left, right, wanted in cases:
        assert polynomial_multiply_f2(left, right) == wanted
    print("PASS four auxiliary F2[u] identities (no Liouville implication asserted)")


def main() -> None:
    check_class_table()
    check_sharp_countermodels()
    check_stationary_extension()
    check_printed_flip()
    check_f2_identities()
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()

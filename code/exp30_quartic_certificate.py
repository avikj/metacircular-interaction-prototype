#!/usr/bin/env python3
"""Exact certificate excluding quartic factors of prime-prefix polynomials.

For X >= 7 put

    F_X(x) = sum_{p <= X, p prime} x^(p-2).

The mathematical reduction (documented by the assertions below) says that an
irreducible quartic factor must be

    g(x) = x^4 + a*x^3 + b*x^2 + c*x + 1

with no real roots, |a|,|c| <= 4, -1 <= b <= 6, and

    a^2 - a*b*c + c^2 = +/- 1.

This script performs the resulting finite proof using only integer and
Fraction arithmetic:

* Sturm chains count/isolate real roots exactly;
* a cubic resolvent enforces the sharp odd-support root annulus;
* Bareiss determinants give exact Sylvester resultants;
* rational tail inequalities exclude every surviving non-cyclotomic triple.

No floating-point result is used in an assertion.
"""

from __future__ import annotations

from fractions import Fraction
from math import isqrt
from time import perf_counter


Q = Fraction


# Polynomials used by the Sturm code have ascending coefficients.
def trim(f: list[Q]) -> list[Q]:
    while len(f) > 1 and f[-1] == 0:
        f.pop()
    return f


def derivative(f: list[Q]) -> list[Q]:
    if len(f) <= 1:
        return [Q(0)]
    return [Q(i) * f[i] for i in range(1, len(f))]


def evaluate(f: list[Q], x: Q) -> Q:
    ans = Q(0)
    for coefficient in reversed(f):
        ans = ans * x + coefficient
    return ans


def divmod_poly(f: list[Q], g: list[Q]) -> tuple[list[Q], list[Q]]:
    f = trim(f[:])
    g = trim(g[:])
    if g == [0]:
        raise ZeroDivisionError("polynomial division by zero")
    if len(f) < len(g):
        return [Q(0)], f
    quotient = [Q(0)] * (len(f) - len(g) + 1)
    while len(f) >= len(g) and f != [0]:
        shift = len(f) - len(g)
        coefficient = f[-1] / g[-1]
        quotient[shift] = coefficient
        for j, value in enumerate(g):
            f[shift + j] -= coefficient * value
        trim(f)
    return trim(quotient), trim(f)


def sturm_chain(f: list[Q]) -> list[list[Q]]:
    f = trim(f[:])
    chain = [f, trim(derivative(f))]
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
    return sum(x != y for x, y in zip(nonzero, nonzero[1:]))


def variations_at(chain: list[list[Q]], x: Q) -> int:
    return variations([sign(evaluate(f, x)) for f in chain])


def variations_at_infinity(chain: list[list[Q]], positive: bool) -> int:
    signs = []
    for f in chain:
        leading_sign = sign(f[-1])
        if not positive and (len(f) - 1) % 2:
            leading_sign = -leading_sign
        signs.append(leading_sign)
    return variations(signs)


def real_root_count(f: list[Q]) -> int:
    chain = sturm_chain(f)
    return variations_at_infinity(chain, False) - variations_at_infinity(chain, True)


def roots_between(f: list[Q], left: Q, right: Q) -> int:
    """Count roots in (left,right), requiring non-root endpoints."""
    assert left < right
    assert evaluate(f, left) != 0 and evaluate(f, right) != 0
    chain = sturm_chain(f)
    return variations_at(chain, left) - variations_at(chain, right)


def divide_linear_exact(f: list[Q], root: Q) -> list[Q]:
    quotient, remainder = divmod_poly(f, [-root, Q(1)])
    assert remainder == [0]
    return quotient


def strip_endpoint(f: list[Q], endpoint: Q) -> list[Q]:
    while evaluate(f, endpoint) == 0:
        f = divide_linear_exact(f, endpoint)
    return f


def roots_strictly_between(f: list[Q], left: Q, right: Q) -> int:
    f = strip_endpoint(strip_endpoint(f, left), right)
    return roots_between(f, left, right)


def roots_strictly_greater(f: list[Q], left: Q) -> int:
    f = strip_endpoint(f, left)
    chain = sturm_chain(f)
    return variations_at(chain, left) - variations_at_infinity(chain, True)


def square_integer(n: int) -> bool:
    if n < 0:
        return False
    root = isqrt(n)
    return root**2 == n


def reducible_quartic_without_linear(a: int, b: int, c: int) -> bool:
    """Exact test for a monic quartic of constant one splitting 2+2."""
    # Constants of the two monic integral quadratics are both s in {+1,-1}.
    for s in (1, -1):
        if c != s * a:
            continue
        product = b - 2 * s
        discriminant = a * a - 4 * product
        if square_integer(discriminant):
            root = isqrt(discriminant)
            if (a + root) % 2 == 0:
                return True
    return False


def bareiss_determinant(matrix: list[list[int]]) -> int:
    """Fraction-free exact determinant."""
    a = [row[:] for row in matrix]
    n = len(a)
    if n == 0:
        return 1
    previous = 1
    parity = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot_row = next((i for i in range(k + 1, n) if a[i][k]), None)
            if pivot_row is None:
                return 0
            a[k], a[pivot_row] = a[pivot_row], a[k]
            parity = -parity
        pivot = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = a[i][j] * pivot - a[i][k] * a[k][j]
                assert numerator % previous == 0
                a[i][j] = numerator // previous
        for i in range(k + 1, n):
            a[i][k] = 0
        previous = pivot
    return parity * a[-1][-1]


def resultant(f_desc: list[int], g_desc: list[int]) -> int:
    """Sylvester resultant; inputs use descending coefficients."""
    m = len(f_desc) - 1
    n = len(g_desc) - 1
    sylvester = []
    for shift in range(n):
        sylvester.append([0] * shift + f_desc + [0] * (n - 1 - shift))
    for shift in range(m):
        sylvester.append([0] * shift + g_desc + [0] * (m - 1 - shift))
    return bareiss_determinant(sylvester)


PRIMES = (2, 3, 5, 7, 11, 13)


def prime_prefix_desc(last_prime: int) -> list[int]:
    degree = last_prime - 2
    allowed = {p - 2 for p in PRIMES if p <= last_prime}
    return [int(exponent in allowed) for exponent in range(degree, -1, -1)]


PREFIX = {p: prime_prefix_desc(p) for p in (7, 11, 13)}
NEXT_EXPONENT = {7: 9, 11: 11, 13: 15}


EXPECTED_FINAL = {
    (-2, 2, -1), (-2, 3, -1), (-1, -1, 1), (-1, 0, 0),
    (-1, 1, -1), (-1, 1, 0), (-1, 2, -2), (-1, 2, 0),
    (-1, 3, -2), (-1, 3, -1), (0, 0, -1), (0, 0, 1),
    (0, 1, -1), (0, 1, 1), (0, 2, -1), (0, 2, 1),
    (1, -1, -1), (1, 0, 0), (1, 1, 0), (1, 1, 1),
    (1, 2, 0), (1, 2, 2), (1, 3, 1), (1, 3, 2),
    (2, 2, 1), (2, 3, 1),
}

CYCLIC = {(-1, 1, -1), (1, 1, 1)}  # Phi_10 and Phi_5.


# triple: (chosen cutoff, upper bound for inner radius, |R_7|, |R_11|, |R_13|)
EXPECTED_CERTIFICATES = {
    (-2, 2, -1): (7, Q(763, 1000), 19, 67, 691),
    (-2, 3, -1): (7, Q(643, 1000), 62, 3151, 22636),
    (-1, -1, 1): (7, Q(763, 1000), 37, 63, 457),
    (-1, 2, -2): (7, Q(763, 1000), 16, 441, 169),
    (-1, 2, 0): (7, Q(357, 500), 16, 367, 1437),
    (-1, 3, -2): (7, Q(643, 1000), 82, 5701, 7492),
    (-1, 3, -1): (7, Q(13, 20), 73, 4087, 7923),
    (0, 1, 1): (7, Q(401, 500), 8, 71, 218),
    (0, 2, -1): (7, Q(357, 500), 11, 641, 873),
    (0, 2, 1): (7, Q(357, 500), 23, 645, 729),
    (1, -1, -1): (7, Q(763, 1000), 139, 343, 1843),
    (1, 1, 0): (7, Q(401, 500), 16, 41, 278),
    (1, 2, 0): (7, Q(357, 500), 16, 705, 2159),
    (1, 2, 2): (7, Q(763, 1000), 16, 259, 43),
    (1, 3, 1): (7, Q(13, 20), 31, 2763, 5917),
    (1, 3, 2): (7, Q(643, 1000), 44, 3679, 5338),
    (2, 2, 1): (7, Q(763, 1000), 43, 63, 751),
    (2, 3, 1): (7, Q(643, 1000), 76, 2899, 21058),
    (-1, 1, 0): (11, Q(401, 500), 2, 47, 176),
    (0, 0, -1): (11, Q(169, 200), 17, 75, 253),
    (0, 1, -1): (11, Q(401, 500), 2, 107, 152),
    (-1, 0, 0): (13, Q(169, 200), 16, 3, 109),
    (0, 0, 1): (13, Q(169, 200), 1, 23, 57),
    (1, 0, 0): (13, Q(169, 200), 16, 5, 27),
}


def resolvent(a: int, b: int, c: int) -> list[Q]:
    # T^3 - b*T^2 + (a*c-4)*T + (4*b-a^2-c^2).
    return [Q(4 * b - a * a - c * c), Q(a * c - 4), Q(-b), Q(1)]


def exact_tail_margin(cutoff: int, radius_upper: Q, res: int) -> Q:
    exponent = NEXT_EXPONENT[cutoff]
    weighted_sum = sum(
        radius_upper ** (exponent - (p - 2))
        for p in PRIMES
        if p <= cutoff
    )
    return Q(res) * (1 - radius_upper * radius_upper) ** 2 - weighted_sum**2


def main() -> None:
    start = perf_counter()

    diophantine = []
    no_real = []
    viable = []
    unit_circle = []

    for a in range(-4, 5):
        for b in range(-1, 7):
            for c in range(-4, 5):
                delta = a * a - a * b * c + c * c
                if abs(delta) != 1:
                    continue
                triple = (a, b, c)
                diophantine.append(triple)

                g_asc = [Q(1), Q(c), Q(b), Q(a), Q(1)]
                if real_root_count(g_asc) != 0:
                    continue
                no_real.append(triple)
                assert not reducible_quartic_without_linear(a, b, c)

                h = resolvent(a, b, c)
                roots_23 = roots_strictly_between(h, Q(2), Q(3))
                if roots_23 == 1:
                    viable.append(triple)
                elif roots_23 == 0:
                    # If the conjugate-pair radius is exactly one, the quartic
                    # is cyclotomic.  In this finite list these are Phi_5/Phi_10.
                    h_without_two = strip_endpoint(h, Q(2))
                    if (
                        triple in CYCLIC
                        and roots_strictly_greater(h_without_two, Q(2)) == 0
                    ):
                        unit_circle.append(triple)
                else:
                    raise AssertionError((triple, roots_23))

    assert len(diophantine) == 62
    assert len(no_real) == 46
    assert set(viable) | set(unit_circle) == EXPECTED_FINAL
    assert set(unit_circle) == CYCLIC
    assert len(viable) == 24

    margins: dict[tuple[int, int, int], Q] = {}
    selected_counts = {7: 0, 11: 0, 13: 0}

    for triple in sorted(viable):
        a, b, c = triple
        cutoff, upper, r7, r11, r13 = EXPECTED_CERTIFICATES[triple]
        expected_resultants = {7: r7, 11: r11, 13: r13}
        g_desc = [1, a, b, c, 1]
        actual_resultants = {
            p: abs(resultant(g_desc, PREFIX[p])) for p in (7, 11, 13)
        }
        assert actual_resultants == expected_resultants

        # T=r^2+r^-2 is the unique resolvent root above 2.  For 0<r<1,
        # r<u iff T>u^2+u^-2.  This is an exact Sturm certificate.
        threshold = upper * upper + 1 / (upper * upper)
        h = resolvent(a, b, c)
        assert Q(2) < threshold < Q(3)
        assert roots_between(h, threshold, Q(3)) == 1

        # Every earlier prime prefix has nonzero resultant.
        for earlier in (7, 11, 13):
            if earlier >= cutoff:
                break
            assert actual_resultants[earlier] != 0

        margin = exact_tail_margin(cutoff, upper, actual_resultants[cutoff])
        assert margin > 0
        margins[triple] = margin
        selected_counts[cutoff] += 1

    assert set(EXPECTED_CERTIFICATES) == set(viable)
    assert selected_counts == {7: 18, 11: 3, 13: 3}

    minimum_triple = min(margins, key=margins.get)
    minimum_margin = margins[minimum_triple]
    assert minimum_triple == (0, 1, 1)

    print("quartic certificate: PASS")
    print(f"D=+-1 triples: {len(diophantine)}")
    print(f"no-real irreducible triples: {len(no_real)}")
    print(f"odd-annulus survivors: {len(viable) + len(unit_circle)}")
    print(f"cyclotomic survivors (Phi_5, Phi_10): {len(unit_circle)}")
    print(f"noncyclotomic certificates by cutoff: {selected_counts}")
    print(f"minimum margin triple: {minimum_triple}")
    print(f"minimum margin exact: {minimum_margin}")
    print(f"minimum margin decimal: {float(minimum_margin):.12f}")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

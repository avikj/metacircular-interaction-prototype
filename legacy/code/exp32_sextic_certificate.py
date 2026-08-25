#!/usr/bin/env python3
"""Exact certificate excluding irreducible sextic prime-prefix factors.

For X >= 7 put F_X(x)=sum_{p<=X} x^(p-2).  A hypothetical monic
irreducible sextic factor is written

    g=x^6+a*x^5+b*x^4+c*x^3+d*x^2+e*x+1.

The proof reduction is documented in ``notes/SEXTIC_OBSTRUCTION.md``.  This
script checks the resulting finite certificate using integer and Fraction
arithmetic only.  In particular:

* Sturm chains count real roots;
* exact Routh tables after a Cayley transform count roots in rational disks;
* trial division is a complete irreducibility test in the inherited root box;
* Bareiss resultants and rational tail inequalities close every candidate.

Floating point is used only for the final human-readable margin and timing.
"""

from __future__ import annotations

from math import isqrt
from time import perf_counter

from exp30_quartic_certificate import Q, divmod_poly, real_root_count, resultant


DEGREE = 6
INNER = Q(617, 1000)
OUTER = Q(20001, 10000)
CUTOFFS = (7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47)
EXPECTED_COUNTS = {
    7: 267,
    11: 47,
    13: 14,
    17: 6,
    19: 5,
    23: 11,
    29: 3,
    31: 4,
    37: 0,
    41: 0,
    43: 0,
    47: 1,
}

# Phi_14, Phi_7, Phi_18, Phi_9, respectively.  The note gives immediate
# residue-class obstructions showing that none divides a prime prefix.
CYCLOTOMIC = {
    (-1, 1, -1, 1, -1),
    (1, 1, 1, 1, 1),
    (0, 0, -1, 0, 0),
    (0, 0, 1, 0, 0),
}


def delta(a: int, b: int, c: int, d: int, e: int) -> int:
    """Res_y(y^3+b*y^2+d*y+1, a*y^2+c*y+e)."""
    return (
        a**3
        - 2 * a * a * b * e
        - a * a * c * d
        + a * a * d * d * e
        + a * b * b * e * e
        + a * b * c * c
        - a * b * c * d * e
        + 3 * a * c * e
        - 2 * a * d * e * e
        - b * c * e * e
        - c**3
        + c * c * d * e
        + e**3
    )


def poly_add(f: list[Q], g: list[Q]) -> list[Q]:
    answer = [Q(0)] * max(len(f), len(g))
    for i, value in enumerate(f):
        answer[i] += value
    for i, value in enumerate(g):
        answer[i] += value
    return answer


def poly_multiply(f: list[Q], g: list[Q]) -> list[Q]:
    answer = [Q(0)] * (len(f) + len(g) - 1)
    for i, x in enumerate(f):
        for j, y in enumerate(g):
            answer[i + j] += x * y
    return answer


def poly_power(f: list[Q], exponent: int) -> list[Q]:
    answer = [Q(1)]
    for _ in range(exponent):
        answer = poly_multiply(answer, f)
    return answer


def cayley_polynomial(g_ascending: list[Q], radius: Q) -> list[Q]:
    """(1+w)^6 g(radius*(1-w)/(1+w)), ascending in w."""
    answer = [Q(0)]
    for exponent, coefficient in enumerate(g_ascending):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    assert len(answer) == DEGREE + 1
    return answer


def sign_changes(values: list[Q]) -> int:
    signs = [(value > 0) - (value < 0) for value in values]
    assert 0 not in signs
    return sum(left != right for left, right in zip(signs, signs[1:]))


def routh_right_half_plane(polynomial_ascending: list[Q]) -> int | None:
    """Return the exact RHP root count, or None for a degenerate table."""
    coefficients = list(reversed(polynomial_ascending))
    degree = len(coefficients) - 1
    width = (degree + 2) // 2
    table = [[Q(0)] * width for _ in range(degree + 1)]
    table[0][: len(coefficients[0::2])] = coefficients[0::2]
    table[1][: len(coefficients[1::2])] = coefficients[1::2]
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


def roots_in_disk(g_ascending: list[Q], radius: Q) -> int | None:
    # w=(radius-z)/(radius+z) has Re(w)>0 exactly when |z|<radius.
    return routh_right_half_plane(cayley_polynomial(g_ascending, radius))


def integer_divides(f_descending: list[int], g_descending: list[int]) -> bool:
    _, remainder = divmod_poly(
        [Q(value) for value in reversed(f_descending)],
        [Q(value) for value in reversed(g_descending)],
    )
    return remainder == [0]


def reducible_sextic(g_descending: list[int]) -> bool:
    """Complete degree 1/2/3 factor search under the strict root bound 2."""
    for constant in (-1, 1):
        if integer_divides(g_descending, [1, constant]):
            return True
        for linear in range(-3, 4):
            if integer_divides(g_descending, [1, linear, constant]):
                return True
        for quadratic in range(-5, 6):
            for linear in range(-11, 12):
                if integer_divides(
                    g_descending, [1, quadratic, linear, constant]
                ):
                    return True
    return False


def rational_radius_bound(g_ascending: list[Q], target_count: int) -> Q:
    """Certify an upper bound for the target_count-th root by modulus."""
    lower = INNER
    upper = OUTER
    lower_count = roots_in_disk(g_ascending, lower)
    upper_count = roots_in_disk(g_ascending, upper)
    assert lower_count is not None and upper_count is not None
    assert lower_count < target_count <= upper_count

    for _ in range(14):
        middle = (lower + upper) / 2
        count = roots_in_disk(g_ascending, middle)
        if count is None:
            # Moving strictly upward preserves its use as an upper bound and
            # avoids the finitely many exceptional radii.
            middle += (upper - lower) / 1_000_000
            count = roots_in_disk(g_ascending, middle)
            assert count is not None
        if count >= target_count:
            upper = middle
        else:
            lower = middle
    return upper


def primes_through(limit: int) -> tuple[int, ...]:
    answer = []
    for candidate in range(2, limit + 1):
        if all(candidate % divisor for divisor in range(2, isqrt(candidate) + 1)):
            answer.append(candidate)
    return tuple(answer)


PRIMES = primes_through(53)


def prefix_descending(cutoff: int) -> list[int]:
    exponents = {prime - 2 for prime in PRIMES if prime <= cutoff}
    return [int(exponent in exponents) for exponent in range(cutoff - 2, -1, -1)]


def remainder_descending(f_descending: list[int], g_descending: list[int]) -> list[int]:
    _, remainder = divmod_poly(
        [Q(value) for value in reversed(f_descending)],
        [Q(value) for value in reversed(g_descending)],
    )
    assert all(value.denominator == 1 for value in remainder)
    return [int(value) for value in reversed(remainder)]


def tail_margin(
    cutoff: int,
    radii: tuple[Q, Q, Q],
    absolute_resultant: int,
) -> Q:
    u1, u2, u3 = radii
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    b2 = sum(u2 ** (prime - 2) for prime in PRIMES if prime <= cutoff)
    b3 = sum(u3 ** (prime - 2) for prime in PRIMES if prime <= cutoff)
    return (
        Q(absolute_resultant) * (1 - u1 * u1) ** 2
        - u1 ** (2 * first_tail_exponent) * b2 * b2 * b3 * b3
    )


def main() -> None:
    start = perf_counter()
    diophantine = []
    no_real = []
    coarse_annulus = []
    irreducible = []

    for a in range(-6, 7):
        for e in range(-6, 7):
            for b in range(-18, 19):
                for d in range(-18, 19):
                    for c in range(-24, 25):
                        if abs(delta(a, b, c, d, e)) != 1:
                            continue
                        candidate = (a, b, c, d, e)
                        diophantine.append(candidate)
                        g_ascending = [Q(1), Q(e), Q(d), Q(c), Q(b), Q(a), Q(1)]
                        if real_root_count(g_ascending) != 0:
                            continue
                        no_real.append(candidate)

                        inner_count = roots_in_disk(g_ascending, INNER)
                        outer_count = roots_in_disk(g_ascending, OUTER)
                        assert inner_count is not None and outer_count is not None
                        if inner_count != 0 or outer_count != 6:
                            continue
                        coarse_annulus.append(candidate)

                        g_descending = [1, a, b, c, d, e, 1]
                        if reducible_sextic(g_descending):
                            continue
                        irreducible.append(candidate)

    assert len(diophantine) == 18_506
    assert len(no_real) == 4_894
    assert len(coarse_annulus) == 392
    assert len(irreducible) == 362
    assert CYCLOTOMIC <= set(irreducible)

    selected_counts = {cutoff: 0 for cutoff in CUTOFFS}
    margins: list[tuple[Q, tuple[int, int, int, int, int], int]] = []

    for candidate in irreducible:
        if candidate in CYCLOTOMIC:
            continue
        a, b, c, d, e = candidate
        g_ascending = [Q(1), Q(e), Q(d), Q(c), Q(b), Q(a), Q(1)]
        g_descending = [1, a, b, c, d, e, 1]
        radii = tuple(
            rational_radius_bound(g_ascending, target) for target in (2, 4, 6)
        )
        assert radii[0] <= radii[1] <= radii[2]
        assert radii[0] < 1

        selected = False
        for cutoff in CUTOFFS:
            prefix = prefix_descending(cutoff)
            remainder = remainder_descending(prefix, g_descending)
            absolute_resultant = abs(resultant(g_descending, remainder))
            # A zero here would be an actual sextic divisor at this prefix.
            assert absolute_resultant != 0
            margin = tail_margin(cutoff, radii, absolute_resultant)
            if margin > 0:
                selected_counts[cutoff] += 1
                margins.append((margin, candidate, cutoff))
                selected = True
                break
        assert selected, candidate

    assert selected_counts == EXPECTED_COUNTS
    assert sum(selected_counts.values()) == len(irreducible) - len(CYCLOTOMIC)
    minimum_margin, minimum_candidate, minimum_cutoff = min(margins)
    assert minimum_candidate == (0, 2, -1, 3, 0)
    assert minimum_cutoff == 7

    print("sextic certificate: PASS")
    print(f"D=+-1 tuples: {len(diophantine)}")
    print(f"no-real tuples: {len(no_real)}")
    print(f"rational-annulus tuples: {len(coarse_annulus)}")
    print(f"irreducible candidates: {len(irreducible)}")
    print(f"cyclotomic exclusions: {len(CYCLOTOMIC)}")
    print(f"tail certificates by cutoff: {selected_counts}")
    print(f"minimum margin candidate: {minimum_candidate} at {minimum_cutoff}")
    print(f"minimum margin exact: {minimum_margin}")
    print(f"minimum margin decimal: {float(minimum_margin):.12f}")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

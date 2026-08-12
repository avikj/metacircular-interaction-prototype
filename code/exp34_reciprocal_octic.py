#!/usr/bin/env python3
"""Exact certificate excluding reciprocal irreducible octic factors of F_X.

For X >= 11 put F_X(x)=sum_{p<=X} x^(p-2).  A reciprocal monic octic
of constant one is written

    g=x^8+a*x^7+b*x^6+c*x^5+d*x^4+c*x^3+b*x^2+a*x+1.

The proof reduction is documented in ``notes/RECIPROCAL_OCTIC.md``.  Every
decision below uses integer or Fraction arithmetic.  Floating point is used
only to print an already certified positive rational margin and elapsed time.
"""

from __future__ import annotations

from math import isqrt
from time import perf_counter

from exp30_quartic_certificate import Q, real_root_count, resultant
from exp32_sextic_certificate import (
    integer_divides,
    poly_add,
    poly_multiply,
    poly_power,
    routh_right_half_plane,
)


DEGREE = 8
INNER = Q(617, 1000)  # strictly below phi^-1
OUTER = Q(81, 50)  # strictly above phi
CUTOFFS = (11, 13, 17, 19, 23, 29, 31, 37)
EXPECTED_COUNTS = {
    11: 22,
    13: 2,
    17: 3,
    19: 0,
    23: 3,
    29: 4,
    31: 0,
    37: 2,
}

# Phi_15 and Phi_30.  These are excluded by the global cyclotomic theorem.
CYCLOTOMIC = {
    (-1, 0, 1, -1),
    (1, 0, -1, -1),
}

# Exact proper factors for the twenty reducible rational-annulus candidates.
# Coefficients are descending.  The other thirty-six noncyclotomic
# candidates have an irreducible reduction modulo 2, 3, or 7.
REDUCIBLE_FACTORS = {
    (-2, 3, -3, 3): [1, -1, 1],
    (-2, 5, -5, 7): [1, -1, 1],
    (-1, 1, -1, 1): [1, -1, 1],
    (-1, 3, -1, 3): [1, -1, 1],
    (-1, 3, -3, 3): [1, 1, 1],
    (-1, 3, -3, 5): [1, -1, 1],
    (-1, 4, -3, 7): [1, -1, 2, 0, 1],
    (0, 1, 1, 1): [1, -1, 1],
    (0, 1, -1, 1): [1, 1, 1],
    (0, 3, 1, 3): [1, -1, 1],
    (0, 3, -1, 3): [1, 1, 1],
    (0, 3, 1, 5): [1, 1, 1],
    (0, 3, -1, 5): [1, -1, 1],
    (1, 1, 1, 1): [1, 1, 1],
    (1, 3, 3, 3): [1, -1, 1],
    (1, 3, 1, 3): [1, 1, 1],
    (1, 3, 3, 5): [1, 1, 1],
    (1, 4, 3, 7): [1, 0, 2, 1, 1],
    (2, 3, 3, 3): [1, 1, 1],
    (2, 5, 5, 7): [1, 1, 1],
}


def reciprocal_octic(a: int, b: int, c: int, d: int) -> list[Q]:
    """Ascending coefficients of the reciprocal octic g."""
    return [Q(1), Q(a), Q(b), Q(c), Q(d), Q(c), Q(b), Q(a), Q(1)]


def unit_kernel(a: int, b: int, c: int, d: int) -> int:
    """The square-root factor in Res(E,O)."""
    return (a - c) ** 2 + a * b * (a - c) + a * a * (d - 2)


def parity_resultant(a: int, b: int, c: int, d: int) -> int:
    """Res_y(E,O) for the even and odd parts of g."""
    return (d - 2 * b + 2) * unit_kernel(a, b, c, d) ** 2


def cayley_polynomial(g_ascending: list[Q], radius: Q) -> list[Q]:
    """(1+w)^8 g(radius*(1-w)/(1+w)), ascending in w."""
    answer = [Q(0)]
    for exponent, coefficient in enumerate(g_ascending):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    assert len(answer) == DEGREE + 1
    return answer


def roots_in_disk(g_ascending: list[Q], radius: Q) -> int | None:
    # w=(radius-z)/(radius+z) has Re(w)>0 exactly when |z|<radius.
    return routh_right_half_plane(cayley_polynomial(g_ascending, radius))


def mod_trim(polynomial: list[int], prime: int) -> list[int]:
    answer = [value % prime for value in polynomial]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def mod_add(left: list[int], right: list[int], prime: int) -> list[int]:
    answer = [0] * max(len(left), len(right))
    for index, value in enumerate(left):
        answer[index] += value
    for index, value in enumerate(right):
        answer[index] += value
    return mod_trim(answer, prime)


def mod_remainder(
    dividend: list[int], divisor: list[int], prime: int
) -> list[int]:
    answer = mod_trim(dividend, prime)
    divisor = mod_trim(divisor, prime)
    inverse_lead = pow(divisor[-1], -1, prime)
    while len(answer) >= len(divisor) and answer != [0]:
        shift = len(answer) - len(divisor)
        scale = answer[-1] * inverse_lead % prime
        for index, value in enumerate(divisor):
            answer[index + shift] -= scale * value
        answer = mod_trim(answer, prime)
    return answer


def mod_gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    while mod_trim(right, prime) != [0]:
        left, right = right, mod_remainder(left, right, prime)
    return mod_trim(left, prime)


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


def irreducible_mod_prime(g_ascending: list[int], prime: int) -> bool:
    """Rabin's exact irreducibility test specialized to degree eight."""
    modulus = mod_trim(g_ascending, prime)
    if len(modulus) != DEGREE + 1:
        return False
    x = [0, 1]
    frobenius = x
    for _ in range(4):
        frobenius = mod_power(frobenius, prime, modulus, prime)
    difference = mod_add(frobenius, [0, -1], prime)
    if len(mod_gcd(difference, modulus, prime)) > 1:
        return False
    for _ in range(4):
        frobenius = mod_power(frobenius, prime, modulus, prime)
    return mod_add(frobenius, [0, -1], prime) == [0]


def irreducible_prime_degree_mod(
    g_ascending: list[int], prime: int
) -> bool:
    """Rabin test when the polynomial degree itself is prime."""
    modulus = mod_trim(g_ascending, prime)
    degree = len(modulus) - 1
    if degree < 2 or any(degree % divisor == 0 for divisor in range(2, isqrt(degree) + 1)):
        return False
    x = [0, 1]
    frobenius = mod_power(x, prime, modulus, prime)
    if len(mod_gcd(mod_add(frobenius, [0, -1], prime), modulus, prime)) > 1:
        return False
    for _ in range(degree - 1):
        frobenius = mod_power(frobenius, prime, modulus, prime)
    return mod_add(frobenius, [0, -1], prime) == [0]


def rational_radius_bound(g_ascending: list[Q], target_count: int) -> Q:
    """Certify an upper bound for the target_count-th root by modulus."""
    lower = INNER
    upper = OUTER
    lower_count = roots_in_disk(g_ascending, lower)
    upper_count = roots_in_disk(g_ascending, upper)
    assert lower_count is not None and upper_count is not None
    assert lower_count < target_count <= upper_count

    for _ in range(18):
        middle = (lower + upper) / 2
        count = roots_in_disk(g_ascending, middle)
        if count is None:
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


def prefix_bound(cutoff: int, radius: Q) -> Q:
    return sum(
        radius ** (prime - 2) for prime in PRIMES if prime <= cutoff
    )


def tail_margin(
    cutoff: int,
    radii: tuple[Q, Q, Q, Q],
    absolute_resultant: int,
) -> Q:
    u1, u2, u3, u4 = radii
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    other_product = (
        prefix_bound(cutoff, u2) ** 2
        * prefix_bound(cutoff, u3) ** 2
        * prefix_bound(cutoff, u4) ** 2
    )
    return (
        Q(absolute_resultant) * (1 - u1 * u1) ** 2
        - u1 ** (2 * first_tail_exponent) * other_product
    )


def main() -> None:
    start = perf_counter()
    diophantine = []
    no_real = []
    coarse_annulus = []
    irreducible = []

    # For H(T)=T^4+aT^3+(b-4)T^2+(c-3a)T+(d-2b+2),
    # golden-annulus roots imply |a|<=8, -25<=b<=33,
    # |c-3a|<=44.  Put u=a-c, so |u|<=60.
    for a in range(-8, 9):
        for b in range(-25, 34):
            for epsilon in (-1, 1):
                d = 2 * b - 2 + epsilon
                for u in range(-60, 61):
                    c = a - u
                    if abs(c - 3 * a) > 44:
                        continue
                    if abs(unit_kernel(a, b, c, d)) != 1:
                        continue
                    assert abs(parity_resultant(a, b, c, d)) == 1
                    candidate = (a, b, c, d)
                    diophantine.append(candidate)

                    g_ascending = reciprocal_octic(*candidate)
                    if real_root_count(g_ascending) != 0:
                        continue
                    no_real.append(candidate)

                    inner_count = roots_in_disk(g_ascending, INNER)
                    outer_count = roots_in_disk(g_ascending, OUTER)
                    assert inner_count is not None and outer_count is not None
                    if inner_count != 0 or outer_count != DEGREE:
                        continue
                    coarse_annulus.append(candidate)

                    a0, b0, c0, d0 = candidate
                    g_descending = [1, a0, b0, c0, d0, c0, b0, a0, 1]
                    if candidate in REDUCIBLE_FACTORS:
                        assert integer_divides(
                            g_descending, REDUCIBLE_FACTORS[candidate]
                        )
                        continue
                    if candidate not in CYCLOTOMIC:
                        witness = next(
                            (
                                prime
                                for prime in (2, 3, 5, 7)
                                if irreducible_mod_prime(
                                    [int(value) for value in g_ascending], prime
                                )
                            ),
                            None,
                        )
                        assert witness is not None, candidate
                    irreducible.append(candidate)

    assert len(diophantine) == 928
    assert len(no_real) == 424
    assert len(coarse_annulus) == 58
    assert len(irreducible) == 38
    assert len(REDUCIBLE_FACTORS) == 20
    assert set(coarse_annulus) == (
        set(irreducible) | set(REDUCIBLE_FACTORS)
    )
    assert CYCLOTOMIC < set(irreducible)

    selected_counts = {cutoff: 0 for cutoff in CUTOFFS}
    margins: list[tuple[Q, tuple[int, int, int, int], int, int]] = []

    for candidate in irreducible:
        if candidate in CYCLOTOMIC:
            continue
        a, b, c, d = candidate
        g_ascending = reciprocal_octic(*candidate)
        g_descending = [1, a, b, c, d, c, b, a, 1]
        radii = tuple(
            rational_radius_bound(g_ascending, target)
            for target in (2, 4, 6, 8)
        )
        assert radii[0] <= radii[1] <= radii[2] <= radii[3]
        assert radii[0] < 1

        selected = False
        for cutoff in CUTOFFS:
            absolute_resultant = abs(
                resultant(g_descending, prefix_descending(cutoff))
            )
            # A zero would be an actual reciprocal octic divisor here.
            assert absolute_resultant != 0
            margin = tail_margin(cutoff, radii, absolute_resultant)
            if margin > 0:
                selected_counts[cutoff] += 1
                margins.append(
                    (margin, candidate, cutoff, absolute_resultant)
                )
                selected = True
                break
        assert selected, candidate

    assert selected_counts == EXPECTED_COUNTS
    assert sum(selected_counts.values()) == len(irreducible) - len(CYCLOTOMIC)
    minimum_margin, minimum_candidate, minimum_cutoff, minimum_resultant = min(
        margins
    )
    assert minimum_candidate == (0, 1, -1, -1)
    assert minimum_cutoff == 11
    assert minimum_resultant == 4208

    # Independent finite-field certificate for the first prefix whose
    # factorization was not forced by the low-degree carrier argument.
    # Degree 17 is prime, and the Rabin test below proves F_19 irreducible
    # modulo 71, hence over Q.
    f19 = [
        int(exponent in {0, 1, 3, 5, 9, 11, 15, 17})
        for exponent in range(18)
    ]
    assert irreducible_prime_degree_mod(f19, 71)

    print("reciprocal octic certificate: PASS")
    print(f"unit-resultant tuples: {len(diophantine)}")
    print(f"no-real tuples: {len(no_real)}")
    print(f"rational-annulus tuples: {len(coarse_annulus)}")
    print(f"irreducible candidates: {len(irreducible)}")
    print(f"cyclotomic exclusions: {len(CYCLOTOMIC)}")
    print(f"tail certificates by cutoff: {selected_counts}")
    print(
        "minimum margin: "
        f"candidate={minimum_candidate}, cutoff={minimum_cutoff}, "
        f"resultant={minimum_resultant}"
    )
    print(f"minimum margin exact: {minimum_margin}")
    print(f"minimum margin decimal: {float(minimum_margin):.12f}")
    print("F_19 irreducible modulo 71: PASS")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

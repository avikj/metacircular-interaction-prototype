#!/usr/bin/env python3
"""Exact certificate excluding reciprocal irreducible sextic factors of F_X.

All decisions use integers or Fraction.  The only decimal output is a
human-readable rendering of already certified positive rational margins.
"""

from __future__ import annotations

from fractions import Fraction
from math import gcd
from time import perf_counter

from exp30_quartic_certificate import (
    Q,
    divmod_poly,
    evaluate,
    real_root_count,
    resultant,
    roots_strictly_between,
)


COEFFICIENT_SURVIVORS = {
    (-2, 4, -5),
    (-1, 1, -1),
    (-1, 3, -3),
    (-1, 3, -1),
    (0, 0, -1),
    (0, 0, 1),
    (0, 2, -1),
    (0, 2, 1),
    (1, 1, 1),
    (1, 3, 1),
    (1, 3, 3),
    (2, 4, 5),
}

LOCAL_SURVIVORS = {
    (-1, 1, -1),  # Phi_14
    (-1, 3, -1),
    (1, 1, 1),  # Phi_7
    (1, 3, 1),
}

CYCLIC = {(-1, 1, -1), (1, 1, 1)}
FINAL = {(-1, 3, -1), (1, 3, 1)}
EXPECTED_RESULTANTS = {(-1, 3, -1): 2615, (1, 3, 1): 2381}


def reciprocal_sextic(a: int, b: int, c: int) -> list[Q]:
    """Ascending coefficients of x^6+a*x^5+b*x^4+c*x^3+...+1."""
    return [Q(1), Q(a), Q(b), Q(c), Q(b), Q(a), Q(1)]


def t_cubic(a: int, b: int, c: int) -> list[Q]:
    """f(T) with x^-3*g(x)=f(x+x^-1), ascending coefficients."""
    return [Q(c - 2 * a), Q(b - 3), Q(a), Q(1)]


def isolate_unique_real_root(f: list[Q], steps: int = 80) -> tuple[Q, Q]:
    """Isolate the unique real root of f, known here to lie in (-2,2)."""
    assert real_root_count(f) == 1
    lower, upper = Q(-2), Q(2)
    assert evaluate(f, lower) < 0 < evaluate(f, upper)
    for _ in range(steps):
        middle = (lower + upper) / 2
        value = evaluate(f, middle)
        if value < 0:
            lower = middle
        elif value > 0:
            upper = middle
        else:
            return middle, middle
    return lower, upper


Interval = tuple[Q, Q]


def iadd(x: Interval, y: Interval) -> Interval:
    return x[0] + y[0], x[1] + y[1]


def isub(x: Interval, y: Interval) -> Interval:
    return x[0] - y[1], x[1] - y[0]


def imul(x: Interval, y: Interval) -> Interval:
    values = (x[0] * y[0], x[0] * y[1], x[1] * y[0], x[1] * y[1])
    return min(values), max(values)


def isquare(x: Interval) -> Interval:
    if x[0] <= 0 <= x[1]:
        return Q(0), max(x[0] * x[0], x[1] * x[1])
    values = (x[0] * x[0], x[1] * x[1])
    return min(values), max(values)


def ireciprocal(x: Interval) -> Interval:
    assert not (x[0] <= 0 <= x[1])
    return min(1 / x[0], 1 / x[1]), max(1 / x[0], 1 / x[1])


def ellipse_score_interval(
    a: int, c: int, root_interval: Interval, radius: Q
) -> Interval:
    """Interval for u^2/A^2+v^2/B^2-1 for the nonreal T-pair.

    Here u+-iv are the two nonreal roots of f(T), radius is >1,
    A=radius+radius^-1, and B=radius-radius^-1.  The corresponding
    x-roots have moduli between radius^-1 and radius iff the score is <0.
    """
    s = root_interval
    epsilon = Q(2 * a - c)
    assert epsilon in (Q(-1), Q(1))
    assert (epsilon > 0 and s[0] > 0) or (epsilon < 0 and s[1] < 0)

    u = ((Q(-a) - s[1]) / 2, (Q(-a) - s[0]) / 2)
    modulus_squared = imul((epsilon, epsilon), ireciprocal(s))
    u_squared = isquare(u)
    v_squared = isub(modulus_squared, u_squared)

    A = radius + 1 / radius
    B = radius - 1 / radius
    score = iadd(
        (u_squared[0] / (A * A), u_squared[1] / (A * A)),
        (v_squared[0] / (B * B), v_squared[1] / (B * B)),
    )
    return score[0] - 1, score[1] - 1


def ellipse_score_sign(a: int, b: int, c: int, radius: Q) -> int:
    """Exact sign of the Joukowski ellipse score for the nonreal T-pair."""
    f = t_cubic(a, b, c)
    lower, upper = isolate_unique_real_root(f, 12)
    for _ in range(300):
        score = ellipse_score_interval(a, c, (lower, upper), radius)
        if score[1] < 0:
            return -1
        if score[0] > 0:
            return 1
        middle = (lower + upper) / 2
        value = evaluate(f, middle)
        if value < 0:
            lower = middle
        elif value > 0:
            upper = middle
        else:
            lower = upper = middle
    raise AssertionError((a, b, c, radius, "ellipse sign did not separate"))


def has_no_real_x_roots(a: int, b: int, c: int) -> bool:
    """A real x-root occurs exactly when f(T) has real T outside [-2,2]."""
    f = t_cubic(a, b, c)
    if evaluate(f, Q(-2)) == 0 or evaluate(f, Q(2)) == 0:
        return False
    return roots_strictly_between(f, Q(-2), Q(2)) == real_root_count(f)


def satisfies_golden_annulus(a: int, b: int, c: int) -> bool:
    """Exact annulus test specialized to a reciprocal sextic."""
    f = t_cubic(a, b, c)
    count = real_root_count(f)
    if count == 3:
        # has_no_real_x_roots puts all three T-roots in (-2,2), hence all
        # six x-roots are on the unit circle.
        return True
    assert count == 1
    # The |x|=phi Joukowski ellipse has semiaxis squares 5 and 1.
    # radius=(1+sqrt(5))/2 is encoded directly by those rational squares;
    # use the equivalent score interval rather than introducing sqrt(5).
    lower, upper = isolate_unique_real_root(f, 12)
    for _ in range(300):
        s = (lower, upper)
        epsilon = Q(2 * a - c)
        u = ((Q(-a) - upper) / 2, (Q(-a) - lower) / 2)
        q = imul((epsilon, epsilon), ireciprocal(s))
        u2 = isquare(u)
        v2 = isub(q, u2)
        score = iadd((u2[0] / 5, u2[1] / 5), v2)
        score = score[0] - 1, score[1] - 1
        if score[1] < 0:
            return True
        if score[0] > 0:
            return False
        middle = (lower + upper) / 2
        value = evaluate(f, middle)
        if value < 0:
            lower = middle
        elif value > 0:
            upper = middle
        else:
            lower = upper = middle
    raise AssertionError((a, b, c, "golden ellipse sign did not separate"))


def reducible_under_annulus(a: int, b: int, c: int) -> bool:
    """Exact degree <=3 factor search, complete under the golden annulus."""
    g = reciprocal_sextic(a, b, c)
    if evaluate(g, Q(1)) == 0 or evaluate(g, Q(-1)) == 0:
        return True

    # Constants of monic integral factors divide 1.  For a quadratic,
    # |trace|<2*phi<4.  For a cubic of constant +-1, both its roots and
    # inverse roots lie in the annulus, so its two nonconstant elementary
    # symmetric coefficients have modulus <3*phi<5.
    for constant in (Q(-1), Q(1)):
        for trace in range(-3, 4):
            _, remainder = divmod_poly(g, [constant, Q(trace), Q(1)])
            if remainder == [0]:
                return True
        for linear in range(-4, 5):
            for quadratic in range(-4, 5):
                factor = [constant, Q(linear), Q(quadratic), Q(1)]
                _, remainder = divmod_poly(g, factor)
                if remainder == [0]:
                    return True
    return False


def local_conditions(a: int, b: int, c: int) -> tuple[bool, bool]:
    # Exponents modulo 3: gcd(a^2+b^2-abc,b^2-a^2)=1.
    local_three = gcd(abs(a * a + b * b - a * b * c), abs(b * b - a * a)) == 1
    # Exponents modulo 5: gcd(b,c,a^2-1)=1.
    local_five = gcd(gcd(abs(b), abs(c)), abs(a * a - 1)) == 1
    return local_three, local_five


def f11_desc() -> list[int]:
    exponents = {0, 1, 3, 5, 9}
    return [int(exponent in exponents) for exponent in range(9, -1, -1)]


def B(value: Q) -> Q:
    return 1 + value + value**3 + value**5 + value**9


def tail_margin(res: int) -> Q:
    inner_upper = Q(7, 10)
    outer_upper = Q(3, 2)
    return (
        Q(res) * (1 - inner_upper**2) ** 2
        - inner_upper**22 * B(Q(1)) ** 2 * B(outer_upper) ** 2
    )


def main() -> None:
    start = perf_counter()
    candidates = []
    for a in range(-6, 7):
        for b in range(-16, 17):
            for c in range(-22, 23):
                unit_resultant = (2 * a - c) * (c - a * (b - 1)) ** 2
                if abs(unit_resultant) != 1:
                    continue
                if not has_no_real_x_roots(a, b, c):
                    continue
                if not satisfies_golden_annulus(a, b, c):
                    continue
                if reducible_under_annulus(a, b, c):
                    continue
                candidates.append((a, b, c))

    assert set(candidates) == COEFFICIENT_SURVIVORS

    local_survivors = {
        triple for triple in candidates if all(local_conditions(*triple))
    }
    assert local_survivors == LOCAL_SURVIVORS
    assert CYCLIC < local_survivors
    final = local_survivors - CYCLIC
    assert final == FINAL

    margins = {}
    for triple in sorted(final):
        a, b, c = triple
        # The nonunit pairs have moduli r and r^-1.  The two exact ellipse
        # signs certify 10/7 < r^-1 < 3/2, hence r < 7/10.
        assert ellipse_score_sign(a, b, c, Q(10, 7)) > 0
        assert ellipse_score_sign(a, b, c, Q(3, 2)) < 0

        g_desc = [1, a, b, c, b, a, 1]
        res = abs(resultant(g_desc, f11_desc()))
        assert res == EXPECTED_RESULTANTS[triple]
        margin = tail_margin(res)
        assert margin > 0
        margins[triple] = margin

    print("reciprocal sextic certificate: PASS")
    print(f"irreducible annulus survivors: {len(candidates)}")
    print(f"local survivors: {sorted(local_survivors)}")
    print(f"cyclotomic removals: {sorted(CYCLIC)}")
    print(f"tail-certified final candidates: {sorted(final)}")
    for triple in sorted(final):
        print(
            f"  {triple}: R_11={EXPECTED_RESULTANTS[triple]}, "
            f"margin={margins[triple]} ({float(margins[triple]):.9f})"
        )
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

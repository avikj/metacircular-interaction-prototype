#!/usr/bin/env python3
"""Independent exact audit of the odd-degree nonic tail certificate.

This script does not import exp42.  It uses finer root-radius bisections and
constructs every prime prefix directly before exact polynomial division,
rather than using exp42's power recurrence.

If g divides F_X and q<X is a prime cutoff, then at every root alpha of g,
F_q(alpha)=-T(alpha).  At the unique negative root -t all tail exponents are
odd, hence |T(-t)| <= t^N/(1-t^2).  For the four conjugate pairs we instead
use |F_q(alpha)| <= B_q(|alpha|).  Multiplying the nine root evaluations gives

  |Res(g,F_q)|(1-t^2) <= t^N product_i B_q(r_i)^2.

Thus a strict reverse inequality, together with nonzero prefix resultants,
excludes the candidate from every prime prefix.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("audit42 must not run under python -O")

from collections import Counter
from fractions import Fraction as Q
import json
from math import isqrt
from pathlib import Path

from exact_polynomial import (
    divmod_poly,
    evaluate,
    poly_add,
    poly_multiply,
    poly_power,
    resultant,
    routh_right_half_plane,
)


DEGREE = 9
LOWER = Q(309, 500)
UPPER = Q(79, 125)
INNER = Q(617, 1000)
OUTER = Q(20001, 10000)
LEDGER = Path("/tmp/exp41-nonic-ledger-strict.json")
EXPECTED = {13: 10, 17: 141, 19: 127, 23: 343, 29: 78, 31: 41, 37: 12, 41: 3}


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        value for value in range(2, limit + 1)
        if all(value % divisor for divisor in range(2, isqrt(value) + 1))
    )


PRIMES = primes_through(47)
CUTOFFS = tuple(prime for prime in PRIMES if 11 <= prime <= 41)


def polynomial(candidate: tuple[int, ...]) -> list[int]:
    a, b, c, d, e, f, h, j = candidate
    return [1, j, h, f, e, d, c, b, a, 1]


def cayley(g: list[Q], radius: Q) -> list[Q]:
    result = [Q(0)]
    for exponent, coefficient in enumerate(g):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        result = poly_add(result, [coefficient * entry for entry in term])
    return result


def total_disk_count(g: list[Q], radius: Q) -> int | None:
    return routh_right_half_plane(cayley(g, radius))


def complex_disk_count(g: list[Q], radius: Q) -> int | None:
    total = total_disk_count(g, radius)
    if total is None:
        return None
    return total - int(evaluate(g, -radius) < 0)


def negative_upper(g: list[Q]) -> Q:
    lower, upper = LOWER, UPPER
    assert evaluate(g, -lower) > 0 > evaluate(g, -upper)
    for _ in range(20):
        middle = (lower + upper) / 2
        value = evaluate(g, -middle)
        assert value
        if value > 0:
            lower = middle
        else:
            upper = middle
    return upper


def pair_radius_upper(g: list[Q], target: int) -> Q:
    lower, upper = INNER, OUTER
    assert complex_disk_count(g, lower) == 0
    assert complex_disk_count(g, upper) == 8
    for _ in range(16):
        middle = (lower + upper) / 2
        count = complex_disk_count(g, middle)
        if count is None:
            delta = (upper - lower) / 10**9
            for multiplier in range(1, 1000):
                shifted = middle + multiplier * delta
                count = complex_disk_count(g, shifted)
                if count is not None:
                    middle = shifted
                    break
            assert count is not None
        if count >= target:
            upper = middle
        else:
            lower = middle
    return upper


def direct_remainder(g: list[int], cutoff: int) -> list[int]:
    prefix = [0] * (cutoff - 1)
    for prime in PRIMES:
        if prime <= cutoff:
            prefix[prime - 2] = 1
    _, remainder = divmod_poly(list(map(Q, prefix)), list(map(Q, g)))
    assert all(value.denominator == 1 for value in remainder)
    return [int(value) for value in remainder]


def margin(
    cutoff: int, t: Q, radii: tuple[Q, Q, Q, Q], absolute_resultant: int
) -> Q:
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    product = Q(1)
    for radius in radii:
        bound = sum(
            (radius ** (prime - 2) for prime in PRIMES if prime <= cutoff),
            Q(0),
        )
        product *= bound * bound
    return Q(absolute_resultant) * (1 - t * t) - t**first_tail_exponent * product


def main() -> None:
    ledger = json.loads(LEDGER.read_text(encoding="utf-8"))
    candidates = sorted(
        [tuple(record["candidate"])
         for record in ledger["modular_irreducibility_witnesses"]]
        + [tuple(record["candidate"])
           for record in ledger["cohn_prime_value_witnesses"]]
    )
    assert len(candidates) == len(set(candidates)) == 755
    selected = Counter()
    checked = 0
    minimum = None
    for index, candidate in enumerate(candidates, start=1):
        g_integer = polynomial(candidate)
        g = list(map(Q, g_integer))
        t = negative_upper(g)
        radii = tuple(pair_radius_upper(g, target) for target in (2, 4, 6, 8))
        assert list(radii) == sorted(radii)
        found = False
        for cutoff in CUTOFFS:
            remainder = direct_remainder(g_integer, cutoff)
            while len(remainder) > 1 and remainder[-1] == 0:
                remainder.pop()
            absolute_resultant = abs(
                resultant(list(reversed(g_integer)), list(reversed(remainder)))
            )
            checked += 1
            assert absolute_resultant != 0
            value = margin(cutoff, t, radii, absolute_resultant)
            if value > 0:
                selected[cutoff] += 1
                minimum = value if minimum is None or value < minimum else minimum
                found = True
                break
        assert found, candidate
        if index % 100 == 0:
            print(f"audit42 checkpoint {index}/755", flush=True)
    assert dict(sorted(selected.items())) == EXPECTED
    assert checked == 3_544
    assert minimum is not None and minimum > 0
    print("audit42 independent tail replay: ACCEPT")
    print(f"cutoff census: {dict(sorted(selected.items()))}")
    print(f"exact resultants: {checked}")
    print(f"minimum margin display only: {float(minimum):.12g}")


if __name__ == "__main__":
    main()

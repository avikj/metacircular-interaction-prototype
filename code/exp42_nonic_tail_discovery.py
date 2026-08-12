#!/usr/bin/env python3
"""Exact prime-prefix/tail discovery for exp41's irreducible nonics.

For a candidate with negative root -t and four conjugate-pair radii r_i,
suppose g divides a later prime prefix F_X after cutoff q.  At -t the tail is
bounded by t^N/(1-t^2), where N is the next prime exponent.  At every complex
root the same identity bounds the tail by the finite prefix F_q.  Therefore

  |Res(g,F_q)| <= t^N/(1-t^2) * product_i B_q(r_i)^2,

where B_q(r)=sum_{p<=q} r^(p-2).  Every radius in this script is replaced by
an exact rational upper bound.  A strict reverse inequality excludes every
later prefix.  Nonzero exact resultants separately exclude all earlier ones.

This is a discovery run; stage constants are not promoted until hostile audit.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp42 uses load-bearing assertions and must not run under python -O")

import argparse
from collections import Counter
from fractions import Fraction as Q
import hashlib
import json
from math import isqrt
from pathlib import Path
from time import perf_counter

from exact_polynomial import (
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
DEFAULT_POSTCENSUS = Path("/tmp/exp41-nonic-ledger-strict.json")


def polynomial(candidate: tuple[int, ...]) -> list[int]:
    a, b, c, d, e, f, h, j = candidate
    return [1, j, h, f, e, d, c, b, a, 1]


def candidate_digest(candidates: list[tuple[int, ...]]) -> str:
    text = "".join(" ".join(map(str, candidate)) + "\n"
                   for candidate in sorted(candidates))
    return hashlib.sha256(text.encode("ascii")).hexdigest()


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        candidate for candidate in range(2, limit + 1)
        if all(candidate % divisor for divisor in range(2, isqrt(candidate) + 1))
    )


PRIMES = primes_through(47)
CUTOFFS = tuple(prime for prime in PRIMES if 11 <= prime <= 41)
EXPECTED_INPUT_SHA256 = "96b2c779d6b9d020216e84c7dcbba904b4d8c9eb9851e72e3922a7062bd594af"
EXPECTED_SELECTED = {
    13: 10,
    17: 137,
    19: 127,
    23: 345,
    29: 78,
    31: 43,
    37: 12,
    41: 3,
}


def cayley_polynomial(g: list[Q], radius: Q) -> list[Q]:
    answer = [Q(0)]
    for exponent, coefficient in enumerate(g):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    assert len(answer) == DEGREE + 1
    return answer


def roots_in_disk(g: list[Q], radius: Q) -> int | None:
    return routh_right_half_plane(cayley_polynomial(g, radius))


def negative_root_upper(g: list[Q], steps: int = 12) -> Q:
    lower, upper = LOWER, UPPER
    assert evaluate(g, -lower) > 0 and evaluate(g, -upper) < 0
    for _ in range(steps):
        middle = (lower + upper) / 2
        value = evaluate(g, -middle)
        assert value != 0  # a rational root would contradict irreducibility
        if value > 0:
            lower = middle
        else:
            upper = middle
    return upper


def complex_roots_in_disk(g: list[Q], radius: Q) -> int | None:
    total = roots_in_disk(g, radius)
    if total is None:
        return None
    # g(-r)<0 exactly when the unique root -t satisfies t<r.
    negative_inside = int(evaluate(g, -radius) < 0)
    answer = total - negative_inside
    assert answer in (0, 2, 4, 6, 8)
    return answer


def complex_radius_upper(g: list[Q], target: int, steps: int = 10) -> Q:
    lower, upper = INNER, OUTER
    assert complex_roots_in_disk(g, lower) == 0
    assert complex_roots_in_disk(g, upper) == 8
    for _ in range(steps):
        middle = (lower + upper) / 2
        count = complex_roots_in_disk(g, middle)
        if count is None:
            # An upward rational perturbation preserves an upper bound.
            step = (upper - lower) / 100_000_000
            for multiplier in range(1, 100):
                shifted = middle + multiplier * step
                count = complex_roots_in_disk(g, shifted)
                if count is not None:
                    middle = shifted
                    break
            assert count is not None
        if count >= target:
            upper = middle
        else:
            lower = middle
    return upper


def prefix_remainders(candidate: tuple[int, ...]) -> dict[int, list[int]]:
    g = polynomial(candidate)
    power = [1] + [0] * (DEGREE - 1)
    remainder = [0] * DEGREE
    prime_at_exponent = {prime - 2: prime for prime in PRIMES}
    answer = {}
    for exponent in range(CUTOFFS[-1] - 1):
        if exponent in prime_at_exponent:
            prime = prime_at_exponent[exponent]
            for index in range(DEGREE):
                remainder[index] += power[index]
            if prime in CUTOFFS:
                answer[prime] = remainder[:]
        last = power[-1]
        power = [-last * g[0]] + [
            power[index - 1] - last * g[index] for index in range(1, DEGREE)
        ]
    assert set(answer) == set(CUTOFFS)
    return answer


def tail_margin(
    cutoff: int,
    negative_radius: Q,
    complex_radii: tuple[Q, Q, Q, Q],
    absolute_resultant: int,
) -> Q:
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    prefix_bounds = [
        sum((radius ** (prime - 2) for prime in PRIMES if prime <= cutoff), Q(0))
        for radius in complex_radii
    ]
    product = Q(1)
    for bound in prefix_bounds:
        product *= bound * bound
    return (
        Q(absolute_resultant) * (1 - negative_radius * negative_radius)
        - negative_radius**first_tail_exponent * product
    )


def load_irreducibles(path: Path) -> list[tuple[int, ...]]:
    ledger = json.loads(path.read_text(encoding="utf-8"))
    modular = [tuple(record["candidate"])
               for record in ledger["modular_irreducibility_witnesses"]]
    cohn = [tuple(record["candidate"])
            for record in ledger["cohn_prime_value_witnesses"]]
    candidates = sorted(modular + cohn)
    assert len(candidates) == len(set(candidates)) == 755
    return candidates


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--postcensus-ledger", type=Path, default=DEFAULT_POSTCENSUS)
    parser.add_argument("--ledger-out", type=Path)
    args = parser.parse_args()
    start = perf_counter()

    candidates = load_irreducibles(args.postcensus_ledger)
    assert candidate_digest(candidates) == EXPECTED_INPUT_SHA256
    selected_counts: Counter[int] = Counter()
    resultants_checked = 0
    minimum_margin = None
    minimum_candidate = None
    minimum_cutoff = None
    failures = []
    prefix_divisors = []

    for candidate_index, candidate in enumerate(candidates, start=1):
        g_integer = polynomial(candidate)
        g = list(map(Q, g_integer))
        negative = negative_root_upper(g)
        complex_radii = tuple(
            complex_radius_upper(g, target) for target in (2, 4, 6, 8)
        )
        assert list(complex_radii) == sorted(complex_radii)
        remainders = prefix_remainders(candidate)
        selected = False
        for cutoff in CUTOFFS:
            remainder = remainders[cutoff]
            while len(remainder) > 1 and remainder[-1] == 0:
                remainder.pop()
            absolute_resultant = abs(
                resultant(list(reversed(g_integer)), list(reversed(remainder)))
            )
            resultants_checked += 1
            if absolute_resultant == 0:
                prefix_divisors.append({"candidate": list(candidate), "cutoff": cutoff})
                selected = True
                break
            margin = tail_margin(cutoff, negative, complex_radii, absolute_resultant)
            if margin > 0:
                selected_counts[cutoff] += 1
                if minimum_margin is None or margin < minimum_margin:
                    minimum_margin = margin
                    minimum_candidate = candidate
                    minimum_cutoff = cutoff
                selected = True
                break
        if not selected:
            failures.append(candidate)
        if candidate_index % 50 == 0:
            print(f"exp42 checkpoint {candidate_index}/{len(candidates)}", flush=True)

    result = {
        "experiment": "exp42-nonic-tail-discovery",
        "status": "discovery-only",
        "theorem_claim": False,
        "input_count": len(candidates),
        "input_sha256": candidate_digest(candidates),
        "selected_by_cutoff": dict(sorted(selected_counts.items())),
        "selected_count": sum(selected_counts.values()),
        "prefix_divisors": prefix_divisors,
        "failures": [list(candidate) for candidate in failures],
        "failures_sha256": candidate_digest(failures),
        "resultants_checked": resultants_checked,
        "negative_bisection_steps": 12,
        "complex_radius_bisection_steps": 10,
        "minimum_margin": (
            None if minimum_margin is None else
            [minimum_margin.numerator, minimum_margin.denominator]
        ),
        "minimum_margin_display_only": (
            None if minimum_margin is None else float(minimum_margin)
        ),
        "minimum_candidate": (
            None if minimum_candidate is None else list(minimum_candidate)
        ),
        "minimum_cutoff": minimum_cutoff,
        "elapsed_seconds_display_only": perf_counter() - start,
    }
    assert not prefix_divisors
    assert not failures
    assert dict(sorted(selected_counts.items())) == EXPECTED_SELECTED
    assert sum(selected_counts.values()) == len(candidates)
    assert minimum_margin is not None and minimum_margin > 0
    rendered = json.dumps(result, sort_keys=True, indent=2)
    if args.ledger_out is not None:
        args.ledger_out.write_text(rendered + "\n", encoding="utf-8")
    print(rendered)


if __name__ == "__main__":
    main()

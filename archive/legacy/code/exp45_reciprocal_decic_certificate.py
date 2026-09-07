#!/usr/bin/env python3
"""Exact certificate for reciprocal decic factors of prime-prefix polynomials.

This is the final finite calibration of the low-degree factor pipeline, not a
commitment to continue degree by degree.  The mathematical reduction is in
``notes/RECIPROCAL_DECIC.md``.  Every load-bearing decision uses integers or
``Fraction`` arithmetic.  Floating point occurs only in display fields.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp45 is an exact certificate and forbids python -O")

import argparse
from collections import Counter
from fractions import Fraction as Q
import hashlib
import json
from math import isqrt
from pathlib import Path
from time import perf_counter

from exact_polynomial import (
    divmod_poly,
    evaluate,
    poly_add,
    poly_multiply,
    poly_power,
    resultant,
    routh_right_half_plane,
    sturm_chain,
    variations,
    variations_at_infinity,
)


DEGREE = 10
INNER = Q(617, 1000)  # strictly below phi^{-1}
OUTER = Q(81, 50)  # strictly above phi
TRACE_BOUNDS = (8, 30, 45, 26)
EXPECTED_UNIT_COUNT = 15_754
EXPECTED_UNIT_SHA256 = "b953532bb421d3d243c68cd61358ba03b2def663cf2acb35370d26154ecdc3a6"
EXPECTED_NO_REAL_COUNT = 6_414
EXPECTED_NO_REAL_SHA256 = "31cfee2c06cc8e6cb6a66ea836d61bcaed8ee92a52210d47a30d7c280864b7fd"
EXPECTED_ANNULUS_COUNT = 294
EXPECTED_ANNULUS_SHA256 = "7b36d7f06b8858b87e044720fff480e420e56f80bc1a1fd38c2d350b23e28736"
EXPECTED_REDUCIBLE_COUNT = 72
EXPECTED_IRREDUCIBLE_COUNT = 222
EXPECTED_REDUCIBLE_SHA256 = "55246b015f1fa1857934b2a56e695045ac41707cd8bf707c8c09b024ec6336fa"
EXPECTED_IRREDUCIBLE_SHA256 = "a7c44bd6aea2dcd3eeaafb170e2e688eebce246863a3be887f8718139aa88556"
EXPECTED_TAIL_INPUT_SHA256 = "885d15c37a2ae75ba5cab442b766ef4944a5fadfd9de7ea24c57e078ccf87fcc"

# Trace tuples (A,B,C,D,s,K) for Phi_22 and Phi_11 respectively.
CYCLOTOMIC = {
    (-1, -4, 3, 3, -1, -1),
    (1, -4, -3, 3, 1, -1),
}

EXPECTED_TAIL_COUNTS = {
    13: 137,
    17: 29,
    19: 6,
    23: 19,
    29: 6,
    31: 6,
    37: 6,
    41: 2,
    47: 2,
    53: 3,
    59: 1,
    71: 1,
    73: 1,
    79: 1,
}
EXPECTED_RESULTANTS_CHECKED = 526
EXPECTED_MINIMUM_CANDIDATE = (1, -3, -4, 1, 1, 1)
EXPECTED_MINIMUM_CUTOFF = 13
EXPECTED_MINIMUM_RESULTANT = 40_189
EXPECTED_WITNESS_DISTRIBUTION = {
    2: 64, 3: 30, 5: 32, 7: 10, 11: 18, 13: 8, 17: 12, 19: 4,
    23: 4, 29: 10, 31: 8, 37: 6, 41: 2, 43: 6, 67: 2, 73: 2,
    97: 2, 191: 2,
}

ROOT = Path(__file__).resolve().parents[1]


def source_provenance() -> dict[str, str]:
    paths = {
        "exp45_reciprocal_decic_certificate.py": Path(__file__),
        "exact_polynomial.py": ROOT / "code" / "exact_polynomial.py",
        "UNIT_PRODUCT_VIETA.md": ROOT / "notes" / "UNIT_PRODUCT_VIETA.md",
        "RECIPROCAL_DECIC.md": ROOT / "notes" / "RECIPROCAL_DECIC.md",
    }
    return {
        name: hashlib.sha256(path.read_bytes()).hexdigest()
        for name, path in paths.items()
    }


def candidate_digest(candidates: list[tuple[int, ...]]) -> str:
    payload = "".join(",".join(map(str, row)) + "\n" for row in sorted(candidates))
    return hashlib.sha256(payload.encode("ascii")).hexdigest()


def trace_polynomial(candidate: tuple[int, ...]) -> list[int]:
    """Ascending H(T)=T^5+A*T^4+B*T^3+C*T^2+D*T+s."""
    a, b, c, d, s, _ = candidate
    return [s, d, c, b, a, 1]


def reciprocal_decic(candidate: tuple[int, ...]) -> list[int]:
    """Ascending coefficients of g=x^5 H(x+x^{-1})."""
    a, b, c, d, s, _ = candidate
    original_b = b + 5
    original_c = c + 4 * a
    original_d = d + 3 * b + 10
    original_e = s + 2 * c + 6 * a
    return [
        1, a, original_b, original_c, original_d, original_e,
        original_d, original_c, original_b, a, 1,
    ]


def unit_kernel(a: int, b: int, c: int, d: int, s: int) -> int:
    """Res_T(T^2+B*T+D, remainder of the second parity factor)."""
    ell = c - a * b
    n = s - a * d
    return n * n - b * ell * n + d * ell * ell


def parity_parts(candidate: tuple[int, ...]) -> tuple[list[int], list[int]]:
    g = reciprocal_decic(candidate)
    return g[0::2], g[1::2]


def enumerate_unit_candidates() -> list[tuple[int, ...]]:
    """Solve the quadratic unit equation exactly, including D=0 branches."""
    answer = set()
    for a in range(-TRACE_BOUNDS[0], TRACE_BOUNDS[0] + 1):
        for b in range(-TRACE_BOUNDS[1], TRACE_BOUNDS[1] + 1):
            for d in range(-TRACE_BOUNDS[3], TRACE_BOUNDS[3] + 1):
                for s in (-1, 1):
                    n = s - a * d
                    for kernel in (-1, 1):
                        possible_u = set()
                        if d == 0:
                            if kernel == 1 and b == 0:
                                possible_u.update(range(-45, 46))
                            elif kernel == 1:
                                possible_u.add(0)
                            else:
                                denominator = b * s
                                if denominator and 2 % denominator == 0:
                                    possible_u.add(2 // denominator)
                        else:
                            discriminant = n * n * (b * b - 4 * d) + 4 * d * kernel
                            if discriminant < 0:
                                continue
                            root = isqrt(discriminant)
                            if root * root != discriminant:
                                continue
                            denominator = 2 * d
                            for numerator in (b * n - root, b * n + root):
                                if numerator % denominator == 0:
                                    possible_u.add(numerator // denominator)
                        for u in possible_u:
                            c = a * b + u
                            if abs(c) > TRACE_BOUNDS[2]:
                                continue
                            candidate = (a, b, c, d, s, kernel)
                            assert unit_kernel(a, b, c, d, s) == kernel
                            even, odd = parity_parts(candidate)
                            direct = resultant(list(reversed(even)), list(reversed(odd)))
                            assert direct == s * kernel * kernel
                            answer.add(candidate)
    answer = sorted(answer)
    assert len(answer) == EXPECTED_UNIT_COUNT
    assert candidate_digest(answer) == EXPECTED_UNIT_SHA256
    assert Counter(row[5] for row in answer) == {-1: 1_444, 1: 14_310}
    assert Counter(row[4] for row in answer) == {-1: 7_877, 1: 7_877}
    assert sum(row[3] == 0 for row in answer) == 4_190
    return answer


def variations_at(chain: list[list[Q]], point: Q) -> int:
    return variations([
        (evaluate(polynomial, point) > 0) - (evaluate(polynomial, point) < 0)
        for polynomial in chain
    ])


def has_real_decic_root(candidate: tuple[int, ...]) -> tuple[bool, bool]:
    """Return whether H has a root outside [-2,2], and endpoint incidence."""
    h = list(map(Q, trace_polynomial(candidate)))
    at_minus_two = evaluate(h, Q(-2))
    at_two = evaluate(h, Q(2))
    endpoint = at_minus_two == 0 or at_two == 0
    if endpoint:
        return True, True
    chain = sturm_chain(h)
    below = variations_at_infinity(chain, False) - variations_at(chain, Q(-2))
    above = variations_at(chain, Q(2)) - variations_at_infinity(chain, True)
    assert below >= 0 and above >= 0
    return below + above > 0, False


def cayley_polynomial(g: list[int], radius: Q) -> list[Q]:
    answer = [Q(0)]
    for exponent, coefficient in enumerate(g):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    assert len(answer) == DEGREE + 1
    return answer


def roots_in_disk(g: list[int], radius: Q) -> int | None:
    # w=(radius-z)/(radius+z) has Re(w)>0 exactly when |z|<radius.
    return routh_right_half_plane(cayley_polynomial(g, radius))


def integer_divides(dividend_descending: list[int], divisor_descending: list[int]) -> bool:
    _, remainder = divmod_poly(
        list(map(Q, reversed(dividend_descending))),
        list(map(Q, reversed(divisor_descending))),
    )
    return remainder == [0]


def trace_factor(candidate: tuple[int, ...]) -> tuple[int, ...] | None:
    h_descending = list(reversed(trace_polynomial(candidate)))
    for constant in (-1, 1):
        factor = (1, constant)
        if integer_divides(h_descending, list(factor)):
            return factor
    for constant in (-1, 1):
        for linear in range(-4, 5):
            factor = (1, linear, constant)
            if integer_divides(h_descending, list(factor)):
                return factor
    return None


def multiply_integer(left: list[int], right: list[int]) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] += x * y
    return answer


def sphere_vectors(limit: int = 137) -> dict[int, list[tuple[int, int, int, int]]]:
    """All four-square vectors needed by the h*h^rev exceptional case."""
    bound = isqrt(limit)
    answer: dict[int, list[tuple[int, int, int, int]]] = {
        value: [] for value in range(limit + 1)
    }
    for v1 in range(-bound, bound + 1):
        for v2 in range(-bound, bound + 1):
            for v3 in range(-bound, bound + 1):
                partial = v1 * v1 + v2 * v2 + v3 * v3
                if partial > limit:
                    continue
                remaining = limit - partial
                fourth_bound = isqrt(remaining)
                for v4 in range(-fourth_bound, fourth_bound + 1):
                    norm = partial + v4 * v4
                    answer[norm].append((v1, v2, v3, v4))
    return answer


SPHERE_VECTORS = sphere_vectors()


def exceptional_reciprocal_factor(candidate: tuple[int, ...]) -> tuple[int, ...] | None:
    """Find h when g=t*h*h^rev in the trace-irreducible exceptional case."""
    g = reciprocal_decic(candidate)
    middle = g[5]
    if abs(middle) < 2:
        return None
    t = 1 if middle > 0 else -1
    norm = abs(middle) - 2
    assert norm <= 137
    for vector in SPHERE_VECTORS[norm]:
        h = [t, *vector, 1]
        reverse = list(reversed(h))
        product = [t * coefficient for coefficient in multiply_integer(h, reverse)]
        if product == g:
            return tuple(reversed(h))  # descending monic witness
    return None


def mod_trim(polynomial: list[int], prime: int) -> list[int]:
    answer = [value % prime for value in polynomial]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def mod_remainder(dividend: list[int], divisor: list[int], prime: int) -> list[int]:
    answer = mod_trim(dividend, prime)
    divisor = mod_trim(divisor, prime)
    inverse = pow(divisor[-1], -1, prime)
    while len(answer) >= len(divisor) and answer != [0]:
        shift = len(answer) - len(divisor)
        scale = answer[-1] * inverse % prime
        for index, value in enumerate(divisor):
            answer[index + shift] -= scale * value
        answer = mod_trim(answer, prime)
    return answer


def mod_gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    while mod_trim(right, prime) != [0]:
        left, right = right, mod_remainder(left, right, prime)
    return mod_trim(left, prime)


def mod_multiply(left: list[int], right: list[int], modulus: list[int], prime: int) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = (answer[i + j] + x * y) % prime
    return mod_remainder(answer, modulus, prime)


def mod_power(base: list[int], exponent: int, modulus: list[int], prime: int) -> list[int]:
    answer = [1]
    while exponent:
        if exponent & 1:
            answer = mod_multiply(answer, base, modulus, prime)
        base = mod_multiply(base, base, modulus, prime)
        exponent //= 2
    return answer


def mod_subtract_x(polynomial: list[int], prime: int) -> list[int]:
    answer = polynomial[:]
    while len(answer) < 2:
        answer.append(0)
    answer[1] -= 1
    return mod_trim(answer, prime)


def irreducible_mod_prime(g: list[int], prime: int) -> bool:
    """Rabin criterion for degree ten (prime divisors 2 and 5)."""
    modulus = mod_trim(g, prime)
    if len(modulus) != DEGREE + 1:
        return False
    x = [0, 1]
    for divisor in (2, 5):
        frobenius = mod_power(x, prime ** (DEGREE // divisor), modulus, prime)
        if len(mod_gcd(mod_subtract_x(frobenius, prime), modulus, prime)) > 1:
            return False
    frobenius = mod_power(x, prime**DEGREE, modulus, prime)
    return mod_subtract_x(frobenius, prime) == [0]


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        candidate for candidate in range(2, limit + 1)
        if all(candidate % divisor for divisor in range(2, isqrt(candidate) + 1))
    )


WITNESS_PRIMES = primes_through(251)
PREFIX_PRIMES = primes_through(83)
CUTOFFS = tuple(prime for prime in PREFIX_PRIMES if 13 <= prime <= 79)


def rational_radius_bound(g: list[int], target_count: int, steps: int = 18) -> Q:
    lower, upper = INNER, OUTER
    assert roots_in_disk(g, lower) == 0
    assert roots_in_disk(g, upper) == DEGREE
    for _ in range(steps):
        middle = (lower + upper) / 2
        count = roots_in_disk(g, middle)
        if count is None:
            step = (upper - lower) / 100_000_000
            for multiplier in range(1, 100):
                shifted = middle + multiplier * step
                count = roots_in_disk(g, shifted)
                if count is not None:
                    middle = shifted
                    break
            assert count is not None
        if count >= target_count:
            upper = middle
        else:
            lower = middle
    return upper


def prefix_remainders(g: list[int]) -> dict[int, list[int]]:
    power = [1] + [0] * (DEGREE - 1)
    remainder = [0] * DEGREE
    prime_at_exponent = {prime - 2: prime for prime in PREFIX_PRIMES}
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


def prefix_bound(cutoff: int, radius: Q) -> Q:
    return sum(
        (radius ** (prime - 2) for prime in PREFIX_PRIMES if prime <= cutoff),
        Q(0),
    )


def tail_margin(cutoff: int, radii: tuple[Q, ...], absolute_resultant: int) -> Q:
    first, *others = radii
    next_prime = next(prime for prime in PREFIX_PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    other_product = Q(1)
    for radius in others:
        other_product *= prefix_bound(cutoff, radius) ** 2
    return (
        Q(absolute_resultant) * (1 - first * first) ** 2
        - first ** (2 * first_tail_exponent) * other_product
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ledger-out", type=Path)
    args = parser.parse_args()
    started = perf_counter()
    provenance = source_provenance()

    unit = enumerate_unit_candidates()
    no_real = []
    endpoints = []
    annulus = []
    routh_degenerate = []
    for candidate in unit:
        has_real, endpoint = has_real_decic_root(candidate)
        if endpoint:
            endpoints.append(candidate)
        if has_real:
            continue
        no_real.append(candidate)
        g = reciprocal_decic(candidate)
        inner_count = roots_in_disk(g, INNER)
        outer_count = roots_in_disk(g, OUTER)
        if inner_count is None or outer_count is None:
            routh_degenerate.append(candidate)
        elif inner_count == 0 and outer_count == DEGREE:
            annulus.append(candidate)

    assert not endpoints
    assert not routh_degenerate
    assert len(no_real) == EXPECTED_NO_REAL_COUNT
    assert candidate_digest(no_real) == EXPECTED_NO_REAL_SHA256
    assert len(annulus) == EXPECTED_ANNULUS_COUNT
    assert candidate_digest(annulus) == EXPECTED_ANNULUS_SHA256

    reducible_witnesses = {}
    exceptional_witnesses = {}
    structural_irreducibles = []
    modular_witnesses = {}
    for candidate in annulus:
        factor = trace_factor(candidate)
        if factor is not None:
            reducible_witnesses[candidate] = factor
            continue
        exceptional = exceptional_reciprocal_factor(candidate)
        if exceptional is not None:
            exceptional_witnesses[candidate] = exceptional
            continue
        # Cafure--Cesaratto's reciprocal trace criterion leaves no third
        # case: with H irreducible, g is irreducible unless g=t*h*h^rev.
        structural_irreducibles.append(candidate)
        # Independent exact evidence, not the authority for classification.
        g = reciprocal_decic(candidate)
        witness = next((p for p in WITNESS_PRIMES if irreducible_mod_prime(g, p)), None)
        assert witness is not None, candidate
        modular_witnesses[candidate] = witness

    assert len(reducible_witnesses) == EXPECTED_REDUCIBLE_COUNT
    assert Counter(len(factor) for factor in reducible_witnesses.values()) == {2: 48, 3: 24}
    assert candidate_digest(list(reducible_witnesses)) == EXPECTED_REDUCIBLE_SHA256
    assert not exceptional_witnesses
    assert len(structural_irreducibles) == EXPECTED_IRREDUCIBLE_COUNT
    assert candidate_digest(structural_irreducibles) == EXPECTED_IRREDUCIBLE_SHA256
    assert set(structural_irreducibles) == set(modular_witnesses)
    assert dict(sorted(Counter(modular_witnesses.values()).items())) == EXPECTED_WITNESS_DISTRIBUTION
    assert set(annulus) == (
        set(reducible_witnesses) | set(exceptional_witnesses)
        | set(structural_irreducibles)
    )
    assert CYCLOTOMIC < set(structural_irreducibles)

    tail_candidates = sorted(set(structural_irreducibles) - CYCLOTOMIC)
    assert len(tail_candidates) == 220
    assert candidate_digest(tail_candidates) == EXPECTED_TAIL_INPUT_SHA256
    selected_counts: Counter[int] = Counter()
    resultants_checked = 0
    prefix_divisors = []
    failures = []
    minimum_margin = None
    minimum_candidate = None
    minimum_cutoff = None
    minimum_resultant = None

    for index, candidate in enumerate(tail_candidates, start=1):
        g = reciprocal_decic(candidate)
        radii = tuple(rational_radius_bound(g, target) for target in (2, 4, 6, 8, 10))
        assert list(radii) == sorted(radii)
        assert radii[0] < 1
        remainders = prefix_remainders(g)
        selected = False
        for cutoff in CUTOFFS:
            remainder = remainders[cutoff]
            while len(remainder) > 1 and remainder[-1] == 0:
                remainder.pop()
            absolute_resultant = abs(resultant(list(reversed(g)), list(reversed(remainder))))
            resultants_checked += 1
            if absolute_resultant == 0:
                prefix_divisors.append((candidate, cutoff))
                selected = True
                break
            margin = tail_margin(cutoff, radii, absolute_resultant)
            if margin > 0:
                selected_counts[cutoff] += 1
                if minimum_margin is None or margin < minimum_margin:
                    minimum_margin = margin
                    minimum_candidate = candidate
                    minimum_cutoff = cutoff
                    minimum_resultant = absolute_resultant
                selected = True
                break
        if not selected:
            failures.append(candidate)
        if index % 25 == 0:
            print(f"exp45 tail checkpoint {index}/{len(tail_candidates)}", flush=True)

    assert not prefix_divisors, prefix_divisors
    assert not failures, failures
    assert dict(sorted(selected_counts.items())) == EXPECTED_TAIL_COUNTS
    assert sum(selected_counts.values()) == len(tail_candidates)
    assert resultants_checked == EXPECTED_RESULTANTS_CHECKED
    assert minimum_margin is not None and minimum_margin > 0
    assert minimum_candidate == EXPECTED_MINIMUM_CANDIDATE
    assert minimum_cutoff == EXPECTED_MINIMUM_CUTOFF
    assert minimum_resultant == EXPECTED_MINIMUM_RESULTANT

    result = {
        "experiment": "exp45-reciprocal-decic-certificate",
        "status": "audited-accept",
        "theorem_claim": True,
        "theorem": (
            "for every real X>=2, no irreducible reciprocal polynomial "
            "of degree 10 divides F_X"
        ),
        "trace_box_count": 10_002_902,
        "unit": {"count": len(unit), "sha256": candidate_digest(unit)},
        "no_real": {"count": len(no_real), "sha256": candidate_digest(no_real)},
        "rational_annulus": {"count": len(annulus), "sha256": candidate_digest(annulus)},
        "endpoint_count": len(endpoints),
        "routh_degenerate_count": len(routh_degenerate),
        "reducible": {
            "count": len(reducible_witnesses) + len(exceptional_witnesses),
            "linear": sum(len(factor) == 2 for factor in reducible_witnesses.values()),
            "quadratic": sum(len(factor) == 3 for factor in reducible_witnesses.values()),
            "exceptional_h_h_reverse": len(exceptional_witnesses),
        },
        "structural_irreducible": {
            "count": len(structural_irreducibles),
            "sha256": candidate_digest(structural_irreducibles),
            "authority": "trace irreducible and no t*h*h^rev factor",
        },
        "modular_irreducibility_cross_check": {
            "count": len(modular_witnesses),
            "witness_distribution": dict(sorted(Counter(modular_witnesses.values()).items())),
        },
        "cyclotomic": [list(row) for row in sorted(CYCLOTOMIC)],
        "tail_input_count": len(tail_candidates),
        "tail_input_sha256": candidate_digest(tail_candidates),
        "tail_selected_by_cutoff": dict(sorted(selected_counts.items())),
        "resultants_checked": resultants_checked,
        "prefix_divisors": prefix_divisors,
        "tail_failures": failures,
        "minimum_margin": [minimum_margin.numerator, minimum_margin.denominator],
        "minimum_margin_display_only": float(minimum_margin),
        "minimum_candidate": list(minimum_candidate),
        "minimum_cutoff": minimum_cutoff,
        "minimum_resultant": minimum_resultant,
        "source_provenance": provenance,
        "elapsed_seconds_display_only": perf_counter() - started,
    }
    # A concurrent edit during the exact run invalidates the certificate.
    assert source_provenance() == provenance
    rendered = json.dumps(result, sort_keys=True, indent=2)
    if args.ledger_out is not None:
        args.ledger_out.write_text(rendered + "\n", encoding="utf-8")
    print(rendered)


if __name__ == "__main__":
    main()

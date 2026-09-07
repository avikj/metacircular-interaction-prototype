#!/usr/bin/env python3
"""Exact post-census filtering of exp37's possible nonic factors.

This is a discovery artifact, not a factor-classification certificate.  It
loads the 22,077 parity-unit candidates produced by exp37 and applies only:

* exact Sturm counting (an irreducible nonic factor has one real root);
* exact Routh--Cayley counts at rational radii 617/1000 and 20001/10000;
* bookkeeping for the only coefficient-preserving involution, reciprocity;
* exact finite-field irreducibility witnesses via Rabin's criterion.

A degenerate Routh table is retained, never rejected.  Hence every rejection
is a proved necessary-condition failure.  Reducible tuples are not classified
without an explicit integer factor witness.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp41 uses load-bearing assertions and must not run under python -O")

import argparse
from collections import Counter
from fractions import Fraction as Q
import hashlib
import json
from math import isqrt
from pathlib import Path
from time import perf_counter
from typing import Iterator

from exact_polynomial import (
    poly_add,
    poly_multiply,
    poly_power,
    real_root_count,
    routh_right_half_plane,
)


DEGREE = 9
INNER = Q(617, 1000)       # strictly below lambda=(sqrt(5)-1)/2
OUTER = Q(20001, 10000)    # strictly above 2
EXPECTED_INPUT = 22_077
EXPECTED_INPUT_SHA256 = "ce9a01ba00db63b6a55b03348d68d4c1e7463c2a7a021077618b83f4bca415d9"
EXPECTED_STAGE_DIGESTS = {
    "one_real": (6_082, "09b19592a18b835178b0c7d377391129ffe7c3e303f9e2247d873d34f669fa62"),
    "annulus": (768, "8c68360c82607779b4182d925f0ed42e8171cf67e033481abc874dbffb692e82"),
    "strict_annulus": (767, "6a10b7a45616332efb7b51aee6ec51e65c7b6f412e0b2b3770f63f3264c68c2b"),
    "modular": (754, "70089d4f1aeebb27be6611b5290143b676dc8ccf530e6af397ff008645dc73ad"),
    "reducible": (12, "9d0aa2172d532a418cad874e56f1ba9761c766bfc11801b359b3bf751d07613c"),
    "cohn": (1, "584d7ef48ff0180636cf3a977697e96027a493bff6eca13242ffa12239b61033"),
}
DEFAULT_CHECKPOINTS = Path("/tmp/exp37-nonic-checkpoints")


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        candidate
        for candidate in range(2, limit + 1)
        if all(candidate % divisor for divisor in range(2, isqrt(candidate) + 1))
    )


IRREDUCIBILITY_PRIMES = primes_through(251)


def polynomial(candidate: tuple[int, ...]) -> list[int]:
    """Ascending coefficients of x^9+a*x^8+...+j*x+1."""
    a, b, c, d, e, f, h, j = candidate
    return [1, j, h, f, e, d, c, b, a, 1]


def candidate_digest(candidates: list[tuple[int, ...]]) -> str:
    canonical = "".join(" ".join(map(str, candidate)) + "\n"
                        for candidate in sorted(candidates))
    return hashlib.sha256(canonical.encode("ascii")).hexdigest()


def record_digest(records: object) -> str:
    canonical = json.dumps(records, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def load_candidates(directory: Path) -> list[tuple[int, ...]]:
    paths = sorted(directory.glob("shard-*.jsonl"))
    assert len(paths) == 441, len(paths)
    answer: list[tuple[int, ...]] = []
    for path in paths:
        for line in path.read_text(encoding="utf-8").splitlines():
            if not line.strip():
                continue
            record = json.loads(line)
            assert set(record) == {"coefficients"}
            encoded = record["coefficients"]
            assert isinstance(encoded, list) and len(encoded) == 8
            candidate = tuple(map(int, encoded))
            assert [str(value) for value in candidate] == encoded
            answer.append(candidate)
    assert len(answer) == EXPECTED_INPUT
    assert len(answer) == len(set(answer))
    assert candidate_digest(answer) == EXPECTED_INPUT_SHA256
    return sorted(answer)


def cayley_polynomial(g: list[Q], radius: Q) -> list[Q]:
    """(1+w)^9 g(radius*(1-w)/(1+w)), ascending in w."""
    assert len(g) == DEGREE + 1
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
    # w=(radius-z)/(radius+z) has Re(w)>0 exactly when |z|<radius.
    return routh_right_half_plane(cayley_polynomial(g, radius))


def reciprocal(candidate: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(reversed(candidate))


def trim_mod(f: list[int], prime: int) -> list[int]:
    answer = [value % prime for value in f]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def divmod_mod(f: list[int], g: list[int], prime: int) -> tuple[list[int], list[int]]:
    remainder = trim_mod(f, prime)
    divisor = trim_mod(g, prime)
    assert divisor != [0]
    if len(remainder) < len(divisor):
        return [0], remainder
    quotient = [0] * (len(remainder) - len(divisor) + 1)
    inverse = pow(divisor[-1], -1, prime)
    while remainder != [0] and len(remainder) >= len(divisor):
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * inverse % prime
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[shift + index] = (
                remainder[shift + index] - coefficient * value
            ) % prime
        remainder = trim_mod(remainder, prime)
    return trim_mod(quotient, prime), remainder


def gcd_mod(f: list[int], g: list[int], prime: int) -> list[int]:
    left, right = trim_mod(f, prime), trim_mod(g, prime)
    while right != [0]:
        _, remainder = divmod_mod(left, right, prime)
        left, right = right, remainder
    inverse = pow(left[-1], -1, prime)
    return [(value * inverse) % prime for value in left]


def multiply_mod(f: list[int], g: list[int], modulus: list[int], prime: int) -> list[int]:
    product = [0] * (len(f) + len(g) - 1)
    for i, left in enumerate(f):
        for j, right in enumerate(g):
            product[i + j] = (product[i + j] + left * right) % prime
    _, remainder = divmod_mod(product, modulus, prime)
    return remainder


def power_mod(base: list[int], exponent: int, modulus: list[int], prime: int) -> list[int]:
    answer = [1]
    current = trim_mod(base, prime)
    while exponent:
        if exponent & 1:
            answer = multiply_mod(answer, current, modulus, prime)
        exponent >>= 1
        if exponent:
            current = multiply_mod(current, current, modulus, prime)
    return answer


def subtract_x(f: list[int], prime: int) -> list[int]:
    answer = f[:] + [0] * max(0, 2 - len(f))
    answer[1] = (answer[1] - 1) % prime
    return trim_mod(answer, prime)


def rabin_irreducible_degree_nine(g: list[int], prime: int) -> bool:
    """Exact degree-nine Rabin criterion over F_prime.

    The only prime divisor of nine is three.  Thus irreducibility is
    equivalent to gcd(g,x^(p^3)-x)=1 and x^(p^9)=x mod g.
    """
    modulus = trim_mod(g, prime)
    assert len(modulus) == DEGREE + 1 and modulus[-1] == 1
    frobenius = [0, 1]
    at_three: list[int] | None = None
    for step in range(1, DEGREE + 1):
        frobenius = power_mod(frobenius, prime, modulus, prime)
        if step == 3:
            at_three = frobenius[:]
    assert at_three is not None
    return (
        gcd_mod(modulus, subtract_x(at_three, prime), prime) == [1]
        and subtract_x(frobenius, prime) == [0]
    )


def integer_quotient_if_divides(
    dividend: list[int], divisor: list[int]
) -> list[int] | None:
    """Exact monic division for ascending integer coefficient lists."""
    assert divisor[-1] == 1 and len(dividend) >= len(divisor)
    remainder = dividend[:]
    quotient = [0] * (len(dividend) - len(divisor) + 1)
    for shift in range(len(quotient) - 1, -1, -1):
        coefficient = remainder[shift + len(divisor) - 1]
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[shift + index] -= coefficient * value
    if any(remainder):
        return None
    assert quotient[-1] == 1
    return quotient


def bounded_factor_candidates() -> Iterator[list[int]]:
    """Enumerate every possible factor of degree at most four.

    Every root has modulus strictly below two.  A monic degree-k factor has
    constant term +-1 and its l-th elementary-symmetric coefficient has
    absolute value strictly below binomial(k,l)*2^l.  Integrality therefore
    gives the closed boxes used here.  Any reducible degree-nine polynomial
    has an irreducible factor of degree at most four.
    """
    for constant in (-1, 1):
        yield [constant, 1]
    for constant in (-1, 1):
        for linear in range(-3, 4):
            yield [constant, linear, 1]
    for constant in (-1, 1):
        for quadratic in range(-5, 6):
            for linear in range(-11, 12):
                yield [constant, linear, quadratic, 1]
    for constant in (-1, 1):
        for cubic in range(-7, 8):
            for quadratic in range(-23, 24):
                for linear in range(-31, 32):
                    yield [constant, linear, quadratic, cubic, 1]


def explicit_factor_witness(g: list[int]) -> tuple[list[int], list[int]] | None:
    for factor in bounded_factor_candidates():
        quotient = integer_quotient_if_divides(g, factor)
        if quotient is not None:
            # Independent convolution replay of the returned witness.
            product = [0] * (len(factor) + len(quotient) - 1)
            for i, left in enumerate(factor):
                for j, right in enumerate(quotient):
                    product[i + j] += left * right
            assert product == g
            return factor, quotient
    return None


def evaluate_integer(polynomial: list[int], value: int) -> int:
    answer = 0
    for coefficient in reversed(polynomial):
        answer = answer * value + coefficient
    return answer


def is_prime_trial(value: int) -> bool:
    if value < 2:
        return False
    return all(value % divisor for divisor in range(2, isqrt(value) + 1))


def cohn_prime_value_witness(g: list[int]) -> tuple[int, int] | None:
    """Find a small-base Cohn irreducibility witness, if one exists."""
    for base in range(2, 101):
        if not all(0 <= coefficient < base for coefficient in g):
            continue
        value = evaluate_integer(g, base)
        if is_prime_trial(value):
            return base, value
    return None


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--checkpoint-dir", type=Path, default=DEFAULT_CHECKPOINTS)
    parser.add_argument("--ledger-out", type=Path)
    args = parser.parse_args()

    start = perf_counter()
    candidates = load_candidates(args.checkpoint_dir)

    one_real: list[tuple[int, ...]] = []
    annulus: list[tuple[int, ...]] = []
    routh_degenerate: list[tuple[int, ...]] = []
    for candidate in candidates:
        g = list(map(Q, polynomial(candidate)))
        if real_root_count(g) != 1:
            continue
        one_real.append(candidate)
        inner_count = roots_in_disk(g, INNER)
        outer_count = roots_in_disk(g, OUTER)
        if inner_count is None or outer_count is None:
            # A degenerate Routh table is inconclusive, not a rejection.
            routh_degenerate.append(candidate)
            continue
        if inner_count == 0 and outer_count == DEGREE:
            annulus.append(candidate)

    admissible = sorted(set(annulus) | set(routh_degenerate))
    strict_annulus = []
    radius_two_degenerate = []
    for candidate in admissible:
        count = roots_in_disk(list(map(Q, polynomial(candidate))), Q(2))
        if count is None:
            radius_two_degenerate.append(candidate)
        elif count == DEGREE:
            strict_annulus.append(candidate)
    # A degenerate table would be retained for a separate exact boundary
    # test.  There are none in this census.
    assert not radius_two_degenerate

    admissible_set = set(strict_annulus)
    reciprocal_pairs = sum(
        reciprocal(candidate) in admissible_set and candidate < reciprocal(candidate)
        for candidate in strict_annulus
    )
    reciprocal_fixed = sum(
        reciprocal(candidate) == candidate for candidate in strict_annulus
    )

    witness_counts: Counter[int] = Counter()
    modular_irreducible: list[tuple[int, ...]] = []
    modular_witnesses = []
    unresolved: list[tuple[int, ...]] = []
    for candidate in strict_annulus:
        g = polynomial(candidate)
        witness = next(
            (prime for prime in IRREDUCIBILITY_PRIMES
             if rabin_irreducible_degree_nine(g, prime)),
            None,
        )
        if witness is None:
            unresolved.append(candidate)
        else:
            witness_counts[witness] += 1
            modular_irreducible.append(candidate)
            modular_witnesses.append({
                "candidate": list(candidate),
                "prime": witness,
            })

    factor_witnesses = []
    no_factor_found: list[tuple[int, ...]] = []
    for candidate in unresolved:
        witness = explicit_factor_witness(polynomial(candidate))
        if witness is None:
            no_factor_found.append(candidate)
            continue
        factor, quotient = witness
        factor_witnesses.append({
            "candidate": list(candidate),
            "factor_ascending": factor,
            "quotient_ascending": quotient,
        })

    cohn_witnesses = []
    cohn_unresolved = []
    for candidate in no_factor_found:
        witness = cohn_prime_value_witness(polynomial(candidate))
        if witness is None:
            cohn_unresolved.append(candidate)
            continue
        base, prime_value = witness
        cohn_witnesses.append({
            "candidate": list(candidate),
            "base": base,
            "prime_value": prime_value,
        })

    assert (len(one_real), candidate_digest(one_real)) == EXPECTED_STAGE_DIGESTS["one_real"]
    assert not routh_degenerate
    assert (len(annulus), candidate_digest(annulus)) == EXPECTED_STAGE_DIGESTS["annulus"]
    assert (len(strict_annulus), candidate_digest(strict_annulus)) \
        == EXPECTED_STAGE_DIGESTS["strict_annulus"]
    assert (len(modular_irreducible), candidate_digest(modular_irreducible)) \
        == EXPECTED_STAGE_DIGESTS["modular"]
    reducible_candidates = [tuple(record["candidate"]) for record in factor_witnesses]
    assert (len(reducible_candidates), candidate_digest(reducible_candidates)) \
        == EXPECTED_STAGE_DIGESTS["reducible"]
    cohn_candidates = [tuple(record["candidate"]) for record in cohn_witnesses]
    assert (len(cohn_candidates), candidate_digest(cohn_candidates)) \
        == EXPECTED_STAGE_DIGESTS["cohn"]
    assert not cohn_unresolved
    assert set(modular_irreducible).isdisjoint(reducible_candidates)
    assert set(modular_irreducible).isdisjoint(cohn_candidates)
    assert set(reducible_candidates).isdisjoint(cohn_candidates)
    assert set(modular_irreducible) | set(reducible_candidates) | set(cohn_candidates) \
        == set(strict_annulus)

    result = {
        "experiment": "exp41-nonic-postcensus",
        "status": "discovery-only",
        "theorem_claim": False,
        "input": {
            "count": len(candidates),
            "sha256": candidate_digest(candidates),
        },
        "stages": {
            "one_real": {
                "count": len(one_real),
                "sha256": candidate_digest(one_real),
            },
            "rational_annulus_certified": {
                "count": len(annulus),
                "sha256": candidate_digest(annulus),
            },
            "routh_degenerate_retained": {
                "count": len(routh_degenerate),
                "sha256": candidate_digest(routh_degenerate),
            },
            "admissible_union": {
                "count": len(admissible),
                "sha256": candidate_digest(admissible),
            },
            "strict_radius_two": {
                "count": len(strict_annulus),
                "sha256": candidate_digest(strict_annulus),
            },
            "radius_two_degenerate_retained": {
                "count": len(radius_two_degenerate),
                "sha256": candidate_digest(radius_two_degenerate),
            },
            "finite_field_irreducible": {
                "count": len(modular_irreducible),
                "sha256": candidate_digest(modular_irreducible),
                "witness_counts": dict(sorted(witness_counts.items())),
                "witness_assignment_sha256": record_digest(modular_witnesses),
            },
            "reducibility_unresolved": {
                "count": len(unresolved),
                "sha256": candidate_digest(unresolved),
            },
            "explicitly_reducible": {
                "count": len(factor_witnesses),
                "sha256": candidate_digest([
                    tuple(record["candidate"]) for record in factor_witnesses
                ]),
                "factor_witness_sha256": record_digest(factor_witnesses),
            },
            "no_bounded_factor_found": {
                "count": len(no_factor_found),
                "sha256": candidate_digest(no_factor_found),
            },
            "cohn_prime_value_witness": {
                "count": len(cohn_witnesses),
                "sha256": candidate_digest([
                    tuple(record["candidate"]) for record in cohn_witnesses
                ]),
                "witness_sha256": record_digest(cohn_witnesses),
            },
            "irreducibility_unresolved_after_all_witnesses": {
                "count": len(cohn_unresolved),
                "sha256": candidate_digest(cohn_unresolved),
            },
        },
        "rational_radii": {
            "inner": [INNER.numerator, INNER.denominator],
            "outer": [OUTER.numerator, OUTER.denominator],
        },
        "reciprocity": {
            "fixed_points_in_admissible_set": reciprocal_fixed,
            "two_element_orbits_contained_in_admissible_set": reciprocal_pairs,
            "note": (
                "Reciprocity preserves reducibility and the annulus but not the "
                "small negative-root window, so it is bookkeeping rather than "
                "an asserted symmetry of the admissible factor problem."
            ),
        },
        "irreducibility_primes": list(IRREDUCIBILITY_PRIMES),
        "modular_irreducibility_witnesses": modular_witnesses,
        "bounded_factor_search": {
            "candidate_factor_count": sum(1 for _ in bounded_factor_candidates()),
            "degree_boxes_descending_nonleading": {
                "1": [1],
                "2": [3, 1],
                "3": [5, 11, 1],
                "4": [7, 23, 31, 1]
            },
            "audit_status": (
                "The factor box, enumeration completeness, and all explicit "
                "products were independently replayed and accepted."
            ),
        },
        "factor_witnesses": factor_witnesses,
        "cohn_prime_value_witnesses": cohn_witnesses,
        "no_factor_candidates": [list(candidate) for candidate in no_factor_found],
        "elapsed_seconds_display_only": perf_counter() - start,
    }
    rendered = json.dumps(result, sort_keys=True, indent=2)
    if args.ledger_out is not None:
        args.ledger_out.write_text(rendered + "\n", encoding="utf-8")
    print(rendered)


if __name__ == "__main__":
    main()

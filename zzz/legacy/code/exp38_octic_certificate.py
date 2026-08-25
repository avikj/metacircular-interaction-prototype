#!/usr/bin/env python3
"""Corrected exact certificate excluding octic prime-prefix factors.

This is a fresh successor to the quarantined exp36 artifact.  The historical
files are intentionally left unchanged.  The correction reverses the
first-Graeffe majorant into ascending coefficient order:

    [y^1,...,y^7] -> (12, 59, 150, 209, 159, 64, 12).

The mathematical proof is recorded in ``notes/OCTIC_OBSTRUCTION_V2.md``.
Generic exact polynomial/root utilities come from ``exact_polynomial.py``;
all octic-specific logic and constants are local to this file.  The
quarantined exp36 artifact is not imported.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp38 is an exact certificate and must not run under python -O")

from fractions import Fraction as Q
import hashlib
import json
from math import isqrt
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
from time import perf_counter

from exact_polynomial import (
    poly_add,
    poly_multiply,
    poly_power,
    real_root_count,
    resultant,
    routh_right_half_plane,
)


ENUMERATOR_COUNTS = (
    42_025,
    895_762_875,
    206_489_067,
    122_320_525,
    139_448,
    95_116,
)
GRAEFFE_BOUNDS_ASCENDING = (12, 59, 150, 209, 159, 64, 12)
DEGREE = 8
INNER = Q(617, 1000)
OUTER = Q(20001, 10000)

EXPECTED_NO_REAL = 37_284
EXPECTED_ANNULUS = 7_092
EXPECTED_ORBITS = 2_473
EXPECTED_REDUCIBLE_ORBITS = 78
EXPECTED_IRREDUCIBLE_ORBITS = 2_395
EXPECTED_FULL_IRREDUCIBLES = 6_840
EXPECTED_NONCYCLOTOMIC = 6_838
EXPECTED_MINIMUM_CANDIDATE = (-1, 0, 0, 0, 1, 1, -2)
EXPECTED_MINIMUM_CUTOFF = 11
EXPECTED_SELECTED = {
    11: 5_535,
    13: 509,
    17: 311,
    19: 138,
    23: 174,
    29: 60,
    31: 39,
    37: 31,
    41: 9,
    43: 9,
    47: 9,
    53: 5,
    59: 2,
    61: 3,
    67: 0,
    71: 2,
    73: 0,
    79: 0,
    83: 2,
}

# Phi_15 and Phi_30, in (a,b,c,d,e,f,h) coordinates.
CYCLOTOMIC = {
    (-1, 0, 1, -1, 1, 0, -1),
    (1, 0, -1, -1, -1, 0, 1),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compiler_identity(compiler: str) -> str:
    process = subprocess.run([compiler, "--version"], text=True,
                             capture_output=True, check=True)
    return process.stdout.splitlines()[0]


def compile_and_enumerate() -> tuple[list[tuple[int, ...]], dict[str, str]]:
    compiler = shutil.which("c++") or shutil.which("g++") or shutil.which("clang++")
    if compiler is None:
        raise RuntimeError("an ISO C++17 compiler is required")
    source = Path(__file__).with_name("exp38_octic_enumerator.cpp")
    header = Path(__file__).with_name("exp38_octic_bounds.hpp")
    root = Path(__file__).resolve().parents[1]
    contract = root / "machinery" / "specs" / "octic-graeffe-exp38.json"
    contract_tool = root / "machinery" / "bound_contract.py"
    flags = ("-std=c++17", "-O3")
    with tempfile.TemporaryDirectory(prefix="exp38-octic-") as directory:
        generated_header = Path(directory) / "generated_bounds.hpp"
        subprocess.run([
            sys.executable,
            str(contract_tool),
            str(contract),
            "--emit-cpp",
            str(generated_header),
            "--symbol",
            "kGraeffeBounds",
        ], check=True, capture_output=True, text=True)
        assert generated_header.read_bytes() == header.read_bytes()
        binary = Path(directory) / "enumerator"
        subprocess.run([compiler, *flags, str(source), "-o", str(binary)], check=True)
        provenance = {
            "certificate_python_sha256": sha256(Path(__file__)),
            "exact_polynomial_sha256": sha256(Path(__file__).with_name("exact_polynomial.py")),
            "source_sha256": sha256(source),
            "bounds_header_sha256": sha256(header),
            "bounds_contract_sha256": sha256(contract),
            "binary_sha256": sha256(binary),
            "compiler": compiler_identity(compiler),
            "flags": " ".join(flags),
        }
        run = subprocess.run([str(binary)], text=True, capture_output=True, check=True)

    counts = tuple(map(int, run.stderr.split()))
    assert counts == ENUMERATOR_COUNTS, counts
    candidates = [tuple(map(int, line.split())) for line in run.stdout.splitlines()]
    assert len(candidates) == ENUMERATOR_COUNTS[-1]
    assert len(candidates) == len(set(candidates))
    return candidates, provenance


def polynomial(candidate: tuple[int, ...]) -> list[int]:
    """Ascending coefficients of x^8+a*x^7+...+h*x+1."""
    a, b, c, d, e, f, h = candidate
    return [1, h, f, e, d, c, b, a, 1]


def cayley_polynomial(g: list[Q], radius: Q) -> list[Q]:
    """(1+w)^8 g(radius*(1-w)/(1+w)), ascending in w."""
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


def sign_transform(candidate: tuple[int, ...]) -> tuple[int, ...]:
    a, b, c, d, e, f, h = candidate
    return (-a, b, -c, d, -e, f, -h)


def reciprocal(candidate: tuple[int, ...]) -> tuple[int, ...]:
    a, b, c, d, e, f, h = candidate
    return (h, f, e, d, c, b, a)


def canonical(candidate: tuple[int, ...]) -> tuple[int, ...]:
    orbit = set()
    current = candidate
    for _ in range(2):
        orbit.add(current)
        orbit.add(sign_transform(current))
        current = reciprocal(current)
    return min(orbit)


def integer_divides(dividend: list[int], divisor: list[int]) -> bool:
    """Exact monic division, with ascending coefficient lists."""
    remainder = dividend[:]
    for shift in range(len(remainder) - len(divisor), -1, -1):
        coefficient = remainder[shift + len(divisor) - 1]
        for index, value in enumerate(divisor):
            remainder[shift + index] -= coefficient * value
    return all(value == 0 for value in remainder)


def reducible_octic(candidate: tuple[int, ...]) -> bool:
    """Complete quadratic/quartic factor search in the proved root box."""
    g = polynomial(candidate)
    for middle in (-1, 0, 1):
        if integer_divides(g, [1, middle, 1]):
            return True
    for cubic in range(-4, 5):
        for quadratic in range(-8, 9):
            for linear in range(-4, 5):
                if integer_divides(g, [1, linear, quadratic, cubic, 1]):
                    return True
    return False


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        candidate
        for candidate in range(2, limit + 1)
        if all(candidate % divisor for divisor in range(2, isqrt(candidate) + 1))
    )


PRIMES = primes_through(89)
CUTOFFS = tuple(prime for prime in PRIMES if 11 <= prime <= 83)


def prefix_remainders(candidate: tuple[int, ...]) -> dict[int, list[int]]:
    """F_p modulo g at every prime cutoff 11<=p<=83."""
    g = polynomial(candidate)
    power = [1] + [0] * 7
    remainder = [0] * 8
    prime_at_exponent = {prime - 2: prime for prime in PRIMES}
    answer = {}
    for exponent in range(CUTOFFS[-1] - 1):
        if exponent in prime_at_exponent:
            prime = prime_at_exponent[exponent]
            for index in range(8):
                remainder[index] += power[index]
            if prime in CUTOFFS:
                answer[prime] = remainder[:]
        last = power[-1]
        power = [-last * g[0]] + [
            power[index - 1] - last * g[index] for index in range(1, 8)
        ]
    assert set(answer) == set(CUTOFFS)
    return answer


def rational_radius_bound(g: list[Q], target_count: int) -> Q:
    """Exact upper bound for the target_count-th root ordered by modulus."""
    lower = INNER
    upper = OUTER
    lower_count = roots_in_disk(g, lower)
    upper_count = roots_in_disk(g, upper)
    assert lower_count is not None and upper_count is not None
    assert lower_count < target_count <= upper_count
    for _ in range(14):
        middle = (lower + upper) / 2
        count = roots_in_disk(g, middle)
        if count is None:
            step = (upper - lower) / 100_000_000
            for multiplier in range(1, 100):
                count = roots_in_disk(g, middle + multiplier * step)
                if count is not None:
                    middle += multiplier * step
                    break
            assert count is not None
        if count >= target_count:
            upper = middle
        else:
            lower = middle
    for _ in range(20):
        if target_count != 2 or upper < 1:
            break
        middle = (lower + upper) / 2
        count = roots_in_disk(g, middle)
        if count is None:
            middle += (upper - lower) / 100_000_000
            count = roots_in_disk(g, middle)
            assert count is not None
        if count >= target_count:
            upper = middle
        else:
            lower = middle
    return upper


def tail_margin(
    cutoff: int, radii: tuple[Q, Q, Q, Q], absolute_resultant: int
) -> Q:
    first, second, third, fourth = radii
    next_prime = next(prime for prime in PRIMES if prime > cutoff)
    first_tail_exponent = next_prime - 2
    prefix_bounds = [
        sum((radius ** (prime - 2) for prime in PRIMES if prime <= cutoff), Q(0))
        for radius in (second, third, fourth)
    ]
    return (
        Q(absolute_resultant) * (1 - first * first) ** 2
        - first ** (2 * first_tail_exponent)
        * prefix_bounds[0] ** 2
        * prefix_bounds[1] ** 2
        * prefix_bounds[2] ** 2
    )


def direct_graeffe(candidate: tuple[int, ...]) -> tuple[int, ...]:
    """Return coefficients y^0,...,y^8 of E^2-yO^2 by convolution."""
    a, b, c, d, e, f, h = candidate
    even = (1, f, d, b, 1)
    odd = (h, e, c, a)
    answer = [0] * 9
    for left, x in enumerate(even):
        for right, y in enumerate(even):
            answer[left + right] += x * y
    for left, x in enumerate(odd):
        for right, y in enumerate(odd):
            answer[1 + left + right] -= x * y
    return tuple(answer)


def explicit_graeffe(candidate: tuple[int, ...]) -> tuple[int, ...]:
    """Independent coefficient-level expansion, indexed by ascending power."""
    a, b, c, d, e, f, h = candidate
    return (
        1,
        2 * f - h * h,
        f * f + 2 * d - 2 * h * e,
        2 * b + 2 * f * d - e * e - 2 * h * c,
        2 + 2 * f * b + d * d - 2 * h * a - 2 * e * c,
        2 * f + 2 * d * b - c * c - 2 * e * a,
        b * b + 2 * d - 2 * c * a,
        2 * b - a * a,
        1,
    )


def check_coefficient_indices(candidates: list[tuple[int, ...]]) -> None:
    # These fixed probes include each individual variable and mixed signs, so
    # a reversal or E/O convention change fails before the expensive stages.
    probes = [
        (0, 0, 0, 0, 0, 0, 0),
        (1, 0, 0, 0, 0, 0, 0),
        (0, 1, 0, 0, 0, 0, 0),
        (0, 0, 1, 0, 0, 0, 0),
        (0, 0, 0, 1, 0, 0, 0),
        (0, 0, 0, 0, 1, 0, 0),
        (0, 0, 0, 0, 0, 1, 0),
        (0, 0, 0, 0, 0, 0, 1),
        (-2, 3, -5, 7, -11, 13, -17),
    ]
    for candidate in probes:
        assert direct_graeffe(candidate) == explicit_graeffe(candidate)
    assert GRAEFFE_BOUNDS_ASCENDING == (12, 59, 150, 209, 159, 64, 12)
    contract_path = (Path(__file__).resolve().parents[1] / "machinery" / "specs"
                     / "octic-graeffe-exp38.json")
    contract = json.loads(contract_path.read_text(encoding="utf-8"))
    bounds_by_exponent = {
        int(exponent): int(bound)
        for exponent, bound in contract["bounds_by_exponent"].items()
    }
    assert tuple(bounds_by_exponent[exponent] for exponent in range(1, 8)) \
        == GRAEFFE_BOUNDS_ASCENDING
    assert contract["derived_vector"]["orientation"] == "leading-to-constant"
    assert tuple(contract["derived_vector"]["values"]) == (
        "12", "64", "159", "209", "150", "59", "12"
    )

    # Every tuple emitted by C++ is replayed against independently indexed
    # coefficients and the corrected ascending bounds.
    for candidate in candidates:
        coefficients = direct_graeffe(candidate)
        assert coefficients[0] == coefficients[8] == 1
        assert all(
            abs(coefficients[exponent]) <= GRAEFFE_BOUNDS_ASCENDING[exponent - 1]
            for exponent in range(1, 8)
        )


def main() -> None:
    start = perf_counter()
    unit_nonpositive, provenance = compile_and_enumerate()
    check_coefficient_indices(unit_nonpositive)

    no_real_by_a = {a: 0 for a in range(-9, 1)}
    annulus_by_a = {a: 0 for a in range(-9, 1)}
    annulus_nonpositive = []
    for candidate in unit_nonpositive:
        a = candidate[0]
        candidate_polynomial = list(map(Q, polynomial(candidate)))
        if real_root_count(candidate_polynomial) != 0:
            continue
        no_real_by_a[a] += 1
        inner_count = roots_in_disk(candidate_polynomial, INNER)
        outer_count = roots_in_disk(candidate_polynomial, OUTER)
        assert inner_count is not None and outer_count is not None
        if inner_count != 0 or outer_count != 8:
            continue
        annulus_by_a[a] += 1
        annulus_nonpositive.append(candidate)

    expected_annulus_by_a = {
        -9: 0, -8: 0, -7: 0, -6: 0, -5: 0,
        -4: 3, -3: 131, -2: 415, -1: 1_640, 0: 2_714,
    }
    assert annulus_by_a == expected_annulus_by_a, annulus_by_a
    full_no_real = 2 * sum(no_real_by_a[a] for a in range(-9, 0)) + no_real_by_a[0]
    assert full_no_real == EXPECTED_NO_REAL

    full_annulus = set(annulus_nonpositive)
    full_annulus.update(sign_transform(candidate) for candidate in annulus_nonpositive)
    assert len(full_annulus) == EXPECTED_ANNULUS
    representatives = sorted({canonical(candidate) for candidate in full_annulus})
    assert len(representatives) == EXPECTED_ORBITS

    reducible = {candidate for candidate in representatives if reducible_octic(candidate)}
    assert len(reducible) == EXPECTED_REDUCIBLE_ORBITS
    irreducible_orbits = set(representatives) - reducible
    assert len(irreducible_orbits) == EXPECTED_IRREDUCIBLE_ORBITS

    irreducibles = sorted(
        candidate for candidate in full_annulus
        if canonical(candidate) in irreducible_orbits
    )
    assert len(irreducibles) == EXPECTED_FULL_IRREDUCIBLES
    assert CYCLOTOMIC <= set(irreducibles)
    irreducibles = [candidate for candidate in irreducibles
                    if candidate not in CYCLOTOMIC]
    assert len(irreducibles) == EXPECTED_NONCYCLOTOMIC

    selected_counts = {cutoff: 0 for cutoff in CUTOFFS}
    minimum_margin = None
    minimum_candidate = None
    minimum_cutoff = None
    for candidate in irreducibles:
        polynomial_int = polynomial(candidate)
        polynomial_q = list(map(Q, polynomial_int))
        descending = list(reversed(polynomial_int))
        radii = tuple(rational_radius_bound(polynomial_q, target)
                      for target in (2, 4, 6, 8))
        assert list(radii) == sorted(radii)
        assert radii[0] < 1
        remainders = prefix_remainders(candidate)

        selected = False
        for cutoff in CUTOFFS:
            remainder = remainders[cutoff]
            while len(remainder) > 1 and remainder[-1] == 0:
                remainder.pop()
            absolute_resultant = abs(resultant(descending, list(reversed(remainder))))
            assert absolute_resultant != 0, (candidate, cutoff)
            margin = tail_margin(cutoff, radii, absolute_resultant)
            if margin > 0:
                selected_counts[cutoff] += 1
                if minimum_margin is None or margin < minimum_margin:
                    minimum_margin = margin
                    minimum_candidate = candidate
                    minimum_cutoff = cutoff
                selected = True
                break
        assert selected, candidate

    assert selected_counts == EXPECTED_SELECTED, selected_counts
    assert sum(selected_counts.values()) == EXPECTED_NONCYCLOTOMIC
    assert minimum_margin is not None and minimum_margin > 0
    assert minimum_candidate == EXPECTED_MINIMUM_CANDIDATE
    assert minimum_cutoff == EXPECTED_MINIMUM_CUTOFF

    print("corrected octic certificate: PASS")
    print(f"enumerator counts: {ENUMERATOR_COUNTS}")
    print(f"Graeffe bounds y^1..y^7: {GRAEFFE_BOUNDS_ASCENDING}")
    print(f"no-real tuples: {EXPECTED_NO_REAL}")
    print(f"rational-annulus tuples: {EXPECTED_ANNULUS}")
    print(f"symmetry orbits: {EXPECTED_ORBITS}")
    print(f"reducible orbits: {EXPECTED_REDUCIBLE_ORBITS}")
    print(f"irreducible candidates: {EXPECTED_FULL_IRREDUCIBLES}")
    print(f"cyclotomic exclusions: {len(CYCLOTOMIC)}")
    print(f"tail certificates by cutoff: {selected_counts}")
    print(f"minimum margin candidate: {minimum_candidate} at {minimum_cutoff}")
    print(f"minimum margin decimal: {float(minimum_margin):.12g}")
    print(f"source sha256: {provenance['source_sha256']}")
    print(f"certificate Python sha256: {provenance['certificate_python_sha256']}")
    print(f"exact-polynomial kernel sha256: {provenance['exact_polynomial_sha256']}")
    print(f"bounds header sha256: {provenance['bounds_header_sha256']}")
    print(f"bounds contract sha256: {provenance['bounds_contract_sha256']}")
    print(f"binary sha256: {provenance['binary_sha256']}")
    print(f"compiler: {provenance['compiler']}")
    print(f"flags: {provenance['flags']}")
    print(f"elapsed seconds: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()

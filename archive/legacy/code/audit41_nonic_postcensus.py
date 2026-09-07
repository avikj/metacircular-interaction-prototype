#!/usr/bin/env python3
"""Independent hostile replay of exp41's nonic post-census partition.

This audit intentionally does not import ``exp41_nonic_postcensus``.  It uses
the shared constant-free exact-polynomial kernel for Sturm/Routh only, and a
separate quotient-ring implementation for all finite-field certificates.

The arbitrary-base prime-digit theorem used at the singleton is Theorem 2 of
M. Filaseta, *Irreducibility Criteria for Polynomials with Non-negative
Coefficients*, Canad. J. Math. 40 (1988), 339--351, which cites the original
general-base result of Brillhart--Filaseta--Odlyzko, Canad. J. Math. 33
(1981), 1055--1059, DOI 10.4153/CJM-1981-080-0.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("audit41 must not run under python -O")

from fractions import Fraction as Q
import hashlib
import itertools
import json
from math import isqrt
from pathlib import Path
import sys

from exact_polynomial import (
    poly_add,
    poly_multiply,
    poly_power,
    real_root_count,
    routh_right_half_plane,
)


DEGREE = 9
INNER = Q(617, 1000)
OUTER = Q(20001, 10000)
ROOT = Path(__file__).resolve().parents[1]
CHECKPOINTS = Path("/tmp/exp37-nonic-checkpoints")
DATA = ROOT / "data" / "exp41_nonic_postcensus.json"


def digest(candidates: list[tuple[int, ...]]) -> str:
    text = "".join(" ".join(map(str, candidate)) + "\n"
                   for candidate in sorted(candidates))
    return hashlib.sha256(text.encode("ascii")).hexdigest()


def record_digest(records: object) -> str:
    text = json.dumps(records, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def load_candidates() -> list[tuple[int, ...]]:
    paths = sorted(CHECKPOINTS.glob("shard-*.jsonl"))
    assert len(paths) == 441
    candidates = []
    for path in paths:
        for line in path.read_text(encoding="utf-8").splitlines():
            if line:
                record = json.loads(line)
                candidates.append(tuple(map(int, record["coefficients"])))
    assert len(candidates) == len(set(candidates)) == 22_077
    assert digest(candidates) == "ce9a01ba00db63b6a55b03348d68d4c1e7463c2a7a021077618b83f4bca415d9"
    return sorted(candidates)


def polynomial(candidate: tuple[int, ...]) -> list[int]:
    a, b, c, d, e, f, h, j = candidate
    return [1, j, h, f, e, d, c, b, a, 1]


def cayley(g: list[Q], radius: Q) -> list[Q]:
    answer = [Q(0)]
    for exponent, coefficient in enumerate(g):
        term = poly_multiply(
            poly_power([radius, -radius], exponent),
            poly_power([Q(1), Q(1)], DEGREE - exponent),
        )
        answer = poly_add(answer, [coefficient * value for value in term])
    return answer


def disk_count(g: list[Q], radius: Q) -> int | None:
    # For z=r(1-w)/(1+w), direct multiplication gives
    # Re(w)=(r^2-|z|^2)/|r+z|^2.  Thus RHP means |z|<r.
    return routh_right_half_plane(cayley(g, radius))


# Independent modular implementation: fixed-length quotient-ring reduction.
def reduce_quotient(polynomial: list[int], modulus: list[int], prime: int) -> list[int]:
    work = [value % prime for value in polynomial]
    while len(work) > 1 and work[-1] == 0:
        work.pop()
    degree = len(modulus) - 1
    for exponent in range(len(work) - 1, degree - 1, -1):
        coefficient = work[exponent] % prime
        if coefficient:
            shift = exponent - degree
            for index in range(degree + 1):
                work[shift + index] = (
                    work[shift + index] - coefficient * modulus[index]
                ) % prime
    work = work[:degree]
    while len(work) > 1 and work[-1] == 0:
        work.pop()
    return work


def multiply_quotient(
    first: list[int], second: list[int], modulus: list[int], prime: int
) -> list[int]:
    product = [0] * (len(first) + len(second) - 1)
    for i, left in enumerate(first):
        for j, right in enumerate(second):
            product[i + j] += left * right
    return reduce_quotient(product, modulus, prime)


def power_quotient(
    base: list[int], exponent: int, modulus: list[int], prime: int
) -> list[int]:
    answer = [1]
    power = reduce_quotient(base, modulus, prime)
    while exponent:
        if exponent & 1:
            answer = multiply_quotient(answer, power, modulus, prime)
        power = multiply_quotient(power, power, modulus, prime)
        exponent //= 2
    return answer


def trim_mod(polynomial: list[int], prime: int) -> list[int]:
    answer = [value % prime for value in polynomial]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def remainder_mod(dividend: list[int], divisor: list[int], prime: int) -> list[int]:
    work = trim_mod(dividend, prime)
    divisor = trim_mod(divisor, prime)
    inverse = pow(divisor[-1], -1, prime)
    while work != [0] and len(work) >= len(divisor):
        coefficient = work[-1] * inverse % prime
        shift = len(work) - len(divisor)
        for index, value in enumerate(divisor):
            work[shift + index] = (work[shift + index] - coefficient * value) % prime
        work = trim_mod(work, prime)
    return work


def gcd_mod(first: list[int], second: list[int], prime: int) -> list[int]:
    first, second = trim_mod(first, prime), trim_mod(second, prime)
    while second != [0]:
        first, second = second, remainder_mod(first, second, prime)
    inverse = pow(first[-1], -1, prime)
    return [(value * inverse) % prime for value in first]


def subtract_x(polynomial: list[int], prime: int) -> list[int]:
    answer = polynomial[:] + [0] * max(0, 2 - len(polynomial))
    answer[1] = (answer[1] - 1) % prime
    return trim_mod(answer, prime)


def rabin(g: list[int], prime: int) -> bool:
    modulus = [value % prime for value in g]
    assert len(modulus) == 10 and modulus[-1] == 1
    x_power = [0, 1]
    at_three = None
    for step in range(1, 10):
        x_power = power_quotient(x_power, prime, modulus, prime)
        if step == 3:
            at_three = x_power[:]
    assert at_three is not None
    # Degree 9 has the sole prime divisor 3.
    return gcd_mod(modulus, subtract_x(at_three, prime), prime) == [1] \
        and subtract_x(x_power, prime) == [0]


def primes_through(limit: int) -> tuple[int, ...]:
    return tuple(
        value for value in range(2, limit + 1)
        if all(value % divisor for divisor in range(2, isqrt(value) + 1))
    )


def low_end_quotient(dividend: list[int], divisor: list[int]) -> list[int] | None:
    """Independent exact division derived from the constant coefficient."""
    constant = divisor[0]
    assert constant in (-1, 1) and divisor[-1] == 1
    quotient_degree = len(dividend) - len(divisor)
    quotient = [0] * (quotient_degree + 1)
    for exponent in range(quotient_degree + 1):
        known = sum(
            divisor[index] * quotient[exponent - index]
            for index in range(1, min(exponent, len(divisor) - 1) + 1)
        )
        numerator = dividend[exponent] - known
        quotient[exponent] = numerator // constant
        assert numerator % constant == 0
    product = [0] * (len(divisor) + len(quotient) - 1)
    for i, left in enumerate(divisor):
        for j, right in enumerate(quotient):
            product[i + j] += left * right
    return quotient if product == dividend else None


def factor_candidates():
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


def main() -> None:
    data = json.loads(DATA.read_text(encoding="utf-8"))
    candidates = load_candidates()

    # Orientation smoke tests: z=0 maps to w=+1 (inside); z=2r maps to
    # w=-1/3 (outside).  These are direct exact tests of the Routh sign.
    assert routh_right_half_plane([Q(1), Q(-1)]) == 1
    assert routh_right_half_plane([Q(1), Q(3)]) == 0

    one_real = []
    annulus = []
    for candidate in candidates:
        g = list(map(Q, polynomial(candidate)))
        if real_root_count(g) != 1:
            continue
        one_real.append(candidate)
        inner = disk_count(g, INNER)
        outer = disk_count(g, OUTER)
        assert inner is not None and outer is not None
        if inner == 0 and outer == 9:
            annulus.append(candidate)
    assert (len(one_real), digest(one_real)) == tuple(data["stages"]["one_real"])
    assert (len(annulus), digest(annulus)) == tuple(data["stages"]["rational_annulus"])

    strict_annulus = []
    for candidate in annulus:
        count = disk_count(list(map(Q, polynomial(candidate))), Q(2))
        assert count is not None
        if count == DEGREE:
            strict_annulus.append(candidate)
    assert (len(strict_annulus), digest(strict_annulus)) \
        == tuple(data["stages"]["strict_radius_two"])

    primes = primes_through(251)
    modular_records = []
    no_modular_witness = []
    for candidate in strict_annulus:
        witness = next((prime for prime in primes if rabin(polynomial(candidate), prime)), None)
        if witness is None:
            no_modular_witness.append(candidate)
        else:
            modular_records.append({"candidate": list(candidate), "prime": witness})
    modular_candidates = [tuple(record["candidate"]) for record in modular_records]
    assert (len(modular_candidates), digest(modular_candidates)) \
        == tuple(data["stages"]["finite_field_irreducible"])
    assert record_digest(modular_records) == data["finite_field_witnesses"]["assignment_sha256"]

    all_factors = tuple(factor_candidates())
    assert len(all_factors) == 89_352
    found = []
    factorless = []
    for candidate in no_modular_witness:
        g = polynomial(candidate)
        witness = next(
            ((factor, quotient) for factor in all_factors
             if (quotient := low_end_quotient(g, factor)) is not None),
            None,
        )
        if witness is None:
            factorless.append(candidate)
        else:
            found.append(candidate)
    assert (len(found), digest(found)) == tuple(data["stages"]["explicitly_reducible"])
    assert factorless == [(0, 0, 0, 0, 0, 4, 0, 0)]

    # Arbitrary-base Cohn: coefficients are base-six digits and value is prime.
    singleton = polynomial(factorless[0])
    assert all(0 <= coefficient < 6 for coefficient in singleton)
    value = sum(coefficient * 6**exponent for exponent, coefficient in enumerate(singleton))
    assert value == 10_078_561
    assert all(value % divisor for divisor in range(2, isqrt(value) + 1))

    print("audit41 hostile replay: ACCEPT")
    print(f"one-real: {len(one_real)}")
    print(f"rational annulus: {len(annulus)}")
    print(f"strict radius two: {len(strict_annulus)}")
    print(f"finite-field irreducible: {len(modular_candidates)}")
    print(f"explicit reducibles: {len(found)}")
    print("singleton Cohn witness: x^9+4x^3+1 at base 6")


if __name__ == "__main__":
    main()

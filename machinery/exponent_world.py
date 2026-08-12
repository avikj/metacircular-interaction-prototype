#!/usr/bin/env python3
"""Compile recursive multiplicative origins into prime-exponent coordinates."""

from __future__ import annotations

from dataclasses import dataclass
from math import prod

from arithmetic_life import ArithmeticLife


@dataclass(frozen=True)
class FactorNode:
    value: int
    left: int | None
    right: int | None


@dataclass(frozen=True)
class ExponentForm:
    value: int
    powers: tuple[tuple[int, int], ...]
    derivation: tuple[FactorNode, ...]

    def reconstruct(self) -> int:
        return prod(prime ** exponent for prime, exponent in self.powers)


@dataclass(frozen=True)
class BezoutInverse:
    value: int
    modulus: int
    coefficient: int
    modulus_coefficient: int
    inverse: int

    def solve(self, target: int) -> int:
        """Solve value*z = target modulo modulus in the formed prime field."""
        return (self.inverse * target) % self.modulus


class ExponentWorld:
    """A persistent arithmetic coordinate chart formed by recursive factoring."""

    def __init__(self, life: ArithmeticLife | None = None) -> None:
        self.life = life or ArithmeticLife()
        self.forms: dict[int, ExponentForm] = {
            1: ExponentForm(1, (), (FactorNode(1, None, None),))
        }

    def form(self, n: int) -> ExponentForm:
        if n < 1:
            raise ValueError("exponent coordinates require a positive integer")
        if n in self.forms:
            return self.forms[n]
        split = self.life.factor(n)
        if split is None:
            result = ExponentForm(n, ((n, 1),), (FactorNode(n, None, None),))
        else:
            left, right = split
            left_form, right_form = self.form(left), self.form(right)
            counts = dict(left_form.powers)
            for prime, exponent in right_form.powers:
                counts[prime] = counts.get(prime, 0) + exponent
            powers = tuple(sorted(counts.items()))
            derivation = (
                FactorNode(n, left, right),
                *left_form.derivation,
                *right_form.derivation,
            )
            result = ExponentForm(n, powers, derivation)
        if result.reconstruct() != n:
            raise AssertionError("formed exponent chart failed reconstruction")
        self.forms[n] = result
        return result

    def multiply(self, left: int, right: int) -> ExponentForm:
        a, b = self.form(left), self.form(right)
        counts = dict(a.powers)
        for prime, exponent in b.powers:
            counts[prime] = counts.get(prime, 0) + exponent
        value = left * right
        result = ExponentForm(
            value,
            tuple(sorted(counts.items())),
            (FactorNode(value, left, right), *a.derivation, *b.derivation),
        )
        self.forms[value] = result
        return result

    def gcd(self, left: int, right: int) -> ExponentForm:
        a, b = dict(self.form(left).powers), dict(self.form(right).powers)
        powers = tuple(
            (prime, min(a[prime], b[prime]))
            for prime in sorted(a.keys() & b.keys())
            if min(a[prime], b[prime])
        )
        value = prod(prime ** exponent for prime, exponent in powers)
        return self.form(value)

    def lcm(self, left: int, right: int) -> ExponentForm:
        a, b = dict(self.form(left).powers), dict(self.form(right).powers)
        powers = tuple(
            (prime, max(a.get(prime, 0), b.get(prime, 0)))
            for prime in sorted(a.keys() | b.keys())
        )
        value = prod(prime ** exponent for prime, exponent in powers)
        if value not in self.forms:
            self.forms[value] = ExponentForm(
                value, powers,
                (FactorNode(value, left, right),
                 *self.form(left).derivation, *self.form(right).derivation),
            )
        return self.forms[value]

    def divisor_count(self, n: int) -> int:
        return prod(exponent + 1 for _prime, exponent in self.form(n).powers)

    def form_inverse(self, value: int, modulus: int) -> BezoutInverse:
        """Let earned multiplicative and residue memories form division.

        Both integers must already have exponent forms, and the modulus must
        already be an installed prime residue sensor. This is a causal gate,
        not a mathematical requirement of the extended Euclidean algorithm.
        """
        if value not in self.forms or modulus not in self.forms:
            raise ValueError("value and modulus need earned exponent forms")
        if modulus not in self.life.moduli:
            raise ValueError("modulus needs an earned residue sensor")
        if self.forms[modulus].powers != ((modulus, 1),):
            raise ValueError("division is installed only at a formed prime generator")
        common, coefficient, modulus_coefficient = _extended_gcd(value, modulus)
        if common != 1:
            raise ValueError("value is not invertible modulo the sensor")
        inverse = coefficient % modulus
        if value * inverse % modulus != 1:
            raise AssertionError("Bezout certificate failed to form an inverse")
        self.life._record(
            "form-operation",
            (value, modulus, coefficient, modulus_coefficient, inverse),
            "Bezout descent turns earned mod-prime observation into division; "
            "solve value*z=target by z=inverse*target",
        )
        return BezoutInverse(
            value, modulus, coefficient, modulus_coefficient, inverse
        )


def _extended_gcd(a: int, b: int) -> tuple[int, int, int]:
    """Return positive gcd g and coefficients x,y with ax+by=g."""
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t
    if old_r < 0:
        return -old_r, -old_s, -old_t
    return old_r, old_s, old_t


def main() -> None:
    world = ExponentWorld()
    for n in (72, 90):
        form = world.form(n)
        print(f"{n} -> {form.powers}; reconstruction={form.reconstruct()}")
    print(f"gcd -> {world.gcd(72, 90).powers}")
    print(f"lcm -> {world.lcm(72, 90).powers}")
    print(f"divisors(72) -> {world.divisor_count(72)}")
    print(f"formed worlds cached -> {tuple(sorted(world.forms))}")


if __name__ == "__main__":
    main()

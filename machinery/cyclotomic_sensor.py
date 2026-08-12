#!/usr/bin/env python3
"""A formed organ that answers `v_p(a^n - 1)` for every n after one encounter.

The exponent chart (`exponent_world.py`) makes multiplication local and leaves
addition non-local; `adaptive_valuation_addition.py` (codex-ananta) shows that
for a generic sum the least residue chart that determines `v_p(a+b)` has depth
`v_p(a+b)+1`, so the cost of an answer tracks the answer itself.

This module exhibits the exact family on which that coupling breaks.  For the
multiplicatively generated sums `a^n - 1` a *bounded* chart of the base alone
determines an *unbounded* family of valuations, with no further observation of
the summands.  The classical input is the lifting-the-exponent lemma; what is
formed here is the finite sensor, its minimal base-chart depth, and the
explicit witness that one digit less is not enough.

Run `python3 cyclotomic_sensor.py` for the encounter trace.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd

from arithmetic_life import ArithmeticLife


def valuation(n: int, prime: int) -> int:
    """Exact p-adic valuation of a nonzero integer."""
    if n == 0:
        raise ValueError("zero has no finite valuation; see ADAPTIVE_VALUATION_ADDITION")
    count = 0
    while n % prime == 0:
        n //= prime
        count += 1
    return count


def multiplicative_order(base: int, prime: int) -> int:
    """Least d>0 with base^d = 1 mod prime, by descent through divisors of p-1."""
    if base % prime == 0:
        raise ValueError("order is defined only for a base coprime to the prime")
    order = prime - 1
    for factor, _ in _factor_small(prime - 1):
        while order % factor == 0 and pow(base, order // factor, prime) == 1:
            order //= factor
    return order


def _factor_small(n: int) -> tuple[tuple[int, int], ...]:
    """Exhaustive trial-division factorization; exact, used only on p-1."""
    factors: list[tuple[int, int]] = []
    candidate = 2
    while candidate * candidate <= n:
        if n % candidate == 0:
            power = 0
            while n % candidate == 0:
                n //= candidate
                power += 1
            factors.append((candidate, power))
        candidate += 1
    if n > 1:
        factors.append((n, 1))
    return tuple(factors)


@dataclass(frozen=True)
class CyclotomicSensor:
    """Finite state answering `v_p(a^n - 1)` for all n>=1.

    Odd `prime`:  `order` = ord_p(a), `depth` = v_p(a^order - 1), `plus_depth` unused.
    `prime == 2`: `order` = 1, `depth` = v_2(a-1), `plus_depth` = v_2(a+1).
    """

    prime: int
    base: int
    order: int
    depth: int
    plus_depth: int | None
    base_chart_depth: int

    def valuation(self, exponent: int) -> int:
        if exponent < 1:
            raise ValueError("the cyclotomic family is indexed by exponents n>=1")
        if self.prime == 2:
            if exponent % 2:
                return self.depth
            assert self.plus_depth is not None
            return self.depth + self.plus_depth + valuation(exponent, 2) - 1
        if exponent % self.order:
            return 0
        return self.depth + valuation(exponent, self.prime)

    def divides(self, power: int, exponent: int) -> bool:
        """Does p^power divide a^exponent - 1?  No large integer is formed."""
        return self.valuation(exponent) >= power

    def least_exponent_reaching(self, power: int) -> int:
        """Least n with p^power | a^n - 1.  Inverts the sensor exactly."""
        if power <= 0:
            return 1
        if self.prime == 2:
            if power <= self.depth:
                return 1
            assert self.plus_depth is not None
            deficit = power - self.depth - self.plus_depth + 1
            return 2 ** max(deficit, 1)
        deficit = max(power - self.depth, 0)
        return self.order * self.prime ** deficit


class CyclotomicOrgan:
    """Forms cyclotomic sensors on demand and reuses them without recomputation."""

    def __init__(self, life: ArithmeticLife | None = None) -> None:
        self.life = life or ArithmeticLife()
        self.sensors: dict[tuple[int, int], CyclotomicSensor] = {}
        self.formations = 0
        self.reuses = 0

    def form(self, prime: int, base: int) -> CyclotomicSensor:
        """Install the sensor for (prime, base), gated on an earned residue sense."""
        if prime not in self.life.moduli:
            raise ValueError("the cyclotomic sensor needs an earned mod-p residue sense")
        if gcd(base, prime) != 1:
            raise ValueError("a^n - 1 is a unit at primes dividing a; no sensor is formed")
        key = (prime, base)
        if key in self.sensors:
            self.reuses += 1
            return self.sensors[key]
        if prime == 2:
            minus, plus = valuation(base - 1, 2), valuation(base + 1, 2)
            sensor = CyclotomicSensor(
                prime=2, base=base, order=1, depth=minus, plus_depth=plus,
                base_chart_depth=minus + plus,
            )
            detail = (
                f"2-sensor for base {base}: v2(a-1)={minus}, v2(a+1)={plus}; "
                f"one of them is 1, base chart depth {minus + plus}"
            )
        else:
            order = multiplicative_order(base, prime)
            depth = valuation(pow(base, order) - 1, prime)
            sensor = CyclotomicSensor(
                prime=prime, base=base, order=order, depth=depth, plus_depth=None,
                base_chart_depth=depth + 1,
            )
            detail = (
                f"{prime}-sensor for base {base}: ord={order}, "
                f"v{prime}(a^ord-1)={depth}; base chart depth {depth + 1}"
            )
        self.sensors[key] = sensor
        self.formations += 1
        self.life._record("form-sensor", (prime, base, sensor.depth), detail)
        return sensor

    def valuation(self, prime: int, base: int, exponent: int) -> int:
        return self.form(prime, base).valuation(exponent)


def _divisors(n: int) -> tuple[int, ...]:
    return tuple(d for d in range(1, n + 1) if n % d == 0)


def _mobius(n: int) -> int:
    sign, remaining, candidate = 1, n, 2
    while candidate * candidate <= remaining:
        if remaining % candidate == 0:
            remaining //= candidate
            if remaining % candidate == 0:
                return 0
            sign = -sign
        candidate += 1
    return -sign if remaining > 1 else sign


def cyclotomic_value(index: int, base: int) -> int:
    """Exact integer Phi_index(base) by the Mobius product over divisors."""
    numerator, denominator = 1, 1
    for divisor in _divisors(index):
        sign = _mobius(index // divisor)
        if sign == 1:
            numerator *= base ** divisor - 1
        elif sign == -1:
            denominator *= base ** divisor - 1
    if numerator % denominator:
        raise AssertionError("the cyclotomic Mobius product failed to be integral")
    return numerator // denominator


def chain_head(sensor: CyclotomicSensor) -> tuple[int, ...]:
    """The finite nonconstant prefix of the valuation along the p-chain.

    Length 1 at odd primes, length 2 at p=2.  Every later chain entry is 1.
    """
    if sensor.prime == 2:
        assert sensor.plus_depth is not None
        return (sensor.depth, sensor.plus_depth)
    return (sensor.depth,)


def cyclotomic_valuation(sensor: CyclotomicSensor, index: int) -> int:
    """v_p(Phi_index(a)) read off the chain, with no polynomial evaluated.

    The p-valuation is supported on the single chain d, dp, dp^2, ... where
    d = ord_p(a) (and d = 1 at p = 2).  Along that chain it is the head
    vector followed by the constant 1; everywhere else it is zero.
    """
    if index < 1:
        raise ValueError("cyclotomic index must be positive")
    chain_base = 1 if sensor.prime == 2 else sensor.order
    if index % chain_base:
        return 0
    quotient, steps = index // chain_base, 0
    while quotient % sensor.prime == 0:
        quotient //= sensor.prime
        steps += 1
    if quotient != 1:
        return 0
    head = chain_head(sensor)
    return head[steps] if steps < len(head) else 1


def minimality_witness(sensor: CyclotomicSensor) -> tuple[int, int, int]:
    """A base sharing every digit below the sensor's chart depth, but not the sensor.

    Returns `(other_base, exponent, other_valuation)` where `other_base` agrees
    with `sensor.base` modulo `p^(base_chart_depth - 1)` yet gives a different
    valuation at `exponent`.  This certifies that no coarser chart of the base
    determines the family.
    """
    p, a, k = sensor.prime, sensor.base, sensor.base_chart_depth
    coarse = p ** (k - 1)
    if p == 2:
        assert sensor.plus_depth is not None
        exponent = 2
        for step in range(1, 2 * p + 2):
            other = a + step * coarse
            if other % 2 == 0:
                continue
            other_valuation = (
                valuation(other - 1, 2) + valuation(other + 1, 2)
                + valuation(exponent, 2) - 1
            )
            if other_valuation != sensor.valuation(exponent):
                return other, exponent, other_valuation
        raise AssertionError("no 2-adic minimality witness found")
    exponent = sensor.order
    for step in range(1, p + 1):
        other = a + step * coarse
        if other % p == 0:
            continue
        if multiplicative_order(other, p) != sensor.order:
            continue
        other_valuation = valuation(pow(other, exponent) - 1, p)
        if other_valuation != sensor.valuation(exponent):
            return other, exponent, other_valuation
    raise AssertionError("no minimality witness found")


def main() -> None:
    life = ArithmeticLife()
    organ = CyclotomicOrgan(life)

    print("encounter 1: what is the largest power of 11 dividing 2^110 - 1?")
    life.install_residue_sensor(11, (110,))
    sensor = organ.form(11, 2)
    print(f"  formed once: ord_11(2)={sensor.order}, "
          f"v_11(2^{sensor.order}-1)={sensor.depth} "
          f"(2^10-1 = 1023 = 3*11*31)")
    print(f"  answer: v_11(2^110 - 1) = {sensor.valuation(110)}")

    print("\nencounter 2: the same question at exponent 1210 (a 365-digit integer)")
    print(f"  answer without forming the integer: {organ.valuation(11, 2, 1210)}")
    print(f"  formations so far: {organ.formations}, reuses: {organ.reuses}")

    print("\nencounter 3: the exceptional prime.  v_2(3^2026 - 1)?")
    life.install_residue_sensor(2, (2026,))
    two = organ.form(2, 3)
    print(f"  v2(3-1)={two.depth}, v2(3+1)={two.plus_depth}")
    print(f"  answer: {two.valuation(2026)}")

    print("\nthe sensor inverts: least n with 11^4 | 2^n - 1 is "
          f"{sensor.least_exponent_reaching(4)}")

    other, exponent, other_valuation = minimality_witness(sensor)
    print(f"\nminimality: base {other} agrees with 2 modulo "
          f"11^{sensor.base_chart_depth - 1}, yet v_11({other}^{exponent}-1) = "
          f"{other_valuation} != {sensor.valuation(exponent)}")

    print("\nthe chart behind the law: v_p on the cyclotomic factors")
    for label, formed in (("11, base 2", sensor), ("2, base 3", two)):
        chain = 1 if formed.prime == 2 else formed.order
        entries = [
            f"Phi_{chain * formed.prime ** s}:{cyclotomic_valuation(formed, chain * formed.prime ** s)}"
            for s in range(4)
        ]
        print(f"  p={label}: head {chain_head(formed)}, chain "
              + "  ".join(entries) + "  ...")
    print("  everything off the chain is zero; v_p(n) counts the chain steps")


if __name__ == "__main__":
    main()

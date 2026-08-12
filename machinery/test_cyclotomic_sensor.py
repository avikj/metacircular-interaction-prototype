#!/usr/bin/env python3
"""Exact tests for the cyclotomic sensor organ.

The sweep in `test_agrees_with_direct_valuation` is a falsifier, not a
measurement: it can only refute the theorem in `notes/CYCLOTOMIC_SENSOR.md`.
Every other test checks an exact structural claim.
"""

from __future__ import annotations

import unittest
from math import gcd

from arithmetic_life import ArithmeticLife
from cyclotomic_sensor import (
    CyclotomicOrgan,
    _factor_small,
    minimality_witness,
    multiplicative_order,
    valuation,
)


def organ_with(primes) -> CyclotomicOrgan:
    life = ArithmeticLife()
    for prime in primes:
        life.install_residue_sensor(prime, (0,))
    return CyclotomicOrgan(life)


class TestCyclotomicSensor(unittest.TestCase):
    def test_agrees_with_direct_valuation(self) -> None:
        """Falsifier sweep: sensor answer versus the formed integer."""
        organ = organ_with([2, 3, 5, 7, 11, 13, 17, 19, 23])
        checked = 0
        for prime in (2, 3, 5, 7, 11, 13, 17, 19, 23):
            for base in range(2, 30):
                if gcd(base, prime) != 1:
                    continue
                sensor = organ.form(prime, base)
                for exponent in range(1, 61):
                    self.assertEqual(
                        sensor.valuation(exponent),
                        valuation(base ** exponent - 1, prime),
                        f"p={prime} a={base} n={exponent}",
                    )
                    checked += 1
        self.assertGreater(checked, 10000)

    def test_one_encounter_answers_an_unformed_integer(self) -> None:
        """The sensor formed at n=10 answers n=1210 with no new observation."""
        organ = organ_with([11])
        sensor = organ.form(11, 2)
        self.assertEqual((sensor.order, sensor.depth), (10, 1))
        formations = organ.formations
        self.assertEqual(organ.valuation(11, 2, 1210), 3)
        self.assertEqual(organ.formations, formations)
        self.assertEqual(organ.reuses, 1)

    def test_bounded_chart_unbounded_valuation(self) -> None:
        """Chart depth is fixed at 2 while the answered valuation is unbounded."""
        organ = organ_with([11])
        sensor = organ.form(11, 2)
        self.assertEqual(sensor.base_chart_depth, 2)
        for power in range(1, 40):
            exponent = sensor.least_exponent_reaching(power)
            self.assertGreaterEqual(sensor.valuation(exponent), power)
            # The solution set is closed under multiples, so the least element
            # divides every element.  Minimality therefore follows from the
            # maximal proper divisors alone.
            for factor, _ in _factor_small(exponent):
                self.assertLess(sensor.valuation(exponent // factor), power)

    def test_minimality_witness_defeats_the_coarser_chart(self) -> None:
        """One digit less of the base does not determine the family."""
        organ = organ_with([2, 3, 5, 7, 11, 13])
        for prime, base in ((11, 2), (5, 2), (7, 3), (13, 4), (3, 2),
                            (2, 3), (2, 5), (2, 7), (2, 17)):
            sensor = organ.form(prime, base)
            other, exponent, other_valuation = minimality_witness(sensor)
            coarse = prime ** (sensor.base_chart_depth - 1)
            self.assertEqual(other % coarse, base % coarse)
            self.assertNotEqual(other_valuation, sensor.valuation(exponent))
            self.assertEqual(other_valuation, valuation(other ** exponent - 1, prime))

    def test_base_chart_depth_suffices(self) -> None:
        """Two bases agreeing at the chart depth induce the same whole family."""
        organ = organ_with([11, 7, 5])
        for prime, base in ((11, 2), (7, 3), (5, 7)):
            sensor = organ.form(prime, base)
            step = prime ** sensor.base_chart_depth
            for shift in (1, 2, 5):
                other = base + shift * step
                twin = organ.form(prime, other)
                self.assertEqual((twin.order, twin.depth), (sensor.order, sensor.depth))
                for exponent in range(1, 25):
                    self.assertEqual(sensor.valuation(exponent),
                                     twin.valuation(exponent))

    def test_two_is_exceptional(self) -> None:
        """The odd-prime law fails at 2 and the two-depth sensor repairs it."""
        organ = organ_with([2])
        sensor = organ.form(2, 3)
        self.assertEqual((sensor.depth, sensor.plus_depth), (1, 2))
        self.assertEqual(sensor.valuation(2), 3)
        self.assertNotEqual(sensor.valuation(2), sensor.depth + valuation(2, 2))
        self.assertEqual(sensor.valuation(2026), 3)
        self.assertEqual(min(sensor.depth, sensor.plus_depth), 1)

    def test_wieferich_deep_sensor(self) -> None:
        """A deep sensor is still one encounter: 1093 is a Wieferich prime."""
        organ = organ_with([1093])
        sensor = organ.form(1093, 2)
        self.assertEqual(sensor.order, 364)
        self.assertEqual(sensor.depth, 2)
        self.assertEqual(sensor.base_chart_depth, 3)
        self.assertEqual(sensor.valuation(364 * 1093), 3)
        self.assertEqual(sensor.valuation(363), 0)

    def test_causal_gate_and_unit_refusal(self) -> None:
        organ = CyclotomicOrgan(ArithmeticLife())
        with self.assertRaises(ValueError):
            organ.form(11, 2)
        gated = organ_with([3])
        with self.assertRaises(ValueError):
            gated.form(3, 6)
        with self.assertRaises(ValueError):
            gated.form(3, 2).valuation(0)

    def test_order_is_exact(self) -> None:
        for prime in (2, 3, 5, 7, 11, 13, 101, 1093):
            for base in range(2, 15):
                if base % prime == 0:
                    continue
                order = multiplicative_order(base, prime)
                self.assertEqual(pow(base, order, prime), 1)
                self.assertTrue(all(pow(base, k, prime) != 1 for k in range(1, order)))


if __name__ == "__main__":
    unittest.main(verbosity=2)

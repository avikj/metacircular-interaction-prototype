#!/usr/bin/env python3

import unittest
from math import gcd

from certificate_anatomy import (
    carmichael_numbers,
    fermat_degenerates,
    fermat_refutes,
    freedom_at,
    is_carmichael,
    is_prime,
    least_strong_pseudoprime,
    strong_refutes,
)


class KorseltTests(unittest.TestCase):
    def test_the_known_small_carmichael_numbers(self):
        self.assertEqual(carmichael_numbers(10_000),
                         [561, 1105, 1729, 2465, 2821, 6601, 8911])

    def test_korselt_agrees_with_the_defining_property(self):
        """n is Carmichael iff composite and a^(n-1)=1 for every unit a."""
        for number in range(3, 3000, 2):
            if is_prime(number):
                continue
            defining = all(pow(a, number - 1, number) == 1
                           for a in range(2, number) if gcd(a, number) == 1)
            self.assertEqual(is_carmichael(number), defining, f"n={number}")


class TheoremFTests(unittest.TestCase):
    """On a Carmichael number the Fermat scheme collapses onto divisibility."""

    def test_refuters_are_exactly_the_non_units(self):
        for number in carmichael_numbers(10_000):
            self.assertTrue(fermat_degenerates(number), f"n={number}")

    def test_every_unit_is_inert(self):
        for number in carmichael_numbers(3000):
            for base in range(2, number):
                if gcd(base, number) == 1:
                    self.assertFalse(fermat_refutes(base, number))

    def test_the_minimal_refuters_are_the_prime_divisors(self):
        """So soundness on this family forces T5's divisibility anatomy back."""
        for number in carmichael_numbers(10_000):
            minimal = min(a for a in range(2, number) if fermat_refutes(a, number))
            self.assertTrue(is_prime(minimal))
            self.assertEqual(number % minimal, 0)

    def test_theorem_F_is_stated_only_for_carmichael_numbers(self):
        with self.assertRaises(ValueError):
            fermat_degenerates(561 * 2)
        with self.assertRaises(ValueError):
            fermat_degenerates(341)          # a base-2 pseudoprime, not Carmichael


class StrongSchemeTests(unittest.TestCase):
    """Genuine choice at each n, but no fixed anatomy survives."""

    def test_no_carmichael_analogue_for_the_strong_test(self):
        for number in carmichael_numbers(3000):
            self.assertGreater(freedom_at(number, "strong"),
                               freedom_at(number, "fermat"))

    def test_rabin_quarter_bound_is_not_violated(self):
        """Rabin (1980): at least 3/4 of bases witness. A falsifier, not a proof."""
        for number in range(9, 2000, 2):
            if is_prime(number):
                continue
            witnesses = sum(strong_refutes(a, number) for a in range(2, number - 1))
            self.assertGreaterEqual(witnesses, 0.75 * (number - 3), f"n={number}")

    def test_least_strong_pseudoprimes_by_exhaustive_scan(self):
        self.assertEqual(least_strong_pseudoprime((2,), 3000), 2047)
        self.assertEqual(least_strong_pseudoprime((2, 3), 1_373_655), 1_373_653)

    def test_a_fixed_anatomy_certifies_a_composite_as_prime(self):
        for bases, failure in (((2,), 2047), ((2, 3), 1_373_653)):
            self.assertFalse(is_prime(failure))
            for base in bases:
                self.assertFalse(strong_refutes(base, failure))

    def test_enlarging_a_fixed_anatomy_only_moves_the_failure(self):
        """{2} fails at 2047; {2,3} passes 2047 but fails later."""
        self.assertTrue(strong_refutes(3, 2047))
        self.assertFalse(any(strong_refutes(b, 1_373_653) for b in (2, 3)))


if __name__ == "__main__":
    unittest.main()

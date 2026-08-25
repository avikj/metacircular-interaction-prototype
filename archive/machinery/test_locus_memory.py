#!/usr/bin/env python3
"""Exact tests for locus memory against interval memory.

Run: python3 -m unittest test_locus_memory -v   (from machinery/)
"""

import math
import unittest

from locus_memory import (
    BABYLONIAN_GENERATORS,
    BABYLONIAN_TABLE_CEILING,
    SEXAGESIMAL_BASE,
    LocusVerdict,
    babylonian_table,
    compare_with_interval,
    digit_coverage,
    locus,
    required_reach,
    sparsity_bound,
    sum_representation_bound,
    terms_needed,
)
from memory_step_tradeoff import positional_base, worst_case_steps


class LocusMemoryTests(unittest.TestCase):
    def test_locus_is_correct_and_closed(self):
        for primes in ((2,), (2, 3), (2, 3, 5)):
            for ceiling in (50, 1000, 10**5):
                held = locus(primes, ceiling)
                self.assertEqual(held[0], 1)
                self.assertLessEqual(held[-1], ceiling)
                for x in held:
                    y = x
                    for p in primes:
                        while y % p == 0:
                            y //= p
                    self.assertEqual(y, 1)      # every element is p-smooth
                # closure: any product still under the ceiling is present
                for x in held:
                    for p in primes:
                        if x * p <= ceiling:
                            self.assertIn(x * p, held)

    def test_sparsity_bound_holds(self):
        """Theorem R: |F| <= prod (1 + log X / log p)."""
        for primes in ((2, 3), (2, 3, 5), (2, 3, 5, 7)):
            for ceiling in (10**3, 10**6, 10**9):
                self.assertLessEqual(len(locus(primes, ceiling)),
                                     sparsity_bound(primes, ceiling))

    def test_a_locus_reaches_exponentially_further_than_an_interval(self):
        """f held elements force reach exp(Omega(f^(1/k)))."""
        for primes in ((2, 3), (2, 3, 5)):
            for ceiling in (10**4, 10**8, 10**12):
                v = compare_with_interval(primes, ceiling, 60)
                self.assertEqual(v.interval_of_same_size_reaches, v.size - 1)
                self.assertGreater(v.locus_reaches,
                                   v.interval_of_same_size_reaches)
                # the sparsity bound's inverse is a genuine lower bound on reach
                self.assertGreaterEqual(math.log(ceiling) + 1e-9,
                                        required_reach(v.size, len(primes)))

    def test_digit_famine(self):
        """Theorem S: the locus supplies a vanishing fraction of the digits."""
        for primes in ((2, 3), (2, 3, 5)):
            previous_ratio = 1.0
            for base in (16, 60, 256, 1024, 4096):
                supplied, needed = digit_coverage(primes, base)
                self.assertEqual(needed, base)
                self.assertLess(supplied, needed)
                ratio = supplied / needed
                self.assertLess(ratio, previous_ratio)   # strictly thinning
                previous_ratio = ratio
            self.assertLess(supplied / needed, 0.05)     # and it is small

    def test_the_babylonian_table_cannot_be_a_digit_alphabet(self):
        """The standard OB reciprocal table, exactly."""
        table = babylonian_table()
        self.assertEqual(len(table), 31)
        self.assertEqual(table[0], 1)
        self.assertEqual(table[-1], BABYLONIAN_TABLE_CEILING)
        self.assertIn(60, table)
        self.assertNotIn(7, table)          # 7 is not regular: "it does not divide"
        self.assertNotIn(11, table)
        below = [x for x in table if x < SEXAGESIMAL_BASE]
        self.assertEqual(len(below), 25)
        self.assertLess(len(below), SEXAGESIMAL_BASE)
        supplied, needed = digit_coverage(BABYLONIAN_GENERATORS, SEXAGESIMAL_BASE)
        self.assertEqual((supplied, needed), (25, 60))

    def test_sum_representation_bound(self):
        """Theorem T: bounded sums of a small locus miss almost every class."""
        for held, terms in ((10, 3), (100, 5), (1000, 4)):
            self.assertEqual(sum_representation_bound(held, terms),
                             math.comb(held + terms, terms))
        for modulus, held in ((3**160, 100), (3**640, 100), (3**640, 10**4)):
            t = terms_needed(modulus, held)
            self.assertGreaterEqual(sum_representation_bound(held, t), modulus)
            self.assertLess(sum_representation_bound(held, t - 1), modulus)
        # a polylogarithmic locus needs enormously many terms
        self.assertGreater(terms_needed(3**640, 100), 1000)

    def test_the_interval_construction_still_works_for_intervals(self):
        """Control: Theorem P is unharmed; only the locus analogue fails."""
        for modulus, digits in ((6561, 3), (2**20, 4)):
            base = positional_base(modulus, digits)
            self.assertEqual(worst_case_steps(modulus, digits), 2 * digits - 2)
            # but the locus supplies only a fraction of that base's digits
            supplied, needed = digit_coverage((2, 3, 5), base)
            self.assertLess(supplied, needed)

    def test_known_false_control_same_size_means_same_memory(self):
        """'a held set of size f is a held set of size f' must fire as false."""
        v = compare_with_interval((2, 3, 5), 10**12, 1024)
        interval_top = v.size - 1
        self.assertGreater(v.locus_reaches, interval_top * 10**6)
        # and the reverse deficiency: the interval supplies every digit
        self.assertLess(v.digits_supplied, v.digits_needed // 10)

    def test_shape_and_rejections(self):
        v = compare_with_interval((2, 3), 1000, 60)
        self.assertIsInstance(v, LocusVerdict)
        with self.assertRaises(Exception):
            v.size = 0
        with self.assertRaises(ValueError):
            locus((1, 3), 100)
        with self.assertRaises(ValueError):
            locus((2, 3), 0)
        with self.assertRaises(ValueError):
            digit_coverage((2, 3), 1)
        with self.assertRaises(ValueError):
            required_reach(0, 2)
        with self.assertRaises(ValueError):
            sum_representation_bound(0, 3)


if __name__ == "__main__":
    unittest.main()

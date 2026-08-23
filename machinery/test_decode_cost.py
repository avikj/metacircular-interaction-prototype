#!/usr/bin/env python3
"""Exact tests for the (name, decode) cost pair.

Run: python3 -m unittest test_decode_cost -v   (from machinery/)
"""

import math
import unittest

from decode_cost import (
    CostPair,
    digit_count,
    egyptian_product,
    egyptian_selection,
    egyptian_table,
    horner_decode_cost,
    positional_pair,
    power_decode_cost,
    structured_pair,
)


class DecodeCostTests(unittest.TestCase):
    def test_canonical_decode_is_bounded_below_by_output_size(self):
        """Theorem AA: you cannot have the digits for less than their count."""
        for digits in (10, 24, 100, 1000):
            pair = positional_pair(digits)
            self.assertEqual(pair.canonical_decode, digits)
            self.assertGreaterEqual(pair.total_canonical, digits)
        for p, k in ((3, 6), (3, 16), (2, 20)):
            pair = structured_pair(p, k)
            self.assertGreaterEqual(pair.canonical_decode,
                                    int(pair.log10_value))
            self.assertGreaterEqual(pair.total_canonical, pair.canonical_decode)

    def test_the_naming_saving_is_repaid_exactly(self):
        """A short name buys nothing once the digits must be produced."""
        for p, k in ((3, 6), (3, 16), (5, 12)):
            structured = structured_pair(p, k)
            equivalent = positional_pair(int(structured.log10_value) + 1)
            # the structured name is far shorter
            self.assertLess(structured.name_length, equivalent.name_length)
            # but the canonical totals are within a factor of two
            self.assertLessEqual(structured.total_canonical,
                                 2 * equivalent.total_canonical)
            self.assertGreaterEqual(structured.total_canonical,
                                    equivalent.total_canonical // 2)

    def test_value_decoding_shows_no_trade(self):
        """Theorem BB: structured numbers are cheap in BOTH coordinates."""
        for p, k in ((3, 6), (3, 16), (3, 64)):
            structured = structured_pair(p, k)
            self.assertEqual(structured.value_decode, k)      # k squarings
            self.assertLess(structured.name_length, 10)
            # a generic number of the same magnitude is dear in both
            generic = positional_pair(max(1, int(structured.log10_value)))
            self.assertGreater(generic.name_length, structured.name_length)
            self.assertGreater(generic.value_decode, structured.value_decode)

    def test_power_and_horner_costs(self):
        self.assertEqual(power_decode_cost(2**6), 6)
        self.assertEqual(power_decode_cost(2**16), 16)
        self.assertEqual(power_decode_cost(1), 0)
        self.assertEqual(power_decode_cost(3), 2)       # 1 square + 1 multiply
        self.assertEqual(horner_decode_cost(1), 0)
        self.assertEqual(horner_decode_cost(3), 4)

    def test_digit_count_is_exact(self):
        for value, expected in ((0, 1), (9, 1), (10, 2), (999, 3), (1000, 4)):
            self.assertEqual(digit_count(value), expected)
        self.assertEqual(digit_count(255, 2), 8)

    def test_the_rhind_worked_example(self):
        """13 x 23 = 299, exactly as the doubling method gives it."""
        self.assertEqual(egyptian_table(23, 13),
                         [(1, 23), (2, 46), (4, 92), (8, 184)])
        self.assertEqual(egyptian_selection(13), [1, 4, 8])
        product, rows, adds = egyptian_product(23, 13)
        self.assertEqual(product, 299)
        self.assertEqual(rows, 4)
        self.assertEqual(adds, 2)

    def test_egyptian_method_is_correct_and_logarithmic_in_both(self):
        """Table rows and additions are both Theta(log multiplier)."""
        for multiplicand in (7, 23, 100):
            for multiplier in range(1, 200):
                product, rows, adds = egyptian_product(multiplicand, multiplier)
                self.assertEqual(product, multiplicand * multiplier)
                self.assertEqual(rows, multiplier.bit_length())
                self.assertEqual(adds, bin(multiplier).count("1") - 1)
                # both coordinates logarithmic, neither dominating
                self.assertLessEqual(adds, rows)
                self.assertLessEqual(rows, math.log2(multiplier) + 1)

    def test_known_false_control_the_thread_collapses_to_one_quantity(self):
        """'name + decode is conserved' must fail under value decoding."""
        structured = structured_pair(3, 64)
        generic = positional_pair(30)
        structured_total = structured.name_length + structured.value_decode
        generic_total = generic.name_length + generic.value_decode
        # the structured number is astronomically larger yet cheaper in total
        self.assertGreater(structured.log10_value, generic.log10_value)
        self.assertLess(structured_total, generic_total)

    def test_shape_and_rejections(self):
        pair = positional_pair(10)
        self.assertIsInstance(pair, CostPair)
        with self.assertRaises(Exception):
            pair.name_length = 0
        with self.assertRaises(ValueError):
            positional_pair(0)
        with self.assertRaises(ValueError):
            structured_pair(1, 3)
        with self.assertRaises(ValueError):
            power_decode_cost(0)
        with self.assertRaises(ValueError):
            egyptian_table(0, 5)
        with self.assertRaises(ValueError):
            digit_count(-1)


if __name__ == "__main__":
    unittest.main()

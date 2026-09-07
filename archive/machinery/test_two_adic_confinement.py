#!/usr/bin/env python3
"""Exact tests for 2-adic confinement, and the arc closure.

Run: python3 -m unittest test_two_adic_confinement -v   (from machinery/)
"""

import unittest

from formed_locus_depth import formed_chart_depth, unit_level
from two_adic_confinement import (
    TwoAdicConfinement,
    closure_mod_two_power,
    confinement,
    meets_three_mod_four,
    predicted_index,
    unreachable_fraction,
)

GENERATOR_SETS = ((3,), (5,), (7,), (9,), (17,), (15,), (31,), (3, 5), (3, 7),
                  (5, 9), (7, 17))


class TwoAdicConfinementTests(unittest.TestCase):
    def test_closure_is_a_subgroup_of_two_power_order(self):
        for gens in GENERATOR_SETS:
            for k in (4, 6, 8):
                subgroup = closure_mod_two_power(gens, k)
                self.assertIn(1, subgroup)
                for x in subgroup:
                    for y in subgroup:
                        self.assertIn(x * y % 2**k, subgroup)
                self.assertEqual(2 ** (k - 1) % len(subgroup), 0)
                # every element is odd and the order is a power of two
                self.assertTrue(all(x % 2 == 1 for x in subgroup))
                self.assertEqual(len(subgroup) & (len(subgroup) - 1), 0)

    def test_filtration_signature_predicts_the_index_exactly(self):
        """Theorem II uses level plus the mod-4 sign bit."""
        checked = 0
        for gens in GENERATOR_SETS:
            for k in (4, 6, 8, 10):
                record = confinement(gens, k)
                self.assertEqual(record.index, record.predicted,
                                 f"gens={gens} k={k}")
                checked += 1
        self.assertGreater(checked, 40)

    def test_the_two_branches_of_the_formula(self):
        """2^(l-2) when the subgroup meets 3 mod 4, else 2^(l-1)."""
        for gens in GENERATOR_SETS:
            record = confinement(gens, 8)
            subgroup = closure_mod_two_power(gens, 8)
            self.assertEqual(record.meets_three_mod_four,
                             meets_three_mod_four(subgroup))
            if record.meets_three_mod_four:
                self.assertEqual(record.index, 2 ** (record.level - 2))
            else:
                self.assertEqual(record.index, 2 ** (record.level - 1))

    def test_level_alone_is_known_false(self):
        """Equal levels can have indices differing by the missing sign bit."""
        left = confinement((5,), 8)
        right = confinement((3, 5), 8)
        self.assertEqual(left.level, right.level)
        self.assertNotEqual(left.index, right.index)

    def test_index_is_independent_of_precision(self):
        """The level and index do not move with k, once k exceeds the level."""
        for gens in GENERATOR_SETS:
            indices = {confinement(gens, k).index for k in (8, 10, 12)}
            levels = {confinement(gens, k).level for k in (8, 10, 12)}
            self.assertEqual(len(indices), 1, f"gens={gens}")
            self.assertEqual(len(levels), 1, f"gens={gens}")

    def test_filtration_signature_joins_the_two_notes(self):
        """Level and mod-4 image jointly control chart depth and index."""
        # FORMED_UNIT_FILTRATION_DEPTH: <3> has level 3, <3,5> has level 2
        self.assertEqual(unit_level(2, 8, [3]), 3)
        self.assertEqual(unit_level(2, 8, [3, 5]), 2)
        self.assertEqual(confinement((3,), 8).index, 2)
        self.assertEqual(confinement((3, 5), 8).index, 1)
        # and the same level still drives the chart-depth result it was born for
        before = formed_chart_depth(2, [3], 1, 3)
        after = formed_chart_depth(2, [3, 5], 1, 3)
        self.assertEqual(before.depth, 2)
        self.assertEqual(after.depth, after.ambient_depth)
        # level 2 means unconfined AND ambient chart depth; level 3 means both
        self.assertLess(confinement((3, 5), 8).index,
                        confinement((3,), 8).index)

    def test_thin_generators_are_severely_confined(self):
        """<31> reaches 1 class in 16; <15> one in 8."""
        for gens, expected in (((31,), 16), ((15,), 8), ((17,), 8), ((7,), 4)):
            record = confinement(gens, 10)
            self.assertEqual(record.index, expected)
            self.assertGreater(unreachable_fraction(record), 0.7)
        # while two well-chosen generators reach everything
        for gens in ((3, 5), (3, 7)):
            self.assertEqual(confinement(gens, 10).index, 1)
            self.assertEqual(unreachable_fraction(confinement(gens, 10)), 0.0)

    def test_known_false_control_gauss_index_applies_at_two(self):
        """'(Z/2^k)^* is cyclic, so art. 57 applies' must fire as false."""
        # a cyclic group of order 2^(k-1) would have a generator of that order;
        # every element of (Z/2^k)^* has order at most 2^(k-2) for k >= 3
        k = 8
        orders = set()
        for x in range(1, 2**k, 2):
            order, y = 1, x
            while y != 1:
                y = y * x % 2**k
                order += 1
            orders.add(order)
        self.assertLessEqual(max(orders), 2 ** (k - 2))
        self.assertLess(max(orders), 2 ** (k - 1))      # no primitive root

    def test_shape_and_rejections(self):
        record = confinement((3,), 8)
        self.assertIsInstance(record, TwoAdicConfinement)
        with self.assertRaises(Exception):
            record.index = 0
        with self.assertRaises(ValueError):
            closure_mod_two_power((3,), 2)      # k must be at least 3
        with self.assertRaises(ValueError):
            closure_mod_two_power((6,), 8)      # not a unit
        with self.assertRaises(ValueError):
            predicted_index(1, True)


if __name__ == "__main__":
    unittest.main()

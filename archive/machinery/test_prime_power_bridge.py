#!/usr/bin/env python3

import unittest

from prime_power_bridge import (
    reconstruct_residue, residue_coordinates, truncated_valuation,
)


class PrimePowerBridgeTests(unittest.TestCase):
    def test_residue_exactly_splits_into_depth_and_unit(self):
        for n in range(-20, 40):
            coordinates = residue_coordinates(n, 3, 4)
            self.assertEqual(reconstruct_residue(*coordinates, 3, 4), n % 81)

    def test_multiplication_is_saturated_depth_addition(self):
        for a, b in ((6, 18), (9, 27), (10, 14), (0, 7)):
            left = truncated_valuation(a * b, 3, 4)
            right = min(truncated_valuation(a, 3, 4) +
                        truncated_valuation(b, 3, 4), 4)
            self.assertEqual(left, right)

    def test_addition_ultrametric_and_unequal_depth_equality(self):
        for a, b in ((3, 9), (6, 12), (1, 8), (9, 18)):
            va, vb = (truncated_valuation(x, 3, 4) for x in (a, b))
            total = truncated_valuation(a + b, 3, 4)
            self.assertGreaterEqual(total, min(va, vb))
            if va != vb:
                self.assertEqual(total, min(va, vb))

    def test_zero_residue_collapses_all_deeper_valuations(self):
        self.assertEqual(residue_coordinates(3 ** 4, 3, 4), (4, None))
        self.assertEqual(residue_coordinates(3 ** 9, 3, 4), (4, None))


if __name__ == "__main__":
    unittest.main()

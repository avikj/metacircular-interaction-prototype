#!/usr/bin/env python3

import itertools
import unittest
from fractions import Fraction

from weight_span_carrier import carrier, future_equivalent, quotient_fibers, row_basis


class WeightSpanCarrierTests(unittest.TestCase):
    def test_one_shot_weight_splits_total_fiber(self):
        left, right = (1, 0), (0, 1)
        self.assertTrue(future_equivalent(left, right, ((1, 1),)))
        self.assertFalse(future_equivalent(left, right, ((1, 1), (1, 0))))
        states = tuple(itertools.product((0, 1), repeat=2))
        self.assertEqual(len(quotient_fibers(states, ((1, 1),))), 3)
        self.assertEqual(len(quotient_fibers(states, ((1, 1), (1, 0)))), 4)

    def test_span_not_generating_list_determines_carrier(self):
        weights = ((1, 1, 0), (0, 1, 1))
        redundant = weights + ((2, 3, 1), (3, 4, 1))
        for state in itertools.product((0, 1), repeat=3):
            self.assertEqual(carrier(state, weights), carrier(state, redundant))

    def test_singleton_weights_force_full_verdict_vector(self):
        weights = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
        states = tuple(itertools.product((0, 1), repeat=3))
        fibers = quotient_fibers(states, weights)
        self.assertEqual(len(fibers), len(states))
        self.assertTrue(all(len(fiber) == 1 for fiber in fibers.values()))

    def test_exact_rational_elimination(self):
        basis = row_basis(((2, 4), (1, 2), (1, 0)))
        self.assertEqual(basis, ((Fraction(1), Fraction(0)),
                                 (Fraction(0), Fraction(1))))

    def test_every_original_weight_factors_through_carrier_on_finite_locus(self):
        weights = ((1, 1, 0), (0, 1, 1), (2, 2, 0))
        states = tuple(itertools.product((0, 1), repeat=3))
        fibers = quotient_fibers(states, weights)
        for fiber in fibers.values():
            for weight in weights:
                values = {sum(x * w for x, w in zip(state, weight)) for state in fiber}
                self.assertEqual(len(values), 1)

    def test_fail_closed(self):
        with self.assertRaises(ValueError):
            row_basis(((1, 2), (1,)))
        with self.assertRaises(ValueError):
            carrier((1, 0, 1), ((1, 1),))


if __name__ == "__main__":
    unittest.main()

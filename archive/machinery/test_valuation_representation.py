#!/usr/bin/env python3

import unittest

from valuation_representation import (
    exponent_vector, local_addition_counterexample, universal_evaluate,
)


class ValuationRepresentationTests(unittest.TestCase):
    def test_recursive_origins_form_exponent_coordinates(self):
        self.assertEqual(exponent_vector(360), ((2, 3), (3, 2), (5, 1)))

    def test_multiplication_becomes_coordinate_addition(self):
        self.assertEqual(exponent_vector(12 * 75), ((2, 2), (3, 2), (5, 2)))

    def test_arbitrary_multiplicative_observable_factors(self):
        # Free choice on primes extends uniquely; here the target monoid is
        # strings under sorted concatenation represented canonically as tuples.
        image = universal_evaluate(
            45, {3: ("a",), 5: ("b",)}, (),
            lambda left, right: tuple(sorted(left + right)),
        )
        self.assertEqual(image, ("a", "a", "b"))

    def test_no_prime_local_addition_law(self):
        for height in (1, 2, 5):
            a, b = local_addition_counterexample(3, height)
            va = dict(exponent_vector(a)).get(3, 0)
            vb = dict(exponent_vector(b)).get(3, 0)
            vsum = dict(exponent_vector(a + b)).get(3, 0)
            self.assertEqual((va, vb, vsum), (0, 0, height))


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3

import unittest
from fractions import Fraction
from math import gcd

from ray_count_invariant import (
    closed_form,
    invariant_holds,
    is_sylvester_shift,
    pairwise_coprime,
    partial_sum,
    ray_count,
    sylvester,
)


class TheirRecursionTests(unittest.TestCase):
    def test_the_quoted_values(self):
        self.assertEqual([ray_count(k) for k in range(1, 5)], [2, 6, 42, 1806])

    def test_the_recursion_itself(self):
        for depth in range(1, 8):
            self.assertEqual(ray_count(depth + 1),
                             ray_count(depth) + ray_count(depth) ** 2)

    def test_growth_leaves_enumeration_by_depth_six(self):
        self.assertEqual(ray_count(6), 10_650_056_950_806)
        self.assertGreater(ray_count(6), 10 ** 13)


class SylvesterTests(unittest.TestCase):
    def test_the_shift(self):
        for depth in range(1, 8):
            self.assertTrue(is_sylvester_shift(depth), f"k={depth}")

    def test_sylvester_recurrence(self):
        for index in range(1, 8):
            self.assertEqual(sylvester(index + 1),
                             sylvester(index) ** 2 - sylvester(index) + 1)

    def test_theorem_S1_pairwise_coprime(self):
        self.assertTrue(pairwise_coprime(range(1, 8)))
        for j in range(1, 7):
            for k in range(j + 1, 8):
                self.assertEqual(gcd(ray_count(j) + 1, ray_count(k) + 1), 1)


class TheoremS2Tests(unittest.TestCase):
    def test_exact_at_every_limit(self):
        for limit in range(1, 9):
            self.assertEqual(partial_sum(limit), closed_form(limit),
                             f"K={limit}")

    def test_the_named_early_values(self):
        self.assertEqual(partial_sum(1), Fraction(1, 3))
        self.assertEqual(partial_sum(2), Fraction(10, 21))
        self.assertEqual(partial_sum(3), Fraction(451, 903))

    def test_the_error_term_is_one_over_the_next_count(self):
        for limit in range(1, 7):
            self.assertEqual(Fraction(1, 2) - partial_sum(limit),
                             Fraction(1, ray_count(limit + 1)))

    def test_the_sum_converges_to_one_half_from_below(self):
        for limit in range(1, 7):
            self.assertLess(partial_sum(limit), Fraction(1, 2))
            self.assertLess(partial_sum(limit), partial_sum(limit + 1))


class InvariantIsATestTests(unittest.TestCase):
    """It must fail on corrupted recursions, or it is decoration."""

    def test_it_passes_on_the_true_recursion(self):
        for limit in range(1, 7):
            self.assertTrue(invariant_holds(limit))

    def test_it_catches_a_wrong_base_case(self):
        self.assertFalse(invariant_holds(4, base=3))

    def test_it_catches_a_wrong_coefficient(self):
        self.assertFalse(invariant_holds(4, step=lambda r: r + 2 * r * r))

    def test_it_catches_an_off_by_one_recursion(self):
        self.assertFalse(invariant_holds(4, step=lambda r: r * r))


if __name__ == "__main__":
    unittest.main()

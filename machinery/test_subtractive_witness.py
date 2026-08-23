#!/usr/bin/env python3
"""Exact tests for subtractive witness formation.

Run: python3 -m unittest test_subtractive_witness -v   (from machinery/)
"""

import unittest

from subtractive_witness import (
    SubtractiveWitness,
    classes_reached,
    counting_threshold,
    shortest_chain,
    subtractive_advantage,
    witness_by_difference,
)
from witness_chains import chain_count_bound, reachable_in_steps


class SubtractiveWitnessTests(unittest.TestCase):
    def test_class_minimum_obeys_the_counting_bound(self):
        """My own objection to WITNESS_CHAIN_COST §4 fails, exactly."""
        for steps in range(1, 7):
            cheap = reachable_in_steps(steps, 10**7)
            for modulus in (128, 243, 625):
                hit = classes_reached(steps, modulus)
                self.assertLessEqual(hit, len(cheap))
                self.assertLessEqual(hit, chain_count_bound(steps))
                self.assertLessEqual(hit, modulus)
        # and most classes really are missed at small step counts
        self.assertEqual(classes_reached(5, 625), 88)
        self.assertLess(classes_reached(5, 625), 625 // 2)

    def test_counting_threshold_is_the_least_n(self):
        for modulus in (10, 1000, 3**20, 3**40):
            n = counting_threshold(modulus)
            self.assertGreaterEqual(chain_count_bound(n), modulus)
            if n > 1:
                self.assertLess(chain_count_bound(n - 1), modulus)

    def test_witness_by_difference_is_in_the_class_and_positive(self):
        for p in (2, 3, 5, 7):
            for E in range(1, 9):
                for a in (1, 3, 7, 40, 1000, 10**6):
                    w = witness_by_difference(p, E, a)
                    self.assertGreater(w.witness, 0)
                    self.assertEqual(w.witness % p**E, (-a) % p**E)
                    self.assertEqual(w.witness, w.round_number - a)

    def test_restricted_subtraction_suffices_when_the_power_exceeds_a(self):
        """Euclid's larger-minus-smaller is enough; no negative is ever formed."""
        for p, E, a in ((3, 5, 7), (2, 10, 100), (5, 4, 600)):
            w = witness_by_difference(p, E, a)
            self.assertTrue(w.restricted)
            self.assertEqual(w.multiplier, 1)
            self.assertGreater(p**E, a)
        # and when a is larger, doublings clear it -- still no negatives
        w = witness_by_difference(3, 2, 1000)
        self.assertFalse(w.restricted)
        self.assertGreater(w.multiplier, 1)
        self.assertGreater(w.witness, 0)

    def test_subtraction_merges_the_two_branches(self):
        """Beyond the crossover, the difference beats almost every class."""
        for E in (40, 80, 160, 320, 640):
            need = counting_threshold(3**E)
            cost = witness_by_difference(3, E, 7).cost
            self.assertLess(cost, need)
        # and the gap widens
        self.assertLess(witness_by_difference(3, 640, 7).cost * 7,
                        counting_threshold(3**640))
        # below the crossover the difference route is not better
        self.assertGreater(witness_by_difference(3, 10, 7).cost,
                           counting_threshold(3**10))

    def test_subtraction_never_lengthens_a_chain(self):
        for n in range(2, 40):
            am = shortest_chain(n, "+*", cap=7)
            ams = shortest_chain(n, "+*-", cap=7)
            self.assertLessEqual(ams, am, f"n={n}")

    def test_where_subtraction_helps_is_not_the_traditions_domain(self):
        """The move transfers; the notion of 'round' does not."""
        rows = subtractive_advantage(60)
        helped = [n for n, _, _ in rows]
        self.assertEqual(helped, [14, 23, 31, 56, 59])
        nines = [n for n in range(2, 60) if n % 10 == 9]
        # the base-ten 'nines' are almost all NOT chain-subtractive
        self.assertEqual(set(helped) & set(nines), {59})
        # every helped n is a power of two minus a small correction
        for n, _, _ in rows:
            nearest = 2 ** n.bit_length()
            self.assertLess(nearest - n, n)

    def test_known_false_control_subtraction_always_helps(self):
        """'subtraction shortens every chain' is plausible and false."""
        unhelped = [n for n in range(2, 40)
                    if shortest_chain(n, "+*", cap=7) == shortest_chain(n, "+*-", cap=7)]
        self.assertTrue(unhelped)
        self.assertIn(9, unhelped)
        self.assertIn(19, unhelped)      # a 'nine' that gains nothing
        self.assertNotIn(31, unhelped)

    def test_shape_and_rejections(self):
        w = witness_by_difference(3, 4, 7)
        self.assertIsInstance(w, SubtractiveWitness)
        with self.assertRaises(Exception):
            w.cost = 0
        with self.assertRaises(ValueError):
            witness_by_difference(1, 4, 7)
        with self.assertRaises(ValueError):
            witness_by_difference(3, 0, 7)
        with self.assertRaises(ValueError):
            shortest_chain(0)
        with self.assertRaises(ValueError):
            shortest_chain(5, "+/")


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3

import unittest

from cyclotomic_sensor import multiplicative_order, valuation
from ramified_head_length import (
    Eisenstein,
    head_depth_without_forming,
    counterexample_table,
    depth_chain,
    is_ambiguous,
    observed_head_length,
    predicted_head_length,
    shift_law,
    true_head_length,
)


class EisensteinRingTests(unittest.TestCase):
    """The ring must be right before any claim about it is."""

    def test_uniformizer_powers_have_the_stated_valuations(self):
        field = Eisenstein(3, 4, 6)
        for power in range(0, 12):
            element = field.reduce([0] * power + [1])
            self.assertEqual(field.valuation(element), power)

    def test_the_prime_has_valuation_equal_to_the_ramification(self):
        for prime, ramification in ((2, 3), (3, 4), (5, 2)):
            field = Eisenstein(prime, ramification, 5)
            self.assertEqual(field.valuation(field.reduce([prime])), ramification)

    def test_valuation_is_additive_on_products(self):
        field = Eisenstein(3, 4, 6)
        for a in range(1, 7):
            for b in range(1, 7):
                left, right = field.reduce([0] * a + [2]), field.reduce([0] * b + [5])
                self.assertEqual(
                    field.valuation(field.multiply(left, right)),
                    field.valuation(left) + field.valuation(right),
                )


class ShiftLawTests(unittest.TestCase):
    def test_min_law_is_exact_off_the_ambiguous_depth(self):
        """v(x^p - 1) = min(e_K + k, p k) whenever the two terms differ."""
        for prime, ramification, precision in (
            (2, 1, 9), (3, 1, 9), (5, 1, 6),
            (2, 3, 8), (3, 4, 7), (5, 2, 6), (3, 16, 4), (2, 8, 6),
        ):
            field = Eisenstein(prime, ramification, precision)
            for depth in range(1, field.horizon // (prime + 1)):
                if is_ambiguous(field, depth):
                    continue
                for coefficient in range(1, min(prime, 4) + 1):
                    if coefficient % prime == 0:
                        continue
                    chain = depth_chain(field, depth, 1, coefficient)
                    self.assertEqual(
                        chain[1], shift_law(field, depth),
                        f"p={prime} e_K={ramification} k={depth} c={coefficient}",
                    )

    def test_the_ambiguous_depth_is_where_the_law_can_break_upward(self):
        """At k = e_K/(p-1) the two binomial terms tie and v can exceed the min."""
        field = Eisenstein(2, 1, 10)                    # theta = 1: the Q_2 case
        self.assertTrue(is_ambiguous(field, 1))
        self.assertGreater(depth_chain(field, 1, 1)[1], shift_law(field, 1))
        self.assertEqual(field.valuation(field.subtract(
            field.power(field.reduce([-1]), 2), field.reduce([1]))), field.horizon)

    def test_odd_primes_over_Qp_have_no_ambiguous_depth(self):
        for prime in (3, 5, 7, 11):
            field = Eisenstein(prime, 1, 5)
            self.assertFalse(any(is_ambiguous(field, k) for k in range(1, 20)))


class HeadLengthTests(unittest.TestCase):
    def test_the_corpus_Qp_results_are_untouched(self):
        """Over Q_p the prediction is correct -- e_K = 1 hides the error."""
        for prime in (2, 3, 5, 7, 11, 13):
            field = Eisenstein(prime, 1, 8)
            self.assertEqual(predicted_head_length(field), 1 if prime > 2 else 2)
            self.assertEqual(observed_head_length(field, 1, 4),
                             predicted_head_length(field))

    def test_exact_counterexamples_to_the_local_field_prediction(self):
        """p=3, e_K=4: predicted 3, actual 2. p=3, e_K=16: predicted 9, actual 3."""
        for prime, ramification, precision, steps, predicted, actual in (
            (3, 4, 7, 4, 3, 2),
            (2, 3, 9, 4, 4, 3),
            (3, 16, 4, 4, 9, 3),
        ):
            field = Eisenstein(prime, ramification, precision)
            self.assertEqual(predicted_head_length(field), predicted)
            self.assertEqual(observed_head_length(field, 1, steps), actual)
            self.assertNotEqual(predicted, actual)

    def test_theorem_H_matches_the_exact_chain(self):
        for prime, ramification, precision, steps in (
            (3, 1, 9, 4), (5, 1, 6, 3), (5, 2, 7, 3),
            (3, 4, 7, 4), (2, 3, 9, 4), (3, 16, 4, 4), (3, 9, 5, 4),
        ):
            field = Eisenstein(prime, ramification, precision)
            self.assertEqual(true_head_length(field, 1),
                             observed_head_length(field, 1, steps),
                             f"p={prime} e_K={ramification}")

    def test_theorem_H_declines_the_ambiguous_chains(self):
        """Where torsion can intervene, the head is not forced by the min law."""
        for prime, ramification in ((2, 1), (2, 8), (5, 4)):
            field = Eisenstein(prime, ramification, 6)
            with self.assertRaises(ValueError):
                true_head_length(field, 1)

    def test_the_gap_grows_without_bound(self):
        """Predicted is linear in e_K, observed logarithmic."""
        field_small = Eisenstein(3, 4, 7)
        field_large = Eisenstein(3, 16, 4)
        self.assertEqual(
            predicted_head_length(field_large) - predicted_head_length(field_small), 6)
        self.assertEqual(
            observed_head_length(field_large, 1, 4)
            - observed_head_length(field_small, 1, 4), 1)

    def test_the_published_table_is_reproducible(self):
        rows = counterexample_table()
        refuting = [(p, e) for p, e, pred, obs, _ in rows if pred != obs]
        self.assertEqual(refuting, [(3, 4), (2, 3), (3, 16), (2, 8)])


class SensorFormationCostTests(unittest.TestCase):
    """The head depth is reachable without forming a single family member."""

    def test_agrees_with_the_contributed_sensor(self):
        for prime in (3, 5, 7, 11, 13, 17, 19, 23, 1093):
            for base in (2, 3, 5, 6, 10):
                if base % prime == 0:
                    continue
                order = multiplicative_order(base, prime)
                self.assertEqual(
                    head_depth_without_forming(base, order, prime),
                    valuation(pow(base, order) - 1, prime),
                    f"p={prime} a={base}",
                )

    def test_the_avoided_integer_is_exponentially_larger(self):
        """Exact bit counts, not a timing measurement."""
        prime, base = 1093, 2                       # the note's Wieferich case
        order = multiplicative_order(base, prime)
        depth = head_depth_without_forming(base, order, prime)
        formed_bits = (pow(base, order) - 1).bit_length()
        needed_bits = (prime ** (depth + 1)).bit_length()
        self.assertEqual((order, depth), (364, 2))
        self.assertGreater(formed_bits, 10 * needed_bits)

    def test_a_deep_case_where_forming_would_be_hopeless(self):
        """ord_p(a) near p makes a^d - 1 astronomically large; the depth is not."""
        prime, base = 10_000_019, 3                 # a large prime, full order
        order = multiplicative_order(base, prime)
        self.assertGreaterEqual(order, prime // 2)
        self.assertGreater(order * base.bit_length(), 5_000_000)   # bits of a^d-1
        self.assertEqual(head_depth_without_forming(base, order, prime), 1)


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3

import unittest
from fractions import Fraction

from causal_memory import (
    compose_process_tables,
    cut_gluing_defect,
    cut_dimension,
    deterministic_memory_bits,
    is_nonnegative_fooling_set,
    marginals,
    memoryless_at_cut,
    predictive_profiles,
    rational_rank,
)


class CausalMemoryTests(unittest.TestCase):
    def test_outer_product_is_memoryless(self):
        joint = ((1, 2, 1), (2, 4, 2))
        self.assertEqual(cut_dimension(joint), 1)
        self.assertTrue(memoryless_at_cut(joint))
        self.assertEqual(predictive_profiles(joint), ((0, 1),))

    def test_perfect_bit_memory_has_rank_two(self):
        joint = ((1, 0), (0, 1))
        self.assertEqual(cut_dimension(joint), 2)
        self.assertFalse(memoryless_at_cut(joint))
        self.assertEqual(predictive_profiles(joint), ((0,), (1,)))
        self.assertEqual(deterministic_memory_bits(joint), 1)

    def test_one_time_marginals_do_not_determine_memory(self):
        correlated = ((1, 0), (0, 1))
        independent = ((1, 1), (1, 1))
        self.assertEqual(marginals(correlated), marginals(independent))
        self.assertEqual((cut_dimension(correlated), cut_dimension(independent)), (2, 1))

    def test_rank_is_exact_over_rationals(self):
        matrix = (
            (Fraction(1, 3), Fraction(1, 6), Fraction(1, 2)),
            (Fraction(2, 3), Fraction(1, 3), 1),
            (0, 1, 1),
        )
        self.assertEqual(rational_rank(matrix), 2)

    def test_invalid_predictive_row_is_rejected(self):
        with self.assertRaises(ValueError):
            predictive_profiles(((0, 0),))

    def test_square_slack_matrix_separates_rank_notions(self):
        square = ((0, 0, 1, 1), (1, 0, 0, 1),
                  (1, 1, 0, 0), (0, 1, 1, 0))
        self.assertEqual(rational_rank(square), 3)
        self.assertTrue(is_nonnegative_fooling_set(
            square, ((0, 2), (1, 3), (2, 0), (3, 1))))

    def test_cut_spectra_do_not_determine_composite(self):
        left = ((1, 0), (0, 0))
        aligned = ((1, 0), (0, 0))
        orthogonal = ((0, 0), (0, 1))
        self.assertEqual(rational_rank(aligned), rational_rank(orthogonal))
        self.assertEqual(rational_rank(compose_process_tables(left, aligned)), 1)
        self.assertEqual(rational_rank(compose_process_tables(left, orthogonal)), 0)

    def test_cut_gluing_defect_is_exact(self):
        left = ((1, 0), (0, 0))
        aligned = ((1, 0), (0, 0))
        transverse = ((0, 0), (0, 1))
        self.assertEqual(compose_process_tables(left, aligned), ((1, 0), (0, 0)))
        self.assertEqual(compose_process_tables(left, transverse), ((0, 0), (0, 0)))
        self.assertEqual(cut_gluing_defect(left, aligned), 0)
        self.assertEqual(cut_gluing_defect(left, transverse), 1)
        self.assertEqual(rational_rank(aligned), rational_rank(transverse))

    def test_gluing_rejects_mismatched_boundary(self):
        with self.assertRaises(ValueError):
            compose_process_tables(((1, 2),), ((1,), (2,), (3,)))


if __name__ == "__main__":
    unittest.main()

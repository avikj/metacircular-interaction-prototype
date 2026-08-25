import unittest

from adaptive_valuation_centers import (
    adaptive_upper_bound,
    nonadaptive_minimum_centers,
    reconstruct_residue,
)


class AdaptiveValuationCentersTests(unittest.TestCase):
    def test_every_residue_reconstructs(self):
        for prime, depth in ((2, 6), (3, 4), (5, 3)):
            for residue in range(prime**depth):
                result = reconstruct_residue(residue, prime, depth)
                self.assertEqual(result.residue, residue)
                self.assertLessEqual(len(result.queries), adaptive_upper_bound(prime, depth))

    def test_worst_branch_attains_bound(self):
        for prime, depth in ((2, 7), (3, 5), (5, 3)):
            residue = prime**depth - 1
            result = reconstruct_residue(residue, prime, depth)
            self.assertEqual(len(result.queries), adaptive_upper_bound(prime, depth))

    def test_adaptive_vs_nonadaptive_counts(self):
        self.assertEqual(adaptive_upper_bound(3, 4), 8)
        self.assertEqual(nonadaptive_minimum_centers(3, 4), 54)
        self.assertEqual(adaptive_upper_bound(2, 8), 8)
        self.assertEqual(nonadaptive_minimum_centers(2, 8), 128)

    def test_invalid_prime_rejected(self):
        with self.assertRaises(ValueError):
            reconstruct_residue(0, 4, 2)


if __name__ == "__main__":
    unittest.main()

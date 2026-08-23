import unittest
from fractions import Fraction

from machinery.payload_morphism_boundary import (
    mellin_carrier_boundary, qap_native_rank,
)


class PayloadMorphismBoundaryTests(unittest.TestCase):
    def test_same_payload_two_exact_minima(self):
        result = mellin_carrier_boundary(3, Fraction(-2), 0)
        self.assertEqual(result.support_size, 3)
        self.assertEqual(result.unrestricted_rank, 1)
        self.assertEqual(result.graded_rank, 3)
        self.assertEqual(result.reconstructed, result.residual)

    def test_promotion_changes_graded_not_unrestricted_rank(self):
        ranks = tuple((mellin_carrier_boundary(3, Fraction(-2), depth).unrestricted_rank,
                       mellin_carrier_boundary(3, Fraction(-2), depth).graded_rank)
                      for depth in range(4))
        self.assertEqual(ranks, ((1, 3), (1, 2), (1, 1), (0, 0)))

    def test_qap_rank_is_native_linear_image_rank(self):
        self.assertEqual(qap_native_rank(), 1)

    def test_zero_coefficients_remove_channels(self):
        result = mellin_carrier_boundary(3, Fraction(0), 0)
        self.assertEqual((result.unrestricted_rank, result.graded_rank), (0, 0))


if __name__ == "__main__":
    unittest.main()

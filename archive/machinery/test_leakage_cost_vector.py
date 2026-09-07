import unittest

from machinery.amortized_certificate_walk import CostCertificate
from machinery.leakage_cost_vector import (
    ExecutionCostVector,
    compare_routes,
    identity,
    position,
    q6_examples,
    rank_factorization,
)
from machinery.primitive_character_projector import multiply, primitive_projector


class LeakageCostVectorTests(unittest.TestCase):
    def test_q6_translation_preserves_sector(self):
        translation, _ = q6_examples()
        self.assertEqual(translation.leakage_rank, 0)
        self.assertTrue(translation.restricted.exact)
        self.assertEqual(translation.corrected, ExecutionCostVector(104, 0, True))

    def test_q6_position_requires_two_channels(self):
        _, position_sensitive = q6_examples()
        self.assertEqual(position_sensitive.leakage_rank, 2)
        self.assertFalse(position_sensitive.restricted.exact)
        self.assertEqual(position_sensitive.corrected,
                         ExecutionCostVector(104, 8, True))

    def test_rank_factorization_replays_leakage(self):
        p = primitive_projector(6)
        from machinery.leakage_cost_vector import leakage
        leak = leakage(p, position(6))
        b, c = rank_factorization(leak)
        self.assertEqual(len(c), 2)
        self.assertEqual(multiply(b, c), leak)

    def test_identity_projector_has_no_leakage(self):
        result = compare_routes(CostCertificate(2, 5, 1), 1,
                                identity(3), position(3))
        self.assertEqual(result.leakage_rank, 0)
        self.assertTrue(result.restricted.exact)

    def test_negative_horizon_rejected(self):
        with self.assertRaisesRegex(ValueError, "nonnegative"):
            compare_routes(CostCertificate(1, 2, 1), -1,
                           identity(2), position(2))


if __name__ == "__main__":
    unittest.main()

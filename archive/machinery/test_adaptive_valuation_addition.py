#!/usr/bin/env python3

import unittest

from adaptive_valuation_addition import adaptive_sum_valuation, verify_certificate


class AdaptiveValuationAdditionTests(unittest.TestCase):
    def test_equal_unit_depth_can_request_arbitrarily_fine_sensor(self):
        for prime in (2, 3, 5):
            for height in range(7):
                certificate = adaptive_sum_valuation(1, prime**height - 1, prime)
                self.assertEqual(certificate.valuation, height)
                self.assertEqual(len(certificate.steps), height + 1)
                self.assertTrue(verify_certificate(1, prime**height - 1, certificate))

    def test_every_coarser_observation_reports_zero_sum(self):
        certificate = adaptive_sum_valuation(14, 3**5 - 14, 3)
        self.assertTrue(all(step.sum_residue == 0 for step in certificate.steps[:-1]))
        self.assertNotEqual(certificate.steps[-1].sum_residue, 0)

    def test_unequal_depth_stops_at_the_ultrametric_minimum_plus_one(self):
        certificate = adaptive_sum_valuation(3**2, 3**5, 3)
        self.assertEqual(certificate.valuation, 2)
        self.assertEqual(len(certificate.steps), 3)
        self.assertTrue(verify_certificate(3**2, 3**5, certificate))

    def test_zero_requires_external_exact_equality_certificate(self):
        certificate = adaptive_sum_valuation(1729, -1729, 7)
        self.assertTrue(certificate.is_zero)
        self.assertIsNone(certificate.valuation)
        self.assertEqual(certificate.steps, ())
        self.assertTrue(verify_certificate(1729, -1729, certificate))

    def test_tampered_certificate_fails(self):
        certificate = adaptive_sum_valuation(1, 26, 3)
        self.assertFalse(verify_certificate(1, 25, certificate))

    def test_composite_base_is_rejected(self):
        with self.assertRaises(ValueError):
            adaptive_sum_valuation(1, 2, 9)


if __name__ == "__main__":
    unittest.main()

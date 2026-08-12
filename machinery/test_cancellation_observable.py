#!/usr/bin/env python3

import unittest

from cancellation_observable import (
    form_cancellation_observable,
    verify_cancellation_certificate,
)


class CancellationObservableTests(unittest.TestCase):
    def test_transport_equation_and_normalized_compiler(self):
        certificate = form_cancellation_observable(45, 198, 3)
        # min(v_3(45),v_3(198))=2 and 45+198=3^5.
        self.assertEqual(certificate.common_depth, 2)
        self.assertEqual(certificate.cancellation, 3)
        self.assertEqual(len(certificate.refinement.steps), 4)
        self.assertTrue(verify_cancellation_certificate(45, 198, certificate))

    def test_unequal_depth_has_zero_residual(self):
        for prime in (2, 3, 5, 7):
            certificate = form_cancellation_observable(prime, prime**3, prime)
            self.assertEqual(certificate.cancellation, 0)
            self.assertTrue(verify_cancellation_certificate(prime, prime**3, certificate))

    def test_common_scaling_equivariance(self):
        base = form_cancellation_observable(5, 22, 3)
        for scale in (-14, 2, 9, 75):
            scaled = form_cancellation_observable(scale * 5, scale * 22, 3)
            self.assertEqual(scaled.cancellation, base.cancellation)

    def test_equal_depth_realizes_unbounded_finite_residuals(self):
        for prime in (2, 3, 5):
            for height in range(1, 8):
                certificate = form_cancellation_observable(1, prime**height - 1, prime)
                self.assertEqual(certificate.common_depth, 0)
                self.assertEqual(certificate.cancellation, height)

    def test_odd_prime_equal_depth_can_have_zero_residual(self):
        for prime in (3, 5, 7):
            self.assertEqual(form_cancellation_observable(1, 1, prime).cancellation, 0)
        # Two 2-adic units always cancel to depth at least one.
        self.assertEqual(form_cancellation_observable(1, 1, 2).cancellation, 1)

    def test_zero_sum_is_infinite_boundary(self):
        certificate = form_cancellation_observable(63, -63, 3)
        self.assertTrue(certificate.is_zero_sum)
        self.assertIsNone(certificate.cancellation)
        self.assertTrue(verify_cancellation_certificate(63, -63, certificate))

    def test_zero_input_and_composite_prime_fail_closed(self):
        with self.assertRaises(ValueError):
            form_cancellation_observable(0, 1, 3)
        with self.assertRaises(ValueError):
            form_cancellation_observable(1, 2, 9)


if __name__ == "__main__":
    unittest.main()

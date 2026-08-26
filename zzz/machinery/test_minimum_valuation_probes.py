#!/usr/bin/env python3

import unittest

from minimum_valuation_probes import (
    collision,
    form_minimum_probe_basis,
    response_vector,
    verify_minimum_certificate,
)


class MinimumValuationProbeTests(unittest.TestCase):
    def test_canonical_bases_separate_and_have_sharp_size(self):
        for prime, depth in ((2, 1), (2, 4), (3, 3), (5, 2)):
            certificate = form_minimum_probe_basis(prime, depth)
            self.assertEqual(
                len(certificate.centers),
                (prime - 1) * prime ** (depth - 1),
            )
            self.assertTrue(verify_minimum_certificate(certificate))
            self.assertIsNone(collision(certificate.centers, prime, depth))

    def test_every_center_is_necessary_in_a_minimum_basis(self):
        certificate = form_minimum_probe_basis(3, 3)
        for center in certificate.centers:
            reduced = tuple(value for value in certificate.centers if value != center)
            self.assertIsNotNone(collision(reduced, 3, 3))

    def test_two_omitted_siblings_are_always_indistinguishable(self):
        prime, depth = 5, 2
        parent_modulus = prime ** (depth - 1)
        block = tuple(2 + digit * parent_modulus for digit in range(prime))
        centers = tuple(value for value in range(prime**depth) if value not in block[:2])
        self.assertEqual(
            response_vector(block[0], centers, prime, depth),
            response_vector(block[1], centers, prime, depth),
        )

    def test_arbitrary_one_omission_per_block_is_sufficient(self):
        prime, depth = 3, 3
        parent_modulus = prime ** (depth - 1)
        omissions = {
            parent + (parent % prime) * parent_modulus
            for parent in range(parent_modulus)
        }
        centers = tuple(value for value in range(prime**depth) if value not in omissions)
        self.assertIsNone(collision(centers, prime, depth))

    def test_invalid_chart_fails_closed(self):
        with self.assertRaises(ValueError):
            form_minimum_probe_basis(9, 2)
        with self.assertRaises(ValueError):
            form_minimum_probe_basis(3, 0)


if __name__ == "__main__":
    unittest.main()

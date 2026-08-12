#!/usr/bin/env python3
import unittest

from kuttaka_update import (
    CongruenceState, Incompatibility, UpdateCertificate,
    add_constraint, extended_gcd, verify,
)


class KuttakaUpdateTests(unittest.TestCase):
    def test_bezout_certificate(self):
        g, u, v = extended_gcd(84, 30)
        self.assertEqual((g, 84 * u + 30 * v), (6, 6))

    def test_prime_power_sensor_composition(self):
        state = CongruenceState(0, 1)
        for residue, modulus in ((2, 8), (5, 9), (4, 5)):
            result = add_constraint(state, residue, modulus)
            self.assertIsInstance(result, UpdateCertificate)
            self.assertTrue(verify(result))
            state = result.after
        self.assertEqual(state, CongruenceState(194, 360))

    def test_compatible_noncoprime_update(self):
        result = add_constraint(CongruenceState(2, 6), 8, 9)
        self.assertIsInstance(result, UpdateCertificate)
        self.assertEqual(result.after, CongruenceState(8, 18))
        self.assertTrue(verify(result))

    def test_incompatibility_is_exact(self):
        result = add_constraint(CongruenceState(1, 4), 2, 6)
        self.assertIsInstance(result, Incompatibility)
        self.assertEqual((result.gcd, result.difference), (2, 1))
        self.assertTrue(verify(result))

    def test_invalid_modulus_fails_closed(self):
        with self.assertRaises(ValueError):
            CongruenceState(0, 0)


if __name__ == "__main__":
    unittest.main()

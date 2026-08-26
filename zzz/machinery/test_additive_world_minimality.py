#!/usr/bin/env python3

import unittest

from additive_world_minimality import internal_witness, verify_witness


class AdditiveWorldMinimalityTests(unittest.TestCase):
    def test_witness_stays_inside_subgroup_and_climbs(self):
        for generator in range(1, 18):
            for prime in (2, 3, 5, 7):
                for left_factor, right_factor in ((1, 1), (1, 3), (-2, 5), (7, -3)):
                    left, right = generator * left_factor, generator * right_factor
                    if left + right == 0:
                        continue
                    witness = internal_witness(generator, prime, left, right)
                    self.assertTrue(verify_witness(witness))
                    self.assertGreater(witness.witness_valuation, witness.valuation)

    def test_prime_power_in_generator_needs_no_saturation_assumption(self):
        witness = internal_witness(2**5 * 3, 2, 2**5 * 3, 2**6 * 3)
        self.assertTrue(verify_witness(witness))
        self.assertEqual(witness.valuation, 5)

    def test_mixed_prime_generator_uses_crt_coefficient(self):
        witness = internal_witness(30, 7, 30, 60)
        self.assertEqual(witness.coefficient % 5, 0)
        self.assertEqual(witness.coefficient % 7, -((90 // 7**witness.valuation) % 7) % 7)
        self.assertTrue(verify_witness(witness))

    def test_zero_sum_and_nonmembers_fail_closed(self):
        with self.assertRaises(ValueError):
            internal_witness(6, 3, 6, -6)
        with self.assertRaises(ValueError):
            internal_witness(6, 3, 5, 7)

    def test_tampering_fails(self):
        witness = internal_witness(6, 3, 6, 12)
        bad = witness.__class__(**{**witness.__dict__, "witness_right": witness.witness_right + 1})
        self.assertFalse(verify_witness(bad))


if __name__ == "__main__":
    unittest.main()

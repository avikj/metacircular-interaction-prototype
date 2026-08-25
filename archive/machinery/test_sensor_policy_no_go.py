#!/usr/bin/env python3

import unittest
from math import isqrt

from arithmetic_life import ArithmeticLife
from sensor_policy_no_go import (
    certifies_prime,
    complete_policy,
    falsify_policy,
    primes_through,
    thrifty_policy,
)


class SensorPolicyNoGoTests(unittest.TestCase):
    def test_complete_policy_has_no_counterexample(self):
        for frontier in range(2, 60):
            self.assertIsNone(falsify_policy(complete_policy, frontier))

    def test_every_incomplete_policy_certifies_a_prime_square(self):
        for frontier in range(4, 60):
            witness = falsify_policy(thrifty_policy, frontier)
            self.assertIsNotNone(witness)
            n, q = witness
            self.assertEqual(n, q * q)
            self.assertTrue(certifies_prime(thrifty_policy(frontier), n))

    def test_dropping_any_single_sense_is_already_fatal(self):
        """T5 is sharp: no prime below the frontier is expendable."""
        frontier = 30
        full = primes_through(frontier)
        for q in full:
            witness = falsify_policy(lambda b, q=q: [p for p in full if p != q], frontier)
            self.assertEqual(witness, (q * q, q))

    def test_the_live_machine_realizes_the_complete_policy(self):
        for n in (91, 97, 143, 211, 2 * 3 * 5 * 7):
            life = ArithmeticLife()
            life.factor(n)
            bound = isqrt(n)
            self.assertEqual(
                sorted(m for m in life.moduli if m <= bound),
                complete_policy(bound),
            )

    def test_no_go_agrees_with_the_machine_on_prime_squares(self):
        for q in (2, 3, 5, 7, 11, 13):
            life = ArithmeticLife()
            self.assertEqual(life.factor(q * q), (q, q))


if __name__ == "__main__":
    unittest.main()

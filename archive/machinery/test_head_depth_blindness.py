#!/usr/bin/env python3

import unittest

from head_depth_blindness import (
    blindness_depth,
    deep_bases,
    head_depth,
    is_fermat_blind,
    multiplicative_order,
    theorem_w3,
    valuation,
)


class TheoremW3Tests(unittest.TestCase):
    def test_blindness_matches_the_head_depth(self):
        checked = 0
        for prime in (3, 5, 7, 11, 13, 17, 19, 23):
            for base in range(2, 3 * prime):
                if base % prime == 0:
                    continue
                for power in range(1, 5):
                    self.assertTrue(theorem_w3(base, prime, power),
                                    f"q={prime} b={base} a={power}")
                    checked += 1
        self.assertGreater(checked, 1000)

    def test_head_depth_equals_blindness_depth(self):
        for prime in (3, 5, 7, 11, 13, 17):
            for base in range(2, 2 * prime):
                if base % prime == 0:
                    continue
                self.assertEqual(head_depth(base, prime),
                                 blindness_depth(base, prime),
                                 f"q={prime} b={base}")

    def test_every_base_is_blind_at_depth_one_which_is_correct(self):
        """`q` itself is prime, so no base may refute it."""
        for prime in (3, 5, 7, 11, 13):
            for base in range(2, 2 * prime):
                if base % prime == 0:
                    continue
                self.assertTrue(is_fermat_blind(base, prime, 1))
                self.assertGreaterEqual(head_depth(base, prime), 1)

    def test_deep_bases_exist_and_are_exactly_the_predicted_ones(self):
        for prime in (5, 7, 11, 13, 17):
            deep = {b for b in range(2, prime ** 2)
                    if b % prime and head_depth(b, prime) >= 2}
            predicted = {b for b in deep_bases(prime, 2) if b >= 2}
            self.assertEqual(deep, predicted, f"q={prime}")
            self.assertTrue(deep)


class CorollaryW4Tests(unittest.TestCase):
    def test_level_sets_have_order_q_minus_one(self):
        for prime in (5, 7, 11, 13):
            for power in (1, 2, 3):
                self.assertEqual(len(deep_bases(prime, power)), prime - 1)

    def test_level_sets_have_index_q_to_the_a_minus_one(self):
        for prime in (5, 7, 11, 13):
            for power in (1, 2, 3):
                totient = prime ** (power - 1) * (prime - 1)
                self.assertEqual(totient // len(deep_bases(prime, power)),
                                 prime ** (power - 1))

    def test_level_sets_are_closed_under_multiplication(self):
        for prime in (5, 7, 11):
            for power in (2, 3):
                modulus, members = prime ** power, sorted(deep_bases(prime, power))
                for x in members:
                    for y in members:
                        self.assertIn(x * y % modulus, set(members))

    def test_level_sets_are_nested_downward(self):
        for prime in (5, 7, 11):
            shallow = {b % prime ** 2 for b in deep_bases(prime, 3)}
            self.assertTrue(shallow <= deep_bases(prime, 2))


class SessionEightSpecialCaseTests(unittest.TestCase):
    """W2 is exactly W3 at b = 2, a = 2."""

    def test_the_wieferich_bridge_is_recovered(self):
        for prime in (1093, 3511):
            self.assertEqual(head_depth(2, prime), 2)
            self.assertTrue(is_fermat_blind(2, prime, 2))
            self.assertTrue(theorem_w3(2, prime, 2))

    def test_a_non_wieferich_prime_is_seen_at_depth_two(self):
        for prime in (1091, 11, 13, 17):
            self.assertEqual(head_depth(2, prime), 1)
            self.assertFalse(is_fermat_blind(2, prime, 2))

    def test_the_named_cyclotomic_instance(self):
        self.assertEqual(multiplicative_order(2, 1093), 364)
        self.assertEqual(valuation(2 ** 364 - 1, 1093), 2)


if __name__ == "__main__":
    unittest.main()

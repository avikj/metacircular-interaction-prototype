#!/usr/bin/env python3
"""Exact tests for anthyphairetic hitting times.

Run: python3 -m unittest test_anthyphairetic_hitting -v   (from machinery/)
"""

import unittest
from math import gcd

from anthyphairetic_hitting import (
    HittingCertificate,
    apply_word,
    continued_fraction,
    euclid_explicit_witness,
    euclid_hitting_time,
    euclid_lower_bound,
    euclid_upper_bound,
    quotient_sum,
    successor_hitting_time,
    valuation,
    word_length,
)

ODD = (3, 5, 7, 11)


class AnthyphaireticHittingTests(unittest.TestCase):
    def test_word_length_is_the_quotient_sum(self):
        """Theorem H1, exhaustively on coprime pairs with entries < 45."""
        checked = 0
        for x in range(1, 45):
            for y in range(1, 45):
                if gcd(x, y) != 1:
                    continue
                self.assertEqual(word_length(x, y), quotient_sum(x, y) - 1)
                checked += 1
        self.assertGreater(checked, 1000)

    def test_word_reconstructs_the_pair(self):
        """The BFS word applied to (1,1) really is the witness."""
        for p, a, b in ((3, 1, 2), (3, 4, 5), (5, 2, 3), (2, 1, 3), (2, 3, 5)):
            cert = euclid_hitting_time(p, a, b)
            self.assertEqual(apply_word(cert.word), cert.witness)
            self.assertEqual(len(cert.word), cert.hitting_time)
            self.assertEqual(word_length(*cert.witness), cert.hitting_time)

    def test_witness_really_is_a_witness(self):
        """It sits in the depth-v fiber and its sum has valuation > v."""
        for p in (2, 3, 5, 7):
            for a in range(1, 9):
                for b in range(1, 9):
                    if gcd(a, b) != 1:
                        continue
                    cert = euclid_hitting_time(p, a, b)
                    self.assertIsNotNone(cert.hitting_time)
                    x, y = cert.witness
                    v = cert.valuation
                    self.assertEqual(x % p**v, a % p**v)
                    self.assertEqual(y % p**v, b % p**v)
                    self.assertGreater(valuation(x + y, p), v)

    def test_proved_two_sided_bounds_hold(self):
        """Theorem H3: (v+1)log2(p) - 1 <= T <= p^{v+1} - 2."""
        for p in (2, 3, 5, 7):
            for a in range(1, 10):
                for b in range(1, 10):
                    if gcd(a, b) != 1:
                        continue
                    cert = euclid_hitting_time(p, a, b)
                    self.assertGreaterEqual(cert.hitting_time,
                                            euclid_lower_bound(p, cert.valuation))
                    self.assertLessEqual(cert.hitting_time,
                                         euclid_upper_bound(p, cert.valuation))

    def test_explicit_witness_proves_the_upper_bound(self):
        """The construction (a', p^{v+1}-a') is coprime and in the fiber."""
        for p in (2, 3, 5, 7):
            for a in range(1, 12):
                for b in range(1, 12):
                    if gcd(a, b) != 1:
                        continue
                    v = valuation(a + b, p)
                    x, y = euclid_explicit_witness(p, a, b)
                    self.assertEqual(gcd(x, y), 1)
                    self.assertEqual((x + y) % p**(v + 1), 0)
                    self.assertEqual(x % p**v, a % p**v)
                    self.assertEqual(y % p**v, b % p**v)
                    self.assertLessEqual(word_length(x, y),
                                         euclid_upper_bound(p, v))

    def test_successor_closed_form_matches_a_direct_search(self):
        """Theorem H4: t = s*p^v with u + 2s = 0 mod p."""
        for p in ODD:
            for a in range(1, 10):
                for b in range(1, 10):
                    if gcd(a, b) != 1:
                        continue
                    cert = successor_hitting_time(p, a, b)
                    v = cert.valuation
                    found = None
                    for t in range(0, p**(v + 1) + 1):
                        if ((a + t) % p**v == a % p**v
                                and (b + t) % p**v == b % p**v
                                and (a + b + 2 * t) % p**(v + 1) == 0):
                            found = t
                            break
                    self.assertEqual(cert.hitting_time, found)
                    self.assertGreaterEqual(found, p**v)
                    self.assertLessEqual(found, (p - 1) * p**v)

    def test_successor_never_hits_at_two(self):
        for a in range(1, 12):
            for b in range(1, 12):
                if gcd(a, b) != 1:
                    continue
                self.assertIsNone(successor_hitting_time(2, a, b).hitting_time)

    def test_the_separation_between_the_two_rules(self):
        """Successor's lower bound is p^v; anthyphairesis' is (v+1)log2(p)."""
        for p in ODD:
            for v in range(1, 6):
                # never worse, and strictly better from v = 2 on
                self.assertLessEqual(euclid_lower_bound(p, v), p**v)
                if v >= 2:
                    self.assertLess(euclid_lower_bound(p, v), p**v)
            # the one tie among small cases: p = 3, v = 1 gives 3 = 3
            self.assertEqual(euclid_lower_bound(3, 1), 3)
            # and the gap widens without bound
            self.assertLess(euclid_lower_bound(p, 8) * 100, p**8)
        # measured, on pairs where both rules are defined
        for p, a, b in ((3, 13, 14), (5, 2, 3), (7, 3, 4), (3, 4, 5)):
            e = euclid_hitting_time(p, a, b)
            s = successor_hitting_time(p, a, b)
            self.assertLessEqual(e.hitting_time, s.hitting_time)

    def test_known_false_control_richer_moves_hit_sooner(self):
        """'more moves always means a sooner hit' is plausible and false."""
        # p=3, (1,2): successor reaches the witness in 3 moves, anthyphairesis
        # needs 4, although its reachable set is vastly larger.
        e = euclid_hitting_time(3, 1, 2)
        s = successor_hitting_time(3, 1, 2)
        self.assertEqual(e.hitting_time, 4)
        self.assertEqual(s.hitting_time, 3)
        self.assertGreater(e.hitting_time, s.hitting_time)

    def test_certificate_shape_and_rejections(self):
        cert = euclid_hitting_time(3, 1, 2)
        self.assertIsInstance(cert, HittingCertificate)
        with self.assertRaises(Exception):
            cert.hitting_time = 0
        with self.assertRaises(ValueError):
            word_length(2, 4)            # not coprime, not in the orbit
        with self.assertRaises(ValueError):
            word_length(0, 1)            # not positive
        with self.assertRaises(ValueError):
            apply_word("LX")             # bad move letter
        with self.assertRaises(ValueError):
            valuation(0, 3)


if __name__ == "__main__":
    unittest.main()

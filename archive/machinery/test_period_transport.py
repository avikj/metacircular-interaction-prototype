#!/usr/bin/env python3
"""Exact tests for the period-parity transport criterion.

Run: python3 -m unittest test_period_transport -v   (from machinery/)
"""

import unittest

from period_transport import (
    TransportCertificate,
    certify,
    midy_halves,
    multiplicative_order,
    repetend,
    transports_by_fiber,
    transports_by_group,
    transports_by_period,
    transports_with_prime_formed,
    unit_image,
)

ODD_PRIMES = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59,
              61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127,
              131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191,
              193, 197, 199]


class PeriodTransportTests(unittest.TestCase):
    def test_period_length_is_the_multiplicative_order(self):
        """Long division and the group computation return the same integer."""
        for g in (2, 3, 5, 7, 10):
            for p in ODD_PRIMES:
                if g % p == 0:
                    continue
                self.assertEqual(len(repetend(p, g)),
                                 multiplicative_order(g, p))

    def test_midy_theorem_on_the_classical_examples(self):
        """142857, 076923, 09 -- the halves are nines complements."""
        self.assertEqual(repetend(7, 10), [1, 4, 2, 8, 5, 7])
        self.assertEqual(midy_halves(repetend(7, 10), 10), (142, 857, 999))
        self.assertEqual(midy_halves(repetend(13, 10), 10), (76, 923, 999))
        self.assertEqual(midy_halves(repetend(11, 10), 10), (0, 9, 9))
        # and in another base, where "nines" becomes g^m - 1
        self.assertEqual(midy_halves(repetend(11, 2), 2), (2, 29, 31))
        self.assertEqual(midy_halves(repetend(5, 3), 3), (1, 7, 8))

    def test_midy_holds_wherever_the_period_is_even(self):
        for g in (2, 3, 10):
            for p in ODD_PRIMES:
                if g % p == 0:
                    continue
                digits = repetend(p, g)
                if len(digits) % 2:
                    continue
                first, second, target = midy_halves(digits, g)
                self.assertEqual(first + second, target)

    def test_three_routes_to_the_criterion_agree(self):
        """Period parity == (-1 in the image) == depth-0 chart defeated."""
        for g in (2, 3, 5, 10):
            for p in ODD_PRIMES:
                if g % p == 0:
                    continue
                by_period = transports_by_period(p, g)
                by_group = transports_by_group(p, [g])
                self.assertEqual(by_period, by_group)
                self.assertEqual(by_period, transports_by_fiber(p, [g]))

    def test_the_decimal_organism_fails_at_3_31_37_41(self):
        """Odd period, so no two powers of 10 ever cancel at these primes."""
        for p in (3, 31, 37, 41, 43):
            cert = certify(p, [10])
            self.assertFalse(cert.transports)
            self.assertEqual(cert.period % 2, 1)
            self.assertIsNone(cert.midy)
            self.assertIsNone(cert.cancelling_pair)
            powers = [pow(10, k, p) for k in range(multiplicative_order(10, p))]
            self.assertFalse(any((x + y) % p == 0 for x in powers for y in powers))

    def test_transport_holds_with_an_explicit_cancelling_pair(self):
        for p in (7, 11, 13, 17, 19):
            cert = certify(p, [10])
            self.assertTrue(cert.transports)
            self.assertEqual(cert.period % 2, 0)
            u, w = cert.cancelling_pair
            self.assertEqual((u + w) % p, 0)

    def test_many_generators_transport_iff_some_order_is_even(self):
        """(Z/p)^* is cyclic, so ord<g,h> = lcm: odd orders never reach -1."""
        for p in ODD_PRIMES[:20]:
            for g, h in [(2, 3), (3, 10), (2, 5), (5, 7), (3, 7)]:
                if g % p == 0 or h % p == 0:
                    continue
                some_even = (multiplicative_order(g, p) % 2 == 0
                             or multiplicative_order(h, p) % 2 == 0)
                self.assertEqual(transports_by_group(p, [g, h]), some_even)
                self.assertEqual(transports_by_fiber(p, [g, h]), some_even)
        # a concrete pair of odd-order generators that together stay from -1
        self.assertEqual(multiplicative_order(10, 31), 15)
        self.assertEqual(multiplicative_order(2, 31), 5)
        self.assertFalse(transports_by_group(31, [2, 10]))
        self.assertNotIn(30, unit_image(31, [2, 10]))

    def test_forming_the_prime_repairs_the_failure(self):
        """Theorem A': on F = p^N * S transport holds at every odd p."""
        for p in (3, 31, 37):
            self.assertFalse(transports_by_group(p, [10]))
            self.assertTrue(transports_with_prime_formed(p, [10]))

    def test_lifted_order_parity_is_not_needed(self):
        """Parity of ord_{p^m}(g) is constant in m, so level p decides."""
        for g in (2, 3, 10):
            for p in ODD_PRIMES[:12]:
                if g % p == 0:
                    continue
                base = multiplicative_order(g, p) % 2
                for m in (2, 3):
                    self.assertEqual(multiplicative_order(g, p**m) % 2, base)

    def test_known_false_control_p_mod_4(self):
        """'p = 1 mod 4 decides transport' is plausible and false; it must fire."""
        wrong = [p for p in ODD_PRIMES if 10 % p
                 and (p % 4 == 1) != transports_by_period(p, 10)]
        self.assertTrue(wrong, "the false rule must disagree somewhere")
        self.assertIn(7, wrong)      # 7 = 3 mod 4 yet period 6 is even
        self.assertIn(41, wrong)     # 41 = 1 mod 4 yet period 5 is odd

    def test_certificate_shape_and_rejections(self):
        cert = certify(7, [10])
        self.assertIsInstance(cert, TransportCertificate)
        with self.assertRaises(Exception):
            cert.transports = False
        with self.assertRaises(ValueError):
            certify(2, [3])              # Theorem A is for odd p
        with self.assertRaises(ValueError):
            repetend(7, 7)               # p divides the base
        with self.assertRaises(ValueError):
            midy_halves(repetend(37, 10), 10)   # odd period
        with self.assertRaises(ValueError):
            unit_image(7, [14])          # generator is not a unit


if __name__ == "__main__":
    unittest.main()

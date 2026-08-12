#!/usr/bin/env python3

import unittest

from exposed_set import (
    cyclotomic_head_depth,
    exposed_set,
    fermat_nonwitnesses_of_prime_power,
    head_depth_equals_wieferich,
    is_wieferich,
    multiplicative_order,
    sieve,
    small_factors,
    strong_refutes,
    unwitnessed,
)


class LocalizationTests(unittest.TestCase):
    """Only the exposed set can lose soundness when a sensor is dropped."""

    def test_every_exposed_number_is_a_prime_power_or_prime_power_times_a_prime(self):
        bound = 60
        flags = sieve(bound * bound)
        primes = [n for n in range(2, bound + 1) if flags[n]]
        for dropped, numbers in exposed_set(bound).items():
            for number in numbers:
                remaining = number
                while remaining % dropped == 0:
                    remaining //= dropped
                self.assertTrue(remaining == 1 or (flags[remaining]
                                                   and remaining > bound),
                                f"q={dropped} n={number} left {remaining}")
                self.assertEqual(small_factors(number, primes, bound), {dropped})

    def test_non_exposed_composites_keep_a_divisibility_refuter(self):
        bound = 40
        flags = sieve(bound * bound)
        primes = [n for n in range(2, bound + 1) if flags[n]]
        exposed = exposed_set(bound)
        flat = {n for numbers in exposed.values() for n in numbers}
        for number in range(4, bound * bound + 1):
            if flags[number] or number in flat:
                continue
            for dropped in primes:
                self.assertTrue(any(number % p == 0 for p in primes
                                    if p != dropped and p < number),
                                f"n={number} q={dropped}")


class PermanenceVerificationTests(unittest.TestCase):
    def test_no_exposed_number_lacks_a_retained_witness(self):
        """Exhaustive: a proof at these frontiers and nowhere beyond them."""
        for bound in (40, 60, 100):
            self.assertEqual(unwitnessed(bound), [], f"B={bound}")


class LemmaWTests(unittest.TestCase):
    def test_nonwitnesses_form_the_subgroup_of_order_q_minus_one(self):
        for prime in (5, 7, 11, 13):
            for power in (2, 3):
                modulus = prime ** power
                by_fermat = set(fermat_nonwitnesses_of_prime_power(prime, power))
                by_lemma = {b for b in range(2, modulus)
                            if b % prime and pow(b, prime - 1, modulus) == 1}
                self.assertEqual(by_fermat, by_lemma)
                full = {b for b in range(1, modulus)
                        if b % prime and pow(b, prime - 1, modulus) == 1}
                self.assertEqual(len(full), prime - 1)

    def test_base_two_refutes_every_odd_prime_power_off_the_wieferich_primes(self):
        for prime in (3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
            self.assertFalse(is_wieferich(prime))
            for power in (2, 3):
                self.assertTrue(strong_refutes(2, prime ** power))

    def test_base_two_fails_exactly_at_the_wieferich_squares(self):
        for prime in (1093, 3511):
            self.assertTrue(is_wieferich(prime))
            self.assertFalse(strong_refutes(2, prime * prime))
            self.assertTrue(strong_refutes(3, prime * prime))

    def test_the_only_wieferich_primes_below_twenty_thousand(self):
        found = [q for q in range(3, 20000, 2)
                 if all(q % d for d in range(3, int(q ** 0.5) + 1, 2))
                 and is_wieferich(q)]
        self.assertEqual(found, [1093, 3511])


class CorollaryW2Tests(unittest.TestCase):
    """The cyclotomic head anomaly and the pinning failure are one event."""

    def test_head_depth_at_least_two_iff_wieferich(self):
        for prime in (3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 1091, 1093, 3511):
            self.assertTrue(head_depth_equals_wieferich(prime), f"q={prime}")

    def test_the_named_instance_matches_the_cyclotomic_note(self):
        """CYCLOTOMIC_SENSOR's deep sensor: ord_1093(2) = 364, e = 2."""
        self.assertEqual(multiplicative_order(2, 1093), 364)
        self.assertEqual(cyclotomic_head_depth(1093), 2)
        self.assertEqual(cyclotomic_head_depth(11), 1)

    def test_the_two_failures_coincide_pointwise(self):
        for prime in (11, 13, 1091, 1093, 3511):
            anomalous_head = cyclotomic_head_depth(prime) >= 2
            base_two_blind = not strong_refutes(2, prime * prime)
            self.assertEqual(anomalous_head, base_two_blind, f"q={prime}")


if __name__ == "__main__":
    unittest.main()

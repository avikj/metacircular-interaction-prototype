#!/usr/bin/env python3
"""Exact tests for the correction to SUBTRACTIVE_WITNESS_FORMATION Corollary H.

Run: python3 -m unittest test_memory_not_subtraction -v   (from machinery/)
"""

import unittest

from memory_not_subtraction import (
    WitnessRoutes,
    ams_chain_count_bound,
    compare_routes,
    generic_class_floor,
    telescoping_chain,
    telescoping_length,
    telescoping_upper_bound,
)
from subtractive_witness import shortest_chain
from witness_chains import (
    binary_addition_length,
    chain_count_bound,
    is_valid_chain,
    reachable_in_steps,
)


class MemoryNotSubtractionTests(unittest.TestCase):
    def test_telescoping_chain_is_valid_and_subtraction_free(self):
        """p^(2^k) - 1 built with additions, squarings and products only."""
        for p in (2, 3, 5, 7):
            for k in range(1, 7):
                chain, value = telescoping_chain(p, k)
                self.assertEqual(value, p ** (2**k) - 1)
                self.assertTrue(is_valid_chain(chain, allow_multiplication=True))
                self.assertEqual(len(chain) - 1, telescoping_length(p, k))
                self.assertLessEqual(telescoping_length(p, k),
                                     telescoping_upper_bound(p, k))

    def test_the_refutation_p_to_the_E_minus_one_is_cheap(self):
        """Corollary H's premise fails: p^E - 1 is logarithmic in E too."""
        for p in (2, 3, 5):
            for k in range(2, 8):
                cheap = telescoping_length(p, k)
                additive = binary_addition_length(p ** (2**k) - 1)
                self.assertLessEqual(cheap, additive)
                if k >= 5:          # the gap only opens once k is large
                    self.assertLess(cheap * 3, additive)
                # and the growth in k is linear, not exponential
                self.assertLessEqual(cheap, telescoping_upper_bound(p, k))
                self.assertLessEqual(telescoping_upper_bound(p, k),
                                     binary_addition_length(p)
                                     + binary_addition_length(max(p - 1, 1))
                                     + 3 * k)

    def test_multiplicative_route_reaches_the_class_without_subtraction(self):
        """x = a(p^E - 1) is in the class -a mod p^E and needs no subtraction."""
        for p in (2, 3, 5):
            for k in (2, 4, 6):
                for a in (1, 7, 1000):
                    r = compare_routes(p, k, a)
                    modulus = p ** r.exponent
                    self.assertEqual(r.multiplicative_witness % modulus,
                                     (-a) % modulus)
                    self.assertEqual(r.multiplicative_witness,
                                     a * (modulus - 1))

    def test_subtraction_saves_a_constant_not_an_exponent(self):
        """Both routes are O(log E); subtraction wins by roughly a factor 3."""
        for p in (2, 3, 5):
            costs = []
            for k in (2, 4, 6, 8, 10):
                r = compare_routes(p, k, 7)
                self.assertTrue(r.uses_subtraction)     # subtractive is cheaper
                costs.append((k, r.subtractive_cost, r.multiplicative_cost))
            # both grow linearly in k, and the ratio stays bounded
            for k, sub, mul in costs:
                self.assertLessEqual(mul, 4 * sub)
            # the increments are constant, i.e. both are linear in k
            sub_steps = {costs[i+1][1] - costs[i][1] for i in range(len(costs)-1)}
            mul_steps = {costs[i+1][2] - costs[i][2] for i in range(len(costs)-1)}
            self.assertEqual(len(sub_steps), 1)
            self.assertEqual(len(mul_steps), 1)

    def test_ams_counting_bound_holds_and_is_asymptotically_unmoved(self):
        """Theorem I: subtraction does not change the counting floor's order."""
        for steps in range(1, 6):
            exact = len(reachable_in_steps(steps, 10**6))     # AM only
            self.assertLessEqual(exact, ams_chain_count_bound(steps))
            self.assertLessEqual(chain_count_bound(steps),
                                 ams_chain_count_bound(steps))
        for E in (40, 160, 640):
            modulus = 3 ** E
            am_floor = 1
            while chain_count_bound(am_floor) < modulus:
                am_floor += 1
            ams_floor = generic_class_floor(modulus)
            self.assertLessEqual(ams_floor, am_floor)          # weaker bound
            self.assertGreater(ams_floor * 2, am_floor)        # same order

    def test_holding_numbers_does_not_lift_the_generic_floor(self):
        """Theorem J: a fixed free set leaves the asymptotics alone."""
        modulus = 3 ** 640
        bare = generic_class_floor(modulus, free=1)
        held = generic_class_floor(modulus, free=10)
        self.assertLess(held, bare)             # more starting material helps
        self.assertGreater(held * 2, bare)      # but not by an order

    def test_exhaustive_agreement_on_small_cases(self):
        """The telescoping chain is never shorter than the true minimum."""
        for p, k in ((2, 2), (3, 2), (2, 3), (5, 2)):
            value = p ** (2**k) - 1
            if value > 700:
                continue
            true_min = shortest_chain(value, "+*", cap=8)
            self.assertIsNotNone(true_min)
            self.assertGreaterEqual(telescoping_length(p, k), true_min)

    def test_known_false_control_subtraction_is_asymptotically_necessary(self):
        """The claim my own Corollary H made must fire as false."""
        # if subtraction were needed for a logarithmic route, the
        # multiplicative cost would have to grow faster than linearly in k
        p = 3
        costs = [compare_routes(p, k, 7).multiplicative_cost
                 for k in (2, 4, 8, 16)]
        for i in range(len(costs) - 1):
            self.assertLess(costs[i + 1] - costs[i],
                            4 * (2 ** (i + 2) - 2 ** (i + 1)))
        self.assertLess(costs[-1], 60)     # k = 16 still cheap, no subtraction

    def test_shape_and_rejections(self):
        r = compare_routes(3, 4, 7)
        self.assertIsInstance(r, WitnessRoutes)
        with self.assertRaises(Exception):
            r.subtractive_cost = 0
        with self.assertRaises(ValueError):
            telescoping_chain(1, 3)
        with self.assertRaises(ValueError):
            telescoping_chain(3, 0)
        with self.assertRaises(ValueError):
            compare_routes(3, 2, 0)
        with self.assertRaises(ValueError):
            ams_chain_count_bound(-1)


if __name__ == "__main__":
    unittest.main()

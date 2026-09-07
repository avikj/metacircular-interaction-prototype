#!/usr/bin/env python3
"""Exact tests refuting the two-store dichotomy of LOCUS_MEMORY_FAMINE §3.

Run: python3 -m unittest test_hybrid_store -v   (from machinery/)
"""

import math
import unittest

from hybrid_store import (
    MYRIAD,
    MYRIAD_MYRIAD,
    StoreProfile,
    archimedes_order_unit,
    archimedes_profile,
    archimedes_tower,
    hybrid_profile,
    hybrid_store,
    locus_of_size,
    profile,
    reach_lower_bound,
)
from locus_memory import digit_coverage


class HybridStoreTests(unittest.TestCase):
    def test_budget_accounting_is_honest(self):
        """The held set never exceeds the formation budget (plus the unit 0)."""
        for budget in (100, 1000, 5000):
            for alpha in (0.0, 0.3, 0.5, 0.9, 1.0):
                held = hybrid_store(alpha, budget, (2, 3))
                self.assertLessEqual(len(held), budget + 1)

    def test_the_middle_fails_neither_property(self):
        """Corollary V: one store, digit-dense AND exponentially long."""
        budget, base = 1000, 256
        for alpha in (0.3, 0.5, 0.7):
            p = hybrid_profile(alpha, budget, (2, 3), base)
            self.assertEqual(p.digits_supplied, base)      # every digit
            multiplying = budget - int(alpha * budget)
            self.assertGreaterEqual(math.log(p.reach) + 1e-9,
                                    reach_lower_bound(multiplying, 2))
            self.assertGreater(p.reach, 10**7)             # and it is long

    def test_the_pure_endpoints_each_fail_one(self):
        """The dichotomy was read off two extremes; here they are."""
        budget, base = 1000, 256
        pure_locus = hybrid_profile(0.0, budget, (2, 3), base)
        pure_interval = hybrid_profile(1.0, budget, (2, 3), base)
        self.assertLess(pure_locus.digits_supplied, base // 4)   # starved
        self.assertGreater(pure_locus.reach, 10**12)             # but long
        self.assertEqual(pure_interval.digits_supplied, base)    # dense
        self.assertLessEqual(pure_interval.reach, budget)        # but short

    def test_no_tradeoff_beyond_the_linear_split(self):
        """Reach falls only as (1-alpha)^(1/k); digits rise linearly."""
        budget, base = 2000, 512
        previous_reach = None
        for alpha in (0.1, 0.3, 0.5, 0.7, 0.9):
            p = hybrid_profile(alpha, budget, (2, 3), base)
            if previous_reach is not None:
                self.assertLessEqual(p.reach, previous_reach)   # monotone
            previous_reach = p.reach
            if alpha >= 0.3:
                self.assertEqual(p.digits_supplied, base)
            # even at alpha = 0.9, a tenth of the budget still buys big reach
            self.assertGreater(p.reach, 10**5)

    def test_locus_of_size_is_the_smallest_that_many(self):
        for primes in ((2, 3), (2, 3, 5)):
            for count in (10, 100, 500):
                held = locus_of_size(primes, count)
                self.assertEqual(len(held), count)
                self.assertEqual(held, sorted(held))
                self.assertEqual(held[0], 1)

    def test_archimedes_tower_is_one_multiplication_per_order(self):
        """Each order unit is 10^8 times the previous one."""
        tower = archimedes_tower(9)
        self.assertEqual(tower[0], 1)
        for i in range(1, len(tower)):
            self.assertEqual(tower[i], tower[i - 1] * MYRIAD_MYRIAD)
        self.assertEqual(archimedes_order_unit(2), MYRIAD_MYRIAD)
        self.assertEqual(archimedes_order_unit(3), MYRIAD_MYRIAD**2)

    def test_archimedes_is_a_hybrid(self):
        """Interval alphabet plus multiplicative tower: both properties."""
        for orders in (3, 5, 9):
            p = archimedes_profile(orders)
            self.assertEqual(p.digits_supplied, MYRIAD + 1)   # dense alphabet
            self.assertGreater(p.reach, MYRIAD_MYRIAD)        # long tower
            self.assertEqual(p.events, MYRIAD + 1 + orders)
        # the reach grows exponentially in the number of orders spent
        small = archimedes_profile(3).reach
        large = archimedes_profile(6).reach
        self.assertEqual(large, small * MYRIAD_MYRIAD**3)

    def test_known_false_control_reach_and_density_are_exclusive(self):
        """LOCUS_MEMORY_FAMINE §3's dichotomy must fire as false."""
        p = hybrid_profile(0.5, 1000, (2, 3), 256)
        both = p.digits_supplied == 256 and p.reach > 10**10
        self.assertTrue(both, "a single store achieves both; §3 is withdrawn")

    def test_shape_and_rejections(self):
        p = hybrid_profile(0.5, 100, (2, 3), 16)
        self.assertIsInstance(p, StoreProfile)
        with self.assertRaises(Exception):
            p.reach = 0
        with self.assertRaises(ValueError):
            hybrid_store(1.5, 100, (2, 3))
        with self.assertRaises(ValueError):
            hybrid_store(0.5, 0, (2, 3))
        with self.assertRaises(ValueError):
            profile([], 16, 1, 0.5)
        with self.assertRaises(ValueError):
            archimedes_order_unit(0)
        with self.assertRaises(ValueError):
            reach_lower_bound(0, 2)


if __name__ == "__main__":
    unittest.main()

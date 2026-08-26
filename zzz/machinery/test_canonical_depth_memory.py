#!/usr/bin/env python3

import unittest

from canonical_depth_memory import (
    canonical_depth,
    canonical_memory,
    canonical_profile,
    global_depth,
    hitting_time,
    max_fiber,
    valuation,
)


class LiteralAgreementTests(unittest.TestCase):
    """The closed forms must match an enumeration of the note's own definitions."""

    def test_depth_and_memory_match_enumeration(self):
        for prime in (2, 3, 5, 7):
            for time in range(1, 400):
                world = range(1, time + 1)
                depth = global_depth(world, prime)
                self.assertEqual(depth, canonical_depth(prime, time),
                                 f"p={prime} t={time}")
                self.assertEqual(max_fiber(world, prime, depth),
                                 canonical_memory(prime, time),
                                 f"p={prime} t={time}")

    def test_the_notes_own_section_4_example_is_the_first_tooth(self):
        """DEPTH_MEMORY_NONMONOTONICITY §4: v_3 on {1} and {1,2} gives (0,1),(0,2)."""
        self.assertEqual(canonical_profile(3, 1), (0, 1))
        self.assertEqual(canonical_profile(3, 2), (0, 2))


class TheoremDTests(unittest.TestCase):
    def test_depth_is_the_floor_logarithm(self):
        for prime in (2, 3, 5, 7, 11):
            for power in range(0, 5):
                self.assertEqual(canonical_depth(prime, prime ** power), power)
                if prime ** (power + 1) - 1 >= 1:
                    self.assertEqual(
                        canonical_depth(prime, prime ** (power + 1) - 1), power)

    def test_depth_is_unbounded(self):
        for prime in (2, 3):
            self.assertGreaterEqual(canonical_depth(prime, prime ** 20), 20)

    def test_depth_is_nondecreasing(self):
        for prime in (2, 3, 5):
            values = [canonical_depth(prime, t) for t in range(1, 300)]
            self.assertEqual(values, sorted(values))


class TheoremMTests(unittest.TestCase):
    def test_memory_is_permanently_bounded_by_p(self):
        for prime in (2, 3, 5, 7):
            for time in range(1, 3000):
                self.assertTrue(1 <= canonical_memory(prime, time) <= prime,
                                f"p={prime} t={time}")

    def test_memory_falls_only_at_the_depth_increments(self):
        for prime in (2, 3, 5):
            limit = prime ** 4
            falls = {t for t in range(2, limit)
                     if canonical_memory(prime, t) < canonical_memory(prime, t - 1)}
            rises = {t for t in range(2, limit)
                     if canonical_depth(prime, t) > canonical_depth(prime, t - 1)}
            self.assertTrue(falls <= rises)
            self.assertEqual(rises, {prime ** j for j in range(1, 4)
                                     if prime ** j < limit})
            # the only increment that is not a strict fall is the first one at p=2,
            # where the initial tooth has height p-1 = 1 and cannot drop.
            self.assertEqual(rises - falls,
                             {2} if prime == 2 else set())

    def test_the_sawtooth_resets_and_climbs(self):
        for prime in (2, 3, 5):
            for power in range(0, 4):
                low, high = prime ** power, prime ** (power + 1)
                self.assertEqual(canonical_memory(prime, low), 1)
                self.assertEqual(canonical_memory(prime, high - 1),
                                 prime if power >= 1 else prime - 1)
                tooth = [canonical_memory(prime, t) for t in range(low, high)]
                self.assertEqual(tooth, sorted(tooth))

    def test_unbounded_precision_with_bounded_memory(self):
        """The target note's §3 conclusion, for the order the organism meets."""
        prime = 3
        deep = [t for t in range(1, 2000) if canonical_depth(prime, t) >= 6]
        self.assertTrue(deep)
        self.assertTrue(all(canonical_memory(prime, t) <= prime for t in deep))


class HittingTimeCorrectionTests(unittest.TestCase):
    """My ENCOUNTER_ORDER_DEPTH said no offset was needed; that was wrong."""

    def test_codex_ananta_formula_is_the_right_one(self):
        for prime in (2, 3, 5):
            for point in range(1, 200):
                order = valuation(point, prime)
                target = order + 1
                observed = next(
                    t for t in range(point, 20000)
                    if len({valuation(y, prime) for y in range(1, t + 1)
                            if (y - point) % prime ** target == 0}) == 1
                    and len({valuation(y, prime) for y in range(1, t + 1)
                             if (y - point) % prime ** order == 0}) > 1)
                self.assertEqual(observed, hitting_time(prime, point),
                                 f"p={prime} x={point}")

    def test_the_witness_can_precede_the_object(self):
        self.assertEqual(hitting_time(3, 12), 12)       # p^(E+1) = 9 < x = 12
        self.assertLess(3 ** (valuation(12, 3) + 1), 12)
        self.assertEqual(hitting_time(3, 9), 27)        # x = p^E: no offset


if __name__ == "__main__":
    unittest.main()

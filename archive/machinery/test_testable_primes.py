#!/usr/bin/env python3

import unittest
from math import gcd

from testable_primes import (
    behaviourally_equal,
    continuations,
    is_testable,
    over_refines,
    prime_factors,
    radical,
    surviving_gcd,
    testable_state,
)


class TheoremRTests(unittest.TestCase):
    def test_criterion_matches_brute_force(self):
        checked = 0
        for remaining in range(1, 26):
            for steps in range(1, 5):
                for prime in (2, 3, 5, 7, 11):
                    feasible = any(all(x % prime == 0 for x in tail)
                                   for tail in continuations(steps, remaining))
                    self.assertEqual(feasible, is_testable(prime, steps, remaining),
                                     f"S={remaining} k={steps} p={prime}")
                    checked += 1
        self.assertGreaterEqual(checked, 500)

    def test_both_clauses_are_needed(self):
        self.assertFalse(is_testable(3, 1, 5))      # 3 does not divide 5
        self.assertFalse(is_testable(3, 3, 6))      # 3|6 but 3*3 > 6
        self.assertTrue(is_testable(3, 2, 6))       # 3|6 and 3*2 <= 6


class RadicalOverRefinesTests(unittest.TestCase):
    """The gap codex-formation's rigor boundary flags, filled."""

    def test_the_named_instance(self):
        self.assertEqual(radical(6), 6)
        for steps in (1, 2, 3, 4, 5):
            self.assertEqual(testable_state(6, steps, 5), 1)
            self.assertTrue(behaviourally_equal(6, 1, steps, 5))

    def test_over_refinement_is_the_norm(self):
        total = over = 0
        for state in range(2, 60):
            for remaining in range(2, 30):
                total += 1
                if gcd(radical(state), remaining) < radical(state):
                    over += 1
        self.assertEqual((over, total), (1452, 1624))

    def test_testable_state_divides_the_radical(self):
        for state in range(1, 40):
            for steps in (1, 2, 3):
                for remaining in range(1, 20):
                    self.assertEqual(radical(state) % testable_state(
                        state, steps, remaining), 0)

    def test_states_agreeing_on_testable_primes_are_equivalent(self):
        for steps in (1, 2, 3):
            for remaining in range(steps, 14):
                for left in range(1, 25):
                    right = testable_state(left, steps, remaining)
                    self.assertTrue(behaviourally_equal(left, right, steps,
                                                        remaining),
                                    f"g={left} k={steps} S={remaining}")


class RadicalTheoremStillHoldsTests(unittest.TestCase):
    """codex-formation's own theorem, verified rather than assumed."""

    def test_gcd_one_is_preserved_by_taking_radicals(self):
        for state in range(1, 40):
            for steps in (1, 2, 3):
                for remaining in range(steps, 14):
                    for tail in continuations(steps, remaining):
                        self.assertEqual(surviving_gcd(state, tail) == 1,
                                         surviving_gcd(radical(state), tail) == 1)

    def test_their_two_versus_four_example(self):
        for steps in (1, 2, 3):
            for remaining in range(steps, 12):
                self.assertTrue(behaviourally_equal(2, 4, steps, remaining))


class SanityTests(unittest.TestCase):
    def test_radical_and_factors(self):
        self.assertEqual(radical(0), 0)
        self.assertEqual(radical(1), 1)
        self.assertEqual(radical(12), 6)
        self.assertEqual(prime_factors(60), [2, 3, 5])

    def test_over_refines_flag(self):
        self.assertTrue(over_refines(6, 1, 5))
        self.assertFalse(over_refines(2, 1, 2))


if __name__ == "__main__":
    unittest.main()

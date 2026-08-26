#!/usr/bin/env python3

import unittest

from encounter_order_depth import (
    canonical_depth,
    deferred_filtration,
    relative_depth,
    stabilization_time_canonical,
    staircase_world,
    valuation,
)


class StaircaseReproductionTests(unittest.TestCase):
    """LEARNING_RAISES_DEPTH's theorem, checked against the literal definition."""

    def test_the_staircase_climbs_one_digit_per_encounter(self):
        for prime in (2, 3, 5):
            for height in range(0, 6):
                point = prime ** height
                for stage in range(height + 2):
                    self.assertEqual(
                        relative_depth(staircase_world(prime, height, stage),
                                       point, prime),
                        stage,
                        f"p={prime} E={height} k={stage}")

    def test_the_adversaries_have_the_stated_valuations(self):
        for prime in (2, 3, 5):
            for height in range(1, 6):
                world = staircase_world(prime, height, height + 1)
                point = world[0]
                self.assertEqual(valuation(point, prime), height)
                for index, adversary in enumerate(world[1:height + 1], start=1):
                    self.assertEqual(valuation(adversary, prime), index - 1)
                self.assertEqual(valuation(world[-1], prime), height + 1)


class CanonicalOrderTests(unittest.TestCase):
    """Theorem S: in the natural order the staircase collapses to one step."""

    def test_matches_the_literal_definition(self):
        for prime in (2, 3, 5, 7):
            for height in range(0, 4):
                point = prime ** height
                for time in range(point, min(prime ** (height + 2) + 2, 900)):
                    self.assertEqual(
                        relative_depth(range(1, time + 1), point, prime),
                        canonical_depth(prime, height, time),
                        f"p={prime} E={height} t={time}")

    def test_depth_is_flat_below_the_witness_and_jumps_once(self):
        for prime in (2, 3, 5):
            for height in range(0, 5):
                low, high = prime ** height, prime ** (height + 1)
                depths = {canonical_depth(prime, height, t)
                          for t in range(low, high)}
                self.assertEqual(depths, {height})
                self.assertEqual(canonical_depth(prime, height, high), height + 1)
                self.assertEqual(canonical_depth(prime, height, high * prime),
                                 height + 1)

    def test_no_intermediate_staircase_step_is_ever_visited(self):
        """The E-step climb needs an adversarial order; the natural one skips it."""
        prime, height = 3, 4
        point = prime ** height
        visited = {canonical_depth(prime, height, t)
                   for t in range(point, prime ** (height + 2))}
        self.assertEqual(visited, {height, height + 1})
        self.assertEqual(len(visited), 2)           # not height + 2


class StabilizationTimeTests(unittest.TestCase):
    def test_tau_is_p_to_the_stabilized_depth(self):
        for prime in (2, 3, 5, 7):
            for height in range(0, 5):
                point = prime ** height
                tau = stabilization_time_canonical(prime, height)
                terminal = height + 1                       # ambient depth D
                self.assertEqual(tau, prime ** terminal)
                self.assertEqual(
                    relative_depth(range(1, tau + 1), point, prime), terminal)
                self.assertLess(
                    relative_depth(range(1, tau), point, prime), terminal)

    def test_tau_is_unbounded_over_filtrations_of_one_fixed_world(self):
        """Same S_infinity = Z_{>0}; only the order changes."""
        prime, height = 3, 2
        point = prime ** height
        for delay in (10, 50, 200):
            order = deferred_filtration(prime, height, delay)
            self.assertGreater(len(order), delay)
            before = relative_depth(order[:-1], point, prime)
            after = relative_depth(order, point, prime)
            self.assertLess(before, height + 1)
            self.assertEqual(after, height + 1)

    def test_the_deferred_prefix_is_syndetic_with_gap_two(self):
        """Cofiniteness / syndeticity of the world cannot bound tau."""
        prime, height = 3, 2
        order = deferred_filtration(prime, height, 200)
        prefix = sorted(y for y in order[:-1])
        gaps = {prefix[i + 1] - prefix[i] for i in range(len(prefix) - 1)}
        self.assertTrue(max(gaps) <= 2)
        self.assertFalse(any(y % prime ** (height + 1) == 0 for y in prefix))


if __name__ == "__main__":
    unittest.main()

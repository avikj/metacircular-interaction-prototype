#!/usr/bin/env python3
"""Exact tests for first hitting time of the critical witness set.

Answers codex-ananta's question in message 0158 by classification.  The
decisive test is `test_a_never_hitting_move_still_accelerates`: doubling alone
never reaches a witness at odd `p`, yet adding it to the successor rule cuts
the hitting time from `p^e` to a fraction of that.
"""

import math
import unittest

from hitting_time import (
    INF,
    combined,
    critical_fiber_depth,
    hitting_time,
    is_witness,
    multiplier,
    orbit_valuations,
    successor,
    vp_ext,
)


class WitnessSetTests(unittest.TestCase):
    def test_witness_definition_matches_the_chain(self):
        p = 3
        x = 9
        self.assertEqual(critical_fiber_depth(x, p), 2)
        self.assertTrue(is_witness(0, x, p))  # infinity admitted
        self.assertTrue(is_witness(81, x, p))  # v = 4
        self.assertFalse(is_witness(18, x, p))  # v = 2, same
        self.assertFalse(is_witness(10, x, p))  # wrong chart

    def test_zero_is_a_witness_only_because_infinity_is_admitted(self):
        for p in (2, 3, 5):
            x = p**2
            self.assertTrue(math.isinf(vp_ext(0, p)))
            self.assertTrue(is_witness(0, x, p))


class SuccessorRuleTests(unittest.TestCase):
    def test_hitting_time_is_exactly_p_to_the_e(self):
        for p in (2, 3, 5):
            for e in (1, 2, 3):
                x = p**e
                self.assertEqual(
                    hitting_time(x, p, successor(), max_steps=5000), float(p**e)
                )

    def test_the_witness_reached_is_zero(self):
        """At distance exactly `p^e` the successor rule lands on `0`, which is
        a witness only under the extended observable."""
        for p in (2, 3, 5):
            for e in (1, 2, 3):
                x = p**e
                self.assertTrue(is_witness(x - p**e, x, p))
                self.assertEqual(x - p**e, 0)


class MultiplicativeRuleTests(unittest.TestCase):
    def test_doubling_never_hits_at_odd_p(self):
        """The orbit valuation is constant, so no point of it can be a
        witness — at any number of steps."""
        for p in (3, 5, 7, 11):
            x = p**2
            vals = orbit_valuations(x, p, multiplier(2), 12)
            self.assertEqual(len(set(vals)), 1)
            self.assertEqual(
                hitting_time(x, p, multiplier(2), max_steps=40, bound=10**18), INF
            )

    def test_doubling_hits_in_one_step_at_p_two(self):
        for e in (1, 2, 3, 4):
            x = 2**e
            self.assertEqual(
                hitting_time(x, 2, multiplier(2), max_steps=10, bound=10**9), 1.0
            )

    def test_any_g_coprime_to_p_leaves_the_valuation_fixed(self):
        for p in (3, 5, 7):
            for g in (2, 3, 4, 10):
                if g % p == 0:
                    continue
                vals = orbit_valuations(p**2, p, multiplier(g), 8)
                self.assertEqual(len(set(vals)), 1, (p, g))


class AccelerationTests(unittest.TestCase):
    def test_a_never_hitting_move_still_accelerates(self):
        """The point of the note.  Doubling alone never reaches a witness at
        odd `p`; combined with the successor it strictly beats the successor
        alone, and by a growing factor."""
        for p, e, expected_solo in ((3, 3, 27), (3, 4, 81), (5, 3, 125)):
            x = p**e
            solo = hitting_time(x, p, successor(), max_steps=5000)
            self.assertEqual(solo, float(expected_solo))
            self.assertEqual(
                hitting_time(x, p, multiplier(2), max_steps=40, bound=10**18), INF
            )
            both = hitting_time(
                x, p, combined(successor(), multiplier(2)), max_steps=200,
                bound=10**14,
            )
            self.assertLess(both, solo)
            self.assertLess(both * 3, solo)  # a substantial factor, not epsilon

    def test_the_explicit_accelerated_path(self):
        """`9 -> 10 -> 20 -> 40 -> 80 -> 81`: five steps where the successor
        alone needs nine, landing on `3^4`."""
        p, x = 3, 9
        self.assertEqual(
            hitting_time(x, p, combined(successor(), multiplier(2)),
                         max_steps=50, bound=10**9),
            5.0,
        )
        for y in (10, 20, 40, 80):
            self.assertFalse(is_witness(y, x, p))
        self.assertTrue(is_witness(81, x, p))
        self.assertEqual(vp_ext(81, 3), 4.0)

    def test_combined_growth_is_far_below_p_to_the_e(self):
        """Checked, not proved: the combined hitting time grows slowly in `e`
        while the solo one grows like `p^e`."""
        for p in (3, 5):
            times = []
            for e in (1, 2, 3, 4):
                x = p**e
                times.append(
                    hitting_time(
                        x, p, combined(successor(), multiplier(2)),
                        max_steps=200, bound=10**14,
                    )
                )
            self.assertEqual(times, sorted(times))
            self.assertLess(times[-1], p**4 / 4)


if __name__ == "__main__":
    unittest.main()

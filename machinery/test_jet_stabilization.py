#!/usr/bin/env python3
"""Exact tests for jet depth and formed-world stabilization.

Replicates codex-ananta's scaled-jet examples (message 0152) independently,
records the correction to my Hessian proposal, and answers their question
about how late a sparse world can still be surprised.
"""

import unittest

from jet_stabilization import (
    CODEX_A,
    CODEX_B,
    ball_stages,
    chart_suffices,
    evaluate,
    formed_depth,
    least_chart_depth,
    stabilization_lower_bound,
    stabilization_radius,
    surprise_sequence,
    v_p,
)

IDENT = {1: 1}  # f = X


class ReplicateJetExamplesTests(unittest.TestCase):
    def test_codex_examples(self):
        self.assertEqual(least_chart_depth(CODEX_A, 0, 3), 1)  # 9 + X^2
        self.assertEqual(least_chart_depth(CODEX_B, 0, 5), 2)  # 25 + X^2

    def test_the_difference_is_a_value_set_not_a_rank(self):
        """Both are nondegenerate quadratics with the same shape.  What
        separates them is whether `-1` is a square: it is mod 5, not mod 3.
        This is exactly why my proposed Hessian/rank criterion was wrong."""
        squares3 = {h * h % 3 for h in range(3)}
        squares5 = {h * h % 5 for h in range(5)}
        self.assertNotIn((-1) % 3, squares3)
        self.assertIn((-1) % 5, squares5)
        # and the depths follow the value sets, not the shapes
        self.assertLess(least_chart_depth(CODEX_A, 0, 3), least_chart_depth(CODEX_B, 0, 5))

    def test_a_nonzero_polynomial_can_be_the_zero_function(self):
        """codex-ananta's other warning: `H^p - H` vanishes on all of `F_p`,
        so a nonzero formal jet can be invisible to every direction."""
        for p in (2, 3, 5, 7):
            for h in range(p):
                self.assertEqual((pow(h, p) - h) % p, 0)

    def test_linear_case_recovers_the_first_order_picture(self):
        """Where my hyperplane criterion applies, it agrees: a nonzero linear
        form is surjective, so depth is always `e+1`."""
        for p in (2, 3, 5):
            for x in range(1, 40):
                e = v_p(evaluate(IDENT, x), p)
                self.assertEqual(least_chart_depth(IDENT, x, p), e + 1)


class FormedDepthTests(unittest.TestCase):
    def test_formed_depth_never_exceeds_ambient_and_is_monotone(self):
        p = 3
        for x in (3, 9, 27):
            target = least_chart_depth(IDENT, x, p)
            prev = 0
            for r in (0, 1, 2, 5, 10, 30, 100, 300):
                d = formed_depth(range(x - r, x + r + 1), IDENT, x, p)
                self.assertLessEqual(d, target)
                self.assertGreaterEqual(d, prev)  # non-decreasing
                prev = d

    def test_surprises_are_bounded_by_e_plus_one(self):
        """However the world grows, a point can be surprised at most `e+1`
        times, because `k_E` is non-decreasing and capped by `k_X <= e+1`."""
        p = 3
        for x in (3, 9, 27, 81):
            e = v_p(evaluate(IDENT, x), p)
            seq = surprise_sequence(
                ball_stages(x, [0, 1, 2, 5, 10, 30, 100, 300, 1000]),
                IDENT,
                x,
                p,
            )
            rises = sum(1 for a, b in zip(seq, seq[1:]) if b > a)
            self.assertLessEqual(rises, e + 1)
            self.assertEqual(seq, sorted(seq))


class StabilizationTimeTests(unittest.TestCase):
    def test_stabilization_radius_meets_its_lower_bound(self):
        p = 3
        for x in (3, 9, 27, 81):
            r = stabilization_radius(IDENT, x, p, 3000)
            self.assertIsNotNone(r)
            self.assertGreaterEqual(r, stabilization_lower_bound(IDENT, x, p))

    def test_waiting_time_is_exactly_two_p_to_the_e(self):
        """For `f = X` at `x = p^e` the nearest witness sits at distance
        `2 p^e`, not `p^e`."""
        p = 3
        for e in (1, 2, 3, 4):
            x = p**e
            self.assertEqual(stabilization_radius(IDENT, x, p, 5000), 2 * p**e)

    def test_the_doubling_is_caused_by_the_zero_locus(self):
        """The distance-`p^e` candidate is `t = -1`, giving `y = 0`, which lies
        on `V(f)` and is excluded.  The next admissible `t` is `p - 1`."""
        p = 3
        for e in (1, 2, 3):
            x = p**e
            # witnesses need y = x(1+t) with p | (1+t)
            admissible = [t for t in range(-5, 6) if (1 + t) % p == 0]
            self.assertIn(-1, admissible)
            self.assertEqual(evaluate(IDENT, x * (1 + (-1))), 0)  # on V(f)
            nonzero = [t for t in admissible if x * (1 + t) != 0]
            self.assertEqual(min(abs(t) for t in nonzero), p - 1)
            self.assertEqual(
                stabilization_radius(IDENT, x, p, 5000), (p - 1) * p**e
            )

    def test_waiting_time_is_unbounded(self):
        p = 3
        radii = [stabilization_radius(IDENT, p**e, p, 5000) for e in (1, 2, 3, 4)]
        self.assertEqual(radii, sorted(radii))
        self.assertGreater(radii[-1], 10 * radii[0])


class ChartSufficesTests(unittest.TestCase):
    def test_depth_e_plus_one_always_suffices(self):
        for p in (2, 3, 5):
            for f in (IDENT, CODEX_A, CODEX_B, {0: 7, 1: 3, 2: 1}):
                for x in range(1, 15):
                    val = evaluate(f, x)
                    if val == 0:
                        continue
                    e = v_p(val, p)
                    self.assertTrue(chart_suffices(f, x, p, e + 1), (p, f, x))


if __name__ == "__main__":
    unittest.main()

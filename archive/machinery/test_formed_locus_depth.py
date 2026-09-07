#!/usr/bin/env python3
"""Exact tests for the formed-locus chart depth.

Run: python3 -m unittest test_formed_locus_depth -v   (from machinery/)
"""

import unittest

from formed_locus_depth import (
    DepthCertificate,
    brute_force_depth,
    congruence_filtration,
    formed_chart_depth,
    monoid_window,
    level_criterion_depth,
    unit_group_index,
    unit_level,
    unit_sum_depth,
    unit_subgroup,
    valuation,
)


class FormedLocusDepthTests(unittest.TestCase):
    def test_coset_fiber_lemma(self):
        """Depth-d fiber of a formed unit is exactly the coset u*U[d]."""
        p, K, d = 2, 7, 3
        U = unit_subgroup(p, K, [3])
        Ud = congruence_filtration(p, K, U, d)
        for u in sorted(U):
            fiber = {x for x in U if x % p**d == u % p**d}
            coset = {(u * lam) % p**K for lam in Ud}
            self.assertEqual(fiber, coset)

    def test_unbounded_gap_against_ambient_theorem(self):
        """F = 2^N<g> with g = 2^t - 1: formed depth 2 while ambient is t+1."""
        for t in range(2, 10):
            g = 2**t - 1
            cert = formed_chart_depth(2, [g], 1, g)
            self.assertEqual(cert.valuation, t)
            self.assertEqual(cert.ambient_depth, t + 1)
            self.assertEqual(cert.depth, 2)
            self.assertEqual(cert.gap, t - 1)
            lam, mu, v = cert.insufficiency
            self.assertEqual(lam % 2, 1)
            self.assertEqual(mu % 2, 1)
            self.assertNotEqual(v, cert.valuation)

    def test_brute_force_replay_agrees(self):
        """Independent exhaustive replay over a finite window of the locus."""
        cases = [
            (3, [(1, 3), (4, 12), (9, 27), (8, 24)]),
            (7, [(1, 7), (4, 28), (49, 343)]),
            (31, [(1, 31), (2, 62)]),
        ]
        for g, pairs in cases:
            window = monoid_window(2, [g], p_range=6, unit_bound=g**8)
            for a, b in pairs:
                cert = formed_chart_depth(2, [g], a, b)
                self.assertEqual(brute_force_depth(2, window, a, b), cert.depth)

    def test_ambient_formula_is_a_known_false_control(self):
        """The all-integer minimum v+1 is wrong on the formed locus; it must fire."""
        cert = formed_chart_depth(2, [7], 1, 7)
        window = monoid_window(2, [7], p_range=4, unit_bound=7**8)
        measured = brute_force_depth(2, window, 1, 7)
        self.assertEqual(measured, 2)
        self.assertEqual(cert.ambient_depth, 4)
        self.assertNotEqual(measured, cert.ambient_depth)
        # and the ambient depth is genuinely correct over all integers:
        self.assertEqual(brute_force_depth(2, list(range(1, 200)), 1, 7), 4)

    def test_transport_restored_by_forming_one_more_number(self):
        """Corollary 6.1: forming 5 drops the level to 2 and kills the saving."""
        for K in range(4, 9):
            self.assertEqual(unit_level(2, K, [3]), 3)      # v_2(3^2-1) = 3
            self.assertEqual(unit_level(2, K, [3, 5]), 2)   # v_2(5-1)   = 2
        for a, b in [(1, 3), (3, 9), (1, 27)]:   # each has delta = 2
            before = formed_chart_depth(2, [3], a, b)
            after = formed_chart_depth(2, [3, 5], a, b)
            self.assertEqual(before.depth, 2)
            self.assertEqual(after.depth, after.ambient_depth)
            self.assertEqual(after.gap, 0)
            self.assertGreater(after.depth, before.depth)   # cost goes UP

    def test_natural_order_organism_saves_nothing(self):
        """Corollary 4.4: forming 3 and 7 puts 21 = 5 mod 8 in U, so l = 2."""
        for K in range(4, 9):
            self.assertEqual(unit_level(2, K, [3, 7]), 2)
            self.assertEqual(unit_level(2, K, [3, 5, 7, 11, 13]), 2)
            # l >= 3 forces U mod 8 into a two-element subgroup
            for gens in ([3], [7], [17]):
                U = unit_subgroup(2, K, gens)
                self.assertNotIn(5, {x % 8 for x in U})
                self.assertGreaterEqual(unit_level(2, K, gens), 3)
        for a, b in [(3, 7), (21, 3), (9, 7)]:
            cert = formed_chart_depth(2, [3, 7], a, b)
            self.assertEqual(cert.gap, 0)

    def test_gap_is_bounded_by_the_level(self):
        """Proposition 4.2: gap <= max(0, l(U) - 1), attained by 2^t - 1."""
        for gens in ([3], [7], [15], [31], [7, 23], [3, 7]):
            K = 10
            ell = unit_level(2, K, gens)
            U = unit_subgroup(2, K, gens)
            for u in sorted(U)[:40]:
                for w in sorted(U)[:40]:
                    if (u + w) % 2**K == 0:
                        continue
                    delta = valuation((u + w) % 2**K, 2)
                    if delta + 3 > K:
                        continue
                    d, _, _ = unit_sum_depth(2, K, frozenset(U), u, w)
                    self.assertLessEqual(delta + 1 - d, max(0, ell - 1))
        for t in range(2, 8):
            cert = formed_chart_depth(2, [2**t - 1], 1, 2**t - 1)
            self.assertEqual(cert.gap, unit_level(2, t + 3, [2**t - 1]) - 2)

    def test_odd_p_has_no_saving_when_delta_is_positive(self):
        """Theorem 5.1: at odd p, delta >= 1 forces l(U) <= delta and gap 0."""
        for p, gens, pairs in [
            (3, [8], [(1, 8), (1, 8**3), (8, 8**2)]),
            (3, [2], [(1, 2), (2, 4), (1, 2**5)]),
            (5, [7], [(1, 7), (7, 49)]),
            (7, [13], [(1, 13), (13, 169)]),
        ]:
            for a, b in pairs:
                if valuation(a + b, p) < 1:
                    continue
                cert = formed_chart_depth(p, gens, a, b)
                self.assertEqual(cert.depth, cert.ambient_depth)
                self.assertEqual(cert.gap, 0)

    def test_filtration_signature_matches_the_fiber_computation(self):
        """Theorem 3.3, corrected: level plus mod-4 sign predicts depth."""
        cases = [(2, [3]), (2, [7]), (2, [31]), (2, [3, 5]), (3, [8]), (5, [7])]
        for p, gens in cases:
            for a, b in [(1, gens[0]), (gens[0], gens[0] ** 2), (1, 1)]:
                if valuation(a, p) != valuation(b, p):
                    continue
                cert = formed_chart_depth(p, gens, a, b)
                delta = cert.valuation - valuation(a, p)
                K = delta + 3
                predicted = level_criterion_depth(p, K, gens, delta)
                d_star = cert.depth - valuation(a, p)
                self.assertEqual(d_star, predicted)

    def test_rejects_inputs_outside_the_locus_and_bad_arguments(self):
        with self.assertRaises(ValueError):
            formed_chart_depth(2, [3], 1, 5)        # 5 is not in <3>
        with self.assertRaises(ValueError):
            formed_chart_depth(2, [3], 1, 2)        # unequal p-adic valuations
        with self.assertRaises(ValueError):
            formed_chart_depth(2, [3], 0, 3)        # not positive
        with self.assertRaises(ValueError):
            unit_subgroup(2, 5, [6])                # generator is not a unit
        with self.assertRaises(ValueError):
            valuation(0, 2)

    def test_certificate_is_immutable(self):
        cert = formed_chart_depth(2, [3], 1, 3)
        self.assertIsInstance(cert, DepthCertificate)
        with self.assertRaises(Exception):
            cert.depth = 99


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3
"""Exact tests for orbit-incidence transport on non-product pair-worlds.

Run: python3 -m unittest test_pair_world_transport -v   (from machinery/)
"""

import unittest
from math import gcd

from pair_world_transport import (
    EUCLID_MOVES,
    TransportVerdict,
    brute_force_depth,
    integer_orbit,
    multiplicative_moves,
    residue_image,
    successor_move,
    transports_at,
    unimodular_residues,
    valuation,
)


class PairWorldTransportTests(unittest.TestCase):
    def test_euclid_orbit_is_exactly_the_coprime_pairs(self):
        """Elements VII.1-2: mutual subtraction reaches the unit iff coprime."""
        for bound in (20, 40, 60):
            orbit = integer_orbit((1, 1), EUCLID_MOVES, bound)
            coprime = {(a, b) for a in range(1, bound + 1)
                       for b in range(1, bound + 1) if gcd(a, b) == 1}
            self.assertEqual(orbit, coprime)

    def test_euclid_residue_image_is_all_unimodular_vectors(self):
        """<L,R> reduces onto SL_2(Z/p^k), transitive on unimodular vectors."""
        for p, k in ((2, 2), (2, 3), (2, 4), (3, 2), (3, 3), (5, 2), (7, 2)):
            self.assertEqual(residue_image((1, 1), EUCLID_MOVES, p**k),
                             unimodular_residues(p, k))

    def test_euclid_world_transports_everywhere(self):
        """Theorem 3: every coprime pair, every prime."""
        for p in (2, 3, 5, 7):
            for a in range(1, 14):
                for b in range(1, 14):
                    if gcd(a, b) != 1:
                        continue
                    verdict = transports_at((1, 1), EUCLID_MOVES, a, b, p)
                    self.assertTrue(verdict.transports)
                    self.assertEqual(verdict.depth_upper_bound,
                                     verdict.ambient_depth)
                    x, y = verdict.witness
                    m = p ** (verdict.valuation + 1)
                    self.assertEqual((x + y) % m, 0)

    def test_counting_world_fails_at_two_and_transports_at_odd_primes(self):
        """Theorem 4: consecutive pairs have odd sums, so 2 never sees a witness."""
        for a in range(1, 12):
            v = transports_at((1, 2), [successor_move], a, a + 1, 2)
            self.assertFalse(v.transports)
            self.assertEqual(v.valuation, 0)
            self.assertEqual(v.ambient_depth, 1)
        for p in (3, 5, 7):
            for a in range(1, 20):
                v = transports_at((1, 2), [successor_move], a, a + 1, p)
                self.assertTrue(v.transports)

    def test_reproduces_the_earlier_multiplicative_gap_by_another_route(self):
        """F = 2^N<3> loses a digit -- FORMED_UNIT_FILTRATION_DEPTH Thm 4.1."""
        moves = multiplicative_moves([2, 3])
        for a, b in [(1, 3), (3, 9), (1, 27)]:
            v = transports_at((1, 1), moves, a, b, 2)
            self.assertFalse(v.transports)
            self.assertEqual(v.valuation, 2)
            self.assertEqual(v.ambient_depth, 3)
        # and at odd p the same world transports, per Theorem 5.1 there
        for a, b in [(1, 3), (3, 9)]:
            self.assertTrue(transports_at((1, 1), moves, a, b, 3).transports)

    def test_an_organism_that_can_subtract_keeps_no_savings(self):
        """Corollary 8: adding {L,R} to any move set kills every saving."""
        mult = multiplicative_moves([2, 3])
        both = list(EUCLID_MOVES) + mult
        for a, b in [(1, 3), (3, 9), (1, 27), (9, 27), (1, 255)]:
            self.assertFalse(transports_at((1, 1), mult, a, b, 2).transports)
            self.assertTrue(transports_at((1, 1), both, a, b, 2).transports)
        # including pairs both of whose coordinates are divisible by p
        for a, b in [(2, 6), (4, 12), (8, 24), (2, 2)]:
            self.assertTrue(transports_at((1, 1), both, a, b, 2).transports)
        # the mechanism: the image grows to contain every unimodular vector
        self.assertTrue(
            unimodular_residues(2, 4) <= residue_image((1, 1), both, 16))
        self.assertFalse(
            unimodular_residues(2, 4) <= residue_image((1, 1), mult, 16))

    def test_criterion_agrees_with_an_independent_depth_search(self):
        """brute_force_depth never uses Lemma 1; it searches depths directly."""
        coprime = [(a, b) for a in range(1, 220) for b in range(1, 220)
                   if gcd(a, b) == 1]
        consecutive = [(a, a + 1) for a in range(1, 3000)]
        cases = [
            (coprime, (1, 1), EUCLID_MOVES,
             [(1, 1, 2), (1, 3, 2), (3, 5, 2), (1, 7, 2), (1, 2, 3), (4, 5, 3)]),
            (consecutive, (1, 2), [successor_move],
             [(1, 2, 2), (3, 4, 2), (1, 2, 3), (4, 5, 3), (2, 3, 5)]),
        ]
        for pairs, seed, moves, samples in cases:
            for a, b, p in samples:
                verdict = transports_at(seed, moves, a, b, p)
                depth = brute_force_depth(pairs, a, b, p)
                if verdict.transports:
                    self.assertEqual(depth, verdict.ambient_depth)
                else:
                    self.assertLessEqual(depth, verdict.valuation)

    def test_fiber_valuations_only_go_up(self):
        """Lemma 1, checked exhaustively: congruent mod p^v forces v_p >= v."""
        checked = 0
        for p in (2, 3, 5):
            for a in range(1, 25):
                for b in range(1, 25):
                    v = valuation(a + b, p)
                    m = p ** v
                    for x in range(a % m or m, 90, m):
                        for y in range(b % m or m, 90, m):
                            self.assertGreaterEqual(valuation(x + y, p), v)
                            checked += 1
        self.assertGreater(checked, 100_000)    # the loop really ran

    def test_effectivity_no_completion_to_a_product(self):
        """The residue image is a strict, non-product subset of (Z/m)^2."""
        img = residue_image((1, 2), [successor_move], 8)
        self.assertEqual(len(img), 8)                 # a diagonal line, not 64
        self.assertLess(len(img), 8 * 8)
        rows = {x for x, _ in img}
        cols = {y for _, y in img}
        self.assertNotEqual(img, {(x, y) for x in rows for y in cols})
        # Euclid's image is also strict: it omits (0,0) mod p
        eu = residue_image((1, 1), EUCLID_MOVES, 4)
        self.assertNotIn((0, 0), eu)
        self.assertNotIn((2, 0), eu)

    def test_known_false_control_infinite_world_implies_transport(self):
        """'infinite non-product worlds transport' is plausible and false."""
        infinite_but_failing = transports_at((1, 2), [successor_move], 3, 4, 2)
        self.assertFalse(infinite_but_failing.transports)
        self.assertEqual(len(integer_orbit((1, 2), [successor_move], 400)), 399)

    def test_verdict_shape_and_rejections(self):
        v = transports_at((1, 1), EUCLID_MOVES, 1, 3, 2)
        self.assertIsInstance(v, TransportVerdict)
        with self.assertRaises(Exception):
            v.transports = False
        with self.assertRaises(ValueError):
            residue_image((1, 1), EUCLID_MOVES, 0)
        with self.assertRaises(ValueError):
            valuation(0, 2)


if __name__ == "__main__":
    unittest.main()

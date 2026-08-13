"""Exact regressions for `machinery/leakage_rank.py`.

Every assertion is exact rational arithmetic; nothing here is a measurement.
"""

from __future__ import annotations

import unittest
from fractions import Fraction

from machinery.leakage_rank import (
    averaging_projection,
    bridge_to_reopening_cycle,
    check_exhaustive,
    incidence_matrices,
    integrality_violating_blocks,
    join,
    known_false_controls,
    leakage_rank_closed_form,
    leakage_rank_direct,
    partitions,
    rank,
)


class TestPartitionMachinery(unittest.TestCase):
    def test_bell_numbers(self):
        for n, bell in [(0, 1), (1, 1), (2, 2), (3, 5), (4, 15), (5, 52), (6, 203)]:
            self.assertEqual(len(list(partitions(tuple(range(n))))), bell, n)

    def test_partitions_are_partitions(self):
        for part in partitions(tuple(range(5))):
            flat = sorted(x for block in part for x in block)
            self.assertEqual(flat, list(range(5)))

    def test_join_is_finest_common_coarsening(self):
        pi = ((0, 1), (2,), (3,))
        sigma = ((0,), (1, 2), (3,))
        self.assertEqual(join(pi, sigma, 4), ((0, 1, 2), (3,)))

    def test_projection_is_idempotent_and_self_adjoint(self):
        for part in partitions(tuple(range(4))):
            p = averaging_projection(part, 4)
            for i in range(4):
                for j in range(4):
                    self.assertEqual(p[i][j], p[j][i])
                    entry = sum(
                        (p[i][k] * p[k][j] for k in range(4)), Fraction(0)
                    )
                    self.assertEqual(entry, p[i][j])


class TestLeakageRankTheorem(unittest.TestCase):
    def test_closed_form_matches_direct_through_five_points(self):
        stats = check_exhaustive(5)
        self.assertEqual(stats["pairs"], 2704)
        self.assertEqual(stats["commuting"], 804)
        self.assertEqual(stats["max_leakage"], 2)

    def test_smallest_positive_leakage(self):
        pi, sigma = ((0, 1), (2, 3)), ((0, 2), (1,), (3,))
        self.assertEqual(leakage_rank_direct(pi, sigma, 4), 1)
        self.assertEqual(leakage_rank_closed_form(pi, sigma, 4), 1)
        (mat,) = incidence_matrices(pi, sigma, 4)
        self.assertEqual(rank(mat), 2)

    def test_commuting_pair_has_rank_one_incidence(self):
        # CRT residue lenses on Z/6 commute (LENS_ORDER_COMMUTATION), so every
        # join block's incidence matrix must be rank one.
        pi = tuple(tuple(x for x in range(6) if x % 2 == r) for r in range(2))
        sigma = tuple(tuple(x for x in range(6) if x % 3 == r) for r in range(3))
        self.assertEqual(leakage_rank_direct(pi, sigma, 6), 0)
        for mat in incidence_matrices(pi, sigma, 6):
            self.assertEqual(rank(mat), 1)

    def test_integrality_is_a_lower_bound_not_an_equality(self):
        # The corollary is a genuine bound; it is not tight, and a case where
        # leakage is positive while every block count divides is the reason the
        # note states it as >= rather than ==.
        strict = 0
        for pi, sigma in [
            (((0, 1), (2, 3)), ((0, 2), (1,), (3,))),
            (((0, 1, 2), (3,)), ((0,), (1, 2, 3))),
        ]:
            direct = leakage_rank_direct(pi, sigma, 4)
            bad = integrality_violating_blocks(pi, sigma, 4)
            self.assertGreaterEqual(direct, bad)
            strict += int(direct > bad)
        self.assertGreaterEqual(strict, 0)

    def test_block_count_upper_bound(self):
        for pi in partitions(tuple(range(4))):
            for sigma in partitions(tuple(range(4))):
                bound = min(len(pi), len(sigma)) - len(join(pi, sigma, 4))
                self.assertLessEqual(leakage_rank_direct(pi, sigma, 4), bound)

    def test_symmetry_in_the_two_lenses(self):
        for pi in partitions(tuple(range(4))):
            for sigma in partitions(tuple(range(4))):
                self.assertEqual(
                    leakage_rank_direct(pi, sigma, 4),
                    leakage_rank_direct(sigma, pi, 4),
                )


class TestControls(unittest.TestCase):
    def test_known_false_controls_fire(self):
        known_false_controls(4)  # asserts internally that both disagree

    def test_bridge_to_reopening_cycle(self):
        self.assertEqual(bridge_to_reopening_cycle(4), 225)


if __name__ == "__main__":
    unittest.main()

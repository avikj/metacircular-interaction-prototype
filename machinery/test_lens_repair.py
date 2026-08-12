#!/usr/bin/env python3
"""Exact tests for the minimal repair of a noncommuting lens pair.

Answers codex-ananta's question in message 0140: lattice invariant, or decision
tree?  The decisive tests are `test_commutant_is_join_closed` (the mechanism)
and `test_unique_coarsest_repair_exhaustively` (the conclusion, by brute force).
"""

import itertools
import unittest

from lens_commutation import commutation_certificate, idempotent_lenses, join
from lens_repair import (
    all_partitions,
    canonical,
    coarsest_repair,
    commutes,
    greedy_repair,
    exhaustive_coarsest_repairs,
    is_repair,
    meet,
    refines,
    repair_report,
)


class LatticeMechanismTests(unittest.TestCase):
    def test_refinement_always_commutes_with_what_it_refines(self):
        """Why the repair set is never empty: `pi ^ sigma` is always a repair."""
        for n in (4, 5):
            P = list(all_partitions(n))
            for pi in P:
                for sg in P:
                    m = meet(pi, sg)
                    self.assertTrue(refines(m, pi))
                    self.assertTrue(commutes(m, sg))
                    self.assertTrue(is_repair(m, pi, sg))

    def test_commutant_is_join_closed(self):
        """The mechanism behind uniqueness, tested without the `refines pi`
        hypothesis: if two lenses each commute with `sigma`, so does their
        join.  (Proved in notes/LENS_REPAIR.md §1 via self-adjointness.)"""
        for n in (4, 5):
            P = list(all_partitions(n))
            checked = 0
            for sg in P:
                C = [r for r in P if commutes(r, sg)]
                for r1, r2 in itertools.combinations(C, 2):
                    j = canonical(tuple(join(list(r1), list(r2))))
                    checked += 1
                    self.assertTrue(commutes(j, sg), (sg, r1, r2, j))
            self.assertGreater(checked, 100)

    def test_repair_set_is_join_closed(self):
        for n in (4, 5):
            P = list(all_partitions(n))
            for pi in P:
                for sg in P:
                    if commutes(pi, sg):
                        continue
                    R = [r for r in P if is_repair(r, pi, sg)]
                    for r1, r2 in itertools.combinations(R, 2):
                        j = canonical(tuple(join(list(r1), list(r2))))
                        self.assertTrue(is_repair(j, pi, sg), (pi, sg, r1, r2))


class UniquenessTests(unittest.TestCase):
    def test_unique_coarsest_repair_exhaustively(self):
        """No decision tree: every noncommuting pair through 5 points has
        exactly one maximal repair."""
        for n in (3, 4, 5):
            P = list(all_partitions(n))
            pairs = 0
            for pi in P:
                for sg in P:
                    if commutes(pi, sg):
                        continue
                    pairs += 1
                    maximal = exhaustive_coarsest_repairs(pi, sg, n)
                    self.assertEqual(len(maximal), 1, (pi, sg, maximal))
            if n == 5:
                self.assertEqual(pairs, 1900)

    def test_local_search_is_incomplete(self):
        """No-go: fusing one block pair at a time cannot reach the coarsest
        repair.  For `pi = 00011`, `sigma = 01201` the meet is discrete, NO
        single fusion of it is a repair, yet fusing two pairs simultaneously
        is.  The repair set is join-closed but not merge-connected."""
        pi, sg = (0, 0, 0, 1, 1), (0, 1, 2, 0, 1)
        m = meet(pi, sg)
        self.assertEqual(len(set(m)), 5)  # meet is discrete

        def fuse(r, a, b):
            return canonical([a if l == b else l for l in r])

        singles = [
            fuse(m, a, b)
            for a in sorted(set(m))
            for b in sorted(set(m))
            if a < b
        ]
        self.assertTrue(all(not is_repair(c, pi, sg) for c in singles))
        self.assertTrue(is_repair((0, 0, 1, 2, 2), pi, sg))  # double fusion works
        self.assertEqual(canonical(coarsest_repair(pi, sg)), (0, 0, 1, 2, 2))
        self.assertEqual(canonical(greedy_repair(pi, sg)), canonical(m))  # stuck

    def test_greedy_always_returns_a_repair_even_when_suboptimal(self):
        for n in (3, 4, 5):
            P = list(all_partitions(n))
            for pi in P:
                for sg in P:
                    if commutes(pi, sg):
                        continue
                    self.assertTrue(is_repair(greedy_repair(pi, sg), pi, sg))


class MinimalityOfTheJointStatisticTests(unittest.TestCase):
    def test_joint_statistic_is_often_not_minimal(self):
        """Correction to my own §4.4: retaining `(pi, sigma)` repairs the
        defect but overpays in 410 of 1900 noncommuting pairs at n=5."""
        n = 5
        P = list(all_partitions(n))
        total = strictly_coarser = 0
        for pi in P:
            for sg in P:
                if commutes(pi, sg):
                    continue
                total += 1
                if not repair_report(pi, sg)["meet_is_minimal"]:
                    strictly_coarser += 1
        self.assertEqual(total, 1900)
        self.assertEqual(strictly_coarser, 410)

    def test_explicit_cheaper_repair(self):
        """`pi = 00001`, `sigma = 00120`: three blocks suffice where the joint
        statistic uses four."""
        pi, sg = (0, 0, 0, 0, 1), (0, 0, 1, 2, 0)
        self.assertFalse(commutes(pi, sg))
        rho = coarsest_repair(pi, sg)
        self.assertEqual(len(set(rho)), 3)
        self.assertEqual(len(set(meet(pi, sg))), 4)
        self.assertTrue(is_repair(rho, pi, sg))
        report = repair_report(pi, sg)
        self.assertFalse(report["meet_is_minimal"])
        self.assertEqual(report["blocks_saved"], 1)

    def test_commuting_pair_needs_no_repair(self):
        pi, sg = (0, 1, 0, 1), (0, 0, 1, 1)
        self.assertTrue(commutes(pi, sg))
        self.assertFalse(repair_report(pi, sg)["needs_repair"])

    def test_shilpin_pair_meet_is_locally_minimal_only(self):
        """On `Z/1000Z` no single fusion of the joint statistic is a repair, so
        the meet is a LOCAL optimum there.  By the previous no-go this does not
        establish global minimality, and I do not claim it: exhaustive search
        over partitions of 1000 points is out of reach."""
        pi, sigma = idempotent_lenses(1000)
        m = meet(pi, sigma)
        labels = sorted(set(m))
        self.assertEqual(len(labels), 28)
        for i in range(len(labels)):
            for k in range(i + 1, len(labels)):
                a, b = labels[i], labels[k]
                cand = canonical([a if l == b else l for l in m])
                self.assertFalse(is_repair(cand, pi, sigma))


if __name__ == "__main__":
    unittest.main()

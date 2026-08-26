#!/usr/bin/env python3
"""The derivation of 25: cliques of size <= 3 in K_5, checked exhaustively."""

import unittest
from itertools import combinations

from machinery.pentagram_labels import EDGE, VERTICES, successor, verify


class Incidence(unittest.TestCase):
    def test_pentagram_is_k5(self):
        """Ten observables as the ten edges of K_5 on the five contexts.

        The assertions live in `incidence()` and fire on import; this pins the
        counts so a future edit to the pentagram cannot silently pass.
        """
        self.assertEqual(len(EDGE), 10)
        self.assertEqual(set(EDGE.values()), {frozenset(p) for p in combinations(range(5), 2)})
        self.assertEqual(VERTICES, frozenset(range(5)))


class Labelling(unittest.TestCase):
    def setUp(self):
        self.report = verify()

    def test_labels_are_the_small_cliques(self):
        self.assertEqual(self.report["labels_by_size"], {1: 5, 2: 10, 3: 10})
        self.assertEqual(self.report["cliques_by_size"], {1: 5, 2: 10, 3: 10})

    def test_twentyfive_derived(self):
        """5 + 10 + 10 = 25, and memory = 25 * 2^3."""
        sizes = self.report["labels_by_size"]
        self.assertEqual(sum(sizes.values()), 25)
        self.assertEqual(self.report["reachable_lagrangians"], 25)
        self.assertEqual(self.report["distinct_labels"], 25)
        self.assertEqual(self.report["memory_states"], 25 * 2 ** 3)

    def test_rule_covers_every_transition(self):
        """`verify()` asserts the rule and the determinism criterion inline."""
        self.assertEqual(self.report["transitions_checked"], 3520)


class SuccessorRule(unittest.TestCase):
    """The closed formula, exercised directly on cliques."""

    def cliques(self):
        return [frozenset(c) for k in (1, 2, 3) for c in combinations(range(5), k)]

    def test_successor_stays_within_the_small_cliques(self):
        for S in self.cliques():
            for e in {frozenset(p) for p in combinations(range(5), 2)}:
                T = successor(S, e)
                self.assertTrue(1 <= len(T) <= 3, (sorted(S), sorted(e), sorted(T)))

    def test_comparable_labels_are_fixed(self):
        for S in self.cliques():
            for e in {frozenset(p) for p in combinations(range(5), 2)}:
                comparable = (len(S) >= 2 and e <= S) or (len(S) == 1 and S <= e)
                if comparable:
                    self.assertEqual(successor(S, e), S)

    def test_growth_and_collapse(self):
        for S in self.cliques():
            for e in {frozenset(p) for p in combinations(range(5), 2)}:
                comparable = (len(S) >= 2 and e <= S) or (len(S) == 1 and S <= e)
                if comparable:
                    continue
                T = successor(S, e)
                if len(S | e) <= 3:
                    self.assertEqual(T, S | e)
                elif len(S) == 2:
                    self.assertEqual(T, e | (VERTICES - (S | e)))
                    self.assertEqual(len(T), 3)
                else:
                    self.assertEqual(T, S & e if S & e else e)
                    self.assertLessEqual(len(T), 2)

    def test_the_measured_edge_is_always_represented(self):
        """After a nondeterministic step the new Lagrangian holds the measured
        observable, so its label must meet that edge."""
        for S in self.cliques():
            for e in {frozenset(p) for p in combinations(range(5), 2)}:
                self.assertTrue(successor(S, e) & e)


if __name__ == "__main__":
    unittest.main()

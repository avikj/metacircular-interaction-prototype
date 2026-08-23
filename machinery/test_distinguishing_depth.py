#!/usr/bin/env python3
"""Exact checks for distinguishing depth of Pauli memory states."""

import unittest
from collections import Counter

import machinery.pauli_context_memory as pcm
from machinery.distinguishing_depth import (
    deepest_pairs,
    depths,
    pentagram_states,
    qubit_states,
    square_states,
)
from machinery.pentagram_labels import label


class Shallow(unittest.TestCase):
    """Every closed scenario separates in one measurement."""

    def test_one_qubit(self):
        r = depths(*qubit_states())
        self.assertEqual(r["states"], 7)
        self.assertEqual(r["max_depth"], 1)
        self.assertEqual(r["unseparated_pairs"], 0)

    def test_mermin_square(self):
        r = depths(*square_states())
        self.assertEqual(r["states"], 24)
        self.assertEqual(r["max_depth"], 1)
        self.assertEqual(r["depth_histogram"], {1: 276})
        self.assertEqual(r["unseparated_pairs"], 0)

    def test_full_two_qubit_set(self):
        obs = pcm.all_paulis(2)
        lags = pcm.lagrangians(obs, 2)
        gens, span = [], {pcm.identity(2)}
        for v in sorted(lags[0]):
            if any(v == w for _, w in span):
                continue
            gens.append((1, v))
            span = set(pcm.generate(gens, 2))
        states = pcm.reachable(pcm.generate(gens, 2), list(obs), 2)
        r = depths(states, list(obs), 2)
        self.assertEqual(r["states"], 60)
        self.assertEqual(r["max_depth"], 1)


class PentagramDepth(unittest.TestCase):
    """The one non-closed scenario, and the only one reaching depth two."""

    def setUp(self):
        self.states, self.obs, self.n = pentagram_states()
        self.report = depths(self.states, self.obs, self.n)

    def test_depth_two_and_no_deeper(self):
        self.assertEqual(self.report["states"], 200)
        self.assertEqual(self.report["max_depth"], 2)
        self.assertEqual(self.report["unseparated_pairs"], 0)

    def test_exactly_one_hundred_twenty_deep_pairs(self):
        self.assertEqual(self.report["depth_histogram"], {1: 19780, 2: 120})
        self.assertEqual(
            sum(self.report["depth_histogram"].values()), self.report["pairs_total"]
        )

    def test_refinement_trace(self):
        """1 -> 140 -> 200: the 80 edge-label states resolve from 20 blocks."""
        self.assertEqual(self.report["blocks_by_round"][:3], [1, 140, 200])
        self.assertEqual(200 - 140, 80 - 20)

    def test_deep_pairs_are_exactly_the_same_edge_label_pairs(self):
        """The predicted mechanism, checked: eight characters, one observable."""
        pairs = deepest_pairs(self.states, self.obs, self.n, 2)
        self.assertEqual(len(pairs), 120)
        kinds = Counter()
        for i, j in pairs:
            a, b = label(self.states[i]), label(self.states[j])
            kinds[(len(a), len(b), a == b)] += 1
        self.assertEqual(kinds, Counter({(2, 2, True): 120}))

    def test_count_is_forced_by_the_mechanism(self):
        """10 edge labels x 2 blocks of four x C(4,2) = 120."""
        self.assertEqual(10 * 2 * (4 * 3 // 2), 120)


if __name__ == "__main__":
    unittest.main()

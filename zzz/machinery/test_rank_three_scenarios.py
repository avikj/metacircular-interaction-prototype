#!/usr/bin/env python3
"""Exact rank-three checks: the confirmed prediction and the closure failure."""

import unittest

import machinery.pauli_context_memory as pcm
from machinery.rank_three_scenarios import (
    PENTAGRAM,
    SPACE6,
    line_signs,
    pentagram_memory,
    plus_type6,
    quadric_scenario,
    refinements6,
)


class RankThreeQuadric(unittest.TestCase):
    """ARF_MERMIN_CLASSIFICATION section 3's prediction, run."""

    def test_form_counts(self):
        self.assertEqual(len(refinements6()), 64)
        self.assertEqual(len(plus_type6()), 36)

    def test_every_plus_form_gives_the_predicted_scenario(self):
        for q in plus_type6():
            scenario = quadric_scenario(q)
            self.assertEqual(len(scenario), 35)
            self.assertEqual(len(pcm.lagrangians(scenario, 3)), 30)

    def test_memory_is_two_hundred_forty(self):
        """The forward prediction: memory = |C| * 2^n = 30 * 8."""
        scenario = quadric_scenario(plus_type6()[0])
        self.assertEqual(pcm.pure_memory(scenario, 3), 240)

    def test_full_three_qubit_set(self):
        """Control: 135 Lagrangians * 8 = 1080 three-qubit stabilizer states."""
        obs = pcm.all_paulis(3)
        self.assertEqual(len(pcm.lagrangians(obs, 3)), 135)
        self.assertEqual(pcm.pure_memory(obs, 3), 1080)


class PentagramClosureFailure(unittest.TestCase):
    """PAULI_MEMORY_LAGRANGIAN Corollary 3.2's hypotheses are necessary."""

    def test_pentagram_is_contextual(self):
        signs = line_signs()
        self.assertEqual(len(signs), 5)
        self.assertEqual(signs.count(-1) % 2, 1)

    def test_contexts_are_not_full_lagrangians(self):
        """Every maximal isotropic subspace inside the set is one-dimensional."""
        obs = [pcm.pauli(w) for w in PENTAGRAM]
        inside = pcm.lagrangians(obs, 3)
        self.assertEqual(len(inside), 10)
        self.assertTrue(all(len(L) == 1 for L in inside))

    def test_memory_exceeds_lines_times_eight(self):
        """Predicted: memory > 5 * 8. Actual: 200, via 25 reachable Lagrangians."""
        states, lags, overlap = pentagram_memory()
        self.assertEqual(len(states), 200)
        self.assertEqual(len(lags), 25)
        self.assertEqual(len(lags) * 8, len(states))
        self.assertGreater(len(states), 5 * 8)

    def test_reachable_lagrangian_breakdown(self):
        """The 25 split 5 + 10 + 10 by how many pentagram observables they hold."""
        _, _, overlap = pentagram_memory()
        self.assertEqual(overlap, {1: 10, 3: 10, 4: 5})

    def test_memory_is_irredundant(self):
        obs = [pcm.pauli(w) for w in PENTAGRAM]
        states, _, _ = pentagram_memory()
        self.assertEqual(len(pcm.predictive_quotient(states, obs, 3)), len(states))


if __name__ == "__main__":
    unittest.main()

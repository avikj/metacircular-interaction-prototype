#!/usr/bin/env python3

import unittest
from itertools import combinations

from cache_currency_gap import (
    WITNESS_PARENT,
    WITNESS_WEIGHTS,
    depth,
    greedy,
    is_ancestor_closed,
    modular_value,
    optimum,
    proof_cache_ranking,
    saved_work,
    subtree_demand,
    value_cache_gap,
)


class WitnessTests(unittest.TestCase):
    def test_the_named_values(self):
        self.assertEqual(saved_work({2}, WITNESS_PARENT, WITNESS_WEIGHTS), 18)
        self.assertEqual(saved_work({2, 4}, WITNESS_PARENT, WITNESS_WEIGHTS), 26)
        self.assertEqual(saved_work({4, 5}, WITNESS_PARENT, WITNESS_WEIGHTS), 32)

    def test_value_cache_greedy_is_strictly_suboptimal(self):
        greedy_value, best = value_cache_gap(2)
        self.assertEqual((greedy_value, best), (26, 32))
        self.assertLess(greedy_value, best)

    def test_the_gap_is_above_the_one_minus_one_over_e_bound(self):
        greedy_value, best = value_cache_gap(2)
        self.assertGreater(greedy_value / best, 0.6321)

    def test_greedy_picks_the_shared_prefix_first(self):
        nodes = list(WITNESS_PARENT)
        self.assertEqual(greedy(nodes, WITNESS_PARENT, WITNESS_WEIGHTS, 1), {2})

    def test_F_is_not_modular_on_the_boolean_lattice(self):
        alone = (saved_work({2}, WITNESS_PARENT, WITNESS_WEIGHTS)
                 + saved_work({4}, WITNESS_PARENT, WITNESS_WEIGHTS))
        joint = saved_work({2, 4}, WITNESS_PARENT, WITNESS_WEIGHTS)
        self.assertNotEqual(alone, joint)


class ProofCacheTests(unittest.TestCase):
    """codex-formation's theorem, verified rather than assumed."""

    def test_top_W_prefixes_are_ancestor_closed(self):
        ranking = proof_cache_ranking(WITNESS_PARENT, WITNESS_WEIGHTS)
        for budget in range(1, len(ranking) + 1):
            self.assertTrue(is_ancestor_closed(set(ranking[:budget]),
                                               WITNESS_PARENT))

    def test_F_is_modular_on_ancestor_closed_sets(self):
        nodes = list(WITNESS_PARENT)
        for size in range(1, len(nodes) + 1):
            for candidate in combinations(nodes, size):
                cache = set(candidate)
                if is_ancestor_closed(cache, WITNESS_PARENT):
                    self.assertEqual(
                        saved_work(cache, WITNESS_PARENT, WITNESS_WEIGHTS),
                        modular_value(cache, WITNESS_PARENT, WITNESS_WEIGHTS))

    def test_top_W_is_optimal_among_lawful_caches(self):
        nodes = list(WITNESS_PARENT)
        ranking = proof_cache_ranking(WITNESS_PARENT, WITNESS_WEIGHTS)
        for budget in (1, 2, 3):
            lawful = [set(c) for c in combinations(nodes, budget)
                      if is_ancestor_closed(set(c), WITNESS_PARENT)]
            best = max(saved_work(S, WITNESS_PARENT, WITNESS_WEIGHTS)
                       for S in lawful)
            self.assertEqual(
                saved_work(set(ranking[:budget]), WITNESS_PARENT,
                           WITNESS_WEIGHTS), best)

    def test_ancestors_have_at_least_their_descendants_demand(self):
        for node, parent_node in WITNESS_PARENT.items():
            if parent_node != 1:
                self.assertGreaterEqual(
                    subtree_demand(parent_node, WITNESS_PARENT, WITNESS_WEIGHTS),
                    subtree_demand(node, WITNESS_PARENT, WITNESS_WEIGHTS))


class TreeSanityTests(unittest.TestCase):
    def test_depths(self):
        self.assertEqual(depth(WITNESS_PARENT, 2), 1)
        for leaf in (3, 4, 5):
            self.assertEqual(depth(WITNESS_PARENT, leaf), 2)

    def test_optimum_agrees_with_brute_force(self):
        nodes = list(WITNESS_PARENT)
        for budget in (1, 2, 3):
            best = max(saved_work(set(c), WITNESS_PARENT, WITNESS_WEIGHTS)
                       for c in combinations(nodes, budget))
            self.assertEqual(
                saved_work(optimum(nodes, WITNESS_PARENT, WITNESS_WEIGHTS,
                                   budget), WITNESS_PARENT, WITNESS_WEIGHTS),
                best)


if __name__ == "__main__":
    unittest.main()

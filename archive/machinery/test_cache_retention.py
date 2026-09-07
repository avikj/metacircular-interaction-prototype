#!/usr/bin/env python3

import itertools
import unittest

from cache_relative_formation import binary_prefixes
from cache_retention import (
    ancestor_closed_retention,
    candidate_nodes,
    exact_ancestor_closed_retention,
    exact_retention,
    greedy_retention,
    is_ancestor_closed,
    saved_work,
    subtree_demand,
    trace_parent,
)


class CacheRetentionTests(unittest.TestCase):
    def test_binary_paths_share_only_an_initial_segment(self):
        for a in range(1, 80):
            for b in range(1, 80):
                left, right = binary_prefixes(a), binary_prefixes(b)
                common = set(left) & set(right)
                length = 0
                while length < min(len(left), len(right)) and left[length] == right[length]:
                    length += 1
                self.assertEqual(common, set(left[:length]))

    def test_saved_work_is_monotone_submodular(self):
        weights = {5: 2, 6: 1, 10: 3, 13: 2}
        universe = sorted(candidate_nodes(weights))
        subsets = [frozenset(x for x, bit in zip(universe, mask) if bit)
                   for mask in itertools.product((0, 1), repeat=len(universe))]
        for small in subsets:
            for large in subsets:
                if not small <= large:
                    continue
                self.assertLessEqual(saved_work(small, weights), saved_work(large, weights))
                for x in set(universe) - large:
                    small_gain = saved_work(small | {x}, weights) - saved_work(small, weights)
                    large_gain = saved_work(large | {x}, weights) - saved_work(large, weights)
                    self.assertGreaterEqual(small_gain, large_gain)

    def test_executable_formation_event(self):
        weights = {10: 1, 11: 1, 12: 1, 13: 1}
        greedy, trace = greedy_retention(weights, 2)
        exact, optimum = exact_retention(weights, 2)
        self.assertEqual((greedy, trace), (frozenset({10, 12}), ((10, 8), (12, 8))))
        self.assertEqual(saved_work(greedy, weights), optimum)
        self.assertEqual(optimum, 16)
        self.assertEqual(exact, frozenset({10, 12}))

    def test_greedy_meets_elementary_bound_on_small_instances(self):
        for targets in ({7: 1, 9: 2, 12: 1}, {10: 1, 11: 1, 12: 1, 13: 1}):
            for budget in range(1, 4):
                chosen, _ = greedy_retention(targets, budget)
                _, optimum = exact_retention(targets, budget)
                # The theorem gives 1-(1-1/B)^B >= 1-1/e.
                self.assertGreaterEqual(
                    budget**budget * saved_work(chosen, targets),
                    (budget**budget - (budget - 1)**budget) * optimum,
                )

    def test_fail_closed(self):
        with self.assertRaises(ValueError):
            saved_work({2}, {0: 1})
        with self.assertRaises(ValueError):
            greedy_retention({3: 1}, -1)

    def test_trace_parent_reconstructs_every_path(self):
        for target in range(2, 100):
            reverse_path = [target]
            while reverse_path[-1] != 1:
                reverse_path.append(trace_parent(reverse_path[-1]))
            self.assertEqual(tuple(reversed(reverse_path)), binary_prefixes(target))

    def test_ancestor_closed_value_telescopes(self):
        weights = {10: 2, 11: 1, 12: 3, 13: 2}
        rewards = subtree_demand(weights)
        candidates = sorted(rewards)
        for mask in itertools.product((0, 1), repeat=len(candidates)):
            kept = frozenset(x for x, bit in zip(candidates, mask) if bit)
            if is_ancestor_closed(kept):
                self.assertEqual(saved_work(kept, weights), sum(rewards[x] for x in kept))

    def test_ancestor_closed_greedy_is_exact(self):
        instances = ({13: 1}, {10: 1, 11: 1, 12: 1, 13: 1},
                     {5: 2, 6: 1, 10: 3, 13: 2})
        for weights in instances:
            for budget in range(5):
                chosen, _ = ancestor_closed_retention(weights, budget)
                exact, optimum = exact_ancestor_closed_retention(weights, budget)
                self.assertTrue(is_ancestor_closed(chosen))
                self.assertEqual(saved_work(chosen, weights), optimum)
                self.assertEqual(len(chosen), min(budget, len(candidate_nodes(weights))))
                self.assertTrue(is_ancestor_closed(exact))

    def test_provenance_currency_changes_the_frontier(self):
        weights = {13: 1}
        unrestricted, unrestricted_value = exact_retention(weights, 1)
        replayable, replayable_value = exact_ancestor_closed_retention(weights, 1)
        self.assertEqual((unrestricted, unrestricted_value), (frozenset({13}), 5))
        self.assertEqual((replayable, replayable_value), (frozenset({2}), 1))


if __name__ == "__main__":
    unittest.main()

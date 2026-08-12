#!/usr/bin/env python3

import unittest

from cache_relative_formation import (
    binary_prefixes,
    form_from_cache,
    future_cost_profile,
    verify_transition,
)


class CacheRelativeFormationTests(unittest.TestCase):
    def test_same_target_has_different_marginal_costs(self):
        empty = form_from_cache(13, frozenset({1}))
        partial = form_from_cache(13, frozenset({1, 2, 3, 6}))
        complete = form_from_cache(13, frozenset(binary_prefixes(13)))
        self.assertEqual((empty.new_additions, partial.new_additions, complete.new_additions), (5, 2, 0))
        self.assertTrue(all(map(verify_transition, (empty, partial, complete))))

    def test_cache_monotonicity_on_nested_trace_caches(self):
        prefixes = binary_prefixes(109)
        costs = []
        for length in range(1, len(prefixes) + 1):
            cache = frozenset(prefixes[:length])
            costs.append(form_from_cache(109, cache).new_additions)
        self.assertEqual(costs, sorted(costs, reverse=True))
        self.assertEqual(costs[-1], 0)

    def test_transition_retains_new_intermediates_for_reuse(self):
        first = form_from_cache(13, frozenset({1}))
        second = form_from_cache(12, first.final_cache)
        self.assertEqual(second.new_additions, 0)
        self.assertEqual(second.new_intermediates, frozenset())

    def test_fixed_policy_formula_without_cache(self):
        for target in range(1, 100):
            transition = form_from_cache(target, frozenset({1}))
            expected = target.bit_length() - 1 + target.bit_count() - 1
            self.assertEqual(transition.new_additions, expected)

    def test_invalid_cache_and_target_fail_closed(self):
        with self.assertRaises(ValueError):
            form_from_cache(7, frozenset())
        with self.assertRaises(ValueError):
            form_from_cache(0, frozenset({1}))

    def test_equal_present_vectors_have_incomparable_future_options(self):
        five = form_from_cache(5, frozenset({1}))
        six = form_from_cache(6, frozenset({1}))
        self.assertEqual(five.present_cost_vector, six.present_cost_vector)
        self.assertEqual(five.present_cost_vector, (3, 4))
        self.assertFalse(five.final_cache <= six.final_cache)
        self.assertFalse(six.final_cache <= five.final_cache)
        self.assertEqual(future_cost_profile(five.final_cache, (3, 4)), (1, 0))
        self.assertEqual(future_cost_profile(six.final_cache, (3, 4)), (0, 1))

    def test_future_profile_factors_through_labeled_dependency_intersection(self):
        targets = (3, 4, 5, 6, 13)
        cache = form_from_cache(13, frozenset({1})).final_cache
        profile = future_cost_profile(cache, targets)
        self.assertEqual(profile, tuple(form_from_cache(t, cache).new_additions for t in targets))


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3

import unittest

from weighted_formation_curvature import (
    all_curvatures,
    curvature_report,
    is_submodular,
    weighted_value,
)


class WeightedFormationCurvatureTests(unittest.TestCase):
    def test_report_equals_direct_second_difference(self):
        facts = {
            "or": ({"a"}, {"b"}),
            "and": ({"a", "b"},),
            "a_only": ({"a"},),
            "three": ({"a", "b", "c"},),
        }
        weights = {"or": 5, "and": 3, "a_only": 7, "three": 2}
        for report in all_curvatures(facts, weights):
            direct = (
                weighted_value(report.left, facts, weights)
                + weighted_value(report.right, facts, weights)
                - weighted_value(report.left | report.right, facts, weights)
                - weighted_value(report.left & report.right, facts, weights)
            )
            self.assertEqual(report.slack, direct)

    def test_two_action_threshold_is_exact(self):
        facts = {"either": ({"a"}, {"b"}), "both": ({"a", "b"},)}
        for alpha in range(1, 6):
            for beta in range(0, 7):
                weights = {"either": beta, "both": alpha}
                report = curvature_report({"a"}, {"b"}, facts, weights)
                self.assertEqual((report.redundant_weight,
                                  report.jointly_unlocked_weight,
                                  report.slack), (beta, alpha, beta - alpha))
                self.assertEqual(is_submodular(facts, weights), beta >= alpha)

    def test_complementary_fact_survives_at_balanced_total(self):
        facts = {"either": ({"a"}, {"b"}), "both": ({"a", "b"},)}
        weights = {"either": 1, "both": 1}
        self.assertTrue(is_submodular(facts, weights))
        self.assertEqual(weighted_value(set(), facts, weights), 0)
        self.assertEqual(weighted_value({"a"}, facts, weights), 1)
        self.assertEqual(weighted_value({"b"}, facts, weights), 1)
        self.assertEqual(weighted_value({"a", "b"}, facts, weights), 2)

    def test_fail_closed(self):
        facts = {"x": ({"a"},)}
        with self.assertRaises(ValueError):
            weighted_value(set(), facts, {})
        with self.assertRaises(ValueError):
            curvature_report(set(), set(), facts, {"x": -1})


if __name__ == "__main__":
    unittest.main()

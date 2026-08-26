import unittest

from witness_withdrawal import (
    independent_reachability_lower_bound,
    optimize_withdrawal,
)


class WitnessWithdrawalTests(unittest.TestCase):
    def test_smallest_choice_sensitive_example(self):
        # Two A-only seeds, one B-only seed, and one shortest-path node which
        # may route to A or B.  Lexicographic A gives loads (3,1), optimum B
        # gives (2,2).
        depth = {"a0": 0, "a1": 0, "b": 0, "u": 1}
        successors = {"u": ("a0", "b")}
        seed_labels = {"a0": ("A",), "a1": ("A",), "b": ("B",)}
        sol = optimize_withdrawal(depth, successors, seed_labels)
        self.assertEqual(sol.worst_invalidated_weight, 2)
        self.assertEqual(sol.loads, {"A": 2, "B": 2})
        self.assertEqual(sol.parent["u"], "b")

    def test_shared_suffix_kills_independent_assignment(self):
        # u passes through c.  Each separately reaches A and B, but the one
        # stored choice at c forces both to share a root.  Four nodes is the
        # smallest possible gap between the relaxation and a real forest.
        depth = {"a": 0, "b": 0, "c": 1, "u": 2}
        successors = {"c": ("a", "b"), "u": ("c",)}
        seed_labels = {"a": ("A",), "b": ("B",)}
        self.assertEqual(
            independent_reachability_lower_bound(depth, successors, seed_labels),
            2,
        )
        self.assertEqual(
            optimize_withdrawal(depth, successors, seed_labels).worst_invalidated_weight,
            3,
        )

    def test_seed_can_choose_terminal_observation(self):
        depth = {"x": 0, "a": 0, "b": 0}
        seed_labels = {"x": ("A", "B"), "a": ("A",), "b": ("B",)}
        sol = optimize_withdrawal(depth, {}, seed_labels)
        self.assertEqual(sol.worst_invalidated_weight, 2)

    def test_weighted_withdrawal(self):
        depth = {"a": 0, "b": 0, "u": 1}
        successors = {"u": ("a", "b")}
        seed_labels = {"a": ("A",), "b": ("B",)}
        weights = {"a": 4, "b": 1, "u": 3}
        sol = optimize_withdrawal(depth, successors, seed_labels, weights)
        self.assertEqual(sol.loads, {"A": 4, "B": 4})
        self.assertEqual(sol.parent["u"], "b")

    def test_rejects_nonshortest_edge(self):
        with self.assertRaisesRegex(ValueError, "decrease depth"):
            optimize_withdrawal(
                {"a": 0, "u": 2},
                {"u": ("a",)},
                {"a": ("A",)},
            )


if __name__ == "__main__":
    unittest.main()

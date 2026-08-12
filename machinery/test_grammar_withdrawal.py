import unittest

from grammar_withdrawal import (
    Production,
    invalidated_nodes,
    optimize_constructor_withdrawal,
)


class GrammarWithdrawalTests(unittest.TestCase):
    def test_two_seed_alternative_derivation_is_smallest_improvement(self):
        # q2 and q3 look like two independent labels.  Generated through the
        # same quotient constructor Q, however, they share one fault domain.
        q2 = Production("q2-via-Q", "q2", frozenset({"Q", "two"}))
        q3_shared = Production("q3-via-Q", "q3", frozenset({"Q", "three"}))
        q3_direct = Production("q3-direct", "q3", frozenset({"D3"}))
        sol = optimize_constructor_withdrawal(
            {"z2": 0, "z3": 0},
            {},
            {"z2": (q2,), "z3": (q3_shared, q3_direct)},
        )
        self.assertEqual(sol.production["z3"], q3_direct)
        self.assertEqual(sol.worst_invalidated_weight, 1)
        self.assertEqual(invalidated_nodes(sol, "Q"), frozenset({"z2"}))

    def test_semantic_labels_do_not_determine_rule_damage(self):
        q2 = Production("q2-via-Q", "q2", frozenset({"Q"}))
        q3 = Production("q3-via-Q", "q3", frozenset({"Q"}))
        sol = optimize_constructor_withdrawal(
            {"z2": 0, "z3": 0}, {}, {"z2": (q2,), "z3": (q3,)}
        )
        # Atomic-label loads are one each, yet withdrawing the common rule
        # destroys both chosen separations.
        self.assertEqual({p.observation for p in sol.production.values()}, {"q2", "q3"})
        self.assertEqual(sol.worst_invalidated_weight, 2)
        self.assertEqual(invalidated_nodes(sol, "Q"), frozenset({"z2", "z3"}))

    def test_nonseed_inherits_exact_derivation_support(self):
        left = Production("left", "parity", frozenset({"project", "left"}))
        direct = Production("direct", "parity", frozenset({"parity"}))
        depth = {"z": 0, "u": 1}
        sol = optimize_constructor_withdrawal(
            depth, {"u": ("z",)}, {"z": (left, direct)}
        )
        self.assertEqual(sol.production["u"], sol.production["z"])
        self.assertEqual(sol.worst_invalidated_weight, 2)

    def test_weighted_rule_loads_overlap(self):
        p = Production("composite", "obs", frozenset({"parse", "project"}))
        sol = optimize_constructor_withdrawal(
            {"z": 0}, {}, {"z": (p,)}, {"z": 7}
        )
        self.assertEqual(sol.rule_loads, {"parse": 7, "project": 7})
        self.assertEqual(sol.worst_invalidated_weight, 7)

    def test_rejects_nonshortest_edges(self):
        p = Production("p", "obs", frozenset({"rule"}))
        with self.assertRaisesRegex(ValueError, "decrease depth"):
            optimize_constructor_withdrawal(
                {"z": 0, "u": 2}, {"u": ("z",)}, {"z": (p,)}
            )


if __name__ == "__main__":
    unittest.main()

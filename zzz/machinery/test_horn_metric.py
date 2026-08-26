#!/usr/bin/env python3
"""Exact and hostile tests for context-indexed Horn compilation."""

import unittest
from fractions import Fraction

from machinery.horn_metric import (
    DeletionRule,
    HornMacroCertificate,
    HornRule,
    LinearResourceRule,
    compile_horn_macro,
    horn_state_graph,
)
from machinery.proof_metric import ProofEdge, all_pairs_shortest_paths


class HornMetricTests(unittest.TestCase):
    def setUp(self):
        self.atoms = ("a", "b", "c", "d")
        self.rules = (
            HornRule("ab_c_old", frozenset(("a", "b")), "c", Fraction(11, 2)),
        )
        self.certificate = HornMacroCertificate(
            "ab_c", frozenset(("a", "b")), "c", 1, ("ab_c_old",)
        )

    def test_context_family_and_exact_update(self):
        result = compile_horn_macro(self.atoms, self.rules, self.certificate)
        self.assertEqual(result.validation_cost, Fraction(11, 2))
        ab = frozenset(("a", "b"))
        abc = frozenset(("a", "b", "c"))
        abd = frozenset(("a", "b", "d"))
        abcd = frozenset(("a", "b", "c", "d"))
        self.assertEqual(result.before[ab, abc], Fraction(11, 2))
        self.assertEqual(result.after[ab, abc], 1)
        self.assertEqual(result.before[abd, abcd], Fraction(11, 2))
        self.assertEqual(result.after[abd, abcd], 1)
        sources = {edge.source for edge in result.macro_edges}
        self.assertIn(ab, sources)
        self.assertIn(abd, sources)

    def test_irrelevant_d_is_small_rank_one_counterexample(self):
        states, old_edges = horn_state_graph(self.atoms, self.rules)
        ab = frozenset(("a", "b"))
        abc = frozenset(("a", "b", "c"))
        abd = frozenset(("a", "b", "d"))
        abcd = frozenset(("a", "b", "c", "d"))
        # A single base-context edge cannot serve the weakened context: monotone
        # proof states have no path that deletes the irrelevant fact d.
        one_edge = ProofEdge("ab_c@base", ab, abc, 1)
        single, _ = all_pairs_shortest_paths(states, old_edges + (one_edge,))
        family = compile_horn_macro(self.atoms, self.rules, self.certificate)
        self.assertEqual(single[abd, abcd], Fraction(11, 2))
        self.assertEqual(family.after[abd, abcd], 1)
        self.assertIsNone(single[abd, ab])

    def test_reachability_is_unchanged(self):
        result = compile_horn_macro(self.atoms, self.rules, self.certificate)
        before = {pair for pair, cost in result.before.items() if cost is not None}
        after = {pair for pair, cost in result.after.items() if cost is not None}
        self.assertEqual(before, after)

    def test_invalid_certificates_fail_closed(self):
        invalid = (
            HornMacroCertificate("empty", frozenset(("a", "b")), "c", 1, ()),
            HornMacroCertificate("unknown", frozenset(("a", "b")), "c", 1, ("no",)),
            HornMacroCertificate("disabled", frozenset(("a",)), "c", 1,
                                 ("ab_c_old",)),
            HornMacroCertificate("wrong", frozenset(("a", "b")), "d", 1,
                                 ("ab_c_old",)),
            HornMacroCertificate("negative", frozenset(("a", "b")), "c", -1,
                                 ("ab_c_old",)),
        )
        for certificate in invalid:
            with self.subTest(certificate=certificate.name):
                with self.assertRaises(ValueError):
                    compile_horn_macro(self.atoms, self.rules, certificate)

    def test_deletion_and_linear_resources_fail_closed(self):
        with self.assertRaisesRegex(TypeError, "deletion"):
            horn_state_graph(
                self.atoms,
                (DeletionRule("consume_d", frozenset(("d",)), "d", 1),),  # type: ignore[arg-type]
            )
        with self.assertRaisesRegex(TypeError, "resource-sensitive"):
            horn_state_graph(
                self.atoms,
                (LinearResourceRule("linear", ("a",), ("c",), 1),),  # type: ignore[arg-type]
            )

    def test_multistep_macro_can_hide_intermediate_operational_fact(self):
        atoms = ("a", "b", "x", "c")
        rules = (
            HornRule("ab_x", frozenset(("a", "b")), "x", 1),
            HornRule("x_c", frozenset(("x",)), "c", 1),
        )
        result = compile_horn_macro(
            atoms,
            rules,
            HornMacroCertificate(
                "ab_c", frozenset(("a", "b")), "c", 1, ("ab_x", "x_c")
            ),
        )
        ab = frozenset(("a", "b"))
        abc = frozenset(("a", "b", "c"))
        self.assertIsNone(result.before[ab, abc])
        self.assertEqual(result.after[ab, abc], 1)
        self.assertIn((ab, abc, None, Fraction(1)), result.influence_cone)


if __name__ == "__main__":
    unittest.main()

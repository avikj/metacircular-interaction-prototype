#!/usr/bin/env python3
"""Hostile tests for the proof-carrying min-plus compiler."""

import unittest
from fractions import Fraction

from machinery.proof_metric import (
    HyperRule,
    MacroCertificate,
    ProofEdge,
    all_pairs_shortest_paths,
    compile_macro,
)


class ProofMetricTests(unittest.TestCase):
    def setUp(self):
        self.vertices = ("a", "b", "c", "d", "isolated")
        self.edges = (
            ProofEdge("ab", "a", "b", 3),
            ProofEdge("bc", "b", "c", Fraction(7, 2)),
            ProofEdge("cd", "c", "d", Fraction(11, 2)),
        )

    def test_macro_update_and_influence_cone(self):
        result = compile_macro(
            self.vertices,
            self.edges,
            MacroCertificate("bd", "b", "d", Fraction(1, 2), ("bc", "cd")),
        )
        self.assertEqual(result.validation_cost, 9)
        self.assertEqual(result.before["a", "d"], 12)
        self.assertEqual(result.after["a", "d"], Fraction(7, 2))
        self.assertEqual(result.after["b", "d"], Fraction(1, 2))
        self.assertEqual(result.witnesses["a", "d"], ("ab", "bd"))
        self.assertEqual(
            result.influence_cone,
            (("a", "d", Fraction(12), Fraction(7, 2)),
             ("b", "d", Fraction(9), Fraction(1, 2))),
        )

    def test_reachability_is_unchanged(self):
        result = compile_macro(
            self.vertices,
            self.edges,
            MacroCertificate("ac", "a", "c", 1, ("ab", "bc")),
        )
        before_reachable = {pair for pair, value in result.before.items() if value is not None}
        after_reachable = {pair for pair, value in result.after.items() if value is not None}
        self.assertEqual(before_reachable, after_reachable)
        self.assertIsNone(result.after["isolated", "d"])

    def test_non_improving_macro_is_valid_but_has_empty_influence(self):
        result = compile_macro(
            self.vertices,
            self.edges,
            MacroCertificate("slow", "b", "d", 20, ("bc", "cd")),
        )
        self.assertEqual(result.influence_cone, ())
        self.assertEqual(result.before, result.after)

    def test_invalid_certificate_fails_closed(self):
        cases = (
            MacroCertificate("empty", "a", "a", 0, ()),
            MacroCertificate("unknown", "a", "d", 1, ("ab", "missing")),
            MacroCertificate("jump", "a", "d", 1, ("bc", "cd")),
            MacroCertificate("short", "a", "d", 1, ("ab", "bc")),
            MacroCertificate("negative", "a", "d", -1, ("ab", "bc", "cd")),
        )
        for certificate in cases:
            with self.subTest(certificate=certificate.name):
                with self.assertRaises(ValueError):
                    compile_macro(self.vertices, self.edges, certificate)

    def test_duplicate_names_and_endpoints_fail_closed(self):
        with self.assertRaises(ValueError):
            all_pairs_shortest_paths(
                self.vertices,
                self.edges + (ProofEdge("ab", "a", "d", 1),),
            )
        with self.assertRaises(ValueError):
            all_pairs_shortest_paths(
                self.vertices,
                self.edges + (ProofEdge("outside", "a", "z", 1),),
            )

    def test_zero_cost_cycle_matches_fresh_apsp(self):
        edges = (
            ProofEdge("ab", "a", "b", 0),
            ProofEdge("ba", "b", "a", 0),
            ProofEdge("bc", "b", "c", 2),
        )
        result = compile_macro(
            ("a", "b", "c"),
            edges,
            MacroCertificate("ac", "a", "c", 1, ("ab", "bc")),
        )
        self.assertEqual(result.after["b", "c"], 1)
        self.assertEqual(result.witnesses["b", "c"], ("ba", "ac"))

    def test_hyperrule_flattening_is_rejected(self):
        # {a,b} -> c cannot soundly become a -> c: the missing b premise matters.
        rule = HyperRule("and", ("a", "b"), "c", 1)
        with self.assertRaisesRegex(TypeError, "AND/OR proof hypergraph"):
            all_pairs_shortest_paths(("a", "b", "c"), (rule,))  # type: ignore[arg-type]


if __name__ == "__main__":
    unittest.main()

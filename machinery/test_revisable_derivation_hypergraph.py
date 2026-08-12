import itertools
import unittest

from revisable_derivation_hypergraph import Rule, closure, minimal_supports, survivors_from_supports


class RevisionTests(unittest.TestCase):
    def test_smallest_single_parent_overinvalidates(self):
        rules = (
            Rule("direct", frozenset({"s"}), "x"),
            Rule("detour1", frozenset({"s"}), "y"),
            Rule("detour2", frozenset({"y"}), "x"),
        )
        supports = minimal_supports({"s"}, rules)
        self.assertEqual(supports["x"], frozenset({frozenset({"direct"}),
                                                   frozenset({"detour1", "detour2"})}))
        self.assertIn("x", survivors_from_supports(supports, {"direct"}))
        self.assertIn("x", closure({"s"}, rules, {"direct"}))

    def test_and_rule_requires_every_premise(self):
        rules = (
            Rule("left", frozenset({"s"}), "a"),
            Rule("right", frozenset({"s"}), "b"),
            Rule("join", frozenset({"a", "b"}), "z"),
        )
        self.assertEqual(minimal_supports({"s"}, rules)["z"],
                         frozenset({frozenset({"left", "right", "join"})}))

    def test_cycles_create_no_support_from_nothing(self):
        rules = (Rule("ab", frozenset({"a"}), "b"), Rule("ba", frozenset({"b"}), "a"))
        self.assertEqual(closure(set(), rules), frozenset())
        self.assertEqual(minimal_supports(set(), rules), {})

    def test_support_law_matches_recomputation_for_every_deletion(self):
        rules = (
            Rule("sa", frozenset({"s"}), "a"),
            Rule("sb", frozenset({"s"}), "b"),
            Rule("abz", frozenset({"a", "b"}), "z"),
            Rule("ax", frozenset({"a"}), "x"),
            Rule("xz", frozenset({"x"}), "z"),
            Rule("za", frozenset({"z"}), "a"),
        )
        supports = minimal_supports({"s"}, rules)
        names = tuple(rule.name for rule in rules)
        for mask in itertools.product((False, True), repeat=len(names)):
            deleted = {name for name, bit in zip(names, mask) if bit}
            self.assertEqual(survivors_from_supports(supports, deleted),
                             closure({"s"}, rules, deleted))


if __name__ == "__main__":
    unittest.main()

import unittest

from initial_crystal import Rule, generate, interpret, is_closed, validate_rules


class InitialCrystalTests(unittest.TestCase):
    def test_empty_seed_generates_least_closed_world(self):
        rules = (
            Rule("seed", frozenset(), "A"),
            Rule("form-B", frozenset({"A"}), "B", frozenset({"seed"})),
            Rule("compose", frozenset({"A", "B"}), "C",
                 frozenset({"seed", "form-B"})),
        )
        crystal = generate(rules)
        self.assertEqual(crystal.sentences, frozenset({"A", "B", "C"}))
        self.assertTrue(is_closed(crystal.sentences, rules))
        self.assertEqual(crystal.origin("C")[0].parents, ("A", "B"))

    def test_leastness_against_every_declared_closed_superset(self):
        rules = (Rule("zero", frozenset(), 0),
                 Rule("one", frozenset({0}), 1))
        generated = generate(rules).sentences
        candidates = ({0, 1}, {0, 1, 2}, {0, 1, "extra"})
        self.assertTrue(all(is_closed(candidate, rules) and generated <= candidate
                            for candidate in candidates))

    def test_rule_dependency_names_are_checked(self):
        with self.assertRaises(ValueError):
            validate_rules((Rule("later", frozenset(), "x",
                                 frozenset({"missing"})),))

    def test_interpretation_replays_derivation(self):
        rules = (Rule("unit", frozenset(), "u"),
                 Rule("double", frozenset({"u"}), "d"))
        crystal = generate(rules)
        result = interpret(crystal, rules, {"u": 1, "d": 2},
                           {"unit": ((), 1), "double": ((1,), 2)})
        self.assertEqual(result, {"u": 1, "d": 2})
        with self.assertRaises(ValueError):
            interpret(crystal, rules, {"u": 1, "d": 3},
                      {"unit": ((), 1), "double": ((1,), 2)})


if __name__ == "__main__":
    unittest.main()

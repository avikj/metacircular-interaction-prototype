import unittest

from constructor_grammar_formation import QuotientGrammar, accidental_catalog_choice


class ConstructorGrammarFormationTests(unittest.TestCase):
    def test_collision_2_4_forces_one_step_mod3(self):
        grammar = QuotientGrammar()
        result = grammar.form_for_collision(2, 4)
        self.assertEqual((result.modulus, result.cost), (3, 1))
        self.assertEqual(result.replay(), 3)

    def test_composite_difference_skips_dividing_moduli(self):
        grammar = QuotientGrammar()
        result = grammar.form_for_collision(14, 26)
        self.assertEqual((result.modulus, result.cost), (5, 2))
        self.assertEqual([step[2] for step in result.derivation], [4, 5])

    def test_formed_program_changes_next_search(self):
        grammar = QuotientGrammar()
        first = grammar.form_for_collision(14, 26)
        self.assertEqual(first.modulus, 5)
        # Mod 5 is now a zero-cost installed program and resolves this encounter.
        with self.assertRaises(ValueError):
            grammar.form_for_collision(1, 6)

    def test_accidental_call_order_is_not_optimization(self):
        self.assertEqual(accidental_catalog_choice(2, 4, (5, 3)), 5)
        self.assertEqual(QuotientGrammar().form_for_collision(2, 4).modulus, 3)

    def test_no_equal_pair_observation(self):
        with self.assertRaises(ValueError):
            QuotientGrammar().form_for_collision(9, 9)


if __name__ == "__main__":
    unittest.main()

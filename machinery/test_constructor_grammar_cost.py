import unittest

from constructor_grammar_cost import (
    generate,
    observed_states,
    profile,
    representation_fiber,
    value,
)


class ConstructorGrammarCostTests(unittest.TestCase):
    def test_closed_forms_replay(self):
        for base in range(2, 6):
            for depth in range(5):
                words = generate(base, depth)
                p = profile(base, depth)
                self.assertEqual(len(words), p.syntax_nodes)
                self.assertEqual(len(words) - 1, p.materialization_calls)
                self.assertEqual(len({value(w, base) for w in words}), p.arithmetic_values)
                self.assertEqual(p.quotient_collisions, p.syntax_nodes - p.arithmetic_values)

    def test_fixed_depth_is_unique_positional_address(self):
        for base in range(2, 6):
            words = [w for w in generate(base, 4) if len(w) == 4]
            self.assertEqual(len(words), base**4)
            self.assertEqual(len({value(w, base) for w in words}), base**4)

    def test_leading_zero_fibers(self):
        self.assertEqual(representation_fiber(0, 2, 3), ((), (0,), (0, 0), (0, 0, 0)))
        self.assertEqual(representation_fiber(1, 2, 3), ((1,), (0, 1), (0, 0, 1)))
        self.assertEqual(representation_fiber(5, 2, 3), ((1, 0, 1),))

    def test_observer_retention_is_separate(self):
        self.assertEqual(observed_states(2, 1, 3), 2)
        self.assertEqual(observed_states(2, 2, 3), 3)
        self.assertEqual(observed_states(10, 2, 7), 7)

    def test_small_schema_does_not_equal_materialization_cost(self):
        p = profile(2, 10)
        self.assertEqual(p.schema_constructors, 3)
        self.assertEqual(p.one_execution_calls, 10)
        self.assertEqual(p.materialization_calls, 2046)
        self.assertEqual(p.arithmetic_values, 1024)


if __name__ == "__main__":
    unittest.main()

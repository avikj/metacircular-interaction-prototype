import unittest
from fractions import Fraction

from action_metric import (
    DerivedGenerator,
    WeightedGenerator,
    compile_derived_generator,
    generated_monoid,
)


class ActionMetricTests(unittest.TestCase):
    def test_cyclic_translation_macro_preserves_monoid_and_shortens_metric(self):
        step = WeightedGenerator("step", (1, 2, 0), 1)
        result = compile_derived_generator(
            3, (step,), DerivedGenerator("step2", ("step", "step"), 1)
        )
        self.assertEqual(len(result.elements), 3)
        self.assertEqual(result.derived_action, (2, 0, 1))
        self.assertEqual(result.validation_cost, 2)
        self.assertEqual(len(result.influence_cone), 3)
        self.assertTrue(all(old == 2 and new == 1
                            for _, _, old, new in result.influence_cone))

    def test_non_improving_macro_has_empty_influence(self):
        flip = WeightedGenerator("flip", (1, 0), Fraction(1, 2))
        result = compile_derived_generator(
            2, (flip,), DerivedGenerator("flip-again", ("flip",), 1)
        )
        self.assertFalse(result.influence_cone)

    def test_reusable_action_macro_can_be_needed_more_than_once(self):
        step = WeightedGenerator("step", (1, 2, 3, 4, 0), 1)
        result = compile_derived_generator(
            5, (step,), DerivedGenerator("step2", ("step", "step"), 1)
        )
        identity = (0, 1, 2, 3, 4)
        step4 = (4, 0, 1, 2, 3)
        self.assertEqual(result.before[identity, step4], 4)
        self.assertEqual(result.after[identity, step4], 2)

    def test_unknown_expansion_and_negative_cost_fail_closed(self):
        step = WeightedGenerator("step", (1, 0), 1)
        with self.assertRaises(ValueError):
            compile_derived_generator(
                2, (step,), DerivedGenerator("bad", ("missing",), 0)
            )
        with self.assertRaises(ValueError):
            compile_derived_generator(
                2, (step,), DerivedGenerator("bad", ("step",), -1)
            )

    def test_malformed_action_is_rejected(self):
        with self.assertRaises(ValueError):
            generated_monoid(2, (WeightedGenerator("escape", (0, 2), 1),))


if __name__ == "__main__":
    unittest.main()

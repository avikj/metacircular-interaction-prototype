import unittest

from mod5_predictive_quantum_profile import (
    full_response_classes,
    predictive_classes,
    predictive_dimension,
    signature,
)


class Mod5PredictiveQuantumProfileTests(unittest.TestCase):
    def test_exact_horizon_profile(self):
        self.assertEqual([predictive_dimension(h) for h in range(6)], [1, 3, 4, 4, 4, 4])

    def test_full_classes_have_strict_intermediate_quotient(self):
        self.assertEqual(
            full_response_classes(),
            frozenset({frozenset({0}), frozenset({1}), frozenset({4}), frozenset({2, 3})}),
        )

    def test_two_and_three_remain_equivalent(self):
        for horizon in range(12):
            self.assertEqual(signature(2, horizon), signature(3, horizon))

    def test_empty_continuation_is_uniform_and_zero_is_then_separated(self):
        self.assertEqual(predictive_classes(0), frozenset({frozenset(range(5))}))
        self.assertNotEqual(signature(0, 1), signature(1, 1))


if __name__ == "__main__":
    unittest.main()

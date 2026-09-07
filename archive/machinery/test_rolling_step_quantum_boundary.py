import unittest

from rolling_step_quantum_boundary import (
    expected_rolling_dimension,
    promised_ladder_transition,
    rolling_environment_dimension,
)


class RollingStepQuantumBoundaryTests(unittest.TestCase):
    def test_exact_iterated_fiber_cost(self):
        for prime, depth in ((2, 6), (3, 4), (5, 3)):
            for steps in range(depth + 3):
                self.assertEqual(
                    rolling_environment_dimension(prime, depth, steps),
                    expected_rolling_dimension(prime, depth, steps),
                )

    def test_one_step_exports_one_p_ary_digit(self):
        self.assertEqual(rolling_environment_dimension(2, 8, 1), 2)
        self.assertEqual(rolling_environment_dimension(5, 3, 1), 5)

    def test_saturation_is_full_erasure(self):
        self.assertEqual(rolling_environment_dimension(3, 4, 4), 81)
        self.assertEqual(rolling_environment_dimension(3, 4, 9), 81)

    def test_promised_level_transition_is_injective(self):
        transition = promised_ladder_transition(7)
        self.assertEqual(len({output for _, output in transition}), len(transition))


if __name__ == "__main__":
    unittest.main()

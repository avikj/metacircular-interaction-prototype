import unittest

from temporal_acceleration_bounds import (
    TWELVE_YEAR_TO_TWELVE_HOUR_RATIO,
    break_even_uses,
    critical_path,
    independent_span,
    interpreted_cost,
    nested_span,
)


class TemporalAccelerationBoundTests(unittest.TestCase):
    def test_twelve_ternary_nesting(self):
        self.assertEqual(nested_span([3] * 12), 531441)

    def test_exact_rate_threshold(self):
        self.assertEqual(TWELVE_YEAR_TO_TWELVE_HOUR_RATIO, 8766)
        self.assertLess(nested_span([2] * 11 + [3]), 8766)
        self.assertGreater(nested_span([2] * 10 + [3] * 2), 8766)

    def test_independent_control_is_additive(self):
        self.assertEqual(independent_span([3] * 12), 36)

    def test_uncompiled_control_has_no_execution_gain(self):
        self.assertEqual(interpreted_cost([3] * 12), 531441)

    def test_break_even_is_strict_and_exact(self):
        self.assertEqual(break_even_uses(old_cost=8, new_cost=1, overhead=27), 4)
        self.assertIsNone(break_even_uses(old_cost=1, new_cost=1, overhead=0))

    def test_dependency_path_adds(self):
        self.assertEqual(critical_path([2, 3, 5, 7]), 17)


if __name__ == "__main__":
    unittest.main()

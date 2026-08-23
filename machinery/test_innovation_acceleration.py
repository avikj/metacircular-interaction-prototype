import unittest

from innovation_acceleration import (
    cumulative_work,
    nested_span,
    net_saving,
    throughput_gain,
)


class InnovationAccelerationTests(unittest.TestCase):
    def test_twelve_ternary_formations_exceed_twelve_elapsed_years(self):
        hourly_year = 12 * 365 * 24
        self.assertEqual(nested_span([3] * 12), 531441)
        self.assertGreater(nested_span([3] * 12), hourly_year)

    def test_twelve_binary_formations_do_not(self):
        hourly_year = 12 * 365 * 24
        self.assertEqual(cumulative_work([2] * 12), 4095)
        self.assertLess(cumulative_work([2] * 12), hourly_year)

    def test_independent_shortcuts_do_not_multiply(self):
        independent_span = sum([3] * 12)
        self.assertEqual(independent_span, 36)
        self.assertNotEqual(independent_span, nested_span([3] * 12))

    def test_amortization_boundary(self):
        self.assertLess(net_saving(old_cost=10, new_cost=2, future_uses=1,
                                   formation_cost=7, verification_cost=2), 0)
        self.assertGreater(net_saving(old_cost=10, new_cost=2, future_uses=2,
                                      formation_cost=7, verification_cost=2), 0)

    def test_gain_is_workload_relative(self):
        old = {"a": 10, "b": 10}
        new = {"a": 1, "b": 20}
        self.assertGreater(throughput_gain(old, new, {"a": .9, "b": .1}), 1)
        self.assertLess(throughput_gain(old, new, {"a": .1, "b": .9}), 1)


if __name__ == "__main__":
    unittest.main()

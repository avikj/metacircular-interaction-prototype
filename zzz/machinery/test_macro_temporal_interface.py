import unittest

from macro_temporal_interface import (
    endpoint_macro_preserves_trace,
    minimum_side_record_dimension,
    temporal_profile,
)


class MacroTemporalInterfaceTests(unittest.TestCase):
    def test_reset_macro_loses_intermediate_parity(self):
        successor = (1, 2, 3, 4, 5, 0)
        reset = (0, 0, 0, 0, 0, 0)
        parity = (0, 1, 0, 1, 0, 1)
        constant = (0,) * 6
        endpoint, traces = temporal_profile((successor, reset), (parity, constant))
        self.assertEqual(endpoint, reset)
        self.assertFalse(endpoint_macro_preserves_trace(endpoint, traces))
        self.assertEqual(minimum_side_record_dimension(endpoint, traces), 2)

    def test_invertible_endpoint_recovers_fixed_trace(self):
        successor = (1, 2, 3, 4, 5, 0)
        parity = (0, 1, 0, 1, 0, 1)
        endpoint, traces = temporal_profile((successor, successor), (parity, parity))
        self.assertTrue(endpoint_macro_preserves_trace(endpoint, traces))
        self.assertEqual(minimum_side_record_dimension(endpoint, traces), 1)

    def test_three_trace_values_require_qutrit_record(self):
        identity = (0, 1, 2, 3, 4, 5)
        reset = (0,) * 6
        mod3 = (0, 1, 2, 0, 1, 2)
        constant = (0,) * 6
        endpoint, traces = temporal_profile((identity, reset), (mod3, constant))
        self.assertEqual(minimum_side_record_dimension(endpoint, traces), 3)

    def test_endpoint_fibers_can_need_different_local_alphabets(self):
        endpoint = (0, 0, 1, 1, 1)
        traces = ((0,), (1,), (0,), (1,), (2,))
        self.assertEqual(minimum_side_record_dimension(endpoint, traces), 3)


if __name__ == "__main__":
    unittest.main()

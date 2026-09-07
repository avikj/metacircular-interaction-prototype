import unittest

from adaptive_trace_process import (
    TerminalResidueRecord,
    reconstruct_trace,
    terminal_record,
    trace_and_terminal_costs,
)
from adaptive_valuation_addition import adaptive_sum_valuation


class AdaptiveTraceProcessTests(unittest.TestCase):
    def test_terminal_record_reconstructs_every_step(self):
        for prime in (2, 3, 5):
            for height in range(7):
                certificate = adaptive_sum_valuation(1, prime**height - 1, prime)
                self.assertEqual(
                    reconstruct_trace(terminal_record(certificate)), certificate.steps
                )

    def test_zero_branch_is_one_explicit_flag(self):
        certificate = adaptive_sum_valuation(17, -17, 3)
        record = terminal_record(certificate)
        self.assertTrue(record.is_zero)
        self.assertEqual(reconstruct_trace(record), ())

    def test_trace_and_terminal_have_identical_fibers(self):
        chart = tuple((a, b) for a in range(-8, 9) for b in range(-8, 9))
        result = trace_and_terminal_costs(chart, 3)
        self.assertEqual(result["trace_outputs"], result["terminal_outputs"])

    def test_terminal_record_keeps_more_than_answer_only(self):
        first = terminal_record(adaptive_sum_valuation(1, 2, 3))
        second = terminal_record(adaptive_sum_valuation(2, 1, 3))
        self.assertEqual(first.depth, second.depth)
        self.assertNotEqual(first, second)

    def test_malformed_zero_record_rejected(self):
        with self.assertRaises(ValueError):
            reconstruct_trace(TerminalResidueRecord(3, 1, 0, 0, True))


if __name__ == "__main__":
    unittest.main()

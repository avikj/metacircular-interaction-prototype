import unittest

from machinery.kuttaka_trace_macro import (
    best_prefix_period, compile_repeated_block, replay,
)


class KuttakaTraceMacroTests(unittest.TestCase):
    def test_repeated_block_changes_bounded_next_action(self):
        result = best_prefix_period((1, 2) * 4)
        self.assertIsNotNone(result)
        self.assertEqual(result.block, (1, 2))
        self.assertEqual((result.quotient_cost, result.installed_cost), (8, 6))
        self.assertEqual(result.strict_gain, 2)
        self.assertEqual(result.macro_payload, replay((1, 2) * 4))

    def test_exact_threshold_formula(self):
        # gain=mr-(m+r)=(m-1)(r-1)-1
        for m, r in ((1, 5), (2, 2), (2, 3), (3, 2), (4, 4)):
            block = (7,) if m == 1 else tuple(range(1, m + 1))
            result = compile_repeated_block(block, r)
            self.assertEqual(result.strict_gain, (m - 1) * (r - 1) - 1)

    def test_no_repetition_no_macro(self):
        self.assertIsNone(best_prefix_period((4, 1, 3, 2, 5)))

    def test_repetition_can_be_semantic_without_cost_gain(self):
        result = compile_repeated_block((7,), 5)
        self.assertEqual(result.direct_payload, result.macro_payload)
        self.assertLess(result.strict_gain, 0)

    def test_invalid_quotient_rejected(self):
        with self.assertRaisesRegex(ValueError, "nonnegative"):
            compile_repeated_block((1, -1), 3)


if __name__ == "__main__":
    unittest.main()

import unittest

from machinery.ramanujan_sieve_ingestion import certified_ramanujan_rows
from machinery.wheel_metabolism_cycle import answer_from_rows, run_wheel_cycle


class WheelMetabolismCycleTests(unittest.TestCase):
    def test_three_queries_keep_direct_representation(self):
        result = run_wheel_cycle(30, (1, 2, 6))
        self.assertEqual(result.route, "old")
        self.assertEqual(result.charged_cost, 90)
        self.assertEqual(result.installed_cells, 0)
        self.assertEqual(result.answers, result.direct_controls)

    def test_four_queries_install_primitive_trace_cache(self):
        result = run_wheel_cycle(30, (1, 2, 6, 10))
        self.assertEqual(result.route, "compile")
        self.assertEqual(result.charged_cost, 104)
        self.assertEqual(result.installed_cells, 72)
        self.assertEqual(result.answers, result.direct_controls)

    def test_wrong_full_spectrum_control_leaks(self):
        rows = certified_ramanujan_rows(30)
        # Replace the primitive q=6 trace by the full Q[C6] regular trace.
        rows[6] = (6, 0, 0, 0, 0, 0)
        wrong = answer_from_rows(30, 2, rows)
        correct = run_wheel_cycle(30, (2, 2, 2, 2)).answers[0]
        self.assertNotEqual(wrong, correct)


if __name__ == "__main__":
    unittest.main()

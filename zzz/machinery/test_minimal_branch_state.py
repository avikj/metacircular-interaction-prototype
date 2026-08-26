import unittest

from minimal_branch_state import (
    branch_record_classes,
    reverse_tested_digits,
    tested_digits,
)


class MinimalBranchStateTests(unittest.TestCase):
    def test_digit_reconstructs_forward_and_reverse_schedule(self):
        for p in (2, 3, 5, 7):
            for digit in range(p):
                forward = tested_digits(digit, p)
                self.assertEqual(reverse_tested_digits(digit, p), forward[::-1])
                expected = digit + 1 if digit < p - 1 else p - 1
                self.assertEqual(len(forward), expected)

    def test_p_logical_outcomes_even_when_two_schedule_lengths_match(self):
        for p in (2, 3, 5, 7):
            records = branch_record_classes(p)
            self.assertEqual(len(records), p)
            self.assertNotEqual(p - 2, p - 1)
            self.assertEqual(len(records[p - 2]), len(records[p - 1]))


if __name__ == "__main__":
    unittest.main()


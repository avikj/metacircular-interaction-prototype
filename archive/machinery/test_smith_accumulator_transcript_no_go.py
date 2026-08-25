import unittest

from smith_accumulator_transcript_no_go import (
    accumulator_profile,
    final_certificate_view,
    recover_quotient_from_left,
)


class SmithAccumulatorTranscriptNoGoTests(unittest.TestCase):
    def test_closed_form_certificate(self):
        for q in range(20):
            left, diagonal, right = final_certificate_view(q)
            self.assertEqual(left, ((-q, 1), (-(2 * q + 1), 2)))
            self.assertEqual(diagonal, ((1, 0), (0, 14)))
            self.assertEqual(right, ((1, -7), (0, 1)))

    def test_left_entry_recovers_quotient(self):
        for q in range(30):
            left, _, _ = final_certificate_view(q)
            self.assertEqual(recover_quotient_from_left(left), q)

    def test_diagonal_erases_but_full_accumulator_preserves(self):
        profile = accumulator_profile(17)
        self.assertEqual(profile["diagonal_image_size"], 1)
        self.assertEqual(profile["diagonal_fiber"], 17)
        self.assertEqual(profile["right_diagonal_image_size"], 1)
        self.assertEqual(profile["full_view_image_size"], 17)
        self.assertEqual(profile["full_view_fiber"], 1)

    def test_recovery_profile(self):
        self.assertEqual(accumulator_profile(8)["recovered"], tuple(range(8)))


if __name__ == "__main__":
    unittest.main()

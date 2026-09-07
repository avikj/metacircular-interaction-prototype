import unittest
from fractions import Fraction

from ternary_grover_valuation import (
    UNIFORM,
    diffuse,
    identify_digit,
    phase_query,
    reconstruct,
    threshold_mark,
)


class TernaryGroverValuationTests(unittest.TestCase):
    def test_one_query_exactly_identifies_each_digit(self):
        for digit in range(3):
            found, final = identify_digit(digit)
            self.assertEqual(found, digit)
            self.assertEqual(final, tuple(Fraction(index == digit) for index in range(4)))

    def test_dummy_is_never_marked_and_one_candidate_is(self):
        depth = 4
        for residue in range(3**depth):
            prefix = 0
            for level in range(depth):
                marks = [threshold_mark(residue, prefix, level, digit, depth)
                         for digit in range(4)]
                self.assertEqual(sum(marks), 1)
                self.assertFalse(marks[3])
                digit = marks.index(True)
                prefix += digit * 3**level

    def test_full_residue_reconstruction_uses_k_queries(self):
        for depth in range(1, 5):
            for residue in range(3**depth):
                found, queries = reconstruct(residue, depth)
                self.assertEqual(found, residue)
                self.assertEqual(queries, depth)

    def test_diffusion_is_an_involution(self):
        states = [UNIFORM, phase_query(UNIFORM, 0), phase_query(UNIFORM, 2)]
        for state in states:
            self.assertEqual(diffuse(diffuse(state)), state)

    def test_invalid_digit_and_depth_fail_closed(self):
        with self.assertRaises(ValueError):
            identify_digit(3)
        with self.assertRaises(ValueError):
            reconstruct(0, 0)


if __name__ == "__main__":
    unittest.main()


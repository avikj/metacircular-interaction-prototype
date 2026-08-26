import unittest

from precision_memory_reallocation import (
    fixed_old_chart_after_transition,
    profile,
    transition_profiles,
)


class PrecisionMemoryReallocationTests(unittest.TestCase):
    def test_exact_transition_balance(self):
        for prime in (2, 3, 5, 7):
            for level in range(1, 5):
                frontier = prime ** (level + 1)
                before, after = transition_profiles(prime, level)
                self.assertEqual((before.image_size, before.environment_dimension),
                                 (prime**level, prime))
                self.assertEqual((after.image_size, after.environment_dimension),
                                 (frontier, 1))
                self.assertEqual(before.rectangular_capacity, frontier)
                self.assertEqual(after.rectangular_capacity, frontier)

    def test_single_unused_cell_is_explicit(self):
        before, after = transition_profiles(5, 2)
        self.assertEqual(before.unused_cells, 1)
        self.assertEqual(after.unused_cells, 0)

    def test_fixed_output_cannot_clear_environment(self):
        for prime in (2, 3, 5, 7):
            for level in range(1, 4):
                fixed = fixed_old_chart_after_transition(prime, level)
                self.assertEqual(fixed.environment_dimension, prime)
                self.assertEqual(fixed.image_size, prime**level)

    def test_formula_matches_literal_fibers(self):
        exact = profile(27, 9)
        self.assertEqual(exact.image_size, 9)
        self.assertEqual(exact.environment_dimension, 3)
        self.assertEqual(exact.unused_cells, 0)

    def test_malformed_profiles_fail_closed(self):
        for args in ((0, 3), (3, 0), (-1, 2)):
            with self.assertRaises(ValueError):
                profile(*args)


if __name__ == "__main__":
    unittest.main()


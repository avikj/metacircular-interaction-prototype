import unittest

from machinery.arithmetic_lefschetz import compile_multiplicative_lefschetz


class ArithmeticLefschetzTests(unittest.TestCase):
    def test_z15_doubling_character_and_sections(self):
        result = compile_multiplicative_lefschetz(15, 2, 4)
        self.assertEqual(result.traces, (15, 1, 3, 1))
        self.assertEqual(result.arithmetic_counts, result.enumerated_counts)
        self.assertEqual(result.orbit_count, 5)
        self.assertEqual(result.global_section_dimension, 5)

    def test_prime_modulus_control(self):
        result = compile_multiplicative_lefschetz(7, 2, 3)
        self.assertEqual(result.traces, (7, 1, 1))
        self.assertEqual(result.orbit_count, 3)

    def test_rejects_nonunit(self):
        with self.assertRaisesRegex(ValueError, "unit"):
            compile_multiplicative_lefschetz(15, 3, 4)

    def test_rejects_false_order(self):
        with self.assertRaisesRegex(ValueError, "group relation"):
            compile_multiplicative_lefschetz(15, 2, 3)

    def test_rejects_nonminimal_order(self):
        with self.assertRaisesRegex(ValueError, "not minimal"):
            compile_multiplicative_lefschetz(15, 2, 8)


if __name__ == "__main__":
    unittest.main()

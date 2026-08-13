import unittest

from machinery.ramanujan_crt_update import (
    compile_crt_wheel_update, extend_rows_by_prime,
)
from machinery.ramanujan_sieve_ingestion import certified_ramanujan_rows


class RamanujanCRTUpdateTests(unittest.TestCase):
    def test_30_to_210_exact_update(self):
        result = compile_crt_wheel_update(30, 7, 6)
        self.assertEqual(result.old_cells_reused, 72)
        self.assertEqual(result.new_cells_formed, 504)
        self.assertEqual(result.total_cells, 576)
        self.assertEqual(result.scratch_cells, 576)
        self.assertEqual(result.local_factor.numerator, 35)
        self.assertEqual(result.local_factor.denominator, 36)
        self.assertEqual(result.updated_correlation, result.rebuilt_correlation)
        self.assertEqual(result.updated_correlation.numerator, 175)
        self.assertEqual(result.updated_correlation.denominator, 64)

    def test_rejects_repeated_prime(self):
        rows = certified_ramanujan_rows(30)
        with self.assertRaisesRegex(ValueError, "new coprime prime"):
            extend_rows_by_prime(rows, 5)

    def test_rejects_composite_extension(self):
        with self.assertRaisesRegex(ValueError, "prime and coprime"):
            compile_crt_wheel_update(30, 49, 6)


if __name__ == "__main__":
    unittest.main()

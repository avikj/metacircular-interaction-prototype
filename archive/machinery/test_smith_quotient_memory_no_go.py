import unittest

from smith_quotient_memory_no_go import (
    first_record,
    minimum_controller_dimension,
    response_classes,
)


class SmithQuotientMemoryNoGoTests(unittest.TestCase):
    def test_coarse_record_is_constant(self):
        self.assertEqual(
            {first_record(q)[0] for q in range(20)},
            {("column-residual", 2, 1)},
        )

    def test_constructor_coefficients_are_all_distinct(self):
        self.assertEqual({first_record(q)[1] for q in range(10)}, set(range(-9, 1)))

    def test_exact_dimension_grows_with_family(self):
        for count in (1, 2, 7, 20):
            self.assertEqual(minimum_controller_dimension(count), count)

    def test_single_visible_fiber_contains_all_responses(self):
        self.assertEqual(
            response_classes(5),
            {("column-residual", 2, 1): frozenset({0, -1, -2, -3, -4})},
        )


if __name__ == "__main__":
    unittest.main()

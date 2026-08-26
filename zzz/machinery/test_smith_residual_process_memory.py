import unittest

from smith_residual_process_memory import (
    WITNESS_MATRICES,
    conditional_memory_dimension,
    first_typed_residual,
    scalar_cut_response_functions,
    scalar_residual_is_sufficient,
)


class SmithResidualProcessMemoryTests(unittest.TestCase):
    def test_three_states_collide_at_scalar_one(self):
        responses = scalar_cut_response_functions()
        self.assertEqual({residual for residual, _ in responses}, {1})
        self.assertEqual(
            {kind for _, kind in responses},
            {"column-residual", "row-residual", "divisibility-residual"},
        )

    def test_exact_conditional_dimension_is_three(self):
        self.assertEqual(conditional_memory_dimension(), 3)
        self.assertFalse(scalar_residual_is_sufficient())

    def test_typed_residual_attains_controller_record(self):
        records = {first_typed_residual(matrix) for matrix in WITNESS_MATRICES}
        self.assertEqual(len(records), 3)

    def test_removing_one_phase_reduces_dimension_not_obstruction(self):
        self.assertEqual(conditional_memory_dimension(WITNESS_MATRICES[:2]), 2)
        self.assertFalse(scalar_residual_is_sufficient(WITNESS_MATRICES[:2]))


if __name__ == "__main__":
    unittest.main()

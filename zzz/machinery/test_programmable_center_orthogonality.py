import unittest

from programmable_center_orthogonality import (
    center_program_qubits,
    exact_program_dimension,
    translation_permutation,
    translations_equal_up_to_phase,
)


class ProgrammableCenterOrthogonalityTests(unittest.TestCase):
    def test_distinct_modular_centers_are_distinct_unitaries(self):
        for modulus in range(2, 15):
            permutations = {
                translation_permutation(modulus, center)
                for center in range(modulus)
            }
            self.assertEqual(len(permutations), modulus)
            self.assertTrue(all(
                translations_equal_up_to_phase(modulus, center, center + modulus)
                for center in range(modulus)
            ))

    def test_full_center_language_needs_full_dimension(self):
        self.assertEqual(exact_program_dimension(81, range(81)), 81)
        self.assertEqual(center_program_qubits(81, range(81)), 7)

    def test_branch_center_subset_costs_its_cardinality(self):
        centers = (0, 9, 18, 27, 36, 45)
        self.assertEqual(exact_program_dimension(81, centers), 6)
        self.assertEqual(center_program_qubits(81, centers), 3)

    def test_modular_duplicates_do_not_add_program_states(self):
        self.assertEqual(exact_program_dimension(8, (0, 8, 1, 9)), 2)

    def test_empty_language_rejected(self):
        with self.assertRaises(ValueError):
            exact_program_dimension(8, ())


if __name__ == "__main__":
    unittest.main()

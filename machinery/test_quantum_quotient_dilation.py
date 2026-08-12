import unittest

from quantum_quotient_dilation import (
    coherent_environment_dimension,
    coherent_environment_qubits,
    measurement_environment_dimension,
    nested_residue_composition_certificate,
    quotient_composition_certificate,
    residue_dilation_certificate,
    residue_outputs,
)


class QuantumQuotientDilationTests(unittest.TestCase):
    def test_fiber_maximum_not_number_of_inputs(self):
        outputs = (0, 1, 0, 1, 0)
        self.assertEqual(coherent_environment_dimension(outputs), 3)
        self.assertEqual(coherent_environment_qubits(outputs), 2)
        self.assertEqual(measurement_environment_dimension(outputs), 5)

    def test_injective_map_needs_no_garbage_level(self):
        outputs = ("a", "b", "c")
        self.assertEqual(coherent_environment_dimension(outputs), 1)
        self.assertEqual(coherent_environment_qubits(outputs), 0)

    def test_constant_map_retains_every_input_distinction(self):
        outputs = (0, 0, 0, 0)
        self.assertEqual(coherent_environment_dimension(outputs), 4)
        self.assertEqual(measurement_environment_dimension(outputs), 4)

    def test_residue_formula(self):
        self.assertEqual(residue_outputs(10, 3), (0, 1, 2, 0, 1, 2, 0, 1, 2, 0))
        certificate = residue_dilation_certificate(10, 3)
        self.assertEqual(certificate["coherent_environment_dimension"], 4)
        self.assertEqual(certificate["measurement_environment_dimension"], 10)

    def test_arithmetic_life_encounter(self):
        certificate = residue_dilation_certificate(91, 7)
        self.assertEqual(certificate["coherent_environment_dimension"], 13)
        self.assertEqual(certificate["coherent_environment_qubits"], 4)

    def test_invalid_chart(self):
        with self.assertRaises(ValueError):
            residue_dilation_certificate(0, 7)

    def test_same_stage_costs_different_composite_costs(self):
        first = (0, 0, 1, 1, 2, 3)  # fiber sizes 2,2,1,1
        aligned = quotient_composition_certificate(first, (0, 0, 1, 1))
        mixed = quotient_composition_certificate(first, (0, 1, 0, 1))
        self.assertEqual(
            (aligned["first_stage_dimension"], aligned["second_stage_dimension"]),
            (2, 2),
        )
        self.assertEqual(
            (mixed["first_stage_dimension"], mixed["second_stage_dimension"]),
            (2, 2),
        )
        self.assertEqual(aligned["direct_composite_dimension"], 4)
        self.assertEqual(mixed["direct_composite_dimension"], 3)

    def test_nested_residue_garbage_compresses(self):
        certificate = nested_residue_composition_certificate(10, 6, 2)
        self.assertEqual(certificate["independent_register_dimension"], 6)
        self.assertEqual(certificate["direct_composite_dimension"], 5)
        self.assertEqual(certificate["redundant_levels"], 1)

    def test_balanced_nested_residue_has_no_dimension_overpayment(self):
        certificate = nested_residue_composition_certificate(12, 6, 2)
        self.assertEqual(certificate["independent_register_dimension"], 6)
        self.assertEqual(certificate["direct_composite_dimension"], 6)

    def test_nested_residue_requires_divisibility(self):
        with self.assertRaises(ValueError):
            nested_residue_composition_certificate(10, 6, 4)


if __name__ == "__main__":
    unittest.main()

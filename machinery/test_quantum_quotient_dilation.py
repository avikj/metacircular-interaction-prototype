import unittest

from quantum_quotient_dilation import (
    coherent_environment_dimension,
    coherent_environment_qubits,
    measurement_environment_dimension,
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


if __name__ == "__main__":
    unittest.main()

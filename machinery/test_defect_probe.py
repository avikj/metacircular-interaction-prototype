import unittest
from fractions import Fraction

from machinery.defect_probe import (
    QA,
    QB,
    compile_probe,
    derive_separator,
    derive_max_hamming_probe,
    hamming_distance,
    matvec,
    minimum_repetitions,
    ml_error_probability,
    multiplication_matrix,
    select_action,
)


class DefectProbeTests(unittest.TestCase):
    def setUp(self):
        self.a = multiplication_matrix(QA, tuple(reversed(QA)))
        self.b = multiplication_matrix(QB, tuple(reversed(QB)))

    def test_separator_is_derived_and_exact(self):
        vector = derive_separator(self.a, self.b)
        self.assertEqual(vector, (1, 0, 0, 1, 1, 1, 1, 1, 1, 0))
        self.assertEqual(matvec(self.a, vector), (0,) * 10)
        self.assertEqual(
            matvec(self.b, vector),
            (0, 1, 0, 0, 0, 0, 0, 1, 1, 1),
        )

    def test_compiled_outputs_select_different_actions(self):
        compiled = compile_probe()
        self.assertEqual(
            select_action(compiled, compiled.predicted_outputs["qA"]),
            "select-qA-decoder",
        )
        self.assertEqual(
            select_action(compiled, compiled.predicted_outputs["qB"]),
            "select-qB-decoder",
        )

    def test_unknown_and_malformed_measurements_fail_closed(self):
        compiled = compile_probe()
        with self.assertRaises(ValueError):
            select_action(compiled, (1,) * 10)
        with self.assertRaises(ValueError):
            select_action(compiled, (0,) * 9)

    def test_external_return_is_explicitly_missing(self):
        compiled = compile_probe()
        self.assertEqual(compiled.missing_external_record["status"], "NOT_MEASURED")
        self.assertIn(
            "No external device has been measured", compiled.trust_boundary
        )

    def test_unique_max_hamming_probe_is_derived(self):
        vector, distance, multiplicity = derive_max_hamming_probe(self.a, self.b)
        self.assertEqual(vector, (0, 1, 0, 1, 0, 1, 1, 1, 1, 1))
        self.assertEqual((distance, multiplicity), (10, 1))
        output_a, output_b = matvec(self.a, vector), matvec(self.b, vector)
        self.assertEqual(output_a, (1, 0, 1, 0, 0, 0, 1, 0, 1, 0))
        self.assertEqual(output_b, tuple(1-bit for bit in output_a))
        self.assertEqual(hamming_distance(output_a, output_b), 10)

    def test_exact_ml_error_including_ties(self):
        epsilon = Fraction(1, 10)
        # Odd distance three has no tie.
        self.assertEqual(
            ml_error_probability(3, epsilon),
            3 * epsilon**2 * (1-epsilon) + epsilon**3,
        )
        # The semantic kernel probe has distance four; randomized two-flip
        # ties happen to simplify to the same polynomial 3e^2-2e^3.
        self.assertEqual(
            ml_error_probability(4, epsilon),
            3 * epsilon**2 - 2 * epsilon**3,
        )
        self.assertEqual(
            ml_error_probability(2, epsilon),
            epsilon**2 + epsilon * (1-epsilon),
        )

    def test_exact_repetition_threshold(self):
        epsilon, target = Fraction(1, 10), Fraction(1, 1000)
        semantic_cost = minimum_repetitions(4, epsilon, target, 20)
        robust_cost = minimum_repetitions(10, epsilon, target, 20)
        self.assertEqual((semantic_cost, robust_cost), (3, 1))
        self.assertGreater(ml_error_probability(4, epsilon, 2), target)
        self.assertLessEqual(ml_error_probability(4, epsilon, 3), target)

    def test_noise_model_boundaries_fail_closed(self):
        with self.assertRaises(ValueError):
            ml_error_probability(3, Fraction(1, 2))
        with self.assertRaises(ValueError):
            minimum_repetitions(3, Fraction(1, 10), Fraction(1, 100), 0)


if __name__ == "__main__":
    unittest.main()

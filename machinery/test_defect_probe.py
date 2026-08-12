import unittest

from machinery.defect_probe import (
    QA,
    QB,
    compile_probe,
    derive_separator,
    matvec,
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


if __name__ == "__main__":
    unittest.main()

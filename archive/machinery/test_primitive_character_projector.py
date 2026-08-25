import unittest

from machinery.primitive_character_projector import (
    compile_primitive_projector,
    primitive_projector,
    rank_fraction,
)


class PrimitiveCharacterProjectorTests(unittest.TestCase):
    def test_q3_negative_trace_no_set_control(self):
        certificate = compile_primitive_projector(3)
        self.assertEqual(certificate.ramanujan_values, (2, -1, -1))
        self.assertLess(certificate.ramanujan_values[1], 0)

    def test_q12_projector_and_trace(self):
        certificate = compile_primitive_projector(12)
        self.assertEqual(certificate.projector_rank, 4)
        self.assertEqual(certificate.projected_traces,
                         (4, 0, 2, 0, -2, 0, -4, 0, -2, 0, 2, 0))
        self.assertEqual(certificate.projected_traces,
                         certificate.weighted_sector_traces)

    def test_prime_and_prime_power_ranks(self):
        self.assertEqual(rank_fraction(primitive_projector(5)), 4)
        self.assertEqual(rank_fraction(primitive_projector(8)), 4)

    def test_unweighted_regular_trace_is_false_control(self):
        certificate = compile_primitive_projector(6)
        regular = (6, 0, 0, 0, 0, 0)
        self.assertNotEqual(certificate.ramanujan_values, regular)

    def test_invalid_modulus_rejected(self):
        with self.assertRaisesRegex(ValueError, "at least two"):
            compile_primitive_projector(1)


if __name__ == "__main__":
    unittest.main()

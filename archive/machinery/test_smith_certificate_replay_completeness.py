import unittest

from smith_certificate_replay_completeness import (
    certificate_round_trip,
    reconstruct_source,
    replay_trace,
    unimodular_inverse,
)
from smith_residual_machine import IDENTITY, multiply, smith_reduce


class SmithCertificateReplayCompletenessTests(unittest.TestCase):
    def test_unimodular_inverse_both_signs(self):
        for matrix in (((1, 3), (2, 7)), ((0, 1), (1, 0)), ((-2, 1), (-5, 2))):
            inverse = unimodular_inverse(matrix)
            self.assertEqual(multiply(matrix, inverse), IDENTITY)
            self.assertEqual(multiply(inverse, matrix), IDENTITY)

    def test_round_trip_signed_singular_and_zero_cases(self):
        sources = (
            ((0, 0), (0, 0)),
            ((0, 6), (0, -9)),
            ((-12, 18), (30, -42)),
            ((84, 14), (30, 10)),
            ((2, 0), (19, 7)),
        )
        for source in sources:
            self.assertTrue(certificate_round_trip(source), source)

    def test_certificate_reconstructs_source_exactly(self):
        source = ((-17, 23), (41, -59))
        certificate = smith_reduce(source)
        self.assertEqual(
            reconstruct_source(certificate.left, certificate.diagonal, certificate.right),
            source,
        )

    def test_certificate_reconstructs_full_trace(self):
        source = ((84, 14), (30, 10))
        certificate = smith_reduce(source)
        self.assertEqual(
            replay_trace(certificate.left, certificate.diagonal, certificate.right),
            certificate.steps,
        )


if __name__ == "__main__":
    unittest.main()

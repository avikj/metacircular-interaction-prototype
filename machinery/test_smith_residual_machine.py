#!/usr/bin/env python3

import unittest
from itertools import product
from math import gcd

from smith_residual_machine import SmithCertificate, smith_reduce


class SmithResidualMachineTests(unittest.TestCase):
    def assertSmith(self, matrix, diagonal):
        certificate = smith_reduce(matrix)
        self.assertEqual(certificate.diagonal, diagonal)
        self.assertTrue(certificate.verify())
        pivots = [(s.pivot_before, s.pivot_after) for s in certificate.steps]
        self.assertTrue(all(0 < after < before for before, after in pivots))
        return certificate

    def test_arithmetic_life_example_closes(self):
        certificate = self.assertSmith(((84, 14), (30, 10)), ((2, 0), (0, 210)))
        self.assertGreaterEqual(len(certificate.steps), 1)

    def test_diagonal_residual_generates_next_operation(self):
        certificate = self.assertSmith(((6, 0), (0, 10)), ((2, 0), (0, 30)))
        self.assertEqual(certificate.steps[0].kind, "divisibility-residual")
        self.assertEqual(certificate.steps[0].residual, 4)

    def test_same_scalar_residual_requires_three_typed_actions(self):
        lower = smith_reduce(((2, 0), (1, 7))).steps[0]
        upper = smith_reduce(((2, 1), (0, 7))).steps[0]
        diagonal = smith_reduce(((2, 0), (0, 3))).steps[0]
        self.assertEqual({lower.residual, upper.residual, diagonal.residual}, {1})
        self.assertEqual(
            {lower.kind, upper.kind, diagonal.kind},
            {"column-residual", "row-residual", "divisibility-residual"},
        )

    def test_signed_zero_entry_and_singular_states(self):
        self.assertSmith(((0, -6), (0, 15)), ((3, 0), (0, 0)))
        self.assertSmith(((-2, 0), (5, 7)), ((1, 0), (0, 14)))
        self.assertSmith(((0, 0), (0, 0)), ((0, 0), (0, 0)))

    def test_rank_one_non_axis_matrix(self):
        self.assertSmith(((6, 9), (10, 15)), ((1, 0), (0, 0)))

    def test_fabricated_certificate_fails(self):
        real = smith_reduce(((6, 0), (0, 10)))
        fake = SmithCertificate(real.source, real.left, ((2, 0), (0, 10)), real.right, real.steps)
        self.assertFalse(fake.verify())

    def test_bounded_falsifier_all_signed_matrices(self):
        # Claim-anchored falsifier, not a census: every matrix in this box must
        # terminate and match the independently computed determinantal divisors.
        for entries in product(range(-3, 4), repeat=4):
            a, b, c, d = entries
            matrix = ((a, b), (c, d))
            certificate = smith_reduce(matrix)
            delta1 = gcd(gcd(abs(a), abs(b)), gcd(abs(c), abs(d)))
            determinant = abs(a * d - b * c)
            expected2 = determinant // delta1 if delta1 else 0
            self.assertEqual(certificate.diagonal, ((delta1, 0), (0, expected2)))
            self.assertTrue(certificate.verify())


if __name__ == "__main__":
    unittest.main()

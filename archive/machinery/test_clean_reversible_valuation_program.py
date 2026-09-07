import unittest

from clean_reversible_valuation_program import (
    clean_reconstruct,
    mutated_center_residual,
)


class CleanReversibleValuationProgramTests(unittest.TestCase):
    def test_every_residue_reconstructs_with_clean_ancilla(self):
        for prime, depth in ((2, 6), (3, 4), (5, 3)):
            for residue in range(prime**depth):
                run = clean_reconstruct(residue, prime, depth)
                self.assertEqual(run.residue, residue)
                self.assertEqual(run.response_ancilla, 0)
                self.assertEqual(run.oracle_invocations, 2 * depth * (prime - 1))

    def test_digits_are_the_only_retained_query_decisions(self):
        run = clean_reconstruct(73, 3, 4)
        self.assertEqual(run.retained_digits, (1, 0, 2, 2))
        self.assertEqual(sum(d * 3**i for i, d in enumerate(run.retained_digits)), 73)

    def test_mutating_center_before_unquery_leaves_garbage(self):
        self.assertNotEqual(mutated_center_residual(5, 2, 4, 3), 0)

    def test_invalid_parameters_rejected(self):
        with self.assertRaises(ValueError):
            clean_reconstruct(0, 1, 2)


if __name__ == "__main__":
    unittest.main()

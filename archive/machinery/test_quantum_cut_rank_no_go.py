import unittest
from fractions import Fraction

from quantum_cut_rank_no_go import qubit_process_table, separation_profile


class QuantumCutRankNoGoTests(unittest.TestCase):
    def test_qubit_born_table_is_exact(self):
        self.assertEqual(
            qubit_process_table(),
            (
                (1, 0, Fraction(1, 2), Fraction(1, 2)),
                (0, 1, Fraction(1, 2), Fraction(1, 2)),
                (Fraction(1, 2), Fraction(1, 2), 1, Fraction(1, 2)),
                (Fraction(1, 2), Fraction(1, 2), Fraction(1, 2), 1),
            ),
        )

    def test_equal_ordinary_rank_hides_quantum_separation(self):
        self.assertEqual(
            separation_profile(),
            {
                "qubit_ordinary_rank": 4,
                "qubit_quantum_dimension": 2,
                "identity_ordinary_rank": 4,
                "identity_quantum_dimension": 4,
            },
        )

    def test_qubit_table_is_not_rank_one(self):
        table = qubit_process_table()
        self.assertNotEqual(table[0][0] * table[1][1], table[0][1] * table[1][0])


if __name__ == "__main__":
    unittest.main()


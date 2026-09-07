import unittest

from arithmetic_witness_crystal import (
    STATES,
    append_digit,
    complete_to_multiple_of_three,
    shortest_completion_suffix,
    witness_forest,
)


class ArithmeticWitnessCrystalTests(unittest.TestCase):
    def test_forest_has_the_unique_non_immediate_pair(self):
        forest = witness_forest()
        self.assertEqual(set(forest), {(0, 1), (0, 2), (1, 2)})
        self.assertEqual(forest[(0, 1)].word, "")
        self.assertEqual(forest[(0, 2)].word, "")
        self.assertEqual(forest[(1, 2)].word, "1")

    def test_every_certificate_replays(self):
        for witness in witness_forest().values():
            self.assertEqual(witness.replay(), witness.terminal)
            self.assertNotEqual(*witness.responses)

    def test_shortest_completion_policy(self):
        self.assertEqual(
            {r: shortest_completion_suffix(r) for r in STATES},
            {0: "", 1: "1", 2: "01"},
        )

    def test_completion_operation(self):
        for n in range(30):
            completed, suffix = complete_to_multiple_of_three(n)
            self.assertEqual(completed % 3, 0)
            self.assertEqual(completed >> len(suffix), n)

    def test_no_fixed_suffix_serves_the_old_one_state_quotient(self):
        # Every fixed word induces an injective affine map on Z/3Z because 2
        # is invertible.  This bounded replay checks representative words.
        for word in ("", "0", "1", "00", "01", "10", "11"):
            outputs = []
            for remainder in STATES:
                state = remainder
                for digit in word:
                    state = append_digit(state, digit)
                outputs.append(state)
            self.assertEqual(len(set(outputs)), 3)


if __name__ == "__main__":
    unittest.main()

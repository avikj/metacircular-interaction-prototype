import unittest

from arity_quantum_memory_no_go import (
    memory_jump,
    proper_context_profile,
    residual,
    threshold,
    witness,
)


class ArityQuantumMemoryNoGoTests(unittest.TestCase):
    def test_proper_context_profiles_are_constant(self):
        for prime, arity in ((2, 3), (3, 4), (5, 6)):
            start = threshold(prime, arity) + 1
            profiles = {
                proper_context_profile(witness(prime, arity, exponent), prime)
                for exponent in range(start, start + 5)
            }
            self.assertEqual(len(profiles), 1)

    def test_full_context_reads_the_exponent(self):
        for prime, arity, exponent in ((2, 3, 4), (3, 4, 3), (5, 6, 5)):
            self.assertEqual(residual(witness(prime, arity, exponent), prime), exponent)

    def test_quantum_memory_jump_is_unbounded(self):
        self.assertEqual(
            memory_jump(3, 5, 9),
            {
                "histories": 9,
                "lower_arity_predictive_dimension": 1,
                "full_arity_predictive_dimension": 9,
            },
        )

    def test_bad_parameters_fail_closed(self):
        with self.assertRaises(ValueError):
            witness(2, 1, 3)
        with self.assertRaises(ValueError):
            memory_jump(2, 3, 0)


if __name__ == "__main__":
    unittest.main()


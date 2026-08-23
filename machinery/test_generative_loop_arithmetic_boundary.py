import unittest

from machinery.generative_loop_arithmetic_boundary import (
    UnaryTerm, coefficient_erasure_witness, projector_shape_term,
)


class GenerativeLoopArithmeticBoundaryTests(unittest.TestCase):
    def test_same_formal_shape_state_different_arithmetic_answers(self):
        witness = coefficient_erasure_witness(30)
        self.assertEqual(witness.left_term, UnaryTerm((1,)))
        self.assertEqual(witness.left_term, witness.right_term)
        self.assertEqual(witness.left_correlation, (30,) * 30)
        self.assertEqual(witness.right_correlation, (120,) * 30)

    def test_nonconstant_scalar_multiple_has_same_support(self):
        signal = tuple(int(i % 5 == 0) for i in range(30))
        doubled = tuple(2 * x for x in signal)
        self.assertEqual(projector_shape_term(signal), projector_shape_term(doubled))
        self.assertNotEqual(signal, doubled)


if __name__ == "__main__":
    unittest.main()

import unittest

from machinery.ramanujan_trace import (
    compile_ramanujan_trace, cyclotomic_polynomials, mobius,
)


class RamanujanTraceTests(unittest.TestCase):
    def test_q12_divisor_convolution_equals_cyclotomic_trace(self):
        result = compile_ramanujan_trace(12)
        self.assertEqual(result.cyclotomic, (1, 0, -1, 0, 1))
        self.assertEqual(result.values, (4, 0, 2, 0, -2, 0, -4, 0, -2, 0, 2, 0))
        self.assertEqual(result.values, result.spectral_traces)

    def test_prime_control(self):
        result = compile_ramanujan_trace(5)
        self.assertEqual(result.values, (4, -1, -1, -1, -1))

    def test_full_group_algebra_is_a_false_control(self):
        result = compile_ramanujan_trace(12)
        self.assertNotEqual(result.values, result.full_group_algebra_traces)
        self.assertEqual(result.full_group_algebra_traces[0], 12)
        self.assertEqual(result.values[0], 4)

    def test_cyclotomic_factorization_small(self):
        phis = cyclotomic_polynomials(6)
        self.assertEqual(phis[6], (1, -1, 1))

    def test_mobius_square_factor_control(self):
        self.assertEqual(mobius(12), 0)
        self.assertEqual(mobius(6), 1)


if __name__ == "__main__":
    unittest.main()

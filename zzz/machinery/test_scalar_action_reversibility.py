import unittest
from math import gcd


class ScalarActionReversibilityTests(unittest.TestCase):
    def test_integer_action_reverses_on_image(self):
        for n in range(1, 8):
            for mu in ((0, 1, 4), (3, 2, 9), (0, 0, 0)):
                out = tuple(n * x for x in mu)
                self.assertEqual(tuple(x // n for x in out), mu)

    def test_modular_fiber_size(self):
        for M in range(2, 13):
            for n in range(1, 13):
                fibers = {}
                for x in range(M):
                    fibers.setdefault((n * x) % M, []).append(x)
                occupied = [len(v) for v in fibers.values()]
                self.assertTrue(all(size == gcd(n, M) for size in occupied))

    def test_product_dimension(self):
        M, n, D = 12, 8, 2
        fibers = {}
        for x in range(M):
            for y in range(M):
                out = ((n * x) % M, (n * y) % M)
                fibers.setdefault(out, 0)
                fibers[out] += 1
        self.assertTrue(all(size == gcd(n, M)**D for size in fibers.values()))

    def test_false_control_nonunit_is_not_reversible(self):
        M, n = 6, 2
        self.assertEqual((n * 0) % M, (n * 3) % M)
        self.assertNotEqual(0, 3)


if __name__ == "__main__":
    unittest.main()

import unittest
from itertools import product
from math import gcd


def max_fiber(M, D, programs, keep):
    fibers = {}
    for n in programs:
        for x in product(range(M), repeat=D):
            y = tuple((n * a) % M for a in x)
            out = (n, y) if keep else y
            fibers[out] = fibers.get(out, 0) + 1
    return max(fibers.values())


class ProgrammableScalarDilationTests(unittest.TestCase):
    def test_exact_formulas(self):
        for M, D, programs in ((6, 1, (1, 2, 3)), (8, 2, (1, 2, 4)), (5, 2, (1, 2, 3))):
            sizes = [gcd(n, M)**D for n in programs]
            self.assertEqual(max_fiber(M, D, programs, True), max(sizes))
            self.assertEqual(max_fiber(M, D, programs, False), sum(sizes))

    def test_unequal_sectors_beat_crude_product(self):
        sizes = [1, 2, 3]
        self.assertEqual(sum(sizes), 6)
        self.assertLess(sum(sizes), len(sizes) * max(sizes))

    def test_equal_unit_sectors(self):
        M, programs = 5, (1, 2, 3, 4)
        self.assertEqual(max_fiber(M, 1, programs, True), 1)
        self.assertEqual(max_fiber(M, 1, programs, False), 4)

    def test_false_control_zero_witnesses_all_programs(self):
        M, programs = 6, (1, 2, 3)
        zero_fiber = sum(1 for n in programs for x in range(M) if n * x % M == 0)
        self.assertEqual(zero_fiber, 6)


if __name__ == "__main__":
    unittest.main()

import unittest
from functools import reduce
from math import gcd, lcm


def equalize(totals):
    L = lcm(*totals)
    return L, tuple(L // t for t in totals)


class IntegerRayEqualizationTests(unittest.TestCase):
    def test_lcm_equalization(self):
        for totals in ((2, 3), (2, 4, 5), (7, 7, 7), (4, 6, 9)):
            L, mult = equalize(totals)
            self.assertTrue(all(n * t == L for n, t in zip(mult, totals)))
            self.assertEqual(reduce(gcd, mult), 1)

    def test_every_other_common_mass_is_multiple(self):
        totals = (4, 6, 9)
        L, mult = equalize(totals)
        for q in range(1, 8):
            self.assertEqual(tuple(q * n for n in mult),
                             tuple((q * L) // t for t in totals))

    def test_exact_copy_excess(self):
        L, mult = equalize((2, 3))
        self.assertEqual((L, mult, sum(n - 1 for n in mult)), (6, (3, 2), 3))

    def test_false_control_product_overpays(self):
        totals = (4, 6)
        L, _ = equalize(totals)
        self.assertEqual(L, 12)
        self.assertNotEqual(L, 24)


if __name__ == "__main__":
    unittest.main()

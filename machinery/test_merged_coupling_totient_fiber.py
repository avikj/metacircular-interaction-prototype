import unittest
from math import gcd


def decompositions(T):
    return [((a, T-a), (T-a, a)) for a in range(1, T) if gcd(a, T) == 1]


class MergedCouplingTotientFiberTests(unittest.TestCase):
    def test_exact_characterization(self):
        for T in range(2, 30):
            ds = decompositions(T)
            self.assertTrue(all(tuple(x+y for x,y in zip(*pair)) == (T,T) for pair in ds))
            self.assertTrue(all(gcd(*v) == 1 for pair in ds for v in pair))
            self.assertEqual(len(ds), sum(gcd(a,T)==1 for a in range(1,T)))

    def test_unordered_halves_for_T_gt_2(self):
        for T in range(3, 20):
            unordered = {tuple(sorted(pair)) for pair in decompositions(T)}
            self.assertEqual(2*len(unordered), len(decompositions(T)))

    def test_false_control_nonunit_is_nonprimitive(self):
        T, a = 6, 2
        self.assertGreater(gcd(a, T-a), 1)


if __name__ == "__main__": unittest.main()

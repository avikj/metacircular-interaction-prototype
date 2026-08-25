import unittest
from fractions import Fraction
from itertools import permutations

from center_order_latency import expected_pair
from survival_path_dp import subset_optimum


class MonotoneLawOrderTests(unittest.TestCase):
    def test_canonical_separately_minimizes_both_coordinates(self):
        laws = (
            [Fraction(4, 10), Fraction(3, 10), Fraction(2, 10), Fraction(1, 10)],
            [Fraction(1, 4)] * 4,
            [Fraction(6, 10), Fraction(4, 10), Fraction(0), Fraction(0)],
        )
        for masses in laws:
            p = len(masses)
            canonical = tuple(range(p))
            cq, cs = expected_pair(canonical, masses)
            pairs = [expected_pair(order, masses) for order in permutations(range(p))]
            self.assertEqual(cq, min(q for q, _ in pairs))
            self.assertEqual(cs, min(s for _, s in pairs))
            self.assertEqual(cs, sum(d * masses[d] for d in range(p)))

    def test_every_scalarization_matches_subset_dp(self):
        masses = [Fraction(5, 15), Fraction(4, 15), Fraction(3, 15),
                  Fraction(2, 15), Fraction(1, 15)]
        canonical = tuple(range(5))
        q, s = expected_pair(canonical, masses)
        for lam in (Fraction(0), Fraction(1, 17), Fraction(1), Fraction(100)):
            self.assertEqual(subset_optimum(masses, lam)[0], q + lam * s)

    def test_pointwise_metric_bound(self):
        for order in permutations(range(4)):
            for d in range(4):
                position = order.index(d)
                stop = position if position < 3 else 3
                path = (0,) + order[:stop + 1]
                motion = sum(abs(b - a) for a, b in zip(path, path[1:]))
                self.assertGreaterEqual(motion, d)

    def test_false_control_nonmonotone_law(self):
        masses = [Fraction(2, 10), Fraction(7, 10), Fraction(1, 10)]
        canonical = expected_pair((0, 1, 2), masses)
        optimum = subset_optimum(masses, Fraction(1, 10))
        self.assertLess(optimum[0], canonical[0] + Fraction(1, 10) * canonical[1])
        self.assertEqual(optimum[1], (1, 0, 2))


if __name__ == "__main__":
    unittest.main()

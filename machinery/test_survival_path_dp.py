import unittest
from fractions import Fraction
from itertools import permutations

from center_order_latency import expected_pair
from survival_path_dp import permutation_optimum, subset_optimum, survival_cost


class SurvivalPathDPTests(unittest.TestCase):
    def test_survival_identity(self):
        masses = [Fraction(1, 10), Fraction(2, 10), Fraction(3, 10), Fraction(4, 10)]
        for order in permutations(range(4)):
            q, s = expected_pair(order, masses)
            self.assertEqual(survival_cost(order, masses, Fraction(3, 7)),
                             q + Fraction(3, 7) * s)

    def test_dp_against_all_permutations(self):
        laws = (
            [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)],
            [Fraction(4, 15), Fraction(3, 15), Fraction(2, 15), Fraction(6, 15)],
            [Fraction(1, 5)] * 5,
        )
        for masses in laws:
            for lam in (Fraction(0), Fraction(1, 10), Fraction(1), Fraction(7)):
                self.assertEqual(subset_optimum(masses, lam),
                                 permutation_optimum(masses, lam))

    def test_unique_interior_first_optimum(self):
        masses = [Fraction(2, 10), Fraction(7, 10), Fraction(1, 10)]
        value, order = subset_optimum(masses, Fraction(1, 10))
        self.assertEqual((value, order), (Fraction(29, 20), (1, 0, 2)))
        all_values = sorted(
            (survival_cost(o, masses, Fraction(1, 10)), o)
            for o in permutations(range(3))
        )
        self.assertGreater(all_values[1][0], all_values[0][0])
        self.assertNotIn(order[0], (0, 2))

    def test_false_control_dropping_omitted_motion(self):
        masses = [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)]
        order = (0, 1, 2)
        exact = survival_cost(order, masses, Fraction(1))
        # Stop before the final inferred-center edge.
        wrong = Fraction(19, 10) + Fraction(2, 10)
        self.assertNotEqual(exact, wrong)


if __name__ == "__main__":
    unittest.main()

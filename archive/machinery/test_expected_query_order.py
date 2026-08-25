import unittest
from fractions import Fraction
from itertools import permutations

from expected_query_order import (
    brute_force_optimum,
    formula_optimum,
    local_cost,
    optimal_local,
)


class ExpectedQueryOrderTests(unittest.TestCase):
    def test_local_rearrangement_against_every_schedule(self):
        for masses in (
            [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)],
            [Fraction(4, 10), Fraction(3, 10), Fraction(2, 10), Fraction(1, 10)],
        ):
            p = len(masses)
            brute = min(sum(masses[d] * local_cost(order, d) for d in range(p))
                        for order in permutations(range(p)))
            self.assertEqual(brute, optimal_local(masses))

    def test_correlated_digits_still_factor_prefixwise(self):
        distribution = {
            0: Fraction(2, 10), 1: Fraction(1, 10), 2: Fraction(1, 10),
            3: Fraction(1, 10), 4: Fraction(4, 10), 8: Fraction(1, 10),
        }
        self.assertEqual(formula_optimum(distribution, 3, 2),
                         brute_force_optimum(distribution, 3, 2))

    def test_smallest_geometry_conflict(self):
        masses = [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)]
        canonical = (0, 1, 2)
        canonical_cost = sum(masses[d] * local_cost(canonical, d) for d in range(3))
        optimum = optimal_local(masses)
        self.assertEqual(canonical_cost, Fraction(19, 10))
        self.assertEqual(optimum, Fraction(13, 10))
        optimal_orders = [
            order for order in permutations(range(3))
            if sum(masses[d] * local_cost(order, d) for d in range(3)) == optimum
        ]
        self.assertTrue(all(order[0] == 2 and order[1] < 2 for order in optimal_orders))

    def test_false_control_marginals_do_not_optimize_correlated_tree(self):
        distribution = {
            0: Fraction(9, 20), 1: Fraction(1, 20),
            3: Fraction(1, 20), 4: Fraction(9, 20),
        }
        exact = formula_optimum(distribution, 3, 2)
        # Reusing the unconditional second-digit marginal at both prefixes
        # pays 2 locally; conditioning makes each second digit certain.
        unconditional_second = optimal_local([
            sum(w for r, w in distribution.items() if (r // 3) % 3 == d)
            for d in range(3)
        ])
        wrong = optimal_local([
            sum(w for r, w in distribution.items() if r % 3 == d)
            for d in range(3)
        ]) + unconditional_second
        self.assertNotEqual(exact, wrong)


if __name__ == "__main__":
    unittest.main()

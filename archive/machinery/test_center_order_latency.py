import unittest
from fractions import Fraction
from itertools import permutations

from center_order_latency import expected_pair, local_costs, optimum, ternary_envelope


class CenterOrderLatencyTests(unittest.TestCase):
    def test_complete_ternary_table(self):
        masses = [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)]
        expected = {
            (0, 1, 2): (Fraction(19, 10), Fraction(16, 10)),
            (0, 2, 1): (Fraction(19, 10), Fraction(20, 10)),
            (1, 0, 2): (Fraction(18, 10), Fraction(32, 10)),
            (1, 2, 0): (Fraction(18, 10), Fraction(20, 10)),
            (2, 0, 1): (Fraction(13, 10), Fraction(28, 10)),
            (2, 1, 0): (Fraction(13, 10), Fraction(24, 10)),
        }
        self.assertEqual({o: expected_pair(o, masses) for o in permutations(range(3))}, expected)

    def test_symbolic_envelope_against_all_orders(self):
        laws = (
            [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)],
            [Fraction(6, 10), Fraction(3, 10), Fraction(1, 10)],
            [Fraction(2, 10), Fraction(7, 10), Fraction(1, 10)],
        )
        for masses in laws:
            for lam in (Fraction(0), Fraction(1, 10), Fraction(1), Fraction(10)):
                self.assertEqual(optimum(masses, lam)[0], ternary_envelope(masses, lam))

    def test_omitted_child_ends_at_learned_center(self):
        for order in permutations(range(4)):
            omitted = order[-1]
            # The cost includes every edge through the omitted endpoint.
            q, s = local_costs(order, omitted)
            path = (0,) + order
            self.assertEqual(q, 3)
            self.assertEqual(s, sum(abs(b - a) for a, b in zip(path, path[1:])))

    def test_false_control_omitting_final_motion_changes_optimum(self):
        masses = [Fraction(1, 10), Fraction(2, 10), Fraction(7, 10)]
        lam = Fraction(1)
        exact = optimum(masses, lam)[0]
        wrong = min(
            sum(masses[d] * (
                min(order.index(d) + 1, 2)
                + sum(abs(b - a) for a, b in zip((0,) + order[:min(order.index(d), 1) + 1],
                                                   ((0,) + order[:min(order.index(d), 1) + 1])[1:]))
            ) for d in range(3))
            for order in permutations(range(3))
        )
        self.assertNotEqual(exact, wrong)


if __name__ == "__main__":
    unittest.main()

import unittest
from itertools import product
from math import gcd

from kuttaka_pulverizer import (
    cell_from_kuttaka,
    is_solution,
    ista_section,
    pulverize,
    solution_family,
    valli_replay,
)
from diagonal_smith_congruence_torsor import classical_cell, mat_mul, diag


class PulverizerTest(unittest.TestCase):
    def test_bezout_identity_and_valli_replay_window(self):
        for a, b in product(range(-9, 10), repeat=2):
            if a == 0 and b == 0:
                continue
            valli, g, x, y = pulverize(a, b)
            self.assertEqual(g, gcd(a, b))
            self.assertEqual(a * x + b * y, g)
            self.assertTrue(valli_replay(a, b, valli))
            # valli length = Euclidean step count, and a wrong valli fails
            if len(valli) > 1:
                self.assertFalse(
                    valli_replay(a, b, [valli[0] + 1] + valli[1:])
                )

    def test_family_complete_on_window(self):
        a, b, c = 21, 15, 9
        g = gcd(a, b)
        family = set(solution_family(a, b, c, range(-30, 31)))
        brute = {
            (x, y)
            for x in range(-80, 81) for y in range(-120, 121)
            if is_solution(a, b, c, x, y)
        }
        # every brute solution in a central window lies in the family
        central = {(x, y) for x, y in brute if abs(x) <= 60}
        self.assertTrue(central <= family)
        self.assertTrue(all(is_solution(a, b, c, *s) for s in family))

    def test_ista_section_is_least_positive(self):
        for a, b, c in ((21, 15, 9), (7, 3, 1), (-14, 10, 4), (5, -8, 3)):
            g = gcd(a, b)
            if c % g:
                continue
            x, y = ista_section(a, b, c)
            self.assertTrue(is_solution(a, b, c, x, y))
            self.assertTrue(0 <= x < abs(b // g))

    def test_cell_agreement_with_classical_construction(self):
        """The pulverizer's cell and the branch's classical_cell are the
        same construction: identical endpoint, both unimodular, and they
        differ by a family shift (a point of the same fiber)."""
        for a, b in ((4, 6), (6, 4), (2, 3), (12, 18), (5, 5), (9, 6)):
            u, v, d = cell_from_kuttaka(a, b)
            self.assertEqual(mat_mul(mat_mul(u, diag(a, b)), v), d)
            u2, v2, d2 = classical_cell(a, b)
            self.assertEqual(d, d2)
            det = lambda m: m[0][0] * m[1][1] - m[0][1] * m[1][0]
            self.assertEqual(det(u), 1)
            self.assertEqual(det(v), 1)
            # same second row (-B, A): both are family members
            self.assertEqual(u[1], u2[1])


if __name__ == "__main__":
    unittest.main()

import unittest
from itertools import product

from smith_path_coordinate_torsor import (
    D_MATRIX,
    chart,
    chart_inverse,
    det2,
    in_transporter,
    intertwining,
    mat_mul,
    stab,
    stab_law,
    torsor_solution,
)

WINDOW = range(-6, 7)
SIGNS = (1, -1)


class StabilizerGroupTest(unittest.TestCase):
    def test_stabilizes_and_law(self):
        for b, e, b2, e2 in product(WINDOW, SIGNS, WINDOW, SIGNS):
            s1, s2 = stab(b, e), stab(b2, e2)
            self.assertEqual(mat_mul(s1, D_MATRIX), D_MATRIX)
            self.assertEqual(mat_mul(s1, s2), stab(*stab_law(b, e, b2, e2)))

    def test_reflections_are_involutions(self):
        for b in WINDOW:
            self.assertEqual(mat_mul(stab(b, -1), stab(b, -1)), stab(0, 1))

    def test_infinite_dihedral_presentation(self):
        # r = S_{0,-1}, t = S_{1,-1} are involutions with rt of infinite
        # order (translation): (rt)^n = S_{n, 1}.
        r, t = stab(0, -1), stab(1, -1)
        cursor = stab(0, 1)
        for n in range(1, 7):
            cursor = mat_mul(cursor, mat_mul(r, t))
            self.assertEqual(cursor, stab(n, 1))


class ChartTest(unittest.TestCase):
    def test_chart_bijection_on_window(self):
        seen = set()
        for k, s in product(WINDOW, SIGNS):
            u = chart_inverse(k, s)
            self.assertTrue(in_transporter(u))
            self.assertEqual(chart(u), (k, s))
            self.assertEqual(det2(u), s)
            seen.add(u)
        self.assertEqual(len(seen), len(WINDOW) * 2)

    def test_intertwining_law(self):
        for b, e, k, s in product(WINDOW, SIGNS, WINDOW, SIGNS):
            left = mat_mul(stab(b, e), chart_inverse(k, s))
            self.assertEqual(left, chart_inverse(*intertwining(b, e, k, s)))

    def test_free_and_transitive(self):
        big = range(-20, 21)
        for k, s, k2, s2 in product(WINDOW, SIGNS, WINDOW, SIGNS):
            solutions = [
                (b, e) for b in big for e in SIGNS
                if intertwining(b, e, k, s) == (k2, s2)
            ]
            self.assertEqual(solutions, [torsor_solution(k, s, k2, s2)])
        # freeness at the base point: only the identity fixes a chart value
        for k, s in product(WINDOW, SIGNS):
            fixers = [
                (b, e) for b in big for e in SIGNS
                if intertwining(b, e, k, s) == (k, s)
            ]
            self.assertEqual(fixers, [(0, 1)])


class MinimalityTest(unittest.TestCase):
    def test_dropping_sign_conflates_distinct_actions(self):
        for k in WINDOW:
            u_plus, u_minus = chart_inverse(k, 1), chart_inverse(k, -1)
            self.assertNotEqual(u_plus, u_minus)
            self.assertNotEqual(det2(u_plus), det2(u_minus))

    def test_dropping_integer_conflates_shear_family(self):
        for s in SIGNS:
            family = {chart_inverse(k, s) for k in WINDOW}
            self.assertEqual(len(family), len(WINDOW))

    def test_any_chart_identification_conflates_matrices(self):
        points = [(k, s) for k in WINDOW for s in SIGNS]
        for i, p in enumerate(points):
            for q in points[i + 1:]:
                self.assertNotEqual(chart_inverse(*p), chart_inverse(*q))


if __name__ == "__main__":
    unittest.main()

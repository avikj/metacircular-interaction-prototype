import unittest
from itertools import product
from math import gcd

from diagonal_smith_congruence_torsor import (
    classical_cell,
    conjugate_by_diag,
    det2,
    diag,
    in_gamma0,
    inv_unimodular,
    mat_mul,
    stabilizer_pair,
    torsor_act,
    two_sided_stabilizes,
)

WINDOW = range(-4, 5)
CELLS = [(4, 6), (6, 4), (2, 3), (12, 18), (5, 5), (3, 12)]


def gl2_window():
    for a, b, c, d in product(WINDOW, repeat=4):
        h = ((a, b), (c, d))
        if abs(det2(h)) == 1:
            yield h


class StabilizerCharacterizationTest(unittest.TestCase):
    def test_membership_iff_congruence(self):
        for d1, d2 in ((2, 6), (1, 6), (3, 3)):
            m = d2 // d1
            for h in gl2_window():
                if in_gamma0(h, m):
                    hh, k = stabilizer_pair(h, d1, d2)
                    self.assertEqual(abs(det2(k)), 1)
                    self.assertTrue(two_sided_stabilizes(hh, k, d1, d2))
                else:
                    solutions = [
                        k for k in gl2_window()
                        if two_sided_stabilizes(h, k, d1, d2)
                    ]
                    self.assertEqual(solutions, [])

    def test_one_sided_triviality_for_nonsingular(self):
        d = diag(2, 6)
        fixers = [h for h in gl2_window() if mat_mul(h, d) == d]
        self.assertEqual(fixers, [((1, 0), (0, 1))])


class ClassicalCellTest(unittest.TestCase):
    def test_cell_identity_and_unimodularity(self):
        for a, b in CELLS:
            u, v, d = classical_cell(a, b)
            self.assertEqual(det2(u), 1)
            self.assertEqual(det2(v), 1)
            self.assertEqual(mat_mul(mat_mul(u, diag(a, b)), v), d)
            g = gcd(a, b)
            self.assertEqual(d, diag(g, a * b // g))

    def test_bezout_shift_is_unipotent(self):
        for a, b in CELLS:
            g = gcd(a, b)
            m = (a * b) // (g * g)
            u0, v0, d = classical_cell(a, b)
            for t in WINDOW:
                ut, vt, _ = classical_cell(a, b, t)
                ht = mat_mul(ut, inv_unimodular(u0))
                self.assertEqual(ht, ((1, -t), (0, 1)))
                self.assertTrue(in_gamma0(ht, m))
                self.assertEqual(
                    vt,
                    mat_mul(v0, conjugate_by_diag(
                        inv_unimodular(ht), d[0][0], d[1][1]
                    )),
                )

    def test_gap_beyond_bezout(self):
        """diag(1,-1) is in Gamma_0(m) but not unipotent: it produces a
        lawful fiber point the Bezout ambiguity can never reach."""
        a, b = 4, 6
        u0, v0, d = classical_cell(a, b)
        h = ((1, 0), (0, -1))
        u, v = torsor_act(h, u0, v0, d[0][0], d[1][1])
        self.assertEqual(mat_mul(mat_mul(u, diag(a, b)), v), d)
        for t in range(-50, 51):
            ut, _, _ = classical_cell(a, b, t)
            self.assertNotEqual(u, ut)


class TorsorTest(unittest.TestCase):
    def test_action_free_and_lawful(self):
        a, b = 4, 6
        u0, v0, d = classical_cell(a, b)
        d1, d2 = d[0][0], d[1][1]
        m = d2 // d1
        seen = set()
        for h in gl2_window():
            if not in_gamma0(h, m):
                continue
            u, v = torsor_act(h, u0, v0, d1, d2)
            self.assertEqual(mat_mul(mat_mul(u, diag(a, b)), v), d)
            self.assertNotIn((u, v), seen)  # freeness
            seen.add((u, v))

    def test_transitivity_recovers_congruence_element(self):
        a, b = 12, 18
        u0, v0, d = classical_cell(a, b)
        d1, d2 = d[0][0], d[1][1]
        m = d2 // d1
        for t in WINDOW:
            ut, vt, _ = classical_cell(a, b, t)
            h = mat_mul(ut, inv_unimodular(u0))
            self.assertTrue(in_gamma0(h, m))
            self.assertEqual(
                torsor_act(h, u0, v0, d1, d2), (ut, vt)
            )


if __name__ == "__main__":
    unittest.main()

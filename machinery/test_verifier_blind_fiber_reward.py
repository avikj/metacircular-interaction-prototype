import unittest
from itertools import product

from hecke_coset_smith_assembly import det2, mat_mul
from total_smith_replay_payload import (
    elementary_divisors,
    is_event,
    payload,
    replay,
    section,
)
from verifier_blind_fiber_reward import (
    bezout_format,
    det_format,
    unipotent,
    verifier_observables,
    word_cost,
)

GRID = [((2, 0), (1, 7)), ((4, 6), (2, 8)), ((2, 0), (0, -3)),
        ((3, 5), (7, 2))]

WINDOW = range(-8, 9)


def window_events(mat, d):
    det_m = det2(mat)
    adj_m = ((mat[1][1], -mat[0][1]), (-mat[1][0], mat[0][0]))
    for a, b, c, e in product(WINDOW, repeat=4):
        u = ((a, b), (c, e))
        du = det2(u)
        if abs(du) != 1:
            continue
        ui = ((u[1][1] * du, -u[0][1] * du), (-u[1][0] * du, u[0][0] * du))
        num = mat_mul(mat_mul(adj_m, ui), d)
        if any(num[i][j] % det_m for i in range(2) for j in range(2)):
            continue
        v = tuple(tuple(num[i][j] // det_m for j in range(2))
                  for i in range(2))
        if abs(det2(v)) == 1:
            yield u, v


class TheoremATest(unittest.TestCase):
    def test_verifier_observables_constant_on_events(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            values = {verifier_observables(mat, u, v)
                      for u, v in window_events(mat, d)}
            self.assertEqual(len(values), 1, mat)


class TheoremBTest(unittest.TestCase):
    def test_det_format_gives_exactly_two_kernel_classes(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            classes = {}
            for u, v in window_events(mat, d):
                h = payload(u, u0)
                classes.setdefault(det_format(h), set()).add(h)
            self.assertEqual(set(classes), {1, -1}, mat)
            # pair law: det U * det V = sign(det M) on every event
            sign = 1 if det2(mat) > 0 else -1
            for u, v in window_events(mat, d):
                self.assertEqual(det2(u) * det2(v), sign)

    def test_bezout_format_conflates_gap_witnesses(self):
        mat = ((4, 6), (2, 8))
        u0, v0, d = section(mat)
        e1, e2 = elementary_divisors(mat)
        m = e2 // e1
        gap1 = ((1, 0), (0, -1))
        gap2 = ((1, 0), (m, 1))
        self.assertEqual(bezout_format(gap1), ("bottom",))
        self.assertEqual(bezout_format(gap2), ("bottom",))
        self.assertEqual(bezout_format(gap1), bezout_format(gap2))
        # while unipotents are perfectly discriminated
        values = {bezout_format(unipotent(t)) for t in range(-5, 6)}
        self.assertEqual(len(values), 11)

    def test_injective_format_replays(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            for u, v in window_events(mat, d):
                h = payload(u, u0)  # the injective format IS the payload
                self.assertEqual(replay(h, u0, v0, d), (u, v))
                self.assertTrue(is_event(u, v, mat, d))


class SectionMechanismTest(unittest.TestCase):
    def test_external_cost_separates_what_verifiers_conflate(self):
        """R0027 Section 4 executable: two events with identical verifier
        observables get different declared word costs."""
        mat = ((4, 6), (2, 8))
        u0, v0, d = section(mat)
        e1, e2 = elementary_divisors(mat)
        m = e2 // e1
        x = replay(unipotent(0), u0, v0, d)   # base event, cost 0
        y = replay(unipotent(2), u0, v0, d)   # two shifts away
        self.assertEqual(
            verifier_observables(mat, *x), verifier_observables(mat, *y)
        )
        cx = word_cost(payload(x[0], u0), m)
        cy = word_cost(payload(y[0], u0), m)
        self.assertEqual(cx, 0)
        self.assertEqual(cy, 2)
        self.assertNotEqual(cx, cy)


if __name__ == "__main__":
    unittest.main()

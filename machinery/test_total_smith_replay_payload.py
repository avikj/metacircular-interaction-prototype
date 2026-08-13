import unittest
from itertools import product

from total_smith_replay_payload import (
    elementary_divisors,
    in_gamma0,
    is_event,
    payload,
    replay,
    section,
)
from hecke_coset_smith_assembly import det2, mat_mul

GRID = [
    ((2, 0), (1, 7)),
    ((2, 1), (0, 7)),
    ((4, 6), (2, 8)),
    ((6, 4), (10, 12)),
    ((3, 5), (7, 2)),
    ((2, 0), (0, 3)),
    ((5, 0), (0, 5)),
]

# +-8 is needed: for M=((2,1),(0,7)) every event's U has an entry of
# magnitude at least 7, so smaller windows are empty there.
WINDOW = range(-8, 9)


def window_events(mat, d):
    for a, b, c, e in product(WINDOW, repeat=4):
        u = ((a, b), (c, e))
        if abs(det2(u)) != 1:
            continue
        # solve for V exactly: V = M^-1 U^-1 D over Q, test integrality
        det_m = det2(mat)
        adj_m = ((mat[1][1], -mat[0][1]), (-mat[1][0], mat[0][0]))
        ui = ((u[1][1] * det2(u), -u[0][1] * det2(u)),
              (-u[1][0] * det2(u), u[0][0] * det2(u)))
        num = mat_mul(mat_mul(adj_m, ui), d)
        if any(num[i][j] % det_m for i in range(2) for j in range(2)):
            continue
        v = tuple(tuple(num[i][j] // det_m for j in range(2))
                  for i in range(2))
        if abs(det2(v)) == 1:
            yield u, v


class SectionTest(unittest.TestCase):
    def test_section_is_event_with_predicted_endpoint(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            e1, e2 = elementary_divisors(mat)
            self.assertEqual(d, ((e1, 0), (0, e2)))
            self.assertTrue(is_event(u0, v0, mat, d))


class PayloadBijectionTest(unittest.TestCase):
    def test_every_window_event_has_gamma0_payload_and_replays(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            e1, e2 = elementary_divisors(mat)
            m = e2 // e1
            count = 0
            seen = set()
            for u, v in window_events(mat, d):
                self.assertTrue(is_event(u, v, mat, d))
                h = payload(u, u0)
                self.assertTrue(in_gamma0(h, m), (mat, u, h, m))
                self.assertEqual(replay(h, u0, v0, d), (u, v))
                self.assertNotIn(h, seen)  # injectivity
                seen.add(h)
                count += 1
            self.assertGreater(count, 0)

    def test_replay_of_gamma0_window_gives_events(self):
        for mat in GRID:
            u0, v0, d = section(mat)
            e1, e2 = elementary_divisors(mat)
            m = e2 // e1
            for a, b, cc, e in product(WINDOW, repeat=4):
                h = ((a, b), (cc, e))
                if abs(det2(h)) != 1 or h[1][0] % m:
                    continue
                u, v = replay(h, u0, v0, d)
                self.assertTrue(is_event(u, v, mat, d))
                self.assertEqual(payload(u, u0), h)


class SectionIndependenceTest(unittest.TestCase):
    def test_payload_differences_are_section_independent(self):
        mat = ((4, 6), (2, 8))
        u0, v0, d = section(mat)
        e1, e2 = elementary_divisors(mat)
        m = e2 // e1
        # alternative section: translate the canonical one by a fixed
        # Gamma_0(m) element
        g = ((1, 0), (m, 1))
        u1, v1 = replay(g, u0, v0, d)
        events = list(window_events(mat, d))[:6]
        from hecke_coset_smith_assembly import inv_unimodular
        for x, _ in events:
            for y, _ in events:
                d0 = mat_mul(payload(x, u0), inv_unimodular(payload(y, u0)))
                d1 = mat_mul(payload(x, u1), inv_unimodular(payload(y, u1)))
                self.assertEqual(d0, d1)


class SignRetentionTest(unittest.TestCase):
    def test_payload_carries_the_sign(self):
        """det U is payload data, not endpoint data: two events over the
        same M and D with det U = +1 and -1 have payloads differing in
        determinant."""
        mat = ((2, 0), (0, 3))
        u0, v0, d = section(mat)
        dets = set()
        for u, v in window_events(mat, d):
            dets.add(det2(u))
            h = payload(u, u0)
            self.assertEqual(det2(h), det2(u) * det2(u0))
        self.assertEqual(dets, {1, -1})


if __name__ == "__main__":
    unittest.main()

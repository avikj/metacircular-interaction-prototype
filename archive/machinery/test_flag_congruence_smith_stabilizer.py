import unittest
from itertools import product

from flag_congruence_smith_stabilizer import (
    conjugate_by_diag,
    det,
    diag,
    in_flag_gamma0_congruence,
    in_flag_gamma0_conjugation,
    inverse_unimodular,
    is_integral,
    mat_mul,
    stabilizer_partner,
    torsor_act,
    two_sided_stabilizes,
)

FLAGS = [(1, 2, 4), (1, 1, 6), (2, 2, 2)]


def unimodular_window():
    out = []
    for entries in product((-1, 0, 1), repeat=9):
        h = (entries[0:3], entries[3:6], entries[6:9])
        if abs(det(h)) == 1:
            out.append(h)
    return out


WINDOW = unimodular_window()


class DescriptionEquivalenceTest(unittest.TestCase):
    def test_congruence_iff_conjugation(self):
        for flag in FLAGS:
            for h in WINDOW:
                self.assertEqual(
                    in_flag_gamma0_congruence(h, flag),
                    in_flag_gamma0_conjugation(h, flag),
                    (h, flag),
                )

    def test_n2_matches_r0033_gamma0(self):
        from diagonal_smith_congruence_torsor import in_gamma0
        for d1, d2 in ((1, 6), (2, 6), (3, 3)):
            m = d2 // d1
            for a, b, c, e in product(range(-3, 4), repeat=4):
                h = ((a, b), (c, e))
                if abs(a * e - b * c) != 1:
                    continue
                self.assertEqual(
                    in_flag_gamma0_congruence(h, (d1, d2)),
                    in_gamma0(h, m),
                )


class GroupClosureTest(unittest.TestCase):
    def test_products_and_inverses_stay_members(self):
        flag = (1, 2, 4)
        members = [h for h in WINDOW
                   if in_flag_gamma0_congruence(h, flag)][:40]
        self.assertGreater(len(members), 5)
        for h in members:
            hi = inverse_unimodular(h)
            self.assertTrue(in_flag_gamma0_congruence(hi, flag))
        for h in members[:12]:
            for g in members[:12]:
                self.assertTrue(
                    in_flag_gamma0_congruence(mat_mul(h, g), flag)
                )


class StabilizerTest(unittest.TestCase):
    def test_members_stabilize_and_nonmembers_cannot(self):
        for flag in FLAGS:
            for h in WINDOW:
                if in_flag_gamma0_congruence(h, flag):
                    k = stabilizer_partner(h, flag)
                    self.assertEqual(abs(det(k)), 1)
                    self.assertTrue(two_sided_stabilizes(h, k, flag))
                else:
                    # the unique rational partner is non-integral
                    k = conjugate_by_diag(inverse_unimodular(h), flag)
                    self.assertFalse(is_integral(k))


class TorsorTest(unittest.TestCase):
    def test_events_freeness_and_payload_roundtrip(self):
        flag = (1, 2, 4)
        d = diag(flag)
        p = ((1, 1, 0), (0, 1, 1), (0, 0, 1))
        q = ((1, 0, 0), (1, 1, 0), (0, 1, 1))
        m = mat_mul(mat_mul(p, d), q)
        u0, v0 = inverse_unimodular(p), inverse_unimodular(q)
        self.assertEqual(mat_mul(mat_mul(u0, m), v0), d)
        members = [h for h in WINDOW
                   if in_flag_gamma0_congruence(h, flag)][:40]
        seen = set()
        for h in members:
            u, v = torsor_act(h, u0, v0, flag)
            self.assertEqual(mat_mul(mat_mul(u, m), v), d)
            self.assertNotIn((u, v), seen)
            seen.add((u, v))
            payload = mat_mul(u, inverse_unimodular(u0))
            self.assertEqual(payload, h)



class ElementaryCertificateTest(unittest.TestCase):
    def test_moduli_pinned_by_elementary_certificates(self):
        """Repair for window vacuity found by the blind audit: I + v E_ij
        is a member iff m_ij | v, with m_ij = |d_i|/gcd(d_i,d_j) — exact,
        O(1), window-independent.  Chains and non-chains."""
        from math import gcd as _gcd
        for flag in ((1, 2, 4), (2, 2, 2), (4, 6, 9), (6, 10, 15)):
            n = 3
            for i in range(n):
                for j in range(n):
                    if i == j:
                        continue
                    m_ij = abs(flag[i]) // _gcd(flag[i], flag[j])
                    for v in range(1, 13):
                        h = tuple(
                            tuple((1 if r == c else 0)
                                  + (v if (r, c) == (i, j) else 0)
                                  for c in range(n))
                            for r in range(n)
                        )
                        member = in_flag_gamma0_conjugation(h, flag)
                        self.assertEqual(member, v % m_ij == 0,
                                         (flag, i, j, v, m_ij))


if __name__ == "__main__":
    unittest.main()

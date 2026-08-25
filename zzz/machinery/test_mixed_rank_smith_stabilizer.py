import unittest
from itertools import product

from mixed_rank_smith_stabilizer import (
    blocks,
    exists_integral_partner,
    h_side_member,
    mixed_diag,
    one_sided_member,
    one_sided_stabilizes,
    partner,
    two_sided_stabilizes,
)
from flag_congruence_smith_stabilizer import det, mat_mul


def unimodular_2():
    out = []
    for a, b, c, d in product(range(-2, 3), repeat=4):
        h = ((a, b), (c, d))
        if abs(det(h)) == 1:
            out.append(h)
    return out


def unimodular_3():
    out = []
    for entries in product((-1, 0, 1), repeat=9):
        h = (entries[0:3], entries[3:6], entries[6:9])
        if abs(det(h)) == 1:
            out.append(h)
    return out


class TwoSidedTheoremTest(unittest.TestCase):
    def test_2x2_rank1_iff_with_brute_force(self):
        """Independent of the block derivation: for every unimodular H,
        membership <=> some unimodular K in a window satisfies HDK=D,
        and the constructed partner always works for members."""
        flag, n = (2,), 2
        ks = unimodular_2()
        for h in unimodular_2():
            member = h_side_member(h, flag)
            self.assertEqual(member, exists_integral_partner(h, flag, n))
            brute = any(two_sided_stabilizes(h, k, flag, n) for k in ks)
            if member:
                self.assertTrue(
                    two_sided_stabilizes(h, partner(h, flag, n), flag, n)
                )
                self.assertTrue(brute)
            else:
                self.assertFalse(brute)

    def test_3x3_iff_both_ranks(self):
        for flag in ((2,), (1, 3), (2, 4)):
            n = 3
            for h in unimodular_3():
                member = h_side_member(h, flag)
                self.assertEqual(
                    member, exists_integral_partner(h, flag, n), (h, flag)
                )
                if member:
                    self.assertTrue(
                        two_sided_stabilizes(h, partner(h, flag, n), flag, n)
                    )


class OneSidedCollapseTest(unittest.TestCase):
    def test_one_sided_iff_corner_identity(self):
        for flag, n, window in (((2,), 2, unimodular_2()),
                                ((1, 3), 3, unimodular_3())):
            for h in window:
                self.assertEqual(
                    one_sided_stabilizes(h, flag, n),
                    one_sided_member(h, flag),
                )

    def test_matches_r0032_dihedral_at_2x2(self):
        from smith_path_coordinate_torsor import stab
        flag, n = (1,), 2
        expected = {stab(b, e) for b in range(-2, 3) for e in (1, -1)}
        found = {
            h for h in unimodular_2() if one_sided_stabilizes(h, flag, n)
        }
        self.assertEqual(
            found,
            {h for h in expected
             if all(abs(x) <= 2 for row in h for x in row)},
        )


class ExtensionStructureTest(unittest.TestCase):
    def test_corner_map_is_homomorphism_with_parabolic_kernel(self):
        flag, n, r = (1, 3), 3, 2
        members = [h for h in unimodular_3() if h_side_member(h, flag)]
        self.assertGreater(len(members), 10)
        for h in members[:15]:
            for g in members[:15]:
                hg = mat_mul(h, g)
                self.assertTrue(h_side_member(hg, flag))
                ah, ag = blocks(h, r)[0], blocks(g, r)[0]
                self.assertEqual(blocks(hg, r)[0], mat_mul(ah, ag))
        kernel = [h for h in members
                  if blocks(h, r)[0] == ((1, 0), (0, 1))]
        # kernel elements: corner I, free B tail, unit E block
        self.assertGreater(len(kernel), 1)
        for h in kernel:
            _, _, c, e = blocks(h, r)
            self.assertTrue(all(x == 0 for row in c for x in row))
            self.assertEqual(abs(det(e)), 1)


if __name__ == "__main__":
    unittest.main()

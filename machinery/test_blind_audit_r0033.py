"""Hostile blind-audit tests for registry claim R0033 (fleet-blind-r0033).

Attacks, in the packet's own order of named audit joints:
  1. the integrality step (H^{-1})_21 = +-H_21 for BOTH determinant signs;
  2. the V-side law V = V0 D^{-1} H^{-1} D, verified by DIRECT computation
     on every fiber point in a window (not by torsor-completion
     uniqueness);
  3. negative / mixed-sign inputs: negative d1 or d2 (m = d2/d1 < 0),
     negative and mixed-sign (a, b) in the classical cell, the meaning of
     "m divides M_21" for m < 0, and what diag(g, ab/g) is when ab < 0.

All arithmetic exact; all finite checks exhaustive over stated windows.
"""

import unittest
from fractions import Fraction
from math import gcd

from blind_audit_r0033 import (
    I2, mmul, mdet, madj, minv_unimodular, is_unimodular, diag,
    conj_by_D, K_of_H, in_gamma0, unimodular_window,
    classical_cell, bezout_shift, fiber_action, fiber_points_in_window,
)

# diagonal test battery: every sign pattern of (d1, d2) with d1 | d2,
# including |m| = 1, prime m, composite m, negative m.
DIAGS = [
    (1, 1), (1, -1), (-1, 1), (-1, -1),          # |m| = 1
    (1, 2), (1, -2), (-1, 2), (-1, -2),          # |m| = 2
    (2, 6), (2, -6), (-2, 6), (-2, -6),          # |m| = 3
    (1, 6), (1, -6),                             # |m| = 6
    (3, 3), (-3, 3), (5, -5),                    # d2 = +-d1
    (4, 8), (-4, -8),                            # |m| = 2, |d1| > 1
]

W4 = unimodular_window(4)   # shared exhaustive GL_2(Z) window
W2 = unimodular_window(2)


class TestInverseCornerBothSigns(unittest.TestCase):
    """Audit joint 1: (H^{-1})_21 = +-H_21 for BOTH determinant signs."""

    def test_corner_identity_exhaustive(self):
        saw_plus = saw_minus = 0
        for H in W4:
            d = mdet(H)
            Hinv = minv_unimodular(H)
            # exact identity: (H^{-1})_21 = -det(H) * H_21
            self.assertEqual(Hinv[1][0], -d * H[1][0])
            self.assertEqual(abs(Hinv[1][0]), abs(H[1][0]))
            self.assertEqual(mmul(H, Hinv), I2)
            if d == 1:
                saw_plus += 1
            else:
                saw_minus += 1
        # both determinant signs genuinely exercised
        self.assertGreater(saw_plus, 0)
        self.assertGreater(saw_minus, 0)


class TestStabilizerIff(unittest.TestCase):
    """The characterization: K = D^{-1}H^{-1}D is integral (and then
    automatically unimodular with HDK = D) iff |m| divides H_21 —
    exhaustively, for every sign pattern of (d1, d2)."""

    def test_iff_over_window_all_sign_patterns(self):
        for d1, d2 in DIAGS:
            m = d2 // d1
            self.assertEqual(m * d1, d2)  # battery sanity: d1 | d2
            D = diag(d1, d2)
            hits = 0
            for H in W4:
                K = K_of_H(H, d1, d2)
                member = in_gamma0(H, m)
                self.assertEqual(
                    K is not None, member,
                    msg=f"iff fails at D=diag({d1},{d2}), H={H}")
                if K is not None:
                    hits += 1
                    self.assertTrue(is_unimodular(K))
                    self.assertEqual(mmul(H, mmul(D, K)), D)
                    self.assertEqual(mdet(K), mdet(H))
            self.assertGreater(hits, 0)

    def test_negative_m_divisibility_is_sign_blind(self):
        # m | x and |m| | x agree for every m != 0; the Gamma_0(m)
        # condition for negative m is exactly Gamma_0(|m|).
        for m in [-6, -3, -2, -1, 1, 2, 3, 6]:
            for x in range(-30, 31):
                self.assertEqual(x % m == 0, x % abs(m) == 0)

    def test_level_one_is_all_of_GL2_including_m_minus_one(self):
        # |m| = 1 (d2 = +-d1) gives the whole of GL_2(Z); the claim
        # names m = 1, but m = -1 behaves identically.
        for d1, d2 in [(1, 1), (3, 3), (1, -1), (-2, 2), (5, -5)]:
            for H in W2:
                self.assertIsNotNone(K_of_H(H, d1, d2))

    def test_pairs_enumeration_K_is_forced(self):
        # literal two-sided stabilizer over PAIRS: for every unimodular
        # (H, K) in the window with H D K = D, K equals D^{-1}H^{-1}D and
        # H in Gamma_0(m).  Exhaustive over window 2, positive and
        # negative m.
        for d1, d2 in [(1, 2), (1, -2), (-1, 2), (2, -6)]:
            m = d2 // d1
            D = diag(d1, d2)
            found = 0
            for H in W2:
                HD = mmul(H, D)
                for K in W2:
                    if mmul(HD, K) == D:
                        found += 1
                        self.assertEqual(K, K_of_H(H, d1, d2))
                        self.assertTrue(in_gamma0(H, m))
            self.assertGreater(found, 0)

    def test_out_of_scope_ratio_moves_the_condition(self):
        # hostile scope probe: d1 does NOT divide d2 (D = diag(2,1),
        # ratio 1/2).  The lower-left condition fails to characterize;
        # the true condition sits on the OTHER corner: 2 | (H^{-1})_12,
        # i.e. 2 | H_12.  Confirms the integrality hypothesis m in Z is
        # essential and direction-sensitive, not cosmetic.
        d1, d2 = 2, 1
        witness = ((1, 1), (0, 1))  # H_21 = 0 yet K non-integral
        self.assertIsNone(K_of_H(witness, d1, d2))
        for H in W4:
            K = K_of_H(H, d1, d2)
            self.assertEqual(K is not None, H[0][1] % 2 == 0,
                             msg=f"true condition for diag(2,1) at H={H}")


class TestStabilizerGroupStructure(unittest.TestCase):
    """The 'isomorphic to Gamma_0(m)' clause: the pair set is a group
    under (H1,K1)*(H2,K2) = (H1H2, K2K1) (GL x GL^op), and H -> (H, K(H))
    is an isomorphism for THAT product; it is NOT closed under the plain
    componentwise product."""

    def test_op_product_closure_and_iso(self):
        d1, d2 = 1, 2
        for H1 in W2:
            K1 = K_of_H(H1, d1, d2)
            if K1 is None:
                continue
            for H2 in W2:
                K2 = K_of_H(H2, d1, d2)
                if K2 is None:
                    continue
                H12 = mmul(H1, H2)
                self.assertEqual(K_of_H(H12, d1, d2), mmul(K2, K1))

    def test_componentwise_product_not_closed(self):
        d1, d2 = 1, 2
        D = diag(d1, d2)
        H1 = ((1, 0), (2, 1))
        H2 = ((1, 1), (0, 1))
        K1 = K_of_H(H1, d1, d2)
        K2 = K_of_H(H2, d1, d2)
        self.assertEqual(mmul(H1, mmul(D, K1)), D)
        self.assertEqual(mmul(H2, mmul(D, K2)), D)
        H12, K12 = mmul(H1, H2), mmul(K1, K2)
        self.assertNotEqual(mmul(H12, mmul(D, K12)), D)


class TestClassicalCellAllSigns(unittest.TestCase):
    """Audit joint 3: the cell identity, level formula, and d1 | d2 for
    EVERY sign pattern of (a, b), exhaustively over [-8,8]^2 \\ axes."""

    def test_cell_identity_exhaustive(self):
        for a in range(-8, 9):
            if a == 0:
                continue
            for b in range(-8, 9):
                if b == 0:
                    continue
                g, A, B, x, y, U0, V0, D = classical_cell(a, b)
                self.assertGreater(g, 0)
                self.assertEqual((A * g, B * g), (a, b))
                self.assertEqual(x * A + y * B, 1)
                self.assertEqual(mdet(U0), 1)
                self.assertEqual(mdet(V0), 1)
                # the literal identity, any signs:
                self.assertEqual(mmul(U0, mmul(diag(a, b), V0)), D)
                d1, d2 = D[0][0], D[1][1]
                self.assertEqual((d1, d2), (g, a * b // g))
                # d1 | d2 holds for every sign pattern...
                self.assertEqual(d2 % d1, 0)
                # ...and the level is m = AB = ab/g^2, NEGATIVE for
                # mixed signs:
                self.assertEqual(d2 // d1, A * B)
                self.assertEqual(A * B, (a * b) // (g * g))
                if a * b < 0:
                    self.assertLess(A * B, 0)
                    self.assertLess(d2, 0)  # NOT the normalized Smith
                    # form: second invariant factor off by a unit.

    def test_bezout_shift_is_the_claimed_unipotent(self):
        for a, b in [(2, 3), (2, -3), (-2, 3), (-2, -3),
                     (4, 6), (-4, 6), (12, -18), (-5, -5), (1, 1),
                     (7, -1), (-1, 9)]:
            g, A, B, x, y, U0, V0, D = classical_cell(a, b)
            d1, d2 = D[0][0], D[1][1]
            for t in range(-5, 6):
                Ut, Vt, Ht, Dc = bezout_shift(a, b, t)
                self.assertEqual(Dc, D)
                # shifted pair still solves the cell, det +1
                self.assertEqual(mmul(Ut, mmul(diag(a, b), Vt)), D)
                self.assertEqual(mdet(Ut), 1)
                self.assertEqual(mdet(Vt), 1)
                # H_t = ((1,-t),(0,1)) in Gamma_0(AB), and BOTH claimed
                # laws hold by direct computation:
                self.assertTrue(in_gamma0(Ht, A * B if A * B != 0 else 1))
                self.assertEqual(Ut, mmul(Ht, U0))
                Kt = K_of_H(Ht, d1, d2)
                self.assertIsNotNone(Kt)
                # D^{-1} H_t^{-1} D is the unipotent ((1, t*A*B), (0, 1))
                self.assertEqual(Kt, ((1, t * A * B), (0, 1)))
                self.assertEqual(Vt, mmul(V0, Kt))


class TestTorsor(unittest.TestCase):
    """Freeness and transitivity, with the V-side law checked directly
    (audit joint 2) — never via a uniqueness shortcut."""

    CASES = [(2, 3), (2, -3), (-4, 6), (-2, -4), (3, 5), (-6, -9)]

    def test_action_well_defined_and_left_action(self):
        for a, b in self.CASES:
            g, A, B, x, y, U0, V0, D = classical_cell(a, b)
            d1, d2 = D[0][0], D[1][1]
            m = d2 // d1
            M = diag(a, b)
            gamma = [H for H in W2 if in_gamma0(H, m)]
            self.assertGreater(len(gamma), 2)
            for H in gamma:
                U1, V1 = fiber_action(H, U0, V0, d1, d2)
                self.assertTrue(is_unimodular(U1))
                self.assertTrue(is_unimodular(V1))
                self.assertEqual(mmul(U1, mmul(M, V1)), D)
            # left-action axiom on a sample of pairs
            for H1 in gamma[:12]:
                for H2 in gamma[:12]:
                    lhs = fiber_action(mmul(H1, H2), U0, V0, d1, d2)
                    rhs = fiber_action(H1, *fiber_action(H2, U0, V0,
                                                         d1, d2), d1, d2)
                    self.assertEqual(lhs, rhs)

    def test_transitive_with_direct_V_law(self):
        # every fiber point in the window comes from H = U U0^{-1} in
        # Gamma_0(m), and V equals V0 D^{-1} H^{-1} D BY DIRECT
        # COMPUTATION.
        for a, b in self.CASES:
            g, A, B, x, y, U0, V0, D = classical_cell(a, b)
            d1, d2 = D[0][0], D[1][1]
            m = d2 // d1
            M = diag(a, b)
            pts = fiber_points_in_window(M, D, 6)
            self.assertGreater(len(pts), 1)
            for U, V in pts:
                H = mmul(U, minv_unimodular(U0))
                self.assertTrue(in_gamma0(H, m),
                                msg=f"(a,b)=({a},{b}) U={U}: H not Gamma_0")
                K = K_of_H(H, d1, d2)
                self.assertIsNotNone(K)
                self.assertEqual(mmul(H, U0), U)
                self.assertEqual(mmul(V0, K), V,
                                 msg=f"V-side law fails at (a,b)=({a},{b})")

    def test_free(self):
        for a, b in self.CASES:
            g, A, B, x, y, U0, V0, D = classical_cell(a, b)
            d1, d2 = D[0][0], D[1][1]
            m = d2 // d1
            for H in W2:
                if not in_gamma0(H, m) or H == I2:
                    continue
                self.assertNotEqual(fiber_action(H, U0, V0, d1, d2),
                                    (U0, V0))


class TestGapWitness(unittest.TestCase):
    """diag(1,-1) reaches a fiber point no Bezout shift reaches, and the
    under-parametrization persists even inside SL_2."""

    def test_diag_1_minus1_witness(self):
        a, b = 2, 3
        g, A, B, x, y, U0, V0, D = classical_cell(a, b)
        d1, d2 = D[0][0], D[1][1]
        H = ((1, 0), (0, -1))
        self.assertTrue(in_gamma0(H, A * B))
        U1, V1 = fiber_action(H, U0, V0, d1, d2)
        self.assertEqual(mmul(U1, mmul(diag(a, b), V1)), D)
        # every Bezout representative has det +1 (det U_t = x_t A + y_t B
        # = 1 identically), the witness has det -1: unreachable for ALL t.
        self.assertEqual(mdet(U1), -1)
        for t in range(-50, 51):
            Ut, Vt, _, _ = bezout_shift(a, b, t)
            self.assertEqual(mdet(Ut), 1)
            self.assertNotEqual((Ut, Vt), (U1, V1))

    def test_gap_already_inside_SL2(self):
        # stronger than the packet's witness: ((1,0),(AB,1)) has det +1,
        # lies in Gamma_0(AB), yet is no H_t — every U_t keeps second row
        # (-B, A), this one changes it.  The Bezout integer under-
        # parametrizes even the orientation-preserving fiber.
        a, b = 2, 3
        g, A, B, x, y, U0, V0, D = classical_cell(a, b)
        d1, d2 = D[0][0], D[1][1]
        H = ((1, 0), (A * B, 1))
        self.assertTrue(in_gamma0(H, A * B))
        self.assertEqual(mdet(H), 1)
        U1, V1 = fiber_action(H, U0, V0, d1, d2)
        self.assertEqual(mmul(U1, mmul(diag(a, b), V1)), D)
        self.assertNotEqual(U1[1], (-B, A))
        for t in range(-50, 51):
            Ut, _, _, _ = bezout_shift(a, b, t)
            self.assertEqual(Ut[1], (-B, A))
            self.assertNotEqual(Ut, U1)


class TestOneSidedAndNontriviality(unittest.TestCase):
    def test_one_sided_stabilizers_trivial(self):
        for d1, d2 in DIAGS:
            D = diag(d1, d2)
            left = [H for H in W2 if mmul(H, D) == D]
            right = [K for K in W2 if mmul(D, K) == D]
            self.assertEqual(left, [I2])
            self.assertEqual(right, [I2])

    def test_two_sided_never_trivial(self):
        for d1, d2 in DIAGS:
            m = d2 // d1
            negI = ((-1, 0), (0, -1))
            uni = ((1, 1), (0, 1))
            low = ((1, 0), (m, 1))
            for H in (negI, uni, low):
                K = K_of_H(H, d1, d2)
                self.assertIsNotNone(K)
                self.assertEqual(mmul(H, mmul(diag(d1, d2), K)),
                                 diag(d1, d2))
                self.assertNotEqual((H, K), (I2, I2))


if __name__ == "__main__":
    unittest.main()

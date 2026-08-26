"""Blind hostile audit of R0036 -- test battery (exact integers only).

Joints attacked, in the order R0036 states them:

  J1  K is forced: HDK = D  =>  K = D^{-1} H^{-1} D          (pair sweep)
  J2  Gamma_0(D) = {H : (d_i/d_j) | H_ij, i > j} for chains  (n=2 window +-4,
      n=3 window {-1,0,1})
  J3  Non-chain mutation: diag(2,3), diag(4,6,9), diag(6,10,15) -- the true
      condition is m_ij = |d_i| / gcd(d_i, d_j) | H_ij on BOTH sides of the
      diagonal, certified by exhaustive sweep + elementary certificates.
  J4  Window adequacy: the {-1,0,1} window at n=3 is DEGENERATE for (1,2,4)
      (all below-diagonal entries of members are 0), so it cannot pin the
      below-diagonal moduli; elementary certificates E_ij(v) do.
  J5  Negative chain entries (1,-2), (2,-6): everything is sign-blind, and
      Gamma_0 depends only on |d_i| / gcd(d_i, d_j).
  J6  Torsor: event set of a genuine M is free/transitive under the claimed
      action, payload is injective with the claimed inverse.
  J7  "All events share the same normalized D" -- FALSE as stated: for one M
      both diag(1,2) and diag(1,-2) (chains under R0036's hypothesis) occur.
  J8  Closure at n >= 3 does NOT need the flag relation d_i/d_j =
      (d_i/d_k)(d_k/d_j): the gcd-moduli are not multiplicative along the
      flag for (6,10,15), yet closure holds (intersection of groups).

Run: cd machinery && python3 -m unittest test_blind_audit_r0036 -v
"""

import unittest
from itertools import product

from blind_audit_r0036 import (
    identity, mat_mul, diag_mat, det, unimodular_inverse,
    divides, is_chain,
    conj_by_D, stabilizer_partner, in_stabilizer, in_gamma0_intersection,
    claimed_chain_condition, corner_moduli, general_corner_condition,
    modulus_condition,
    unimodular_2x2, unimodular_3x3, sweep_3x3,
    determinantal_divisors, elementary,
    partner_V, events_for, act, payload, unpayload,
)


# ---- shared exact enumerations, computed once ------------------------------

U2_B1 = list(unimodular_2x2(1))          # GL_2(Z), entries in {-1,0,1}
U2_B4 = list(unimodular_2x2(4))          # GL_2(Z), entries in [-4,4]
U3_B1 = list(unimodular_3x3(1))          # GL_3(Z), entries in {-1,0,1}

SWEEP_DS = [(1, 2, 4), (1, 1, 2), (1, 2, -4), (4, 6, 9), (6, 10, 15)]
SWEEP_TOTAL, SWEEP = sweep_3x3(1, [list(d) for d in SWEEP_DS])


class TestJ1PartnerForced(unittest.TestCase):
    """HDK = D over GL_n(Z)^2 forces K = D^{-1} H^{-1} D (Lemma A)."""

    def test_pair_sweep_n2(self):
        for D in ([1, 2], [2, 3], [1, -2]):
            Dm = diag_mat(D)
            hits = 0
            for H in U2_B1:
                HD = mat_mul(H, Dm)
                forced = stabilizer_partner(D, H)
                for K in U2_B1:
                    if mat_mul(HD, K) == Dm:
                        hits += 1
                        self.assertIsNotNone(forced)
                        self.assertEqual(K, forced)
            self.assertGreater(hits, 0)

    def test_forced_partner_really_stabilizes(self):
        for D in ([1, 2], [2, 3], [2, -6]):
            Dm = diag_mat(D)
            for H in U2_B4:
                K = stabilizer_partner(D, H)
                if K is not None:
                    self.assertEqual(mat_mul(mat_mul(H, Dm), K), Dm)
                    self.assertIn(det(K), (1, -1))


class TestJ2ChainDescription(unittest.TestCase):
    """For divisor chains the four membership tests agree exactly."""

    CHAINS_N2 = ([1, 1], [1, 2], [2, 4], [1, -2], [2, -6], [-2, 4], [-2, -6])

    def test_all_are_chains(self):
        for D in self.CHAINS_N2:
            self.assertTrue(is_chain(D), D)

    def test_n2_window_pm4_four_way_agreement(self):
        for D in self.CHAINS_N2:
            members = 0
            below_nonzero = 0
            for H in U2_B4:
                stab = in_stabilizer(D, H)
                self.assertEqual(stab, in_gamma0_intersection(D, H), (D, H))
                self.assertEqual(stab, general_corner_condition(D, H), (D, H))
                self.assertEqual(stab, claimed_chain_condition(D, H), (D, H))
                if stab:
                    members += 1
                    if H[1][0] != 0:
                        below_nonzero += 1
            self.assertGreater(members, 0)
            # the +-4 window at n=2 is NOT degenerate: it sees members with
            # nonzero below-diagonal entries even for modulus up to 4
            self.assertGreater(below_nonzero, 0, D)

    def test_n3_window_pm1_agreement(self):
        for D in SWEEP_DS:
            r = SWEEP[D]
            self.assertEqual(r["mismatch_stab_vs_derived"], [], D)
            self.assertEqual(r["mismatch_stab_vs_inter"], [], D)
            if is_chain(list(D)):
                self.assertEqual(r["mismatch_stab_vs_claimed"], [], D)
            self.assertGreater(r["count"], 0, D)


class TestJ3NonChainMutation(unittest.TestCase):
    """Non-chain diagonals: the description mutates to two-sided gcd moduli."""

    def test_true_moduli_tables(self):
        self.assertEqual(corner_moduli([2, 3]),
                         {(0, 1): 2, (1, 0): 3})
        self.assertEqual(corner_moduli([4, 6, 9]),
                         {(0, 1): 2, (0, 2): 4, (1, 0): 3,
                          (1, 2): 2, (2, 0): 9, (2, 1): 3})
        self.assertEqual(corner_moduli([6, 10, 15]),
                         {(0, 1): 3, (0, 2): 2, (1, 0): 5,
                          (1, 2): 2, (2, 0): 5, (2, 1): 3})

    def test_diag_2_3_window_sweep(self):
        D = [2, 3]
        members = 0
        for H in U2_B4:
            stab = in_stabilizer(D, H)
            self.assertEqual(stab, general_corner_condition(D, H), H)
            members += stab
        self.assertGreater(members, 0)

    def test_diag_2_3_above_diagonal_constraint_is_real(self):
        # A member with BOTH corners nonzero: 2 | H_12 and 3 | H_21.
        D = [2, 3]
        H = [[1, 2], [3, 7]]                       # det = 7 - 6 = 1
        self.assertTrue(in_stabilizer(D, H))
        # the chain-shaped mutant (below-diagonal only) admits false positives:
        bad = [[1, 1], [0, 1]]
        self.assertTrue(modulus_condition({(1, 0): 3}, bad))
        self.assertFalse(in_stabilizer(D, bad))    # 2 does not divide H_12 = 1

    def test_elementary_certificates_pin_every_modulus(self):
        # smallest v >= 1 with I + v E_ij in the stabilizer is exactly m_ij
        for D in ([2, 3], [4, 6, 9], [6, 10, 15], [1, 2, 4], [1, 2, -4]):
            n = len(D)
            for (i, j), m in corner_moduli(D).items():
                for v in range(1, 13):
                    self.assertEqual(in_stabilizer(D, elementary(n, i, j, v)),
                                     divides(m, v), (D, i, j, v))


class TestJ4WindowDegeneracy(unittest.TestCase):
    """{-1,0,1} at n=3 is degenerate for flag (1,2,4): below-diagonal
    divisibilities are vacuous inside the window."""

    def test_all_members_have_zero_below_diagonal(self):
        vals = SWEEP[(1, 2, 4)]["entry_vals"]
        for (i, j) in ((1, 0), (2, 0), (2, 1)):
            self.assertLessEqual(vals[(i, j)], {0}, (i, j))

    def test_member_count_is_exactly_the_triangular_count(self):
        # members in the window are precisely the upper-triangular unimodular
        # matrices with entries in {-1,0,1}: 2^3 sign diagonals * 3^3 uppers
        self.assertEqual(SWEEP[(1, 2, 4)]["count"], 2 ** 3 * 3 ** 3)

    def test_window_cannot_distinguish_below_moduli(self):
        # replace the below-diagonal moduli 2, 4, 2 by 997: membership inside
        # the window is UNCHANGED for every one of the |GL_3| window matrices,
        # so the {-1,0,1} sweep certifies nothing below the diagonal.
        true_mods = corner_moduli([1, 2, 4])
        mutant = dict(true_mods)
        for ij in ((1, 0), (2, 0), (2, 1)):
            mutant[ij] = 997
        for H in U3_B1:
            self.assertEqual(modulus_condition(true_mods, H),
                             modulus_condition(mutant, H), H)

    def test_partial_nondegeneracy_for_1_1_2(self):
        # modulus 1 below-diagonal entries DO move inside the window
        vals = SWEEP[(1, 1, 2)]["entry_vals"]
        self.assertIn(1, vals[(1, 0)])

    def test_certificates_restore_the_lost_information(self):
        D = [1, 2, 4]
        self.assertTrue(in_stabilizer(D, elementary(3, 1, 0, 2)))
        self.assertFalse(in_stabilizer(D, elementary(3, 1, 0, 1)))
        self.assertTrue(in_stabilizer(D, elementary(3, 2, 0, 4)))
        self.assertFalse(in_stabilizer(D, elementary(3, 2, 0, 2)))
        self.assertTrue(in_stabilizer(D, elementary(3, 2, 1, 2)))
        self.assertFalse(in_stabilizer(D, elementary(3, 2, 1, 1)))


class TestJ5SignBlindness(unittest.TestCase):
    """Negative chain entries change nothing: Gamma_0 sees |d_i|/gcd only."""

    def test_membership_identical_across_all_sign_patterns(self):
        base = [2, 6]
        signed = ([2, 6], [2, -6], [-2, 6], [-2, -6])
        for H in U2_B4:
            ref = in_stabilizer(base, H)
            for D in signed:
                self.assertEqual(in_stabilizer(D, H), ref, (D, H))
                self.assertEqual(claimed_chain_condition(D, H), ref, (D, H))

    def test_negative_chains_are_chains(self):
        for D in ([1, -2], [2, -6], [-2, -6], [1, 2, -4]):
            self.assertTrue(is_chain(D), D)


class TestJ6Torsor(unittest.TestCase):
    """Event set of M = [[1,1],[1,3]] (Smith |D| = (1,2)) under the action."""

    M = [[1, 1], [1, 3]]
    D = [1, 2]

    @classmethod
    def setUpClass(cls):
        cls.events = events_for(cls.M, cls.D, 3)

    def test_events_exist_and_are_events(self):
        self.assertGreater(len(self.events), 0)
        Dm = diag_mat(self.D)
        for U, V in self.events:
            self.assertEqual(mat_mul(mat_mul(U, self.M), V), Dm)
            self.assertIn(det(U), (1, -1))
            self.assertIn(det(V), (1, -1))

    def test_payload_lands_in_gamma0_and_is_injective_with_claimed_inverse(self):
        base = self.events[0]
        seen = set()
        for ev in self.events:
            H = payload(ev, base)
            self.assertTrue(in_stabilizer(self.D, H))       # transitivity
            key = tuple(map(tuple, H))
            self.assertNotIn(key, seen)                     # freeness/injectivity
            seen.add(key)
            self.assertEqual(unpayload(self.D, H, base), ev)  # claimed inverse

    def test_action_maps_events_to_events(self):
        Dm = diag_mat(self.D)
        base = self.events[0]
        gens = [elementary(2, 1, 0, 2), diag_mat([1, -1]), diag_mat([-1, 1])]
        for H in gens:
            U, V = act(self.D, H, base)
            self.assertEqual(mat_mul(mat_mul(U, self.M), V), Dm)
            self.assertEqual(payload((U, V), base), H)      # section of bijection

    def test_action_rejects_non_members(self):
        with self.assertRaises(ValueError):
            act(self.D, elementary(2, 1, 0, 1), self.events[0])


class TestJ7SharedNormalFormIsFalseAsStated(unittest.TestCase):
    """Under the stated hypothesis (nonzero d_i, d_i | d_j) the normalized D
    is NOT unique: sign flips give distinct chain diagonals for the same M."""

    M = [[1, 1], [1, 3]]

    def test_two_distinct_chain_diagonals_for_one_M(self):
        ev_pos = events_for(self.M, [1, 2], 3)
        ev_neg = events_for(self.M, [1, -2], 3)
        self.assertGreater(len(ev_pos), 0)
        self.assertGreater(len(ev_neg), 0)
        self.assertTrue(is_chain([1, 2]) and is_chain([1, -2]))
        self.assertNotEqual([1, 2], [1, -2])

    def test_what_is_actually_invariant(self):
        # determinantal divisors are GLxGL invariant and see only |d_i|
        g = determinantal_divisors(self.M)
        self.assertEqual(g, determinantal_divisors(diag_mat([1, 2])))
        self.assertEqual(g, determinantal_divisors(diag_mat([1, -2])))
        self.assertEqual(g, (1, 2))

    def test_all_sign_patterns_reachable(self):
        # (diag(eps) U, V) is an event for diag(eps) D -- all 2^n patterns
        for e0 in (1, -1):
            for e1 in (1, -1):
                D = [e0 * 1, e1 * 2]
                self.assertGreater(len(events_for(self.M, D, 3)), 0, D)
                self.assertTrue(is_chain(D))


class TestJ8ClosureWithoutFlagRelation(unittest.TestCase):
    """Closure of Gamma_0(D) never needs the flag relation; for non-chains
    the gcd moduli are NOT multiplicative along the flag, yet closure holds."""

    def test_flag_multiplicativity_fails_for_6_10_15(self):
        m = corner_moduli([6, 10, 15])
        self.assertEqual(m[(0, 1)] * m[(1, 2)], 6)
        self.assertEqual(m[(0, 2)], 2)          # 2 != 6: relation fails
        # a genuine member the flag-multiplied modulus would wrongly exclude:
        C = elementary(3, 0, 2, 2)
        self.assertTrue(in_stabilizer([6, 10, 15], C))
        flag_mutant = dict(m)
        flag_mutant[(0, 2)] = m[(0, 1)] * m[(1, 2)]
        self.assertFalse(modulus_condition(flag_mutant, C))

    def test_products_and_inverses_stay_members(self):
        for D in ([2, 3], [4, 6, 9], [6, 10, 15], [1, 2, 4], [1, 2, -4]):
            n = len(D)
            gens = [elementary(n, i, j, m)
                    for (i, j), m in corner_moduli(D).items()]
            gens += [diag_mat(list(eps))
                     for eps in product((1, -1), repeat=n)]
            for A in gens:
                Ai = unimodular_inverse(A)
                self.assertTrue(in_stabilizer(D, Ai), (D, A))
                for B in gens:
                    P = mat_mul(A, B)
                    stab = in_stabilizer(D, P)
                    self.assertTrue(stab, (D, A, B))
                    self.assertEqual(stab, general_corner_condition(D, P))


if __name__ == "__main__":
    unittest.main()

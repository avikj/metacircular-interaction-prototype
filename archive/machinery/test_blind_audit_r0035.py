"""Hostile blind-audit tests for R0035 (fleet-blind-r0035).

Derived exclusively from the registry statement; owner's derivation not
read.  Exact integer computation only.  Each test targets a named joint.

Run:  cd /home/user/math/machinery && python3 -m unittest test_blind_audit_r0035 -v
"""

import unittest

from blind_audit_r0035 import (
    I2, det2, mul, inv_unimodular, is_unimodular, smith_divisors,
    euclidean_normalizer, solve_V, is_event_U, unimodular_window,
    enumerate_events, minimal_window_bound, in_gamma0, conj_Dinv, act,
    payload, payload_inverse, sample_gamma0, section_euclid, section_lexmin,
)


def sgn(x):
    return (x > 0) - (x < 0)


# Grid: det<0, det>0, non-diagonal, repeated divisor (e1=e2), m=1, m>1.
GRID = [
    ((2, 1), (7, 5)),      # det  3, divisors (1, 3),  m = 3
    ((3, 1), (5, 1)),      # det -2, divisors (1, 2),  m = 2
    ((2, 0), (0, -3)),     # det -6, divisors (1, 6),  m = 6, diagonal-ish
    ((4, 6), (2, 8)),      # det 20, divisors (2, 10), m = 5
    ((2, 2), (0, 2)),      # det  4, divisors (2, 2),  m = 1 repeated
    ((6, 4), (8, 10)),     # det 28, divisors (2, 14), m = 7
    ((0, -1), (1, 0)),     # det  1, divisors (1, 1),  m = 1 unimodular
    ((5, 3), (7, -2)),     # det -31, divisors (1, 31), m = 31
]

WINDOW = 6


class TestNormalizerIsSection(unittest.TestCase):
    """Sanity: the independent Euclidean normalizer is a computable
    section (needed as the base event everywhere below)."""

    def test_normalizer(self):
        for M in GRID:
            U, V, D = euclidean_normalizer(M)
            e1, e2 = smith_divisors(M)
            self.assertEqual(D, ((e1, 0), (0, e2)))
            self.assertEqual(mul(mul(U, M), V), D)
            self.assertTrue(is_unimodular(U) and is_unimodular(V))


class TestJoint1_DeterminantClasses(unittest.TestCase):
    """Joint 1: GL_2 vs SL_2 reading.  Derived law:
    det U . det V = sign(det M), and det U alone takes BOTH values for
    every nonsingular M (diag(1,-1) in Gamma_0(m) for all m)."""

    def test_det_pair_law_exhaustive(self):
        for M in GRID:
            evts = enumerate_events(M, WINDOW)
            self.assertTrue(evts, f"no events in window for {M}")
            s = sgn(det2(M))
            for U, V in evts:
                self.assertEqual(det2(U) * det2(V), s,
                                 f"det pair law fails at M={M}, U={U}")

    def test_both_det_classes_occur_for_every_M(self):
        F = ((1, 0), (0, -1))          # det -1, in Gamma_0(m) for all m
        for M in GRID:
            e1, e2 = smith_divisors(M)
            U0, V0 = section_euclid(M)
            flipped = act(F, (U0, V0), e1, e2)
            self.assertIsNotNone(flipped)
            U1, V1 = flipped
            D = ((e1, 0), (0, e2))
            self.assertEqual(mul(mul(U1, M), V1), D)
            self.assertEqual(det2(U1), -det2(U0))
            # and both classes visible in a raw exhaustive window too
            dets = {det2(U) for U, _ in enumerate_events(M, WINDOW)}
            self.assertEqual(dets, {1, -1},
                             f"missing a det class for M={M}")

    def test_det_U_is_payload_data(self):
        # clause (d): det U = det(pi) det(U0), trivially, but check exactly
        for M in GRID:
            base = section_euclid(M)
            for ev in enumerate_events(M, WINDOW):
                pi = payload(ev, base)
                self.assertEqual(det2(ev[0]), det2(pi) * det2(base[0]))


class TestJoint2_EndpointUniqueness(unittest.TestCase):
    """Joint 2: 'every event has the same D'.  Positivity of the diagonal
    is load-bearing: with only ordering + divisibility, sign leaks."""

    def test_same_D_under_positive_convention(self):
        """Exhaustively: all diagonal outcomes U M V with positive
        divisibility-ordered diagonal equal diag(e1,e2)."""
        for M in GRID[:5]:
            e1, e2 = smith_divisors(M)
            found = set()
            for U in unimodular_window(3):
                for e1s in (e1, -e1):
                    for e2s in (e2, -e2):
                        Dc = ((e1s, 0), (0, e2s))
                        if solve_V(M, U, Dc) is not None:
                            found.add((e1s, e2s))
            # the positive endpoint occurs and is unique among positives
            positives = {d for d in found if d[0] > 0 and d[1] > 0}
            self.assertEqual(positives, {(e1, e2)})

    def test_sign_leak_without_positivity(self):
        """diag(-e1, e2) is reachable by unimodular (U', V') and satisfies
        the integer divisibility d1 | d2 — so 'normalized' must state
        positivity explicitly or clause (a) fails."""
        for M in GRID:
            U, V, D = euclidean_normalizer(M)
            e1, e2 = smith_divisors(M)
            Uf = mul(((-1, 0), (0, 1)), U)
            self.assertTrue(is_unimodular(Uf))
            Dneg = mul(mul(Uf, M), V)
            self.assertEqual(Dneg, ((-e1, 0), (0, e2)))
            # integer divisibility (-e1) | e2 holds:
            self.assertEqual(e2 % (-e1), 0)

    def test_order_is_forced_by_divisibility(self):
        """diag(e2, e1) (wrong order) violates d1 | d2 unless e1 = e2,
        so ordering does NOT leak — only sign does."""
        for M in GRID:
            e1, e2 = smith_divisors(M)
            if e1 == e2:
                continue
            self.assertEqual(e2 % e1, 0)      # right order divides
            self.assertNotEqual(e1 % e2, 0)   # wrong order does not


class TestJoint2b_TorsorRegularity(unittest.TestCase):
    """Clauses (b), (c): stabilizer is exactly Gamma_0(m) in GL_2(Z);
    action is well-defined, free, transitive; payload map bijective."""

    def test_action_lands_in_events(self):
        for M in GRID:
            e1, e2 = smith_divisors(M)
            m = e2 // e1
            D = ((e1, 0), (0, e2))
            base = section_euclid(M)
            for H in sample_gamma0(m, depth=3):
                ev = act(H, base, e1, e2)
                self.assertIsNotNone(ev)
                self.assertEqual(mul(mul(ev[0], M), ev[1]), D)
                self.assertTrue(is_unimodular(ev[0]))
                self.assertTrue(is_unimodular(ev[1]))

    def test_outside_gamma0_never_an_event(self):
        """Falsification direction: H unimodular with m ∤ c gives NO
        event with U-part H.U0 (V fails integrality)."""
        for M in GRID:
            e1, e2 = smith_divisors(M)
            m = e2 // e1
            if m == 1:
                continue          # Gamma_0(1) = GL_2(Z), nothing outside
            D = ((e1, 0), (0, e2))
            U0, _ = section_euclid(M)
            tested = 0
            for H in unimodular_window(3):
                if H[1][0] % m == 0:
                    continue
                tested += 1
                self.assertIsNone(solve_V(M, mul(H, U0), D),
                                  f"H outside Gamma_0({m}) gave an event, "
                                  f"M={M}, H={H}")
            self.assertGreater(tested, 0)

    def test_regular_torsor_on_window(self):
        """For every pair of enumerated events: transporter
        H = U' U^{-1} lies in Gamma_0(m), reproduces V' via the claimed
        action (transitive + the action formula is the right one), and
        is unique (free)."""
        for M in GRID:
            e1, e2 = smith_divisors(M)
            m = e2 // e1
            evts = enumerate_events(M, min(WINDOW, 5))
            self.assertGreaterEqual(len(evts), 2)
            for U1, V1 in evts:
                for U2, V2 in evts:
                    H = mul(U2, inv_unimodular(U1))
                    self.assertTrue(in_gamma0(H, m),
                                    f"transporter escapes Gamma_0({m})")
                    got = act(H, (U1, V1), e1, e2)
                    self.assertEqual(got, (U2, V2))
                    # freeness: H U1 = U1  =>  H = I
                    if H != I2:
                        self.assertNotEqual(mul(H, U1), U1)

    def test_payload_bijection(self):
        for M in GRID:
            e1, e2 = smith_divisors(M)
            m = e2 // e1
            base = section_euclid(M)
            evts = enumerate_events(M, min(WINDOW, 5))
            seen = set()
            for ev in evts:
                pi = payload(ev, base)
                self.assertTrue(in_gamma0(pi, m))
                self.assertNotIn(pi, seen)   # injective
                seen.add(pi)
                # claimed inverse recovers the event exactly
                self.assertEqual(payload_inverse(pi, base, e1, e2), ev)
            # surjectivity onto Gamma_0(m): every sampled H is a payload
            for H in sample_gamma0(m, depth=2):
                ev = payload_inverse(H, base, e1, e2)
                self.assertIsNotNone(ev)
                self.assertEqual(payload(ev, base), H)

    def test_action_is_a_left_action(self):
        """(H1 H2).x = H1.(H2.x) — composition law of clause (b)."""
        for M in GRID[:4]:
            e1, e2 = smith_divisors(M)
            m = e2 // e1
            base = section_euclid(M)
            Hs = sample_gamma0(m, depth=2)[:12]
            for H1 in Hs:
                for H2 in Hs:
                    lhs = act(mul(H1, H2), base, e1, e2)
                    rhs = act(H1, act(H2, base, e1, e2), e1, e2)
                    self.assertEqual(lhs, rhs)


class TestJoint3_SectionChange(unittest.TestCase):
    """Joint 3: direction of the translation.  Derived: new base
    U0' = H0 U0 gives pi' = pi H0^{-1} — a RIGHT translation by ONE fixed
    element per M.  Left translation would destroy invariance of the
    differences pi_i pi_j^{-1}."""

    def _payload_pairs(self, M):
        e1, e2 = smith_divisors(M)
        m = e2 // e1
        b1 = section_euclid(M)
        b2 = section_lexmin(M)
        self.assertNotEqual(b1, b2, f"sections coincide for M={M}; "
                            "pick a different grid entry")
        evts = enumerate_events(M, min(WINDOW, 5))
        pis1 = [payload(ev, b1) for ev in evts]
        pis2 = [payload(ev, b2) for ev in evts]
        return m, evts, pis1, pis2

    def test_right_translation_one_fixed_element(self):
        for M in GRID:
            m, evts, pis1, pis2 = self._payload_pairs(M)
            # right translator pi1^{-1} pi2 must be constant over events
            rights = {mul(inv_unimodular(p1), p2)
                      for p1, p2 in zip(pis1, pis2)}
            self.assertEqual(len(rights), 1,
                             f"right translator not constant for M={M}")
            T = rights.pop()
            self.assertTrue(in_gamma0(T, m))
            for p1, p2 in zip(pis1, pis2):
                self.assertEqual(p2, mul(p1, T))     # pi' = pi . T

    def test_not_left_translation(self):
        """The left 'translator' pi2 pi1^{-1} varies over events for at
        least one grid M: an author error of direction would be caught."""
        witnessed = False
        for M in GRID:
            _m, evts, pis1, pis2 = self._payload_pairs(M)
            lefts = {mul(p2, inv_unimodular(p1))
                     for p1, p2 in zip(pis1, pis2)}
            if len(lefts) > 1:
                witnessed = True
        self.assertTrue(witnessed,
                        "left translator constant everywhere: cannot "
                        "distinguish direction on this grid")

    def test_payload_differences_section_independent(self):
        for M in GRID:
            _m, evts, pis1, pis2 = self._payload_pairs(M)
            for i in range(len(evts)):
                for j in range(len(evts)):
                    d1 = mul(pis1[i], inv_unimodular(pis1[j]))
                    d2 = mul(pis2[i], inv_unimodular(pis2[j]))
                    self.assertEqual(d1, d2)
                    # and equals the section-free transporter U_i U_j^{-1}
                    self.assertEqual(
                        d1, mul(evts[i][0], inv_unimodular(evts[j][0])))

    def test_translator_is_per_M_not_global(self):
        """Scope probe: 'one fixed element' holds per M; across two M
        with the SAME divisors the translator generally differs."""
        # same divisors (1, 3) on purpose:
        same_div = [((2, 1), (7, 5)), ((1, 0), (0, 3)), ((3, 1), (3, 2)),
                    ((1, 2), (2, 7))]
        pairs = {}
        for M in same_div:
            e1, e2 = smith_divisors(M)
            self.assertEqual((e1, e2), (1, 3))
            b1 = section_euclid(M)
            b2 = section_lexmin(M)
            if b1 == b2:
                continue
            # per-M right translator T(M): pi' = pi . T(M), T = pi1(b2)
            pairs.setdefault((e1, e2), []).append((M, payload(b2, b1)))
        found_conflict = False
        for key, lst in pairs.items():
            ts = {t for _, t in lst}
            if len(ts) > 1:
                found_conflict = True
        print("\n[joint 3 scope] per-M translators, divisors (1,3):")
        for key, lst in pairs.items():
            for M, t in lst:
                print(f"  M={M}  T={t}")
        self.assertTrue(found_conflict,
                        "translators agreed across all same-divisor M; "
                        "grid too small to witness per-M scope")


class TestJoint4_WindowAdequacy(unittest.TestCase):
    """Joint 4: minimal entry bound of any event's U, certified by
    exhaustive enumeration (windows below the bound are provably empty)."""

    def test_minimal_bounds_certified(self):
        results = {}
        for M in GRID:
            B = minimal_window_bound(M, Bmax=20)
            self.assertIsNotNone(B)
            e1, e2 = smith_divisors(M)
            D = ((e1, 0), (0, e2))
            # certify emptiness strictly below B
            if B > 0:
                for U in unimodular_window(B - 1):
                    self.assertIsNone(solve_V(M, U, D))
            # and non-emptiness at B
            self.assertTrue(
                any(solve_V(M, U, D) is not None
                    for U in unimodular_window(B)))
            results[M] = B
        # at least two M must genuinely exercise the bound machinery
        self.assertGreaterEqual(len(results), 2)
        # print raw data for the audit report
        print("\n[joint 4] minimal U-entry bounds:")
        for M, B in results.items():
            e1, e2 = smith_divisors(M)
            print(f"  M={M}  divisors=({e1},{e2})  minimal bound B*={B} "
                  f"(window B*={B - 1 if B else '-'} exhaustively empty)")


class TestRepeatedDivisor(unittest.TestCase):
    """e1 = e2 (m = 1): Gamma_0(1) = GL_2(Z); every unimodular U is an
    event U-part."""

    def test_m_equals_one_full_group(self):
        for M in [((2, 2), (0, 2)), ((3, 0), (0, 3)), ((0, -1), (1, 0))]:
            e1, e2 = smith_divisors(M)
            self.assertEqual(e1, e2)
            D = ((e1, 0), (0, e2))
            for U in unimodular_window(2):
                self.assertIsNotNone(solve_V(M, U, D),
                                     f"m=1 but U={U} not an event, M={M}")


if __name__ == "__main__":
    unittest.main()

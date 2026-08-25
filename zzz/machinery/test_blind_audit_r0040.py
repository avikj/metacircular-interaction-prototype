"""Blind hostile audit tests for claim R0040 (fleet-blind-r0040).

Every test is an exact integer / exact polynomial computation.  Joints
named by the audit brief:
  1. the always-reduced lemma at its degenerate corners (b = 0, c = d);
  2. the second sum form S(m) = sum phi(c) sigma_1(m/c^2), rederived;
  3. the Dirichlet series / Euler factor, as polynomial identities;
  4. the "first divergence at m = 4" claim against six standard functions.
"""

import unittest
from math import gcd

from hecke_coset_smith_assembly import (
    divisors,
    sigma1,
    psi,
    hnf_bases,
    content,
    cyclic_bases,
    mat_mul,
    det2,
)
from blind_audit_r0040 import (
    phi,
    sigma_k,
    jordan2,
    factorize,
    square_divisor_roots,
    hnf_of_columns,
    basis_columns,
    divide_basis,
    scale_basis,
    index_of,
    is_reduced_hnf,
    sublattices_direct,
    phi_map,
    phi_inverse,
    S_direct,
    S_c_psi,
    S_phi_sigma,
    S_prime_power_closed,
    S_multiplicative,
    S_pk_polynomial,
    S_pk_closed_polynomial,
    poly_mul,
    poly_sub,
    ONE,
    ONE_PLUS_X,
    ONE_MINUS_X,
    ONE_MINUS_X2,
    ONE_MINUS_PX,
    ONE_MINUS_PX2,
)

M_EXHAUSTIVE = 60


class TestGroundTruthEnumeration(unittest.TestCase):
    """The Hermite enumeration itself, against an HNF-free ground truth."""

    def test_direct_subgroup_enumeration_matches_hnf(self):
        # index-m sublattices contain mZ^2; enumerate subgroups of (Z/m)^2
        # of order m by brute force, canonicalize with hnf_of_columns.
        for m in range(1, 13):
            direct = sublattices_direct(m)
            hnf = set(hnf_bases(m))
            self.assertEqual(direct, hnf, "m=%d" % m)
            self.assertEqual(len(hnf), sigma1(m), "m=%d" % m)

    def test_hnf_of_columns_is_canonical(self):
        # re-canonicalizing an HNF basis (in scrambled generator form)
        # returns it unchanged, for every basis to m <= M_EXHAUSTIVE
        for m in range(1, M_EXHAUSTIVE + 1):
            for basis in hnf_bases(m):
                (a, _), (b, d) = basis
                cols = [(a, b), (0, d), (a, b + d), (-a, -b)]
                self.assertEqual(hnf_of_columns(cols), basis)


class TestJoint1AlwaysReducedLemma(unittest.TestCase):
    """Joint 1: the divided corner is claimed already reduced, via
    'b and d are distinct multiples of c with b < d, so b <= d - c'."""

    def test_inequality_chain_hypotheses(self):
        # The chain needs: c | b, c | d, b < d (strict), hence d - b >= c.
        # b = 0 is a multiple of every c, and 0 <= b < d makes b, d always
        # distinct — verify all three facts and the conclusion exhaustively.
        for m in range(1, M_EXHAUSTIVE + 1):
            for basis in hnf_bases(m):
                (a, _), (b, d) = basis
                c = content(basis)
                self.assertEqual(b % c, 0, basis)
                self.assertEqual(d % c, 0, basis)
                self.assertLess(b, d, basis)          # distinct, ordered
                self.assertLessEqual(b, d - c, basis)  # the claimed step
                self.assertLessEqual(0, b // c, basis)
                self.assertLessEqual(b // c, d // c - 1, basis)

    def test_divided_basis_is_reduced_and_canonical(self):
        # ((a/c,0),(b/c,d/c)) must equal the canonical HNF of (1/c)L
        # computed independently from scratch (no shortcut).
        for m in range(1, M_EXHAUSTIVE + 1):
            for basis in hnf_bases(m):
                c = content(basis)
                shortcut = divide_basis(basis, c)
                self.assertTrue(is_reduced_hnf(shortcut), basis)
                cols = [(x // c, y // c) for (x, y) in basis_columns(basis)]
                self.assertEqual(hnf_of_columns(cols), shortcut, basis)
                self.assertEqual(content(shortcut), 1, basis)
                self.assertEqual(index_of(shortcut) * c * c, m, basis)

    def test_corner_b_zero(self):
        # b = 0: b is a multiple of c and b < d still holds (0 < d);
        # the divided basis must be ((a/c,0),(0,d/c)).
        cases = [(2, 0, 4), (6, 0, 4), (4, 0, 2), (9, 0, 3), (12, 0, 2)]
        for a, b, d in cases:
            basis = ((a, 0), (b, d))
            c = gcd(gcd(a, b), d)
            self.assertEqual(content(basis), c)
            got = phi_map(basis)
            self.assertEqual(got, (c, ((a // c, 0), (0, d // c))), basis)

    def test_corner_c_equals_d(self):
        # c = d forces b = 0 (b in [0,d) a multiple of d) and d | a.
        # Construct all such L for m <= 400 and check the formula there.
        found = 0
        for m in range(1, 401):
            for basis in hnf_bases(m):
                (a, _), (b, d) = basis
                c = content(basis)
                if c == d:
                    found += 1
                    self.assertEqual(b, 0, basis)
                    self.assertEqual(a % d, 0, basis)
                    got_c, got_div = phi_map(basis)
                    self.assertEqual(got_c, c)
                    self.assertEqual(got_div, ((a // c, 0), (0, 1)), basis)
                    self.assertEqual(divide_basis(basis, c), got_div, basis)
        # the degenerate corner genuinely occurs (e.g. m=4: a=2,b=0,d=2)
        self.assertGreater(found, 0)
        self.assertEqual(content(((2, 0), (0, 2))), 2)  # explicit witness

    def test_no_c_equals_d_with_nonzero_b(self):
        # sanity: the degenerate corner cannot occur with b != 0
        for m in range(1, M_EXHAUSTIVE + 1):
            for basis in hnf_bases(m):
                (a, _), (b, d) = basis
                if content(basis) == d:
                    self.assertEqual(b, 0, basis)


class TestBijection(unittest.TestCase):
    """Claim (i): Phi is a bijection onto the disjoint union, inverse
    (c, L') -> c L'."""

    def test_phi_bijection_exhaustive(self):
        for m in range(1, M_EXHAUSTIVE + 1):
            images = [phi_map(basis) for basis in hnf_bases(m)]
            # target: disjoint union over c^2 | m of cyclic index-(m/c^2)
            target = set()
            for c in square_divisor_roots(m):
                for cb in cyclic_bases(m // (c * c)):
                    target.add((c, cb))
            self.assertEqual(len(images), len(set(images)), "m=%d" % m)
            self.assertEqual(set(images), target, "m=%d" % m)

    def test_inverse_both_ways(self):
        for m in range(1, M_EXHAUSTIVE + 1):
            for basis in hnf_bases(m):
                c, cb = phi_map(basis)
                self.assertEqual(phi_inverse(c, cb), basis)
            for c in square_divisor_roots(m):
                for cb in cyclic_bases(m // (c * c)):
                    back = phi_inverse(c, cb)
                    self.assertEqual(index_of(back), m)
                    self.assertEqual(phi_map(back), (c, cb))

    def test_fiber_counts_are_psi(self):
        # claim (iii): #{L : e_1(L) = c} = psi(m/c^2), and 0 if c^2 does
        # not divide m
        for m in range(1, M_EXHAUSTIVE + 1):
            fibers = {}
            for basis in hnf_bases(m):
                c = content(basis)
                fibers[c] = fibers.get(c, 0) + 1
            for c in range(1, m + 1):
                expected = psi(m // (c * c)) if m % (c * c) == 0 else 0
                self.assertEqual(fibers.get(c, 0), expected, (m, c))
            self.assertEqual(sum(fibers.values()), sigma1(m))

    def test_refined_sigma1_identity(self):
        for m in range(1, 401):
            self.assertEqual(
                sigma1(m),
                sum(psi(m // (c * c)) for c in square_divisor_roots(m)),
            )


class TestEquivariance(unittest.TestCase):
    """Claim (iv): e_1(gamma L) = e_1(L) and scaling commutes with gamma."""

    GENS = [((0, -1), (1, 0)), ((1, 1), (0, 1)), ((1, -1), (0, 1)),
            ((1, 0), (1, 1)), ((2, 1), (1, 1)), ((5, 2), (2, 1))]

    def test_e1_invariant_and_phi_equivariant(self):
        for gamma in self.GENS:
            self.assertEqual(det2(gamma), 1)
        for m in range(1, 25):
            for basis in hnf_bases(m):
                c, cb = phi_map(basis)
                cols = basis_columns(basis)
                for gamma in self.GENS:
                    gcols = [
                        (gamma[0][0] * x + gamma[0][1] * y,
                         gamma[1][0] * x + gamma[1][1] * y)
                        for (x, y) in cols
                    ]
                    gbasis = hnf_of_columns(gcols)
                    self.assertEqual(index_of(gbasis), m)
                    gc, gcb = phi_map(gbasis)
                    self.assertEqual(gc, c)  # e_1(gamma L) = e_1(L)
                    # (1/c)(gamma L) = gamma ((1/c) L)
                    gcb_cols = [
                        (gamma[0][0] * x + gamma[0][1] * y,
                         gamma[1][0] * x + gamma[1][1] * y)
                        for (x, y) in basis_columns(cb)
                    ]
                    self.assertEqual(gcb, hnf_of_columns(gcb_cols))


class TestJoint2SecondSumForm(unittest.TestCase):
    """Joint 2: S(m) = sum_{c^2|m} phi(c) sigma_1(m/c^2), rederived from
    e_1 = sum_{c | e_1} phi(c)."""

    def test_totient_divisor_sum(self):
        # the identity the rederivation rests on: n = sum_{c|n} phi(c)
        for n in range(1, 1001):
            self.assertEqual(n, sum(phi(c) for c in divisors(n)))

    def test_counting_step(self):
        # #{L index m : c | e_1(L)} = sigma_1(m/c^2) if c^2 | m else 0
        # (these are exactly the L contained in c Z^2, i.e. c times an
        # arbitrary index-(m/c^2) sublattice)
        for m in range(1, M_EXHAUSTIVE + 1):
            for c in range(1, m + 1):
                count = sum(
                    1 for basis in hnf_bases(m) if content(basis) % c == 0
                )
                expected = sigma1(m // (c * c)) if m % (c * c) == 0 else 0
                self.assertEqual(count, expected, (m, c))

    def test_three_routes_agree_exhaustively(self):
        for m in range(1, 501):
            s = S_direct(m)
            self.assertEqual(s, S_c_psi(m), "m=%d" % m)
            self.assertEqual(s, S_phi_sigma(m), "m=%d" % m)

    def test_two_sum_forms_agree_further(self):
        for m in range(1, 2001):
            self.assertEqual(S_c_psi(m), S_phi_sigma(m), "m=%d" % m)

    def test_many_square_divisors_m36_m144(self):
        # m = 36: c in {1,2,3,6}
        self.assertEqual(square_divisor_roots(36), [1, 2, 3, 6])
        s36_cpsi = 1 * psi(36) + 2 * psi(9) + 3 * psi(4) + 6 * psi(1)
        s36_phis = (phi(1) * sigma1(36) + phi(2) * sigma1(9)
                    + phi(3) * sigma1(4) + phi(6) * sigma1(1))
        self.assertEqual(s36_cpsi, 72 + 24 + 18 + 6)      # = 120
        self.assertEqual(s36_phis, 91 + 13 + 2 * 7 + 2)   # = 120
        self.assertEqual(S_direct(36), 120)
        # m = 144: c in {1,2,3,4,6,12}
        self.assertEqual(square_divisor_roots(144), [1, 2, 3, 4, 6, 12])
        s = (1 * psi(144) + 2 * psi(36) + 3 * psi(16) + 4 * psi(9)
             + 6 * psi(4) + 12 * psi(1))
        s2 = (phi(1) * sigma1(144) + phi(2) * sigma1(36) + phi(3) * sigma1(16)
              + phi(4) * sigma1(9) + phi(6) * sigma1(4) + phi(12) * sigma1(1))
        self.assertEqual(s, S_direct(144))
        self.assertEqual(s2, S_direct(144))


class TestJoint3DirichletSeries(unittest.TestCase):
    """Joint 3: multiplicativity, prime-power closed form, Euler factor."""

    def test_multiplicative_on_coprime_pairs(self):
        for m1 in range(1, 201):
            for m2 in range(m1, 201):
                if gcd(m1, m2) == 1:
                    self.assertEqual(
                        S_c_psi(m1 * m2), S_c_psi(m1) * S_c_psi(m2),
                        (m1, m2),
                    )

    def test_not_multiplicative_blindly(self):
        # sanity that the test above has teeth: S is NOT completely
        # multiplicative (S(4) != S(2)^2)
        self.assertNotEqual(S_c_psi(4), S_c_psi(2) ** 2)

    def test_prime_power_closed_form(self):
        for p in (2, 3, 5, 7, 11):
            for k in range(0, 9):
                self.assertEqual(
                    S_prime_power_closed(p, k), S_c_psi(p ** k), (p, k)
                )
        # and directly against lattice enumeration for small prime powers
        for p, kmax in ((2, 8), (3, 5), (5, 3), (7, 2)):
            for k in range(0, kmax + 1):
                self.assertEqual(
                    S_prime_power_closed(p, k), S_direct(p ** k), (p, k)
                )

    def test_multiplicative_assembly_matches(self):
        for m in range(1, 501):
            self.assertEqual(S_multiplicative(m), S_c_psi(m), "m=%d" % m)

    def test_closed_form_polynomial_identity(self):
        # S(p^k) as a polynomial in Z[p]: c-psi sum vs (p-1)-divided
        # closed form, exact coefficientwise, k up to 60
        for k in range(0, 61):
            self.assertEqual(
                S_pk_polynomial(k), S_pk_closed_polynomial(k), "k=%d" % k
            )

    def test_euler_factor_zeta_quotient_identity(self):
        # Euler factor of zeta(s)zeta(s-1)zeta(2s-1)/zeta(2s) at p, with
        # x = p^{-s}:  (1-x^2)/((1-x)(1-px)(1-px^2)).  Claimed equal to
        # (1+x)/((1-px)(1-px^2)).  Cross-multiplied polynomial identity
        # in Z[p,x]:
        lhs = poly_mul(ONE_MINUS_X2, poly_mul(ONE_MINUS_PX, ONE_MINUS_PX2))
        rhs = poly_mul(
            ONE_PLUS_X,
            poly_mul(ONE_MINUS_X,
                     poly_mul(ONE_MINUS_PX, ONE_MINUS_PX2)),
        )
        self.assertEqual(lhs, rhs)

    def test_euler_factor_generates_S(self):
        # (1 - px - px^2 + p^2 x^3) * sum_k S(p^k) x^k == 1 + x, checked
        # as an exact identity in Z[p] coefficient-by-coefficient in x up
        # to x^60.  D(0) = 1, so this uniquely pins the whole series.
        D = poly_mul(ONE_MINUS_PX, ONE_MINUS_PX2)  # 1 - px - px^2 + p^2x^3
        Dx = {}  # x-degree -> {p-degree: coeff}
        for (i, j), c in D.items():
            Dx.setdefault(j, {})[i] = c
        K = 60
        Spoly = [S_pk_polynomial(k) for k in range(K + 1)]
        for k in range(K + 1):
            conv = {}
            for j, dpoly in Dx.items():
                if j > k:
                    continue
                for i1, c1 in dpoly.items():
                    for i2, c2 in Spoly[k - j].items():
                        conv[i1 + i2] = conv.get(i1 + i2, 0) + c1 * c2
            conv = {i: c for i, c in conv.items() if c != 0}
            expected = {0: 1} if k in (0, 1) else {}
            self.assertEqual(conv, expected, "x^%d" % k)

    def test_series_numerically_at_p2_p3(self):
        # belt and braces: substitute p = 2, 3 into the recurrence
        # S(p^k) = p S(p^{k-1}) + p S(p^{k-2}) - p^2 S(p^{k-3}), k >= 2
        for p in (2, 3):
            vals = [S_c_psi(p ** k) for k in range(12)]
            self.assertEqual(vals[0], 1)
            self.assertEqual(vals[1], p + 1)
            for k in range(2, 12):
                prev3 = vals[k - 3] if k >= 3 else 0
                self.assertEqual(
                    vals[k],
                    p * vals[k - 1] + p * vals[k - 2] - p * p * prev3,
                    (p, k),
                )


class TestJoint4FirstDivergence(unittest.TestCase):
    """Joint 4: S vs sigma_0, sigma_1, sigma_2, psi, phi, J_2 at m=1..10."""

    def test_exact_table(self):
        S = [None] + [S_direct(m) for m in range(1, 11)]
        self.assertEqual(S[1:], [1, 3, 4, 8, 6, 12, 8, 18, 15, 18])

    def test_divergence_indices(self):
        rivals = {
            "sigma_0": lambda n: sigma_k(n, 0),
            "sigma_1": lambda n: sigma_k(n, 1),
            "sigma_2": lambda n: sigma_k(n, 2),
            "psi": psi,
            "phi": phi,
            "J_2": jordan2,
        }
        first_diff = {}
        for name, f in rivals.items():
            for m in range(1, 11):
                if S_direct(m) != f(m):
                    first_diff[name] = m
                    break
        # every rival has diverged by m = 4 ...
        self.assertEqual(
            first_diff,
            {"sigma_0": 2, "sigma_1": 4, "sigma_2": 2,
             "psi": 4, "phi": 2, "J_2": 3},
        )
        # ... and m = 4 is the FIRST m at which S differs from ALL of them
        for m in range(1, 4):
            self.assertTrue(
                any(S_direct(m) == f(m) for f in rivals.values()), m
            )
        self.assertTrue(
            all(S_direct(4) != f(4) for f in rivals.values())
        )

    def test_m4_values(self):
        self.assertEqual(S_direct(4), 8)
        self.assertEqual(sigma_k(4, 0), 3)
        self.assertEqual(sigma_k(4, 1), 7)
        self.assertEqual(sigma_k(4, 2), 21)
        self.assertEqual(psi(4), 6)
        self.assertEqual(phi(4), 2)
        self.assertEqual(jordan2(4), 12)


if __name__ == "__main__":
    unittest.main()

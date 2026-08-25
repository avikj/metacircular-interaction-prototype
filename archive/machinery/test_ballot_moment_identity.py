"""Tests for notes/BALLOT_MOMENT_IDENTITY.md (fleet-ballot-moment).

All exact integers / Fractions; every closed form is checked against the
automaton DP, every generating-function law coefficientwise to k <= 12,
and the refutations against exact minimal counterexamples.
"""

import unittest
from fractions import Fraction
from math import comb

from ballot_moment_identity import (
    U_series,
    U_series_closed,
    V_series,
    balanced_chain_count,
    ballot_transfer_series,
    catalan_series,
    chain_counts_by_label,
    chain_weighted_moment_ballot,
    chain_weighted_moment_closed,
    chain_weighted_moment_dp,
    chain_weighted_moment_halfsum,
    chain_weighted_moment_stratum,
    euler_factor_series,
    expected_p_label,
    galois_conjugate,
    geometric_label_sum,
    inverse_ihara_series,
    label_distribution,
    per_state_ballot,
    per_state_sum,
    phi_U,
    phi_V,
    series_mul,
    stratum_size,
    total_chain_series,
)
from bijective_smith_assembly import second_moment_prime_power
from divisor_flag_label_automaton import (
    chain_count_closed,
    chain_count_dp,
    enumerate_chains,
    level_label,
)

PRIMES = (2, 3, 5)
KMAX = 12


class TestChainEnsembleByLabel(unittest.TestCase):
    def test_dp_equals_stratum_times_ballot(self):
        """M_k(i) = psi(p^{k-2i}) C_p(i,k) for p in {2,3,5}, k <= 12."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                counts = chain_counts_by_label(p, k)
                self.assertEqual(len(counts), k // 2 + 1)
                for i, m in enumerate(counts):
                    self.assertEqual(
                        m, stratum_size(p, i, k) * chain_count_closed(p, i, k),
                        (p, i, k))

    def test_dp_against_brute_force_chains(self):
        """Endpoint-label census of ALL (p+1)^k chains, p in {2,3}, k <= 4."""
        for p in (2, 3):
            for k in range(5):
                census = {}
                for chain in enumerate_chains(p, k):
                    i, _ = level_label(chain[-1], p)
                    census[i] = census.get(i, 0) + 1
                self.assertEqual(
                    census,
                    {i: m for i, m in enumerate(chain_counts_by_label(p, k))
                     if m})

    def test_closed_form_equals_dp_of_seed1(self):
        """C_p closed form == C_p DP (re-pin the imported machinery)."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                for i in range(k // 2 + 1):
                    self.assertEqual(chain_count_closed(p, i, k),
                                     chain_count_dp(p, i, k))


class TestWeightedMoment(unittest.TestCase):
    def test_five_expressions_agree(self):
        """W(k): DP == stratum sum == ballot transform of S == closed
        form == half-sum evaluation, p in {2,3,5}, k <= 12."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                w = chain_weighted_moment_dp(p, k)
                self.assertEqual(w, chain_weighted_moment_stratum(p, k))
                self.assertEqual(w, chain_weighted_moment_ballot(p, k))
                self.assertEqual(w, chain_weighted_moment_closed(p, k))
                self.assertEqual(w, chain_weighted_moment_halfsum(p, k))

    def test_even_doubling(self):
        """W(2t+2) = 2p W(2t+1), t >= 0."""
        for p in PRIMES:
            for t in range(KMAX // 2):
                self.assertEqual(chain_weighted_moment_dp(p, 2 * t + 2),
                                 2 * p * chain_weighted_moment_dp(p, 2 * t + 1))

    def test_first_values(self):
        """W = 1, p+1, 2p(p+1), p(p+1)(3p+1), 2p^2(p+1)(3p+1),
        p^2(p+1)(10p^2+5p+1), ... for every p in {2,3,5}."""
        for p in PRIMES:
            expected = [1, p + 1, 2 * p * (p + 1), p * (p + 1) * (3 * p + 1),
                        2 * p ** 2 * (p + 1) * (3 * p + 1),
                        p ** 2 * (p + 1) * (10 * p ** 2 + 5 * p + 1)]
            self.assertEqual(V_series(p, 5), expected)


class TestRadialDistribution(unittest.TestCase):
    def test_sums_to_one_and_positive(self):
        """The label distribution is an exact probability distribution."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                dist = label_distribution(p, k)
                self.assertEqual(sum(dist.values()), Fraction(1))
                for prob in dist.values():
                    self.assertGreater(prob, 0)

    def test_expected_p_label(self):
        """E[p^I] from the distribution == W(k)/(p+1)^k, exactly."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                dist = label_distribution(p, k)
                self.assertEqual(sum(prob * p ** i for i, prob in dist.items()),
                                 expected_p_label(p, k))

    def test_odd_expected_value_closed_form(self):
        """E[p^{I_{2t+1}}] = p^t sum_{r<=t} binom(2t+1,r) p^r / (p+1)^{2t}."""
        for p in PRIMES:
            for t in range(KMAX // 2):
                k = 2 * t + 1
                half = sum(comb(k, r) * p ** r for r in range(t + 1))
                self.assertEqual(expected_p_label(p, k),
                                 Fraction(p ** t * half, (p + 1) ** (k - 1)))


class TestGeneratingFunctions(unittest.TestCase):
    def test_euler_factor_series_is_S(self):
        """(1+x)/((1-px)(1-px^2)) has coefficients S(p^k), k <= 12."""
        for p in PRIMES:
            self.assertEqual(
                euler_factor_series(p, KMAX),
                [second_moment_prime_power(p, k) for k in range(KMAX + 1)])

    def test_V_is_catalan_transform_of_S(self):
        """V(x) = C(x) Shat(x C(x)), C = C_{p^2}: coefficientwise k <= 12."""
        for p in PRIMES:
            G = [second_moment_prime_power(p, m) for m in range(KMAX + 1)]
            self.assertEqual(ballot_transfer_series(p * p, G, KMAX),
                             V_series(p, KMAX))

    def test_U_is_catalan_transform_of_R(self):
        """U(x) = C/((1-xC)(1-px^2C^2)): per-state sums, k <= 12."""
        for p in PRIMES:
            self.assertEqual(U_series_closed(p, KMAX), U_series(p, KMAX))
            for k in range(KMAX + 1):
                self.assertEqual(per_state_sum(p, k), per_state_ballot(p, k))

    def test_ihara_total_chain_identity(self):
        """w = p, G = sigma_1(p^m) recovers 1/(1-(p+1)x) == (p+1)^k."""
        for p in PRIMES:
            self.assertEqual(total_chain_series(p, KMAX),
                             [(p + 1) ** k for k in range(KMAX + 1)])

    def test_catalan_series_functional_equation(self):
        """C_w = 1 + w x^2 C_w^2 coefficientwise, w in {p, p^2}."""
        for p in PRIMES:
            for w in (p, p * p):
                c = catalan_series(w, KMAX)
                c2 = series_mul(c, c, KMAX)
                rhs = [1] + [0] * KMAX
                for d in range(2, KMAX + 1):
                    rhs[d] = w * c2[d - 2]
                self.assertEqual(c, rhs)

    def test_inverse_ihara_recovers_euler_factor(self):
        """Shat(u) = V(u/(1+p^2u^2))/(1+p^2u^2) coefficientwise, k <= 12."""
        for p in PRIMES:
            self.assertEqual(inverse_ihara_series(p, KMAX),
                             euler_factor_series(p, KMAX))


class TestRefutation(unittest.TestCase):
    def test_minimal_counterexample_U_vs_S(self):
        """U_k = S(p^k) FAILS first at k = 1: U_1 = 1, S(p) = p+1.
        (k = 0 agrees: both are 1.)"""
        for p in PRIMES:
            self.assertEqual(per_state_sum(p, 0),
                             second_moment_prime_power(p, 0))
            self.assertEqual(per_state_sum(p, 1), 1)
            self.assertEqual(second_moment_prime_power(p, 1), p + 1)
            self.assertNotEqual(per_state_sum(p, 1),
                                second_moment_prime_power(p, 1))

    def test_minimal_counterexample_V_vs_S(self):
        """W(k) = S(p^k) FAILS first at k = 2, with gap exactly p^2
        (= ballot(2,1) p^2 S(1)): W(2) = 2p^2+2p, S(p^2) = p^2+2p.
        (k = 0, 1 agree.)"""
        for p in PRIMES:
            for k in (0, 1):
                self.assertEqual(chain_weighted_moment_dp(p, k),
                                 second_moment_prime_power(p, k))
            gap = (chain_weighted_moment_dp(p, 2)
                   - second_moment_prime_power(p, 2))
            self.assertEqual(gap, p * p)

    def test_galois_witness_V_irrational(self):
        """Phi_V(T) != Phi_V(1/(p^2 T)) at T = 1/p^2 (conjugate T = 1):
        exact Fractions, and the general-p obstruction (p+1)^2 != 0."""
        for p in PRIMES + (7, 11):
            t = Fraction(1, p * p)
            self.assertEqual(galois_conjugate(p, t), 1)
            a, b = phi_V(p, t), phi_V(p, galois_conjugate(p, t))
            self.assertEqual(a, Fraction((p * p + 1) ** 2,
                                         (p - 1) * (p ** 3 - 1)))
            self.assertEqual(b, Fraction(2 * (p * p + 1), (p - 1) ** 2))
            # a = b <=> (p^2+1)(p-1) = 2(p^3-1), whose defect is
            # -(p+1)^2 (p-1) != 0 for every p
            self.assertNotEqual(a, b)
            self.assertEqual((p * p + 1) * (p - 1) - 2 * (p ** 3 - 1),
                             -((p + 1) ** 2) * (p - 1))

    def test_galois_witness_U_irrational(self):
        """Phi_U is finite at T = 1/p^2 but its conjugate value Phi_U(1)
        is a pole (1-T = 0); exact witness at a nearby point instead:
        Phi_U(1/(2p^2)) != Phi_U(2) for all tested p."""
        for p in PRIMES + (7, 11):
            self.assertEqual(
                phi_U(p, Fraction(1, p * p)),
                Fraction(p ** 3 * (p * p + 1),
                         (p * p - 1) * (p ** 3 - 1)))
            t = Fraction(1, 2 * p * p)
            self.assertEqual(galois_conjugate(p, t), 2)
            self.assertNotEqual(phi_U(p, t), phi_U(p, 2))

    def test_u_variable_forms(self):
        """V = (1+p^2u^2)(1+u)/((1-pu)(1-pu^2)) and
        U = (1+p^2u^2)/((1-u)(1-pu^2)) at u = x C(x): checked as exact
        rational identities V (1-pu) = U (1-u^2) at sample points, plus
        Shat(u) = (1+u)/((1-pu)(1-pu^2)) so V = (1+p^2u^2) Shat(u)."""
        for p in PRIMES:
            for t in (Fraction(1, 3 * p), Fraction(1, p ** 2),
                      Fraction(2, 5 * p)):
                v, u = phi_V(p, t), phi_U(p, t)
                self.assertEqual(v * (1 - p * t), u * (1 - t * t))
                shat = (1 + t) / ((1 - p * t) * (1 - p * t * t))
                self.assertEqual(v, (1 + p * p * t * t) * shat)


class TestBallotTransferLemma(unittest.TestCase):
    def test_lemma_on_generic_sequences(self):
        """sum_j ballot(k,j) w^j G_{k-2j} has GF C_w Ghat(x C_w) for
        arbitrary integer sequences G and weights w (the lemma is
        weight- and sequence-agnostic)."""
        from divisor_flag_label_automaton import ballot
        for w in (1, 2, 3, 4, 9):
            for G in ([1] * (KMAX + 1),
                      list(range(1, KMAX + 2)),
                      [m * m - 3 * m + 7 for m in range(KMAX + 1)]):
                lhs = [sum(ballot(k, j) * w ** j * G[k - 2 * j]
                           for j in range(k // 2 + 1))
                       for k in range(KMAX + 1)]
                self.assertEqual(ballot_transfer_series(w, G, KMAX), lhs)

    def test_balanced_chain_count_column(self):
        """B_p(k) = C_p(floor(k/2), k) and the geometric sum R_m used in
        the U-instance."""
        for p in PRIMES:
            for k in range(KMAX + 1):
                self.assertEqual(balanced_chain_count(p, k),
                                 chain_count_dp(p, k // 2, k))
            for m in range(KMAX + 1):
                self.assertEqual(geometric_label_sum(p, m),
                                 sum(p ** i for i in range(m // 2 + 1)))


if __name__ == "__main__":
    unittest.main()

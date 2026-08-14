"""Tests for machinery/divisor_flag_label_automaton.py (fleet-flag-automaton).

Exact-integer replay of notes/DIVISOR_FLAG_LABEL_AUTOMATON.md: forward
keep/raise multiplicities against brute-force composition of Hermite
bases, the backward (R0038) time reversal, chain-count DP and its ballot
closed form against brute-force chain enumeration, totals, and the
Bruhat-Tits tree dictionary (distance = v_p(e2/e1), sphere sizes, unique
parents, walk steps).  p in {2, 3}, levels k <= 4 exhaustively.
"""

import unittest
from collections import Counter

from hecke_coset_smith_assembly import hnf_bases, psi, sigma1
from divisor_flag_label_automaton import (
    IDENTITY,
    ballot,
    chain_count_closed,
    chain_count_dp,
    enumerate_chains,
    index_p_sublattices,
    level_label,
    observed_forward_split,
    predicted_forward_split,
    primitive_rep,
    tree_ball,
)

PS = (2, 3)
KMAX = 4


class TestForwardTransitions(unittest.TestCase):
    def test_split_matches_prediction(self):
        """Theorem 1 exhaustively: from every lattice of level k <= KMAX,
        the p+1 index-p sublattices split (keep, raise) = (p, 1) when
        2i < k and (p+1, 0) when 2i = k."""
        for p in PS:
            for k in range(KMAX + 1):
                for basis in hnf_bases(p ** k):
                    i, kk = level_label(basis, p)
                    self.assertEqual(kk, k)
                    self.assertEqual(observed_forward_split(basis, p),
                                     predicted_forward_split(i, k, p))

    def test_balanced_state_is_homothety_of_ambient(self):
        """2i = k holds exactly for L = p^i Z^2 (Smith pair balanced)."""
        for p in PS:
            for k in range(KMAX + 1):
                for basis in hnf_bases(p ** k):
                    i, _ = level_label(basis, p)
                    if 2 * i == k:
                        q = p ** i
                        self.assertEqual(basis, ((q, 0), (0, q)))

    def test_state_space(self):
        """Levels stratify by labels 0 <= i <= k//2 with stratum sizes
        N_k(i) = psi(p^{k-2i})."""
        for p in PS:
            for k in range(KMAX + 1):
                strata = Counter(level_label(b, p)[0]
                                 for b in hnf_bases(p ** k))
                self.assertEqual(set(strata), set(range(k // 2 + 1)))
                for i, size in strata.items():
                    self.assertEqual(size, psi(p ** (k - 2 * i)))
                self.assertEqual(sum(strata.values()), sigma1(p ** k))


class TestBackwardParents(unittest.TestCase):
    def test_parent_split_is_time_reversal(self):
        """R0038 Theorems 2+4, re-verified as the reversal of Theorem 1:
        a fixed child of level k, label i has parents splitting
        (keep, raise) = (1, 0) for i = 0; (1, p) for i >= 1, 2i < k;
        (0, p+1) for 2i = k."""
        for p in PS:
            for k in range(1, KMAX + 1):
                parent_labels = {}
                for parent in hnf_bases(p ** (k - 1)):
                    ip, _ = level_label(parent, p)
                    for kid in index_p_sublattices(parent, p):
                        parent_labels.setdefault(kid, []).append(ip)
                self.assertEqual(set(parent_labels), set(hnf_bases(p ** k)))
                for child, labels in parent_labels.items():
                    i, _ = level_label(child, p)
                    keep = labels.count(i)
                    raise_ = labels.count(i - 1)
                    self.assertEqual(keep + raise_, len(labels))
                    if i == 0:
                        self.assertEqual((keep, raise_), (1, 0))
                    elif 2 * i < k:
                        self.assertEqual((keep, raise_), (1, p))
                    else:
                        self.assertEqual(2 * i, k)
                        self.assertEqual((keep, raise_), (0, p + 1))


class TestChainCounts(unittest.TestCase):
    def test_brute_force_vs_dp_and_closed_form(self):
        """All (p+1)^k chains enumerated by composing Hermite bases:
        endpoints cover every index-p^k lattice, and the count per FIXED
        endpoint equals both the DP C_p(i,k) and the ballot closed form
        sum_{j<=i} (binom(k,j)-binom(k,j-1)) p^j."""
        for p in PS:
            for k in range(KMAX + 1):
                chains = enumerate_chains(p, k)
                self.assertEqual(len(chains), (p + 1) ** k)
                counts = Counter(chain[-1] for chain in chains)
                self.assertEqual(set(counts), set(hnf_bases(p ** k)))
                for endpoint, count in counts.items():
                    i, _ = level_label(endpoint, p)
                    self.assertEqual(count, chain_count_dp(p, i, k))
                    self.assertEqual(count, chain_count_closed(p, i, k))

    def test_totals(self):
        """Grand total (p+1)^k; psi-weighted stratum identity; the
        cyclic stratum receives exactly one chain per endpoint, i.e.
        psi(p^k) = (p+1) p^{k-1} chains in total."""
        for p in PS:
            for k in range(1, KMAX + 1):
                total = sum(psi(p ** (k - 2 * i)) * chain_count_closed(p, i, k)
                            for i in range(k // 2 + 1))
                self.assertEqual(total, (p + 1) ** k)
                self.assertEqual(chain_count_closed(p, 0, k), 1)
                self.assertEqual(psi(p ** k), (p + 1) * p ** (k - 1))
                chains = enumerate_chains(p, k)
                cyclic = sum(1 for chain in chains
                             if level_label(chain[-1], p)[0] == 0)
                self.assertEqual(cyclic, (p + 1) * p ** (k - 1))

    def test_dp_equals_closed_form_widely(self):
        """The Pascal induction, replayed: DP = ballot sum for all states
        with k <= 14, p in {2, 3, 5, 7}."""
        for p in (2, 3, 5, 7):
            for k in range(15):
                for i in range(k // 2 + 1):
                    self.assertEqual(chain_count_dp(p, i, k),
                                     chain_count_closed(p, i, k))

    def test_special_values(self):
        """C_p(0,k) = 1, C_p(1,k) = (k-1)p + 1, C_p(2,5) = 5p^2+4p+1,
        and the balanced factorization C_p(i,2i) = (p+1) C_p(i-1,2i-1)."""
        for p in (2, 3, 5):
            for k in range(2, 10):
                self.assertEqual(chain_count_closed(p, 0, k), 1)
                self.assertEqual(chain_count_closed(p, 1, k), (k - 1) * p + 1)
            self.assertEqual(chain_count_closed(p, 2, 5),
                             5 * p * p + 4 * p + 1)
            for i in range(1, 6):
                self.assertEqual(
                    chain_count_closed(p, i, 2 * i),
                    (p + 1) * chain_count_closed(p, i - 1, 2 * i - 1))

    def test_ballot_coefficients(self):
        """b_j(k) = binom(k,j) - binom(k,j-1) >= 0, b_0 = 1, central
        vanishing b_i(2i-1) = 0 (the balanced-case collapse), and the
        telescoping sum_{j<=i} b_j(k) = binom(k,i)."""
        from math import comb
        for k in range(12):
            self.assertEqual(ballot(k, 0), 1)
            for j in range(k // 2 + 1):
                self.assertGreaterEqual(ballot(k, j), 0)
            for i in range(k // 2 + 1):
                self.assertEqual(sum(ballot(k, j) for j in range(i + 1)),
                                 comb(k, i))
        for i in range(1, 8):
            self.assertEqual(ballot(2 * i - 1, i), 0)


class TestTreeDictionary(unittest.TestCase):
    RADIUS = KMAX + 1

    def test_sphere_sizes(self):
        """|S(0)| = 1 and |S(r)| = (p+1) p^{r-1} = psi(p^r): the sphere
        is the cyclic stratum at level r."""
        for p in PS:
            spheres = Counter(tree_ball(p, self.RADIUS).values())
            self.assertEqual(spheres[0], 1)
            for r in range(1, self.RADIUS + 1):
                self.assertEqual(spheres[r], (p + 1) * p ** (r - 1))
                self.assertEqual(spheres[r], psi(p ** r))

    def test_distance_formula(self):
        """dist([L]) = v_p(e2) - v_p(e1) = k - 2i for every lattice of
        level k <= KMAX: the exact dictionary label i = (k - dist)/2."""
        for p in PS:
            dist = tree_ball(p, KMAX)
            for k in range(KMAX + 1):
                for basis in hnf_bases(p ** k):
                    i, _ = level_label(basis, p)
                    self.assertEqual(dist[primitive_rep(basis)], k - 2 * i)

    def test_regularity_unique_parent_symmetry(self):
        """(p+1) distinct neighbor classes at every vertex; every
        non-root vertex has exactly one neighbor closer to the root and
        p farther (the tree property); adjacency is symmetric."""
        for p in PS:
            dist = tree_ball(p, self.RADIUS)
            for v, r in dist.items():
                if r >= self.RADIUS:
                    continue  # children's distances lie outside the ball
                neighbors = {primitive_rep(kid)
                             for kid in index_p_sublattices(v, p)}
                self.assertEqual(len(neighbors), p + 1)
                closer = [w for w in neighbors if dist[w] == r - 1]
                farther = [w for w in neighbors if dist[w] == r + 1]
                self.assertEqual(len(closer) + len(farther), p + 1)
                self.assertEqual(len(closer), 0 if r == 0 else 1)
                for w in neighbors:
                    back = {primitive_rep(kid)
                            for kid in index_p_sublattices(w, p)}
                    self.assertIn(v, back)

    def test_chains_are_walks(self):
        """Along every enumerated chain of length KMAX: the class walk
        starts at the root, d_j = j - 2 i_j equals the tree distance,
        every step moves distance +-1, keep steps away from the root and
        raise steps toward it."""
        for p in PS:
            dist = tree_ball(p, KMAX)
            for chain in enumerate_chains(p, KMAX):
                self.assertEqual(chain[0], IDENTITY)
                prev_i, prev_d = 0, 0
                for j, basis in enumerate(chain):
                    i, k = level_label(basis, p)
                    self.assertEqual(k, j)
                    d = dist[primitive_rep(basis)]
                    self.assertEqual(d, j - 2 * i)
                    if j:
                        self.assertIn(i - prev_i, (0, 1))
                        self.assertEqual(d - prev_d,
                                         1 if i == prev_i else -1)
                    prev_i, prev_d = i, d


if __name__ == "__main__":
    unittest.main()

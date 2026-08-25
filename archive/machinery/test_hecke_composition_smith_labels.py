"""Tests for machinery/hecke_composition_smith_labels.py (fleet-hecke-comp).

Exact-integer replay of notes/HECKE_COMPOSITION_SMITH_LABELS.md: Hermite
reduction correctness, coprime composition bijection with the Smith label
product law, and the p-power chain-multiplicity pattern of
T_p T_{p^k} = T_{p^{k+1}} + p R_p T_{p^{k-1}}.
"""

import unittest
from math import gcd

from hecke_coset_smith_assembly import (
    det2,
    hnf_bases,
    mat_mul,
    same_lattice,
    sigma1,
    smith_invariants,
)
from hecke_composition_smith_labels import (
    chain_multiplicities,
    compose,
    compose_all,
    coprime_composition_table,
    hermite_reduce,
    label_step_split,
    predicted_multiplicity,
)

# A deterministic grid of nonsingular integer matrices, mixed signs.
_MATRICES = [
    ((a, b), (c, d))
    for a in range(-4, 5)
    for b in range(-4, 5)
    for c in range(-4, 5)
    for d in range(-4, 5)
    if a * d - b * c != 0
]

_UNIMODULAR = [
    ((1, 0), (0, 1)), ((0, -1), (1, 0)), ((1, 1), (0, 1)),
    ((1, 0), (1, 1)), ((1, -2), (0, 1)), ((2, 1), (1, 1)),
    ((1, 0), (0, -1)), ((-1, 2), (1, -1)), ((3, 2), (1, 1)),
]


class TestHermiteReduce(unittest.TestCase):
    def test_form_and_lattice_preserved(self):
        """Output is a valid Hermite basis of the SAME lattice (exact
        same-lattice check via adjugate divisibility)."""
        for mat in _MATRICES:
            h = hermite_reduce(mat)
            (a, z), (b, d) = h
            self.assertEqual(z, 0)
            self.assertGreaterEqual(a, 1)
            self.assertGreaterEqual(d, 1)
            self.assertTrue(0 <= b < d)
            self.assertEqual(a * d, abs(det2(mat)))
            self.assertTrue(same_lattice(mat, h))

    def test_idempotent(self):
        for mat in _MATRICES:
            h = hermite_reduce(mat)
            self.assertEqual(hermite_reduce(h), h)

    def test_right_unimodular_invariance(self):
        """The Hermite basis is a lattice invariant: M and M U reduce to
        the same canonical form for every unimodular U."""
        for mat in _MATRICES[:600]:
            h = hermite_reduce(mat)
            for u in _UNIMODULAR:
                self.assertEqual(hermite_reduce(mat_mul(mat, u)), h)

    def test_matches_repo_enumeration(self):
        """Every enumerated Hermite basis is already reduced, and reducing
        any basis of the same lattice recovers it."""
        for m in range(1, 13):
            for basis in hnf_bases(m):
                self.assertEqual(hermite_reduce(basis), basis)

    def test_singular_rejected(self):
        with self.assertRaises(ValueError):
            hermite_reduce(((2, 4), (1, 2)))


class TestComposition(unittest.TestCase):
    def test_index_multiplies_and_composite_is_sublattice(self):
        for m, n in [(2, 2), (2, 3), (4, 6), (3, 3)]:
            for bm in hnf_bases(m):
                for bn in hnf_bases(n):
                    comp = compose(bm, bn)
                    self.assertEqual(det2(comp), m * n)
                    self.assertIn(comp, hnf_bases(m * n))
                    # L'' = M N Z^2 really is the composed lattice.
                    self.assertTrue(same_lattice(comp, mat_mul(bm, bn)))

    def test_total_pair_count(self):
        """len(hnf_bases(mn)) consistency: sigma1 is multiplicative on
        coprime arguments, so pairs = sigma1(m) sigma1(n) = sigma1(mn)."""
        for m, n in [(2, 3), (3, 4), (4, 9), (2, 9)]:
            self.assertEqual(gcd(m, n), 1)
            pairs = sum(len(v) for v in compose_all(m, n).values())
            self.assertEqual(pairs, sigma1(m) * sigma1(n))
            self.assertEqual(pairs, len(hnf_bases(m * n)))
            self.assertEqual(len(hnf_bases(m * n)), sigma1(m * n))


class TestCoprimeBijectionAndLabelLaw(unittest.TestCase):
    PAIRS = [(2, 3), (3, 4), (4, 9), (2, 9)]

    def test_bijection(self):
        for m, n in self.PAIRS:
            table = compose_all(m, n)
            self.assertEqual(set(table), set(hnf_bases(m * n)))
            for comp, pairs in table.items():
                self.assertEqual(len(pairs), 1, (comp, pairs))

    def test_smith_labels_multiply(self):
        """e_i(composite) = e_i(L) * e_i(relative) for i = 1, 2."""
        for m, n in self.PAIRS:
            for comp, [(bm, bn)] in compose_all(m, n).items():
                sm = smith_invariants(bm)
                sn = smith_invariants(bn)
                self.assertEqual(smith_invariants(comp),
                                 (sm[0] * sn[0], sm[1] * sn[1]))

    def test_table_helper_accepts_and_rejects(self):
        for m, n in self.PAIRS:
            self.assertEqual(len(coprime_composition_table(m, n)),
                             sigma1(m * n))
        with self.assertRaises(ValueError):
            coprime_composition_table(2, 4)


class TestPPowerRecursion(unittest.TestCase):
    CASES = [(p, k) for p in (2, 3) for k in (1, 2, 3)]

    def test_all_composites_reached_and_total_count(self):
        """Chains (index p^k, then relative index p) hit every index-
        p^{k+1} lattice, and the total chain count is the recursion's:
        sigma1(p^k) sigma1(p) = sigma1(p^{k+1}) + p sigma1(p^{k-1})."""
        for p, k in self.CASES:
            table = chain_multiplicities(p, k)
            self.assertEqual(set(table), set(hnf_bases(p ** (k + 1))))
            total = sum(len(v) for v in table.values())
            self.assertEqual(total, sigma1(p ** k) * sigma1(p))
            self.assertEqual(total,
                             sigma1(p ** (k + 1)) + p * sigma1(p ** (k - 1)))

    def test_multiplicity_pattern(self):
        """Multiplicity 1 on cyclic composites (p does not divide e1),
        multiplicity p+1 on composites with p | e1 — i.e. exactly the
        coefficient of T_{p^{k+1}} plus p times the indicator of the
        image of R_p T_{p^{k-1}} (composites of the form p L''')."""
        for p, k in self.CASES:
            for comp, e1s in chain_multiplicities(p, k).items():
                self.assertEqual(len(e1s), predicted_multiplicity(comp, p))
                e1c = smith_invariants(comp)[0]
                if e1c % p == 0:
                    self.assertEqual(len(e1s), p + 1)
                else:
                    self.assertEqual(len(e1s), 1)

    def test_r_p_image_is_the_extra_p_support(self):
        """{composites with p | e1} = {p L''' : L''' of index p^{k-1}},
        each hit once by the homothety — so p+1 = 1 + p exactly."""
        for p, k in self.CASES:
            divisible = {comp for comp in hnf_bases(p ** (k + 1))
                         if smith_invariants(comp)[0] % p == 0}
            scaled = {hermite_reduce(((p * a, 0), (p * b, p * d)))
                      for (a, _), (b, d) in hnf_bases(p ** (k - 1))}
            self.assertEqual(divisible, scaled)
            self.assertEqual(len(divisible), sigma1(p ** (k - 1)))

    def test_label_motion_interlacing(self):
        """Along every chain step the Smith label stays or is multiplied
        by p: e1(L') | e1(L'') and e1(L'') | p e1(L')."""
        for p, k in self.CASES:
            for comp, e1s in chain_multiplicities(p, k).items():
                e1c = smith_invariants(comp)[0]
                for e1m in e1s:
                    self.assertEqual(e1c % e1m, 0)
                    self.assertEqual((p * e1m) % e1c, 0)

    def test_keep_raise_split(self):
        """For a composite with e1 = p^i >= p: exactly (keep, raise) =
        (1, p) when 2i <= k, and (0, p+1) when 2i = k+1 (then the
        composite is p^i Z^2, the balanced Smith type)."""
        for p, k in self.CASES:
            for comp, (keep, raise_) in label_step_split(p, k).items():
                e1c, e2c = smith_invariants(comp)
                i = 0
                t = e1c
                while t % p == 0:
                    t //= p
                    i += 1
                if 2 * i <= k:
                    self.assertEqual((keep, raise_), (1, p), comp)
                else:
                    self.assertEqual(2 * i, k + 1)
                    self.assertEqual((keep, raise_), (0, p + 1), comp)
                    self.assertEqual(e1c, e2c)  # composite = p^i Z^2


if __name__ == "__main__":
    unittest.main()

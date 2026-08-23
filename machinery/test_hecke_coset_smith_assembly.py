import unittest
from itertools import product
from math import gcd, isqrt

from hecke_coset_smith_assembly import (
    basis_matrix,
    cyclic_bases,
    det2,
    hnf_bases,
    in_gamma0,
    mat_mul,
    psi,
    same_lattice,
    sigma1,
    smith_2x2,
    smith_invariants,
    stabilizes,
    transitivity_witness,
)


class CountingTest(unittest.TestCase):
    def test_hnf_count_is_sigma1(self):
        for m in range(1, 41):
            self.assertEqual(len(hnf_bases(m)), sigma1(m))

    def test_cyclic_count_is_psi(self):
        for m in range(1, 41):
            self.assertEqual(len(cyclic_bases(m)), psi(m))

    def test_assembly_identity(self):
        for m in range(1, 401):
            total = sum(
                psi(m // (c * c))
                for c in range(1, isqrt(m) + 1)
                if m % (c * c) == 0
            )
            self.assertEqual(sigma1(m), total)

    def test_smith_stratification_matches_content(self):
        for m in range(1, 25):
            for basis in hnf_bases(m):
                e1, e2 = smith_invariants(basis)
                self.assertEqual(e1 * e2, m)
                self.assertEqual(e2 % e1, 0)
                (a, _), (b, d) = basis
                self.assertEqual(e1, gcd(gcd(a, b), d))


class UniquenessTest(unittest.TestCase):
    def test_hnf_bases_give_pairwise_distinct_lattices(self):
        for m in range(1, 13):
            mats = [basis_matrix(basis) for basis in hnf_bases(m)]
            for i, p in enumerate(mats):
                self.assertTrue(same_lattice(p, p))
                for q in mats[i + 1:]:
                    self.assertFalse(same_lattice(p, q))


class StabilizerTest(unittest.TestCase):
    def test_stabilizer_is_gamma0(self):
        window = range(-4, 5)
        for m in (2, 3, 4, 6):
            for a, b, c, d in product(window, repeat=4):
                gamma = ((a, b), (c, d))
                if det2(gamma) != 1:
                    continue
                self.assertEqual(
                    stabilizes(gamma, m), in_gamma0(gamma, m),
                    (gamma, m),
                )


class TransitivityTest(unittest.TestCase):
    def test_smith_2x2_normalizes(self):
        window = range(-5, 6)
        for a, b, c, d in product(window, repeat=4):
            mat = ((a, b), (c, d))
            if det2(mat) == 0:
                continue
            u, v = smith_2x2(mat)
            self.assertIn(abs(det2(u)), (1,))
            self.assertIn(abs(det2(v)), (1,))
            res = mat_mul(mat_mul(u, mat), v)
            self.assertEqual(res[0][1], 0)
            self.assertEqual(res[1][0], 0)
            self.assertGreater(res[0][0], 0)
            self.assertGreater(res[1][1], 0)
            self.assertEqual(res[1][1] % res[0][0], 0)

    def test_every_cyclic_lattice_reached_from_L0(self):
        for m in range(1, 16):
            d0 = ((1, 0), (0, m))
            for basis in cyclic_bases(m):
                gamma = transitivity_witness(basis)
                self.assertEqual(det2(gamma), 1)
                self.assertTrue(
                    same_lattice(mat_mul(gamma, d0), basis_matrix(basis))
                )


if __name__ == "__main__":
    unittest.main()

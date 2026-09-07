"""Tests for machinery/bijective_smith_assembly.py — exact integers only.

Replays, per notes/BIJECTIVE_SMITH_ASSEMBLY.md:
  1. the Hermite coordinate formula for Phi, the mod-reduction lemma
     (b/c is always already reduced), and the exact round trip, for
     EVERY index-m sublattice, m <= 30;
  2. the counting identity sigma_1(m) = sum_{c^2|m} psi(m/c^2) for
     m <= 400 VIA THE BIJECTION (fiberwise onto-without-repetition),
     not just numerically;
  3. the second moment S(m) = sum_L e1(L): four exact forms agree for
     m <= 200, the prime-power closed form directly at prime powers,
     and S is none of sigma_1, psi, sigma_2;
  4. SL_2(Z)-equivariance of Phi on a unimodular window for m in
     {6, 12}, plus explicit orbit witnesses showing each stratum is
     one orbit.
"""

import unittest
from math import gcd

from hecke_coset_smith_assembly import (
    cyclic_bases,
    det2,
    hnf_bases,
    psi,
    sigma1,
    smith_invariants,
)
from bijective_smith_assembly import (
    assembly_fibers,
    gamma_dot,
    label,
    phi,
    phi_inverse,
    second_moment,
    second_moment_bijective,
    second_moment_closed,
    second_moment_prime_power,
    second_moment_totient,
    square_divisors,
    stratum_base_point,
    stratum_orbit_witness,
    unimodular_window,
)


class TestHermiteFormula(unittest.TestCase):
    """Task 1: the exact coordinate formula and round trip, all m <= 30."""

    M_MAX = 30

    def test_phi_coordinate_formula_and_mod_lemma(self):
        for m in range(1, self.M_MAX + 1):
            for basis in hnf_bases(m):
                (a, _), (b, d) = basis
                c, image = phi(basis)
                # the label is the first Smith invariant, and c^2 | m
                self.assertEqual(c, smith_invariants(basis)[0])
                self.assertEqual(m % (c * c), 0)
                # exact Hermite formula, WITH the mod written out --
                # and Lemma 2: the mod-reduction is the identity
                self.assertEqual(
                    image, ((a // c, 0), ((b // c) % (d // c), d // c))
                )
                self.assertEqual((b // c) % (d // c), b // c)
                # sharper form of the lemma: c | b, c | d, b < d
                # force b <= d - c
                self.assertLessEqual(b, d - c)

    def test_phi_image_is_cyclic_of_index_m_over_c_squared(self):
        for m in range(1, self.M_MAX + 1):
            for basis in hnf_bases(m):
                c, image = phi(basis)
                (a1, z1), (b1, d1) = image
                self.assertEqual(z1, 0)
                self.assertTrue(a1 >= 1 and d1 >= 1 and 0 <= b1 < d1)
                self.assertEqual(a1 * d1, m // (c * c))     # index
                self.assertEqual(gcd(gcd(a1, b1), d1), 1)   # cyclic
                # c * image spans the original lattice: coordinatewise
                self.assertEqual(phi_inverse(c, image), basis)

    def test_round_trip_both_ways(self):
        for m in range(1, self.M_MAX + 1):
            # L -> Phi(L) -> L
            for basis in hnf_bases(m):
                c, image = phi(basis)
                self.assertEqual(phi_inverse(c, image), basis)
            # (c, L') -> c L' -> (c, L')
            for c in square_divisors(m):
                for image in cyclic_bases(m // (c * c)):
                    self.assertEqual(phi(phi_inverse(c, image)), (c, image))

    def test_phi_is_a_bijection_onto_the_disjoint_union(self):
        for m in range(1, self.M_MAX + 1):
            target = {
                c: set(cyclic_bases(m // (c * c))) for c in square_divisors(m)
            }
            seen = {c: set() for c in square_divisors(m)}
            for basis in hnf_bases(m):
                c, image = phi(basis)
                self.assertIn(c, seen)
                self.assertNotIn(image, seen[c])  # injective, fiberwise
                seen[c].add(image)
            self.assertEqual(seen, target)        # surjective, fiberwise


class TestCountingIdentity(unittest.TestCase):
    """Task 2a: sigma_1(m) = sum_{c^2|m} psi(m/c^2) for m <= 400,
    via the bijection (fiber counts), not just numerically."""

    M_MAX = 400

    def test_assembly_identity_via_bijection(self):
        for m in range(1, self.M_MAX + 1):
            fibers = assembly_fibers(m)
            cs = square_divisors(m)
            self.assertEqual(sorted(fibers), cs)
            total = 0
            for c in cs:
                images = fibers[c]
                n = m // (c * c)
                # each label-c stratum maps bijectively ONTO the cyclic
                # index-(m/c^2) space
                self.assertEqual(len(images), len(set(images)))
                self.assertEqual(set(images), set(cyclic_bases(n)))
                self.assertEqual(len(images), psi(n))
                total += len(images)
            self.assertEqual(total, sigma1(m))
            self.assertEqual(sigma1(m), sum(psi(m // (c * c)) for c in cs))


class TestSecondMoment(unittest.TestCase):
    """Task 2b: S(m) = sum_L e1(L) -- four exact forms and the
    prime-power shape."""

    M_MAX = 200

    def test_four_forms_agree(self):
        for m in range(1, self.M_MAX + 1):
            s = second_moment(m)
            self.assertEqual(s, second_moment_bijective(m))
            self.assertEqual(s, second_moment_totient(m))
            self.assertEqual(s, second_moment_closed(m))

    def test_prime_power_closed_form_directly(self):
        for p, k_max in [(2, 8), (3, 5), (5, 3), (7, 3)]:
            for k in range(0, k_max + 1):
                self.assertEqual(
                    second_moment(p ** k), second_moment_prime_power(p, k)
                )

    def test_odd_power_factorization(self):
        # S(p^{2t+1}) = psi(p^{t+1}) * sigma_1(p^t)
        for p in (2, 3, 5):
            for t in (0, 1, 2):
                self.assertEqual(
                    second_moment_prime_power(p, 2 * t + 1),
                    psi(p ** (t + 1)) * sigma1(p ** t),
                )

    def test_not_a_standard_sigma_variant(self):
        # S(4) = 8; sigma_1(4) = 7, psi(4) = 6, sigma_2(4) = 21
        self.assertEqual(second_moment(4), 8)
        self.assertNotEqual(second_moment(4), sigma1(4))
        self.assertNotEqual(second_moment(4), psi(4))
        self.assertNotEqual(
            second_moment(4), sum(d * d for d in (1, 2, 4))
        )


class TestEquivariance(unittest.TestCase):
    """Task 3/4: Phi is SL_2(Z)-equivariant, and each stratum is one
    orbit, checked on unimodular window elements for m in {6, 12}."""

    MS = (6, 12)
    WINDOW_BOUND = 2

    def test_label_invariance_and_equivariance(self):
        window = unimodular_window(self.WINDOW_BOUND)
        self.assertGreater(len(window), 1)
        for m in self.MS:
            for basis in hnf_bases(m):
                c, image = phi(basis)
                for gamma in window:
                    moved = gamma_dot(gamma, basis)
                    # gamma . L has the same index and the same label
                    self.assertEqual(
                        moved[0][0] * moved[1][1], m
                    )
                    self.assertEqual(label(moved), c)
                    # Phi(gamma . L) = (c, gamma . ((1/c) L))
                    c2, image2 = phi(moved)
                    self.assertEqual(c2, c)
                    self.assertEqual(image2, gamma_dot(gamma, image))

    def test_each_stratum_is_one_orbit_via_witnesses(self):
        for m in self.MS:
            for basis in hnf_bases(m):
                c = label(basis)
                gamma = stratum_orbit_witness(basis)
                self.assertEqual(det2(gamma), 1)
                self.assertEqual(
                    gamma_dot(gamma, stratum_base_point(m, c)), basis
                )


if __name__ == "__main__":
    unittest.main()

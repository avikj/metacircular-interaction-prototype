#!/usr/bin/env python3
"""Exact tests for the countable valuation strata.

The decisive content is the correction: on `Z_p` the `v_p = infinity` block is
NULL, so it imposes no condition; in `Z/p^m` it has positive weight and is
rigid instead.
"""

import unittest
from fractions import Fraction

from countable_strata import (
    haar_strata,
    independent_product_commutes,
    null_block_imposes_no_condition,
    strata_sum,
    tail_mass,
)
from valuation_lens import blocks_of, valuation_lens, weighted_commutes
from weight_rigidity import singleton_rigidity_violations


class HaarStrataTests(unittest.TestCase):
    def test_masses_sum_to_one_for_every_truncation(self):
        for p in (2, 3, 5, 7):
            for cap in range(1, 10):
                self.assertEqual(strata_sum(p, cap), Fraction(1))

    def test_each_finite_stratum_has_positive_mass(self):
        for p in (2, 3, 5):
            s = haar_strata(p, 6)
            for j in range(6):
                self.assertGreater(s[j], 0)
                self.assertEqual(s[j], Fraction(p - 1, p ** (j + 1)))

    def test_the_tail_vanishes(self):
        for p in (2, 3, 5):
            prev = None
            for k in (1, 2, 4, 8, 16):
                m = tail_mass(p, k)
                self.assertEqual(m, Fraction(1, p**k))
                if prev is not None:
                    self.assertLess(m, prev)
                prev = m


class DistinctPrimesStillCommuteTests(unittest.TestCase):
    def test_countably_many_strata_commute(self):
        for p, q, cap in ((2, 3, 6), (3, 5, 5), (2, 5, 8), (5, 7, 4)):
            self.assertTrue(independent_product_commutes(p, q, cap), (p, q, cap))

    def test_agrees_with_the_finite_model_at_matching_truncation(self):
        """The finite `Z/p^a q^b` result of `VALUATION_LENS` §3 is the
        truncation of this one."""
        for p, a, q, b in ((2, 3, 3, 2), (3, 2, 5, 1)):
            N = p**a * q**b
            pi, sg = valuation_lens(N, p, a), valuation_lens(N, q, b)
            self.assertTrue(weighted_commutes(pi, sg, [Fraction(1)] * N))


class NullVersusRigidTests(unittest.TestCase):
    """The correction to `WEIGHT_RIGIDITY` §3."""

    def test_on_Z_p_the_infinity_block_imposes_nothing(self):
        self.assertTrue(
            null_block_imposes_no_condition(
                Fraction(0), Fraction(1, 3), Fraction(1)
            )
        )

    def test_in_the_finite_model_the_same_block_has_positive_weight(self):
        """`{0}` is a genuine positive-weight singleton in `Z/p^m`, which is
        why the finite argument had to invoke rigidity rather than nullity."""
        for p in (2, 3):
            for m in (2, 3, 4):
                N = p**m
                pi = valuation_lens(N, p, m)
                top = blocks_of(pi)[m]
                self.assertEqual(top, [0])
                self.assertEqual(Fraction(len(top), N), Fraction(1, p**m))
                self.assertGreater(Fraction(1, p**m), 0)

    def test_the_two_mechanisms_are_genuinely_different(self):
        """In the finite model the block can *violate* rigidity — a condition
        a null block could never state, since it contributes no equation."""
        found = False
        for p in (2, 3):
            for m in (2, 3):
                N = p**m
                pi = valuation_lens(N, p, m)
                for mod in range(2, N):
                    sg = [x % mod for x in range(N)]
                    if singleton_rigidity_violations(pi, sg):
                        found = True
                        break
        self.assertTrue(found)


if __name__ == "__main__":
    unittest.main()

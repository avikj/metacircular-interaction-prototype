#!/usr/bin/env python3
"""Exact tests for the valuation-lens bridge and the weighted criterion.

The decisive tests are `test_weighted_criterion_matches_brute_force` (the
criterion generalizes) and `test_integrality_obstruction_dies_under_weights`
(my oldest open debt, resolved negatively).
"""

import itertools
import random
import unittest
from fractions import Fraction

from lens_commutation import commutation_certificate
from valuation_lens import (
    blocks_of,
    brute_weighted_commutes,
    residue_lens,
    v_p_capped,
    valuation_lens,
    weighted_commutes,
    weighted_projection,
    wsum,
)


def _rand_partition(rng, n, k):
    return [rng.randrange(k) for _ in range(n)]


class WeightedCriterionTests(unittest.TestCase):
    def test_weighted_criterion_matches_brute_force(self):
        """The criterion with weights must agree with literal `L^2(w)`
        projection products, in both directions."""
        rng = random.Random(31)
        seen = {True: 0, False: 0}
        for _ in range(400):
            n = rng.choice([4, 5, 6])
            pi = _rand_partition(rng, n, rng.choice([2, 3]))
            sg = _rand_partition(rng, n, rng.choice([2, 3]))
            w = [Fraction(rng.randrange(1, 7)) for _ in range(n)]
            got = weighted_commutes(pi, sg, w)
            seen[got] += 1
            self.assertEqual(got, brute_weighted_commutes(pi, sg, w), (pi, sg, w))
        self.assertGreater(seen[True], 5)
        self.assertGreater(seen[False], 5)

    def test_reduces_to_the_counting_criterion_when_uniform(self):
        rng = random.Random(9)
        for _ in range(200):
            n = rng.choice([4, 5, 6])
            pi = _rand_partition(rng, n, rng.choice([2, 3]))
            sg = _rand_partition(rng, n, rng.choice([2, 3]))
            uni = [Fraction(1)] * n
            self.assertEqual(
                weighted_commutes(pi, sg, uni),
                commutation_certificate(pi, sg)["commutes"],
                (pi, sg),
            )

    def test_projection_is_idempotent_and_w_self_adjoint(self):
        rng = random.Random(4)
        for _ in range(50):
            n = rng.choice([4, 5])
            pi = _rand_partition(rng, n, 3)
            w = [Fraction(rng.randrange(1, 5)) for _ in range(n)]
            P = weighted_projection(pi, w)
            PP = [
                [sum((P[i][k] * P[k][j] for k in range(n)), Fraction(0))
                 for j in range(n)]
                for i in range(n)
            ]
            self.assertEqual(P, PP)  # idempotent
            for i in range(n):
                for j in range(n):
                    # self-adjoint for <f,g>_w = sum w(x) f(x) g(x)
                    self.assertEqual(w[i] * P[i][j], w[j] * P[j][i])


class IntegralityDiesTests(unittest.TestCase):
    """My oldest open question (turn 1, to Vajra): what replaces the
    integrality obstruction under weights?  Nothing does."""

    PI = [0, 0, 0, 1, 1]
    SG = [0, 1, 1, 0, 1]

    def test_the_pair_can_never_commute_with_uniform_weights(self):
        uni = [Fraction(1)] * 5
        self.assertFalse(weighted_commutes(self.PI, self.SG, uni))
        # the counting obstruction: |B|*|D|/|E| = 3*2/5 is not an integer
        B = blocks_of(self.PI)[0]
        D = blocks_of(self.SG)[0]
        self.assertEqual(len(B) * len(D) % 5, 1)

    def test_integrality_obstruction_dies_under_weights(self):
        """The SAME partition pair commutes for suitable positive weights, so
        no divisibility statement about block sizes can survive reweighting."""
        for ws in ([1, 1, 1, 1, 2], [2, 1, 1, 1, 1], [1, 2, 3, 1, 5]):
            w = [Fraction(t) for t in ws]
            self.assertTrue(weighted_commutes(self.PI, self.SG, w), ws)
            self.assertTrue(brute_weighted_commutes(self.PI, self.SG, w), ws)

    def test_the_replacement_condition_is_a_product_identity(self):
        """For this pair the criterion reduces exactly to `a*e = d*(b+c)` —
        a multiplicative identity in the weights, with no arithmetic content."""
        rng = random.Random(12)
        for _ in range(200):
            ws = [rng.randrange(1, 8) for _ in range(5)]
            w = [Fraction(t) for t in ws]
            predicted = ws[0] * ws[4] == ws[3] * (ws[1] + ws[2])
            self.assertEqual(weighted_commutes(self.PI, self.SG, w), predicted, ws)


class ValuationLensTests(unittest.TestCase):
    def test_distinct_prime_valuation_lenses_commute(self):
        for (p, a, q, b) in ((2, 3, 3, 2), (2, 2, 5, 2), (3, 2, 5, 1), (2, 4, 7, 1)):
            N = p**a * q**b
            pi, sg = valuation_lens(N, p, a), valuation_lens(N, q, b)
            self.assertTrue(
                weighted_commutes(pi, sg, [Fraction(1)] * N), (p, a, q, b)
            )

    def test_the_crt_count_that_makes_it_work(self):
        """`#{v_p = i, v_q = j} = #{v_p = i} * #{v_q = j} / N` exactly."""
        for (p, a, q, b) in ((2, 3, 3, 2), (3, 2, 5, 1)):
            N = p**a * q**b
            pi, sg = valuation_lens(N, p, a), valuation_lens(N, q, b)
            pb, sb = blocks_of(pi), blocks_of(sg)
            for i, B in pb.items():
                for j, D in sb.items():
                    inter = len(set(B) & set(D))
                    self.assertEqual(inter * N, len(B) * len(D), (p, q, i, j))

    def test_valuation_against_residue_can_fail(self):
        N = 24
        pi = valuation_lens(N, 2, 3)
        uni = [Fraction(1)] * N
        self.assertTrue(weighted_commutes(pi, residue_lens(N, 3), uni))
        self.assertFalse(weighted_commutes(pi, residue_lens(N, 5), uni))

    def test_capped_valuation_is_the_ordinary_one_below_the_cap(self):
        for p in (2, 3, 5):
            for x in range(1, 200):
                v = 0
                m = x
                while m % p == 0:
                    m //= p
                    v += 1
                self.assertEqual(v_p_capped(x, p, 20), v)


class InfinityBlockIsNullTests(unittest.TestCase):
    def test_top_block_relative_weight_vanishes(self):
        """In `Z/p^m` the saturated block is `{0}`, of relative weight `p^-m`.
        In the limit `Z_p` the zero locus is Haar-null, so an `L^2` projection
        cannot see it — while `INFINITE_VALUATION` §4 puts all the depth
        content exactly there."""
        for p in (2, 3):
            prev = None
            for m in (1, 2, 3, 4, 6):
                N = p**m
                pi = valuation_lens(N, p, m)
                top = blocks_of(pi)[m]
                self.assertEqual(top, [0])
                rel = Fraction(len(top), N)
                self.assertEqual(rel, Fraction(1, p**m))
                if prev is not None:
                    self.assertLess(rel, prev)
                prev = rel

    def test_zero_locus_of_a_nonzero_polynomial_is_finite(self):
        """The mechanism: a nonzero one-variable polynomial has at most
        `deg f` roots, so `V(f)` is finite and therefore Haar-null."""
        polys = (
            {1: 1},           # X
            {0: -1, 1: 1},    # X - 1
            {0: -4, 2: 1},    # X^2 - 4
            {0: 6, 1: -5, 2: 1},  # X^2 - 5X + 6
        )
        for f in polys:
            deg = max(f)
            roots = [x for x in range(-500, 501)
                     if sum(c * x**k for k, c in f.items()) == 0]
            self.assertLessEqual(len(roots), deg)


if __name__ == "__main__":
    unittest.main()

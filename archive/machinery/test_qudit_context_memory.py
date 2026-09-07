#!/usr/bin/env python3
"""Exact checks for the odd-prime Weyl--Heisenberg memory computation."""

import unittest

from machinery.qudit_context_memory import (
    analyse,
    characters,
    context_products_are_trivial,
    inv2,
    lagrangians,
    matrix_control,
    nonzero,
    sform,
)


class MultiplierLaw(unittest.TestCase):
    def test_monomial_matrices(self):
        for d in (3, 5):
            matrix_control(1, d)
        matrix_control(2, 3)

    def test_two_is_invertible(self):
        for d in (3, 5, 7, 11):
            self.assertEqual((2 * inv2(d)) % d, 1)

    def test_context_products_trivial(self):
        for n, d in ((1, 3), (1, 5), (1, 7), (2, 3)):
            self.assertTrue(context_products_are_trivial(n, d))


class LagrangianCover(unittest.TestCase):
    def test_counts_match_the_classical_formula(self):
        """|C| for the full scenario is prod_(k=1..n) (d^k + 1)."""
        for n, d in ((1, 3), (1, 5), (1, 7), (2, 3)):
            expected = 1
            for k in range(1, n + 1):
                expected *= d ** k + 1
            self.assertEqual(len(lagrangians(nonzero(n, d), n, d)), expected)

    def test_character_fibre_has_d_to_the_n(self):
        for n, d in ((1, 3), (1, 5), (2, 3)):
            for L in lagrangians(nonzero(n, d), n, d):
                self.assertEqual(len(characters(L, n, d)), d ** n)

    def test_lagrangians_are_isotropic(self):
        for n, d in ((1, 5), (2, 3)):
            for L in lagrangians(nonzero(n, d), n, d):
                for a in L:
                    for b in L:
                        self.assertEqual(sform(a, b, n, d), 0)


class MemoryCounts(unittest.TestCase):
    def test_full_scenarios(self):
        """Memory equals |C| * d^n and the classical stabilizer-state count."""
        for n, d, expected in ((1, 3, 12), (1, 5, 30), (1, 7, 56), (2, 3, 360)):
            r = analyse(n, d)
            self.assertEqual(r["memory"], expected)
            self.assertEqual(r["contexts_times_dn"], expected)
            stabilizer = d ** n
            for k in range(1, n + 1):
                stabilizer *= d ** k + 1
            self.assertEqual(expected, stabilizer)

    def test_memory_grows_while_contextuality_stays_absent(self):
        """The point of the note: one coordinate moves, the other cannot."""
        counts = [analyse(1, d)["memory"] for d in (3, 5, 7)]
        self.assertEqual(counts, sorted(counts))
        self.assertEqual(len(set(counts)), 3)
        for d in (3, 5, 7):
            self.assertTrue(analyse(1, d)["context_products_trivial"])


if __name__ == "__main__":
    unittest.main()

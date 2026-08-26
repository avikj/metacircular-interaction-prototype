#!/usr/bin/env python3
"""Exact tests for emergence in the finite hitting model.

The decisive tests are `test_monoid_membership_matches_the_model` (the
reformulation) and `test_g_parts_do_not_determine_emergence` (the no-go on the
shape of any criterion).
"""

import itertools
import unittest

from affine_emergence import (
    compose,
    emergence_census,
    g_part_undetermined,
    generated_monoid,
    hits_by_monoid,
    never_hitting_singles,
)
from hitting_decidable import EMERGENT_P2, additive, hits, multiplicative


class MonoidReformulationTests(unittest.TestCase):
    def test_monoid_membership_matches_the_model(self):
        """Exhaustive over all affine pairs for three moduli."""
        for p, e in ((2, 1), (3, 1), (2, 2)):
            M = p ** (e + 1)
            pool = [(g, c) for g in range(M) for c in range(M)]
            for pr in itertools.combinations(pool, 2):
                self.assertEqual(
                    hits(p, e, list(pr)), hits_by_monoid(p, e, list(pr)), (p, e, pr)
                )

    def test_matches_on_the_arithmetic_families_too(self):
        for p in (3, 5):
            for e in (1, 2):
                for mv in (
                    additive([1]),
                    additive([p ** (e + 1)]),
                    multiplicative([2]),
                    multiplicative([p]),
                    additive([1]) + multiplicative([2]),
                ):
                    self.assertEqual(hits(p, e, mv), hits_by_monoid(p, e, mv))

    def test_composition_is_associative_and_has_an_identity(self):
        M = 9
        elems = [(g, c) for g in range(M) for c in range(M)]
        ident = (1, 0)
        for f in elems[:20]:
            self.assertEqual(compose(f, ident, M), f)
            self.assertEqual(compose(ident, f, M), f)
        for f, g, h in itertools.islice(itertools.product(elems, repeat=3), 400):
            self.assertEqual(
                compose(compose(f, g, M), h, M), compose(f, compose(g, h, M), M)
            )

    def test_the_monoid_is_finite_and_closed(self):
        M = 9
        moves = [(2, 1), (3, 4)]
        mon = generated_monoid(moves, M)
        self.assertLessEqual(len(mon), M * M)
        for f in mon:
            for g in moves:
                self.assertIn(compose(f, (g[0] % M, g[1] % M), M), mon)


class EmergenceIsCommonTests(unittest.TestCase):
    def test_census_counts(self):
        """Pinned so a later change cannot quietly alter the claim."""
        self.assertEqual(
            emergence_census(2, 1),
            {"modulus": 4, "never_hitting_singles": 10, "pairs": 45, "emergent": 15},
        )
        self.assertEqual(
            emergence_census(3, 1),
            {"modulus": 9, "never_hitting_singles": 39, "pairs": 741, "emergent": 159},
        )

    def test_emergence_is_a_substantial_fraction(self):
        for p, e in ((2, 1), (3, 1), (2, 2)):
            c = emergence_census(p, e)
            self.assertGreater(c["emergent"] / c["pairs"], 0.15)

    def test_the_minimal_witness_is_among_them(self):
        m1, m2 = EMERGENT_P2
        self.assertFalse(hits(2, 1, [m1]))
        self.assertFalse(hits(2, 1, [m2]))
        self.assertTrue(hits(2, 1, [m1, m2]))
        self.assertTrue(hits_by_monoid(2, 1, [m1, m2]))


class NoGeneratorWiseCriterionTests(unittest.TestCase):
    def test_g_parts_do_not_determine_emergence(self):
        """Each undetermined `g`-part pair carries both an emergent and a
        non-emergent instance, so the multiplicative parts alone cannot
        decide."""
        for p, e, expected in ((3, 1, 19), (2, 2, 19)):
            und = g_part_undetermined(p, e)
            self.assertEqual(len(und), expected, (p, e, und))
            self.assertGreater(len(und), 0)

    def test_an_explicit_pair_of_pairs_with_equal_g_parts(self):
        """Two pairs sharing their multiplicative parts and differing in
        verdict — the concrete refutation."""
        p, e = 3, 1
        singles = never_hitting_singles(p, e)
        target = None
        for m1, m2 in itertools.combinations(singles, 2):
            for n1, n2 in itertools.combinations(singles, 2):
                if sorted((m1[0], m2[0])) != sorted((n1[0], n2[0])):
                    continue
                if hits(p, e, [m1, m2]) and not hits(p, e, [n1, n2]):
                    target = ((m1, m2), (n1, n2))
                    break
            if target:
                break
        self.assertIsNotNone(target)
        (a1, a2), (b1, b2) = target
        self.assertEqual(sorted((a1[0], a2[0])), sorted((b1[0], b2[0])))
        self.assertTrue(hits(p, e, [a1, a2]))
        self.assertFalse(hits(p, e, [b1, b2]))


if __name__ == "__main__":
    unittest.main()

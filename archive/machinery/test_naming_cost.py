#!/usr/bin/env python3
"""Exact tests for name-length accounting.

Run: python3 -m unittest test_naming_cost -v   (from machinery/)
"""

import math
import unittest

from naming_cost import (
    ARCHIMEDES_LOG10_REACH,
    ARCHIMEDES_UNIT,
    ARYABHATA_AVARGA,
    ARYABHATA_PLACES,
    ARYABHATA_VARGA,
    Allocation,
    archimedes,
    aryabhata,
    aryabhata_multiset_counts,
    aryabhata_syllable_values,
    length_needed,
    name_bound,
    positional,
    redundancy,
)


class NamingCostTests(unittest.TestCase):
    def test_counting_bound_is_the_same_shape_as_the_chain_bound(self):
        """Theorem X: names <= A^L, so L >= log(targets)/log A."""
        for alphabet in (2, 10, 60, 289, 10**8):
            for targets in (10**6, 10**12, 10**24):
                length = length_needed(alphabet, targets)
                self.assertGreaterEqual(name_bound(alphabet, length), targets)
                if length > 0:
                    self.assertLess(name_bound(alphabet, length - 1), targets)
                # the bound is exactly the logarithmic one
                self.assertAlmostEqual(
                    length, math.ceil(math.log(targets) / math.log(alphabet)),
                    delta=1)

    def test_aryabhata_syllable_values_are_correct(self):
        """Gitikapada 2: ka = 1, hau = 10^18, nine places two decades apart."""
        values = aryabhata_syllable_values()
        self.assertIn(1, values)                         # ka
        self.assertEqual(max(values), 100 * 100**8)      # hau
        self.assertEqual(max(values), 10**18)
        self.assertEqual(len(ARYABHATA_VARGA), 25)
        self.assertEqual(len(ARYABHATA_AVARGA), 8)
        self.assertEqual(len(ARYABHATA_PLACES), 9)
        # 33 consonants x 9 vowels = 297 syllables, but values collide
        self.assertEqual(len(values), 289)
        self.assertLess(len(values), 33 * 9)
        # the collisions are exactly consonant 100 against consonant 1 one
        # place up: 100 * 100^j == 1 * 100^(j+1)
        self.assertEqual(33 * 9 - len(values), 8)

    def test_the_three_allocations_are_distinct_kinds(self):
        tight = positional(10, 24)
        redundant = aryabhata(9)
        sparse = archimedes()
        # tight: names equal reach exactly
        self.assertAlmostEqual(math.log10(tight.names), tight.log10_reach,
                               places=6)
        # redundant: many more names than numbers in range
        self.assertGreater(math.log10(redundant.names), redundant.log10_reach)
        # sparse: reach dwarfs the name count
        self.assertGreater(sparse.log10_reach, math.log10(sparse.names) * 10**10)
        self.assertEqual((tight.kind, redundant.kind, sparse.kind),
                         ("tight", "redundant", "sparse"))

    def test_every_scheme_obeys_the_bound(self):
        """No allocation escapes Theorem X."""
        for allocation in (positional(10, 24), positional(60, 14),
                           aryabhata(3), aryabhata(9), archimedes()):
            self.assertLessEqual(
                allocation.names,
                name_bound(allocation.alphabet, allocation.length))

    def test_aryabhata_is_complete_and_redundant(self):
        """Exhaustive: every number below the ceiling is nameable, many ways."""
        covered, mean, worst = redundancy(300, 3)
        self.assertEqual(covered, 300)               # complete
        self.assertGreater(mean, 20)                 # and richly redundant
        self.assertEqual(worst, 97)
        covered_two, mean_two, _ = redundancy(100, 2)
        self.assertEqual(covered_two, 100)
        self.assertGreater(mean_two, 5)
        # fewer syllables leaves gaps: the redundancy is bought, not free
        partial, _, _ = redundancy(300, 2)
        self.assertLess(partial, 300)

    def test_multiset_counts_are_exact(self):
        counts = aryabhata_multiset_counts(50, 2)
        values = [v for v in aryabhata_syllable_values() if v <= 50]
        # a single syllable names each of its own values at least once
        for v in values:
            self.assertGreaterEqual(counts[v], 1)
        # 40 is nameable as itself and as several sums
        self.assertGreater(counts[40], 1)
        self.assertEqual(counts[0], 0)

    def test_archimedes_reach_against_name_count(self):
        """3 myriad-numbers name 10^24 things spread over 10^(8*10^16)."""
        sparse = archimedes()
        self.assertEqual(sparse.names, ARCHIMEDES_UNIT**3)
        self.assertEqual(math.log10(sparse.names), 24.0)
        self.assertEqual(sparse.log10_reach, float(ARCHIMEDES_LOG10_REACH))
        # the same name budget positionally reaches only 10^24
        self.assertEqual(positional(10, 24).names, sparse.names)
        self.assertLess(positional(10, 24).log10_reach, sparse.log10_reach)

    def test_known_false_control_a_rule_escapes_counting(self):
        """'a naming rule beats the counting bound' must fire as false."""
        # Archimedes' rule is a finite description with enormous reach, yet
        # it names no more than its alphabet and length allow.
        sparse = archimedes()
        self.assertLessEqual(sparse.names,
                             name_bound(sparse.alphabet, sparse.length))
        # and it cannot name an arbitrary integer in its range: the named set
        # is a vanishing fraction of the reach
        self.assertLess(math.log10(sparse.names) / sparse.log10_reach, 1e-10)

    def test_shape_and_rejections(self):
        allocation = positional(10, 3)
        self.assertIsInstance(allocation, Allocation)
        with self.assertRaises(Exception):
            allocation.names = 0
        with self.assertRaises(ValueError):
            name_bound(0, 3)
        with self.assertRaises(ValueError):
            length_needed(1, 100)
        with self.assertRaises(ValueError):
            positional(1, 3)
        with self.assertRaises(ValueError):
            aryabhata(0)
        with self.assertRaises(ValueError):
            aryabhata_multiset_counts(0, 2)


if __name__ == "__main__":
    unittest.main()

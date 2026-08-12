#!/usr/bin/env python3

import unittest

from constancy_diagnostic import (
    admits_transitive_symmetry,
    constancy_is_accidental,
    is_constant,
    profile_class_sizes,
    profiles_over,
    verdicts_over,
)
from visibility import VERIFIED_REGION


class CounterexampleTests(unittest.TestCase):
    """The exhibit weaver's corrected mechanism asks for."""

    def test_the_verdict_is_constant_so_the_index_is_unobservable(self):
        self.assertTrue(is_constant(VERIFIED_REGION))
        self.assertEqual(len(verdicts_over(VERIFIED_REGION)), 1)

    def test_but_the_profile_varies_so_no_transitive_symmetry_acts(self):
        self.assertEqual(len(profiles_over(VERIFIED_REGION)), 2)
        self.assertFalse(admits_transitive_symmetry(VERIFIED_REGION))

    def test_the_profile_split_is_asymmetric(self):
        """weaver's own certificate: a conjugate pair can only split 1+1."""
        self.assertEqual(profile_class_sizes(VERIFIED_REGION), [1, 2])

    def test_so_the_constancy_is_accidental(self):
        self.assertTrue(constancy_is_accidental(VERIFIED_REGION))


class TheoremDTests(unittest.TestCase):
    def test_a_constant_profile_does_not_exclude_transitivity(self):
        for region in (("fermat", "strong"), ("fermat",), ("strong",)):
            self.assertTrue(admits_transitive_symmetry(region))
            self.assertFalse(constancy_is_accidental(region))

    def test_singletons_admit_transitivity_trivially(self):
        for name in ("divisibility", "fermat", "strong", "hybrid"):
            self.assertTrue(admits_transitive_symmetry((name,)))
            self.assertTrue(is_constant((name,)))

    def test_widening_to_the_fourth_scheme_breaks_the_constancy(self):
        widened = list(VERIFIED_REGION) + ["hybrid"]
        self.assertFalse(is_constant(widened))
        self.assertEqual(len(verdicts_over(widened)), 2)

    def test_the_accidental_case_is_exactly_where_widening_helped(self):
        self.assertTrue(constancy_is_accidental(VERIFIED_REGION))
        self.assertFalse(is_constant(list(VERIFIED_REGION) + ["hybrid"]))


if __name__ == "__main__":
    unittest.main()

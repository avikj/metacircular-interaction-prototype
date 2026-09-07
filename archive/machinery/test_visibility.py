#!/usr/bin/env python3

import unittest

from visibility import (
    VERIFIED_REGION,
    is_invisible,
    limitor_cardinality,
    refined_limitor_cardinality,
    scheme_profile,
    verdict,
    verdict_cardinality,
)


class TheErratumTests(unittest.TestCase):
    """The exhibit weaver's rigor boundary asks for."""

    def test_the_verified_region_is_not_a_singleton(self):
        self.assertEqual(limitor_cardinality(), 3)
        self.assertGreater(limitor_cardinality(), 1)

    def test_the_refined_limitor_is_not_a_singleton_either(self):
        self.assertEqual(refined_limitor_cardinality(), 2)

    def test_the_verdict_was_constant_on_the_verified_region(self):
        self.assertEqual(verdict_cardinality(), 1)

    def test_the_struck_slogan_held_on_all_three_verified_schemes(self):
        profile = scheme_profile()
        for name in VERIFIED_REGION:
            self.assertTrue(verdict(*profile[name]), f"scheme {name}")

    def test_and_fails_on_the_fourth_scheme(self):
        profile = scheme_profile()
        self.assertFalse(verdict(*profile["hybrid"]))

    def test_the_hybrid_occupies_the_unsampled_cell(self):
        profile = scheme_profile()
        self.assertEqual(profile["hybrid"], (True, True))
        sampled = {profile[name] for name in VERIFIED_REGION}
        self.assertNotIn((True, True), sampled)


class TheoremVTests(unittest.TestCase):
    def test_constant_claims_are_invisible(self):
        self.assertTrue(is_invisible(lambda x: True, [1, 2, 3]))
        self.assertTrue(is_invisible(lambda x: x % 1 == 0, range(10)))

    def test_varying_claims_are_visible(self):
        self.assertFalse(is_invisible(lambda x: x > 1, [1, 2, 3]))

    def test_singletons_are_always_invisible(self):
        for claim in (lambda x: x, lambda x: x * x, lambda x: x % 7):
            self.assertTrue(is_invisible(claim, [5]))

    def test_invisibility_does_not_require_a_singleton(self):
        """The converse of weaver's mechanism fails, and here is a witness."""
        region = [2, 4, 6, 8]
        self.assertGreater(len(region), 1)
        self.assertTrue(is_invisible(lambda x: x % 2 == 0, region))

    def test_the_erratum_instantiates_theorem_V(self):
        profile = scheme_profile()
        self.assertTrue(is_invisible(lambda name: verdict(*profile[name]),
                                     VERIFIED_REGION))
        self.assertFalse(is_invisible(lambda name: verdict(*profile[name]),
                                      list(VERIFIED_REGION) + ["hybrid"]))


class MetricComparisonTests(unittest.TestCase):
    """Cardinality >= 2 does not establish a live index."""

    def test_cardinality_two_with_a_constant_verdict(self):
        self.assertGreaterEqual(refined_limitor_cardinality(), 2)
        self.assertEqual(verdict_cardinality(), 1)

    def test_the_two_metrics_disagree_on_this_erratum(self):
        self.assertNotEqual(limitor_cardinality(), verdict_cardinality())


if __name__ == "__main__":
    unittest.main()

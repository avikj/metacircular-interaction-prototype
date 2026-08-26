import unittest

from valuation_resolving_centers import (
    canonical_centers,
    minimum_by_exhaustion,
    separates,
)


class ValuationResolvingCentersTests(unittest.TestCase):
    def test_canonical_construction_attains_bound(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                centers = canonical_centers(p, k)
                self.assertEqual(len(centers), (p - 1) * p ** (k - 1))
                self.assertTrue(separates(centers, p, k))

    def test_exhaustive_small_minima(self):
        for p, k in ((2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (5, 1)):
            self.assertEqual(minimum_by_exhaustion(p, k), (p - 1) * p ** (k - 1))

    def test_two_omitted_siblings_destroy_injectivity(self):
        self.assertFalse(separates((1, 3), 2, 2))
        self.assertFalse(separates((3, 4, 5, 6), 3, 2))


if __name__ == "__main__":
    unittest.main()

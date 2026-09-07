import unittest

from machinery.limit_orbit_comparison import (
    equalizer_nonsurjective,
    product_noninjective,
    tree_positive_control,
)


class LimitOrbitComparisonTests(unittest.TestCase):
    def test_product_comparison_is_not_injective(self):
        source, images = product_noninjective()
        self.assertEqual(len(source), 2)
        self.assertEqual(len(set(images)), 1)

    def test_equalizer_comparison_is_not_surjective(self):
        source, target = equalizer_nonsurjective()
        self.assertEqual(len(source), 0)
        self.assertEqual(len(target), 1)

    def test_rooted_tree_lifts(self):
        self.assertEqual(tree_positive_control(), {0: 0, 1: 1, 2: 1})


if __name__ == "__main__":
    unittest.main()

import unittest
from fractions import Fraction

from machinery.equivariant_morse import (
    orbitwise_control_certificate,
    reflected_interval_certificate,
)


class EquivariantMorseTests(unittest.TestCase):
    def test_reflected_interval_obstruction(self):
        result = reflected_interval_certificate()
        self.assertTrue(result["chain_action"])
        self.assertEqual(result["best_ordinary_critical_cells"], 1)
        self.assertEqual(result["best_stable_critical_cells"], 3)
        self.assertEqual(result["stable_matchings"], (frozenset(),))

    def test_integral_nonsplitting_and_rational_half_section(self):
        result = reflected_interval_certificate()
        self.assertEqual(result["integral_augmentation_image_generator"], 2)
        self.assertFalse(result["integral_section_exists"])
        self.assertEqual(result["rational_section"],
                         (Fraction(1, 2), Fraction(1, 2)))

    def test_orbitwise_matching_control(self):
        result = orbitwise_control_certificate()
        self.assertTrue(result["chain_action"])
        self.assertTrue(result["matching_is_acyclic"])
        self.assertTrue(result["matching_is_stable"])
        self.assertTrue(result["matched_cells_are_disjoint"])
        self.assertEqual(result["critical_cells"], 2)


if __name__ == "__main__":
    unittest.main()

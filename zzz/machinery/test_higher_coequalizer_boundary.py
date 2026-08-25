import unittest

from machinery.higher_coequalizer_boundary import (
    compose,
    smith_arrow,
    smith_fixed_point_boundary,
)


class HigherCoequalizerBoundaryTests(unittest.TestCase):
    def test_smith_fixed_point_has_c3_automorphisms(self):
        result = smith_fixed_point_boundary()
        self.assertEqual(result["loop_powers"], (0, 1, 2))
        self.assertTrue(result["generator_is_nonidentity"])
        self.assertTrue(result["pi0_images_equal"])

    def test_groupoid_composition_is_mod_three(self):
        zero = (0, 0, 0)
        loops = [smith_arrow(zero, k) for k in range(3)]
        for a in range(3):
            for b in range(3):
                self.assertEqual(compose(loops[a], loops[b]), loops[(a + b) % 3])

    def test_free_orbit_has_no_nonidentity_stabilizer(self):
        moved = (0, 0, 1)
        self.assertNotEqual(smith_arrow(moved, 1).target, moved)
        self.assertNotEqual(smith_arrow(moved, 2).target, moved)
        self.assertEqual(smith_arrow(moved, 3).target, moved)


if __name__ == "__main__":
    unittest.main()

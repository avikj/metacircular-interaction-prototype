import unittest

from clean_rolling_compiler import fixed_level_centers, seam_jump


class CleanRollingCompilerTests(unittest.TestCase):
    def test_early_success_forces_upward_fixed_schedule_jump(self):
        for p in (3, 5, 7):
            for k in range(1, 5):
                modulus = p**k
                for ell in range(k):
                    scale = p**ell
                    prefix = scale - 1
                    for digit in range(p - 2):
                        self.assertEqual(
                            seam_jump(modulus, prefix, scale, p, digit),
                            (p - 2 - digit) * scale,
                        )

    def test_boundary_branches_have_no_upward_jump(self):
        for p in (2, 3, 5):
            centers = fixed_level_centers(p**3, 0, 1, p)
            self.assertEqual(seam_jump(p**3, 0, 1, p, p - 2), 0)
            omitted_next = p**3 - (p - 1)
            self.assertEqual(omitted_next - centers[-1], -1)


if __name__ == "__main__":
    unittest.main()


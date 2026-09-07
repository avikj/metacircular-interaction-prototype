import unittest
from fractions import Fraction

from aligned_measure_cone import is_aligned


RAYS = (
    (1, 0, 1, 0),
    (1, 0, 0, 0),
    (1, 1, 1, 1),
    (1, 2, 1, 0),
    (2, 1, 0, 1),
    (1, 1, 0, 0),
)


def diff_coordinates(x):
    return (x[2], x[0] - x[2], x[3], x[1] - x[3])


class BinaryDepthTwoRaysTests(unittest.TestCase):
    def test_all_six_rays_are_aligned(self):
        for ray in RAYS:
            self.assertTrue(is_aligned(ray, 2, 2))

    def test_coordinate_support_classification(self):
        expected = {
            (1, 0, 0, 0), (0, 1, 0, 0),
            (1, 0, 1, 0), (1, 0, 0, 2),
            (0, 2, 1, 0), (0, 1, 0, 1),
        }
        self.assertEqual({diff_coordinates(ray) for ray in RAYS}, expected)

    def test_mixed_rays_not_in_known_generator_cone(self):
        generators = (
            (1, 0, 0, 0), (1, 1, 0, 0),
            (1, 1, 1, 1), (1, 0, 1, 0),
        )
        # Solve the triangular coordinates directly. For each mixed target,
        # x3 forces the uniform coefficient; x2 then forces the dilation;
        # the remaining x0,x1 coefficients become inconsistent/nonnegative.
        for target in ((1, 2, 1, 0), (2, 1, 0, 1)):
            uniform = Fraction(target[3])
            dilation = Fraction(target[2]) - uniform
            pair = Fraction(target[1]) - uniform
            singleton = Fraction(target[0]) - uniform - dilation - pair
            coeffs = (singleton, pair, uniform, dilation)
            reconstructed = tuple(sum(c * g[i] for c, g in zip(coeffs, generators))
                                  for i in range(4))
            self.assertEqual(reconstructed, target)
            self.assertTrue(any(c < 0 for c in coeffs))

    def test_false_control_interval_three_is_not_extreme(self):
        interval_three = (1, 1, 1, 0)
        left = tuple(Fraction(v, 2) for v in (1, 0, 1, 0))
        right = tuple(Fraction(v, 2) for v in (1, 2, 1, 0))
        self.assertEqual(interval_three, tuple(a + b for a, b in zip(left, right)))
        self.assertTrue(is_aligned(interval_three, 2, 2))


if __name__ == "__main__":
    unittest.main()

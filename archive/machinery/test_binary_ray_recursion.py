import unittest
from fractions import Fraction

from aligned_measure_cone import is_aligned
from aligned_cone_recursion import interleave, split_low_digit


def normalize(ray):
    total = sum(ray)
    return tuple(Fraction(x, total) for x in ray)


def next_rays(rays):
    normalized = [normalize(r) for r in rays]
    lifts = [tuple(v for pair in zip(r, [0] * len(r)) for v in pair) for r in normalized]
    couplings = [tuple(v for pair in zip(r, s) for v in pair)
                 for r in normalized for s in normalized]
    return tuple(lifts + couplings)


class BinaryRayRecursionTests(unittest.TestCase):
    def test_counts(self):
        rays = ((1, 0), (1, 1))
        counts = [len(rays)]
        for _ in range(3):
            rays = next_rays(rays)
            self.assertEqual(len(set(rays)), len(rays))
            counts.append(len(rays))
        self.assertEqual(counts, [2, 6, 42, 1806])

    def test_every_constructed_ray_is_aligned(self):
        rays = next_rays(((1, 0), (1, 1)))
        for ray in rays:
            self.assertTrue(is_aligned(ray, 2, 2))

    def test_depth_two_matches_classification(self):
        rays = {normalize(r) for r in next_rays(((1, 0), (1, 1)))}
        known = {normalize(r) for r in (
            (1, 0, 1, 0), (1, 0, 0, 0), (1, 1, 1, 1),
            (1, 2, 1, 0), (2, 1, 0, 1), (1, 1, 0, 0))}
        self.assertEqual(rays, known)

    def test_false_control_aligned_children_wrong_totals(self):
        parent = interleave([[1, 0], [1, 1]])
        self.assertTrue(all(is_aligned(c, 2, 1) for c in split_low_digit(parent, 2)))
        self.assertFalse(is_aligned(parent, 2, 2))


if __name__ == "__main__":
    unittest.main()

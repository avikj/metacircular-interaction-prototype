import unittest
from fractions import Fraction

from aligned_measure_cone import is_aligned


def normalize(ray):
    total = sum(ray)
    return tuple(Fraction(x, total) for x in ray)


def next_rays(rays, p):
    rays = [normalize(r) for r in rays]
    out = []
    zero = [Fraction(0)] * len(rays[0])
    for m in range(1, p + 1):
        def build(prefix):
            if len(prefix) == m:
                children = list(prefix) + [tuple(zero)] * (p - m)
                out.append(tuple(children[x % p][x // p]
                                 for x in range(p * len(zero))))
                return
            for ray in rays:
                build(prefix + (ray,))
        build(())
    return tuple(out)


class PAryRayRecursionTests(unittest.TestCase):
    def test_depth_one_and_recursion_counts(self):
        for p in (2, 3, 4):
            rays = tuple(tuple([1] * m + [0] * (p - m)) for m in range(1, p + 1))
            children = next_rays(rays, p)
            self.assertEqual(len(children), sum(p**m for m in range(1, p + 1)))
            self.assertEqual(len(set(children)), len(children))

    def test_every_constructed_parent_is_aligned(self):
        for p in (2, 3):
            rays = tuple(tuple([1] * m + [0] * (p - m)) for m in range(1, p + 1))
            for parent in next_rays(rays, p):
                self.assertTrue(is_aligned(parent, p, 2))

    def test_ternary_depth_two_has_39_structural_rays(self):
        base = ((1, 0, 0), (1, 1, 0), (1, 1, 1))
        rays = next_rays(base, 3)
        self.assertEqual(len(rays), 39)

    def test_false_control_strict_gap_leaves_scaling_freedom(self):
        # Two aligned extreme children but unequal positive totals: aligned,
        # yet decomposable by independently scaling the two child measures.
        parent = (2, 1, 0, 0)  # p=2 interleaving children (2,0),(1,0)
        self.assertTrue(is_aligned(parent, 2, 2))
        left = (1, 0, 0, 0)
        right = (1, 1, 0, 0)
        self.assertEqual(parent, tuple(a + b for a, b in zip(left, right)))
        self.assertTrue(is_aligned(left, 2, 2))
        self.assertTrue(is_aligned(right, 2, 2))


if __name__ == "__main__":
    unittest.main()

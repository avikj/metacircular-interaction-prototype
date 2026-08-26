import unittest
from itertools import product

from aligned_cone_recursion import interleave, recursive_certificate, split_low_digit
from aligned_measure_cone import is_aligned


class AlignedConeRecursionTests(unittest.TestCase):
    def test_split_interleave_inverse(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                mu = list(range(p**k))
                self.assertEqual(interleave(split_low_digit(mu, p)), mu)

    def test_recursive_certificate_equals_flat_inequalities(self):
        for p, k in ((2, 1), (2, 2), (2, 3), (3, 1), (3, 2)):
            # Exact finite falsifier family, not a census claim.
            for mu in product(range(3), repeat=p**k):
                recursive, _ = recursive_certificate(list(mu), p, k)
                self.assertEqual(recursive, is_aligned(mu, p, k))

    def test_mixed_rays_are_equal_total_child_couplings(self):
        cases = {
            (1, 2, 1, 0): ([[1, 1], [2, 0]], (2, 2)),
            (2, 1, 0, 1): ([[2, 0], [1, 1]], (2, 2)),
        }
        for ray, (children, totals) in cases.items():
            self.assertEqual(split_low_digit(ray, 2), children)
            valid, certificate = recursive_certificate(ray, 2, 2)
            self.assertTrue(valid)
            self.assertEqual(certificate[0], totals)

    def test_false_control_ordered_totals_are_load_bearing(self):
        children = [[1, 0], [1, 1]]
        self.assertTrue(all(recursive_certificate(child, 2, 1)[0] for child in children))
        parent = interleave(children)
        self.assertEqual(parent, [1, 1, 0, 1])
        self.assertFalse(recursive_certificate(parent, 2, 2)[0])


if __name__ == "__main__":
    unittest.main()

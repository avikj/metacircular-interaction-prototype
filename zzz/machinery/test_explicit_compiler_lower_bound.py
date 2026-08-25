import unittest

from explicit_compiler_lower_bound import lower_bound, required_objects


class ExplicitCompilerLowerBoundTests(unittest.TestCase):
    def test_required_sets_have_only_initial_center_overlap(self):
        for p in (2, 3, 5, 7):
            for k in range(1, 7):
                powers, centers = required_objects(p, k)
                self.assertEqual(len(centers), k * (p - 1))
                self.assertEqual(len(set(centers)), len(centers))
                self.assertEqual(powers.intersection(centers), {p**k} if k > 1 else set())

    def test_exact_object_count(self):
        for p in (2, 3, 5, 7):
            for k in range(1, 7):
                self.assertEqual(lower_bound(p, k), k * p - 2)


if __name__ == "__main__":
    unittest.main()


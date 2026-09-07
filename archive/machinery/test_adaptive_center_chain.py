import unittest

from adaptive_center_chain import center_chain


class AdaptiveCenterChainTests(unittest.TestCase):
    def test_every_residue_reconstructs_with_one_chain(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                for r in range(p**k):
                    centers, deps, prefix = center_chain(r, p, k)
                    self.assertEqual(prefix, r)
                    self.assertLessEqual(len(deps), len(centers) - 1)
                    for left, step, right in deps:
                        self.assertGreater(right, 0)
                        self.assertEqual(left - step, right)

    def test_worst_branch_exact_counts(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                centers, deps, _ = center_chain(p**k - 1, p, k)
                self.assertEqual(len(centers), k * (p - 1))
                self.assertEqual(len(deps), k * (p - 1) - 1)
                self.assertEqual(centers[0], p**k)


if __name__ == "__main__":
    unittest.main()

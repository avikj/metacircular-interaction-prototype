import unittest

from adaptive_center_chain import center_chain
from output_sensitive_clean_cost import cost


class OutputSensitiveCleanCostTests(unittest.TestCase):
    def test_formula_matches_every_bounded_branch(self):
        for p in (2, 3, 5):
            for k in range(1, 5):
                for r in range(p**k):
                    report = cost(r, p, k)
                    centers, subtractions, recovered = center_chain(r, p, k)
                    self.assertEqual(recovered, r)
                    self.assertEqual(report["queries"], len(centers))
                    self.assertEqual(report["subtractions"], len(subtractions))

    def test_extremes(self):
        for p in (2, 3, 5, 7):
            for k in range(1, 6):
                zero = cost(0, p, k)
                worst = cost(p**k - 1, p, k)
                self.assertEqual((zero["queries"], zero["subtractions"]), (k, 0))
                self.assertEqual(worst["queries"], k * (p - 1))
                self.assertEqual(worst["subtractions"], k * (p - 1) - 1)


if __name__ == "__main__":
    unittest.main()


import unittest

from adaptive_valuation_identification import minimax_queries


class AdaptiveValuationIdentificationTests(unittest.TestCase):
    def test_exact_small_minimax_values(self):
        for p, k in ((2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (5, 1)):
            self.assertEqual(minimax_queries(p, k), k * (p - 1))

    def test_adaptivity_beats_nonadaptive_except_first_level(self):
        for p, k in ((2, 3), (3, 2)):
            adaptive = minimax_queries(p, k)
            nonadaptive = (p - 1) * p ** (k - 1)
            self.assertLess(adaptive, nonadaptive)


if __name__ == "__main__":
    unittest.main()


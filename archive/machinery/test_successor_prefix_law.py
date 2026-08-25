import unittest

from successor_prefix_law import (
    brute_cost,
    conditional_counts,
    digit,
    digit_count_formula,
    expected_cost_formula,
)


class SuccessorPrefixLawTests(unittest.TestCase):
    def test_every_reached_prefix_is_monotone(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                for N in range(1, p**k + 1):
                    for ell in range(k):
                        for u in range(p**ell):
                            counts = conditional_counts(N, p, ell, u)
                            actual = [sum(digit(r, p, ell) == d and r % (p**ell) == u
                                          for r in range(N)) for d in range(p)]
                            self.assertEqual(counts, actual)
                            self.assertTrue(all(a >= b for a, b in zip(counts, counts[1:])))

    def test_closed_digit_counts(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                for N in range(1, p**k + 1):
                    for ell in range(k):
                        for d in range(p):
                            actual = sum(digit(r, p, ell) == d for r in range(N))
                            self.assertEqual(digit_count_formula(N, p, ell, d), actual)

    def test_cost_formula(self):
        for p in (2, 3, 5):
            for k in range(1, 4):
                for N in range(1, p**k + 1):
                    self.assertEqual(expected_cost_formula(N, p, k), brute_cost(N, p, k))

    def test_endpoints_and_translated_false_control(self):
        self.assertEqual(expected_cost_formula(1, 5, 3), (3, 0))
        # Translation rotates the excess next-digit block: {1,2} mod 3.
        translated_counts = [0, 1, 1]
        self.assertFalse(all(a >= b for a, b in zip(translated_counts, translated_counts[1:])))


if __name__ == "__main__":
    unittest.main()

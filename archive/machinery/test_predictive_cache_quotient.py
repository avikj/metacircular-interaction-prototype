import unittest

from predictive_cache_quotient import critical_pair, distance


def valuation_two(n: int) -> int:
    v = 0
    while n % 2 == 0:
        n //= 2
        v += 1
    return v


class PredictiveCacheQuotientTests(unittest.TestCase):
    def test_every_bounded_positive_integer_is_a_critical_representative(self):
        for r in range(1, 65):
            a, b, v = critical_pair(r)
            self.assertGreater(a, 0)
            self.assertGreater(b, 0)
            self.assertEqual(valuation_two(a + b), v)
            modulus = 2 ** (v + 1)
            self.assertEqual((-a) % modulus or modulus, r)

    def test_interval_caches_give_distinct_profiles(self):
        for n in range(2, 6):
            for m in range(n + 1, 7):
                target = 2 * m
                self.assertEqual(distance(set(range(1, m + 1)), target), 1)
                self.assertGreater(distance(set(range(1, n + 1)), target), 1)

    def test_previous_option_value_is_a_profile_separation(self):
        self.assertEqual(distance({1, 2, 3, 6}, 9), 1)
        self.assertEqual(distance({1, 2, 4, 6}, 9), 2)


if __name__ == "__main__":
    unittest.main()


#!/usr/bin/env python3
import unittest

from prosodic_recurrence import certificate, count, count_by_heavy, rhythms, split_first


class ProsodicRecurrenceTests(unittest.TestCase):
    def test_boundary_counts(self):
        self.assertEqual((count(0), count(1), count(2)), (1, 1, 2))

    def test_first_syllable_is_a_bijection(self):
        for n in range(2, 13):
            light, heavy = split_first(n)
            self.assertEqual(light, rhythms(n - 1))
            self.assertEqual(heavy, rhythms(n - 2))

    def test_binomial_distribution(self):
        for n in range(13):
            self.assertEqual(sum(v for _, v in count_by_heavy(n)), count(n))

    def test_aime_level_instance(self):
        result = certificate(12)
        self.assertEqual(result["count"], 233)
        self.assertEqual(result["binomial_sum"], 233)
        self.assertTrue(result["light_first_bijection"])
        self.assertTrue(result["heavy_first_bijection"])

    def test_invalid_split_fails_closed(self):
        with self.assertRaises(ValueError):
            split_first(1)


if __name__ == "__main__":
    unittest.main()

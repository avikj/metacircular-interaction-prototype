import itertools
import unittest

from prefix_cache_submodularity import optimal_value, value


PARENT = {"r": None, "a": "r", "b": "r", "c": "a", "d": "a", "e": "b"}
WEIGHTS = {"a": 1, "b": 2, "c": 4, "d": 3, "e": 5}
VERTICES = tuple(PARENT)


class PrefixCacheTests(unittest.TestCase):
    def test_monotone_submodular_exhaustively(self):
        subsets = [set(v for bit, v in zip(mask, VERTICES) if bit)
                   for mask in itertools.product((0, 1), repeat=len(VERTICES))]
        for left in subsets:
            for right in subsets:
                self.assertGreaterEqual(
                    value(PARENT, WEIGHTS, left) + value(PARENT, WEIGHTS, right),
                    value(PARENT, WEIGHTS, left | right) + value(PARENT, WEIGHTS, left & right),
                )

    def test_dynamic_program_matches_exhaustive_optimum(self):
        for budget in range(len(VERTICES) + 1):
            brute = max(value(PARENT, WEIGHTS, set(s))
                        for k in range(budget + 1)
                        for s in itertools.combinations(VERTICES, k))
            self.assertEqual(optimal_value(PARENT, WEIGHTS, budget), brute)

    def test_equal_cardinality_is_known_false_summary(self):
        self.assertEqual(len({"a"}), len({"b"}))
        self.assertNotEqual(value(PARENT, WEIGHTS, {"a"}), value(PARENT, WEIGHTS, {"b"}))

    def test_negative_weight_breaks_monotonicity(self):
        self.assertLess(value(PARENT, {"c": -1}, {"a"}), value(PARENT, {"c": -1}, set()))


if __name__ == "__main__":
    unittest.main()

import unittest
from collections import Counter
from itertools import permutations
from math import factorial


def fiber_size(multiset):
    counts = Counter(multiset).values()
    out = factorial(len(multiset))
    for c in counts:
        out //= factorial(c)
    return out


class UnorderedCouplingFiberTests(unittest.TestCase):
    def test_multinomial_fibers(self):
        for items, expected in ((("a", "b", "c"), 6), (("a", "a", "b"), 3),
                                (("a", "a", "a"), 1), (("a", "a", "b", "b"), 6)):
            self.assertEqual(fiber_size(items), expected)
            self.assertEqual(len(set(permutations(items))), expected)

    def test_worst_distinct_is_factorial(self):
        for m in range(1, 8):
            self.assertEqual(fiber_size(tuple(range(m))), factorial(m))

    def test_false_control_repetitions_reduce_fiber(self):
        self.assertLess(fiber_size(("a", "a", "b")), factorial(3))


if __name__ == "__main__":
    unittest.main()

import itertools
import unittest


def saved(trace, cache):
    return max((i for i, value in enumerate(trace) if value in cache), default=0)


def utility(traces, weights, cache):
    return sum(weight * saved(trace, cache) for trace, weight in zip(traces, weights))


class CacheOptionSubmodularityTests(unittest.TestCase):
    def test_diminishing_returns_exhaustively(self):
        traces = ((1, 2, 4, 5), (1, 2, 3, 6), (1, 3, 7, 14))
        weights = (2, 3, 1)
        universe = sorted(set().union(*map(set, traces)))
        subsets = [set(c) for r in range(len(universe) + 1)
                   for c in itertools.combinations(universe, r)]
        for a in subsets:
            for b in subsets:
                if not a <= b:
                    continue
                for x in set(universe) - b:
                    gain_a = utility(traces, weights, a | {x}) - utility(traces, weights, a)
                    gain_b = utility(traces, weights, b | {x}) - utility(traces, weights, b)
                    self.assertGreaterEqual(gain_a, gain_b)

    def test_equal_utility_does_not_equal_state(self):
        traces = ((1, 2, 4, 5), (1, 2, 3, 6))
        weights = (1, 1)
        left, right = {1, 2, 4, 5}, {1, 2, 3, 6}
        self.assertEqual(utility(traces, weights, left), utility(traces, weights, right))
        self.assertNotEqual(left, right)
        self.assertNotEqual(
            tuple(saved(t, left) for t in traces),
            tuple(saved(t, right) for t in traces),
        )


if __name__ == "__main__":
    unittest.main()

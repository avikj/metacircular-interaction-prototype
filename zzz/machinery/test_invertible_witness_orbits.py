import unittest
from collections import deque


def compose(p, q):
    return tuple(p[q[x]] for x in range(len(p)))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    seen, queue = {identity}, deque([identity])
    while queue:
        g = queue.popleft()
        for a in generators:
            h = compose(a, g)
            if h not in seen:
                seen.add(h)
                queue.append(h)
    return seen


def pair_orbit(pair, group):
    return {(g[pair[0]], g[pair[1]]) for g in group}


def split_orbits(states, generators, observations):
    group = generated_group(generators)
    result = {}
    for x in states:
        for y in states:
            orbit = frozenset(pair_orbit((x, y), group))
            result[(x, y)] = any(
                observation[u] != observation[v]
                for observation in observations for u, v in orbit
            )
    return result


class InvertibleWitnessOrbitTests(unittest.TestCase):
    def test_s3_coloring_splits_distinct_pairs(self):
        # a=(01), b=(12), generating S3.
        a, b = (1, 0, 2), (0, 2, 1)
        color = (0, 0, 1)
        split = split_orbits(range(3), (a, b), (color,))
        self.assertTrue(all(split[x, y] for x in range(3) for y in range(3) if x != y))
        self.assertTrue(all(not split[x, x] for x in range(3)))

    def test_withdrawal_is_orbitwise(self):
        cycle = (1, 2, 3, 0)
        first = (0, 1, 0, 0)
        second = (0, 0, 1, 0)
        both = split_orbits(range(4), (cycle,), (first, second))
        after = split_orbits(range(4), (cycle,), (second,))
        # Removing one label leaves every distinct diagonal orbit that has a
        # surviving seed split; semantic status is constant on each orbit.
        group = generated_group((cycle,))
        for pair in ((0, 1), (0, 2), (0, 3)):
            orbit = pair_orbit(pair, group)
            self.assertEqual({after[p] for p in orbit}, {after[pair]})
        self.assertTrue(any(both[p] and after[p] for p in both))

    def test_noninvertible_kill_control(self):
        # 0->1->2, 2->2.  (0,1) reaches seed (1,2), but not conversely.
        step = lambda x: min(x + 1, 2)
        observation = lambda x: x == 2
        self.assertFalse(observation(0) != observation(1))
        self.assertTrue(observation(step(0)) != observation(step(1)))
        self.assertNotEqual({step(0), step(1), step(2)}, {0, 1, 2})


if __name__ == "__main__":
    unittest.main()

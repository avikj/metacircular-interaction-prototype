import unittest

from depth_memory_nonmonotonicity import (
    residue_charts,
    selected_chart_memory,
    valuation_world_profile,
)


class DepthMemoryNonmonotonicityTests(unittest.TestCase):
    def test_refinement_never_increases_memory_on_fixed_world(self):
        world = tuple(range(17))
        charts = residue_charts(2, 5)
        costs = [selected_chart_memory(world, charts, k) for k in range(6)]
        self.assertTrue(all(a >= b for a, b in zip(costs, costs[1:])))

    def test_depth_rises_while_memory_falls(self):
        before = valuation_world_profile((5, 10, 15, 20), 5, 2)
        after = valuation_world_profile((5, 10, 15, 20, 25), 5, 2)
        self.assertEqual(before, (0, 4))
        self.assertEqual(after, (2, 1))

    def test_depth_fixed_while_memory_rises(self):
        self.assertEqual(valuation_world_profile((1,), 3, 1), (0, 1))
        self.assertEqual(valuation_world_profile((1, 3, 4, 6), 3, 1), (1, 2))
        # A pure same-output growth control keeps depth zero and grows memory.
        self.assertEqual(valuation_world_profile((1, 2), 3, 1), (0, 2))

    def test_binary_staircase_has_constant_unit_memory(self):
        prime, exponent = 2, 7
        x = prime**exponent
        worlds = [(x,)]
        for j in range(1, exponent + 1):
            worlds.append(worlds[-1] + (x + prime ** (j - 1),))
        worlds.append(worlds[-1] + (prime ** (exponent + 1),))
        profiles = [valuation_world_profile(world, prime, exponent + 1)
                    for world in worlds]
        self.assertEqual([depth for depth, _ in profiles], list(range(exponent + 2)))
        self.assertEqual([memory for _, memory in profiles], [1] * (exponent + 2))


if __name__ == "__main__":
    unittest.main()

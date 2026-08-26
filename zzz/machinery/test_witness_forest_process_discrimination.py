import unittest

from witness_forest_process_discrimination import (
    bfs_discrimination_depths,
    deterministic_trace_distance,
    shortest_discrimination_experiment,
)


class WitnessForestProcessDiscriminationTests(unittest.TestCase):
    def test_trace_distance_is_zero_or_one(self):
        self.assertEqual(deterministic_trace_distance("a", "a"), 0)
        self.assertEqual(deterministic_trace_distance("a", "b"), 1)

    def test_bfs_depth_equals_exhaustive_discrimination_depth(self):
        states = tuple(range(4))
        actions = (
            ("up", lambda x: min(x + 1, 3)),
            ("down", lambda x: max(x - 1, 0)),
        )
        observations = (("is3", lambda x: x == 3), ("parity", lambda x: x % 2))
        depths = bfs_discrimination_depths(states, actions, observations)
        for pair, depth in depths.items():
            experiment = shortest_discrimination_experiment(
                pair[0], pair[1], actions, observations, 4
            )
            self.assertIsNotNone(experiment)
            self.assertEqual(experiment["action_depth"], depth)

    def test_terminal_observation_is_separate_from_action_depth(self):
        actions = (("up", lambda x: min(x + 1, 2)),)
        observations = (("is2", lambda x: x == 2),)
        experiment = shortest_discrimination_experiment(0, 1, actions, observations, 3)
        self.assertEqual(experiment["action_depth"], 1)
        self.assertEqual(experiment["word"], ("up",))
        self.assertEqual(experiment["observation"], "is2")

    def test_indistinguishable_pair_has_no_experiment(self):
        actions = (("identity", lambda x: x),)
        observations = (("constant", lambda x: 0),)
        self.assertIsNone(shortest_discrimination_experiment(0, 1, actions, observations, 5))


if __name__ == "__main__":
    unittest.main()

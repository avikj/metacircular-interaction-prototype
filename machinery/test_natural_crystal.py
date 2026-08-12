import unittest

from natural_crystal import crystallize, twelve_link_machine


class NaturalCrystalTests(unittest.TestCase):
    def test_context_distinguishes_equal_present_outputs(self):
        states = ("p", "q", "bright", "dark")
        actions = ("probe",)
        transition = {
            ("p", "probe"): "bright",
            ("q", "probe"): "dark",
            ("bright", "probe"): "bright",
            ("dark", "probe"): "dark",
        }
        observation = {"p": 0, "q": 0, "bright": 1, "dark": 2}
        crystal = crystallize(states, actions, transition, observation)
        self.assertEqual(len(crystal.fibers), 4)

    def test_origins_survive_true_crystallization(self):
        states = ("a", "b", "end")
        actions = ("step",)
        transition = {
            ("a", "step"): "end",
            ("b", "step"): "end",
            ("end", "step"): "end",
        }
        observation = {"a": 0, "b": 0, "end": 1}
        crystal = crystallize(states, actions, transition, observation)
        self.assertIn(("a", "b"), crystal.fibers)

    def test_twelve_fixture_retains_declared_links(self):
        crystal = twelve_link_machine()
        self.assertEqual(len(crystal.fibers), 13)
        self.assertEqual(set(sum((list(f) for f in crystal.fibers), [])),
                         set(range(13)))

    def test_rejects_partial_dynamics(self):
        with self.assertRaises(ValueError):
            crystallize((0, 1), ("a",), {(0, "a"): 1}, {0: 0, 1: 1})


if __name__ == "__main__":
    unittest.main()

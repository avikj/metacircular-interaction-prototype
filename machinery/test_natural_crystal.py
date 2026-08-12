import unittest

from natural_crystal import (
    compile_experiment,
    crystallize,
    explain_distinctions,
    run_word,
    shortest_distinguishing_word,
    twelve_link_machine,
)


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
        word = shortest_distinguishing_word(
            "p", "q", actions, transition, observation
        )
        self.assertEqual(word, ("probe",))
        self.assertNotEqual(
            observation[run_word("p", word, transition)],
            observation[run_word("q", word, transition)],
        )

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
        self.assertIsNone(shortest_distinguishing_word(
            "a", "b", actions, transition, observation
        ))

    def test_every_crystal_fiber_is_exactly_the_none_witness_pairs(self):
        states = (0, 1, 2, 3)
        actions = ("next",)
        transition = {
            (0, "next"): 1,
            (1, "next"): 2,
            (2, "next"): 3,
            (3, "next"): 3,
        }
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        crystal = crystallize(states, actions, transition, observation)
        explanations = explain_distinctions(
            states, actions, transition, observation
        )
        same_fiber = {
            tuple(sorted((left, right)))
            for fiber in crystal.fibers
            for index, left in enumerate(fiber)
            for right in fiber[index + 1:]
        }
        no_witness = {
            tuple(sorted(pair)) for pair, word in explanations.items()
            if word is None
        }
        self.assertEqual(no_witness, same_fiber)
        self.assertEqual(explanations[(0, 1)], ("next", "next"))
        self.assertEqual(explanations[(1, 2)], ("next",))

    def test_discovered_experiment_becomes_one_action_without_new_meaning(self):
        states = (0, 1, 2, 3)
        actions = ("next",)
        transition = {
            (0, "next"): 1,
            (1, "next"): 2,
            (2, "next"): 3,
            (3, "next"): 3,
        }
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        before = crystallize(states, actions, transition, observation)
        old_word = shortest_distinguishing_word(
            0, 1, actions, transition, observation
        )
        self.assertEqual(old_word, ("next", "next"))

        new_actions, new_transition = compile_experiment(
            states, actions, transition, "look-two", old_word
        )
        after = crystallize(states, new_actions, new_transition, observation)
        self.assertEqual(after.fibers, before.fibers)
        self.assertEqual(shortest_distinguishing_word(
            0, 1, new_actions, new_transition, observation
        ), ("look-two",))

    def test_compilation_fails_closed(self):
        transition = {(0, "step"): 0}
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "step", ("step",))
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "new", ())
        with self.assertRaises(ValueError):
            compile_experiment((0,), ("step",), transition, "new", ("missing",))

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

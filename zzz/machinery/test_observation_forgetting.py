import unittest

from observation_forgetting import (
    forget_observation,
    is_group,
    minimal_reversibility_example,
)


class ObservationForgettingTests(unittest.TestCase):
    def test_minimal_reversibility_reversal(self):
        result = minimal_reversibility_example()
        self.assertEqual(len(result.rich.fibers), 3)
        self.assertEqual(len(result.coarse.fibers), 2)
        self.assertFalse(is_group(result.rich_monoid))
        self.assertTrue(is_group(result.coarse_monoid))

    def test_monoid_map_is_surjective(self):
        result = minimal_reversibility_example()
        self.assertEqual(set(result.monoid_map), set(range(len(result.coarse_monoid))))
        self.assertEqual(len(result.rich_monoid), 2)
        self.assertEqual(len(result.coarse_monoid), 1)

    def test_cyclic_forgetting_c4_to_c2(self):
        states = tuple(range(4))
        actions = ("next",)
        transition = {(x, "next"): (x + 1) % 4 for x in states}
        result = forget_observation(
            states, actions, transition,
            {x: x for x in states}, {x: x % 2 for x in states},
        )
        self.assertEqual(len(result.rich_monoid), 4)
        self.assertEqual(len(result.coarse_monoid), 2)
        self.assertTrue(is_group(result.rich_monoid))
        self.assertTrue(is_group(result.coarse_monoid))

    def test_rejects_unrelated_observation(self):
        states = (0, 1)
        transition = {(x, "stay"): x for x in states}
        with self.assertRaises(ValueError):
            forget_observation(
                states, ("stay",), transition,
                {0: 0, 1: 0}, {0: 0, 1: 1},
            )

    def test_two_states_cannot_have_nontrivial_reversal(self):
        # Any proper quotient of two states has one state; retained action
        # semantics is then wholly trivial. The three-state example is the
        # least one whose forgotten quotient still distinguishes two worlds.
        result = forget_observation(
            (0, 1), ("reset",),
            {(0, "reset"): 0, (1, "reset"): 0},
            {0: 0, 1: 1}, {0: 0, 1: 0},
        )
        self.assertEqual(len(result.coarse.fibers), 1)


if __name__ == "__main__":
    unittest.main()

import unittest

from formation_relative_quantum_memory import (
    formed_memory_dimension,
    residue_formed_cost,
    restriction_profile,
)


class FormationRelativeQuantumMemoryTests(unittest.TestCase):
    def test_restriction_can_hide_ambient_maximum_fiber(self):
        profile = restriction_profile(range(12), (0, 1, 2), lambda x: x % 3)
        self.assertEqual(profile["ambient_dimension"], 4)
        self.assertEqual(profile["formed_dimension"], 1)
        self.assertFalse(profile["certifies_ambient_dimension"])

    def test_restriction_cost_is_monotone(self):
        sensor = lambda x: x % 3
        chain = ((0,), (0, 1, 2), tuple(range(6)), tuple(range(12)))
        costs = [formed_memory_dimension(states, sensor) for states in chain]
        self.assertEqual(costs, [1, 1, 2, 4])

    def test_every_finite_residue_world_has_finite_cost(self):
        for frontier in (1, 7, 91, 1000):
            self.assertEqual(
                residue_formed_cost(range(frontier), 7),
                (frontier + 6) // 7,
            )

    def test_invalid_domains_fail_closed(self):
        with self.assertRaises(ValueError):
            formed_memory_dimension((), lambda x: x)
        with self.assertRaises(ValueError):
            restriction_profile((0, 1), (2,), lambda x: x)


if __name__ == "__main__":
    unittest.main()


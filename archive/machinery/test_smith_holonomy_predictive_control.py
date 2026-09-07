import unittest

from machinery.smith_holonomy_predictive_control import (
    element_order,
    holonomy_world,
    invariant_observation_collapses_future,
)
from machinery.smith_path_holonomy import witness


class SmithHolonomyPredictiveControlTests(unittest.TestCase):
    def test_nontrivial_transport_preserves_element_order(self):
        *_, before, after, _ = witness()
        self.assertNotEqual(before, after)
        self.assertEqual(element_order(before), element_order(after))

    def test_order_task_has_exactly_four_predictive_states(self):
        crystal = holonomy_world(element_order)
        self.assertEqual(len(crystal.fibers), 4)
        self.assertEqual(set(crystal.observations), {1, 2, 3, 6})
        self.assertTrue(invariant_observation_collapses_future(element_order))

    def test_coordinate_sensitive_false_control_refines(self):
        coordinate = lambda value: value[1]
        crystal = holonomy_world(coordinate)
        self.assertFalse(invariant_observation_collapses_future(coordinate))
        self.assertEqual(len(crystal.fibers), 4)
        self.assertEqual(len(set(crystal.observations)), 2)

    def test_identity_observation_retains_all_classes(self):
        crystal = holonomy_world(lambda value: value)
        self.assertEqual(len(crystal.fibers), 12)


if __name__ == "__main__":
    unittest.main()

import unittest

from minimal_mixed_mod5_control import (
    capability_changing_controls,
    mixed_classes,
    mixed_dimension,
)


class MinimalMixedMod5ControlTests(unittest.TestCase):
    def test_complete_single_control_classification(self):
        self.assertEqual({b: mixed_dimension(b) for b in range(5)}, {0: 4, 1: 4, 2: 5, 3: 5, 4: 4})
        self.assertEqual(capability_changing_controls(), frozenset({2, 3}))

    def test_two_or_three_make_partition_discrete(self):
        discrete = frozenset({frozenset({a}) for a in range(5)})
        self.assertEqual(mixed_classes(2), discrete)
        self.assertEqual(mixed_classes(3), discrete)

    def test_zero_one_four_preserve_autonomous_pair(self):
        for foreign in (0, 1, 4):
            self.assertIn(frozenset({2, 3}), mixed_classes(foreign))

    def test_no_intermediate_dimension_exists(self):
        self.assertTrue(all(mixed_dimension(b) in (4, 5) for b in range(5)))


if __name__ == "__main__":
    unittest.main()

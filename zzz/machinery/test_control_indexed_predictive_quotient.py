import unittest

from control_indexed_predictive_quotient import (
    autonomous_classes,
    full_intervention_classes,
    intervention_signature,
    refines,
    zero_error_dimension,
)


class ControlIndexedPredictiveQuotientTests(unittest.TestCase):
    def test_same_monoid_has_two_exact_dimensions(self):
        self.assertEqual(zero_error_dimension(autonomous_classes()), 4)
        self.assertEqual(zero_error_dimension(full_intervention_classes()), 5)

    def test_full_intervention_refines_autonomous(self):
        self.assertTrue(refines(full_intervention_classes(), autonomous_classes()))
        self.assertFalse(refines(autonomous_classes(), full_intervention_classes()))

    def test_hostile_intervention_separates_two_and_three(self):
        self.assertNotEqual(intervention_signature(2), intervention_signature(3))
        self.assertEqual(intervention_signature(2)[2], "other")
        self.assertEqual(intervention_signature(3)[2], "one")

    def test_full_intervention_partition_is_discrete(self):
        self.assertEqual(full_intervention_classes(), frozenset({frozenset({a}) for a in range(5)}))


if __name__ == "__main__":
    unittest.main()

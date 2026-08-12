import math
import unittest

from defect_calculus import PrimePowerDefect, derived_incidence, local_defect


class DefectCalculusTests(unittest.TestCase):
    def test_same_prime_retains_degrees_but_euler_cancels(self):
        result = derived_incidence(PrimePowerDefect(3, 1),
                                   PrimePowerDefect(3, 7))
        self.assertEqual(result.homology_orders, ((0, 3), (1, 3)))
        self.assertEqual(result.alternating_order, 1)
        self.assertEqual(result.support_prime, 3)

    def test_different_prime_incidence_is_zero(self):
        result = derived_incidence(PrimePowerDefect(2, 5),
                                   PrimePowerDefect(7, 2))
        self.assertTrue(result.is_zero)
        self.assertEqual(result.alternating_order, 1)
        self.assertIsNone(result.support_prime)

    def test_tower_step_including_two_edge(self):
        step = PrimePowerDefect(2, 1).tower_step()
        step.validate()
        self.assertEqual(step.ramification_index, 2)
        self.assertEqual(step.conormal_map_rank, 0)
        self.assertAlmostEqual(step.height_increment, math.log(2))

    def test_local_lengths_compose_additively(self):
        first = local_defect(((2, 1), (3, 2)))
        second = local_defect(((2, 4), (5, 1)))
        composite = first.compose(second)
        self.assertEqual(composite.lengths, ((2, 5), (3, 2), (5, 1)))
        self.assertEqual(composite.cokernel_order,
                         first.cokernel_order * second.cokernel_order)
        self.assertAlmostEqual(composite.logarithmic_length,
                               first.logarithmic_length + second.logarithmic_length)

    def test_prime_and_exponent_are_typed(self):
        with self.assertRaises(ValueError):
            PrimePowerDefect(9, 1)
        with self.assertRaises(ValueError):
            PrimePowerDefect(3, 0)


if __name__ == "__main__":
    unittest.main()

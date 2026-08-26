import unittest

from machinery.euclidean_formation import form_greatest_common_measure


class EuclideanFormationTests(unittest.TestCase):
    def test_twelve_forms_as_greatest_common_measure(self):
        update = form_greatest_common_measure(48, 180)
        self.assertEqual(update.formed_invariant, 12)
        self.assertEqual(update.common_divisors_before, (1, 2, 3, 4, 6, 12))
        self.assertEqual(update.common_divisors_before, update.common_divisors_after)
        self.assertEqual(update.descent_trace[-1], (36, 12, 3, 0))
        self.assertIn("(4,15)", update.immediate_frontier)

    def test_unit_remainder_changes_frontier_to_coprimality(self):
        update = form_greatest_common_measure(35, 12)
        self.assertEqual(update.formed_invariant, 1)
        self.assertIn("no non-unit", update.obstruction)
        self.assertTrue(update.immediate_frontier.startswith("coprime:"))

    def test_each_step_is_euclidean_division(self):
        update = form_greatest_common_measure(1071, 462)
        self.assertEqual(update.formed_invariant, 21)
        for x, y, q, r in update.descent_trace:
            self.assertEqual(x, q * y + r)
            self.assertLess(r, y)

    def test_rejects_nonpositive_input(self):
        for pair in ((0, 3), (-2, 3), (True, 3)):
            with self.assertRaises(ValueError):
                form_greatest_common_measure(*pair)


if __name__ == "__main__":
    unittest.main()

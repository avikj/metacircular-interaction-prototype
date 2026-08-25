import unittest

from unitary_syntactic_monoid_boundary import (
    coherent_environment_dimension,
    faithful_closed_unitary_possible,
    generated_monoid,
    identity,
    idempotents,
    is_group,
)


class UnitarySyntacticMonoidBoundaryTests(unittest.TestCase):
    def test_reset_is_nontrivial_idempotent_and_no_go(self):
        reset = (0, 0, 0)
        monoid = generated_monoid([reset])
        self.assertEqual(monoid, frozenset({identity(3), reset}))
        self.assertEqual(idempotents(monoid), monoid)
        self.assertFalse(is_group(monoid))
        self.assertFalse(faithful_closed_unitary_possible(monoid))

    def test_cyclic_permutations_are_group_and_unitary_eligible(self):
        cycle = (1, 2, 0)
        monoid = generated_monoid([cycle])
        self.assertEqual(len(monoid), 3)
        self.assertEqual(idempotents(monoid), frozenset({identity(3)}))
        self.assertTrue(faithful_closed_unitary_possible(monoid))

    def test_saturating_increment_is_not_closed_unitary(self):
        saturating_increment = (1, 2, 2)
        monoid = generated_monoid([saturating_increment])
        self.assertEqual(len(monoid), 3)
        self.assertFalse(faithful_closed_unitary_possible(monoid))
        self.assertIn((2, 2, 2), idempotents(monoid))

    def test_dilation_cost_is_distinct_from_closed_eligibility(self):
        reset = (0, 0, 0)
        cycle = (1, 2, 0)
        self.assertEqual(coherent_environment_dimension(reset), 3)
        self.assertEqual(coherent_environment_dimension(cycle), 1)

    def test_partial_merger_can_lack_nonidentity_generator_idempotence(self):
        merger = (0, 0, 2, 2)
        monoid = generated_monoid([merger, (1, 2, 3, 0)])
        self.assertFalse(faithful_closed_unitary_possible(monoid))
        self.assertGreater(coherent_environment_dimension(merger), 1)


if __name__ == "__main__":
    unittest.main()

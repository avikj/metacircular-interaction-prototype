import unittest

from incremental_refinement_quantum_boundary import (
    forgetting_environment_dimension,
    mod_six_certificate,
    old_state_can_reconstruct_refinement,
    split_multiplicities,
)


class IncrementalRefinementQuantumBoundaryTests(unittest.TestCase):
    def test_mod_six_split_costs_qutrit(self):
        certificate = mod_six_certificate()
        self.assertEqual(certificate["old_classes"], 2)
        self.assertEqual(certificate["refined_classes"], 6)
        self.assertEqual(certificate["split_multiplicities"], {0: 3, 1: 3})
        self.assertEqual(certificate["forgetting_environment_dimension"], 3)
        self.assertFalse(certificate["old_state_can_reconstruct"])

    def test_shortest_witnesses_need_at_most_one_action(self):
        certificate = mod_six_certificate()
        self.assertEqual(certificate["maximum_shortest_new_witness_length"], 1)
        self.assertEqual(certificate["witness_2_vs_4"], (("+2",), "3|x"))
        self.assertEqual(certificate["witness_1_vs_5"], (("+2",), "3|x"))

    def test_uneven_split_uses_largest_multiplicity(self):
        old = ("a", "a", "a", "b", "b")
        new = (0, 1, 2, 3, 3)
        self.assertEqual(split_multiplicities(old, new), {"a": 3, "b": 1})
        self.assertEqual(forgetting_environment_dimension(old, new), 3)

    def test_no_split_is_reconstructible(self):
        old = (0, 0, 1, 1)
        new = ("even", "even", "odd", "odd")
        self.assertTrue(old_state_can_reconstruct_refinement(old, new))

    def test_nonrefinement_is_rejected(self):
        with self.assertRaises(ValueError):
            split_multiplicities((0, 1), ("same", "same"))


if __name__ == "__main__":
    unittest.main()

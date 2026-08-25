import unittest

from machinery.cyclic_local_system import (
    compile_cyclic_local_system, identity, smith_example,
)
from machinery.smith_holonomy_predictive_control import carrier
from machinery.smith_path_holonomy import act, witness


class CyclicLocalSystemTests(unittest.TestCase):
    def setUp(self):
        *_, h, _, _, _ = witness()
        self.states = carrier()
        self.permutation = {state: act(h, state) for state in self.states}

    def test_smith_c3_sees_isotropy_erased_by_orbit_set(self):
        result = smith_example()
        by_length = sorted((len(item.orbit), item.invariant_dimension)
                           for item in result.orbit_invariants)
        self.assertEqual(by_length, [(1, 0), (1, 0), (1, 0),
                                     (3, 2), (3, 2), (3, 2)])
        self.assertEqual(result.global_section_dimension, 6)

    def test_trivial_local_system_control(self):
        unit = identity(2)
        result = compile_cyclic_local_system(
            self.states, self.permutation,
            {state: unit for state in self.states}, 3, 2,
        )
        self.assertEqual(result.global_section_dimension, 12)

    def test_rejects_edge_labels_that_do_not_respect_c3(self):
        unit = identity(2)
        bad = {state: unit for state in self.states}
        moving = next(state for state in self.states
                      if self.permutation[state] != state)
        bad[moving] = ((0, 1), (1, 1))
        with self.assertRaisesRegex(ValueError, "cyclic group relation"):
            compile_cyclic_local_system(
                self.states, self.permutation, bad, 3, 2,
            )


if __name__ == "__main__":
    unittest.main()

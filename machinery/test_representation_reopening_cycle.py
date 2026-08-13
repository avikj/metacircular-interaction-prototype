import unittest

from machinery.representation_reopening_cycle import (
    cycle,
    decide_initial,
    expose_operator,
)


class RepresentationReopeningCycleTests(unittest.TestCase):
    def test_input_horizon_changes_installation_route(self):
        self.assertEqual(decide_initial(3).phase, "retained")
        self.assertEqual(decide_initial(4).phase, "installed")

    def test_translation_control_does_not_reopen(self):
        installed = decide_initial(4)
        control = expose_operator(installed, "translation", 4)
        self.assertEqual(control.phase, "executed")
        self.assertIn("leakage-rank=0", control.evidence)

    def test_position_reopens_installed_representation(self):
        installed = decide_initial(4)
        changed = expose_operator(installed, "position", 4)
        self.assertEqual(changed.phase, "reopened")
        self.assertIn("leakage-rank=8", changed.evidence)
        self.assertEqual(tuple((c.baseline_operations, c.correction_scalars)
                               for c in changed.costs), ((120, 0), (104, 32)))

    def test_full_cycle(self):
        phases = tuple(state.phase for state in cycle())
        self.assertEqual(phases, ("retained", "installed", "executed", "reopened"))

    def test_unknown_operator_fails_closed(self):
        with self.assertRaisesRegex(ValueError, "unknown"):
            expose_operator(decide_initial(4), "mystery", 4)


if __name__ == "__main__":
    unittest.main()

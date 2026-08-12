#!/usr/bin/env python3

import unittest

from coupled_encounter_engine import EncounterEngine


class CoupledEncounterEngineTests(unittest.TestCase):
    def test_smith_sensor_is_caused_by_a_real_collision(self):
        e = EncounterEngine.inherited()
        self.assertIsNone(e.meet_smith(((2, 0), (1, 7))))
        returned = e.meet_smith(((2, 1), (0, 7)))
        self.assertIsNotNone(returned)
        self.assertEqual(returned.visible_fiber, 1)
        self.assertIn("smith:typed-residual-origin", e.sensors)
        self.assertIn("smith:certified-next-step", e.actions)
        self.assertEqual(e.proposals["smith-scalar-controller"].status, "refuted")

    def test_encounter_order_does_not_script_smith_conclusion(self):
        e = EncounterEngine.inherited()
        self.assertIsNone(e.meet_smith(((2, 1), (0, 7))))
        self.assertIsNotNone(e.meet_smith(((2, 0), (1, 7))))

    def test_two_adic_collision_forms_exact_missing_bit(self):
        e = EncounterEngine.inherited()
        self.assertIsNone(e.meet_two_adic((5,), 8))
        returned = e.meet_two_adic((3, 5), 8)
        self.assertIsNotNone(returned)
        self.assertEqual(returned.visible_fiber, 2)
        self.assertIn("2adic:mod4-sign", e.sensors)
        self.assertIn("2adic:predict-index", e.actions)
        self.assertEqual(e.proposals["two-adic-level-index"].status, "refuted")

    def test_noncollisions_do_not_form_sensors(self):
        e = EncounterEngine.inherited()
        e.meet_two_adic((5,), 8)
        e.meet_two_adic((13,), 8)  # same signature and same index
        self.assertNotIn("2adic:mod4-sign", e.sensors)

    def test_task_quotient_exposes_a_real_pareto_tradeoff(self):
        e = EncounterEngine.inherited()
        coarse = e.couple_task("distinguish-fixed-point-2")
        rich = e.reopen("distinguish-0-from-1")
        self.assertLess(coarse.effective_states, rich.effective_states)
        self.assertTrue(coarse.effective_action_is_group)
        self.assertFalse(rich.effective_action_is_group)
        self.assertEqual(coarse.retained_states, rich.retained_states)

    def test_exact_returns_redirect_attention(self):
        e = EncounterEngine.inherited()
        self.assertEqual(e.attention()[0], "smith-scalar-controller")
        e.meet_smith(((2, 0), (1, 7)))
        e.meet_smith(((2, 1), (0, 7)))
        self.assertNotIn("smith-scalar-controller", e.attention())
        e.couple_task("distinguish-fixed-point-2")
        self.assertIn("reopen-forgotten-distinction", e.attention())


if __name__ == "__main__":
    unittest.main()

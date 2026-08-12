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

    def test_live_port_changes_executable_future_grammar(self):
        left, right = EncounterEngine.inherited(), EncounterEngine.inherited()
        left.couple_constructor_port(2, "participant-A")
        right.couple_constructor_port(0, "participant-B")
        self.assertEqual(len(left.active_grammar), 2)
        self.assertEqual(len(right.active_grammar), 3)
        self.assertEqual(left.constructor_future(), (0, 1))
        self.assertEqual(right.constructor_future(), (0, 1, 2))
        self.assertNotEqual(left.constructor_future(), right.constructor_future())

    def test_scores_order_but_cannot_overrule_live_relation(self):
        e = EncounterEngine.inherited()
        lawful = __import__("situated_constructor_port").transporter(3, 0, 1)
        wanted = next(g for g in lawful if g[2] == 0)
        other = next(g for g in lawful if g[2] == 2)
        cert = e.couple_constructor_port(
            0, "human", {wanted: -1000.0, other: 1000.0}
        )
        self.assertEqual(cert.selected, wanted)
        self.assertTrue(cert.verifies())

    def test_withdrawal_restores_torsor_and_retains_provenance(self):
        e = EncounterEngine.inherited()
        cert = e.couple_constructor_port(0, "living-environment")
        lawful = e.withdraw_constructor_port()
        self.assertEqual(len(lawful), 2)
        self.assertIsNone(e.active_constructor)
        self.assertIsNone(e.constructor_selection_policy)
        self.assertEqual(e.active_grammar, ())
        self.assertNotIn("constructor:iterate-selected", e.actions)
        self.assertIn("constructor:torsor-unresolved", e.actions)
        self.assertEqual(e.constructor_history, [cert])
        with self.assertRaises(ValueError):
            e.constructor_future()

    def test_api_call_order_is_not_a_hidden_selection_policy(self):
        left, right = EncounterEngine.inherited(), EncounterEngine.inherited()
        # Inspect the same lawful field in opposite orders.  Neither path may
        # install a primitive or invent an alternation schedule.
        left_choices = left.constructor_choices()
        left_attention = left.attention()
        right_attention = right.attention()
        right_choices = right.constructor_choices()
        self.assertEqual(left_choices, right_choices)
        self.assertEqual(left_attention, right_attention)
        self.assertIsNone(left.active_constructor)
        self.assertIsNone(right.active_constructor)
        self.assertEqual(left.active_grammar, right.active_grammar)
        self.assertIsNone(left.constructor_selection_policy)
        self.assertIsNone(right.constructor_selection_policy)
        # A declared relation, not call order, collapses the set.
        left.couple_constructor_port(0, "participant")
        self.assertEqual(left.constructor_selection_policy,
                         "exact-live-port-equation")
        self.assertIsNone(right.active_constructor)

    def test_predictive_reuse_lives_on_installed_configurations(self):
        e = EncounterEngine.inherited()
        e.couple_constructor_port(2, "participant")
        self.assertEqual(e.constructor_future(0), (0, 1))
        e.withdraw_constructor_port()
        e.couple_constructor_port(0, "participant")
        self.assertEqual(e.constructor_future(0), (0, 1, 2))

    def test_exact_arithmetic_forecast_has_no_port_authority(self):
        e = EncounterEngine.inherited()
        forecast = e.forecast_port_from_smith(((2, 1), (0, 7)))
        self.assertEqual(forecast.response, 0)
        self.assertTrue("verify=True" in forecast.evidence)
        # Forecasting mutates only the prediction ledger: no constructor,
        # grammar, action, sensor, or selection policy has been installed.
        self.assertIsNone(e.active_constructor)
        self.assertEqual(e.active_grammar, ())
        self.assertIsNone(e.constructor_selection_policy)
        # A live participant may supply the opposite response. Exact
        # certification follows that relation, not the arithmetic forecast.
        cert = e.couple_constructor_port(2, "participant-disagrees")
        self.assertEqual(cert.port.response, 2)
        self.assertEqual(e.constructor_future(), (0, 1))


if __name__ == "__main__":
    unittest.main()

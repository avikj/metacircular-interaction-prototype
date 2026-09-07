#!/usr/bin/env python3
"""Assertions for the independent cf-cinder audit of R0030.

Each test fires one bullet of the packet's `Falsification` section and shows it
does NOT hold: the forecast never installs, the opposed live port certifies,
the forecast never overrides the response, reuse lives on C x X (not the
nonclosed transporter), and there is no third predictive class.
"""

import unittest

from coupled_encounter_engine import EncounterEngine
from cf_cinder_audit_r0030 import (
    diff_installation,
    enumerate_equivalences_on_pair,
    forecast_policy,
    is_transporter_closed,
    replay_smith_certificate,
    reuse_signatures,
    snapshot,
    solve_port,
)

A = ((2, 1), (0, 7))


class CinderAuditR0030(unittest.TestCase):
    # --- Proof obligation 1 / independent replay -------------------------
    def test_smith_certificate_replays_independently(self):
        r = replay_smith_certificate(A)
        self.assertTrue(r["ok"], r["checks"])
        self.assertTrue(all(r["checks"].values()))
        self.assertEqual(r["first_kind"], "row-residual")
        self.assertEqual(r["diagonal"], ((1, 0), (0, 14)))

    def test_independent_forecast_policy_matches_engine(self):
        engine = EncounterEngine.inherited()
        fc = engine.forecast_port_from_smith(A)
        self.assertEqual(fc.response, 0)
        self.assertEqual(forecast_policy(A), 0)
        # control: a column-residual matrix forecasts 2, a divisibility one too
        self.assertEqual(forecast_policy(((2, 0), (1, 7))), 2)
        self.assertEqual(forecast_policy(((2, 0), (0, 3))), 2)

    # --- Falsification bullet: forecast must not install anything ---------
    def test_forecast_changes_only_the_prediction_ledger(self):
        engine = EncounterEngine.inherited()
        before = snapshot(engine)
        self.assertEqual(len(engine.response_forecasts), 0)
        engine.forecast_port_from_smith(A)
        after = snapshot(engine)
        self.assertEqual(diff_installation(before, after), [],
                         "forecast mutated installation-bearing state")
        self.assertEqual(len(engine.response_forecasts), 1)
        # explicit: no constructor, grammar, sensor delta, action delta, policy
        self.assertIsNone(engine.active_constructor)
        self.assertEqual(engine.active_grammar, ())
        self.assertIsNone(engine.constructor_selection_policy)
        self.assertNotIn("constructor:live-context-response", engine.sensors)
        self.assertNotIn("constructor:iterate-selected", engine.actions)

    def test_repeated_forecasts_only_grow_the_ledger(self):
        engine = EncounterEngine.inherited()
        before = snapshot(engine)
        for _ in range(5):
            engine.forecast_port_from_smith(A)
        after = snapshot(engine)
        self.assertEqual(diff_installation(before, after), [])
        self.assertEqual(len(engine.response_forecasts), 5)

    # --- Falsification bullet: opposed live port must fail certification --
    def test_opposed_live_port_r2_certifies_uniquely(self):
        port = solve_port(3, 0, 1, 2, 2)
        self.assertTrue(port["unique"])
        self.assertEqual(port["selected"], (1, 0, 2))
        self.assertEqual(port["order"], 2)
        self.assertEqual(port["future_trace"], (0, 1))
        # engine agrees
        engine = EncounterEngine.inherited()
        cert = engine.couple_constructor_port(2, "cf-cinder")
        self.assertTrue(cert.verifies())
        self.assertEqual(cert.selected, (1, 0, 2))
        self.assertEqual(len(engine.active_grammar), 2)
        self.assertEqual(engine.constructor_future(0), (0, 1))

    # --- Falsification bullet: forecast must not override the response ----
    def test_forecast_zero_does_not_override_live_response_two(self):
        engine = EncounterEngine.inherited()
        fc = engine.forecast_port_from_smith(A)          # predicts 0
        self.assertEqual(fc.response, 0)
        cert = engine.couple_constructor_port(2, "participant-disagrees")  # supplies 2
        self.assertEqual(cert.port.response, 2)
        # installed grammar follows the LIVE response 2 (order two), not the
        # forecast 0 (which would be order three, trace (0,1,2)).
        self.assertEqual(len(engine.active_grammar), 2)
        self.assertEqual(engine.constructor_future(0), (0, 1))
        self.assertNotEqual(engine.constructor_future(0), (0, 1, 2))
        # the disagreeing forecast survives in the ledger, unresolved
        self.assertEqual(engine.response_forecasts[0].response, 0)

    # --- Falsification bullet: reuse on the nonclosed transporter ---------
    def test_raw_transporter_is_not_closed_so_reuse_lives_on_CxX(self):
        c = is_transporter_closed()
        self.assertFalse(c["closed"])
        self.assertFalse(c["tau2_sends_0_to_1"])   # tau^2 = id, id(0)=0
        self.assertFalse(c["rho2_sends_0_to_1"])   # rho^2 = (0 2 1), sends 0->2
        # the engine's reuse acts on installed configurations (g,x)->(g,g(x)):
        # two responses give genuinely different futures, confirming C x X.
        left, right = EncounterEngine.inherited(), EncounterEngine.inherited()
        left.couple_constructor_port(2, "p")
        right.couple_constructor_port(0, "p")
        self.assertEqual(left.constructor_future(0), (0, 1))
        self.assertEqual(right.constructor_future(0), (0, 1, 2))

    # --- Falsification bullet: no third predictive class ------------------
    def test_double_reuse_separates_both_constructors_and_no_third_class(self):
        r = reuse_signatures()
        self.assertEqual(r["sig_tau"], (0, 1, 0))
        self.assertEqual(r["sig_rho"], (0, 1, 2))
        self.assertTrue(r["endpoint_indiscrete"])   # o,a agree -> indiscrete
        self.assertTrue(r["a2_discrete"])           # a^2 separates -> discrete
        # a two-element carrier has exactly two equivalence relations; there is
        # no intermediate/third predictive partition of the two constructors.
        self.assertEqual(r["num_possible_quotients"], 2)
        self.assertEqual(enumerate_equivalences_on_pair(), 2)
        # and there are exactly two constructors to begin with
        self.assertEqual(len(solve_port(3, 0, 1, 2, 2)["lawful"]), 2)


if __name__ == "__main__":
    unittest.main()

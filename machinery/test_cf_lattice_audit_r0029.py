#!/usr/bin/env python3
"""Hostile tests for the R0029 audit (breaker: cf-lattice).

Each test attacks one line of the packet's Falsification section and fails only
if the engine can be made to violate the exact statement.  The permutation
facts are recomputed by cf_lattice_audit_r0029's independent algebra, not read
from the builder's helpers.
"""

import itertools
import os
import random
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import cf_lattice_audit_r0029 as audit
from coupled_encounter_engine import EncounterEngine


class IndependentAlgebraTests(unittest.TestCase):
    """First establish that my own algebra agrees with the packet's claims,
    so the engine comparison below is against a trustworthy oracle."""

    def test_candidate_set_is_the_two_element_torsor(self):
        T = audit.candidate_set(3, 0, 1)
        self.assertEqual(T, {(1, 0, 2), (1, 2, 0)})

    def test_port_equations_are_uniquely_solvable(self):
        # g(2)=2 -> (1,0,2) order 2; g(2)=0 -> (1,2,0) order 3.
        g2 = audit.unique_selection(3, 0, 1, 2, 2)
        g0 = audit.unique_selection(3, 0, 1, 2, 0)
        self.assertEqual(g2, (1, 0, 2))
        self.assertEqual(g0, (1, 2, 0))
        self.assertEqual(audit.cyclic_order(g2), 2)
        self.assertEqual(audit.cyclic_order(g0), 3)
        self.assertEqual(audit.orbit_trace(g2, 0), (0, 1))
        self.assertEqual(audit.orbit_trace(g0, 0), (0, 1, 2))

    def test_response_one_is_inconsistent(self):
        # No g in T solves g(2)=1; a live port asking for it must be rejected.
        self.assertIsNone(audit.unique_selection(3, 0, 1, 2, 1))


class EngineMatchesIndependentMath(unittest.TestCase):
    def test_full_audit_confirms(self):
        report = audit.run_audit()
        self.assertEqual(report["verdict"], "CONFIRMED", report["findings"])
        self.assertEqual(report["findings"], [])


class FalsificationAttacks(unittest.TestCase):
    # Falsifier 1: "Exhibit equal active transformation monoids after the two
    # port responses."
    def test_two_responses_install_unequal_monoids(self):
        a = EncounterEngine.inherited()
        b = EncounterEngine.inherited()
        a.couple_constructor_port(2, "A")
        b.couple_constructor_port(0, "B")
        # Different orders => the grammars are unequal as sets of permutations.
        self.assertEqual(len(a.active_grammar), 2)
        self.assertEqual(len(b.active_grammar), 3)
        self.assertNotEqual(set(a.active_grammar), set(b.active_grammar))
        # And the observable future differs, matching independent orbit walks.
        self.assertEqual(a.constructor_future(0), audit.orbit_trace((1, 0, 2), 0))
        self.assertEqual(b.constructor_future(0), audit.orbit_trace((1, 2, 0), 0))
        self.assertNotEqual(a.constructor_future(0), b.constructor_future(0))

    # Falsifier 2: "Make a proposal score install a constructor inconsistent
    # with the port."  Sweep adversarial scores including extreme margins.
    def test_scores_never_override_port_equation(self):
        rng = random.Random(20260812)
        T = sorted(audit.candidate_set(3, 0, 1))
        for response in (0, 2):
            expected = audit.unique_selection(3, 0, 1, 2, response)
            # The wrong candidate is the other torsor element.
            wrong = next(g for g in T if g != expected)
            for _ in range(200):
                scores = {
                    expected: rng.uniform(-1e9, -1.0),   # punish the correct one
                    wrong: rng.uniform(1.0, 1e9),         # reward the wrong one
                }
                e = EncounterEngine.inherited()
                cert = e.couple_constructor_port(response, "adversary", scores)
                self.assertEqual(cert.selected, expected)
                self.assertTrue(cert.verifies())
                self.assertEqual(e.active_constructor, expected)

    # Falsifier 2b: an inconsistent port equation cannot install anything at
    # all -- it must raise, never silently pick a candidate.
    def test_inconsistent_port_is_rejected_not_defaulted(self):
        e = EncounterEngine.inherited()
        with self.assertRaises(ValueError):
            e.couple_constructor_port(1, "impossible")
        self.assertIsNone(e.active_constructor)
        self.assertIsNone(e.constructor_selection_policy)
        self.assertEqual(e.active_grammar, ())

    # Falsifier 3: "Make inspection order alone choose a candidate or an
    # alternation schedule."  Try every ordering of read-only inspections.
    def test_no_inspection_order_installs_anything(self):
        def choices(e):
            return e.constructor_choices()

        def attention(e):
            return e.attention()

        def future_guarded(e):
            # constructor_future must refuse while the torsor is unresolved.
            try:
                e.constructor_future(0)
                return "LEAKED"
            except ValueError:
                return "guarded"

        inspections = [choices, attention, future_guarded]
        baseline_choices = set(EncounterEngine.inherited().constructor_choices())
        for perm in itertools.permutations(inspections):
            e = EncounterEngine.inherited()
            observed = [op(e) for op in perm]
            self.assertIn("guarded", observed)  # future never leaked
            self.assertEqual(set(e.constructor_choices()), baseline_choices)
            self.assertIsNone(e.active_constructor)
            self.assertIsNone(e.constructor_selection_policy)
            self.assertEqual(e.active_grammar, ())

    # Falsifier 3b: two engines inspected in opposite orders reach identical
    # unselected state (the AIME anti-alternation obligation).
    def test_opposite_orders_leave_identical_state(self):
        left = EncounterEngine.inherited()
        right = EncounterEngine.inherited()
        lc = left.constructor_choices()
        la = left.attention()
        ra = right.attention()
        rc = right.constructor_choices()
        self.assertEqual(set(lc), set(rc))
        self.assertEqual(la, ra)
        self.assertEqual(left.active_grammar, right.active_grammar)
        self.assertIsNone(left.constructor_selection_policy)
        self.assertIsNone(right.constructor_selection_policy)

    # Falsifier 4: "Withdraw the port while leaving its iterate action
    # executable."
    def test_withdrawal_removes_all_present_authority(self):
        for response in (0, 2):
            e = EncounterEngine.inherited()
            e.couple_constructor_port(response, "living-env")
            self.assertIn("constructor:iterate-selected", e.actions)
            restored = e.withdraw_constructor_port()
            self.assertEqual(set(restored), audit.candidate_set(3, 0, 1))
            self.assertEqual(len(restored), 2)
            self.assertIsNone(e.active_constructor)
            self.assertIsNone(e.constructor_selection_policy)
            self.assertEqual(e.active_grammar, ())
            self.assertNotIn("constructor:iterate-selected", e.actions)
            self.assertIn("constructor:torsor-unresolved", e.actions)
            # The iterate action is no longer executable.
            with self.assertRaises(ValueError):
                e.constructor_future(0)

    # Falsifier 5: "Erase historical provenance as a side effect of
    # withdrawal."
    def test_withdrawal_retains_certificate_and_provenance(self):
        e = EncounterEngine.inherited()
        cert = e.couple_constructor_port(0, "participant-X")
        e.withdraw_constructor_port()
        self.assertEqual(e.constructor_history, [cert])
        self.assertEqual(e.constructor_history[-1].port.provenance, "participant-X")
        self.assertTrue(e.constructor_history[-1].verifies())
        # Re-supplying a different response installs the OTHER grammar, and
        # history accumulates rather than being overwritten.
        cert2 = e.couple_constructor_port(2, "participant-Y")
        self.assertEqual(e.constructor_history, [cert, cert2])
        self.assertEqual(len(e.active_grammar), 2)


if __name__ == "__main__":
    unittest.main()

"""Independent breaker audit of R0029 (situated port engine integration).

Auditor: cf-tessera (Claude Fable 5 lineage).  Hostile tests written against
the packet's exact statement and falsification list, independent of the
builder's own test files.  Attack surfaces, per the registered forecast in
msg 0430: full read-only permutation invariance (stronger than the packet's
"either order"), adversarial score override attempts, port pathology with a
partial-installation check, withdrawal semantics, monoid inequality, and the
re-supply-without-withdrawal joint.
"""

import unittest
from itertools import permutations as iterperms

from coupled_encounter_engine import EncounterEngine
from situated_constructor_port import Port, powers, select_with_port, transporter


def installation_snapshot(engine):
    """Every installation-bearing field named by the packet, frozen."""
    return (
        engine.active_constructor,
        engine.active_grammar,
        engine.constructor_selection_policy,
        tuple(engine.constructor_history),
        frozenset(engine.sensors),
        frozenset(engine.actions),
        tuple(sorted(engine.proposals)),
        tuple(
            (name, p.status) for name, p in sorted(engine.proposals.items())
        ),
    )


READ_ONLY_CALLS = {
    "attention": lambda e: e.attention(),
    "choices": lambda e: e.constructor_choices(),
    "attention2": lambda e: e.attention(),
    "choices2": lambda e: e.constructor_choices(),
}


class ReadOnlyInvarianceTest(unittest.TestCase):
    def test_all_permutations_leave_unselected_state_identical(self):
        """Stronger than the packet's 'either order': all 24 orderings of
        repeated read-only calls leave byte-identical unselected state, and
        every ordering sees the same undecided two-candidate torsor."""
        baseline = None
        for order in iterperms(sorted(READ_ONLY_CALLS)):
            engine = EncounterEngine.inherited()
            before = installation_snapshot(engine)
            results = tuple(READ_ONLY_CALLS[name](engine) for name in order)
            self.assertEqual(installation_snapshot(engine), before)
            key = tuple(sorted(zip(order, map(repr, results))))
            if baseline is None:
                baseline = key
            self.assertEqual(key, baseline)

    def test_undecided_set_is_the_full_transporter(self):
        engine = EncounterEngine.inherited()
        self.assertEqual(set(engine.constructor_choices()),
                         {(1, 0, 2), (1, 2, 0)})
        self.assertEqual(engine.active_grammar, ())
        self.assertIsNone(engine.constructor_selection_policy)


class AdversarialScoreTest(unittest.TestCase):
    def test_huge_scores_on_wrong_candidate_do_not_override(self):
        for response, expected in ((2, (1, 0, 2)), (0, (1, 2, 0))):
            wrong = (1, 2, 0) if expected == (1, 0, 2) else (1, 0, 2)
            scores = {wrong: 1e18, expected: -1e18, (0, 1, 2): 1e30}
            cert = select_with_port(
                3, 0, 1, Port(2, response, "hostile"), scores
            )
            self.assertEqual(cert.selected, expected)
            self.assertTrue(cert.verifies())

    def test_scores_cannot_install_through_engine(self):
        engine = EncounterEngine.inherited()
        cert = engine.couple_constructor_port(
            2, "hostile", scores={(1, 2, 0): 1e18}
        )
        self.assertEqual(cert.selected, (1, 0, 2))
        self.assertEqual(len(engine.active_grammar), 2)


class PortPathologyTest(unittest.TestCase):
    def test_impossible_response_fails_certification(self):
        # g(0)=1 and g(2)=1 contradict injectivity: empty match.
        with self.assertRaises(ValueError):
            select_with_port(3, 0, 1, Port(2, 1, "hostile"))

    def test_nonunique_context_fails_certification(self):
        # context 0 with response 1 matches both candidates.
        with self.assertRaises(ValueError):
            select_with_port(3, 0, 1, Port(0, 1, "hostile"))

    def test_failed_certification_leaves_no_partial_installation(self):
        engine = EncounterEngine.inherited()
        before = installation_snapshot(engine)
        with self.assertRaises(ValueError):
            engine.couple_constructor_port(1, "hostile")
        self.assertEqual(installation_snapshot(engine), before)


class InstalledGrammarTest(unittest.TestCase):
    def test_monoids_unequal_orders_and_traces(self):
        engine2 = EncounterEngine.inherited()
        engine3 = EncounterEngine.inherited()
        engine2.couple_constructor_port(2, "live")
        engine3.couple_constructor_port(0, "live")
        m2, m3 = set(engine2.active_grammar), set(engine3.active_grammar)
        self.assertEqual((len(m2), len(m3)), (2, 3))
        self.assertNotEqual(m2, m3)
        self.assertEqual(engine2.constructor_future(0), (0, 1))
        self.assertEqual(engine3.constructor_future(0), (0, 1, 2))

    def test_installed_grammar_is_closed_monoid(self):
        """Reuse acts on the installed cyclic monoid, which is closed under
        composition, unlike the transporter (regression for the packet's
        'never acts on the nonclosed transporter')."""
        from situated_constructor_port import compose
        t = transporter(3, 0, 1)
        self.assertNotEqual(
            {compose(a, b) for a in t for b in t} & set(t),
            {compose(a, b) for a in t for b in t},
        )
        for response in (0, 2):
            g = select_with_port(3, 0, 1, Port(2, response, "live")).selected
            monoid = set(powers(g))
            self.assertEqual(
                {compose(a, b) for a in monoid for b in monoid}, monoid
            )


class WithdrawalTest(unittest.TestCase):
    def test_withdrawal_restores_torsor_and_retains_history(self):
        engine = EncounterEngine.inherited()
        cert = engine.couple_constructor_port(2, "live")
        restored = engine.withdraw_constructor_port()
        self.assertEqual(set(restored), {(1, 0, 2), (1, 2, 0)})
        self.assertIsNone(engine.active_constructor)
        self.assertEqual(engine.active_grammar, ())
        self.assertIsNone(engine.constructor_selection_policy)
        self.assertNotIn("constructor:iterate-selected", engine.actions)
        self.assertNotIn("constructor:live-context-response", engine.sensors)
        self.assertIn("constructor:torsor-unresolved", engine.actions)
        self.assertEqual(engine.constructor_history, [cert])
        with self.assertRaises(ValueError):
            engine.constructor_future(0)

    def test_double_withdrawal_raises(self):
        engine = EncounterEngine.inherited()
        engine.couple_constructor_port(2, "live")
        engine.withdraw_constructor_port()
        with self.assertRaises(ValueError):
            engine.withdraw_constructor_port()


class ResupplyJointTest(unittest.TestCase):
    def test_resupply_without_withdrawal_overwrites_silently(self):
        """Registered suspect joint (i), msg 0430: a second port supplied
        while a constructor is installed replaces the active grammar without
        passing through withdrawal.  Both certificates are retained in
        history, so no provenance is erased and no packet clause is
        falsified; but 'withdrawal reverses present installation' has this
        undeclared bypass.  Recorded as a scope fact, not a defect."""
        engine = EncounterEngine.inherited()
        engine.couple_constructor_port(2, "first")
        self.assertEqual(len(engine.active_grammar), 2)
        engine.couple_constructor_port(0, "second")
        self.assertEqual(len(engine.active_grammar), 3)
        self.assertEqual(len(engine.constructor_history), 2)
        # present authority reflects only the latest port
        self.assertEqual(engine.constructor_future(0), (0, 1, 2))


if __name__ == "__main__":
    unittest.main()

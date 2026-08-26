import unittest
from fractions import Fraction

from active_observer_design import (
    FormationPressure,
    Probe,
    audit_revision,
    audit_revision_composition,
    choose_next_probe,
    condition_or_pressure,
    posterior,
    resource_distinguishability,
    shortest_context_probes,
)
from compositional_crystal import Operation, crystallize_algebra


class ActiveObserverDesignTests(unittest.TestCase):
    def setUp(self):
        self.states = ("a", "b", "c", "d")
        self.probes = (
            Probe("balanced", 2, dict(zip(self.states, (0, 0, 1, 1)))),
            Probe("singleton", 1, dict(zip(self.states, (1, 0, 0, 0)))),
            Probe("expensive", 9, dict(zip(self.states, (0, 1, 2, 3)))),
        )
        self.prior = {state: 1 for state in self.states}

    def test_exact_active_choice_accounts_for_cost(self):
        choice = choose_next_probe(self.states, self.probes, self.prior)
        self.assertEqual(choice.probe, "singleton")
        self.assertEqual(choice.disagreement_gain, Fraction(3, 8))
        self.assertEqual(choice.gain_per_cost, Fraction(3, 8))

    def test_budget_and_evidence_change_choice(self):
        choice = choose_next_probe(
            self.states, self.probes, self.prior,
            evidence=(("singleton", 0),), budget=2,
        )
        self.assertEqual(choice.probe, "balanced")
        self.assertEqual(dict(posterior(
            self.states, self.probes, self.prior, (("singleton", 0),)
        )), {"b": Fraction(1, 3), "c": Fraction(1, 3), "d": Fraction(1, 3)})

    def test_low_level_posterior_still_fails_closed(self):
        with self.assertRaises(ValueError):
            posterior(self.states, self.probes, self.prior, (("singleton", 7),))

    def test_impossible_observation_is_preserved_as_pressure(self):
        result = condition_or_pressure(
            self.states, self.probes, self.prior,
            (("singleton", 0), ("balanced", 9)),
        )
        self.assertIsInstance(result, FormationPressure)
        self.assertEqual(result.evidence_prefix, (("singleton", 0),))
        self.assertEqual(result.witness, ("balanced", 9))
        self.assertEqual(result.live_support, ("b", "c", "d"))
        self.assertIsInstance(choose_next_probe(
            self.states, self.probes, self.prior, (("singleton", 7),)
        ), FormationPressure)

    def test_unknown_probe_is_not_misclassified_as_pressure(self):
        with self.assertRaisesRegex(ValueError, "unknown probe"):
            condition_or_pressure(self.states, self.probes, self.prior,
                                  (("undeclared", 0),))

    def test_revision_audit_checks_observation_squares(self):
        old_states = ("a", "b")
        old_probes = (Probe("color", 1, {"a": 0, "b": 1}),)
        new_states = ("a0", "a1", "b0")
        new_probes = (
            Probe("old-color", 1, {"a0": 0, "a1": 0, "b0": 1}),
            Probe("texture", 1, {"a0": 0, "a1": 1, "b0": 0}),
        )
        args = (old_states, old_probes, new_states, new_probes,
                {"a0": "a", "a1": "a", "b0": "b"})
        audit = audit_revision(*args, {"color": "old-color"})
        self.assertEqual(audit.forgotten_states, ())
        self.assertEqual(audit.preserved_probes, ("color",))
        self.assertEqual(audit.violated_probes, ())
        self.assertEqual(audit.new_probes, ("texture",))
        broken = audit_revision(*args, {"color": "texture"})
        self.assertEqual(broken.violated_probes,
                         (("color", ("a1", "b0")),))

    def test_revision_preservation_composes(self):
        audit = audit_revision_composition(
            ("a",), (Probe("q", 1, {"a": 0}),),
            ("b",), (Probe("q1", 1, {"b": 0}),),
            ("c",), (Probe("q2", 1, {"c": 0}),),
            {"b": "a"}, {"q": "q1"}, {"c": "b"}, {"q1": "q2"},
        )
        self.assertEqual(audit.composite_defects, (("q", ()),))

    def test_two_stage_defects_can_cancel(self):
        args = (
            ("a",), (Probe("q", 1, {"a": 0}),),
            ("b",), (Probe("q1", 1, {"b": 1}),),
            ("c",),
        )
        cancel = audit_revision_composition(
            *args, (Probe("q2", 1, {"c": 0}),),
            {"b": "a"}, {"q": "q1"}, {"c": "b"}, {"q1": "q2"},
        )
        persist = audit_revision_composition(
            *args, (Probe("q2", 1, {"c": 2}),),
            {"b": "a"}, {"q": "q1"}, {"c": "b"}, {"q1": "q2"},
        )
        self.assertEqual(cancel.first_defects, persist.first_defects)
        self.assertEqual(cancel.second_defects, persist.second_defects)
        self.assertNotEqual(cancel.composite_defects, persist.composite_defects)

    def test_resource_distinguishability_emits_blind_pairs(self):
        table = resource_distinguishability(
            (0, 1, 2), (Probe("parity", 1, {0: 0, 1: 1, 2: 0}),)
        )
        self.assertIn((0, 2, None, ()), table)
        self.assertIn((0, 1, 1, ("parity",)), table)

    def test_crystal_shortest_contexts_become_probes(self):
        elements = (0, 1, 2, 3)
        step = Operation("step", 1, {(x,): min(x + 1, 3) for x in elements})
        observation = {0: 0, 1: 0, 2: 0, 3: 1}
        crystal = crystallize_algebra(elements, (step,), observation)
        probes = shortest_context_probes(elements, (step,), observation, crystal)
        distance = {(left, right): cost for left, right, cost, _ in
                    resource_distinguishability(elements, probes)}
        self.assertEqual(distance[(0, 1)], 3)
        self.assertEqual(distance[(1, 2)], 2)
        self.assertEqual(distance[(2, 3)], 1)


if __name__ == "__main__":
    unittest.main()

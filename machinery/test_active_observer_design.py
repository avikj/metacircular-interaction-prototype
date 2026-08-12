import unittest
from fractions import Fraction

from active_observer_design import (
    Probe,
    choose_next_probe,
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

    def test_zero_mass_evidence_fails_closed(self):
        with self.assertRaises(ValueError):
            posterior(self.states, self.probes, self.prior, (("singleton", 7),))

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

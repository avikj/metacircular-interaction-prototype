#!/usr/bin/env python3

import unittest

from situated_constructor_port import (
    Port,
    compose,
    powers,
    proposal_order,
    select_with_port,
    target_stabilizer,
    three_point_world,
    transporter,
)


class SituatedConstructorPortTests(unittest.TestCase):
    def test_three_points_are_minimal_nontrivial_transporter(self):
        self.assertEqual(len(transporter(2, 0, 1)), 1)
        self.assertEqual(len(transporter(3, 0, 1)), 2)

    def test_target_stabilizer_acts_freely_and_transitively(self):
        lawful = transporter(3, 0, 1)
        stabilizer = target_stabilizer(3, 1)
        base = lawful[0]
        orbit = {compose(h, base) for h in stabilizer}
        self.assertEqual(orbit, set(lawful))
        self.assertEqual(len(orbit), len(stabilizer))

    def test_port_evaluation_is_bijection_and_certifies(self):
        world = three_point_world()
        certs = world["certificates"]
        self.assertEqual(set(certs), {0, 2})
        self.assertTrue(all(cert.verifies() for cert in certs.values()))
        self.assertEqual({cert.selected[2] for cert in certs.values()}, {0, 2})

    def test_selection_is_equivariant_under_target_stabilizer(self):
        # The nonidentity stabilizer swaps 0 and 2 while fixing target 1.
        h = (2, 1, 0)
        first = select_with_port(3, 0, 1, Port(2, 0, "environment"))
        transported = select_with_port(3, 0, 1, Port(2, h[0], "transported"))
        self.assertEqual(transported.selected, compose(h, first.selected))

    def test_installation_changes_future_action_grammar(self):
        world = three_point_world()
        self.assertEqual(world["grammar_orders"], {0: 3, 2: 2})
        self.assertEqual(world["future_traces"][0], (0, 1, 2))
        self.assertEqual(world["future_traces"][2], (0, 1))

    def test_scores_cannot_override_exact_port(self):
        lawful = transporter(3, 0, 1)
        desired = next(g for g in lawful if g[2] == 0)
        rejected = next(g for g in lawful if g[2] == 2)
        scores = {desired: -1000.0, rejected: 1000.0}
        self.assertEqual(proposal_order(lawful, scores)[0], rejected)
        cert = select_with_port(3, 0, 1, Port(2, 0, "human"), scores)
        self.assertEqual(cert.selected, desired)

    def test_withdrawal_restores_torsor_not_a_default(self):
        lawful = transporter(3, 0, 1)
        self.assertEqual(len(lawful), 2)
        with self.assertRaises(ValueError):
            select_with_port(3, 0, 1, Port(2, 1, "invalid"))
        self.assertEqual({len(powers(g)) for g in lawful}, {2, 3})


if __name__ == "__main__":
    unittest.main()

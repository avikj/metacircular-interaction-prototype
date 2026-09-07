#!/usr/bin/env python3

import unittest

from probe_cost_descent import (
    binary_method_cost,
    canonical_nonnegative_lift,
    form_lift_cost_witness,
    probe_signature,
)


class ProbeCostDescentTests(unittest.TestCase):
    def test_congruent_lifts_have_identical_probes_and_divergent_costs(self):
        for prime, depth, residue in ((2, 4, 3), (3, 3, 1), (5, 2, 7)):
            witness = form_lift_cost_witness(prime, depth, residue, 100)
            self.assertEqual(
                probe_signature(witness.low_lift, prime, depth),
                probe_signature(witness.high_lift, prime, depth),
            )
            self.assertLess(witness.successor_costs[0], witness.successor_costs[1])
            self.assertLess(witness.binary_costs[0], witness.binary_costs[1])

    def test_cost_gap_is_unbounded(self):
        costs = [
            form_lift_cost_witness(3, 3, 1, 10**power).binary_costs[1]
            for power in range(1, 6)
        ]
        self.assertEqual(costs, sorted(costs))
        self.assertEqual(len(set(costs)), len(costs))

    def test_canonical_lift_minimizes_successor_cost(self):
        for residue in range(25):
            canonical = canonical_nonnegative_lift(residue, 5, 2)
            self.assertEqual(canonical, residue)
            self.assertTrue(all(canonical <= residue + 25 * t for t in range(6)))

    def test_typed_boundaries_fail_closed(self):
        with self.assertRaises(ValueError):
            form_lift_cost_witness(3, 2, 1, 0)
        with self.assertRaises(ValueError):
            binary_method_cost(0)
        with self.assertRaises(ValueError):
            canonical_nonnegative_lift(1, 9, 2)


if __name__ == "__main__":
    unittest.main()

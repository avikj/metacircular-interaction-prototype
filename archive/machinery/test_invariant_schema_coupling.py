#!/usr/bin/env python3

import unittest

from invariant_schema_coupling import (
    RANK_ONE_SMITH,
    RANK_ONE_SOURCE,
    determinant,
    generated_group,
    invariant_envelope,
    matmul,
    orbit_partition,
    smith_descent_witness,
)


class InvariantSchemaCouplingTests(unittest.TestCase):
    def test_smallest_transitive_ambiguity(self):
        cycle = (1, 2, 0)
        transposition = (1, 0, 2)
        c3 = generated_group((cycle,))
        s3 = generated_group((cycle, transposition))
        self.assertEqual(orbit_partition(c3), ((0, 1, 2),))
        self.assertEqual(orbit_partition(s3), ((0, 1, 2),))
        self.assertEqual(len(c3), 3)
        self.assertEqual(len(s3), 6)

    def test_invariant_return_is_idempotent_envelope(self):
        cycle = (1, 2, 0)
        c3 = generated_group((cycle,))
        closure = invariant_envelope(orbit_partition(c3))
        self.assertEqual(len(closure), 6)
        self.assertEqual(invariant_envelope(orbit_partition(closure)), closure)

    def test_two_points_do_not_show_group_ambiguity(self):
        swap = (1, 0)
        transitive = generated_group((swap,))
        self.assertEqual(transitive, invariant_envelope(orbit_partition(transitive)))

    def test_infinite_smith_stabilizer_has_identical_endpoint(self):
        witnesses = [smith_descent_witness(k) for k in range(-4, 5)]
        self.assertEqual(len(set(witnesses)), 9)
        for u in witnesses:
            self.assertEqual(determinant(u), -1)
            self.assertEqual(matmul(u, RANK_ONE_SOURCE), RANK_ONE_SMITH)

    def test_nonunimodular_false_control_is_rejected(self):
        fake = ((0, 2), (1, -2))
        self.assertNotIn(determinant(fake), (-1, 1))
        self.assertNotEqual(matmul(fake, RANK_ONE_SOURCE), RANK_ONE_SMITH)


if __name__ == "__main__":
    unittest.main()

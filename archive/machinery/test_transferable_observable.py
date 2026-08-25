#!/usr/bin/env python3

import unittest

from transferable_observable import (
    is_equivariant, orbit_closure, restriction_collision,
)


class TransferableObservableTests(unittest.TestCase):
    def test_lookup_collision_witnesses_nontransfer(self):
        xs = (0, 1, 2)
        candidates = ({0: 0, 1: 1, 2: 0}, {0: 0, 1: 1, 2: 1})
        self.assertEqual(restriction_collision(xs, (0, 1), candidates), (0, 1, 2))

    def test_orbit_generation_forces_equivariant_extension(self):
        xs = (0, 1, 2, 3)
        step = {x: (x + 1) % 4 for x in xs}
        flip = {0: 1, 1: 0}
        parity = {x: x % 2 for x in xs}
        self.assertEqual(orbit_closure(xs, (0,), (step,)), xs)
        self.assertTrue(is_equivariant(xs, parity, (step,), (flip,)))
        candidates = tuple(q for q in (
            parity, {x: 1 - x % 2 for x in xs}
        ) if is_equivariant(xs, q, (step,), (flip,)))
        self.assertIsNone(restriction_collision(xs, (0,), candidates))

    def test_unseen_orbit_retains_lookup_freedom(self):
        xs = (0, 1, 2, 3)
        swap_pairs = {0: 1, 1: 0, 2: 3, 3: 2}
        fixed = {0: 0, 1: 1}
        q0 = {0: 0, 1: 0, 2: 0, 3: 0}
        q1 = {0: 0, 1: 0, 2: 1, 3: 1}
        self.assertEqual(orbit_closure(xs, (0,), (swap_pairs,)), (0, 1))
        self.assertTrue(is_equivariant(xs, q0, (swap_pairs,), (fixed,)))
        self.assertTrue(is_equivariant(xs, q1, (swap_pairs,), (fixed,)))
        self.assertEqual(restriction_collision(xs, (0,), (q0, q1)), (0, 1, 2))

    def test_structure_is_relative_not_posthoc(self):
        xs = (0, 1)
        identity = {0: 0, 1: 1}
        constant = {0: 0, 1: 0}
        self.assertEqual(restriction_collision(xs, (0,), (identity, constant)),
                         (0, 1, 1))


if __name__ == "__main__":
    unittest.main()

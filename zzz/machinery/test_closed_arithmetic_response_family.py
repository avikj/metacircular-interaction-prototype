#!/usr/bin/env python3

import unittest

from closed_arithmetic_response_family import (
    InstallationLedger,
    autonomous_fibers,
    compose_scalars,
    full_fibers,
    one_use_fibers,
)


class ClosedArithmeticResponseFamilyTests(unittest.TestCase):
    def test_scalar_family_is_closed_under_reuse(self):
        self.assertTrue(
            all(compose_scalars(a, b, 5) in range(5) for a in range(5) for b in range(5))
        )

    def test_autonomous_schedule_has_strict_three_four_five_chain(self):
        self.assertEqual(one_use_fibers(5), ((0,), (1,), (2, 3, 4)))
        self.assertEqual(autonomous_fibers(5, 4), ((0,), (1,), (2, 3), (4,)))

    def test_arbitrary_scalar_continuations_force_equality(self):
        self.assertEqual(full_fibers(5), ((0,), (1,), (2,), (3,), (4,)))

    def test_hostile_return_splits_autonomous_pair(self):
        # 2 and 3 share an autonomous response law, but left continuation 2
        # yields 4 ('other') and 1 ('one').
        self.assertNotEqual((2 * 2) % 5, (2 * 3) % 5)
        self.assertEqual(((2 * 2) % 5, (2 * 3) % 5), (4, 1))

    def test_cardinality_four_cannot_have_strict_three_middle_four_chain(self):
        # If P<Q<equality and |P|>=3, class counts require 3<|Q|<n.
        self.assertFalse(any(3 < middle < n for n in range(1, 5) for middle in range(1, n)))

    def test_prediction_does_not_install(self):
        ledger = InstallationLedger(5)
        ledger.predict(2)
        self.assertIsNone(ledger.installed)
        ledger.authorize(3, "live-participant-port")
        self.assertEqual(ledger.installed, 3)
        self.assertEqual(ledger.predictions, [2])

    def test_binary_observation_false_control_has_only_two_initial_classes(self):
        # Replacing zero/one/other by zero/nonzero cannot meet the >=3 premise.
        classes = {"zero" if a == 0 else "nonzero" for a in range(5)}
        self.assertEqual(len(classes), 2)


if __name__ == "__main__":
    unittest.main()

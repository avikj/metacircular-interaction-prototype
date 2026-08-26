#!/usr/bin/env python3
import unittest

from congruence_defect_localization import localize, verify_against_kuttaka
from exponent_world import ExponentWorld
from kuttaka_update import CongruenceState


class CongruenceDefectLocalizationTests(unittest.TestCase):
    def test_localizes_missing_three_exponent(self):
        state = CongruenceState(17, 72)
        report = localize(state, 23, 90)
        self.assertEqual(report.common_prime_powers, ((2, 1), (3, 2)))
        self.assertEqual(report.difference_powers, ((2, 1), (3, 1)))
        self.assertEqual(
            tuple((d.prime, d.required_exponent, d.available_exponent,
                   d.missing_exponent) for d in report.defects),
            ((3, 2, 1, 1),),
        )
        self.assertTrue(verify_against_kuttaka(state, 23, 90, report))

    def test_compatible_difference_has_no_defect(self):
        state = CongruenceState(17, 72)
        report = localize(state, 35, 90)
        self.assertTrue(report.compatible)
        self.assertTrue(verify_against_kuttaka(state, 35, 90, report))

    def test_equal_residues_are_compatible(self):
        state = CongruenceState(5, 12)
        report = localize(state, 5, 18)
        self.assertTrue(report.compatible)
        self.assertEqual(report.difference_powers, ())

    def test_multiple_defects_are_all_reported(self):
        state = CongruenceState(0, 72)
        report = localize(state, 1, 90)
        self.assertEqual(tuple(d.prime for d in report.defects), (2, 3))

    def test_reuses_formed_exponent_world(self):
        world = ExponentWorld()
        localize(CongruenceState(17, 72), 23, 90, world)
        event_count = len(world.life.events)
        localize(CongruenceState(17, 72), 23, 90, world)
        self.assertEqual(len(world.life.events), event_count)


if __name__ == "__main__":
    unittest.main()

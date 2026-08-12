#!/usr/bin/env python3

import unittest

from exponent_world import ExponentWorld


class ExponentWorldTests(unittest.TestCase):
    def test_recursive_origins_form_exponent_coordinates(self):
        world = ExponentWorld()
        form = world.form(72)
        self.assertEqual(form.powers, ((2, 3), (3, 2)))
        self.assertEqual(form.reconstruct(), 72)

    def test_multiplication_becomes_coordinate_addition(self):
        world = ExponentWorld()
        self.assertEqual(
            world.multiply(12, 18).powers,
            ((2, 3), (3, 3)),
        )

    def test_gcd_lcm_become_min_max(self):
        world = ExponentWorld()
        self.assertEqual(world.gcd(72, 90).powers, ((2, 1), (3, 2)))
        self.assertEqual(world.lcm(72, 90).powers, ((2, 3), (3, 2), (5, 1)))

    def test_divisor_count_compiles_from_independent_choices(self):
        world = ExponentWorld()
        self.assertEqual(world.divisor_count(72), 12)

    def test_formed_world_is_reused(self):
        world = ExponentWorld()
        first = world.form(72)
        event_count = len(world.life.events)
        second = world.form(72)
        self.assertIs(first, second)
        self.assertEqual(len(world.life.events), event_count)


if __name__ == "__main__":
    unittest.main()

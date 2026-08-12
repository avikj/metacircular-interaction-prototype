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

    def test_earned_prime_sensor_and_origins_form_inverse(self):
        world = ExponentWorld()
        world.life.factor(91)  # earns and certifies residue sensors through 7
        world.form(3)
        world.form(7)
        formed = world.form_inverse(3, 7)
        self.assertEqual(3 * formed.coefficient + 7 * formed.modulus_coefficient, 1)
        self.assertEqual(formed.inverse, 5)
        self.assertEqual(formed.solve(1), 5)
        self.assertEqual(formed.solve(4), 6)
        self.assertEqual(world.life.events[-1].kind, "form-operation")

    def test_inverse_fails_without_earned_memories(self):
        world = ExponentWorld()
        world.form(3)
        world.form(7)
        with self.assertRaises(ValueError):
            world.form_inverse(3, 7)  # no installed mod-7 sensor
        world.life.factor(91)
        with self.assertRaises(ValueError):
            world.form_inverse(2, 7)  # 2 has no cached exponent form

    def test_composite_sensor_does_not_form_field_division(self):
        world = ExponentWorld()
        world.life.install_residue_sensor(6, (6,))
        world.form(5)
        world.form(6)
        with self.assertRaises(ValueError):
            world.form_inverse(5, 6)


if __name__ == "__main__":
    unittest.main()

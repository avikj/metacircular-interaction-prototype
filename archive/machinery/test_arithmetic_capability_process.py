import unittest

from arithmetic_capability_process import SixClock


class ArithmeticCapabilityProcessTests(unittest.TestCase):
    def test_temporal_observation_is_necessary(self):
        clock = SixClock()
        self.assertEqual(clock.form_from_collision(2, 4), 3)
        self.assertEqual(clock.immediate_profile(2), clock.immediate_profile(4))
        self.assertEqual(clock.witness_word((2, 4)), ("successor",))
        self.assertEqual(clock.replay((2, 4)), ("multiple-of-3", (1, 0)))

    def test_all_residues_reconstruct(self):
        clock = SixClock()
        clock.form_multiple_of_three()
        profiles = [clock.behavioral_profile(x) for x in clock.states]
        self.assertEqual(len(set(profiles)), 6)
        self.assertEqual([clock.decode_residue(p) for p in profiles], list(range(6)))

    def test_new_actions_fail_closed_then_form(self):
        clock = SixClock()
        with self.assertRaises(ValueError):
            clock.add(5, 4)
        clock.form_multiple_of_three()
        self.assertEqual(clock.add(5, 4), 3)
        self.assertTrue(clock.divisible_by_six(0))
        self.assertFalse(clock.divisible_by_six(3))

    def test_every_pair_has_shortest_replay(self):
        clock = SixClock()
        clock.form_multiple_of_three()
        self.assertEqual(len(clock.certificates), 15)
        for pair, certificate in clock.certificates.items():
            self.assertEqual(len(clock.witness_word(pair)), certificate.distance)
            _, readings = clock.replay(pair)
            self.assertNotEqual(*readings)

    def test_generated_modulus_is_forced_by_difference(self):
        clock = SixClock()
        self.assertEqual(2 % 2, 4 % 2)
        self.assertNotEqual(2 % 3, 4 % 3)
        self.assertEqual(clock.form_from_collision(2, 4), 3)
        with self.assertRaises(ValueError):
            clock.form_from_collision(2, 4)


if __name__ == "__main__":
    unittest.main()

import unittest

from decohering_sensor_blindness import extreme_pair, sensor_profile


class DecoheringSensorBlindnessTests(unittest.TestCase):
    def test_constant_and_injective_sensors_have_same_channel_cost(self):
        constant, injective = extreme_pair(8)
        self.assertEqual(constant["decohering_environment"], 8)
        self.assertEqual(injective["decohering_environment"], 8)
        self.assertEqual(constant["image_size"], 1)
        self.assertEqual(injective["image_size"], 8)

    def test_coherent_overwrite_sees_the_opposite_extremes(self):
        constant, injective = extreme_pair(8)
        self.assertEqual(constant["coherent_overwrite_environment"], 8)
        self.assertEqual(injective["coherent_overwrite_environment"], 1)

    def test_residue_sensor_retains_fiber_information(self):
        profile = sensor_profile(tuple(value % 3 for value in range(8)))
        self.assertEqual(
            profile,
            {
                "source_size": 8,
                "image_size": 3,
                "coherent_overwrite_environment": 3,
                "decohering_environment": 8,
            },
        )

    def test_empty_source_is_rejected(self):
        with self.assertRaises(ValueError):
            sensor_profile(())


if __name__ == "__main__":
    unittest.main()


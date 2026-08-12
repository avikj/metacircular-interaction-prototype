#!/usr/bin/env python3
import unittest

from prosthetic_sensor_no_go import (
    absent_outcome_witness,
    conservative_absorption_possible,
    preservation_defects,
)


class ProstheticSensorNoGoTests(unittest.TestCase):
    def test_conservative_split_preserves_old_image(self):
        old = {"a": 0, "b": 1}
        new = ("a0", "a1", "b0")
        projection = {"a0": "a", "a1": "a", "b0": "b"}
        revised = {"a0": 0, "a1": 0, "b0": 1}
        self.assertFalse(preservation_defects(old, new, projection, revised))
        self.assertIsNone(absent_outcome_witness(old, new, revised))
        self.assertTrue(conservative_absorption_possible(old, new, projection, revised))

    def test_absent_outcome_forces_square_defect(self):
        old = {"a": 0, "b": 1}
        new = ("a0", "anomaly", "b0")
        projection = {"a0": "a", "anomaly": "a", "b0": "b"}
        revised = {"a0": 0, "anomaly": 2, "b0": 1}
        self.assertEqual(absent_outcome_witness(old, new, revised), ("anomaly", 2))
        self.assertEqual(len(preservation_defects(old, new, projection, revised)), 1)
        self.assertFalse(conservative_absorption_possible(old, new, projection, revised))

    def test_new_sensor_does_not_repair_old_probe_square(self):
        # Adding any independent sensor leaves this old-probe defect unchanged.
        old = {"a": "normal"}
        new = ("a0", "anomaly")
        projection = {"a0": "a", "anomaly": "a"}
        revised_old_probe = {"a0": "normal", "anomaly": "alarm"}
        added_sensor = {"a0": 0, "anomaly": 1}
        self.assertEqual(set(added_sensor.values()), {0, 1})
        self.assertTrue(preservation_defects(old, new, projection, revised_old_probe))

    def test_incomplete_revision_fails_closed(self):
        with self.assertRaises(ValueError):
            preservation_defects({"a": 0}, ("x",), {}, {"x": 0})


if __name__ == "__main__":
    unittest.main()

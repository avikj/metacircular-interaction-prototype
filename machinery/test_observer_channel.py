#!/usr/bin/env python3

import json
import tempfile
import unittest
from pathlib import Path

from observer_channel import audit, load_rows


class ObserverChannelTests(unittest.TestCase):
    def test_target_descent_can_hold_without_state_reconstruction(self) -> None:
        rows = [
            {"state": 0, "observable": "a", "target": 0},
            {"state": 1, "observable": "a", "target": 0},
            {"state": 2, "observable": "b", "target": 1},
        ]
        result = audit(rows)
        self.assertTrue(result["target_descends"])
        self.assertEqual(result["zero_error_side_alphabet_for_target"], 1)
        self.assertEqual(result["zero_error_side_alphabet_for_state"], 2)
        self.assertEqual(result["fixed_length_side_bits_for_target"], 0)
        self.assertEqual(result["fixed_length_side_bits_for_state"], 1)

    def test_collision_witness_and_minimum_target_side_alphabet(self) -> None:
        rows = [
            {"state": "x0", "observable": 0, "target": "red"},
            {"state": "x1", "observable": 0, "target": "blue"},
            {"state": "x2", "observable": 0, "target": "green"},
            {"state": "x3", "observable": 1, "target": "red"},
        ]
        result = audit(rows)
        self.assertFalse(result["target_descends"])
        self.assertIsNotNone(result["collision_witness"])
        self.assertEqual(result["zero_error_side_alphabet_for_target"], 3)
        self.assertEqual(result["fixed_length_side_bits_for_target"], 2)

    def test_loader_rejects_duplicate_states_and_binds_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "states.jsonl"
            path.write_text(
                json.dumps({"state": [1, 2], "observable": 0, "target": 0}) + "\n",
                encoding="utf-8",
            )
            rows, digest = load_rows(path)
            self.assertEqual(len(rows), 1)
            self.assertEqual(len(digest), 64)
            path.write_text(
                "\n".join([
                    json.dumps({"state": {"a": 1}, "observable": 0, "target": 0}),
                    json.dumps({"state": {"a": 1}, "observable": 1, "target": 1}),
                ]),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "duplicate canonical state"):
                load_rows(path)

    def test_empty_input_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "empty.jsonl"
            path.write_text("\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "no states"):
                load_rows(path)


if __name__ == "__main__":
    unittest.main()

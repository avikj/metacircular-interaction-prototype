#!/usr/bin/env python3

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from observer_channel import audit, canonical, load_rows


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
        self.assertEqual(result["collision_witness"]["state_a"], "x0")
        self.assertEqual(result["collision_witness"]["state_b"], "x1")
        capacity = result["deterministic_shannon_capacity_annotation"]
        self.assertEqual(capacity["image_cardinality_exact"], 2)
        self.assertEqual(capacity["bits_exact_expression"], "log2(2)")
        self.assertEqual(capacity["bits_approx"], 1.0)

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

    def test_loader_rejects_duplicate_keys_floats_and_nonfinite_tokens(self) -> None:
        invalid_rows = [
            '{"state":{"a":1,"a":2},"observable":0,"target":0}\n',
            '{"state":0.1,"observable":0,"target":0}\n',
            '{"state":NaN,"observable":0,"target":0}\n',
            '{"state":0,"observable":Infinity,"target":0}\n',
        ]
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "states.jsonl"
            for encoded in invalid_rows:
                path.write_text(encoded, encoding="utf-8")
                with self.assertRaisesRegex(ValueError, "invalid exact JSON"):
                    load_rows(path)

    def test_reduced_tagged_rationals_are_exact_values(self) -> None:
        rows = [{
            "state": {"num": "-3", "den": "4"},
            "observable": {"num": "1", "den": "2"},
            "target": [True, None, 7],
        }]
        result = audit(rows)
        self.assertTrue(result["target_descends"])
        self.assertEqual(canonical(rows[0]["state"]), '{"den":"4","num":"-3"}')
        for bad in [
            {"num": "2", "den": "4"},
            {"num": "1", "den": "0"},
            {"num": "+1", "den": "2"},
            {"num": "01", "den": "2"},
        ]:
            with self.assertRaisesRegex(ValueError, "rational"):
                canonical(bad)

    def test_direct_api_rejects_empty_duplicate_and_inexact_rows(self) -> None:
        with self.assertRaisesRegex(ValueError, "no states"):
            audit([])
        with self.assertRaisesRegex(ValueError, "duplicate canonical state"):
            audit([
                {"state": 0, "observable": 0, "target": 0},
                {"state": 0, "observable": 1, "target": 1},
            ])
        with self.assertRaisesRegex(ValueError, "floating-point"):
            audit([{"state": 0, "observable": 0.5, "target": 0}])
        with self.assertRaisesRegex(ValueError, "input_sha256"):
            audit([{"state": 0, "observable": 0, "target": 0}], "not-a-digest")

    def test_cli_refuses_to_overwrite_input_and_reports_output_errors(self) -> None:
        script = Path(__file__).with_name("observer_channel.py")
        row = json.dumps({"state": 0, "observable": 0, "target": 0}) + "\n"
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            input_path = root / "states.jsonl"
            input_path.write_text(row, encoding="utf-8")
            same_path = subprocess.run(
                [sys.executable, str(script), str(input_path), "--output", str(input_path)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(same_path.returncode, 2)
            self.assertIn("must not be the input", same_path.stderr)
            self.assertEqual(input_path.read_text(encoding="utf-8"), row)

            missing_parent = root / "missing" / "result.json"
            failed_write = subprocess.run(
                [sys.executable, str(script), str(input_path), "--output", str(missing_parent)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(failed_write.returncode, 2)
            self.assertIn("No such file or directory", failed_write.stderr)
            self.assertNotIn("Traceback", failed_write.stderr)

            output_path = root / "result.json"
            success = subprocess.run(
                [sys.executable, str(script), str(input_path), "--output", str(output_path)],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(success.returncode, 0, success.stderr)
            output = json.loads(output_path.read_text(encoding="utf-8"))
            self.assertEqual(output["schema"], "finite-observer-audit-v2")
            self.assertEqual(output["input_sha256"], load_rows(input_path)[1])

    def test_empty_input_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "empty.jsonl"
            path.write_text("\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "no states"):
                load_rows(path)


if __name__ == "__main__":
    unittest.main()

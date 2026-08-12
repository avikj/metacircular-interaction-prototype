#!/usr/bin/env python3
"""Regression tests for the content-addressed CPU ledger."""

from __future__ import annotations

import json
import tempfile
import unittest
from argparse import Namespace
from pathlib import Path

import cpu_ledger


class CpuLedgerTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.spec = self.root / "spec.json"
        self.kernel = self.root / "kernel.py"
        self.spec.write_text('{"degree":2}\n', encoding="utf-8")
        self.kernel.write_text("# exact kernel\n", encoding="utf-8")

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def candidates(self, name: str, rows: list[list[int]]) -> Path:
        path = self.root / name
        with path.open("w", encoding="utf-8") as handle:
            for row in rows:
                handle.write(json.dumps({"coefficients": [str(x) for x in row]}) + "\n")
        return path

    def record(self, index: int, count: int, rows: list[list[int]]) -> Path:
        candidates = self.candidates(f"candidates-{index}.jsonl", rows)
        output = self.root / f"manifest-{index}.json"
        args = Namespace(
            spec=self.spec,
            kernel=self.kernel,
            candidates=candidates,
            shard_index=index,
            shard_count=count,
            domain=json.dumps({"index": index}),
            stage_counts=json.dumps([
                {"stage": "raw", "count": len(rows) + 3},
                {"stage": "survivors", "count": len(rows)},
            ]),
            command=f"kernel --shard {index}/{count}",
            output=output,
        )
        cpu_ledger.record(args)
        return output

    def test_record_verify_and_merge(self) -> None:
        one = self.record(0, 2, [[1, 0, 1]])
        two = self.record(1, 2, [[1, 1, 1]])
        self.assertEqual(cpu_ledger.validate_manifest(one), [])
        output = self.root / "merge.json"
        cpu_ledger.merge(Namespace(manifests=[one, two], output=output))
        merged = json.loads(output.read_text(encoding="utf-8"))
        self.assertEqual(merged["candidate_rows"], 2)

    def test_mutation_is_detected(self) -> None:
        manifest = self.record(0, 1, [[1, 0, 1]])
        value = json.loads(manifest.read_text(encoding="utf-8"))
        cpu_ledger.artifact_path(manifest, value["candidates"]["path"]).write_text(
            '{"coefficients":["1","9","1"]}\n', encoding="utf-8"
        )
        self.assertIn("candidates hash mismatch", cpu_ledger.validate_manifest(manifest))

    def test_incomplete_cover_is_rejected(self) -> None:
        one = self.record(0, 2, [[1, 0, 1]])
        with self.assertRaisesRegex(ValueError, "incomplete shard cover"):
            cpu_ledger.merge(Namespace(manifests=[one], output=self.root / "merge.json"))

    def test_nonmonotone_pipeline_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "cannot increase"):
            cpu_ledger.parse_stage_counts(json.dumps([
                {"stage": "one", "count": 2},
                {"stage": "two", "count": 3},
            ]))


if __name__ == "__main__":
    unittest.main()

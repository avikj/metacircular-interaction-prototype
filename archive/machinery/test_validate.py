#!/usr/bin/env python3
"""Regression tests for problem-spec versus bound-contract dispatch."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

import validate


class SpecDispatchTest(unittest.TestCase):
    def write(self, value: object) -> Path:
        directory = Path(tempfile.mkdtemp(prefix="math-spec-test-"))
        path = directory / "value.json"
        path.write_text(json.dumps(value), encoding="utf-8")
        return path

    def test_bound_contract_uses_bound_schema(self) -> None:
        value = {
            "format": "math-bound-contract-v1",
            "polynomial": "x^3+a*x+1",
            "degree": 3,
            "bounds_by_exponent": {"1": "4", "2": "7"},
            "derived_vector": {
                "orientation": "leading-to-constant",
                "values": ["7", "4"],
            },
        }
        kind, errors = validate.validate_path(self.write(value))
        self.assertEqual(kind, "math-bound-contract-v1")
        self.assertEqual(errors, [])

    def test_reversed_bound_contract_is_not_treated_as_problem_spec(self) -> None:
        value = {
            "format": "math-bound-contract-v1",
            "polynomial": "x^3+a*x+1",
            "degree": 3,
            "bounds_by_exponent": {"1": "4", "2": "7"},
            "derived_vector": {
                "orientation": "leading-to-constant",
                "values": ["4", "7"],
            },
        }
        kind, errors = validate.validate_path(self.write(value))
        self.assertEqual(kind, "math-bound-contract-v1")
        self.assertTrue(any("orientation mismatch" in error for error in errors))

    def test_problem_spec_still_requires_proof_labeled_pruning(self) -> None:
        value = {
            "claim_id": "R9999",
            "family": "test",
            "degree": 2,
            "mode": "discovery",
            "coefficient_order": ["1", "a", "1"],
            "decomposition": {},
            "stages": [
                {
                    "id": "bad",
                    "constraints": [
                        {
                            "id": "guess",
                            "status": "heuristic",
                            "proof_ref": "pending",
                            "prunes": True,
                        }
                    ],
                }
            ],
        }
        kind, errors = validate.validate_path(self.write(value))
        self.assertEqual(kind, "math-problem-spec-v1")
        self.assertTrue(any("unproved constraint may not prune" in error for error in errors))


if __name__ == "__main__":
    unittest.main()

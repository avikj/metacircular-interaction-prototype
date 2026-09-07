#!/usr/bin/env python3

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

import monomial_vertex as mv


def q(numerator: int, denominator: int = 1) -> dict[str, str]:
    return {"num": str(numerator), "den": str(denominator)}


def packet(domain: str = "closed") -> dict:
    return {
        "schema": mv.SCHEMA,
        "domain": domain,
        "caps": [q(1), q(10)],
        "groups": [{"vars": [0, 1], "product": q(5)}],
        "objectives": [{
            "id": "orientation-falsifier",
            "terms": [{"coefficient": q(1), "exponents": ["100", "0"]}],
        }],
    }


class MonomialVertexTests(unittest.TestCase):
    def test_heterogeneous_orientation(self) -> None:
        result = mv.check(packet())
        objective = result["objectives"][0]
        self.assertEqual(objective["value"], q(1))
        self.assertEqual(objective["closure_vertex_slack"], [[1]])
        self.assertEqual(objective["extremum_kind"], "maximum")

    def test_negative_laurent_exponent(self) -> None:
        value = packet()
        value["objectives"][0]["terms"][0]["exponents"] = ["-1", "0"]
        result = mv.check(value)
        self.assertEqual(result["objectives"][0]["value"], q(2))
        self.assertEqual(result["objectives"][0]["closure_vertex_slack"], [[0]])

    def test_product_of_simplices(self) -> None:
        value = {
            "schema": mv.SCHEMA,
            "domain": "closed",
            "caps": [q(2), q(3), q(5), q(7)],
            "groups": [
                {"vars": [0, 1], "product": q(3)},
                {"vars": [2, 3], "product": q(7)},
            ],
            "objectives": [{
                "id": "sum",
                "terms": [
                    {"coefficient": q(1), "exponents": ["1", "0", "0", "0"]},
                    {"coefficient": q(1), "exponents": ["0", "1", "0", "0"]},
                    {"coefficient": q(1), "exponents": ["0", "0", "1", "0"]},
                    {"coefficient": q(1), "exponents": ["0", "0", "0", "1"]},
                ],
            }],
        }
        result = mv.check(value)
        self.assertEqual(result["closure_vertex_count"], 4)
        self.assertEqual(result["objectives"][0]["closure_vertex_slack"], [[0, 2]])

    def test_strict_reports_supremum(self) -> None:
        result = mv.check(packet("strict"))
        objective = result["objectives"][0]
        self.assertEqual(objective["extremum_kind"], "supremum")
        self.assertEqual(objective["strict_domain_attainment"], "not_decided")

    def test_degenerate_closed_group(self) -> None:
        value = packet()
        value["groups"][0]["product"] = q(10)
        result = mv.check(value)
        self.assertEqual(result["closure_vertex_count"], 1)
        self.assertEqual(result["objectives"][0]["closure_vertex_slack"], [[None]])

    def test_rejects_overlap_and_inexact_numbers(self) -> None:
        value = packet()
        value["groups"] = [
            {"vars": [0, 1], "product": q(5)},
            {"vars": [1], "product": q(1)},
        ]
        with self.assertRaisesRegex(ValueError, "partition"):
            mv.check(value)
        value = packet()
        value["caps"][0] = 1.0
        with self.assertRaisesRegex(ValueError, "tagged rational"):
            mv.check(value)

    def test_loader_rejects_duplicate_keys_and_float(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bad.json"
            path.write_text('{"schema":"x","schema":"y"}', encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "duplicate object key"):
                mv.load_exact_json(path)
            path.write_text('{"x":1.25}', encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "floating-point"):
                mv.load_exact_json(path)

    def test_rejects_lone_surrogate_identifier(self) -> None:
        value = packet()
        value["objectives"][0]["id"] = "\ud800"
        with self.assertRaisesRegex(ValueError, "surrogates"):
            mv.check(value)


if __name__ == "__main__":
    unittest.main()

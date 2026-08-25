#!/usr/bin/env python3
"""Regression tests for exponent-addressed polynomial bounds."""

from __future__ import annotations

import unittest

import bound_contract


def octic_contract(values: list[str]) -> dict[str, object]:
    return {
        "format": bound_contract.FORMAT,
        "polynomial": "E(y)^2-y*O(y)^2",
        "degree": 8,
        "bounds_by_exponent": {
            "1": "12",
            "2": "59",
            "3": "150",
            "4": "209",
            "5": "159",
            "6": "64",
            "7": "12",
        },
        "derived_vector": {
            "orientation": "leading-to-constant",
            "values": values,
        },
    }


class BoundContractTest(unittest.TestCase):
    def test_correct_leading_order_is_accepted(self) -> None:
        value = octic_contract(["12", "64", "159", "209", "150", "59", "12"])
        self.assertEqual(bound_contract.validate_contract(value), [])
        emitted = bound_contract.emit_cpp(value, "kGraeffeBounds")
        self.assertIn("{0, 12, 59, 150, 209, 159, 64, 12, 0}", emitted)

    def test_reversed_derivation_is_rejected(self) -> None:
        value = octic_contract(["12", "59", "150", "209", "159", "64", "12"])
        errors = bound_contract.validate_contract(value)
        self.assertTrue(any("orientation mismatch" in error for error in errors))

    def test_missing_exponent_is_rejected(self) -> None:
        value = octic_contract(["12", "64", "159", "209", "150", "59", "12"])
        del value["bounds_by_exponent"]["6"]  # type: ignore[index]
        errors = bound_contract.validate_contract(value)
        self.assertTrue(any("exactly the interior exponents" in error for error in errors))


if __name__ == "__main__":
    unittest.main()

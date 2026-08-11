#!/usr/bin/env python3
"""Exact finite observer/target sufficiency audit.

Input is JSONL with one row per state and exactly these fields:

    {"state": ..., "observable": ..., "target": ...}

Load-bearing values may use JSON nulls, booleans, integers, strings, arrays,
and unique-key objects.  Floating-point numbers and nonstandard NaN/Infinity
tokens are rejected.  Exact rationals use the reduced tagged form
``{"num":"-3","den":"4"}``.  Equality is equality of the resulting canonical
exact-JSON encodings.  The checker is exact and finite: it does not assert that
the supplied rows exhaust an intended infinite or externally defined state
space.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import tempfile
from collections import defaultdict
from pathlib import Path
from typing import Any


FIELDS = {"state", "observable", "target"}
RATIONAL_FIELDS = {"num", "den"}
INTEGER_TEXT = re.compile(r"(?:0|-[1-9][0-9]*|[1-9][0-9]*)\Z")
POSITIVE_INTEGER_TEXT = re.compile(r"[1-9][0-9]*\Z")
SHA256_TEXT = re.compile(r"[0-9a-f]{64}\Z")


def _validate_string(value: str, path: str) -> None:
    if any(0xD800 <= ord(character) <= 0xDFFF for character in value):
        raise ValueError(f"{path}: strings may not contain lone UTF-16 surrogates")


def _validate_exact_json(value: Any, path: str = "value") -> None:
    if value is None or isinstance(value, bool):
        return
    if isinstance(value, int):
        return
    if isinstance(value, float):
        raise ValueError(f"{path}: floating-point numbers are forbidden; use a tagged rational")
    if isinstance(value, str):
        _validate_string(value, path)
        return
    if isinstance(value, list):
        for index, item in enumerate(value):
            _validate_exact_json(item, f"{path}[{index}]")
        return
    if isinstance(value, dict):
        for key in value:
            if not isinstance(key, str):
                raise ValueError(f"{path}: object keys must be strings")
            _validate_string(key, f"{path} key")
        if set(value) == RATIONAL_FIELDS:
            numerator = value["num"]
            denominator = value["den"]
            if not isinstance(numerator, str) or not INTEGER_TEXT.fullmatch(numerator):
                raise ValueError(f"{path}: rational numerator must be a canonical integer string")
            if not isinstance(denominator, str) or not POSITIVE_INTEGER_TEXT.fullmatch(denominator):
                raise ValueError(f"{path}: rational denominator must be a positive canonical integer string")
            if math.gcd(abs(int(numerator)), int(denominator)) != 1:
                raise ValueError(f"{path}: tagged rational must be in lowest terms")
            return
        for key, item in value.items():
            _validate_exact_json(item, f"{path}.{key}")
        return
    raise ValueError(f"{path}: unsupported non-JSON value of type {type(value).__name__}")


def _canonical_validated(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def canonical(value: Any) -> str:
    _validate_exact_json(value)
    return _canonical_validated(value)


def digest_bytes(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def _unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate object key {key!r}")
        result[key] = value
    return result


def _reject_float(token: str) -> Any:
    raise ValueError(f"floating-point number {token!r} is forbidden; use a tagged rational")


def _reject_nonfinite(token: str) -> Any:
    raise ValueError(f"nonstandard numeric token {token!r} is forbidden")


def _validate_row(row: Any, label: str) -> dict[str, Any]:
    if not isinstance(row, dict) or set(row) != FIELDS:
        raise ValueError(f"{label}: fields must be exactly {sorted(FIELDS)}")
    for field in sorted(FIELDS):
        _validate_exact_json(row[field], f"{label}.{field}")
    return row


def validate_rows(rows: Any) -> list[dict[str, Any]]:
    if not isinstance(rows, list):
        raise ValueError("rows must be a list")
    if not rows:
        raise ValueError("input has no states")
    validated: list[dict[str, Any]] = []
    seen_states: set[str] = set()
    for index, candidate in enumerate(rows, 1):
        row = _validate_row(candidate, f"row {index}")
        state_key = _canonical_validated(row["state"])
        if state_key in seen_states:
            raise ValueError(f"row {index}: duplicate canonical state")
        seen_states.add(state_key)
        validated.append(row)
    return validated


def load_rows(path: Path) -> tuple[list[dict[str, Any]], str]:
    raw = path.read_bytes()
    rows: list[dict[str, Any]] = []
    seen_states: set[str] = set()
    for line_number, line in enumerate(raw.decode("utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            candidate = json.loads(
                line,
                object_pairs_hook=_unique_object,
                parse_float=_reject_float,
                parse_constant=_reject_nonfinite,
            )
        except (json.JSONDecodeError, ValueError) as exc:
            raise ValueError(f"line {line_number}: invalid exact JSON: {exc}") from exc
        row = _validate_row(candidate, f"line {line_number}")
        state_key = _canonical_validated(row["state"])
        if state_key in seen_states:
            raise ValueError(f"line {line_number}: duplicate canonical state")
        seen_states.add(state_key)
        rows.append(row)
    if not rows:
        raise ValueError("input has no states")
    return rows, digest_bytes(raw)


def audit(rows: list[dict[str, Any]], input_sha256: str = "") -> dict[str, Any]:
    if not isinstance(input_sha256, str) or (
        input_sha256 and not SHA256_TEXT.fullmatch(input_sha256)
    ):
        raise ValueError("input_sha256 must be empty or 64 lowercase hexadecimal characters")
    rows = validate_rows(rows)
    fibers: dict[str, list[dict[str, Any]]] = defaultdict(list)
    observable_values: dict[str, Any] = {}
    for row in rows:
        key = _canonical_validated(row["observable"])
        observable_values[key] = row["observable"]
        fibers[key].append(row)

    target_descends = True
    collision = None
    max_fiber = 0
    max_target_fiber = 0
    fiber_ledger: list[dict[str, Any]] = []
    for key in sorted(fibers):
        fiber = sorted(fibers[key], key=lambda row: _canonical_validated(row["state"]))
        targets: dict[str, Any] = {}
        for row in fiber:
            targets[_canonical_validated(row["target"])] = row["target"]
        max_fiber = max(max_fiber, len(fiber))
        max_target_fiber = max(max_target_fiber, len(targets))
        if len(targets) > 1 and collision is None:
            first = fiber[0]
            first_target = _canonical_validated(first["target"])
            second = next(
                row for row in fiber
                if _canonical_validated(row["target"]) != first_target
            )
            collision = {
                "observable": observable_values[key],
                "state_a": first["state"],
                "target_a": first["target"],
                "state_b": second["state"],
                "target_b": second["target"],
            }
            target_descends = False
        fiber_ledger.append({
            "observable": observable_values[key],
            "state_count": len(fiber),
            "distinct_target_count": len(targets),
        })

    return {
        "schema": "finite-observer-audit-v2",
        "input_sha256": input_sha256,
        "state_count": len(rows),
        "observable_count": len(fibers),
        "target_descends": target_descends,
        "collision_witness": collision,
        "zero_error_side_alphabet_for_target": max_target_fiber,
        "zero_error_side_alphabet_for_state": max_fiber,
        "fixed_length_side_bits_for_target": (max_target_fiber - 1).bit_length(),
        "fixed_length_side_bits_for_state": (max_fiber - 1).bit_length(),
        "deterministic_shannon_capacity_annotation": {
            "channel_model": "one-use deterministic channel with unconstrained input distribution",
            "image_cardinality_exact": len(fibers),
            "bits_exact_expression": f"log2({len(fibers)})",
            "bits_approx": math.log2(len(fibers)),
        },
        "fiber_ledger": fiber_ledger,
        "trust_boundary": (
            "Exact for the supplied finite rows. It does not prove that the rows "
            "exhaust an intended external or infinite state space. The Shannon "
            "capacity annotation assumes free choice of the input distribution; "
            "its bits_approx field is floating-point and is not a target-sufficiency "
            "or runtime claim."
        ),
    }


def _atomic_write_text(path: Path, encoded: str) -> None:
    temporary_name: str | None = None
    try:
        descriptor, temporary_name = tempfile.mkstemp(
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
        )
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary_name, path)
        temporary_name = None
    finally:
        if temporary_name is not None:
            try:
                Path(temporary_name).unlink()
            except OSError:
                pass


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        if args.output is not None and args.input.resolve() == args.output.resolve():
            raise ValueError("output path must not be the input path")
        rows, input_sha256 = load_rows(args.input)
        result = audit(rows, input_sha256)
        encoded = json.dumps(result, sort_keys=True, indent=2, ensure_ascii=False) + "\n"
        if args.output:
            _atomic_write_text(args.output, encoded)
    except (OSError, UnicodeDecodeError, ValueError) as exc:
        parser.error(str(exc))
    if not args.output:
        print(encoded, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

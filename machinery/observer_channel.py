#!/usr/bin/env python3
"""Exact finite observer/target sufficiency audit.

Input is JSONL with one row per state and exactly these fields:

    {"state": ..., "observable": ..., "target": ...}

Values may be any JSON values.  Equality is canonical-JSON equality.  The
checker is exact and finite: it does not assert that the supplied rows exhaust
an intended infinite or externally defined state space.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from collections import defaultdict
from pathlib import Path
from typing import Any


FIELDS = {"state", "observable", "target"}


def canonical(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def digest_bytes(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def load_rows(path: Path) -> tuple[list[dict[str, Any]], str]:
    raw = path.read_bytes()
    rows: list[dict[str, Any]] = []
    seen_states: set[str] = set()
    for line_number, line in enumerate(raw.decode("utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError as exc:
            raise ValueError(f"line {line_number}: invalid JSON: {exc}") from exc
        if not isinstance(row, dict) or set(row) != FIELDS:
            raise ValueError(f"line {line_number}: fields must be exactly {sorted(FIELDS)}")
        state_key = canonical(row["state"])
        if state_key in seen_states:
            raise ValueError(f"line {line_number}: duplicate canonical state")
        seen_states.add(state_key)
        rows.append(row)
    if not rows:
        raise ValueError("input has no states")
    return rows, digest_bytes(raw)


def audit(rows: list[dict[str, Any]], input_sha256: str = "") -> dict[str, Any]:
    fibers: dict[str, list[dict[str, Any]]] = defaultdict(list)
    observable_values: dict[str, Any] = {}
    for row in rows:
        key = canonical(row["observable"])
        observable_values[key] = row["observable"]
        fibers[key].append(row)

    target_descends = True
    collision = None
    max_fiber = 0
    max_target_fiber = 0
    fiber_ledger: list[dict[str, Any]] = []
    for key in sorted(fibers):
        fiber = sorted(fibers[key], key=lambda row: canonical(row["state"]))
        targets: dict[str, Any] = {}
        for row in fiber:
            targets[canonical(row["target"])] = row["target"]
        max_fiber = max(max_fiber, len(fiber))
        max_target_fiber = max(max_target_fiber, len(targets))
        if len(targets) > 1 and collision is None:
            first = fiber[0]
            second = next(row for row in fiber if canonical(row["target"]) != canonical(first["target"]))
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
        "schema": "finite-observer-audit-v1",
        "input_sha256": input_sha256,
        "state_count": len(rows),
        "observable_count": len(fibers),
        "target_descends": target_descends,
        "collision_witness": collision,
        "zero_error_side_alphabet_for_target": max_target_fiber,
        "zero_error_side_alphabet_for_state": max_fiber,
        "fixed_length_side_bits_for_target": (max_target_fiber - 1).bit_length(),
        "fixed_length_side_bits_for_state": (max_fiber - 1).bit_length(),
        "shannon_capacity_bits_annotation": math.log2(len(fibers)),
        "fiber_ledger": fiber_ledger,
        "trust_boundary": (
            "Exact for the supplied finite rows. It does not prove that the rows "
            "exhaust an intended external or infinite state space. The Shannon "
            "capacity is an annotation, not a target-sufficiency or runtime claim."
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        rows, input_sha256 = load_rows(args.input)
        result = audit(rows, input_sha256)
    except (OSError, UnicodeDecodeError, ValueError) as exc:
        parser.error(str(exc))
    encoded = json.dumps(result, sort_keys=True, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.write_text(encoded, encoding="utf-8")
    else:
        print(encoded, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

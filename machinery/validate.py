#!/usr/bin/env python3
"""Fail closed on problem specs and stage manifests using the stdlib only."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def canonical_hash(value: object) -> str:
    data = json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(data).hexdigest()


def validate_spec(path: Path) -> list[str]:
    errors: list[str] = []
    value = json.loads(path.read_text(encoding="utf-8"))
    for key in ("claim_id", "family", "degree", "mode", "coefficient_order", "decomposition", "stages"):
        if key not in value:
            errors.append(f"missing {key}")
    if value.get("mode") not in {"discovery", "certificate"}:
        errors.append("mode must be discovery or certificate")
    for stage in value.get("stages", []):
        for constraint in stage.get("constraints", []):
            if constraint.get("status") not in {"theorem", "audited-lemma", "heuristic"}:
                errors.append(f"{stage.get('id')}/{constraint.get('id')}: invalid status")
            if constraint.get("prunes") and constraint.get("status") not in {"theorem", "audited-lemma"}:
                errors.append(f"{stage.get('id')}/{constraint.get('id')}: unproved constraint may not prune")
            if constraint.get("prunes") and constraint.get("proof_ref") in {None, "", "pending"}:
                errors.append(f"{stage.get('id')}/{constraint.get('id')}: pruning requires proof_ref")
    print(f"spec_sha256={canonical_hash(value)}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path)
    args = parser.parse_args()
    paths = args.paths or sorted((ROOT / "machinery" / "specs").glob("*.json"))
    failed = False
    for path in paths:
        errors = validate_spec(path)
        if errors:
            failed = True
            print(f"FAIL {path}")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"PASS {path}")
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())

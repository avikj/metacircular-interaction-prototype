#!/usr/bin/env python3
"""Report and validate retrospective path-harvest manifests.

This tool does not certify mathematics.  It ensures that mature claims receive
an explicit, statement-bound retrospective pass and that changed statements
invalidate stale harvests.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CLAIMS = ROOT / "collab" / "discovery" / "claims"
HARVEST = ROOT / "collab" / "discovery" / "harvest"
ELIGIBLE = {"formalizing", "proving", "breaking", "certified", "refuted",
            "known", "inconclusive"}
TOP_FIELDS = {
    "claim_id", "statement_hash", "source_commit", "harvested_at", "lineage",
    "moves_attempted", "route_delta", "seeds", "conclusion",
}
SEED_FIELDS = {
    "title", "kind", "exact_seed", "evidence", "cheap_test",
    "kill_condition", "status",
}
SEED_STATUSES = {"seed", "known", "killed", "deferred"}


def fail(message: str) -> None:
    raise ValueError(message)


def frontmatter(path: Path) -> dict[str, str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        fail(f"{path}: missing frontmatter")
    result: dict[str, str] = {}
    for line in lines[1:]:
        if line == "---":
            return result
        if not line.strip():
            continue
        if ":" not in line:
            fail(f"{path}: malformed frontmatter line {line!r}")
        key, value = line.split(":", 1)
        key = key.strip()
        if key in result:
            fail(f"{path}: duplicate key {key}")
        result[key] = value.strip()
    fail(f"{path}: unterminated frontmatter")


def claims() -> dict[str, tuple[Path, dict[str, str]]]:
    output: dict[str, tuple[Path, dict[str, str]]] = {}
    for path in sorted(CLAIMS.glob("R*.md")):
        meta = frontmatter(path)
        claim_id = meta.get("id", "")
        if not re.fullmatch(r"R\d{4}", claim_id):
            fail(f"{path}: invalid claim id {claim_id!r}")
        if not path.name.startswith(claim_id + "-"):
            fail(f"{path}: filename/id mismatch")
        if claim_id in output:
            fail(f"duplicate claim id {claim_id}")
        if not re.fullmatch(r"[0-9a-f]{64}", meta.get("statement_hash", "")):
            fail(f"{path}: invalid statement_hash")
        output[claim_id] = (path, meta)
    return output


def nonempty_string(value: object) -> bool:
    return isinstance(value, str) and bool(value.strip())


def validate_manifest(path: Path, claim_meta: dict[str, str]) -> list[str]:
    errors: list[str] = []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f"{path}: cannot parse JSON: {exc}"]
    if not isinstance(data, dict):
        return [f"{path}: top level must be an object"]
    unknown = set(data) - TOP_FIELDS
    missing = TOP_FIELDS - set(data)
    if unknown:
        errors.append(f"{path}: unknown fields {sorted(unknown)}")
    if missing:
        errors.append(f"{path}: missing fields {sorted(missing)}")
    claim_id = claim_meta["id"]
    if data.get("claim_id") != claim_id:
        errors.append(f"{path}: claim_id does not match {claim_id}")
    if data.get("statement_hash") != claim_meta["statement_hash"]:
        errors.append(f"{path}: stale or mismatched statement_hash")
    if not re.fullmatch(r"[0-9a-f]{40}", str(data.get("source_commit", ""))):
        errors.append(f"{path}: source_commit must be a full Git SHA-1")
    for key in ("harvested_at", "lineage", "route_delta", "conclusion"):
        if not nonempty_string(data.get(key)):
            errors.append(f"{path}: {key} must be nonempty")
    moves = data.get("moves_attempted")
    if not isinstance(moves, list) or not moves or not all(nonempty_string(x) for x in moves):
        errors.append(f"{path}: moves_attempted must be a nonempty string list")
    seeds = data.get("seeds")
    if not isinstance(seeds, list):
        errors.append(f"{path}: seeds must be a list")
        return errors
    for index, seed in enumerate(seeds):
        prefix = f"{path}: seed {index}"
        if not isinstance(seed, dict):
            errors.append(prefix + " must be an object")
            continue
        if set(seed) != SEED_FIELDS:
            errors.append(prefix + f" fields must be exactly {sorted(SEED_FIELDS)}")
        for key in SEED_FIELDS - {"status"}:
            if not nonempty_string(seed.get(key)):
                errors.append(prefix + f" {key} must be nonempty")
        if seed.get("status") not in SEED_STATUSES:
            errors.append(prefix + f" invalid status {seed.get('status')!r}")
    return errors


def main(argv: list[str]) -> int:
    command = argv[1] if len(argv) == 2 else ""
    if command not in {"pending", "validate"}:
        print("usage: path_harvest.py {pending|validate}", file=sys.stderr)
        return 2
    try:
        registry = claims()
    except ValueError as exc:
        print(f"ERROR {exc}", file=sys.stderr)
        return 1
    errors: list[str] = []
    pending: list[str] = []
    for claim_id, (_, meta) in registry.items():
        path = HARVEST / f"{claim_id}.json"
        if path.exists():
            errors.extend(validate_manifest(path, meta))
        elif meta.get("status") in ELIGIBLE:
            pending.append(claim_id)
    if errors:
        for error in errors:
            print("ERROR", error)
        return 1
    if command == "pending":
        for claim_id in pending:
            print(claim_id)
        print(f"pending={len(pending)}")
    else:
        print(f"harvest manifests valid; pending={len(pending)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

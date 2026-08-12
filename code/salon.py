#!/usr/bin/env python3
"""Fail-closed validator for persistent constructive-salon records."""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

KINDS = {"attention", "formation_pressure", "utterance", "construction", "question", "transport", "synthesis"}
MATH_KINDS = {"construction", "transport", "synthesis"}
NON_EVIDENTIARY_KINDS = {"attention", "formation_pressure"}
PRESSURES = {"out_of_model_outcome", "structural_blindness", "translation_gap", "persistent_descent_failure"}
REF_KINDS = {"attends_to", "released_as", "pressures", "depends_on", "responds_to", "objects_to", "transports", "synthesizes"}


def canonical(node: dict) -> bytes:
    body = {k: v for k, v in node.items() if k != "id"}
    return json.dumps(body, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()


def content_id(node: dict) -> str:
    return "salon:" + hashlib.sha256(canonical(node)).hexdigest()


def validate(record: dict, root: Path) -> list[str]:
    errors: list[str] = []
    nodes = record.get("nodes")
    if not isinstance(nodes, list):
        return ["nodes must be a list"]
    by_id: dict[str, dict] = {}
    for n, node in enumerate(nodes):
        where = f"nodes[{n}]"
        if not isinstance(node, dict):
            errors.append(f"{where} must be an object"); continue
        if node.get("kind") not in KINDS:
            errors.append(f"{where}: invalid kind")
        expected = content_id(node)
        if node.get("id") != expected:
            errors.append(f"{where}: content id mismatch")
        if expected in by_id:
            errors.append(f"{where}: duplicate content id")
        by_id[expected] = node
        if not isinstance(node.get("agent"), str) or not node.get("agent"):
            errors.append(f"{where}: nonempty execution agent required")
        if not isinstance(node.get("text"), str) or not node.get("text"):
            errors.append(f"{where}: nonempty text required")
        if node.get("kind") == "attention":
            if node.get("status") not in {"open", "released"}:
                errors.append(f"{where}: attention status must be open or released")
            forbidden = node.get("forbidden_conclusions")
            if not isinstance(forbidden, list) or not forbidden:
                errors.append(f"{where}: attention requires forbidden_conclusions")
        if node.get("kind") == "formation_pressure":
            if node.get("pressure_kind") not in PRESSURES:
                errors.append(f"{where}: invalid formation pressure kind")
            if not node.get("model_ref"):
                errors.append(f"{where}: formation pressure requires model_ref")
        lens = node.get("lens")
        if lens and lens.get("provenance") != "simulated-methodological-influence-not-historical":
            errors.append(f"{where}: lens must disclaim historical attribution")
        artifacts = node.get("artifacts", [])
        if node.get("kind") in MATH_KINDS and not artifacts:
            errors.append(f"{where}: mathematical judgment requires an artifact")
        for artifact in artifacts:
            p = (root / artifact).resolve()
            try: p.relative_to(root.resolve())
            except ValueError: errors.append(f"{where}: artifact escapes root"); continue
            if not p.is_file(): errors.append(f"{where}: missing artifact {artifact}")
    for n, edge in enumerate(record.get("edges", [])):
        if edge.get("kind") not in REF_KINDS: errors.append(f"edges[{n}]: invalid kind")
        if edge.get("from") not in by_id or edge.get("to") not in by_id:
            errors.append(f"edges[{n}]: dangling endpoint")
        elif edge.get("kind") in {"depends_on", "transports", "synthesizes"} and by_id[edge["to"]].get("kind") in NON_EVIDENTIARY_KINDS:
            errors.append(f"edges[{n}]: non-evidentiary node cannot support mathematics")
    branches = {b.get("id"): b for b in record.get("branches", [])}
    for n, b in enumerate(branches.values()):
        if b.get("head") not in by_id: errors.append(f"branches[{n}]: unknown head")
        parent = b.get("parent")
        if parent is not None and parent not in branches: errors.append(f"branches[{n}]: unknown parent")
    for n, r in enumerate(record.get("resumptions", [])):
        if r.get("branch") not in branches: errors.append(f"resumptions[{n}]: unknown branch")
        if r.get("from_head") not in by_id or r.get("new_head") not in by_id:
            errors.append(f"resumptions[{n}]: unknown head")
        elif branches.get(r.get("branch"), {}).get("head") != r.get("new_head"):
            errors.append(f"resumptions[{n}]: new_head is not branch head")
        if not r.get("resume_note"): errors.append(f"resumptions[{n}]: resume_note required")
    return errors


def main() -> int:
    path = Path(sys.argv[1])
    errors = validate(json.loads(path.read_text()), path.parent)
    if errors:
        print("\n".join(errors), file=sys.stderr); return 1
    print("salon record valid"); return 0


if __name__ == "__main__":
    raise SystemExit(main())

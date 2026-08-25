#!/usr/bin/env python3
"""Content-addressed work units for exact, sharded mathematics searches.

The tool does not certify the mathematical reduction encoded by a kernel.
It certifies the much narrower computational facts that the declared spec and
kernel were used, that candidate artifacts have not changed, that stage counts
are monotone, and that a merge contains exactly one manifest for every shard.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import platform
import sys
from pathlib import Path
from typing import Any, Iterable


FORMAT = "math-cpu-ledger-v1"


def canonical_bytes(value: object) -> bytes:
    return json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")


def object_hash(value: object) -> str:
    return hashlib.sha256(canonical_bytes(value)).hexdigest()


def file_hash(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, value: object) -> None:
    path.write_text(json.dumps(value, sort_keys=True, indent=2) + "\n", encoding="utf-8")


def portable_path(path: Path, manifest: Path) -> str:
    """Store paths relative to the manifest so a whole work bundle can move."""
    return os.path.relpath(path.resolve(), manifest.resolve().parent)


def artifact_path(manifest: Path, stored: str) -> Path:
    path = Path(stored)
    return path if path.is_absolute() else manifest.resolve().parent / path


def parse_stage_counts(raw: str) -> list[dict[str, object]]:
    value = json.loads(raw)
    if not isinstance(value, list) or not value:
        raise ValueError("stage counts must be a nonempty JSON list")
    result: list[dict[str, object]] = []
    previous: int | None = None
    names: set[str] = set()
    for item in value:
        if not isinstance(item, dict) or set(item) != {"stage", "count"}:
            raise ValueError("each stage count must have exactly stage and count")
        name, count = item["stage"], item["count"]
        if not isinstance(name, str) or not name or name in names:
            raise ValueError("stage names must be nonempty and unique")
        if not isinstance(count, int) or count < 0:
            raise ValueError("stage counts must be nonnegative integers")
        if previous is not None and count > previous:
            raise ValueError("a pruning pipeline cannot increase its candidate count")
        names.add(name)
        previous = count
        result.append({"stage": name, "count": count})
    return result


def canonical_coefficients(value: object) -> tuple[str, ...]:
    if not isinstance(value, list) or not value:
        raise ValueError("coefficients must be a nonempty list")
    result: list[str] = []
    for coefficient in value:
        if isinstance(coefficient, bool):
            raise ValueError("Boolean is not an integer coefficient")
        try:
            integer = int(coefficient)
        except (TypeError, ValueError) as error:
            raise ValueError("coefficient is not an integer") from error
        if str(integer) != str(coefficient):
            raise ValueError("coefficient is not in canonical decimal form")
        result.append(str(integer))
    return tuple(result)


def candidate_ids(path: Path, spec_sha256: str) -> list[str]:
    ids: list[str] = []
    with path.open(encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, 1):
            if not line.strip():
                continue
            value = json.loads(line)
            if not isinstance(value, dict) or "coefficients" not in value:
                raise ValueError(f"{path}:{line_number}: missing coefficients")
            coefficients = canonical_coefficients(value["coefficients"])
            ids.append(object_hash({"spec_sha256": spec_sha256, "coefficients": coefficients}))
    return ids


def digest_ids(ids: Iterable[str], *, ordered: bool) -> str:
    values = list(ids)
    if not ordered:
        values.sort()
    digest = hashlib.sha256()
    for value in values:
        digest.update(value.encode("ascii"))
        digest.update(b"\n")
    return digest.hexdigest()


def record(args: argparse.Namespace) -> int:
    spec = args.spec.resolve()
    kernel = args.kernel.resolve()
    candidates = args.candidates.resolve()
    if not (0 <= args.shard_index < args.shard_count):
        raise ValueError("shard index must lie in [0, shard_count)")

    spec_sha256 = file_hash(spec)
    ids = candidate_ids(candidates, spec_sha256)
    stages = parse_stage_counts(args.stage_counts)
    if stages[-1]["count"] != len(ids):
        raise ValueError("last stage count does not equal candidate row count")

    manifest = {
        "format": FORMAT,
        "spec": {"path": portable_path(spec, args.output), "sha256": spec_sha256},
        "kernel": {"path": portable_path(kernel, args.output), "sha256": file_hash(kernel)},
        "shard": {
            "index": args.shard_index,
            "count": args.shard_count,
            "domain": json.loads(args.domain),
        },
        "stages": stages,
        "candidates": {
            "path": portable_path(candidates, args.output),
            "sha256": file_hash(candidates),
            "rows": len(ids),
            "ordered_id_sha256": digest_ids(ids, ordered=True),
            "set_id_sha256": digest_ids(ids, ordered=False),
        },
        "run": {
            "command": args.command,
            "python": sys.version.split()[0],
            "platform": platform.platform(),
        },
    }
    manifest["manifest_sha256"] = object_hash(manifest)
    write_json(args.output, manifest)
    print(f"manifest_sha256={manifest['manifest_sha256']}")
    return 0


def validate_manifest(path: Path, *, verify_artifacts: bool = True) -> list[str]:
    errors: list[str] = []
    value = read_json(path)
    if value.get("format") != FORMAT:
        errors.append("wrong format")
    claimed_hash = value.get("manifest_sha256")
    unhashed = dict(value)
    unhashed.pop("manifest_sha256", None)
    if claimed_hash != object_hash(unhashed):
        errors.append("manifest hash mismatch")

    try:
        index = value["shard"]["index"]
        count = value["shard"]["count"]
        if not isinstance(index, int) or not isinstance(count, int) or not (0 <= index < count):
            errors.append("invalid shard coordinates")
        stages = value["stages"]
        parse_stage_counts(json.dumps(stages))
    except (KeyError, TypeError, ValueError) as error:
        errors.append(f"invalid structure: {error}")

    if verify_artifacts:
        for field in ("spec", "kernel", "candidates"):
            try:
                artifact = artifact_path(path, value[field]["path"])
                if not artifact.is_file():
                    errors.append(f"missing {field} artifact")
                elif file_hash(artifact) != value[field]["sha256"]:
                    errors.append(f"{field} hash mismatch")
            except (KeyError, TypeError):
                errors.append(f"invalid {field} record")
        if not errors:
            spec_sha256 = value["spec"]["sha256"]
            candidates = artifact_path(path, value["candidates"]["path"])
            ids = candidate_ids(candidates, spec_sha256)
            if len(ids) != value["candidates"]["rows"]:
                errors.append("candidate row count mismatch")
            if digest_ids(ids, ordered=True) != value["candidates"]["ordered_id_sha256"]:
                errors.append("ordered candidate digest mismatch")
            if digest_ids(ids, ordered=False) != value["candidates"]["set_id_sha256"]:
                errors.append("candidate set digest mismatch")
    return errors


def verify(args: argparse.Namespace) -> int:
    failed = False
    for path in args.manifests:
        errors = validate_manifest(path)
        if errors:
            failed = True
            print(f"FAIL {path}")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"PASS {path}")
    return int(failed)


def merge(args: argparse.Namespace) -> int:
    manifests = [(path, read_json(path)) for path in args.manifests]
    if not manifests:
        raise ValueError("at least one manifest is required")
    for path in args.manifests:
        errors = validate_manifest(path)
        if errors:
            raise ValueError(f"invalid manifest {path}: {'; '.join(errors)}")

    first = manifests[0][1]
    shard_count = first["shard"]["count"]
    common = (first["spec"]["sha256"], first["kernel"]["sha256"], shard_count)
    indices: set[int] = set()
    all_ids: list[str] = []
    for manifest_path, manifest in manifests:
        observed = (manifest["spec"]["sha256"], manifest["kernel"]["sha256"], manifest["shard"]["count"])
        if observed != common:
            raise ValueError("manifests do not share spec, kernel, and shard count")
        index = manifest["shard"]["index"]
        if index in indices:
            raise ValueError(f"duplicate shard index {index}")
        indices.add(index)
        all_ids.extend(candidate_ids(artifact_path(manifest_path, manifest["candidates"]["path"]), common[0]))
    expected = set(range(shard_count))
    if indices != expected:
        raise ValueError(f"incomplete shard cover: missing={sorted(expected-indices)} extra={sorted(indices-expected)}")
    if len(set(all_ids)) != len(all_ids):
        raise ValueError("candidate appears in more than one shard")

    result = {
        "format": "math-cpu-merge-v1",
        "spec_sha256": common[0],
        "kernel_sha256": common[1],
        "shard_count": shard_count,
        "candidate_rows": len(all_ids),
        "candidate_set_sha256": digest_ids(all_ids, ordered=False),
        "manifest_sha256s": sorted(value["manifest_sha256"] for _, value in manifests),
    }
    result["merge_sha256"] = object_hash(result)
    write_json(args.output, result)
    print(f"merge_sha256={result['merge_sha256']}")
    return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    subparsers = result.add_subparsers(dest="action", required=True)

    record_parser = subparsers.add_parser("record")
    record_parser.add_argument("--spec", required=True, type=Path)
    record_parser.add_argument("--kernel", required=True, type=Path)
    record_parser.add_argument("--candidates", required=True, type=Path)
    record_parser.add_argument("--shard-index", required=True, type=int)
    record_parser.add_argument("--shard-count", required=True, type=int)
    record_parser.add_argument("--domain", required=True, help="exact JSON description of the shard domain")
    record_parser.add_argument("--stage-counts", required=True, help="ordered JSON list of stage/count objects")
    record_parser.add_argument("--command", required=True)
    record_parser.add_argument("--output", required=True, type=Path)
    record_parser.set_defaults(function=record)

    verify_parser = subparsers.add_parser("verify")
    verify_parser.add_argument("manifests", nargs="+", type=Path)
    verify_parser.set_defaults(function=verify)

    merge_parser = subparsers.add_parser("merge")
    merge_parser.add_argument("manifests", nargs="+", type=Path)
    merge_parser.add_argument("--output", required=True, type=Path)
    merge_parser.set_defaults(function=merge)
    return result


def main() -> int:
    args = parser().parse_args()
    return args.function(args)


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Fail-closed validation for an inert MathDGM record archive.

This module validates descriptions of candidate genomes and evaluations.  It
does not execute candidates, apply patches, select agents, or update any
mathematical claim.  In particular, ``retained`` is only an archive state
meaning "eligible to be named as a parent by another genome".
"""

from __future__ import annotations

import argparse
import copy
import datetime as dt
import hashlib
import json
import math
import os
import re
import stat
from pathlib import Path, PurePosixPath
from typing import Any, Callable, Iterable, Mapping, Sequence


GENOME_FORMAT = "math-dgm-genome-v1"
EVALUATION_FORMAT = "math-dgm-evaluation-v1"
EVENT_FORMAT = "math-dgm-event-v1"
ATTESTATION_FORMAT = "math-dgm-evaluator-attestation-v1"
RECONSTRUCTION_FORMAT = "math-dgm-reconstruction-manifest-v1"
TRUST_POLICY_FORMAT = "math-dgm-trust-policy-v1"

HASH_FRAME_VERSION = b"math-dgm-hash-frame-v1\0"
MAX_JSON_BYTES = 4 * 1024 * 1024
MAX_ARCHIVE_BYTES = 64 * 1024 * 1024
MAX_JSONL_RECORDS = 100_000
MAX_JSON_NESTING = 32
MAX_STRING_CHARACTERS = 65_536
MAX_INTEGER_DIGITS = 101
MAX_CAS_ARTIFACT_BYTES = 64 * 1024 * 1024

# Evolution is quarantined to disposable candidate material.  The archive
# validator itself, proof/certification paths, CI, and collaboration protocol
# are outside this allowlist and also named explicitly in the denylist.
MUTABLE_PATH_PREFIXES = ("collab/evolution/candidates/",)
IMMUTABLE_TCB_PREFIXES = (
    ".github/",
    ".claude/",
    "AGENTS.md",
    "code/discovery_loop.py",
    "collab/PROTOCOL.md",
    "collab/discovery/",
    "collab/evolution/archive/",
    "formal/",
    "machinery/",
)

RESOURCE_MAXIMA = {
    "cpu_seconds": 7 * 24 * 60 * 60,
    "wall_seconds": 7 * 24 * 60 * 60,
    "memory_bytes": 1 << 40,
    "output_bytes": 1 << 40,
    "model_tokens": 1_000_000_000,
}

_CONTENT_ID = re.compile(r"sha256:[0-9a-f]{64}\Z")
_REVISION = re.compile(r"(?:git-sha1:[0-9a-f]{40}|git-sha256:[0-9a-f]{64})\Z")
_SLUG = re.compile(r"[a-z0-9][a-z0-9._-]{0,127}\Z")
_TIMESTAMP = re.compile(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\Z")
_SAFE_PATH_COMPONENT = re.compile(r"[a-z0-9][a-z0-9._-]{0,127}\Z")
_RESERVED_PATH_COMPONENTS = {".git", ".claude", ".codex", "agents.md"}

_GENOME_KEYS = {
    "format",
    "genome_id",
    "created_at",
    "parent_genome_ids",
    "base_revision",
    "base_snapshot_sha256",
    "objective_sha256s",
    "dependency_sha256s",
    "dependency_closure_sha256",
    "reconstruction_manifest_sha256",
    "mutations",
}
_MUTATION_KEYS = {"path", "operation", "before_sha256", "after_sha256", "rationale_sha256"}
_EVALUATION_KEYS = {
    "format",
    "evaluation_id",
    "genome_id",
    "evaluator_sha256",
    "evaluation_protocol_sha256",
    "environment_sha256",
    "resource_policy_sha256",
    "task_set_sha256",
    "seed_sha256s",
    "evaluation_cache_key",
    "evaluation_mode",
    "replicate",
    "run_nonce_sha256",
    "started_at",
    "finished_at",
    "outcome",
    "measurements",
    "resources",
    "artifact_sha256s",
    "attestation_sha256",
    "claim_effect",
}
_MEASUREMENT_KEYS = {"name", "numerator", "denominator", "direction"}
_RESOURCES_KEYS = {"limits", "used"}
_EVENT_KEYS = {
    "format",
    "event_id",
    "sequence",
    "at",
    "genome_id",
    "evaluation_id",
    "from_state",
    "to_state",
    "kind",
    "reason_sha256",
    "previous_event_id",
}

_TRANSITIONS: dict[tuple[str | None, str], str] = {
    (None, "proposed"): "propose",
    ("proposed", "evaluating"): "begin_evaluation",
    ("evaluated", "evaluating"): "begin_evaluation",
    ("evaluating", "evaluated"): "finish_evaluation",
    ("evaluated", "retained"): "retain",
    ("evaluated", "rejected"): "reject",
    ("retained", "retired"): "retire",
    ("rejected", "retired"): "retire",
}


class ValidationError(ValueError):
    """A record is not a valid exact MathDGM record."""


class ArchiveError(ValidationError):
    """A collection is not a valid append-only MathDGM archive."""


def _reject_float(_: str) -> None:
    raise ValidationError("JSON floating-point numbers are forbidden")


def _reject_constant(value: str) -> None:
    raise ValidationError(f"non-finite JSON number {value!r} is forbidden")


def _object_without_duplicates(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise ValidationError(f"duplicate JSON key {key!r}")
        result[key] = value
    return result


def _parse_bounded_integer(source: str) -> int:
    digits = source[1:] if source.startswith("-") else source
    if len(digits) > MAX_INTEGER_DIGITS:
        raise ValidationError(f"JSON integer exceeds {MAX_INTEGER_DIGITS} digits")
    try:
        return int(source)
    except (ValueError, OverflowError) as error:
        raise ValidationError("invalid JSON integer") from error


def _preflight_json_text(text: str) -> None:
    if not isinstance(text, str):
        raise ValidationError("JSON source must be text")
    try:
        encoded = text.encode("utf-8")
    except UnicodeEncodeError as error:
        raise ValidationError("JSON source is not Unicode scalar text") from error
    if len(encoded) > MAX_JSON_BYTES:
        raise ValidationError(f"JSON source exceeds {MAX_JSON_BYTES} bytes")
    depth = 0
    in_string = False
    escaped = False
    for character in text:
        if in_string:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == '"':
                in_string = False
            continue
        if character == '"':
            in_string = True
        elif character in "[{":
            depth += 1
            if depth > MAX_JSON_NESTING:
                raise ValidationError(f"JSON nesting exceeds {MAX_JSON_NESTING}")
        elif character in "]}":
            depth -= 1
            if depth < 0:
                break


def parse_exact_json(text: str) -> Any:
    """Parse resource-bounded JSON, normalizing every parser failure."""
    _preflight_json_text(text)
    try:
        value = json.loads(
            text,
            parse_int=_parse_bounded_integer,
            parse_float=_reject_float,
            parse_constant=_reject_constant,
            object_pairs_hook=_object_without_duplicates,
        )
    except ValidationError:
        raise
    except (json.JSONDecodeError, ValueError, OverflowError, RecursionError, UnicodeError) as error:
        raise ValidationError(f"invalid JSON: {error}") from error
    _reject_inexact_values(value)
    return value


def _reject_inexact_values(value: Any, path: str = "$", depth: int = 0) -> None:
    if depth > MAX_JSON_NESTING:
        raise ValidationError(f"{path}: nesting exceeds {MAX_JSON_NESTING}")
    if isinstance(value, float):
        raise ValidationError(f"{path}: floating-point values are forbidden")
    if isinstance(value, str):
        if len(value) > MAX_STRING_CHARACTERS:
            raise ValidationError(f"{path}: string exceeds {MAX_STRING_CHARACTERS} characters")
        try:
            value.encode("utf-8")
        except UnicodeEncodeError as error:
            raise ValidationError(f"{path}: string is not Unicode scalar text") from error
        return
    if value is None or isinstance(value, (int, bool)):
        if isinstance(value, int) and not isinstance(value, bool):
            digits = len(str(abs(value)))
            if digits > MAX_INTEGER_DIGITS:
                raise ValidationError(f"{path}: integer exceeds {MAX_INTEGER_DIGITS} digits")
        return
    if isinstance(value, list):
        for index, item in enumerate(value):
            _reject_inexact_values(item, f"{path}[{index}]", depth + 1)
        return
    if isinstance(value, dict):
        for key, item in value.items():
            if not isinstance(key, str):
                raise ValidationError(f"{path}: object key is not a string")
            if len(key) > MAX_STRING_CHARACTERS:
                raise ValidationError(f"{path}: object key is too long")
            _reject_inexact_values(item, f"{path}.{key}", depth + 1)
        return
    raise ValidationError(f"{path}: value has no exact JSON representation")


def canonical_json_bytes(value: Any) -> bytes:
    """Return the one accepted UTF-8 encoding of an exact JSON value."""
    _reject_inexact_values(value)
    try:
        result = json.dumps(
            value,
            ensure_ascii=False,
            allow_nan=False,
            sort_keys=True,
            separators=(",", ":"),
        ).encode("utf-8")
        if len(result) > MAX_JSON_BYTES:
            raise ValidationError(f"canonical JSON exceeds {MAX_JSON_BYTES} bytes")
        return result
    except (TypeError, ValueError, UnicodeEncodeError) as error:
        raise ValidationError(f"value cannot be canonically encoded: {error}") from error


def _framed_hash(domain: str, payload: bytes) -> str:
    try:
        domain_bytes = domain.encode("ascii")
    except UnicodeEncodeError as error:
        raise ValidationError("hash domain must be ASCII") from error
    if not domain_bytes or len(domain_bytes) > 255:
        raise ValidationError("hash domain length is invalid")
    preimage = (
        HASH_FRAME_VERSION
        + len(domain_bytes).to_bytes(2, "big")
        + domain_bytes
        + len(payload).to_bytes(8, "big")
        + payload
    )
    return "sha256:" + hashlib.sha256(preimage).hexdigest()


def artifact_id(payload: bytes) -> str:
    """Content ID for an inert CAS byte artifact, with a typed preimage."""
    if not isinstance(payload, bytes):
        raise ValidationError("artifact payload must be bytes")
    return _framed_hash("artifact/v1", payload)


_RECORD_ID_DOMAINS = {
    (GENOME_FORMAT, "genome_id"): "record/genome/v1",
    (EVALUATION_FORMAT, "evaluation_id"): "record/evaluation/v1",
    (EVENT_FORMAT, "event_id"): "record/event/v1",
}


def content_id(record: Mapping[str, Any], id_field: str) -> str:
    """Hash a record's identity projection.

    Genome creation time is archive metadata, not semantic genome identity.
    Evaluation observations and event times are part of those run/event
    records; their separate semantic cache key excludes them.
    """
    if id_field not in record:
        raise ValidationError(f"missing content-id field {id_field!r}")
    format_name = record.get("format")
    domain = _RECORD_ID_DOMAINS.get((format_name, id_field))
    if domain is None:
        raise ValidationError("unsupported record format/content-id field pair")
    unhashed = dict(record)
    del unhashed[id_field]
    if id_field == "genome_id" and unhashed.get("format") == GENOME_FORMAT:
        unhashed.pop("created_at", None)
    return _framed_hash(domain, canonical_json_bytes(unhashed))


def add_content_id(record: Mapping[str, Any], id_field: str) -> dict[str, Any]:
    """Return a deep copy with a canonical content ID filled in."""
    result = copy.deepcopy(dict(record))
    result[id_field] = ""
    result[id_field] = content_id(result, id_field)
    return result


def dependency_closure_id(parent_genome_ids: Sequence[str], dependency_sha256s: Sequence[str]) -> str:
    """Hash the complete direct edge set of a content-addressed genome node.

    Parent IDs recursively bind their own parent/dependency edges, so this
    local edge hash commits to the transitive closure without expanding it in
    every record.
    """
    value = {
        "dependency_sha256s": sorted(set(dependency_sha256s)),
        "parent_genome_ids": sorted(set(parent_genome_ids)),
    }
    return _framed_hash("dependency-edge-set/v1", canonical_json_bytes(value))


def evaluation_cache_key(
    genome_id: str,
    evaluator_sha256: str,
    evaluation_protocol_sha256: str,
    environment_sha256: str,
    resource_policy_sha256: str,
    task_set_sha256: str,
    seed_sha256s: Sequence[str],
    limits: Mapping[str, int],
) -> str:
    """Return a deterministic-only memoization key for the complete run contract."""
    value = {
        "evaluator_sha256": evaluator_sha256,
        "evaluation_protocol_sha256": evaluation_protocol_sha256,
        "environment_sha256": environment_sha256,
        "genome_id": genome_id,
        "limits": dict(limits),
        "resource_policy_sha256": resource_policy_sha256,
        "seed_sha256s": sorted(set(seed_sha256s)),
        "task_set_sha256": task_set_sha256,
    }
    return _framed_hash("evaluation-cache/deterministic/v1", canonical_json_bytes(value))


def stochastic_replicate_key(evaluation: Mapping[str, Any]) -> str:
    """Identify one replicate slot without collapsing its nonce/observation."""
    value = {
        "environment_sha256": evaluation["environment_sha256"],
        "evaluation_protocol_sha256": evaluation["evaluation_protocol_sha256"],
        "evaluator_sha256": evaluation["evaluator_sha256"],
        "genome_id": evaluation["genome_id"],
        "limits": evaluation["resources"]["limits"],
        "replicate": evaluation["replicate"],
        "resource_policy_sha256": evaluation["resource_policy_sha256"],
        "seed_sha256s": sorted(set(evaluation["seed_sha256s"])),
        "task_set_sha256": evaluation["task_set_sha256"],
    }
    return _framed_hash("evaluation-replicate-slot/stochastic/v1", canonical_json_bytes(value))


def evaluation_attestation_core_id(evaluation: Mapping[str, Any]) -> str:
    """Bind what a trusted evaluator attests without a circular artifact hash."""
    projection = dict(evaluation)
    projection.pop("evaluation_id", None)
    projection.pop("attestation_sha256", None)
    return _framed_hash("evaluation-attestation-core/v1", canonical_json_bytes(projection))


def expected_attestation(evaluation: Mapping[str, Any]) -> dict[str, str]:
    return {
        "format": ATTESTATION_FORMAT,
        "evaluation_core_id": evaluation_attestation_core_id(evaluation),
        "evaluator_sha256": str(evaluation["evaluator_sha256"]),
    }


def expected_reconstruction_manifest(genome: Mapping[str, Any]) -> dict[str, Any]:
    return {
        "format": RECONSTRUCTION_FORMAT,
        "base_revision": genome["base_revision"],
        "base_snapshot_sha256": genome["base_snapshot_sha256"],
        "mutations": genome["mutations"],
    }


def _object(value: Any, where: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise ValidationError(f"{where}: expected object")
    return value


def _exact_keys(value: Mapping[str, Any], keys: set[str], where: str) -> None:
    observed = set(value)
    if observed != keys:
        missing = sorted(keys - observed)
        extra = sorted(observed - keys)
        raise ValidationError(f"{where}: wrong keys; missing={missing}, extra={extra}")


def _string(value: Any, where: str, *, maximum: int = 256) -> str:
    if not isinstance(value, str) or not value or len(value) > maximum:
        raise ValidationError(f"{where}: expected a nonempty string of at most {maximum} characters")
    return value


def _slug(value: Any, where: str) -> str:
    result = _string(value, where, maximum=128)
    if _SLUG.fullmatch(result) is None:
        raise ValidationError(f"{where}: expected a canonical lowercase slug")
    return result


def _hash(value: Any, where: str) -> str:
    result = _string(value, where, maximum=71)
    if _CONTENT_ID.fullmatch(result) is None:
        raise ValidationError(f"{where}: expected sha256:<64 lowercase hex digits>")
    return result


def _optional_hash(value: Any, where: str) -> str | None:
    return None if value is None else _hash(value, where)


def _timestamp(value: Any, where: str) -> str:
    result = _string(value, where, maximum=20)
    if _TIMESTAMP.fullmatch(result) is None:
        raise ValidationError(f"{where}: expected RFC3339 UTC seconds (YYYY-MM-DDTHH:MM:SSZ)")
    try:
        dt.datetime.strptime(result, "%Y-%m-%dT%H:%M:%SZ")
    except ValueError as error:
        raise ValidationError(f"{where}: invalid calendar timestamp") from error
    return result


def _integer(value: Any, where: str, *, minimum: int = 0, maximum: int | None = None) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise ValidationError(f"{where}: expected an integer")
    if value < minimum or (maximum is not None and value > maximum):
        raise ValidationError(f"{where}: integer outside [{minimum}, {maximum}]")
    return value


def _sorted_unique_strings(
    value: Any,
    where: str,
    validator: Callable[[Any, str], str],
    *,
    maximum: int,
) -> list[str]:
    if not isinstance(value, list) or len(value) > maximum:
        raise ValidationError(f"{where}: expected a list of at most {maximum} entries")
    result = [validator(item, f"{where}[{index}]") for index, item in enumerate(value)]
    if result != sorted(set(result)):
        raise ValidationError(f"{where}: entries must be sorted and unique")
    return result


def _repository_path(value: Any, where: str) -> str:
    path = _string(value, where, maximum=512)
    if not path.isascii() or any(ord(character) < 0x20 or ord(character) == 0x7F for character in path):
        raise ValidationError(f"{where}: path must contain only printable ASCII")
    if "\\" in path or path.startswith("/") or path.endswith("/"):
        raise ValidationError(f"{where}: path must be a normalized repository-relative POSIX file")
    parts = PurePosixPath(path).parts
    if not parts or any(part in ("", ".", "..") for part in parts) or PurePosixPath(path).as_posix() != path:
        raise ValidationError(f"{where}: path must be normalized and cannot traverse")
    for part in parts:
        if _SAFE_PATH_COMPONENT.fullmatch(part) is None:
            raise ValidationError(f"{where}: path component {part!r} is not canonical lowercase ASCII")
        if part.casefold() in _RESERVED_PATH_COMPONENTS:
            raise ValidationError(f"{where}: reserved control component {part!r} is forbidden")
    if any(path == prefix.rstrip("/") or path.startswith(prefix) for prefix in IMMUTABLE_TCB_PREFIXES):
        raise ValidationError(f"{where}: path is in the immutable trusted computing base")
    if not any(path.startswith(prefix) and len(path) > len(prefix) for prefix in MUTABLE_PATH_PREFIXES):
        raise ValidationError(f"{where}: path is outside the mutable candidate allowlist")
    return path


def _verify_content_id(record: Mapping[str, Any], field: str, where: str) -> None:
    claimed = _hash(record[field], f"{where}.{field}")
    expected = content_id(record, field)
    if claimed != expected:
        raise ValidationError(f"{where}.{field}: content hash mismatch (expected {expected})")


def validate_genome(value: Any) -> dict[str, Any]:
    genome = _object(value, "genome")
    _exact_keys(genome, _GENOME_KEYS, "genome")
    if genome["format"] != GENOME_FORMAT:
        raise ValidationError("genome.format: wrong format")
    _timestamp(genome["created_at"], "genome.created_at")
    parents = _sorted_unique_strings(
        genome["parent_genome_ids"], "genome.parent_genome_ids", _hash, maximum=8
    )
    revision = _string(genome["base_revision"], "genome.base_revision", maximum=75)
    if _REVISION.fullmatch(revision) is None:
        raise ValidationError("genome.base_revision: expected git-sha1:<40 hex> or git-sha256:<64 hex>")
    base_snapshot = _hash(genome["base_snapshot_sha256"], "genome.base_snapshot_sha256")
    objectives = _sorted_unique_strings(
        genome["objective_sha256s"], "genome.objective_sha256s", _hash, maximum=32
    )
    if not objectives:
        raise ValidationError("genome.objective_sha256s: at least one objective is required")
    dependencies = _sorted_unique_strings(
        genome["dependency_sha256s"], "genome.dependency_sha256s", _hash, maximum=512
    )
    closure = _hash(genome["dependency_closure_sha256"], "genome.dependency_closure_sha256")
    expected_closure = dependency_closure_id(parents, dependencies)
    if closure != expected_closure:
        raise ValidationError(
            "genome.dependency_closure_sha256: does not bind the canonical parent/dependency edge set"
        )
    reconstruction = _hash(
        genome["reconstruction_manifest_sha256"], "genome.reconstruction_manifest_sha256"
    )
    mutations = genome["mutations"]
    if not isinstance(mutations, list) or not mutations or len(mutations) > 128:
        raise ValidationError("genome.mutations: expected 1..128 mutations")
    paths: list[str] = []
    referenced_hashes = set(objectives) | {base_snapshot, reconstruction}
    for index, raw in enumerate(mutations):
        where = f"genome.mutations[{index}]"
        mutation = _object(raw, where)
        _exact_keys(mutation, _MUTATION_KEYS, where)
        path = _repository_path(mutation["path"], f"{where}.path")
        paths.append(path)
        operation = mutation["operation"]
        if operation not in ("add", "modify"):
            raise ValidationError(f"{where}.operation: only add or modify is allowed")
        before = _optional_hash(mutation["before_sha256"], f"{where}.before_sha256")
        _hash(mutation["after_sha256"], f"{where}.after_sha256")
        _hash(mutation["rationale_sha256"], f"{where}.rationale_sha256")
        referenced_hashes.add(mutation["after_sha256"])
        referenced_hashes.add(mutation["rationale_sha256"])
        if before is not None:
            referenced_hashes.add(before)
        if (operation == "add") != (before is None):
            raise ValidationError(f"{where}: add requires null before_sha256; modify requires a hash")
        if before is not None and before == mutation["after_sha256"]:
            raise ValidationError(f"{where}: modify must change the file hash")
    if paths != sorted(set(paths)):
        raise ValidationError("genome.mutations: paths must be sorted and unique")
    if not referenced_hashes.issubset(dependencies):
        raise ValidationError("genome.dependency_sha256s: does not include every objective and mutation hash")
    _verify_content_id(genome, "genome_id", "genome")
    return genome


def _validate_resources(value: Any) -> dict[str, dict[str, int]]:
    resources = _object(value, "evaluation.resources")
    _exact_keys(resources, _RESOURCES_KEYS, "evaluation.resources")
    checked: dict[str, dict[str, int]] = {}
    for group in ("limits", "used"):
        record = _object(resources[group], f"evaluation.resources.{group}")
        _exact_keys(record, set(RESOURCE_MAXIMA), f"evaluation.resources.{group}")
        checked[group] = {
            name: _integer(
                record[name],
                f"evaluation.resources.{group}.{name}",
                maximum=maximum,
            )
            for name, maximum in RESOURCE_MAXIMA.items()
        }
    for name in RESOURCE_MAXIMA:
        if checked["used"][name] > checked["limits"][name]:
            raise ValidationError(f"evaluation.resources.used.{name}: exceeds declared limit")
    return checked


def validate_evaluation(value: Any) -> dict[str, Any]:
    evaluation = _object(value, "evaluation")
    _exact_keys(evaluation, _EVALUATION_KEYS, "evaluation")
    if evaluation["format"] != EVALUATION_FORMAT:
        raise ValidationError("evaluation.format: wrong format")
    _hash(evaluation["genome_id"], "evaluation.genome_id")
    evaluator = _hash(evaluation["evaluator_sha256"], "evaluation.evaluator_sha256")
    protocol = _hash(
        evaluation["evaluation_protocol_sha256"], "evaluation.evaluation_protocol_sha256"
    )
    environment = _hash(evaluation["environment_sha256"], "evaluation.environment_sha256")
    resource_policy = _hash(
        evaluation["resource_policy_sha256"], "evaluation.resource_policy_sha256"
    )
    task_set = _hash(evaluation["task_set_sha256"], "evaluation.task_set_sha256")
    seeds = _sorted_unique_strings(
        evaluation["seed_sha256s"], "evaluation.seed_sha256s", _hash, maximum=256
    )
    mode = evaluation["evaluation_mode"]
    if mode not in ("deterministic", "stochastic"):
        raise ValidationError("evaluation.evaluation_mode: expected deterministic or stochastic")
    replicate = _integer(evaluation["replicate"], "evaluation.replicate", maximum=(1 << 31) - 1)
    run_nonce = _optional_hash(evaluation["run_nonce_sha256"], "evaluation.run_nonce_sha256")
    started = _timestamp(evaluation["started_at"], "evaluation.started_at")
    finished = _timestamp(evaluation["finished_at"], "evaluation.finished_at")
    if finished < started:
        raise ValidationError("evaluation: finished_at precedes started_at")
    if evaluation["outcome"] not in ("pass", "fail", "error"):
        raise ValidationError("evaluation.outcome: expected pass, fail, or error")
    measurements = evaluation["measurements"]
    if not isinstance(measurements, list) or len(measurements) > 256:
        raise ValidationError("evaluation.measurements: expected at most 256 entries")
    names: list[str] = []
    for index, raw in enumerate(measurements):
        where = f"evaluation.measurements[{index}]"
        measurement = _object(raw, where)
        _exact_keys(measurement, _MEASUREMENT_KEYS, where)
        names.append(_slug(measurement["name"], f"{where}.name"))
        numerator = _integer(
            measurement["numerator"], f"{where}.numerator", minimum=-(10**100), maximum=10**100
        )
        denominator = _integer(measurement["denominator"], f"{where}.denominator", minimum=1, maximum=10**100)
        if math.gcd(abs(numerator), denominator) != 1:
            raise ValidationError(f"{where}: rational value must be reduced")
        if measurement["direction"] not in ("maximize", "minimize", "constraint"):
            raise ValidationError(f"{where}.direction: invalid direction")
    if names != sorted(set(names)):
        raise ValidationError("evaluation.measurements: names must be sorted and unique")
    resources = _validate_resources(evaluation["resources"])
    cache_key = _optional_hash(evaluation["evaluation_cache_key"], "evaluation.evaluation_cache_key")
    if mode == "deterministic":
        if replicate != 0 or run_nonce is not None:
            raise ValidationError("evaluation: deterministic runs require replicate=0 and null run_nonce_sha256")
        expected_cache_key = evaluation_cache_key(
            evaluation["genome_id"],
            evaluator,
            protocol,
            environment,
            resource_policy,
            task_set,
            seeds,
            resources["limits"],
        )
        if cache_key != expected_cache_key:
            raise ValidationError("evaluation.evaluation_cache_key: deterministic memoization-key mismatch")
    elif cache_key is not None or run_nonce is None:
        raise ValidationError(
            "evaluation: stochastic observations require null cache key and a content-addressed run nonce"
        )
    artifacts = _sorted_unique_strings(
        evaluation["artifact_sha256s"], "evaluation.artifact_sha256s", _hash, maximum=256
    )
    _hash(evaluation["attestation_sha256"], "evaluation.attestation_sha256")
    if evaluation["outcome"] == "pass":
        if not measurements:
            raise ValidationError("evaluation: pass requires at least one exact measurement")
        if not artifacts:
            raise ValidationError("evaluation: pass requires at least one resolved artifact")
        if not any(resources["used"][name] > 0 for name in ("cpu_seconds", "wall_seconds", "model_tokens")):
            raise ValidationError("evaluation: pass cannot report zero execution use")
    if evaluation["claim_effect"] != "none":
        raise ValidationError("evaluation.claim_effect: must be literal 'none'")
    _verify_content_id(evaluation, "evaluation_id", "evaluation")
    return evaluation


def validate_event(value: Any) -> dict[str, Any]:
    event = _object(value, "event")
    _exact_keys(event, _EVENT_KEYS, "event")
    if event["format"] != EVENT_FORMAT:
        raise ValidationError("event.format: wrong format")
    _integer(event["sequence"], "event.sequence", maximum=(1 << 63) - 1)
    _timestamp(event["at"], "event.at")
    _hash(event["genome_id"], "event.genome_id")
    evaluation_id = _optional_hash(event["evaluation_id"], "event.evaluation_id")
    previous = _optional_hash(event["previous_event_id"], "event.previous_event_id")
    from_state = event["from_state"]
    if from_state is not None:
        _string(from_state, "event.from_state", maximum=16)
    to_state = _string(event["to_state"], "event.to_state", maximum=16)
    expected_kind = _TRANSITIONS.get((from_state, to_state))
    if expected_kind is None or event["kind"] != expected_kind:
        raise ValidationError("event: illegal state transition or mismatched kind")
    _hash(event["reason_sha256"], "event.reason_sha256")
    if (event["kind"] == "finish_evaluation") != (evaluation_id is not None):
        raise ValidationError("event.evaluation_id: present exactly for finish_evaluation")
    if event["sequence"] == 0 and previous is not None:
        raise ValidationError("event.previous_event_id: first event must use null")
    if event["sequence"] > 0 and previous is None:
        raise ValidationError("event.previous_event_id: non-first event requires a predecessor")
    _verify_content_id(event, "event_id", "event")
    return event


class LocalCAS:
    """Read-only, regular-file-only resolver for typed artifact IDs."""

    def __init__(self, root: Path):
        self.root = root

    def read(self, identifier: str) -> bytes:
        checked = _hash(identifier, "CAS identifier")
        path = self.root / checked.removeprefix("sha256:")
        flags = os.O_RDONLY
        if hasattr(os, "O_NOFOLLOW"):
            flags |= os.O_NOFOLLOW
        try:
            descriptor = os.open(path, flags)
        except OSError as error:
            raise ArchiveError(f"CAS object {checked} cannot be opened as a non-symlink file: {error}") from error
        try:
            metadata = os.fstat(descriptor)
            if not stat.S_ISREG(metadata.st_mode):
                raise ArchiveError(f"CAS object {checked} is not a regular file")
            if metadata.st_size > MAX_CAS_ARTIFACT_BYTES:
                raise ArchiveError(f"CAS object {checked} exceeds {MAX_CAS_ARTIFACT_BYTES} bytes")
            chunks: list[bytes] = []
            remaining = metadata.st_size
            while remaining:
                chunk = os.read(descriptor, min(remaining, 1024 * 1024))
                if not chunk:
                    raise ArchiveError(f"CAS object {checked} was truncated while reading")
                chunks.append(chunk)
                remaining -= len(chunk)
            if os.read(descriptor, 1):
                raise ArchiveError(f"CAS object {checked} changed size while reading")
            payload = b"".join(chunks)
        finally:
            os.close(descriptor)
        observed = artifact_id(payload)
        if observed != checked:
            raise ArchiveError(f"CAS object {checked} has content ID {observed}")
        return payload


def _parse_canonical_artifact(payload: bytes, where: str) -> Any:
    if len(payload) > MAX_JSON_BYTES:
        raise ArchiveError(f"{where}: structured artifact exceeds {MAX_JSON_BYTES} bytes")
    try:
        text = payload.decode("utf-8")
        value = parse_exact_json(text)
    except (UnicodeDecodeError, ValidationError) as error:
        raise ArchiveError(f"{where}: {error}") from error
    if canonical_json_bytes(value) != payload:
        raise ArchiveError(f"{where}: artifact is not canonical JSON")
    return value


def load_trust_policy(path: Path) -> dict[str, set[str]]:
    try:
        raw = path.read_bytes()
    except OSError as error:
        raise ArchiveError(f"cannot read trust policy {path}: {error}") from error
    policy = _object(_parse_canonical_artifact(raw, "trust policy"), "trust policy")
    keys = {"format", "trusted_evaluator_sha256s", "trusted_attestation_sha256s"}
    _exact_keys(policy, keys, "trust policy")
    if policy["format"] != TRUST_POLICY_FORMAT:
        raise ArchiveError("trust policy: wrong format")
    evaluators = _sorted_unique_strings(
        policy["trusted_evaluator_sha256s"], "trust policy.trusted_evaluator_sha256s", _hash, maximum=256
    )
    attestations = _sorted_unique_strings(
        policy["trusted_attestation_sha256s"],
        "trust policy.trusted_attestation_sha256s",
        _hash,
        maximum=100_000,
    )
    return {"evaluators": set(evaluators), "attestations": set(attestations)}


def _verify_retention_evidence(
    genome: Mapping[str, Any],
    evaluation: Mapping[str, Any],
    event_reason_sha256s: Iterable[str],
    cas: LocalCAS | None,
    trust_policy: Mapping[str, set[str]] | None,
) -> None:
    if cas is None or trust_policy is None:
        raise ArchiveError("retention requires --cas and --trust-policy")
    for identifier in genome["dependency_sha256s"]:
        cas.read(identifier)
    for identifier in sorted(set(event_reason_sha256s)):
        cas.read(identifier)
    manifest_payload = cas.read(genome["reconstruction_manifest_sha256"])
    manifest = _parse_canonical_artifact(manifest_payload, "reconstruction manifest")
    if manifest != expected_reconstruction_manifest(genome):
        raise ArchiveError("reconstruction manifest does not exactly bind base snapshot and mutations")

    references = {
        evaluation["evaluator_sha256"],
        evaluation["evaluation_protocol_sha256"],
        evaluation["environment_sha256"],
        evaluation["resource_policy_sha256"],
        evaluation["task_set_sha256"],
        evaluation["attestation_sha256"],
        *evaluation["seed_sha256s"],
        *evaluation["artifact_sha256s"],
    }
    if evaluation["run_nonce_sha256"] is not None:
        references.add(evaluation["run_nonce_sha256"])
    for identifier in sorted(references):
        cas.read(identifier)
    if evaluation["evaluator_sha256"] not in trust_policy["evaluators"]:
        raise ArchiveError("retention evaluator is not in the trusted local allowlist")
    if evaluation["attestation_sha256"] not in trust_policy["attestations"]:
        raise ArchiveError("retention attestation is not in the trusted local allowlist")
    attestation_payload = cas.read(evaluation["attestation_sha256"])
    attestation = _parse_canonical_artifact(attestation_payload, "evaluator attestation")
    if attestation != expected_attestation(evaluation):
        raise ArchiveError("trusted evaluator attestation does not bind this evaluation")


def _read_canonical_jsonl(path: Path, validator: Callable[[Any], dict[str, Any]]) -> tuple[list[dict[str, Any]], bytes]:
    try:
        size = path.stat().st_size
        if size > MAX_ARCHIVE_BYTES:
            raise ArchiveError(f"{path}: archive exceeds {MAX_ARCHIVE_BYTES} bytes")
        raw = path.read_bytes()
    except OSError as error:
        raise ArchiveError(f"cannot read {path}: {error}") from error
    if raw and not raw.endswith(b"\n"):
        raise ArchiveError(f"{path}: JSONL must end with a newline")
    lines = raw.splitlines(keepends=True)
    if len(lines) > MAX_JSONL_RECORDS:
        raise ArchiveError(f"{path}: archive exceeds {MAX_JSONL_RECORDS} records")
    records: list[dict[str, Any]] = []
    for line_number, line in enumerate(lines, 1):
        if len(line) > MAX_JSON_BYTES + 1:
            raise ArchiveError(f"{path}:{line_number}: record exceeds {MAX_JSON_BYTES} bytes")
        if line in (b"\n", b"\r\n"):
            raise ArchiveError(f"{path}:{line_number}: blank lines are forbidden")
        try:
            text = line[:-1].decode("utf-8")
            value = parse_exact_json(text)
            expected = canonical_json_bytes(value) + b"\n"
            if line != expected:
                raise ArchiveError(f"{path}:{line_number}: record is not canonical JSON")
            records.append(validator(value))
        except (UnicodeDecodeError, ValidationError) as error:
            if isinstance(error, ArchiveError):
                raise
            raise ArchiveError(f"{path}:{line_number}: {error}") from error
    return records, raw


def _assert_append_only(previous: Path | None, current_raw: bytes, current: Path) -> None:
    if previous is None:
        return
    try:
        if previous.stat().st_size > MAX_ARCHIVE_BYTES:
            raise ArchiveError(f"{previous}: prior archive exceeds {MAX_ARCHIVE_BYTES} bytes")
        prior_raw = previous.read_bytes()
    except OSError as error:
        raise ArchiveError(f"cannot read prior archive {previous}: {error}") from error
    if prior_raw and not prior_raw.endswith(b"\n"):
        raise ArchiveError(f"{previous}: prior archive is not a complete JSONL prefix")
    if not current_raw.startswith(prior_raw):
        raise ArchiveError(f"{current}: archive rewrites or truncates its declared prior prefix")


def validate_bundle(
    genomes_path: Path,
    evaluations_path: Path,
    events_path: Path,
    *,
    previous_genomes_path: Path | None = None,
    previous_evaluations_path: Path | None = None,
    previous_events_path: Path | None = None,
    cas_path: Path | None = None,
    trust_policy_path: Path | None = None,
) -> dict[str, int]:
    """Validate three canonical JSONL logs and their cross-record invariants.

    If prior paths are supplied, each current file must contain its prior file
    as a byte-for-byte prefix.  This is an append-only check, not merely an
    equality check on parsed records.
    """
    genomes, genomes_raw = _read_canonical_jsonl(genomes_path, validate_genome)
    evaluations, evaluations_raw = _read_canonical_jsonl(evaluations_path, validate_evaluation)
    events, events_raw = _read_canonical_jsonl(events_path, validate_event)
    _assert_append_only(previous_genomes_path, genomes_raw, genomes_path)
    _assert_append_only(previous_evaluations_path, evaluations_raw, evaluations_path)
    _assert_append_only(previous_events_path, events_raw, events_path)
    cas = LocalCAS(cas_path) if cas_path is not None else None
    trust_policy = load_trust_policy(trust_policy_path) if trust_policy_path is not None else None

    genome_by_id: dict[str, dict[str, Any]] = {}
    for genome in genomes:
        genome_id = genome["genome_id"]
        if genome_id in genome_by_id:
            raise ArchiveError(f"duplicate genome_id {genome_id}")
        for parent_id in genome["parent_genome_ids"]:
            if parent_id not in genome_by_id:
                raise ArchiveError(f"genome {genome_id} names a parent not earlier in the genome archive")
        genome_by_id[genome_id] = genome

    evaluation_by_id: dict[str, dict[str, Any]] = {}
    evaluation_by_cache_key: dict[str, str] = {}
    stochastic_nonces: set[str] = set()
    stochastic_replicates: set[str] = set()
    for evaluation in evaluations:
        evaluation_id = evaluation["evaluation_id"]
        if evaluation_id in evaluation_by_id:
            raise ArchiveError(f"duplicate evaluation_id {evaluation_id}")
        if evaluation["genome_id"] not in genome_by_id:
            raise ArchiveError(f"evaluation {evaluation_id} names an unknown genome")
        cache_key = evaluation["evaluation_cache_key"]
        if cache_key is not None and cache_key in evaluation_by_cache_key:
            raise ArchiveError(
                f"evaluation cache key {cache_key} is duplicated by {evaluation_by_cache_key[cache_key]} and {evaluation_id}"
            )
        if cache_key is not None:
            evaluation_by_cache_key[cache_key] = evaluation_id
        nonce = evaluation["run_nonce_sha256"]
        if nonce is not None:
            if nonce in stochastic_nonces:
                raise ArchiveError(f"stochastic run nonce {nonce} is reused")
            stochastic_nonces.add(nonce)
            replicate_key = stochastic_replicate_key(evaluation)
            if replicate_key in stochastic_replicates:
                raise ArchiveError("stochastic replicate slot is duplicated under one run contract")
            stochastic_replicates.add(replicate_key)
        evaluation_by_id[evaluation_id] = evaluation

    state: dict[str, str] = {}
    started_at: dict[str, str] = {}
    last_outcome: dict[str, str] = {}
    last_evaluation: dict[str, str] = {}
    event_reasons: dict[str, set[str]] = {}
    used_evaluations: set[str] = set()
    previous_id: str | None = None
    previous_at: str | None = None
    for index, event in enumerate(events):
        if event["sequence"] != index:
            raise ArchiveError(f"event line {index + 1}: sequence must equal zero-based archive position")
        if event["previous_event_id"] != previous_id:
            raise ArchiveError(f"event line {index + 1}: broken previous_event_id chain")
        if previous_at is not None and event["at"] < previous_at:
            raise ArchiveError(f"event line {index + 1}: timestamps are not monotone")
        genome_id = event["genome_id"]
        if genome_id not in genome_by_id:
            raise ArchiveError(f"event line {index + 1}: unknown genome")
        observed_from = state.get(genome_id)
        if event["from_state"] != observed_from:
            raise ArchiveError(f"event line {index + 1}: from_state does not match archive state")
        event_reasons.setdefault(genome_id, set()).add(event["reason_sha256"])
        if event["kind"] == "propose":
            if event["at"] != genome_by_id[genome_id]["created_at"]:
                raise ArchiveError(f"event line {index + 1}: proposal time differs from genome created_at")
            for parent_id in genome_by_id[genome_id]["parent_genome_ids"]:
                if state.get(parent_id) != "retained":
                    raise ArchiveError(f"event line {index + 1}: parent genome is not retained")
        elif event["kind"] == "begin_evaluation":
            started_at[genome_id] = event["at"]
        elif event["kind"] == "finish_evaluation":
            evaluation_id = event["evaluation_id"]
            if evaluation_id in used_evaluations:
                raise ArchiveError(f"event line {index + 1}: evaluation is referenced twice")
            evaluation = evaluation_by_id.get(evaluation_id)
            if evaluation is None or evaluation["genome_id"] != genome_id:
                raise ArchiveError(f"event line {index + 1}: evaluation does not belong to genome")
            if not (started_at[genome_id] <= evaluation["started_at"] <= evaluation["finished_at"] <= event["at"]):
                raise ArchiveError(f"event line {index + 1}: evaluation times escape its event interval")
            used_evaluations.add(evaluation_id)
            last_outcome[genome_id] = evaluation["outcome"]
            last_evaluation[genome_id] = evaluation_id
        elif event["kind"] == "retain" and last_outcome.get(genome_id) != "pass":
            raise ArchiveError(f"event line {index + 1}: only a passing evaluation may be retained")
        elif event["kind"] == "retain":
            evaluation = evaluation_by_id[last_evaluation[genome_id]]
            _verify_retention_evidence(
                genome_by_id[genome_id], evaluation, event_reasons[genome_id], cas, trust_policy
            )
        state[genome_id] = event["to_state"]
        previous_id = event["event_id"]
        previous_at = event["at"]

    if set(state) != set(genome_by_id):
        missing = sorted(set(genome_by_id) - set(state))
        raise ArchiveError(f"genomes missing proposal events: {missing}")
    unused = sorted(set(evaluation_by_id) - used_evaluations)
    if unused:
        raise ArchiveError(f"evaluations missing finish events: {unused}")
    return {"genomes": len(genomes), "evaluations": len(evaluations), "events": len(events)}


def structural_diff(
    left_genome_id: str,
    right_genome_id: str,
    genomes: Iterable[Mapping[str, Any]],
) -> dict[str, list[Any]]:
    """Diff two genomes by ancestor/dependency graph, never by names or prose.

    This is intentionally not a source-code diff and makes no assertion that
    two different content IDs are semantically inequivalent.
    """
    by_id: dict[str, dict[str, Any]] = {}
    for raw in genomes:
        record = validate_genome(raw)
        genome_id = record["genome_id"]
        if genome_id in by_id:
            raise ArchiveError(f"duplicate genome_id {genome_id}")
        by_id[genome_id] = record
    for genome_id in (left_genome_id, right_genome_id):
        if genome_id not in by_id:
            raise ArchiveError(f"unknown genome_id {genome_id}")

    def closure(root: str) -> tuple[set[str], set[str], set[tuple[str, str]]]:
        nodes: set[str] = set()
        dependencies: set[str] = set()
        edges: set[tuple[str, str]] = set()
        visiting: set[str] = set()

        def visit(genome_id: str) -> None:
            if genome_id in visiting:
                raise ArchiveError("genome parent graph contains a cycle")
            if genome_id in nodes:
                return
            visiting.add(genome_id)
            record = by_id[genome_id]
            dependencies.update(record["dependency_sha256s"])
            for parent in record["parent_genome_ids"]:
                if parent not in by_id:
                    raise ArchiveError(f"genome {genome_id} names an unknown parent")
                edges.add((parent, genome_id))
                visit(parent)
            visiting.remove(genome_id)
            nodes.add(genome_id)

        visit(root)
        return nodes, dependencies, edges

    left_nodes, left_dependencies, left_edges = closure(left_genome_id)
    right_nodes, right_dependencies, right_edges = closure(right_genome_id)
    return {
        "added_genome_ids": sorted(right_nodes - left_nodes),
        "removed_genome_ids": sorted(left_nodes - right_nodes),
        "added_dependency_sha256s": sorted(right_dependencies - left_dependencies),
        "removed_dependency_sha256s": sorted(left_dependencies - right_dependencies),
        "added_parent_edges": [list(edge) for edge in sorted(right_edges - left_edges)],
        "removed_parent_edges": [list(edge) for edge in sorted(left_edges - right_edges)],
    }


def _validate_single(kind: str, path: Path) -> None:
    validators = {"genome": validate_genome, "evaluation": validate_evaluation, "event": validate_event}
    try:
        if path.stat().st_size > MAX_JSON_BYTES:
            raise ValidationError(f"{path}: record exceeds {MAX_JSON_BYTES} bytes")
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise ValidationError(f"cannot read {path}: {error}") from error
    value = parse_exact_json(text)
    validators[kind](value)


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    single = subparsers.add_parser("record", help="validate one JSON record")
    single.add_argument("kind", choices=("genome", "evaluation", "event"))
    single.add_argument("path", type=Path)
    bundle = subparsers.add_parser("archive", help="validate a three-log archive")
    bundle.add_argument("--genomes", type=Path, required=True)
    bundle.add_argument("--evaluations", type=Path, required=True)
    bundle.add_argument("--events", type=Path, required=True)
    bundle.add_argument("--previous-genomes", type=Path)
    bundle.add_argument("--previous-evaluations", type=Path)
    bundle.add_argument("--previous-events", type=Path)
    bundle.add_argument("--cas", type=Path, help="read-only local CAS directory required for retention")
    bundle.add_argument("--trust-policy", type=Path, help="canonical local trust-policy JSON required for retention")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    try:
        if args.command == "record":
            _validate_single(args.kind, args.path)
            print(f"PASS {args.kind} {args.path}")
        else:
            counts = validate_bundle(
                args.genomes,
                args.evaluations,
                args.events,
                previous_genomes_path=args.previous_genomes,
                previous_evaluations_path=args.previous_evaluations,
                previous_events_path=args.previous_events,
                cas_path=args.cas,
                trust_policy_path=args.trust_policy,
            )
            print(f"PASS archive genomes={counts['genomes']} evaluations={counts['evaluations']} events={counts['events']}")
    except ValidationError as error:
        print(f"FAIL {error}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

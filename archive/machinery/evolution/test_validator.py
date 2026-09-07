#!/usr/bin/env python3
"""Regression and adversarial tests for the inert MathDGM record kernel."""

from __future__ import annotations

import copy
import json
import os
import re
import tempfile
import unittest
from pathlib import Path
from unittest import mock

try:
    from . import validator
except ImportError:  # Direct execution: python3 machinery/evolution/test_validator.py
    import validator  # type: ignore[no-redef]


BLOBS = {
    "objective": b"objective-v1",
    "strategy": b'{"strategy":"bounded"}\n',
    "rationale": b"rationale-v1",
    "snapshot": b"base-snapshot-v1",
    "evaluator": b"trusted-evaluator-v1",
    "protocol": b"evaluation-protocol-v1",
    "environment": b"environment-v1",
    "resource-policy": b"resource-policy-v1",
    "tasks": b"task-set-v1",
    "seed": b"seed-v1",
    "result": b"result-v1",
    "nonce-1": b"nonce-1",
    "nonce-2": b"nonce-2",
}
IDS = {name: validator.artifact_id(payload) for name, payload in BLOBS.items()}
KNOWN_PAYLOADS = {identifier: BLOBS[name] for name, identifier in IDS.items()}


def identified(record: dict[str, object], field: str) -> dict[str, object]:
    return validator.add_content_id(record, field)


def genome(*, created_at: str = "2026-08-11T20:00:00Z", parents: list[str] | None = None) -> dict[str, object]:
    parent_ids = parents or []
    mutation = {
        "path": "collab/evolution/candidates/strategy.json",
        "operation": "add",
        "before_sha256": None,
        "after_sha256": IDS["strategy"],
        "rationale_sha256": IDS["rationale"],
    }
    record: dict[str, object] = {
        "format": validator.GENOME_FORMAT,
        "genome_id": "",
        "created_at": created_at,
        "parent_genome_ids": parent_ids,
        "base_revision": "git-sha1:" + "1" * 40,
        "base_snapshot_sha256": IDS["snapshot"],
        "objective_sha256s": [IDS["objective"]],
        "dependency_sha256s": [],
        "dependency_closure_sha256": "",
        "reconstruction_manifest_sha256": "",
        "mutations": [mutation],
    }
    manifest = validator.canonical_json_bytes(validator.expected_reconstruction_manifest(record))
    manifest_id = validator.artifact_id(manifest)
    record["reconstruction_manifest_sha256"] = manifest_id
    dependencies = sorted(
        {IDS["objective"], IDS["strategy"], IDS["rationale"], IDS["snapshot"], manifest_id}
    )
    record["dependency_sha256s"] = dependencies
    record["dependency_closure_sha256"] = validator.dependency_closure_id(parent_ids, dependencies)
    return identified(record, "genome_id")


def resource_vector(**updates: int) -> dict[str, int]:
    value = {
        "cpu_seconds": 60,
        "wall_seconds": 60,
        "memory_bytes": 1024,
        "output_bytes": 1024,
        "model_tokens": 100,
    }
    value.update(updates)
    return value


def evaluation(
    genome_id: str,
    *,
    outcome: str = "pass",
    mode: str = "deterministic",
    replicate: int = 0,
    nonce: str | None = None,
    started_at: str = "2026-08-11T20:00:01Z",
    finished_at: str = "2026-08-11T20:00:02Z",
    cpu_limit: int = 60,
) -> dict[str, object]:
    limits = resource_vector(cpu_seconds=cpu_limit)
    used = resource_vector(cpu_seconds=1, wall_seconds=2, memory_bytes=512, output_bytes=256, model_tokens=10)
    seeds = [IDS["seed"]]
    cache_key = None
    run_nonce = None
    if mode == "deterministic":
        cache_key = validator.evaluation_cache_key(
            genome_id,
            IDS["evaluator"],
            IDS["protocol"],
            IDS["environment"],
            IDS["resource-policy"],
            IDS["tasks"],
            seeds,
            limits,
        )
    else:
        run_nonce = nonce or IDS["nonce-1"]
    record: dict[str, object] = {
        "format": validator.EVALUATION_FORMAT,
        "evaluation_id": "",
        "genome_id": genome_id,
        "evaluator_sha256": IDS["evaluator"],
        "evaluation_protocol_sha256": IDS["protocol"],
        "environment_sha256": IDS["environment"],
        "resource_policy_sha256": IDS["resource-policy"],
        "task_set_sha256": IDS["tasks"],
        "seed_sha256s": seeds,
        "evaluation_cache_key": cache_key,
        "evaluation_mode": mode,
        "replicate": replicate,
        "run_nonce_sha256": run_nonce,
        "started_at": started_at,
        "finished_at": finished_at,
        "outcome": outcome,
        "measurements": [
            {"name": "proofs-replayed", "numerator": 1, "denominator": 1, "direction": "maximize"}
        ],
        "resources": {"limits": limits, "used": used},
        "artifact_sha256s": [IDS["result"]],
        "attestation_sha256": IDS["result"],
        "claim_effect": "none",
    }
    attestation = validator.canonical_json_bytes(validator.expected_attestation(record))
    record["attestation_sha256"] = validator.artifact_id(attestation)
    return identified(record, "evaluation_id")


def event(
    sequence: int,
    genome_id: str,
    previous: str | None,
    from_state: str | None,
    to_state: str,
    kind: str,
    at: str,
    evaluation_id: str | None = None,
) -> dict[str, object]:
    return identified(
        {
            "format": validator.EVENT_FORMAT,
            "event_id": "",
            "sequence": sequence,
            "at": at,
            "genome_id": genome_id,
            "evaluation_id": evaluation_id,
            "from_state": from_state,
            "to_state": to_state,
            "kind": kind,
            "reason_sha256": IDS["rationale"],
            "previous_event_id": previous,
        },
        "event_id",
    )


def lifecycle(g: dict[str, object], evaluations: list[dict[str, object]], *, terminal: str = "retained") -> list[dict[str, object]]:
    result: list[dict[str, object]] = []
    previous = None
    state: str | None = None

    def add(old: str | None, new: str, kind: str, at: str, evaluation_id: str | None = None) -> None:
        nonlocal previous, state
        record = event(len(result), str(g["genome_id"]), previous, old, new, kind, at, evaluation_id)
        result.append(record)
        previous = str(record["event_id"])
        state = new

    add(None, "proposed", "propose", str(g["created_at"]))
    for item in evaluations:
        add(state, "evaluating", "begin_evaluation", str(item["started_at"]))
        add("evaluating", "evaluated", "finish_evaluation", str(item["finished_at"]), str(item["evaluation_id"]))
    terminal_at = "2026-08-11T20:00:09Z"
    add("evaluated", terminal, "retain" if terminal == "retained" else "reject", terminal_at)
    return result


class EvolutionValidatorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.cas = self.root / "cas"
        self.cas.mkdir()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def put(self, payload: bytes) -> str:
        identifier = validator.artifact_id(payload)
        (self.cas / identifier.removeprefix("sha256:")).write_bytes(payload)
        return identifier

    def install_evidence(self, g: dict[str, object], e: dict[str, object]) -> Path:
        for identifier in g["dependency_sha256s"]:  # type: ignore[union-attr]
            if identifier == g["reconstruction_manifest_sha256"]:
                payload = validator.canonical_json_bytes(validator.expected_reconstruction_manifest(g))
            else:
                payload = KNOWN_PAYLOADS[str(identifier)]
            self.assertEqual(self.put(payload), identifier)
        for name in ("evaluator", "protocol", "environment", "resource-policy", "tasks", "seed", "result"):
            self.put(BLOBS[name])
        if e["run_nonce_sha256"] is not None:
            nonce_payload = KNOWN_PAYLOADS[str(e["run_nonce_sha256"])]
            self.put(nonce_payload)
        attestation = validator.canonical_json_bytes(validator.expected_attestation(e))
        self.assertEqual(self.put(attestation), e["attestation_sha256"])
        policy = {
            "format": validator.TRUST_POLICY_FORMAT,
            "trusted_evaluator_sha256s": [e["evaluator_sha256"]],
            "trusted_attestation_sha256s": [e["attestation_sha256"]],
        }
        path = self.root / "trust-policy.json"
        path.write_bytes(validator.canonical_json_bytes(policy))
        return path

    def write_jsonl(self, name: str, records: list[dict[str, object]], *, canonical: bool = True) -> Path:
        path = self.root / name
        if canonical:
            path.write_bytes(b"".join(validator.canonical_json_bytes(record) + b"\n" for record in records))
        else:
            path.write_text('{ "noncanonical" : true }\n', encoding="utf-8")
        return path

    def bundle(self, g: dict[str, object], evaluations: list[dict[str, object]], events: list[dict[str, object]]) -> tuple[Path, Path, Path]:
        return (
            self.write_jsonl("genomes.jsonl", [g]),
            self.write_jsonl("evaluations.jsonl", evaluations),
            self.write_jsonl("events.jsonl", events),
        )

    def validate_retained(self, g: dict[str, object], evaluations: list[dict[str, object]], events: list[dict[str, object]]) -> dict[str, int]:
        policy = self.install_evidence(g, evaluations[-1])
        paths = self.bundle(g, evaluations, events)
        return validator.validate_bundle(*paths, cas_path=self.cas, trust_policy_path=policy)

    def test_valid_record_and_retained_bundle(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]))
        self.assertEqual(validator.validate_genome(g), g)
        self.assertEqual(validator.validate_evaluation(e), e)
        self.assertEqual(self.validate_retained(g, [e], lifecycle(g, [e])), {"genomes": 1, "evaluations": 1, "events": 4})

    def test_retention_requires_local_cas_and_trust_policy(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]))
        with self.assertRaisesRegex(validator.ArchiveError, "requires --cas and --trust-policy"):
            validator.validate_bundle(*self.bundle(g, [e], lifecycle(g, [e])))

    def test_untrusted_or_mismatched_attestation_is_rejected(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]))
        policy = self.install_evidence(g, e)
        raw = json.loads(policy.read_text())
        raw["trusted_attestation_sha256s"] = []
        policy.write_bytes(validator.canonical_json_bytes(raw))
        with self.assertRaisesRegex(validator.ArchiveError, "attestation is not"):
            validator.validate_bundle(*self.bundle(g, [e], lifecycle(g, [e])), cas_path=self.cas, trust_policy_path=policy)

    def test_missing_or_corrupt_cas_reference_is_rejected(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]))
        policy = self.install_evidence(g, e)
        target = self.cas / IDS["objective"].removeprefix("sha256:")
        target.unlink()
        with self.assertRaisesRegex(validator.ArchiveError, "cannot be opened"):
            validator.validate_bundle(*self.bundle(g, [e], lifecycle(g, [e])), cas_path=self.cas, trust_policy_path=policy)

    def test_semantically_wrong_reconstruction_manifest_is_rejected(self) -> None:
        g = genome()
        original_evaluation = evaluation(str(g["genome_id"]))
        self.install_evidence(g, original_evaluation)
        old_manifest = g["reconstruction_manifest_sha256"]
        wrong = {
            "format": validator.RECONSTRUCTION_FORMAT,
            "base_revision": g["base_revision"],
            "base_snapshot_sha256": g["base_snapshot_sha256"],
            "mutations": [],
        }
        wrong_id = self.put(validator.canonical_json_bytes(wrong))
        dependencies = sorted((set(g["dependency_sha256s"]) - {old_manifest}) | {wrong_id})  # type: ignore[arg-type]
        g["reconstruction_manifest_sha256"] = wrong_id
        g["dependency_sha256s"] = dependencies
        g["dependency_closure_sha256"] = validator.dependency_closure_id(g["parent_genome_ids"], dependencies)  # type: ignore[arg-type]
        g = identified(g, "genome_id")
        e = evaluation(str(g["genome_id"]))
        attestation = validator.canonical_json_bytes(validator.expected_attestation(e))
        self.assertEqual(self.put(attestation), e["attestation_sha256"])
        policy = {
            "format": validator.TRUST_POLICY_FORMAT,
            "trusted_evaluator_sha256s": [e["evaluator_sha256"]],
            "trusted_attestation_sha256s": [e["attestation_sha256"]],
        }
        policy_path = self.root / "wrong-manifest-policy.json"
        policy_path.write_bytes(validator.canonical_json_bytes(policy))
        with self.assertRaisesRegex(validator.ArchiveError, "manifest does not exactly bind"):
            validator.validate_bundle(
                *self.bundle(g, [e], lifecycle(g, [e])), cas_path=self.cas, trust_policy_path=policy_path
            )

    def test_allowlisted_but_semantically_wrong_attestation_is_rejected(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]))
        self.install_evidence(g, e)
        wrong = {
            "format": validator.ATTESTATION_FORMAT,
            "evaluation_core_id": IDS["objective"],
            "evaluator_sha256": e["evaluator_sha256"],
        }
        wrong_id = self.put(validator.canonical_json_bytes(wrong))
        e["attestation_sha256"] = wrong_id
        e = identified(e, "evaluation_id")
        policy = {
            "format": validator.TRUST_POLICY_FORMAT,
            "trusted_evaluator_sha256s": [e["evaluator_sha256"]],
            "trusted_attestation_sha256s": [wrong_id],
        }
        policy_path = self.root / "wrong-attestation-policy.json"
        policy_path.write_bytes(validator.canonical_json_bytes(policy))
        with self.assertRaisesRegex(validator.ArchiveError, "does not bind"):
            validator.validate_bundle(
                *self.bundle(g, [e], lifecycle(g, [e])), cas_path=self.cas, trust_policy_path=policy_path
            )

    def test_pass_requires_measurement_artifact_and_nonzero_use(self) -> None:
        g = genome()
        for mutation, message in (
            (("measurements", []), "measurement"),
            (("artifact_sha256s", []), "artifact"),
        ):
            e = evaluation(str(g["genome_id"]))
            e[mutation[0]] = mutation[1]
            e = identified(e, "evaluation_id")
            with self.subTest(field=mutation[0]), self.assertRaisesRegex(validator.ValidationError, message):
                validator.validate_evaluation(e)
        e = evaluation(str(g["genome_id"]))
        e["resources"]["used"] = {name: 0 for name in validator.RESOURCE_MAXIMA}  # type: ignore[index]
        e = identified(e, "evaluation_id")
        with self.assertRaisesRegex(validator.ValidationError, "zero execution"):
            validator.validate_evaluation(e)

    def test_parser_bounds_are_fail_closed_validation_errors(self) -> None:
        hostile = ["[" * (validator.MAX_JSON_NESTING + 1) + "]" * (validator.MAX_JSON_NESTING + 1), '{"x":' + "1" * (validator.MAX_INTEGER_DIGITS + 1) + "}"]
        for source in hostile:
            with self.subTest(length=len(source)), self.assertRaises(validator.ValidationError):
                validator.parse_exact_json(source)
        with self.assertRaises(validator.ValidationError):
            validator.parse_exact_json('{"x":"' + "a" * validator.MAX_JSON_BYTES + '"}')
        with mock.patch.object(validator, "MAX_STRING_CHARACTERS", 3):
            with self.assertRaisesRegex(validator.ValidationError, "string exceeds"):
                validator.parse_exact_json('{"x":"abcd"}')

    def test_archive_byte_line_and_record_caps_fail_before_record_validation(self) -> None:
        path = self.root / "hostile.jsonl"
        path.write_bytes(b"{}\n{}\n")
        with mock.patch.object(validator, "MAX_ARCHIVE_BYTES", 3):
            with self.assertRaisesRegex(validator.ArchiveError, "archive exceeds"):
                validator._read_canonical_jsonl(path, validator.validate_genome)
        with mock.patch.object(validator, "MAX_JSON_BYTES", 1):
            with self.assertRaisesRegex(validator.ArchiveError, "record exceeds"):
                validator._read_canonical_jsonl(path, validator.validate_genome)
        with mock.patch.object(validator, "MAX_JSONL_RECORDS", 1):
            with self.assertRaisesRegex(validator.ArchiveError, "records"):
                validator._read_canonical_jsonl(path, validator.validate_genome)

    def test_duplicate_keys_floats_nonfinite_and_surrogates_are_rejected(self) -> None:
        for source in ('{"x":1,"x":2}', '{"x":1.0}', '{"x":1e3}', '{"x":NaN}', '{"x":"\\ud800"}'):
            with self.subTest(source=source), self.assertRaises(validator.ValidationError):
                value = validator.parse_exact_json(source)
                validator.canonical_json_bytes(value)

    def test_hash_domains_and_order_normalization(self) -> None:
        parents = [IDS["strategy"], IDS["objective"]]
        dependencies = [IDS["rationale"], IDS["snapshot"]]
        projection = {"dependency_sha256s": sorted(dependencies), "parent_genome_ids": sorted(parents)}
        raw_alias = validator.artifact_id(validator.canonical_json_bytes(projection))
        closure = validator.dependency_closure_id(parents, dependencies)
        self.assertNotEqual(raw_alias, closure)
        self.assertEqual(closure, validator.dependency_closure_id(list(reversed(parents)), list(reversed(dependencies))))

    def test_candidate_paths_reject_controls_unicode_and_control_files(self) -> None:
        attacks = (
            "collab/evolution/candidates/AGENTS.md",
            "collab/evolution/candidates/.git/config",
            "collab/evolution/candidates/.claude/x",
            "collab/evolution/candidates/.codex/x",
            "collab/evolution/candidates/\x00x",
            "collab/evolution/candidates/line\nbreak",
            "collab/evolution/candidates/caf\N{LATIN SMALL LETTER E WITH ACUTE}.json",
            "collab/evolution/candidates/Foo.json",
            "collab/evolution/candidates/../archive/x",
        )
        for path in attacks:
            g = genome()
            g["mutations"][0]["path"] = path  # type: ignore[index]
            g = identified(g, "genome_id")
            with self.subTest(path=repr(path)), self.assertRaises(validator.ValidationError):
                validator.validate_genome(g)
        g = genome()
        g["mutations"][0]["path"] = "collab/evolution/candidates/x"  # type: ignore[index]
        manifest = validator.canonical_json_bytes(validator.expected_reconstruction_manifest(g))
        g["reconstruction_manifest_sha256"] = validator.artifact_id(manifest)
        dependencies = sorted(set(g["dependency_sha256s"]) | {g["reconstruction_manifest_sha256"]})  # type: ignore[arg-type]
        g["dependency_sha256s"] = dependencies
        g["dependency_closure_sha256"] = validator.dependency_closure_id(g["parent_genome_ids"], dependencies)  # type: ignore[arg-type]
        g = identified(g, "genome_id")
        validator.validate_genome(g)

    def test_cache_key_binds_limits_and_execution_contract(self) -> None:
        g = genome()
        first = evaluation(str(g["genome_id"]), cpu_limit=60)
        second = evaluation(str(g["genome_id"]), cpu_limit=600)
        self.assertNotEqual(first["evaluation_cache_key"], second["evaluation_cache_key"])
        altered = copy.deepcopy(first)
        altered["environment_sha256"] = IDS["objective"]
        altered = identified(altered, "evaluation_id")
        with self.assertRaisesRegex(validator.ValidationError, "memoization-key mismatch"):
            validator.validate_evaluation(altered)

    def test_stochastic_replicates_are_not_cached_or_collapsed(self) -> None:
        g = genome()
        first = evaluation(str(g["genome_id"]), outcome="fail", mode="stochastic", replicate=0, nonce=IDS["nonce-1"], started_at="2026-08-11T20:00:01Z", finished_at="2026-08-11T20:00:02Z")
        second = evaluation(str(g["genome_id"]), mode="stochastic", replicate=1, nonce=IDS["nonce-2"], started_at="2026-08-11T20:00:03Z", finished_at="2026-08-11T20:00:04Z")
        self.assertIsNone(first["evaluation_cache_key"])
        self.assertIsNone(second["evaluation_cache_key"])
        events = lifecycle(g, [first, second])
        self.assertEqual(self.validate_retained(g, [first, second], events)["evaluations"], 2)

    def test_reused_stochastic_nonce_is_rejected(self) -> None:
        g = genome()
        first = evaluation(str(g["genome_id"]), mode="stochastic", nonce=IDS["nonce-1"])
        second = evaluation(str(g["genome_id"]), mode="stochastic", replicate=1, nonce=IDS["nonce-1"], started_at="2026-08-11T20:00:03Z", finished_at="2026-08-11T20:00:04Z")
        with self.assertRaisesRegex(validator.ArchiveError, "nonce .* reused"):
            validator.validate_bundle(*self.bundle(g, [first, second], lifecycle(g, [first, second])))

    def test_duplicate_stochastic_replicate_slot_is_rejected_even_with_new_nonce(self) -> None:
        g = genome()
        first = evaluation(str(g["genome_id"]), mode="stochastic", replicate=0, nonce=IDS["nonce-1"])
        second = evaluation(str(g["genome_id"]), mode="stochastic", replicate=0, nonce=IDS["nonce-2"], started_at="2026-08-11T20:00:03Z", finished_at="2026-08-11T20:00:04Z")
        with self.assertRaisesRegex(validator.ArchiveError, "replicate slot"):
            validator.validate_bundle(*self.bundle(g, [first, second], lifecycle(g, [first, second])))

    def test_duplicate_deterministic_cache_key_is_rejected(self) -> None:
        g = genome()
        first = evaluation(str(g["genome_id"]), outcome="fail")
        second = copy.deepcopy(first)
        second["started_at"] = "2026-08-11T20:00:03Z"
        second["finished_at"] = "2026-08-11T20:00:04Z"
        second["attestation_sha256"] = IDS["result"]
        attestation = validator.canonical_json_bytes(validator.expected_attestation(second))
        second["attestation_sha256"] = validator.artifact_id(attestation)
        second = identified(second, "evaluation_id")
        with self.assertRaisesRegex(validator.ArchiveError, "cache key .* duplicated"):
            validator.validate_bundle(*self.bundle(g, [first, second], lifecycle(g, [first, second], terminal="rejected")))

    def test_illegal_transition_and_failed_retention_are_rejected(self) -> None:
        g = genome()
        bad = event(1, str(g["genome_id"]), IDS["objective"], "proposed", "retained", "retain", "2026-08-11T20:00:01Z")
        with self.assertRaisesRegex(validator.ValidationError, "illegal state transition"):
            validator.validate_event(bad)
        failed = evaluation(str(g["genome_id"]), outcome="fail")
        with self.assertRaisesRegex(validator.ArchiveError, "only a passing"):
            validator.validate_bundle(*self.bundle(g, [failed], lifecycle(g, [failed])))

    def test_parent_must_be_retained_before_child_proposal(self) -> None:
        parent = genome()
        failed = evaluation(str(parent["genome_id"]), outcome="fail")
        parent_events = lifecycle(parent, [failed], terminal="rejected")
        child = genome(created_at="2026-08-11T20:00:10Z", parents=[str(parent["genome_id"])])
        child_event = event(len(parent_events), str(child["genome_id"]), str(parent_events[-1]["event_id"]), None, "proposed", "propose", str(child["created_at"]))
        genomes = self.write_jsonl("genomes.jsonl", [parent, child])
        evaluations = self.write_jsonl("evaluations.jsonl", [failed])
        events = self.write_jsonl("events.jsonl", parent_events + [child_event])
        with self.assertRaisesRegex(validator.ArchiveError, "parent genome is not retained"):
            validator.validate_bundle(genomes, evaluations, events)

    def test_append_only_and_canonical_jsonl(self) -> None:
        g = genome()
        e = evaluation(str(g["genome_id"]), outcome="fail")
        events = lifecycle(g, [e], terminal="rejected")
        current = self.bundle(g, [e], events)
        previous = self.root / "previous-events.jsonl"
        previous.write_bytes(b"".join(validator.canonical_json_bytes(item) + b"\n" for item in events[:2]))
        validator.validate_bundle(*current, previous_events_path=previous)
        previous.write_bytes(validator.canonical_json_bytes(events[0])[:20])
        with self.assertRaisesRegex(validator.ArchiveError, "complete JSONL prefix"):
            validator.validate_bundle(*current, previous_events_path=previous)
        noncanonical = self.write_jsonl("noncanonical.jsonl", [], canonical=False)
        with self.assertRaises(validator.ArchiveError):
            validator.validate_bundle(noncanonical, self.write_jsonl("empty-e.jsonl", []), self.write_jsonl("empty-v.jsonl", []))

    def test_structural_diff_and_unknown_parent(self) -> None:
        parent = genome()
        child = genome(created_at="2026-08-11T20:00:04Z", parents=[str(parent["genome_id"])])
        diff = validator.structural_diff(str(parent["genome_id"]), str(child["genome_id"]), [parent, child])
        self.assertEqual(diff["added_genome_ids"], [child["genome_id"]])
        self.assertEqual(diff["added_parent_edges"], [[parent["genome_id"], child["genome_id"]]])

    def test_schema_required_keys_and_resource_caps_match_code(self) -> None:
        schema_root = Path(validator.__file__).parent / "schemas"
        genome_schema = json.loads((schema_root / "genome-v1.schema.json").read_text())
        evaluation_schema = json.loads((schema_root / "evaluation-v1.schema.json").read_text())
        event_schema = json.loads((schema_root / "event-v1.schema.json").read_text())
        self.assertEqual(set(genome_schema["required"]), validator._GENOME_KEYS)
        self.assertEqual(set(evaluation_schema["required"]), validator._EVALUATION_KEYS)
        self.assertEqual(set(event_schema["required"]), validator._EVENT_KEYS)
        caps = evaluation_schema["$defs"]["resource-vector"]["properties"]
        self.assertEqual({name: spec["maximum"] for name, spec in caps.items()}, validator.RESOURCE_MAXIMA)
        path_pattern = genome_schema["$defs"]["mutation"]["properties"]["path"]["pattern"]
        self.assertIsNotNone(re.fullmatch(path_pattern, "collab/evolution/candidates/x"))
        self.assertIsNone(re.fullmatch(path_pattern, "collab/evolution/candidates/line\nbreak"))
        for reserved in ("agents.md", ".git/config", ".claude/x", ".codex/x"):
            self.assertIsNone(re.fullmatch(path_pattern, f"collab/evolution/candidates/{reserved}"))

    @unittest.skipUnless(hasattr(os, "symlink"), "symlink unsupported")
    def test_cas_symlink_is_rejected(self) -> None:
        identifier = IDS["objective"]
        target = self.root / "payload"
        target.write_bytes(BLOBS["objective"])
        os.symlink(target, self.cas / identifier.removeprefix("sha256:"))
        with self.assertRaisesRegex(validator.ArchiveError, "non-symlink"):
            validator.LocalCAS(self.cas).read(identifier)


if __name__ == "__main__":
    unittest.main()

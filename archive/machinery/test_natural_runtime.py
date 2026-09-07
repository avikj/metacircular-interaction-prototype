"""Adversarial tests for the read-only natural research runtime."""

from __future__ import annotations

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
CODE = ROOT / "code"
sys.path.insert(0, str(CODE))

import natural  # noqa: E402


class NaturalRuntimeTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.graph = natural.build_graph()

    def test_every_packet_compiles_and_hash_is_deterministic(self) -> None:
        self.assertGreaterEqual(len(self.graph.claims), 21)
        again = natural.build_graph()
        self.assertEqual(
            self.graph.snapshot["graph_sha256"],
            again.snapshot["graph_sha256"],
        )
        core = {key: value for key, value in self.graph.snapshot.items()
                if key != "graph_sha256"}
        self.assertEqual(
            self.graph.snapshot["graph_sha256"],
            natural.sha256_bytes(natural.canonical_bytes(core)),
        )

    def test_statement_identity_and_events_are_preserved(self) -> None:
        claim = self.graph.claim("R0021")
        self.assertIn(claim["status"], {
            "unregistered", "seed", "formalizing", "proving",
            "complete", "superseded", "blocked",
        })
        self.assertEqual(
            claim["statement_hash"],
            "0a384fe7d322986c2066b43fa4f195c352bf2ec9f71a9186106f4226818c2f80",
        )
        self.assertEqual(len(claim["events"]), claim["cycle"])
        self.assertIn("notes/CONSTRAINT_ALGEBRA.md", claim["artifacts"])

    def test_dependency_and_supersession_impact(self) -> None:
        r0005 = self.graph.impact("R0005")
        self.assertIn("R0006", r0005["direct_dependents"])
        r0004 = self.graph.impact("R0004")
        self.assertIn("R0020", r0004["superseded_by"])
        r0020 = self.graph.impact("R0020")
        self.assertEqual(r0020["supersedes"], ["R0004"])

    def test_known_dangling_artifacts_are_visible_not_silent(self) -> None:
        missing = {
            issue["detail"] for issue in self.graph.issues
            if issue["code"] == "missing-artifact"
        }
        self.assertIn(
            "collab/discovery/claims/R0009-chowla-ff-missing-structure.md",
            missing,
        )
        self.assertIn("data/exp46_out.txt", missing)

    def test_no_graph_errors_in_current_repository(self) -> None:
        errors = [issue for issue in self.graph.issues
                  if issue["severity"] == "error"]
        self.assertEqual(errors, [])

    def test_artifact_paths_cannot_escape_repository(self) -> None:
        parent = natural.file_record("../outside-secret")
        absolute = natural.file_record("/tmp/outside-secret")
        self.assertTrue(parent["unsafe"])
        self.assertTrue(absolute["unsafe"])
        self.assertFalse(parent["exists"])

    def test_zero_message_limit_means_zero(self) -> None:
        self.assertEqual(natural.latest_messages(0), [])
        with self.assertRaises(ValueError):
            natural.latest_messages(-1)

    def test_resume_selects_latest_journal_and_messages(self) -> None:
        value = natural.resume(self.graph, "codex")
        self.assertIsNotNone(value["journal_head"])
        self.assertEqual(value["journal_head"]["path"], "collab/journals/codex.md")
        self.assertTrue(value["journal_head"]["heading"])
        self.assertGreaterEqual(len(value["latest_messages"]), 1)
        current_branch = subprocess.run(
            ["git", "branch", "--show-current"], cwd=ROOT, check=True,
            text=True, stdout=subprocess.PIPE,
        ).stdout.strip()
        self.assertEqual(value["git"]["branch"], current_branch)

    def test_snapshot_cli_round_trip(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "snapshot.json"
            completed = subprocess.run(
                [sys.executable, str(CODE / "natural.py"), "snapshot",
                 "--output", str(output)],
                cwd=ROOT, check=True, text=True, stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            snapshot = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(snapshot["schema_version"], natural.SCHEMA_VERSION)
            self.assertIn(snapshot["graph_sha256"], completed.stdout)

    def test_unknown_claim_fails_closed(self) -> None:
        completed = subprocess.run(
            [sys.executable, str(CODE / "natural.py"), "show", "R9999"],
            cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        )
        self.assertEqual(completed.returncode, 2)
        self.assertIn("unknown claim", completed.stderr)


if __name__ == "__main__":
    unittest.main()

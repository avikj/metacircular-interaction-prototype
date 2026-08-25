#!/usr/bin/env python3
import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import launch_workers as launcher


class LauncherTests(unittest.TestCase):
    def test_capabilities_have_both_providers(self):
        self.assertEqual(set(launcher.capability_report()), {"codex", "claude"})

    def test_example_tasks_validate(self):
        tasks = launcher.load_tasks(launcher.HERE / "tasks.example.jsonl")
        self.assertEqual([task["provider"] for task in tasks], ["codex", "claude"])

    def test_duplicate_names_fail(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "tasks.jsonl"
            item = {"name": "same", "provider": "codex", "task": "x", "context": []}
            path.write_text(json.dumps(item) + "\n" + json.dumps(item) + "\n")
            with self.assertRaisesRegex(ValueError, "duplicate"):
                launcher.load_tasks(path)

    def test_codex_thread_id_capture(self):
        stream = '{"type":"thread.started","thread_id":"abc-123"}\n'
        self.assertEqual(launcher.codex_session(stream), "abc-123")

    def test_stable_worktree_name(self):
        self.assertEqual(launcher.worker_worktree("mind").name, "mind")

    def test_pulse_contains_exact_envelope_without_fixed_latest_theory(self):
        prompt = launcher.render_pulse({"name": "mind"}, 7, {"new_messages": [{"path": "m", "body": "{a,b}->c"}]})
        self.assertIn('"path": "m"', prompt)
        self.assertNotIn("complementarity", prompt.lower())

    def test_cursor_round_trip_is_per_worker(self):
        with tempfile.TemporaryDirectory() as directory:
            with mock.patch.object(launcher, "CURSORS", Path(directory)):
                value = {"head": "abc", "messages": {"m": "hash"}, "source_index": 2,
                         "response_hash": "response"}
                launcher.write_cursor("mind", value)
                self.assertEqual(launcher.read_cursor("mind"), value)

    def test_field_envelope_drains_oldest_backlog_without_skips(self):
        with tempfile.TemporaryDirectory() as directory:
            repo = Path(directory); (repo / "collab/messages").mkdir(parents=True)
            subprocess = __import__("subprocess")
            subprocess.run(["git", "init", "-q"], cwd=repo, check=True)
            subprocess.run(["git", "config", "user.email", "test@example.com"], cwd=repo, check=True)
            subprocess.run(["git", "config", "user.name", "Test"], cwd=repo, check=True)
            (repo / "seed").write_text("x")
            subprocess.run(["git", "add", "seed"], cwd=repo, check=True)
            subprocess.run(["git", "commit", "-qm", "seed"], cwd=repo, check=True)
            for number in range(5):
                (repo / f"collab/messages/{number:02d}.md").write_text(str(number))
            cursor = {"head": None, "messages": {}, "source_index": 0, "response_hash": None}
            delivered = []
            with mock.patch.object(launcher, "REPO", repo), mock.patch.object(launcher, "SESSIONS", repo / "sessions"):
                for _ in range(3):
                    envelope, cursor = launcher.field_envelope({"name": "mind"}, cursor, {}, limit=2)
                    delivered.extend(item["path"] for item in envelope["new_messages"])
            self.assertEqual(delivered, [f"collab/messages/{n:02d}.md" for n in range(5)])
            self.assertEqual(envelope["undelivered_message_count"], 0)

    def test_backoff_cap_is_finite(self):
        self.assertGreaterEqual(launcher.FAILURE_BACKOFF_CAP, 1.0)
        self.assertLessEqual(launcher.FAILURE_BACKOFF_CAP, 3600.0)

    def test_persistent_tasks_have_existing_memory_anchors(self):
        index = launcher.persistent_task_index()
        self.assertTrue(index)
        for task in index.values():
            self.assertTrue((launcher.REPO / str(task["journal"])).is_file())

    def test_live_context_joins_pointers_without_summary(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); sessions = root / "sessions"; outbox = root / "messages"
            sessions.mkdir(); outbox.mkdir()
            (sessions / "mind.json").write_text(json.dumps({
                "name": "mind", "provider": "codex", "session_id": "s", "worktree": "/w"
            }))
            task = {"name": "mind", "provider": "codex", "task": "continue", "journal": "j.md"}
            with mock.patch.object(launcher, "SESSIONS", sessions), \
                 mock.patch.object(launcher, "OUTBOX", outbox), \
                 mock.patch.object(launcher, "persistent_task_index", return_value={"mind": task}), \
                 mock.patch.object(launcher, "session_file", side_effect=lambda name: sessions / f"{name}.json"), \
                 mock.patch.object(launcher, "cursor_file", side_effect=lambda name: root / f"{name}.cursor"):
                context = launcher.live_context()
            self.assertEqual(context["minds"][0]["objective"], "continue")
            self.assertEqual(context["minds"][0]["journal"], "j.md")
            self.assertNotIn("summary", context["minds"][0])


if __name__ == "__main__":
    unittest.main()

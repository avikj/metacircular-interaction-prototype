#!/usr/bin/env python3
import json
import tempfile
import unittest
from pathlib import Path

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

    def test_every_custom_pulse_requires_reciprocal_return(self):
        pulse = launcher.render_pulse({"pulse": "specialized work"}, 7)
        self.assertIn("cultivate-collaboratory-mind", pulse)
        self.assertIn("material return", pulse)
        self.assertIn("specialized work", pulse)


if __name__ == "__main__":
    unittest.main()

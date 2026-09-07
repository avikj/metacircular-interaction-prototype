import subprocess
import tempfile
import unittest
from pathlib import Path

from machinery.collab_sync import SyncError, append_message, heartbeat, sync


def run(cwd, *args):
    return subprocess.run(args, cwd=cwd, check=True, text=True, capture_output=True)


class CollaborationSyncTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        base = Path(self.tmp.name)
        self.remote = base / "remote.git"
        run(base, "git", "init", "--bare", str(self.remote))
        self.seed = base / "seed"
        run(base, "git", "clone", str(self.remote), str(self.seed))
        run(self.seed, "git", "config", "user.email", "test@example.invalid")
        run(self.seed, "git", "config", "user.name", "Test")
        (self.seed / "shared.txt").write_text("zero\n")
        run(self.seed, "git", "add", "shared.txt")
        run(self.seed, "git", "commit", "-m", "seed")
        run(self.seed, "git", "branch", "-M", "work")
        run(self.seed, "git", "push", "-u", "origin", "work")
        self.a, self.b = base / "a", base / "b"
        for path in (self.a, self.b):
            run(base, "git", "clone", "-b", "work", str(self.remote), str(path))
            run(path, "git", "config", "user.email", "test@example.invalid")
            run(path, "git", "config", "user.name", "Test")

    def tearDown(self):
        self.tmp.cleanup()

    def test_append_only_unique_messages(self):
        one = append_message(self.a, "alice", "bob", "info", "s", "one")
        two = append_message(self.a, "alice", "bob", "info", "s", "two")
        self.assertNotEqual(one, two)
        self.assertIn("one", (self.a / one).read_text())

    def test_heartbeat_preserves_session_and_journal_pointer(self):
        path = heartbeat(self.a, "alice", "session-41", "collab/journals/alice.md", "working")
        text = (self.a / path).read_text()
        self.assertIn("session-41", text)
        self.assertIn("collab/journals/alice.md", text)

    def test_dirty_tree_fetches_but_does_not_rebase(self):
        before = run(self.a, "git", "rev-parse", "HEAD").stdout.strip()
        (self.a / "local.txt").write_text("preserve me")
        with self.assertRaises(SyncError):
            sync(self.a, "alice", "origin", "work")
        self.assertEqual(before, run(self.a, "git", "rev-parse", "HEAD").stdout.strip())
        self.assertEqual("preserve me", (self.a / "local.txt").read_text())
        self.assertTrue(list((self.a / "collab/mailboxes/alice").glob("*.md")))

    def test_clean_rebase_and_conflict_abort(self):
        (self.a / "a.txt").write_text("a\n")
        run(self.a, "git", "add", "a.txt"); run(self.a, "git", "commit", "-m", "a")
        (self.b / "b.txt").write_text("b\n")
        run(self.b, "git", "add", "b.txt"); run(self.b, "git", "commit", "-m", "b")
        run(self.b, "git", "push", "origin", "work")
        sync(self.a, "alice", "origin", "work")
        self.assertTrue((self.a / "a.txt").exists() and (self.a / "b.txt").exists())

        # Create conflicting commits from the now-synchronized A and a fresh B.
        run(self.b, "git", "pull", "--rebase", "origin", "work")
        (self.a / "shared.txt").write_text("from a\n")
        run(self.a, "git", "add", "shared.txt"); run(self.a, "git", "commit", "-m", "A conflict")
        (self.b / "shared.txt").write_text("from b\n")
        run(self.b, "git", "add", "shared.txt"); run(self.b, "git", "commit", "-m", "B conflict")
        run(self.b, "git", "push", "origin", "work")
        a_head = run(self.a, "git", "rev-parse", "HEAD").stdout.strip()
        with self.assertRaises(SyncError):
            sync(self.a, "alice", "origin", "work")
        self.assertEqual(a_head, run(self.a, "git", "rev-parse", "HEAD").stdout.strip())
        self.assertEqual("from a\n", (self.a / "shared.txt").read_text())
        self.assertFalse((self.a / ".git/rebase-merge").exists())


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3
"""Exercise a real conflicting Bend merge in a fresh native UCM codebase."""

import os
import pty
import re
import signal
import struct
import sys
import tempfile
from pathlib import Path

import fcntl
import termios

import live_ucm_smoke as ucm


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_divergent_merge_smoke.py UCM_BINARY HVM4_BINARY")
    binary, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    original = ucm.FIXTURE.read_text()
    old_main = "def main() -> Bool:\n  loopAction(i0, i1, True)\n"
    assert original.endswith(old_main), "fixture main changed; review this regression"
    ucm.PROMPT = re.compile(r"[^/\s]+/[^>]+>\s*$")

    with tempfile.TemporaryDirectory(prefix="bend-divergent-merge-") as folder:
        temp = Path(folder)
        true_file = temp / "feature.bend"
        false_file = temp / "main.bend"
        true_file.write_text(original.replace(old_main, "def main() -> Bool:\n  True\n"))
        false_file.write_text(original.replace(old_main, "def main() -> Bool:\n  False\n"))

        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ucm.ROOT)
            env = os.environ.copy()
            env["HVM4"] = str(hvm)
            env["COLUMNS"] = "120"
            os.execve(str(binary), [str(binary), "--codebase-create", str(temp / "codebase"), "--no-file-watch"], env)
        try:
            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            ucm.until_prompt(fd)
            assert "checked and stored" in ucm.send(fd, f"load {ucm.FIXTURE}")
            assert "0 #4992" in ucm.send(fd, "bend.run main")
            assert "created the feature branch" in ucm.send(fd, "branch feature")
            assert "checked and stored" in ucm.send(fd, f"load {true_file}")
            assert "1 #0" in ucm.send(fd, "bend.run main")
            ucm.send(fd, "switch /main")
            assert "checked and stored" in ucm.send(fd, f"load {false_file}")
            assert "0 #0" in ucm.send(fd, "bend.run main")

            merged = ucm.send(fd, "merge /feature")
            assert "merged branch histories" in merged and "Encountered exception" not in merged
            listing = ucm.send(fd, "ls")
            assert len(re.findall(r"^\s*\d+\. main\s+\(Bool\)", listing, re.MULTILINE)) == 2
            assert "ambiguous term name" in ucm.send(fd, "bend.run main")
            history = ucm.send(fd, "history")
            assert "starts with a merge" in history
            ucm.send(fd, "switch /feature")
            assert "1 #0" in ucm.send(fd, "bend.run main")
            ucm.send(fd, "switch /main")
            assert "ambiguous term name" in ucm.send(fd, "bend.run main")
            named = ucm.send(fd, "names main")
            hashes = re.findall(r"main#([a-z0-9]+)", named)
            assert len(set(hashes)) == 2, named
            removed = ucm.send(fd, f"delete.term.force main#{hashes[0]}")
            assert "I deleted these terms" in removed
            assert "1 #0" in ucm.send(fd, "bend.run main")
            resolved_history = ucm.send(fd, "history")
            assert "Deletes:" in resolved_history and "starts with a merge" in resolved_history

            assert "created the project target" in ucm.send(fd, "project.create-empty target")
            assert "Done." in ucm.send(fd, "fork scratch/main: target/main:copied")
            assert "copied." in ucm.send(fd, "ls")
            assert "1 #0" in ucm.send(fd, "bend.run copied.main")
            print("PASS: divergent Bend merge, hash-selected conflict resolution, two-parent history, cross-project fork, and HVM execution")
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

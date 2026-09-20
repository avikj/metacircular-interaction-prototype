#!/usr/bin/env python3
"""Transfer a Bend project branch between two native UCM codebases."""

import fcntl
import os
import pty
import re
import signal
import sqlite3
import struct
import sys
import tempfile
import termios
from pathlib import Path

from live_ucm_smoke import FIXTURE, ROOT, send, until_prompt


def run_ucm(ucm, hvm, codebase, commands):
    pid, fd = pty.fork()
    if pid == 0:
        os.chdir(ROOT)
        env = os.environ.copy()
        env.update(HVM4=str(hvm), TERM="xterm-256color", COLUMNS="120")
        os.execve(str(ucm), [str(ucm), "--codebase-create", str(codebase), "--no-file-watch"], env)
    try:
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
        until_prompt(fd)
        return [send(fd, command) for command in commands]
    finally:
        os.kill(pid, signal.SIGTERM)
        os.waitpid(pid, 0)
        os.close(fd)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_sync_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with tempfile.TemporaryDirectory(prefix="bend-ucm-sync-") as temp:
        temp = Path(temp)
        source, dest, archive = temp / "source", temp / "dest", temp / "bend.usync"
        source_results = run_ucm(ucm, hvm, source, [
            f"load {FIXTURE}", "bend.run main", "history",
            "move.term main renamedMain", "history", f"sync.to-file {archive}",
        ])
        assert "0 #4992" in source_results[1], source_results[1]
        assert "Done." in source_results[3], source_results[3]
        assert archive.is_file() and archive.stat().st_size > 0, source_results[5]
        dest_results = run_ucm(ucm, hvm, dest, [
            f"sync.from-file {archive} /main", "bend.run renamedMain", "ls", "history",
            "undo", "bend.run main",
        ])
        assert "0 #4992" in dest_results[1] and "4992 interactions" in dest_results[1], dest_results[1]
        assert "renamedMain" in dest_results[2] and "Segment" in dest_results[2], dest_results[2]
        source_history = re.findall(r"[□⊙]\s+\d+\.\s+(#[a-z0-9]+)", source_results[4])
        dest_history = re.findall(r"[□⊙]\s+\d+\.\s+(#[a-z0-9]+)", dest_results[3])
        assert len(source_history) == 2 and source_history == dest_history, (source_results[4], dest_results[3])
        assert "0 #4992" in dest_results[5], dest_results[5]
        with sqlite3.connect(dest / ".unison/v2/unison.sqlite3") as db:
            bend_count = db.execute("SELECT count(*) FROM object WHERE type_id=4").fetchone()[0]
        assert bend_count == 22, bend_count
        print(f"PASS: native UCM sync file imported causal history {dest_history}, {bend_count} Bend objects, restored prior name with undo, and ran full HVM ({archive.stat().st_size} bytes)")


if __name__ == "__main__":
    main()

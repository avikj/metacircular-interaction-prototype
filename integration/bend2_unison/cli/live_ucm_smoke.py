#!/usr/bin/env python3
"""Exercise native Bend2 loading, execution, and branch updates in a fresh UCM."""

import os
import pty
import re
import select
import signal
import struct
import sys
import tempfile
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
FIXTURE = ROOT / "collab/bend2-cubical/path_transport.bend"
PROMPT = re.compile(r"scratch/(?:main|bendFeature)>\s*$")
ANSI = re.compile(r"\x1b(?:\[[0-?]*[ -/]*[@-~]|[=>])")


def clean(raw):
    return ANSI.sub("", raw.decode("utf-8", "replace")).replace("\b", "")


def until_prompt(fd, timeout=120):
    deadline = time.monotonic() + timeout
    chunks = []
    while time.monotonic() < deadline:
        readable, _, _ = select.select([fd], [], [], min(1, deadline - time.monotonic()))
        if not readable:
            continue
        try:
            chunk = os.read(fd, 65536)
        except OSError as exc:
            raise RuntimeError(f"UCM closed its PTY: {exc}; output: {clean(b''.join(chunks))}") from exc
        if not chunk:
            raise RuntimeError(f"UCM exited before prompt: {clean(b''.join(chunks))}")
        chunks.append(chunk)
        output = clean(b"".join(chunks))
        if PROMPT.search(output):
            return output
    raise TimeoutError(f"UCM prompt timeout; output: {clean(b''.join(chunks))}")


def send(fd, command):
    os.write(fd, (command + "\n").encode())
    result = until_prompt(fd)
    print(f"$ {command}\n{result}", flush=True)
    return result


def watch_smoke(ucm, hvm):
    import fcntl
    import termios

    with tempfile.TemporaryDirectory(prefix="bend-ucm-watch-") as temp:
        temp = Path(temp)
        watched = temp / "path_transport.bend"
        watched.write_text(FIXTURE.read_text())
        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(temp)
            env = os.environ.copy()
            env["HVM4"] = str(hvm)
            env["TERM"] = "xterm-256color"
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(temp / "codebase")], env)
        try:
            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            until_prompt(fd)
            send(fd, "load path_transport.bend")
            assert "0 #4992" in send(fd, "bend.run main")
            source = watched.read_text()
            old_main = "def main() -> Bool:\n  loopAction(i0, i1, True)\n"
            assert source.endswith(old_main)
            watched.write_text(source.replace(old_main, "def main() -> Bool:\n  True\n"))
            changed = until_prompt(fd, timeout=30)
            print(f"$ watched file change\n{changed}", flush=True)
            assert "checked and stored 23 declarations" in changed
            assert "1 #0" in send(fd, "bend.run main")
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_ucm_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with tempfile.TemporaryDirectory(prefix="bend-ucm-live-") as temp:
        temp = Path(temp)
        original = FIXTURE.read_text()
        old_main = "def main() -> Bool:\n  loopAction(i0, i1, True)\n"
        assert original.endswith(old_main), "fixture main changed; review this smoke"
        updated = temp / "path_transport_updated.bend"
        updated.write_text(original.replace(old_main, "def main() -> Bool:\n  True\n"))

        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ROOT)
            env = os.environ.copy()
            env["HVM4"] = str(hvm)
            env["COLUMNS"] = "120"
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(temp / "codebase"), "--no-file-watch"], env)
        try:
            import fcntl
            import termios

            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            print(until_prompt(fd), flush=True)
            loaded = send(fd, f"load {FIXTURE}")
            assert "checked and stored 23 declarations (22 addressed names)" in loaded
            listing = send(fd, "ls")
            assert re.search(r"\bmain\s+\(Bool\)", listing)
            found = send(fd, "find main")
            assert "main : Bool" in found and "missing or corrupted" not in found
            signature = send(fd, "signature main")
            assert re.search(r"main\s+: Bool", signature)
            dependent_listing = send(fd, "ls")
            assert "carryEdge" in dependent_listing and "Segment" in dependent_listing, dependent_listing
            assert "BendComponent_" not in dependent_listing and "BendCtor_" not in dependent_listing, dependent_listing
            dependent_found = send(fd, "find carryEdge")
            assert "PathP(" in dependent_found and "Segment,@left{},@right{}" in dependent_found, dependent_found
            assert "BendComponent_" not in dependent_found and "BendCtor_" not in dependent_found, dependent_found
            dependent_signature = send(fd, "signature carryEdge")
            assert "PathP(" in dependent_signature and "Segment,@left{},@right{}" in dependent_signature, dependent_signature
            assert "BendComponent_" not in dependent_signature and "BendCtor_" not in dependent_signature, dependent_signature
            by_name = send(fd, "bend.run main")
            assert "0 #4992" in by_name and "4992 interactions" in by_name
            by_file = send(fd, f"bend.run {FIXTURE}")
            assert "0 #4992" in by_file and "4992 interactions" in by_file
            renamed = send(fd, "move.term main renamedMain")
            assert "Done." in renamed
            renamed_run = send(fd, "bend.run renamedMain")
            assert "0 #4992" in renamed_run
            missing_main = send(fd, "bend.run main")
            assert "no term named main" in missing_main
            send(fd, "undo")
            restored_main = send(fd, "bend.run main")
            assert "0 #4992" in restored_main
            updated_load = send(fd, f"load {updated}")
            assert "checked and stored 23 declarations" in updated_load
            updated_run = send(fd, "bend.run main")
            assert "1 #0" in updated_run and "0 interactions" in updated_run
            history = send(fd, "history")
            assert "Adds / updates:" in history and "main" in history
            send(fd, "undo")
            prior_run = send(fd, "bend.run main")
            assert "0 #4992" in prior_run and "4992 interactions" in prior_run
            forked = send(fd, "branch bendFeature")
            assert "created the" in forked and "bendFeature" in forked
            send(fd, f"load {updated}")
            feature_run = send(fd, "bend.run main")
            assert "1 #0" in feature_run
            send(fd, "switch /main")
            before_merge = send(fd, "bend.run main")
            assert "0 #4992" in before_merge
            merged = send(fd, "merge /bendFeature")
            assert "fast-forward merged" in merged
            after_merge = send(fd, "bend.run main")
            assert "1 #0" in after_merge
            print("PASS: Bend types in ls/find/signature, HVM execution, rename, replacement, undo, branch fork, and merge")
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)
    watch_smoke(ucm, hvm)
    print("PASS: watched Bend file update and stored-name HVM execution")


if __name__ == "__main__":
    main()

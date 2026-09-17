#!/usr/bin/env python3
"""Exercise full-net cache hits, invalidation, and corruption recovery in UCM."""

import os
import pty
import signal
import struct
import sys
import tempfile
import hashlib
from pathlib import Path

from live_ucm_smoke import FIXTURE, ROOT, send, until_prompt


def artifacts(cache):
    return sorted((cache / "bend2-unison/hvm4-full").glob("*/*.hvm4"))


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_artifact_cache_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with tempfile.TemporaryDirectory(prefix="bend-ucm-artifact-") as temp_name:
        temp = Path(temp_name)
        cache = temp / "cache"
        source = FIXTURE.read_text()
        old_main = "def main() -> Bool:\n  loopAction(i0, i1, True)\n"
        assert source.endswith(old_main)
        updated = temp / "updated.bend"
        updated.write_text(source.replace(old_main, "def main() -> Bool:\n  True\n"))

        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ROOT)
            env = os.environ.copy()
            env["HVM4"] = str(hvm)
            env["XDG_CACHE_HOME"] = str(cache)
            env["COLUMNS"] = "120"
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(temp / "codebase"), "--no-file-watch"], env)
        try:
            import fcntl
            import termios

            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            until_prompt(fd)
            assert "checked and stored" in send(fd, f"load {FIXTURE}")
            first = send(fd, "bend.run main")
            assert "0 #4992" in first and "4992 interactions" in first
            files = artifacts(cache)
            assert len(files) == 1, files
            original = files[0]
            original_bytes = original.read_bytes()
            original_mtime = original.stat().st_mtime_ns

            second = send(fd, "bend.run main")
            assert "0 #4992" in second and "4992 interactions" in second
            assert artifacts(cache) == files
            assert original.stat().st_mtime_ns == original_mtime, "cache hit rewrote the emitted net"

            original.write_bytes(b"corrupt HVM net\n")
            recovered = send(fd, "bend.run main")
            assert "0 #4992" in recovered and "4992 interactions" in recovered
            repaired_files = artifacts(cache)
            assert len(repaired_files) == 1, repaired_files
            repaired = repaired_files[0]
            assert repaired.read_bytes() != b"corrupt HVM net\n", "corrupt artifact was reused"
            repaired_bytes = repaired.read_bytes()
            if repaired_bytes != original_bytes:
                print("emitter produced byte-distinct full nets for the same checked closure:",
                      hashlib.sha256(original_bytes).hexdigest(),
                      hashlib.sha256(repaired_bytes).hexdigest(), flush=True)
                for before, after in zip(original_bytes.splitlines(), repaired_bytes.splitlines()):
                    if before != after:
                        print("first differing emitted lines:", before[:160], after[:160], flush=True)
                        break
            repaired_mtime = repaired.stat().st_mtime_ns
            after_repair = send(fd, "bend.run main")
            assert "0 #4992" in after_repair and "4992 interactions" in after_repair
            assert artifacts(cache) == repaired_files
            assert repaired.stat().st_mtime_ns == repaired_mtime

            assert "checked and stored" in send(fd, f"load {updated}")
            changed = send(fd, "bend.run main")
            assert "1 #0" in changed and "0 interactions" in changed
            changed_files = artifacts(cache)
            assert len(changed_files) == 2 and repaired in changed_files, changed_files
            print("PASS: cache hit, full HVM reduction, corruption recovery, and source-change invalidation", flush=True)
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

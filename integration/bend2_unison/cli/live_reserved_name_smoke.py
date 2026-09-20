#!/usr/bin/env python3
"""A Bend identifier that is a Unison keyword retains its spelling in UCM."""

import os
import pty
import signal
import sys
import tempfile
from pathlib import Path

from live_ucm_smoke import ROOT, send, until_prompt


FIXTURE = ROOT / "integration/bend2_unison/storage/fixtures/SemanticNat.bend"


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_reserved_name_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with tempfile.TemporaryDirectory(prefix="bend-ucm-reserved-") as temp:
        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ROOT)
            env = os.environ.copy()
            env["HVM4"] = str(hvm)
            env["COLUMNS"] = "120"
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(Path(temp) / "codebase"), "--no-file-watch"], env)
        try:
            import fcntl
            import struct
            import termios

            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            until_prompt(fd)
            loaded = send(fd, f"load {FIXTURE}")
            assert "Bend2 name cannot enter UCM branch" not in loaded, loaded
            assert "checked and stored" in loaded, loaded
            listing = send(fd, "ls")
            assert "alias" in listing and "direct" in listing, listing
            found = send(fd, "find `alias`")
            assert "`alias` : Nat" in found, found
            signature = send(fd, "signature `alias`")
            assert "alias" in signature and "Nat" in signature, signature
            output = send(fd, "bend.run alias")
            numeral = "#Suc{#Suc{#Zer{}}} #0"
            assert numeral in output and "HVM4:" not in output, output
            renamed = send(fd, "move.term `alias` renamedAlias")
            assert "Done." in renamed, renamed
            assert numeral in send(fd, "bend.run renamedAlias")
            assert "no term named alias" in send(fd, "bend.run alias")
            send(fd, "undo")
            assert numeral in send(fd, "bend.run alias")
            print("PASS: reserved Bend name stored, run, renamed, undone", flush=True)
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

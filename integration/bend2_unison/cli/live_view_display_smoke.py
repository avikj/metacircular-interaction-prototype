#!/usr/bin/env python3
"""Check UCM source navigation and display on native Bend term/type refs."""

import os
import pty
import signal
import struct
import sys
import tempfile
from pathlib import Path

from live_ucm_smoke import FIXTURE, ROOT, send, until_prompt


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_view_display_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with tempfile.TemporaryDirectory(prefix="bend-ucm-view-") as temp_name:
        temp = Path(temp_name)
        output = temp / "result.txt"
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
            until_prompt(fd)
            assert "checked and stored" in send(fd, f"load {FIXTURE}")
            term = send(fd, "view main")
            assert "def main() -> Bool:" in term and "loopAction(i0, i1, True)" in term
            assert "Encountered exception" not in term
            hit = send(fd, "view Segment")
            assert "type Segment:" in hit and "path @edge:" in hit
            assert "Encountered exception" not in hit
            dependent = send(fd, "view carryEdge")
            assert "def carryEdge(" in dependent and "coe(lambda k." in dependent
            rendered = send(fd, "display main")
            assert "0 #4992" in rendered and "4992 interactions" in rendered
            assert "Unknown term reference" not in rendered
            function = send(fd, "display carryEdge")
            assert "display needs an applied value" in function and "HvmFailure" not in function
            saved = send(fd, f"display.to {output} main")
            assert "wrote HVM4 result" in saved and "0 #4992" in output.read_text(), repr(output.read_text())
            assert "Done." in send(fd, "move.term main renamedMain")
            renamed = send(fd, "view renamedMain")
            assert "def main() -> Bool:" in renamed and "loopAction(i0, i1, True)" in renamed
            docs = send(fd, "docs renamedMain")
            assert "renamedMain.doc" in docs and "Encountered exception" not in docs
            print("PASS: native Bend view term/HIT/dependent source, HVM display/to, rename navigation, docs lookup", flush=True)
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

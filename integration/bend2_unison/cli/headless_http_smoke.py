#!/usr/bin/env python3
"""Check native Bend HTTP in a UCM process without a terminal."""

import hashlib
import json
import os
import socket
import sqlite3
import subprocess
import sys
import tempfile
import time
import urllib.parse
import urllib.request
from pathlib import Path

from live_ucm_smoke import FIXTURE, ROOT


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: headless_http_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        port = sock.getsockname()[1]
    with tempfile.TemporaryDirectory(prefix="bend-ucm-headless-") as temp:
        temp = Path(temp)
        token = "codebase"
        codebase = temp / "codebase"
        db_path = codebase / ".unison/v2/unison.sqlite3"
        with (temp / "ucm.log").open("wb") as log:
            env = os.environ.copy()
            env.update(HVM4=str(hvm), TERM="dumb")
            process = subprocess.Popen(
                [str(ucm), "--codebase-create", str(codebase), "--token", token,
                 "--port", str(port), "--no-file-watch"], cwd=ROOT, env=env,
                stdin=subprocess.PIPE, stdout=log, stderr=subprocess.STDOUT,
            )
            try:
                assert process.stdin is not None
                process.stdin.write((f"load {FIXTURE}\n").encode())
                process.stdin.flush()
                deadline = time.monotonic() + 25
                row = None
                while time.monotonic() < deadline and process.poll() is None:
                    if db_path.exists():
                        try:
                            with sqlite3.connect(db_path) as db:
                                row = db.execute("""SELECT p.component_index,o.bytes FROM bend_presentation p
                                    JOIN object o ON o.id=p.component_object_id WHERE p.authored_name='main'""").fetchone()
                        except sqlite3.OperationalError:
                            pass
                    if row:
                        break
                    time.sleep(0.1)
                assert row, (process.poll(), (temp / "ucm.log").read_text(errors="replace"))
                member, component = row
                query = urllib.parse.urlencode(dict(digest=hashlib.sha3_512(component).hexdigest(), member=member, root="body"))
                url = f"http://127.0.0.1:{port}/{token}/api/bend/subterm?{query}"
                with urllib.request.urlopen(url, timeout=10) as response:
                    body = response.read()
                    assert response.status == 200 and b'"projection"' in body, body
                lookup = (f"http://127.0.0.1:{port}/{token}/api/projects/scratch/branches/main/"
                          "bend/member-link?name=main&kind=term")
                with urllib.request.urlopen(lookup, timeout=10) as response:
                    link = json.load(response)
                    assert response.status == 200
                assert link == f"/codebase/ui/bend/component/{hashlib.sha3_512(component).hexdigest()}/{member}", link
                with urllib.request.urlopen(f"http://127.0.0.1:{port}{link}", timeout=10) as response:
                    assert response.status == 200 and b"Bend component" in response.read()
                type_lookup = (f"http://127.0.0.1:{port}/{token}/api/projects/scratch/branches/main/"
                               "bend/member-link?name=Segment&kind=type")
                with urllib.request.urlopen(type_lookup, timeout=10) as response:
                    type_link = json.load(response)
                    assert response.status == 200
                assert type_link.startswith("/codebase/ui/bend/component/") and type_link.endswith("?root=hit"), type_link
                print("PASS: headless UCM loaded Bend and served local HTTP subterm, branch member link, and browser page")
            finally:
                process.terminate()
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()


if __name__ == "__main__":
    main()

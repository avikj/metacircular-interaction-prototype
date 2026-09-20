#!/usr/bin/env python3
"""Check imported Bend source provenance through live UCM, SQLite, HTTP, and LSP."""

import fcntl
import hashlib
import json
import os
import pty
import signal
import socket
import sqlite3
import struct
import sys
import tempfile
import termios
import urllib.parse
import urllib.request
from pathlib import Path

from live_ucm_smoke import ROOT, send, until_prompt

sys.path.insert(0, str(ROOT / "integration/bend2_unison/interface"))
from live_lsp_smoke import LspClient  # noqa: E402


FIXTURE = ROOT / "integration/bend2_unison/admission/fixtures/Imports/Main.bend"


def ports():
    sockets = [socket.socket(), socket.socket()]
    try:
        for sock in sockets:
            sock.bind(("127.0.0.1", 0))
        return [sock.getsockname()[1] for sock in sockets]
    finally:
        for sock in sockets:
            sock.close()


def check_lsp(port, main, library):
    client = LspClient(port)
    try:
        client.send({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {
            "processId": os.getpid(), "clientInfo": {"name": "bend-import-smoke", "version": "1"},
            "locale": "en", "rootPath": None, "rootUri": None,
            "capabilities": {}, "trace": "off", "workspaceFolders": None,
        }})
        while True:
            response = client.receive()
            if response.get("id") == 1:
                assert "result" in response, response
                break
        client.send({"jsonrpc": "2.0", "method": "initialized", "params": {}})
        client.send({"jsonrpc": "2.0", "method": "textDocument/didOpen", "params": {
            "textDocument": {"uri": main.as_uri(), "languageId": "bend", "version": 1, "text": main.read_text()},
        }})
        client.send({"jsonrpc": "2.0", "id": 2, "method": "textDocument/definition", "params": {
            "textDocument": {"uri": main.as_uri()}, "position": {"line": 2, "character": 3},
        }})
        found = {}
        for _ in range(40):
            message = client.receive()
            if message.get("method") == "textDocument/publishDiagnostics":
                found["diagnostics"] = message["params"]["diagnostics"]
            if message.get("id") == 2:
                found["definition"] = message.get("result")
            if "method" in message and "id" in message:
                client.send({"jsonrpc": "2.0", "id": message["id"], "result": None})
            if len(found) == 2:
                break
        assert found.get("diagnostics") == [], found
        locations = found.get("definition") or []
        assert any(loc.get("targetUri", loc.get("uri")) == library.as_uri() for loc in locations), found
        selection = locations[0]["targetSelectionRange"]
        assert selection["start"] == {"line": 1, "character": 4}, found
        assert selection["end"] == {"line": 1, "character": 7}, found
        print("LSP:", json.dumps(found, ensure_ascii=False), flush=True)
    finally:
        client.close()


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: live_import_smoke.py UCM_BINARY HVM4_BINARY")
    ucm, hvm = (Path(arg).resolve() for arg in sys.argv[1:])
    http_port, lsp_port = ports()
    token = "bend-import-smoke"
    main_file = FIXTURE.resolve()
    library = main_file.with_name("Library.bend")
    with tempfile.TemporaryDirectory(prefix="bend-ucm-import-") as temp:
        codebase = Path(temp) / "codebase"
        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ROOT)
            env = os.environ.copy()
            env.update(HVM4=str(hvm), TERM="xterm-256color", UNISON_LSP_PORT=str(lsp_port))
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(codebase),
                                 "--token", token, "--port", str(http_port), "--no-file-watch"], env)
        try:
            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 500, 0, 0))
            until_prompt(fd)
            loaded = send(fd, f"load {main_file}")
            assert "checked and stored 2 declarations (2 addressed names)" in loaded
            result = send(fd, "bend.run main")
            assert "#Suc{#Suc{#Zer{}}}" in result and "0 interactions" in result

            db = sqlite3.connect(codebase / ".unison/v2/unison.sqlite3")
            rows = db.execute("""SELECT p.authored_name,p.component_index,p.source_path,
                p.source_start_byte,p.source_end_byte,p.source_utf8,o.bytes
                FROM bend_presentation p JOIN object o ON o.id=p.component_object_id
                ORDER BY p.authored_name""").fetchall()
            assert [row[0] for row in rows] == ["main", "two"], rows
            for name, slot, path, start, end, source, component in rows:
                assert path == str(main_file if name == "main" else library)
                assert source == Path(path).read_bytes()
                assert ("def " + name + "(").encode() in source[start:end]
                digest = hashlib.sha3_512(component).hexdigest()
                query = urllib.parse.urlencode(dict(digest=digest, member=slot, root="body"))
                api = f"http://127.0.0.1:{http_port}/{token}/api/bend/subterm?{query}"
                with urllib.request.urlopen(api, timeout=10) as response:
                    root = json.load(response)
                    assert response.status == 200
                presentations = root["presentations"]
                assert len(presentations) == 1
                assert presentations[0]["sourcePath"] == path
                assert presentations[0]["sourceByteRange"] == [start, end]
                assert presentations[0]["error"] is None
                if name == "two":
                    with urllib.request.urlopen(api + "&path=0", timeout=10) as response:
                        nested = json.load(response)
                        assert response.status == 200
                    assert nested["projection"]["address"]["path"] == [0]
                    assert nested["projection"]["term"]["tag"] == "Suc"
                    assert nested["presentations"][0]["sourcePath"] == str(library)
                print(f"HTTP/SQLite: {name} {Path(path).name} bytes {start}:{end}", flush=True)
            check_lsp(lsp_port, main_file, library)
            print("PASS: imported Bend provenance through UCM, SQLite, HTTP root/nested term, and cross-file LSP")
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

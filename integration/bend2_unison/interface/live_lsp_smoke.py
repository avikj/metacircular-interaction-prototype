#!/usr/bin/env python3
"""Exercise Bend diagnostics, hover, and definition through a live UCM LSP socket."""

import argparse
import json
import os
import pathlib
import pty
import re
import select
import signal
import socket
import struct
import tempfile
import time
from urllib.parse import urlparse, unquote

ROOT = pathlib.Path(__file__).resolve().parents[3]
DEFAULT_FIXTURE = ROOT / "collab/bend2-interactive-cubical/path_transport.bend"
PROMPT = re.compile(r"scratch/main>\s*$")
ANSI = re.compile(r"\x1b(?:\[[0-?]*[ -/]*[@-~]|[=>])")


def read_until_prompt(fd, timeout=120):
    deadline = time.monotonic() + timeout
    chunks = []
    while time.monotonic() < deadline:
        ready, _, _ = select.select([fd], [], [], min(1, deadline - time.monotonic()))
        if ready:
            chunk = os.read(fd, 65536)
            if not chunk:
                raise RuntimeError("UCM closed before its prompt")
            chunks.append(chunk)
            output = ANSI.sub("", b"".join(chunks).decode("utf-8", "replace"))
            if PROMPT.search(output):
                return output
    raise TimeoutError("UCM prompt timeout: " + output)


def free_port():
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        return sock.getsockname()[1]


class LspClient:
    def __init__(self, port):
        deadline = time.monotonic() + 15
        while True:
            try:
                self.sock = socket.create_connection(("127.0.0.1", port), 1)
                break
            except OSError:
                if time.monotonic() >= deadline:
                    raise
                time.sleep(0.1)
        self.sock.settimeout(30)

    def send(self, message):
        body = json.dumps(message, separators=(",", ":")).encode()
        header = (
            b"Content-Length: "
            + str(len(body)).encode()
            + b"\r\nContent-Type: application/vscode-jsonrpc; charset=utf-8\r\n\r\n"
        )
        self.sock.sendall(header + body)

    def receive(self):
        header = b""
        while b"\r\n\r\n" not in header:
            part = self.sock.recv(1)
            if not part:
                raise EOFError("LSP connection closed")
            header += part
        size = int(
            [line.split(b":", 1)[1].strip() for line in header.split(b"\r\n")
             if line.lower().startswith(b"content-length:")][0]
        )
        body = b""
        while len(body) < size:
            part = self.sock.recv(size - len(body))
            if not part:
                raise EOFError("LSP response truncated")
            body += part
        return json.loads(body)

    def close(self):
        self.sock.close()


def exercise_lsp(port, fixture):
    source = fixture.read_text()
    uri = fixture.as_uri()
    lines = source.splitlines()
    call_line = max(i for i, row in enumerate(lines) if "loopAction(i0, i1, True)" in row)
    row = lines[call_line]
    call_char = row.index("loopAction") + 1
    interval_char = row.index("i0") + 1
    client = LspClient(port)
    try:
        client.send({
            "jsonrpc": "2.0", "id": 1, "method": "initialize",
            "params": {
                "processId": os.getpid(), "clientInfo": {"name": "bend-smoke", "version": "1"},
                "locale": "en", "rootPath": None, "rootUri": None,
                "capabilities": {}, "trace": "off", "workspaceFolders": None,
            },
        })
        while True:
            message = client.receive()
            if message.get("id") == 1:
                assert "result" in message, message
                break
        client.send({"jsonrpc": "2.0", "method": "initialized", "params": {}})
        client.send({
            "jsonrpc": "2.0", "method": "textDocument/didOpen",
            "params": {"textDocument": {
                "uri": uri, "languageId": "bend", "version": 1, "text": source,
            }},
        })
        client.send({
            "jsonrpc": "2.0", "id": 2, "method": "textDocument/hover",
            "params": {"textDocument": {"uri": uri},
                       "position": {"line": call_line, "character": interval_char}},
        })
        client.send({
            "jsonrpc": "2.0", "id": 3, "method": "textDocument/definition",
            "params": {"textDocument": {"uri": uri},
                       "position": {"line": call_line, "character": call_char}},
        })
        found = {}
        for _ in range(40):
            message = client.receive()
            if message.get("method") == "textDocument/publishDiagnostics":
                found["diagnostics"] = message["params"]["diagnostics"]
            if message.get("id") == 2:
                found["hover"] = message.get("result")
            if message.get("id") == 3:
                found["definition"] = message.get("result")
            if "method" in message and "id" in message:
                client.send({"jsonrpc": "2.0", "id": message["id"], "result": None})
            if len(found) == 3:
                break
        assert found.get("diagnostics") == [], found
        hover = found.get("hover")
        assert hover and "Interval" in hover["contents"]["value"], found
        assert "Component `" in hover["contents"]["value"], found
        links = found.get("definition")
        assert links and links[0]["targetUri"] == uri, found
        print("PASS: Bend LSP diagnostics=[], hover=Interval with native ref, definition="
              + str(links[0]["targetRange"]))
    finally:
        client.close()


def exercise_import_lsp(port, fixture, symbol="two"):
    source = fixture.read_text()
    uri = fixture.as_uri()
    target = (fixture.parent / "Library.bend").resolve().as_uri()
    line = next(i for i, row in enumerate(source.splitlines()) if symbol + "()" in row)
    character = source.splitlines()[line].index(symbol) + 1
    client = LspClient(port)
    try:
        client.send({
            "jsonrpc": "2.0", "id": 1, "method": "initialize",
            "params": {
                "processId": os.getpid(), "clientInfo": {"name": "bend-import-smoke", "version": "1"},
                "locale": "en", "rootPath": None, "rootUri": None,
                "capabilities": {}, "trace": "off", "workspaceFolders": None,
            },
        })
        while client.receive().get("id") != 1:
            pass
        client.send({"jsonrpc": "2.0", "method": "initialized", "params": {}})
        client.send({
            "jsonrpc": "2.0", "method": "textDocument/didOpen",
            "params": {"textDocument": {
                "uri": uri, "languageId": "bend", "version": 1, "text": source,
            }},
        })
        client.send({
            "jsonrpc": "2.0", "id": 2, "method": "textDocument/definition",
            "params": {"textDocument": {"uri": uri},
                       "position": {"line": line, "character": character}},
        })
        diagnostics = None
        definition = None
        for _ in range(40):
            message = client.receive()
            if message.get("method") == "textDocument/publishDiagnostics":
                diagnostics = message["params"]["diagnostics"]
            if message.get("id") == 2:
                definition = message.get("result")
            if "method" in message and "id" in message:
                client.send({"jsonrpc": "2.0", "id": message["id"], "result": None})
            if diagnostics is not None and definition is not None:
                break
        assert diagnostics == [], diagnostics
        assert definition and pathlib.Path(unquote(urlparse(definition[0]["targetUri"]).path)).resolve() == pathlib.Path(unquote(urlparse(target).path)).resolve(), definition
        assert definition[0]["targetRange"]["start"] == {"line": 1, "character": 4}, definition
        assert definition[0]["targetRange"]["end"] == {"line": 1, "character": 4 + len(symbol)}, definition
        print("PASS: Bend LSP imported definition targets Library.bend declaration name")
    finally:
        client.close()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("ucm", type=pathlib.Path)
    parser.add_argument("hvm4", type=pathlib.Path)
    parser.add_argument("--fixture", type=pathlib.Path, default=DEFAULT_FIXTURE)
    parser.add_argument("--imported", action="store_true")
    parser.add_argument("--imported-reserved", action="store_true")
    args = parser.parse_args()
    ucm = args.ucm.resolve()
    hvm4 = args.hvm4.resolve()
    fixture = args.fixture.resolve()
    port = free_port()
    with tempfile.TemporaryDirectory(prefix="bend-lsp-live-") as temp:
        if args.imported_reserved:
            import_dir = pathlib.Path(temp) / "reserved-import"
            import_dir.mkdir()
            (import_dir / "Library.bend").write_text("# reserved Unison name\ndef alias() -> Nat:\n  2n\n")
            fixture = import_dir / "Main.bend"
            fixture.write_text("import Library\ndef main() -> Nat:\n  alias()\n")
        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(ROOT)
            env = os.environ.copy()
            env["HVM4"] = str(hvm4)
            env["UNISON_LSP_PORT"] = str(port)
            env["COLUMNS"] = "120"
            os.execve(str(ucm), [str(ucm), "--codebase-create", str(pathlib.Path(temp) / "codebase"),
                                   "--no-file-watch"], env)
        try:
            import fcntl
            import termios
            fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 50, 120, 0, 0))
            read_until_prompt(fd)
            os.write(fd, ("load " + str(fixture) + "\n").encode())
            loaded = read_until_prompt(fd)
            assert "checked and stored" in loaded, loaded
            if args.imported_reserved:
                exercise_import_lsp(port, fixture, "alias")
            elif args.imported:
                exercise_import_lsp(port, fixture)
            else:
                exercise_lsp(port, fixture)
        finally:
            os.kill(pid, signal.SIGTERM)
            os.waitpid(pid, 0)
            os.close(fd)


if __name__ == "__main__":
    main()

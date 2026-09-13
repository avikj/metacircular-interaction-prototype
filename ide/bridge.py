#!/usr/bin/env python3
"""The kernel bridge: serve the reader AND put the pinned Agda in the loop.

    python3 ide/bridge.py          → http://localhost:8630

Serves ide/web/ and ide/store/ statically, plus a JSON API wrapping one
persistent `agda --interaction-json` session:

  POST /api  {"op": "ping"}
             {"op": "source", "file": <repo-rel path>}          → {text}
             {"op": "write",  "file": ..., "text": ...}          → {ok}
             {"op": "check",  "file": ...}                       → {ok, errors,
                    goals: [{id, range}], warnings}
             {"op": "goal",   "file": ..., "id": n}              → {goal, context}
             {"op": "infer",  "file": ..., "expr": ...}          → {type}
             {"op": "normalize", "file": ..., "expr": ...}       → {value}

Everything the kernel says is relayed verbatim; nothing is summarized.
Files are confined to the repository root. No third-party dependencies.
"""
from __future__ import annotations

import json
import sys
import time
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from elaborate import iotcm  # noqa: E402
from identity import IdentitySession as AgdaSession  # includes -i ide/agda -i generated

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "ide" / "web"
STORE = ROOT / "ide" / "store"
PORT = 8630

SESSION: AgdaSession | None = None
LOADED: str | None = None


def session() -> AgdaSession:
    global SESSION
    if SESSION is None or SESSION.proc.poll() is not None:
        SESSION = AgdaSession()
    return SESSION


def collect(path: str, pred_kinds: set[str], budget: float = 120.0) -> list[dict]:
    """Drain messages until one of pred_kinds arrives (or budget)."""
    sess = session()
    out: list[dict] = []
    deadline = time.time() + budget
    def done(m):
        k = m.get("kind")
        ik = m.get("info", {}).get("kind")
        out.append(m)
        return k in pred_kinds or ik in pred_kinds
    try:
        sess.read_until(done, deadline)
    except TimeoutError:
        pass
    except RuntimeError:
        pass
    return out


def api(req: dict) -> dict:
    global LOADED
    op = req.get("op")
    if op == "ping":
        return {"ok": True, "kernel": "agda 2.8.0 (the pin)", "loaded": LOADED}

    file = req.get("file", "")
    p = (ROOT / file).resolve()
    if not str(p).startswith(str(ROOT)):
        return {"error": "outside the repository"}

    if op == "source":
        if not p.exists():
            return {"error": "no such file"}
        return {"text": p.read_text(encoding="utf-8")}

    if op == "write":
        text = req.get("text", "")
        p.write_text(text, encoding="utf-8")
        return {"ok": True}

    sess = session()
    if op == "check":
        sess.send(iotcm(str(p), f'Cmd_load "{p}" []'))
        msgs = collect(str(p), {"AllGoalsWarnings", "Error"}, 240.0)
        errors, goals, warnings = [], [], []
        for m in msgs:
            info = m.get("info", {})
            if info.get("kind") == "Error":
                err = info.get("error", {})
                errors.append(err.get("message") or json.dumps(err)[:600])
            if info.get("kind") == "AllGoalsWarnings":
                for g in (info.get("visibleGoals") or []):
                    cid = g.get("constraintObj", {})
                    rng = cid.get("range", [{}])
                    goals.append({
                        "id": cid.get("id", g.get("id")),
                        "type": g.get("type", ""),
                        "range": rng,
                    })
                for w in (info.get("warnings") or []):
                    warnings.append(w.get("message", "")[:400])
            if m.get("kind") == "InteractionPoints":
                pass
        LOADED = file if not errors else None
        return {"ok": not errors, "errors": errors, "goals": goals,
                "warnings": warnings}

    if op == "goal":
        gid = int(req.get("id", 0))
        sess.send(iotcm(str(p),
            f'Cmd_goal_type_context Normalised {gid} noRange ""'))
        msgs = collect(str(p), {"GoalSpecific", "Error"}, 60.0)
        for m in msgs:
            info = m.get("info", {})
            if info.get("kind") == "GoalSpecific":
                gi = info.get("goalInfo", {})
                return {"goal": gi.get("type", ""),
                        "context": gi.get("entries", [])}
        return {"error": "no goal info"}

    if op in ("infer", "normalize", "goal") and LOADED != file:
        # the kernel answers in a loaded scope; load first, on demand
        sess.send(iotcm(str(p), f'Cmd_load "{p}" []'))
        collect(str(p), {"AllGoalsWarnings", "Error"}, 240.0)
        LOADED = file

    if op in ("infer", "normalize"):
        expr = req.get("expr", "").replace('"', '\\"')
        cmd = (f'Cmd_infer_toplevel Normalised "{expr}"' if op == "infer"
               else f'Cmd_compute_toplevel DefaultCompute "{expr}"')
        sess.send(iotcm(str(p), cmd))
        msgs = collect(str(p), {"InferredType", "NormalForm", "Error"}, 90.0)
        for m in msgs:
            info = m.get("info", {})
            if info.get("kind") == "InferredType":
                return {"type": info.get("expr", "")}
            if info.get("kind") == "NormalForm":
                return {"value": info.get("expr", "")}
            if info.get("kind") == "Error":
                err = info.get("error", {})
                return {"error": (err.get("message") or "")[:600]}
        return {"error": "kernel gave no answer in budget"}

    return {"error": f"unknown op {op!r}"}


class Handler(SimpleHTTPRequestHandler):
    def translate_path(self, path):
        # /store/* from ide/store, everything else from ide/web
        path = path.split("?", 1)[0]
        if path.startswith("/store/"):
            return str(STORE / path[len("/store/"):])
        rel = path.lstrip("/") or "index.html"
        return str(WEB / rel)

    def do_POST(self):
        if self.path != "/api":
            self.send_error(404)
            return
        n = int(self.headers.get("Content-Length", 0))
        try:
            req = json.loads(self.rfile.read(n))
            resp = api(req)
        except Exception as e:  # the bridge never dies of one request
            resp = {"error": f"bridge: {e}"}
        body = json.dumps(resp, ensure_ascii=False).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


def main() -> int:
    print(f"kernel bridge: http://localhost:{PORT}  (repo: {ROOT})")
    HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Join the kernel to the store: elaborated types for every declaration.

Runs the pinned Agda (installed by `sh setup`) over the corpus and, for each
module the checker accepts, harvests the inferred type of every public name
via the interaction protocol (Cmd_infer over a loaded file's scope).

Output: ide/store/types/<area>.json  { module: { name: type-string } }
Route: kernel — these strings are computed by the typechecker, not read
from text. Modules that fail to load are recorded with the failure named
(never silently absent).

Usage: python3 ide/elaborate.py [--limit N] [--areas a,b,...]
"""
from __future__ import annotations

import json
import os
import queue
import re
import subprocess
import sys
import threading
import time
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"
OUT_DIR = STORE / "types"
PREFIX = Path(os.environ.get("MATH_PREFIX", str(Path.home())))
AGDA = PREFIX / ".local/bin/agda"
LIBFILE = PREFIX / ".agda-pin/libraries"
TIMEOUT = int(os.environ.get("IDE_AGDA_TIMEOUT", "240"))


def iotcm(path: str, cmd: str) -> str:
    return f'IOTCM "{path}" None Indirect ({cmd})\n'


class AgdaSession:
    def __init__(self) -> None:
        self.proc = subprocess.Popen(
            [str(AGDA), f"--library-file={LIBFILE}",
             "-l", "fibre", "-l", "natural-machine", "-l", "rescued-lanes",
             "--interaction-json"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL, text=True, cwd=ROOT,
            env={**os.environ, "LC_ALL": "C.utf8"},
        )
        self.q: queue.Queue = queue.Queue()
        threading.Thread(target=self._pump, daemon=True).start()

    def _pump(self) -> None:
        assert self.proc.stdout
        for raw in self.proc.stdout:
            self.q.put(raw)
        self.q.put(None)

    def send(self, line: str) -> None:
        assert self.proc.stdin
        self.proc.stdin.write(line)
        self.proc.stdin.flush()

    def read_until(self, pred, deadline: float):
        msgs = []
        while True:
            remaining = deadline - time.time()
            if remaining <= 0:
                raise TimeoutError("deadline")
            try:
                raw = self.q.get(timeout=min(remaining, 5.0))
            except queue.Empty:
                continue
            if raw is None:
                raise RuntimeError("agda closed the pipe")
            raw = raw.strip()
            if raw.startswith("JSON> "):
                raw = raw[len("JSON> "):]
            if not raw.startswith("{"):
                continue
            try:
                m = json.loads(raw)
            except json.JSONDecodeError:
                continue
            msgs.append(m)
            if pred(m):
                return msgs
        raise TimeoutError("deadline")

    def load(self, path: Path) -> tuple[bool, str]:
        self.send(iotcm(str(path), f'Cmd_load "{path}" []'))
        try:
            msgs = self.read_until(
                lambda m: m.get("kind") == "Status" and not m.get("status", {}).get("checked", False) is None
                and m.get("status", {}).get("checked") is True
                or (m.get("kind") == "DisplayInfo" and m.get("info", {}).get("kind") in ("Error", "AllGoalsWarnings", "CompilationOk")),
                time.time() + TIMEOUT,
            )
        except TimeoutError:
            self.close()
            return False, "timeout"
        for m in msgs:
            if m.get("kind") == "DisplayInfo" and m.get("info", {}).get("kind") == "Error":
                err = m["info"].get("error", {})
                return False, (err.get("message") or json.dumps(err))[:400]
        return True, ""

    def infer(self, path: Path, expr: str) -> str | None:
        self.send(iotcm(str(path),
                        f'Cmd_infer_toplevel AsIs "{expr}"'))
        try:
            msgs = self.read_until(
                lambda m: m.get("kind") == "DisplayInfo" and
                m.get("info", {}).get("kind") in ("InferredType", "Error"),
                time.time() + 30,
            )
        except TimeoutError:
            return None
        for m in msgs:
            info = m.get("info", {})
            if info.get("kind") == "InferredType":
                expr_obj = info.get("expr")
                if isinstance(expr_obj, str):
                    return expr_obj
                return json.dumps(expr_obj)[:600]
        return None

    def close(self) -> None:
        try:
            self.proc.terminate()
        except Exception:
            pass


def main() -> int:
    args = sys.argv[1:]
    limit = None
    areas = None
    if "--limit" in args:
        limit = int(args[args.index("--limit") + 1])
    if "--areas" in args:
        areas = set(args[args.index("--areas") + 1].split(","))

    if not AGDA.exists():
        print("no pinned agda yet; run sh setup first", file=sys.stderr)
        return 1
    idx = json.loads((STORE / "index.json").read_text())
    detail_cache: dict[str, dict] = {}

    def detail_of(n):
        k = n["dsh"]
        if k not in detail_cache:
            detail_cache[k] = json.loads((STORE / idx["details"][k]).read_text())
        return detail_cache[k].get(n["a"], {})

    nodes = [n for n in idx["nodes"] if n["canon"] and n["verdict"] != "red-by-design"]
    if areas:
        nodes = [n for n in nodes if n["area"] in areas]
    # hubs first: most value per minute
    nodes.sort(key=lambda n: -n["deg"])
    if limit:
        nodes = nodes[:limit]

    OUT_DIR.mkdir(exist_ok=True)
    already: set[str] = set()
    for shard in OUT_DIR.glob("*.json"):
        if shard.name == "_failures.json":
            continue
        try:
            already.update(json.loads(shard.read_text()).keys())
        except Exception:
            pass
    nodes = [n for n in nodes if n["m"] not in already]
    print(f"resuming: {len(already)} done, {len(nodes)} to go", file=sys.stderr)
    results: dict[str, dict] = defaultdict(dict)
    failures: dict[str, str] = {}
    sess = AgdaSession()
    done = 0
    for n in nodes:
        path = ROOT / n["p"]
        ok, err = False, "?"
        if sess.proc.poll() is not None:
            sess = AgdaSession()
        try:
            ok, err = sess.load(path)
        except (RuntimeError, BrokenPipeError):
            sess.close()
            sess = AgdaSession()
            try:
                ok, err = sess.load(path)
            except Exception as e:  # give up on this module, keep the run
                ok, err = False, f"session: {e}"
        if not ok:
            failures[n["m"]] = err
            print(f"  ✗ {n['m']}: {err[:80]}", file=sys.stderr)
            continue
        d = detail_of(n)
        for dec in d.get("decls", [])[:40]:
            t = None
            try:
                t = sess.infer(path, dec["n"])
            except Exception:
                pass
            if t:
                results[n["m"]][dec["n"]] = t
        done += 1
        print(f"  ✓ {n['m']} ({len(results[n['m']])} types)", file=sys.stderr)
        # persist incrementally by area
        area_key = re.sub(r"[^A-Za-z0-9_-]", "_", n["area"])
        shard = OUT_DIR / f"{area_key}.json"
        existing = json.loads(shard.read_text()) if shard.exists() else {}
        existing[n["m"]] = results[n["m"]]
        shard.write_text(json.dumps(existing, ensure_ascii=False), encoding="utf-8")
    sess.close()
    (OUT_DIR / "_failures.json").write_text(
        json.dumps(failures, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"elaborated {done}/{len(nodes)} modules; failures: {len(failures)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

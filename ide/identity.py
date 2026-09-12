#!/usr/bin/env python3
"""Drive CorpusIdentity: per-module kernel-computed identity and edges.

For each corpus module M, generate a probe module that materializes M's
public names via Fibre.CorpusReflection and exports, for every
declaration, its CANONICAL SERIALIZATION (computed by CorpusIdentity,
--safe, inside the kernel) and its exact reference list.  The probe is
loaded and `probe` normalized over the interaction protocol; this driver
only ferries the string and hashes the canonical bytes (SHA-256 of the
kernel-emitted form — representation-independent bookkeeping; the
identity-bearing object is the serialization, which the kernel produced).

Output: ide/store/identity/<area>.json
  { module: { name: { "h": hash16, "refs": [qualified names] } } }
plus _failures.json.  Resumable; hubs first.
"""
from __future__ import annotations

import hashlib
import json
import os
import re
import sys
import time
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from elaborate import AgdaSession, AGDA, LIBFILE, iotcm  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"
OUT_DIR = STORE / "identity"
PROBE_DIR = ROOT / "generated"
PROBE = PROBE_DIR / "IdentityProbe.agda"
TIMEOUT = int(os.environ.get("IDE_AGDA_TIMEOUT", "300"))

sys.path.insert(0, str(ROOT / "scripts"))
import importlib.util  # noqa: E402
spec = importlib.util.spec_from_file_location(
    "corpus_calc", ROOT / "scripts" / "run-corpus-calculus.py")
corpus_calc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corpus_calc)  # type: ignore[union-attr]


def write_probe(mod: str, names: list[str]) -> None:
    lines = [
        "{-# OPTIONS --cubical --safe --guardedness #-}",
        "module IdentityProbe where",
        "open import Agda.Builtin.String",
        "open import Agda.Builtin.List",
        "open import Agda.Builtin.Reflection using (Name)",
        "open import CorpusIdentity",
        "open import Fibre.CorpusReflection",
        f"import {mod}",
        "",
        "names : List Name",
        "names =",
    ]
    lines.extend(f"  quote {mod}.{n} ∷" for n in names)
    lines.append("  []")
    lines.extend([
        "",
        "corpus : RawCorpus",
        "corpus = materialize names",
        "",
        "probe : String",
        "probe = export corpus",
        "",
    ])
    PROBE.write_text("\n".join(lines), encoding="utf-8")


class IdentitySession(AgdaSession):
    def __init__(self) -> None:
        # extend the library path with ide/agda for CorpusIdentity
        import subprocess
        self.proc = subprocess.Popen(
            [str(AGDA), f"--library-file={LIBFILE}",
             "-l", "fibre", "-l", "natural-machine", "-l", "rescued-lanes",
             "-i", str(ROOT / "ide" / "agda"), "-i", str(PROBE_DIR),
             "--interaction-json"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL, text=True, cwd=ROOT,
            env={**os.environ, "LC_ALL": "C.utf8"},
        )
        import queue as _q, threading as _t
        self.q = _q.Queue()
        _t.Thread(target=self._pump, daemon=True).start()

    def compute(self, path: Path, expr: str, budget: int) -> str | None:
        self.send(iotcm(str(path), f'Cmd_compute_toplevel DefaultCompute "{expr}"'))
        try:
            msgs = self.read_until(
                lambda m: m.get("kind") == "DisplayInfo" and
                m.get("info", {}).get("kind") in ("NormalForm", "Error"),
                time.time() + budget)
        except TimeoutError:
            self.close()
            return None
        for m in msgs:
            info = m.get("info", {})
            if info.get("kind") == "NormalForm":
                return info.get("expr")
        return None


def parse_export(raw: str) -> dict[str, dict]:
    # normal form of a String literal: "..." with escapes
    if raw.startswith('"') and raw.endswith('"'):
        raw = raw[1:-1]
    raw = raw.encode().decode("unicode_escape").encode("latin-1", "backslashreplace").decode("utf-8", "replace") \
        if "\\" in raw else raw
    out: dict[str, dict] = {}
    for line in raw.split("\n"):
        parts = line.split("\t")
        if len(parts) != 3:
            continue
        name, canonical, refs = parts
        out[name] = {
            "h": hashlib.sha256(canonical.encode()).hexdigest()[:16],
            "refs": [r for r in refs.split(";") if r],
        }
    return out


def main() -> int:
    limit = None
    if "--limit" in sys.argv:
        limit = int(sys.argv[sys.argv.index("--limit") + 1])
    modules, _dups = corpus_calc.discover()
    idx = json.loads((STORE / "index.json").read_text())
    deg = {n["m"]: n["deg"] for n in idx["nodes"]}
    area = {n["m"]: n["area"] for n in idx["nodes"]}
    modules = [(m, p, ns) for m, p, ns in modules if ns]
    modules.sort(key=lambda x: -deg.get(x[0], 0))

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    PROBE_DIR.mkdir(exist_ok=True)
    done: set[str] = set()
    for shard in OUT_DIR.glob("*.json"):
        if shard.name != "_failures.json":
            try:
                done.update(json.loads(shard.read_text()).keys())
            except Exception:
                pass
    modules = [x for x in modules if x[0] not in done]
    if limit:
        modules = modules[:limit]
    print(f"identity: {len(done)} done, {len(modules)} to go", file=sys.stderr)

    failures: dict[str, str] = {}
    sess = IdentitySession()
    for mod, _path, names in modules:
        write_probe(mod, names[:60])
        if sess.proc.poll() is not None:
            sess = IdentitySession()
        try:
            ok, err = sess.load(PROBE)
        except (RuntimeError, BrokenPipeError):
            sess.close(); sess = IdentitySession()
            try:
                ok, err = sess.load(PROBE)
            except Exception as e:
                ok, err = False, f"session: {e}"
        if not ok:
            failures[mod] = err or "load failed"
            print(f"  x {mod}: {(err or '')[:70]}", file=sys.stderr)
            continue
        raw = sess.compute(PROBE, "probe", TIMEOUT)
        if raw is None:
            failures[mod] = "normalize timeout"
            print(f"  x {mod}: normalize timeout", file=sys.stderr)
            continue
        table = parse_export(raw)
        akey = re.sub(r"[^A-Za-z0-9_-]", "_", area.get(mod, "misc"))
        shard = OUT_DIR / f"{akey}.json"
        existing = json.loads(shard.read_text()) if shard.exists() else {}
        existing[mod] = table
        shard.write_text(json.dumps(existing, ensure_ascii=False), encoding="utf-8")
        print(f"  + {mod} ({len(table)} identities)", file=sys.stderr)
    (OUT_DIR / "_failures.json").write_text(
        json.dumps(failures, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"failures: {len(failures)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

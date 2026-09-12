#!/usr/bin/env python3
"""Drive IdentityTower: the δ- and π-charts, computed by the kernel.

Per module: a probe materializes the module's names; IdentityTower's TC
code (running inside the checker) emits, for each declaration,
  D <name> <normalized-type serialization>     (the δ-key; witness =
                                                the kernel's normalization)
  P <witness> EQV|PATH|ISO <lhsHead> <rhsHead> (a π-edge: an identification
                                                the corpus itself proved)
This driver ferries the strings and hashes δ-keys (bookkeeping over
kernel-emitted canonical bytes). Output:
  ide/store/tower/<area>.json
    { module: { "delta": {name: key-hash}, "pi": [[witness,kind,lhs,rhs]] } }
Resumable; failures recorded by name.
"""
from __future__ import annotations

import hashlib
import json
import os
import re
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from identity import IdentitySession, corpus_calc, PROBE_DIR, PROBE  # noqa: E402
from elaborate import iotcm  # noqa: E402


def kernel_names(sess: "IdentitySession", mod: str) -> list[str] | None:
    """List a module's declarations from the checker itself
    (ShowModuleContents in a probe scope where the module is visible) —
    closes the text-scraper's blindness to parameterized-module blocks."""
    PROBE.write_text(
        "{-# OPTIONS --cubical --safe --guardedness #-}\n"
        "module IdentityProbe where\n"
        f"import {mod}\n", encoding="utf-8")
    try:
        ok, err = sess.load(PROBE)
    except Exception:
        return None
    if not ok:
        return None
    sess.send(iotcm(str(PROBE),
                    f'Cmd_show_module_contents_toplevel Simplified "{mod}"'))
    try:
        msgs = sess.read_until(
            lambda m: m.get("kind") == "DisplayInfo" and
            m.get("info", {}).get("kind") in ("ModuleContents", "Error"),
            time.time() + 90)
    except Exception:
        return None
    for m in msgs:
        info = m.get("info", {})
        if info.get("kind") == "ModuleContents":
            out = []
            for entry in info.get("contents", []):
                name = entry.get("name", "")
                if name and " " not in name and not name.startswith("_"):
                    out.append(name)
            return out
    return None

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"
OUT_DIR = STORE / "tower"
TIMEOUT = int(os.environ.get("IDE_AGDA_TIMEOUT", "300"))


def write_probe(mod: str, names: list[str]) -> None:
    lines = [
        "{-# OPTIONS --cubical --safe --guardedness #-}",
        "module IdentityProbe where",
        "open import Agda.Builtin.String",
        "open import Agda.Builtin.List",
        "open import Agda.Builtin.Reflection using (Name)",
        "open import IdentityTower",
        f"import {mod}",
        "",
        "names : List Name",
        "names =",
    ]
    lines.extend(f"  quote {mod}.{n} ∷" for n in names)
    lines.append("  []")
    lines.extend(["", "towerText : String", "towerText = towerOf names", ""])
    PROBE.write_text("\n".join(lines), encoding="utf-8")


def parse(raw: str) -> dict:
    if raw.startswith('"') and raw.endswith('"'):
        raw = raw[1:-1]
    delta: dict[str, str] = {}
    pi: list[list[str]] = []
    for line in raw.split("\\n" if "\\n" in raw else "\n"):
        parts = line.split("\\t" if "\\t" in line else "\t")
        if len(parts) >= 3 and parts[0] == "D":
            delta[parts[1]] = hashlib.sha256(parts[2].encode()).hexdigest()[:16]
        elif len(parts) == 5 and parts[0] == "P":
            pi.append(parts[1:])
    return {"delta": delta, "pi": pi}


def main() -> int:
    limit = None
    if "--limit" in sys.argv:
        limit = int(sys.argv[sys.argv.index("--limit") + 1])
    only = None
    if "--modules" in sys.argv:
        only = set(sys.argv[sys.argv.index("--modules") + 1].split(","))
    modules, _ = corpus_calc.discover()
    idx = json.loads((STORE / "index.json").read_text())
    deg = {n["m"]: n["deg"] for n in idx["nodes"]}
    area = {n["m"]: n["area"] for n in idx["nodes"]}
    if only:
        modules = [x for x in modules if x[0] in only]
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
    print(f"tower: {len(done)} done, {len(modules)} to go", file=sys.stderr)

    failures: dict[str, str] = {}
    sess = IdentitySession()
    for mod, _p, names in modules:
        if sess.proc.poll() is not None:
            sess = IdentitySession()
        listed = kernel_names(sess, mod)
        if listed:
            names = listed          # kernel-derived; overrides the scraper
        if not names:
            failures[mod] = "no names (kernel listing empty)"
            continue
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
        raw = sess.compute(PROBE, "towerText", TIMEOUT)
        if raw is None:
            failures[mod] = "compute timeout"
            print(f"  x {mod}: compute timeout", file=sys.stderr)
            continue
        rec = parse(raw)
        akey = re.sub(r"[^A-Za-z0-9_-]", "_", area.get(mod, "misc"))
        shard = OUT_DIR / f"{akey}.json"
        existing = json.loads(shard.read_text()) if shard.exists() else {}
        existing[mod] = rec
        shard.write_text(json.dumps(existing, ensure_ascii=False), encoding="utf-8")
        print(f"  + {mod} (delta {len(rec['delta'])}, pi {len(rec['pi'])})",
              file=sys.stderr)
    (OUT_DIR / "_failures.json").write_text(
        json.dumps(failures, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"failures: {len(failures)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def parse_include_dirs(lib: Path) -> list[Path]:
    out: list[Path] = []
    if not lib.exists():
        return out
    for raw in lib.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if line.startswith("include:"):
            base = lib.parent
            for item in line[len("include:"):].split():
                p = (base / item).resolve()
                if p.is_dir() and p not in out:
                    out.append(p)
    return out


def module_name(src: str) -> str | None:
    m = re.search(r"(?m)^module\s+([^\s({]+)", src)
    return m.group(1) if m else None


def public_names(src: str) -> list[str]:
    names: list[str] = []
    seen: set[str] = set()
    keywords = {
        "module", "open", "import", "private", "public", "mutual", "abstract",
        "instance", "macro", "variable", "postulate", "field", "constructor",
        "infix", "infixl", "infixr", "syntax", "pattern",
    }

    def add(x: str) -> None:
        x = x.strip()
        if not x or x == "_" or x in keywords or x.startswith("--") or x.startswith("{-#"):
            return
        if x not in seen:
            seen.add(x)
            names.append(x)

    for line in src.splitlines():
        if not line or line[0].isspace() or line.startswith("--") or line.startswith("{-#"):
            continue
        dm = re.match(r"(?:data|record)\s+([^\s:{]+)", line)
        if dm:
            add(dm.group(1))
            continue
        if ":" not in line:
            continue
        left = line.split(":", 1)[0].strip()
        if not left or left.split()[0] in keywords:
            continue
        # Agda permits grouped signatures: f g : A.  Each token is a name.
        for token in left.split():
            add(token)
    return names


def depth_term(n: int) -> str:
    return "zero" if n == 0 else "suc (" + depth_term(n - 1) + ")"


def discover() -> tuple[list[tuple[str, Path, list[str]]], list[tuple[str, list[Path]]]]:
    libs = [
        ROOT / "formal/cubical/natural-machine.agda-lib",
        ROOT / "rescued-lanes.agda-lib",
    ]
    includes: list[Path] = []
    for lib in libs:
        for p in parse_include_dirs(lib):
            if p not in includes:
                includes.append(p)

    by_module: dict[str, list[tuple[Path, list[str]]]] = {}
    for inc in includes:
        for path in inc.rglob("*.agda"):
            rp = path.resolve()
            if "must_fail" in rp.parts:
                continue
            if path.name.startswith("CorpusProbe"):
                continue
            try:
                src = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            mod = module_name(src)
            if not mod:
                continue
            ns = public_names(src)
            by_module.setdefault(mod, []).append((path, ns))

    # An Agda library context resolves a module name to one module.  Preserve
    # that raw namespace fact rather than inventing identities between duplicate
    # source files.  Pick the first include-order resolution and report the rest.
    rank = {p: i for i, p in enumerate(includes)}

    def resolution_key(item: tuple[Path, list[str]]) -> tuple[int, str]:
        p = item[0].resolve()
        best = len(includes)
        for inc, i in rank.items():
            try:
                p.relative_to(inc)
                best = min(best, i)
            except ValueError:
                pass
        return best, str(p)

    chosen: list[tuple[str, Path, list[str]]] = []
    duplicates: list[tuple[str, list[Path]]] = []
    for mod, xs in sorted(by_module.items()):
        xs = sorted(xs, key=resolution_key)
        chosen.append((mod, xs[0][0], xs[0][1]))
        uniq = []
        for p, _ in xs:
            if p not in uniq:
                uniq.append(p)
        if len(uniq) > 1:
            duplicates.append((mod, uniq))
    return chosen, duplicates


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--depth", type=int, default=1,
                    help="finite observation depth of the coinductive unfolding")
    ap.add_argument("--keep-probe", action="store_true")
    args = ap.parse_args()
    if args.depth < 0:
        ap.error("--depth must be nonnegative")

    prefix = Path(os.environ.get("MATH_PREFIX", str(Path.home())))
    agda = prefix / ".local/bin/agda"
    if not agda.exists():
        found = shutil.which("agda")
        if not found:
            print("no agda; run: sh setup", file=sys.stderr)
            return 1
        agda = Path(found)
    libfile = prefix / ".agda-pin/libraries"
    if not libfile.exists():
        print(f"no {libfile}; run: sh setup", file=sys.stderr)
        return 1

    ver = subprocess.run([str(agda), "--version"], text=True, capture_output=True).stdout.strip()
    if not ver.startswith("Agda version 2.8.0"):
        print(f"wrong toolchain: {ver!r}; run: sh setup", file=sys.stderr)
        return 1

    modules, duplicates = discover()
    qnames: list[str] = []
    imports: list[str] = []
    for mod, _, names in modules:
        imports.append(f"import {mod}")
        qnames.extend(f"{mod}.{n}" for n in names)

    print(f"corpus modules in active Agda namespace: {len(modules)}", file=sys.stderr)
    print(f"public checked names supplied as states/actions: {len(qnames)}", file=sys.stderr)
    if duplicates:
        print(f"duplicate raw module names (separate Agda contexts): {len(duplicates)}", file=sys.stderr)
        for mod, paths in duplicates:
            print("DUPLICATE_MODULE " + mod + " :: " + " | ".join(str(p.relative_to(ROOT)) for p in paths),
                  file=sys.stderr)

    body = [
        "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}",
        "module CorpusProbe where",
        "",
        "open import Agda.Builtin.Reflection using (Name)",
        "open import Agda.Builtin.List using (List ; [] ; _∷_)",
        "open import Agda.Builtin.Nat using (Nat ; zero ; suc)",
        "open import CorpusExecute using (runCorpus)",
        "",
        *imports,
        "",
        "names : List Name",
        "names =",
    ]
    if qnames:
        body.extend([f"  quote {q} ∷" for q in qnames])
        body.append("  []")
    else:
        body.append("  []")
    body.extend(["", f"unquoteDecl = runCorpus ({depth_term(args.depth)}) names", ""])

    tmp_ctx = tempfile.TemporaryDirectory(prefix="corpus-calculus-")
    tdir = Path(tmp_ctx.name)
    probe = tdir / "CorpusProbe.agda"
    probe.write_text("\n".join(body), encoding="utf-8")
    if args.keep_probe:
        kept = ROOT / "CorpusProbe.generated.agda"
        kept.write_text(probe.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"probe: {kept}", file=sys.stderr)

    cmd = [
        str(agda),
        f"--library-file={libfile}",
        "-l", "natural-machine",
        "-l", "rescued-lanes",
        "-i", str(tdir),
        "-v", "corpus.edge:1",
        str(probe),
    ]
    print("executing finite observation of coinductive corpus calculus...", file=sys.stderr)
    return subprocess.call(cmd, cwd=ROOT)


if __name__ == "__main__":
    raise SystemExit(main())

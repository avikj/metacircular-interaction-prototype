#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
GENERATED = ROOT / "generated"
OUT = GENERATED / "CorpusRepository.agda"


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
        if any(c in x for c in "(){}[],"):
            return
        if x not in seen:
            seen.add(x); names.append(x)
    for line in src.splitlines():
        if not line or line[0].isspace() or line.startswith("--") or line.startswith("{-#"):
            continue
        dm = re.match(r"(?:data|record)\s+([^\s:{]+)", line)
        if dm:
            add(dm.group(1)); continue
        if ":" not in line:
            continue
        left = line.split(":", 1)[0].strip()
        if not left or left.split()[0] in keywords:
            continue
        if {"=", "with", "rewrite", "|", "...", "where", "let", "in"} & set(left.split()):
            continue
        for token in left.split():
            add(token)
    return names


def discover() -> tuple[list[tuple[str, Path, list[str]]], list[tuple[str, list[Path]]]]:
    libs = [ROOT / "formal/cubical/natural-machine.agda-lib", ROOT / "rescued-lanes.agda-lib", ROOT / "fibre/fibre.agda-lib"]
    includes: list[Path] = []
    for lib in libs:
        for p in parse_include_dirs(lib):
            if p not in includes:
                includes.append(p)
    by_module: dict[str, list[tuple[Path, list[str], int]]] = {}
    for rank, inc in enumerate(includes):
        for path in inc.rglob("*.agda"):
            rp = path.resolve()
            if "must_fail" in rp.parts or "generated" in rp.parts:
                continue
            try:
                src = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            # A module with open interaction points ('?' or '{! !}' holes)
            # cannot be imported; leave it out of the materialized state.
            if "{!" in src or re.search(r"(?m)(^|[\s(=])\?(\s|\)|$)", src):
                continue
            mod = module_name(src)
            if mod:
                by_module.setdefault(mod, []).append((path, public_names(src), rank))
    chosen: list[tuple[str, Path, list[str]]] = []
    duplicates: list[tuple[str, list[Path]]] = []
    for mod, xs in sorted(by_module.items()):
        xs = sorted(xs, key=lambda x: (x[2], str(x[0])))
        chosen.append((mod, xs[0][0], xs[0][1]))
        paths: list[Path] = []
        for p, _, _ in xs:
            if p not in paths:
                paths.append(p)
        if len(paths) > 1:
            duplicates.append((mod, paths))
    return chosen, duplicates


def find_agda() -> tuple[Path, Path] | None:
    prefix = Path(os.environ.get("MATH_PREFIX", str(Path.home())))
    agda = prefix / ".local/bin/agda"
    if not agda.exists():
        found = shutil.which("agda")
        if not found:
            print("no agda; run: sh setup", file=sys.stderr); return None
        agda = Path(found)
    libfile = prefix / ".agda-pin/libraries"
    if not libfile.exists():
        print(f"no {libfile}; run: sh setup", file=sys.stderr); return None
    ver = subprocess.run([str(agda), "--version"], text=True, capture_output=True).stdout.strip()
    if not ver.startswith("Agda version 2.8.0"):
        print(f"wrong toolchain: {ver!r}; run: sh setup", file=sys.stderr); return None
    return agda, libfile


def generate() -> tuple[int, int]:
    modules, duplicates = discover()
    imports: list[str] = []
    qnames: list[str] = []
    for mod, _, names in modules:
        if mod == "CorpusRepository":
            continue
        imports.append(f"import {mod}")
        qnames.extend(f"{mod}.{n}" for n in names)
    GENERATED.mkdir(exist_ok=True)
    body = [
        "{-# OPTIONS --cubical --safe --guardedness #-}",
        "module CorpusRepository where", "",
        "open import Agda.Primitive using (lzero)",
        "open import Agda.Builtin.Reflection using (Name)",
        "open import Agda.Builtin.List using (List ; [] ; _∷_)",
        "open import Fibre.CorpusReflection",
        "open import Fibre.CorpusSamvada",
        "import CorpusSelfPresentation as SP", "",
        *imports, "", "names : List Name", "names =",
    ]
    body += [f"  quote {q} ∷" for q in qnames] + ["  []"]
    body += [
        "", "corpus : RawCorpus", "corpus = materialize names",
        "", "corpusPoint : Point lzero", "corpusPoint = point corpus",
        "", "corpusProcess : Corpus corpusPoint", "corpusProcess = run corpusPoint",
        "", "corpusPresentation : SP.SelfPresentation corpusPoint", "corpusPresentation = SP.present corpusPoint", "",
    ]
    OUT.write_text("\n".join(body), encoding="utf-8")
    print(f"generated {OUT.relative_to(ROOT)}", file=sys.stderr)
    print(f"active modules: {len(modules)}", file=sys.stderr)
    print(f"checked declarations in the one repository state: {len(qnames)}", file=sys.stderr)
    if duplicates:
        print(f"duplicate declared module names resolved by include order: {len(duplicates)}", file=sys.stderr)
    return len(modules), len(qnames)


def main() -> int:
    tool = find_agda()
    if tool is None:
        return 1
    agda, libfile = tool
    generate()
    cmd = [str(agda), f"--library-file={libfile}", "-l", "fibre", "-l", "natural-machine", "-l", "rescued-lanes", "-i", str(GENERATED), str(OUT)]
    print("materializing one checked repository state and its infinite lossless guarded presentation...", file=sys.stderr)
    rc = subprocess.call(cmd, cwd=ROOT)
    if rc == 0:
        print("COMPLETE: generated/CorpusRepository.agda", file=sys.stderr)
        print("  corpus             = the entire reflected checked repository as one value", file=sys.stderr)
        print("  corpusPoint        = that one value as a universal typed state", file=sys.stderr)
        print("  corpusPresentation = infinite guarded target + exact fibre + continuation", file=sys.stderr)
    return rc


if __name__ == "__main__":
    raise SystemExit(main())

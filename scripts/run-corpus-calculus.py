#!/usr/bin/env python3
from __future__ import annotations

import functools
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]

# Modules whose typechecking exhausts this container's memory (>14 GB even
# checked alone, at every heap/GC setting). Excluded from the materialized
# state and reported, so the omission is visible rather than silent.
MEMORY_EXCLUDES = {
    "RamanujanLehmer_TheQuestionIsATypeTauIsTotalTheGateHoldsToSixteenAndNoConverseIsWritten",
}
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
    # Two names in one module whose underscore-stripped spellings agree
    # (a prefix operator next to its infix sibling, e.g. ⊟ᵐ_ and _⊟ᵐ_)
    # make `quote` irreducibly ambiguous between name and section; drop
    # every member of such a collision class.
    stripped: dict[str, int] = {}
    for n in names:
        key = n.replace("_", "")
        stripped[key] = stripped.get(key, 0) + 1
    return [n for n in names if stripped[n.replace("_", "")] == 1]


def discover() -> tuple[list[tuple[str, Path, list[str]]], list[tuple[str, list[Path]]]]:
    libs = [ROOT / "formal/cubical/natural-machine.agda-lib", ROOT / "rescued-lanes.agda-lib", ROOT / "fibre/fibre.agda-lib"]
    includes: list[Path] = []
    for lib in libs:
        for p in parse_include_dirs(lib):
            if p not in includes:
                includes.append(p)
    by_module: dict[str, list[tuple[Path, list[str], int]]] = {}
    imports_of: dict[str, set[str]] = {}
    for rank, inc in enumerate(includes):
        for path in inc.rglob("*.agda"):
            rp = path.resolve()
            if "must_fail" in rp.parts or "generated" in rp.parts:
                continue
            try:
                src = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            if "{!" in src or re.search(r"(?m)(^|[\s(=])\?(\s|\)|$)", src):
                continue
            # The generated module is --cubical --safe, both infective and
            # coinfective: only modules declaring the same can be imported.
            opts = re.search(r"(?s)\{-#\s*OPTIONS(.*?)#-\}", src)
            flags = opts.group(1) if opts else ""
            if "--cubical" not in flags or "--safe" not in flags:
                continue
            # Anything importing the generated module sits above it; pulling
            # it back into the generated state would be a module cycle.
            if re.search(r"(?m)^\s*(open\s+)?import\s+CorpusRepository\b", src):
                continue
            mod = module_name(src)
            # An importable top-level module must be named after its file;
            # anything else (an inner module matched first, module _) is not
            # addressable by import and would poison the generated file.
            if mod and mod.split(".")[-1] == path.stem:
                # CORPUS_FILTER bounds the probe namespace by module-name
                # regex.  Unset means the whole repository; on machines
                # that cannot hold the whole value, a filter proves the
                # same lane on a subcorpus.
                flt = os.environ.get("CORPUS_FILTER")
                if flt and not re.search(flt, mod):
                    continue
                by_module.setdefault(mod, []).append((path, public_names(src), rank))
                imports_of[mod] = set(re.findall(r"(?m)^\s*(?:open\s+)?import\s+([^\s(]+)", src))
    # Exclude memory-excluded modules together with everything that
    # (transitively) imports them; report each exclusion.
    dropped = set(MEMORY_EXCLUDES)
    changed = True
    while changed:
        changed = False
        for mod, imps in imports_of.items():
            if mod not in dropped and imps & dropped:
                dropped.add(mod); changed = True
    for mod in sorted(dropped & set(by_module)):
        print(f"EXCLUDED (memory closure): {mod}", file=sys.stderr)
        del by_module[mod]
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


def write_if_changed(path: Path, text: str) -> None:
    if path.exists() and path.read_text(encoding="utf-8") == text:
        return
    path.write_text(text, encoding="utf-8")


def generate() -> tuple[int, int]:
    modules, duplicates = discover()
    imports: list[str] = []
    qnames: list[str] = []
    ambiguous = {mod for mod, _ in duplicates}
    # Machine-bound exclusions, not mathematical ones.  The two Ramanujan
    # monsters exhaust a 14 GB heap even checked alone on this 15 GB
    # machine; Sthana imports a Setubandha module absent from the tree.
    unbuildable = {
        "RamanujanLehmer_TheQuestionIsATypeTauIsTotalTheGateHoldsToSixteenAndNoConverseIsWritten",
        "RamanujanSiddhanta_ThePaperInOneModuleEveryClaimOneTerm",
        "Sthana_ThePositionalWordIsPingalasNextRowAndItsAdditionArrivesWithNoCarryRule",
    }
    for mod, _, names in modules:
        if mod == "CorpusRepository" or mod in ambiguous or mod in unbuildable:
            continue
        imports.append(f"import {mod}")
        qnames.extend(f"{mod}.{n}" for n in names)
    GENERATED.mkdir(exist_ok=True)
    # Shard the quadratic loci materialization: each shard probes a slice
    # of generators against the full pool in its own bounded process, and
    # the concatenation of shard values is exactly buildLoci pool pool.
    shard_size = int(os.environ.get("CORPUS_SHARD", "32"))
    chunk_size = int(os.environ.get("CORPUS_POOL_CHUNK", "2000"))
    slices = [qnames[i:i + shard_size] for i in range(0, len(qnames), shard_size)] or [[]]
    chunks = [qnames[i:i + chunk_size] for i in range(0, len(qnames), chunk_size)] or [[]]
    for stale in GENERATED.glob("CorpusShard*.agda"):
        if stale.name not in {f"CorpusShard{k}.agda" for k in range(1, len(slices) + 1)}:
            stale.unlink()
    for stale in GENERATED.glob("CorpusPool*.agda"):
        if stale.name not in {f"CorpusPool{k}.agda" for k in range(1, len(chunks) + 1)}:
            stale.unlink()
    # The classified pool is materialized once, in chunks, as checked
    # values; shards consume it as data and pay no reflection for it.
    chunk_mods: list[str] = []
    for k, ch in enumerate(chunks, start=1):
        cmod = f"CorpusPool{k}"
        chunk_mods.append(cmod)
        cbody = [
            "{-# OPTIONS --cubical --safe --guardedness #-}",
            f"module {cmod} where", "",
            "open import Agda.Builtin.Reflection using (Name)",
            "open import Agda.Builtin.List using (List ; [] ; _∷_)",
            "open import Fibre.CorpusLoci using (PoolEntry ; materializePool)", "",
            *imports, "",
            "chunkNames : List Name", "chunkNames =",
            *[f"  (quote {q}) ∷" for q in ch], "  []", "",
            "chunk : List PoolEntry", "chunk = materializePool chunkNames", "",
        ]
        write_if_changed(GENERATED / f"{cmod}.agda", "\n".join(cbody))
    pool_expr = " Fibre.CorpusLoci.++ ".join(f"{m}.chunk" for m in chunk_mods)
    pool_expr = functools.reduce(
        lambda acc, m: f"Fibre.CorpusLoci._++_ {m}.chunk ({acc})",
        reversed(chunk_mods[:-1]), f"{chunk_mods[-1]}.chunk") if chunk_mods else "[]"
    shard_mods: list[str] = []
    for k, sl in enumerate(slices, start=1):
        smod = f"CorpusShard{k}"
        shard_mods.append(smod)
        sbody = [
            "{-# OPTIONS --cubical --safe --guardedness #-}",
            f"module {smod} where", "",
            "open import Agda.Builtin.Reflection using (Name)",
            "open import Agda.Builtin.List using (List ; [] ; _∷_)",
            "import Fibre.CorpusLoci",
            "open Fibre.CorpusLoci using (RawLoci ; PoolEntry ; materializeLociOver)", "",
            *[f"import {m}" for m in chunk_mods], "",
            *imports, "",
            "pool : List PoolEntry",
            f"pool = {pool_expr}", "",
            "gens : List Name", "gens =",
            *[f"  (quote {q}) ∷" for q in sl], "  []", "",
            "shard : RawLoci", "shard = materializeLociOver pool gens", "",
        ]
        write_if_changed(GENERATED / f"{smod}.agda", "\n".join(sbody))
    body = [
        "{-# OPTIONS --cubical --safe --guardedness #-}",
        "module CorpusRepository where", "",
        "open import Agda.Primitive using (lzero)",
        "open import Agda.Builtin.Reflection using (Name)",
        "open import Agda.Builtin.List using (List ; [] ; _∷_)",
        "open import Fibre.CorpusReflection",
        "open import Fibre.CorpusSamvada",
        "open import Fibre.CorpusLoci",
        "import CorpusSelfPresentation as SP", "",
        *imports, "", "names : List Name", "names =",
    ]
    body += [f"  (quote {q}) ∷" for q in qnames] + ["  []"]
    body += [
        "", "-- Expanded checked source, retained as the exact realization substrate.",
        "corpus : RawCorpus", "corpus = materialize names",
        "", "-- Factored relational presentation: each checked generator occurs once;",
        "-- its dependent family contains exactly the checked inhabitants it acts on,",
        "-- together with the accepted application and normalized result type.",
        *[f"import {m}" for m in shard_mods],
        "loci : RawLoci",
        "loci = " + (functools.reduce(lambda acc, m: f"Fibre.CorpusLoci._++_ {m}.shard ({acc})", reversed(shard_mods[:-1]), f"{shard_mods[-1]}.shard") if shard_mods else "[]"),
        "", "corpusPoint : Point lzero", "corpusPoint = point corpus",
        "", "lociPoint : Point lzero", "lociPoint = point loci",
        "", "corpusProcess : Corpus corpusPoint", "corpusProcess = run corpusPoint",
        "", "lociProcess : Corpus lociPoint", "lociProcess = run lociPoint",
        "", "-- Infinite, depth-free continuation of the factored presentation; every",
        "-- demanded question returns its target plus the exact residual fibre.",
        "lociPresentation : SP.SelfPresentation lociPoint", "lociPresentation = SP.present lociPoint", "",
    ]
    write_if_changed(OUT, "\n".join(body))
    print(f"generated {OUT.relative_to(ROOT)}", file=sys.stderr)
    print(f"active modules: {len(modules)}", file=sys.stderr)
    print(f"checked declarations: {len(qnames)}", file=sys.stderr)
    if duplicates:
        print(f"duplicate declared module names resolved by include order: {len(duplicates)}", file=sys.stderr)
    return len(modules), len(qnames)


def main() -> int:
    tool = find_agda()
    if tool is None:
        return 1
    agda, libfile = tool
    generate()
    base = [str(agda), "+RTS", "-M13G", "-RTS", f"--library-file={libfile}", "-l", "fibre", "-l", "natural-machine", "-l", "rescued-lanes", "-i", str(GENERATED)]
    # Pool chunks first, sequentially: shards depend on their values.
    pools = sorted(GENERATED.glob("CorpusPool*.agda"), key=lambda p: int(p.stem[len("CorpusPool"):]))
    for chunk in pools:
        print(f"classifying {chunk.name} ...", file=sys.stderr)
        rc = subprocess.call(base + [str(chunk)], cwd=ROOT)
        if rc != 0:
            print(f"pool chunk failed: {chunk.name}", file=sys.stderr)
            return rc
    shards = sorted(GENERATED.glob("CorpusShard*.agda"), key=lambda p: int(p.stem[len("CorpusShard"):]))
    # Shards are independent; run a small pool of them concurrently,
    # bounded by CORPUS_JOBS (default 2 — each process can hold a
    # multi-GB heap on this machine).
    jobs = max(1, int(os.environ.get("CORPUS_JOBS", "2")))
    pending = list(shards)
    running: list[tuple[Path, subprocess.Popen]] = []
    failed: Path | None = None
    while (pending or running) and failed is None:
        while pending and len(running) < jobs:
            shard = pending.pop(0)
            print(f"materializing {shard.name} ...", file=sys.stderr)
            running.append((shard, subprocess.Popen(base + [str(shard)], cwd=ROOT)))
        shard, proc = running.pop(0)
        rc = proc.wait()
        if rc != 0:
            failed = shard
    for _, proc in running:
        proc.wait()
    if failed is not None:
        print(f"shard failed: {failed.name}", file=sys.stderr)
        return 1
    print("computing the factored checked corpus presentation and its infinite lossless continuation...", file=sys.stderr)
    rc = subprocess.call(base + [str(OUT)], cwd=ROOT)
    if rc == 0:
        print("COMPLETE: generated/CorpusRepository.agda", file=sys.stderr)
        print("  corpus           = exact expanded checked corpus", file=sys.stderr)
        print("  loci             = shared checked generators factored once + exact realization families", file=sys.stderr)
        print("  lociPresentation = infinite guarded target + exact fibre + continuation", file=sys.stderr)
    return rc


if __name__ == "__main__":
    raise SystemExit(main())

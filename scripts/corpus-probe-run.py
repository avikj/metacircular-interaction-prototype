#!/usr/bin/env python3
"""Chunked, memory-safe driver for the corpus self-presentation.

The whole-corpus readout (generated/CorpusRepository.agda) imports every
module into one process and quoteTC's one giant reflected term: ~12 GB of
live interfaces, dead on any red module.  This driver keeps the SAME checked
reflection semantics (Fibre.CorpusProbe, over Fibre.CorpusReflection /
Fibre.CorpusLoci) but never aggregates: each chunk imports only its own slice
of CHUNKSZ modules, streams one row per declaration via debugPrint, and a red
module fails only its own chunk.  Rows are grouped into meaning-loci here,
outside Agda.

  default (emitDecls, -vdecl:1):  DECL <arity> <head> <def-kind> <name>
  --loci  (emitLoci,  -vloci:1):  LOCUS <arity> <result-head> <gen> <on>
          (the O(n^2) realization-family readout; use --limit to bound it)

Runs against the warm repository cache, so each chunk only compiles itself.
"""
from __future__ import annotations

import argparse
import importlib.util
import os
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_discover():
    spec = importlib.util.spec_from_file_location(
        "rcc", ROOT / "scripts" / "run-corpus-calculus.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def find_agda() -> tuple[str, str]:
    prefix = Path(os.environ.get("MATH_PREFIX", str(Path.home())))
    agda = prefix / ".local/bin/agda"
    agda = str(agda) if agda.exists() else (shutil.which("agda") or "")
    libfile = prefix / ".agda-pin/libraries"
    if not agda or not libfile.exists():
        sys.exit("no agda / libraries pin; run: sh setup")
    return agda, str(libfile)


def module_set(rcc):
    """The importable, judged module set: exactly what CorpusRepository imports."""
    modules, duplicates = rcc.discover()
    dup = {m for m, _ in duplicates}
    excluded = {
        "RamanujanLehmer_TheQuestionIsATypeTauIsTotalTheGateHoldsToSixteenAndNoConverseIsWritten",
        "RamanujanSiddhanta_ThePaperInOneModuleEveryClaimOneTerm",
    }
    skip_names = {"CorpusRepository", "CorpusFinalPresentation"}
    out = []
    for mod, _path, names in modules:
        if mod in dup or mod in excluded or mod in skip_names:
            continue
        # public names quotable as M.name; expandAll adds constructors/fields.
        if names:
            out.append((mod, names))
    return out


def chunk_source(k: int, slice_, macro: str) -> str:
    imports, quotes = [], []
    for i, (mod, names) in enumerate(slice_):
        al = f"D{i}"
        imports.append(f"import {mod} as {al}")
        quotes.extend(f"    quote {al}.{n} ∷" for n in names)
    return "\n".join([
        "{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}",
        f"module Chunk{k} where",
        f"open import Fibre.CorpusProbe using ({macro})",
        "open import Agda.Builtin.Unit using (⊤)",
        "open import Agda.Builtin.List using (List ; [] ; _∷_)",
        "open import Agda.Builtin.Reflection using (Name)",
        *imports,
        "names : List Name",
        "names =",
        *quotes,
        "    []",
        "run : ⊤",
        f"run = {macro} names",
    ])


def run_chunk(agda, libfile, k: int, slice_, macro: str, verb: str, tag: str,
              maxheal: int = 400) -> list[str]:
    """Run one chunk in its OWN temp dir (corpus interfaces live in the warm
    library _build, not here), self-healing inaccessible scraped names."""
    import re
    env = dict(os.environ, LC_ALL="C.utf8")
    cdir = Path(tempfile.mkdtemp(prefix=f"chunk{k}-"))
    cf = cdir / f"Chunk{k}.agda"
    cf.write_text(chunk_source(k, slice_, macro), encoding="utf-8")
    try:
        for _ in range(maxheal):
            p = subprocess.run(
                [agda, f"--library-file={libfile}", "-l", "fibre",
                 "-l", "natural-machine", "-l", "rescued-lanes",
                 "-i", str(cdir), f"-v{verb}:1",
                 "+RTS", "-M4000m", "-RTS", str(cf)],
                cwd=ROOT, text=True, capture_output=True, env=env)
            out = p.stdout + p.stderr
            rows = [ln for ln in out.splitlines() if ln.startswith(tag + "\t")]
            if rows:
                return rows
            if "NotInScope" in out:
                m = re.search(rf"{cf.name}:(\d+)", out)
                if m:
                    ln = int(m.group(1))
                    lines = cf.read_text(encoding="utf-8").splitlines()
                    if 1 <= ln <= len(lines):
                        del lines[ln - 1]
                        cf.write_text("\n".join(lines), encoding="utf-8")
                        continue
            return []  # non-scope error or empty: abandon this chunk quietly
        return []
    finally:
        shutil.rmtree(cdir, ignore_errors=True)


def present(rows: list[str], tag: str, out: Path):
    # locus key = (arity, head) = columns 2,3 of the tab row
    from collections import Counter
    keys = Counter()
    kinds = Counter()
    for r in rows:
        cols = r.split("\t")
        if len(cols) >= 3:
            keys[(cols[1], cols[2])] += 1
        if tag == "DECL" and len(cols) >= 4:
            kinds[cols[3]] += 1
    lines = [
        "════ CORPUS SELF-PRESENTATION (chunked, memory-safe) ════",
        f"tag                          : {tag}",
        f"checked declarations         : {len(rows)}",
        f"meaning-loci (arity, head)   : {len(keys)}",
        "observation q(decl) = (dependent Π-arity, elaborated conclusion head)",
    ]
    if kinds:
        lines.append("by definition kind           : "
                     + "  ".join(f"{k}={n}" for k, n in kinds.most_common()))
    lines.append("")
    lines.append("──── loci by residual size (largest first) ────")
    for (arity, head), cnt in keys.most_common(40):
        lines.append(f"LOCUS  Π{arity:<3} {head:<42} residual={cnt}")
    singles = sum(1 for _k, c in keys.items() if c == 1)
    lines.append("")
    lines.append(f"singleton loci (unique observation): {singles}")
    text = "\n".join(lines)
    out.write_text(text + "\n", encoding="utf-8")
    print(text)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--chunksz", type=int, default=15)
    ap.add_argument("--par", type=int, default=3)
    ap.add_argument("--limit", type=int, default=0, help="cap module count (0 = all)")
    ap.add_argument("--loci", action="store_true", help="run the O(n^2) realization readout")
    ap.add_argument("--rows-out", default="/tmp/corpus-rows.txt")
    ap.add_argument("--pres-out", default="/tmp/corpus-presentation.txt")
    args = ap.parse_args()

    agda, libfile = find_agda()
    rcc = load_discover()
    mods = module_set(rcc)
    if args.limit:
        mods = mods[:args.limit]
    macro, verb, tag = ("emitLoci", "loci", "LOCUS") if args.loci else ("emitDecls", "decl", "DECL")

    chunks = [mods[i:i + args.chunksz] for i in range(0, len(mods), args.chunksz)]
    print(f"modules={len(mods)} chunks={len(chunks)} chunksz={args.chunksz} "
          f"par={args.par} macro={macro}", file=sys.stderr)

    all_rows: list[str] = []
    zero_slices: list = []  # modules in chunks that yielded nothing
    done = 0
    with ThreadPoolExecutor(max_workers=args.par) as ex:
        futs = {ex.submit(run_chunk, agda, libfile, k, sl, macro, verb, tag): (k, sl)
                for k, sl in enumerate(chunks)}
        for fut in futs:
            k, sl = futs[fut]
            rows = fut.result()
            all_rows.extend(rows)
            if not rows and len(sl) > 1:
                zero_slices.append(sl)
            done += 1
            print(f"  chunk {done}/{len(chunks)}: +{len(rows)} rows "
                  f"(total {len(all_rows)})", file=sys.stderr)

    # Singleton recovery: a zero-row chunk lost every module to ONE module's
    # hard (non-NotInScope) error.  Re-run its modules one per chunk so a
    # single red module costs only itself, not its neighbours.
    recover = [(m, ns) for sl in zero_slices for (m, ns) in sl]
    if recover:
        print(f"recovery: {len(recover)} modules from "
              f"{len(zero_slices)} zero-row chunks, one per chunk", file=sys.stderr)
        base = 100000
        with ThreadPoolExecutor(max_workers=args.par) as ex:
            futs = [ex.submit(run_chunk, agda, libfile, base + j, [one], macro, verb, tag)
                    for j, one in enumerate(recover)]
            got = 0
            for fut in futs:
                rows = fut.result()
                all_rows.extend(rows)
                got += len(rows)
            print(f"recovery: +{got} rows (total {len(all_rows)})", file=sys.stderr)

    Path(args.rows_out).write_text("\n".join(all_rows) + "\n", encoding="utf-8")
    print(f"rows -> {args.rows_out}", file=sys.stderr)
    present(all_rows, tag, Path(args.pres_out))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

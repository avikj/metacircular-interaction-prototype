#!/usr/bin/env python3
"""emit-perturbation.py — the front-end for the perturbation presentation.

The calculus does not read .h5ad.  It reads a FINITE PRESENTATION: a gene
panel, a generator family (which gene regulates which, so that `step` is
defined), the interventions available at the boundary, and the control
populations that stand for each (opaque) context.  This script emits that
presentation as a Bend file in the shape of collab/bend2-cubical/port/
Perturbation.bend, so the same theorems (fold, elucidation, the Nerode
quotient, erasure by descent) are stated for the real panel instead of the
three-gene stand-in.

Input: a JSON spec

    {
      "panel":    ["TF1", "TGT1", "HK1", ...],          # gene ids, panel order
      "edges":    [["TF1", "TGT1"], ...],               # activator -> target
      "contexts": {"A": [[2, 1, 5], [1, 1, 3], ...],    # control cells, panel order
                   "B": [[...], ...]},
      "interventions": ["TF1", "HK1"],                  # genes that may be knocked down
      "assay":    ["TGT1"]                              # genes the protocol reads
    }

or `--csv context.csv` per context (header = panel, one row per cell).

The generator family emitted is the simplest one the edge list determines:
a knockdown zeroes its gene; a passage lets every edge act (each target
takes the level of its activator; a gene with no activator keeps its
level; a gene with several activators takes the first listed — state that
choice in the spec if it matters).  Replace `passage` by the field's own
continuation algebra when one is available; nothing downstream changes.

What is emitted, per section, mirrors Perturbation.bend §1–§7, and the
file imports MyhillNerodeMinimalMachine exactly as that file does.  The
emitted file is then checked and run by the patched Bend2 binary:

    LC_ALL=C.utf8 bend Emitted.bend

Everything specific to the panel is a constructor or a literal; every
theorem is stated once, generically, in the emitted text.
"""
from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path


def ident(g: str) -> str:
    """A gene id as a Bend constructor name: lowercase, [a-z0-9_], no leading digit."""
    s = re.sub(r"[^A-Za-z0-9_]", "_", g).lower()
    if not s or s[0].isdigit():
        s = "g_" + s
    return s


def load_spec(path: Path, csv_paths: list[str]) -> dict:
    spec = json.loads(path.read_text())
    for cp in csv_paths:
        name, _, file = cp.partition("=")
        if not file:
            sys.exit(f"--csv expects NAME=path, got {cp}")
        with open(file, newline="") as fh:
            rows = list(csv.reader(fh))
        header, body = rows[0], rows[1:]
        if header != spec["panel"]:
            sys.exit(f"{file}: header {header} is not the panel {spec['panel']}")
        spec.setdefault("contexts", {})[name] = [[int(float(x)) for x in r] for r in body]
    return spec


def emit(spec: dict) -> str:
    panel: list[str] = spec["panel"]
    n = len(panel)
    if n < 1:
        sys.exit("empty panel")
    edges: list[tuple[str, str]] = [tuple(e) for e in spec.get("edges", [])]
    for a, b in edges:
        if a not in panel or b not in panel:
            sys.exit(f"edge {a}->{b} names a gene outside the panel")
    activator: dict[str, str] = {}
    for a, b in edges:
        activator.setdefault(b, a)  # first listed activator wins; stated in the docstring
    interventions: list[str] = spec.get("interventions", panel)
    assay: list[str] = spec.get("assay", panel[:1])
    contexts: dict[str, list[list[int]]] = spec.get("contexts", {})
    for cname, cells in contexts.items():
        for c in cells:
            if len(c) != n:
                sys.exit(f"context {cname}: a cell has {len(c)} levels, panel has {n}")

    G = [ident(g) for g in panel]
    fields = ", ".join(f"{g}: Nat" for g in G)
    vars_ = ", ".join(f"v_{g}" for g in G)

    def cell_of(levels: list[int]) -> str:
        return "@cell{" + ", ".join(f"{int(x)}n" for x in levels) + "}"

    out: list[str] = []
    w = out.append
    w("# EMITTED by scripts/emit-perturbation.py — do not edit; edit the spec.")
    w("# The perturbation presentation (collab/bend2-cubical/port/Perturbation.bend)")
    w(f"# for the panel {panel} with edges {edges}.")
    w("# Contexts are control populations; interventions are knockdowns; the")
    w("# generator family is the one the edge list determines (see the script).")
    w("import MyhillNerodeMinimalMachine")
    w("")
    w("# §1 the finite presentation")
    w("type Gene:")
    for g in G:
        w(f"  case @{g}:")
    w("type Cell:")
    w("  case @cell:")
    for g in G:
        w(f"    {g}: Nat")
    for g in G:
        w(f"def {g}Of(c: Cell) -> Nat:")
        w(f"  match c: case @cell{{{vars_}}}: v_{g}")
    w("type Perturb:")
    w("  case @kd:")
    w("    g: Gene")
    w("  case @passage:")
    w("def knock(g: Gene, c: Cell) -> Cell:")
    w("  match c:")
    w(f"    case @cell{{{vars_}}}:")
    w("      match g:")
    for g in G:
        levels = ", ".join("0n" if h == g else f"v_{h}" for h in G)
        w(f"        case @{g}{{}}: @cell{{{levels}}}")
    w("def step(c: Cell, p: Perturb) -> Cell:")
    w("  match p:")
    w("    case @kd{g}: knock(g, c)")
    w("    case @passage{}:")
    w("      match c:")
    w(f"        case @cell{{{vars_}}}: @cell{{"
      + ", ".join(f"v_{ident(activator[h])}" if h in activator else f"v_{ident(h)}" for h in panel) + "}")
    w("type Step(x: Cell, y: Cell):")
    w("  case @act:")
    w("    p: Perturb")
    w("    ey: Cell{y == step(x, p)}")
    w("type Derivation(x: Cell, z: Cell):")
    w("  case @done:")
    w("    e: Cell{z == x}")
    w("  case @then:")
    w("    y: Cell")
    w("    s: Step(x, y)")
    w("    d: Derivation(y, z)")
    w("def stepPerturb(x: Cell, y: Cell, s: Step(x, y)) -> Perturb:")
    w("  match s: case @act{p, ey}: p")
    w("")
    w("# §2 receiver, fold, uniqueness (AdiBija)")
    w("""type Receiver:
  case @receiver:
    Motion: Cell -> Cell -> Set
    eps: all t: Cell. Motion(t, t)
    cons: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> Motion(b, c) -> Motion(a, c)
def rMotion(R: Receiver, a: Cell, b: Cell) -> Set:
  match R: case @receiver{M, e, k}: M(a, b)
def foldM(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> M(b, c) -> M(a, c), a: Cell, z: Cell, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))
def fold(R: Receiver, a: Cell, z: Cell, d: Derivation(a, z)) -> rMotion(R, a, z):
  match R:
    case @receiver{M, e, k}: foldM(M, e, k, a, z, d)
def fold_unique(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> M(b, c) -> M(a, c),
                g: all a: Cell. all z: Cell. Derivation(a, z) -> M(a, z),
                g_done: all t: Cell. Path(M(t, t), g(t, t, @done{{==}}), e(t)),
                g_step: all a: Cell. all y: Cell. all z: Cell. all s: Step(a, y). all d: Derivation(y, z). Path(M(a, z), g(a, z, @then{y, s, d}), k(a, y, z, s, g(y, z, d))),
                a: Cell, z: Cell, d: Derivation(a, z)) -> Path(M(a, z), g(a, z, d), foldM(M, e, k, a, z, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: g_done(a)
    case @then{y, s, d2}:
      compPath(M(a, z), g(a, z, @then{y, s, d2}), k(a, y, z, s, g(y, z, d2)), k(a, y, z, s, foldM(M, e, k, y, z, d2)),
        g_step(a, y, z, s, d2),
        <i> k(a, y, z, s, fold_unique(M, e, k, g, g_done, g_step, y, z, d2) @ i))""")
    w("")
    w("# §3 readings: length, targeted gene, endpoint, word")
    w("def orB(a: Bool, b: Bool) -> Bool:")
    w("  match a:")
    w("    case True: True")
    w("    case False: b")
    w("def sameGene(g: Gene, g2: Gene) -> Bool:")
    w("  match g:")
    for g in G:
        w(f"    case @{g}{{}}:")
        w("      match g2:")
        for h in G:
            w(f"        case @{h}{{}}: {'True' if h == g else 'False'}")
    w("""def targets(g: Gene, p: Perturb) -> Bool:
  match p:
    case @kd{g2}: sameGene(g, g2)
    case @passage{}: False
def lenM(a: Cell, b: Cell) -> Set:
  Nat
def steps(a: Cell, z: Cell, d: Derivation(a, z)) -> Nat:
  foldM(lenM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)
def hitM(a: Cell, b: Cell) -> Set:
  Bool
def targeted(g: Gene, a: Cell, z: Cell, d: Derivation(a, z)) -> Bool:
  foldM(hitM, lambda t. False, lambda a2. lambda b. lambda c. lambda s. lambda m. orB(targets(g, stepPerturb(a2, b, s)), m), a, z, d)
def endM(a: Cell, b: Cell) -> Set:
  Cell
def endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Cell:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def endpoint_is_endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Path(Cell, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)
def wordM(a: Cell, b: Cell) -> Set:
  Perturb[]
def word(a: Cell, z: Cell, d: Derivation(a, z)) -> Perturb[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepPerturb(a2, b, s) <> w, a, z, d)
def runC(c: Cell, w: Perturb[]) -> Cell:
  run(Cell, Perturb, step, c, w)
def word_replays(a: Cell, z: Cell, d: Derivation(a, z)) -> Path(Cell, runC(a, word(a, z, d)), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      match s:
        case @act{p, ey}:
          match ey: case {==}: word_replays(step(a, p), z, d2)""")
    w("")
    w("# §5 the assay and the behavioural quotient (the protocol reads the assay genes)")
    w("def setNat() -> isSet(Nat):")
    w("  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)")
    # the assay observation: the tuple of assay genes, encoded as a Nat[] (a set)
    w("def assay(c: Cell) -> Nat[]:")
    w("  [" + ", ".join(f"{ident(g)}Of(c)" for g in assay) + "]")
    w("# Nat[] is a set (encode–decode would give it; here it is taken as the")
    w("# generic quotient's one hypothesis, as the corpus's FutureQuotient does)")
    w("def NerodeAssay(setL: isSet(Nat[]), x: Cell, y: Cell) -> Set:")
    w("  Nerode(Cell, Perturb, Nat[], step, assay, x, y)")
    w("def MeaningAssay() -> Set:")
    w("  Meaning(Cell, Perturb, Nat[], step, assay)")
    w("def meaning_is_future(setL: isSet(Nat[]), x: Cell, y: Cell, p: Path(MeaningAssay, @cl{x}, @cl{y})) -> Nerode(Cell, Perturb, Nat[], step, assay, x, y):")
    w("  nerodeEffective(Cell, Perturb, Nat[], step, setL, assay, x, y, p)")
    w("")
    w("# §7 the challenge shape: contexts, submissions, pseudobulk per gene")
    w("def Context() -> Set:")
    w("  Cell[]")
    w("def predict(x: Context, p: Perturb) -> Context:")
    w("  map(Cell, Cell, lambda c. step(c, p), x)")
    for g in G:
        w(f"def pseudobulk_{g}(x: Context) -> Nat:")
        w("  match x:")
        w("    case []: 0n")
        w(f"    case c <> rest: add({g}Of(c), pseudobulk_{g}(rest))")
    for cname, cells in contexts.items():
        cn = ident(cname)
        w(f"def context_{cn}() -> Context:")
        w("  [" + ", ".join(cell_of(c) for c in cells) + "]")
        for g in interventions:
            w(f"def submission_{cn}_kd_{ident(g)}() -> Context:")
            w(f"  predict(predict(context_{cn}(), @kd{{@{ident(g)}}}), @passage)")
    w("")
    w("def main() -> Nat:")
    if contexts and interventions:
        c0 = ident(next(iter(contexts)))
        g0 = ident(interventions[0])
        a0 = ident(assay[0])
        w(f"  pseudobulk_{a0}(submission_{c0}_kd_{g0}())")
    else:
        w("  0n")
    return "\n".join(out) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("spec", type=Path, help="JSON spec (panel, edges, contexts, interventions, assay)")
    ap.add_argument("--csv", action="append", default=[], help="NAME=path: a context's control cells as CSV (header = panel)")
    ap.add_argument("-o", "--out", type=Path, default=None, help="output .bend (default: stdout)")
    args = ap.parse_args()
    spec = load_spec(args.spec, args.csv)
    text = emit(spec)
    if args.out:
        args.out.write_text(text)
        print(f"wrote {args.out} ({len(text.splitlines())} lines)", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()

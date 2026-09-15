#!/usr/bin/env python3
"""emit-spatial.py — the front-end for the spatial presentation.

Reads a points table (SpatialData's Points element as CSV: columns x, y,
gene) and a JSON of segmentations, each a rule assigning a cell id from a
coordinate (axis + sorted cut positions: cell k = the k-th interval), and
emits a Bend file in the shape of collab/bend2-cubical/port/Spatial.bend:

  Gene, Mol (gene, x, y), the field P0 as the list of molecules
  one function per segmentation, the fibre law at each (generic totalEquiv)
  receivers as folds over the field: gene count, the cell-by-gene entry
  refl theorems: every cell-by-gene entry under every segmentation as the
        emitter computes it, certified against the fold by the checker
  the quotient forgetting coordinates: the gene count descends (proved),
        the cell-by-gene entry does not where two same-gene molecules land
        in different cells under a segmentation (emitted as a refutation
        of the resp obligation, computed from the table)
  segmentation dependence: for a gene and a cell where two segmentations
        disagree on the entry, the refutation; where they agree everywhere
        for a gene, the invariance by refl

    python3 scripts/emit-spatial.py points.csv --segs segs.json -o Out.bend
"""
from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path


def ident(x: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_]", "_", x).lower()
    if not s or s[0].isdigit():
        s = "g_" + s
    return s


def cell_of(rule, x, y):
    v = x if rule["axis"] == "x" else y
    k = 0
    for c in rule["cuts"]:
        if v >= c:
            k += 1
    return k


def emit(points, segs):
    genes = sorted({p[2] for p in points})
    G = [ident(g) for g in genes]
    ncells = max(len(r["cuts"]) for r in segs.values()) + 1
    C = [f"c{k}" for k in range(ncells)]
    out = []
    w = out.append
    w("# EMITTED by scripts/emit-spatial.py — do not edit; edit the table / rules.")
    w(f"# {len(points)} molecules, genes {genes}, segmentations {list(segs)} over {ncells} cells")
    w("import SetQuotient")
    w("")
    w("# §1 the presentation")
    w("type Gene:")
    for g in G:
        w(f"  case @{g}:")
    w("type CellId:")
    for c in C:
        w(f"  case @{c}:")
    w("""type Mol:
  case @mol:
    gene: Gene
    x: Nat
    y: Nat
def geneOf(m: Mol) -> Gene:
  match m: case @mol{g, x, y}: g
def xOf(m: Mol) -> Nat:
  match m: case @mol{g, x, y}: x
def yOf(m: Mol) -> Nat:
  match m: case @mol{g, x, y}: y
def ltN(a: Nat, b: Nat) -> Bool:
  match b:
    case 0n: False
    case 1n + q:
      match a:
        case 0n: True
        case 1n + p: ltN(p, q)""")
    w("def P0() -> Mol[]:")
    w("  [" + ", ".join(f"@mol{{@{ident(g)}, {x}n, {y}n}}" for x, y, g in points) + "]")
    # segmentations as nested threshold tests
    for name, rule in segs.items():
        coord = "xOf(m)" if rule["axis"] == "x" else "yOf(m)"
        w(f"def {ident(name)}(m: Mol) -> CellId:")
        cuts = rule["cuts"]
        indent = "  "
        for k, c in enumerate(cuts):
            w(f"{indent}match ltN({coord}, {c}n):")
            w(f"{indent}  case True: @c{k}")
            w(f"{indent}  case False:")
            indent += "    "
        w(f"{indent}@c{len(cuts)}")
    w("")
    w("# §2 the fibre law at a segmentation (fibrelaw.bend, generic)")
    w("""def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)
def tot(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), a, <_> f(a))
def untot(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, a, q):
      a
def tot_sec(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), tot(A, B, f, untot(A, B, f, w)), w):
  match w:
    case (b, a, q):
      <i> (q @ i, a, <j> q @ iand(i, j))
def tot_ret(A: Set, B: Set, f: A -> B, a: A) -> Path(A, untot(A, B, f, tot(A, B, f, a)), a):
  <_> a
def totalEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Total(A, B, f)):
  isoToEquiv(A, Total(A, B, f), tot(A, B, f), untot(A, B, f), tot_sec(A, B, f), tot_ret(A, B, f))""")
    for name in segs:
        w(f"# the molecules ARE the sum over cells of {name}'s fibres; the cell view is the projection")
        w(f"def lossless_{ident(name)}() -> Equiv(Mol, Total(Mol, CellId, {ident(name)})):")
        w(f"  totalEquiv(Mol, CellId, {ident(name)})")
    w("")
    w("# §3 receivers as folds over the field")
    w("def sameGene(g: Gene, g2: Gene) -> Bool:")
    w("  match g:")
    for g in G:
        w(f"    case @{g}{{}}:")
        w("      match g2:")
        for g2 in G:
            w(f"        case @{g2}{{}}: {'True' if g2 == g else 'False'}")
    w("def sameCell(c: CellId, c2: CellId) -> Bool:")
    w("  match c:")
    for c in C:
        w(f"    case @{c}{{}}:")
        w("      match c2:")
        for c2 in C:
            w(f"        case @{c2}{{}}: {'True' if c2 == c else 'False'}")
    w("""def andB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: b
    case False: False
def tick(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
def countGene(g: Gene, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: tick(sameGene(g, geneOf(m)), countGene(g, rest))
def countInCell(s: Mol -> CellId, g: Gene, c: CellId, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: tick(andB(sameGene(g, geneOf(m)), sameCell(c, s(m))), countInCell(s, g, c, rest))""")
    w("")
    w("# §4 the cell-by-gene matrices, as the emitter computes them, certified by refl")
    entries = {}
    for name, rule in segs.items():
        for gi, g in enumerate(genes):
            for k in range(ncells):
                n = sum(1 for x, y, gg in points if gg == g and cell_of(rule, x, y) == k)
                entries[(name, g, k)] = n
                w(f"def cbg_{ident(name)}_{ident(g)}_c{k}() -> Path(Nat, countInCell({ident(name)}, @{ident(g)}, @c{k}, P0()), {n}n):")
                w(f"  <_> {n}n")
    for g in genes:
        n = sum(1 for x, y, gg in points if gg == g)
        w(f"def total_{ident(g)}() -> Path(Nat, countGene(@{ident(g)}, P0()), {n}n):")
        w(f"  <_> {n}n")
    w("")
    w("# §5 erasure = descent: the quotient forgetting coordinates")
    w("""def SameGene(m: Mol, m2: Mol) -> Set:
  Path(Gene, geneOf(m), geneOf(m2))
def SameGeneR() -> Mol -> Mol -> Set:
  lambda m. lambda m2. SameGene(m, m2)
def GeneOnly() -> Set:
  Quotient(Mol, SameGeneR())
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)
# the per-molecule gene contribution descends (it reads the gene only)
def contrib(g: Gene, m: Mol) -> Nat:
  tick(sameGene(g, geneOf(m)), 0n)
def contrib_descends(g: Gene, m: Mol, m2: Mol, r: SameGene(m, m2)) -> Path(Nat, contrib(g, m), contrib(g, m2)):
  <i> tick(sameGene(g, r @ i), 0n)
def contrib_erased(g: Gene, q: GeneOnly) -> Nat:
  quotRec(Mol, SameGeneR(), Nat, setNat(), lambda m. contrib(g, m), lambda m. lambda m2. lambda r. contrib_descends(g, m, m2, r), q)
def cellNum(c: CellId) -> Nat:""")
    w("  match c:")
    for k, c in enumerate(C):
        w(f"    case @{c}{{}}: {k}n")
    # the cell-by-gene contribution does NOT descend: find two same-gene molecules in different cells under a segmentation
    for name, rule in segs.items():
        found = None
        for i in range(len(points)):
            for j in range(i + 1, len(points)):
                a, b = points[i], points[j]
                if a[2] == b[2] and cell_of(rule, a[0], a[1]) != cell_of(rule, b[0], b[1]):
                    found = (a, b)
                    break
            if found:
                break
        if found:
            a, b = found
            ca, cb = cell_of(rule, a[0], a[1]), cell_of(rule, b[0], b[1])
            w(f"# {name}: the cell assignment does not descend — two {a[2]} molecules land in cells {ca} and {cb}")
            w(f"def {ident(name)}_not_descending(h: all m: Mol. all m2: Mol. SameGene(m, m2) -> Path(CellId, {ident(name)}(m), {ident(name)}(m2))) -> Empty:")
            w(f"  natEncode({ca}n, {cb}n, <i> cellNum(h(@mol{{@{ident(a[2])}, {a[0]}n, {a[1]}n}}, @mol{{@{ident(b[2])}, {b[0]}n, {b[1]}n}}, <_> @{ident(a[2])}) @ i))")
    w("")
    w("# §6 segmentation dependence and invariance, on this field")
    names = list(segs)
    if len(names) >= 2:
        s1, s2 = names[0], names[1]
        for g in genes:
            diff = [k for k in range(ncells) if entries[(s1, g, k)] != entries[(s2, g, k)]]
            if diff:
                k = diff[0]
                w(f"def seg_dependent_{ident(g)}_c{k}(p: Path(Nat, countInCell({ident(s1)}, @{ident(g)}, @c{k}, P0()), countInCell({ident(s2)}, @{ident(g)}, @c{k}, P0()))) -> Empty:")
                w(f"  natEncode({entries[(s1, g, k)]}n, {entries[(s2, g, k)]}n, p)")
            else:
                w(f"def seg_invariant_{ident(g)}() -> Path(Nat[], [" + ", ".join(f"countInCell({ident(s1)}, @{ident(g)}, @c{k}, P0())" for k in range(ncells)) + "], [" + ", ".join(f"countInCell({ident(s2)}, @{ident(g)}, @c{k}, P0())" for k in range(ncells)) + "]):")
                w("  <_> [" + ", ".join(f"{entries[(s1, g, k)]}n" for k in range(ncells)) + "]")
    w("")
    w("def main() -> Nat:")
    w(f"  countInCell({ident(names[0])}, @{G[0]}, @c0, P0())")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("points", type=Path, help="CSV with columns x, y, gene")
    ap.add_argument("--segs", type=Path, required=True, help="JSON: name -> {axis, cuts}")
    ap.add_argument("-o", "--out", type=Path, default=None)
    a = ap.parse_args()
    with open(a.points, newline="") as fh:
        rows = list(csv.DictReader(fh))
    points = [(int(float(r["x"])), int(float(r["y"])), r["gene"]) for r in rows]
    segs = json.loads(a.segs.read_text())
    text = emit(points, segs)
    if a.out:
        a.out.write_text(text)
        print(f"wrote {a.out} ({len(text.splitlines())} lines)", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()

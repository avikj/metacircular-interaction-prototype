#!/usr/bin/env python3
"""emit-pangenome.py — the front-end for the pangenome presentation.

Reads a GFA1 file — S (segments with sequences), L (links with orientations
and an M-only overlap CIGAR), P (paths: the embedded haplotypes) — and emits
a Bend file in the shape of collab/bend2-cubical/port/Pangenome.bend:

  Node   = the ORIENTED segments the paths and links use (seg+, seg-);
           the label of seg- is the reverse complement
  Edge   = an indexed family with one constructor per oriented link,
           carrying its overlap length
  Walk   = derivations over Edge; one constant per P line, built by
           following its oriented segments
  folds  = the sequence (labels concatenated, each link's overlap trimmed
           from the next segment — the GFA path sequence), the node path,
           the edge count, and `takes(seg)`: whether a walk traverses a
           segment (the allele call the linear reference records)
  refl   = for every path, its sequence as the emitter computes it,
           certified against the emitted fold by the checker
  fibre  = the fibre law at `takes(seg)` for a chosen segment (a linear
           reference's projection), and — when two paths have the same
           call and differ on some other segment — the two-point fibre
           (`ref_not_equiv` for that segment): reference bias, computed

    python3 scripts/emit-pangenome.py graph.gfa [--ref SEG] -o Out.bend
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

BASE = {"A": 0, "C": 1, "G": 2, "T": 3, "N": 4}
COMP = {"A": "T", "C": "G", "G": "C", "T": "A", "N": "N"}


def ident(x: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_]", "_", x).lower()
    if not s or s[0].isdigit():
        s = "n_" + s
    return s


def onode(seg: str, orient: str) -> str:
    return ident(seg) + ("_p" if orient == "+" else "_m")


def revcomp(seq: str) -> str:
    return "".join(COMP.get(b, "N") for b in reversed(seq.upper()))


def parse_gfa(path: Path):
    segs, links, paths = {}, [], []
    for raw in path.read_text().splitlines():
        if not raw or raw.startswith("#"):
            continue
        f = raw.rstrip("\n").split("\t")
        if f[0] == "S":
            segs[f[1]] = f[2] if f[2] != "*" else ""
        elif f[0] == "L":
            ov = 0
            m = re.fullmatch(r"(\d+)M", f[5]) if len(f) > 5 else None
            if m:
                ov = int(m.group(1))
            links.append((f[1], f[2], f[3], f[4], ov))
        elif f[0] == "P":
            steps = [(s[:-1], s[-1]) for s in f[2].split(",")]
            paths.append((f[1], steps))
    return segs, links, paths


def emit(segs, links, paths, ref_seg: str | None):
    # oriented nodes used anywhere
    nodes: dict[str, tuple[str, str]] = {}
    for a, ao, b, bo, ov in links:
        nodes[onode(a, ao)] = (a, ao)
        nodes[onode(b, bo)] = (b, bo)
        # the reverse-complement link
        nodes[onode(b, "-" if bo == "+" else "+")] = (b, "-" if bo == "+" else "+")
        nodes[onode(a, "-" if ao == "+" else "+")] = (a, "-" if ao == "+" else "+")
    for _, steps in paths:
        for s, o in steps:
            nodes[onode(s, o)] = (s, o)
    node_list = sorted(nodes)

    def lab(n):
        s, o = nodes[n]
        seq = segs.get(s, "")
        return seq.upper() if o == "+" else revcomp(seq)

    # edges: each link and its reverse complement, deduplicated
    edges: dict[tuple[str, str], tuple[str, int]] = {}
    for a, ao, b, bo, ov in links:
        x, y = onode(a, ao), onode(b, bo)
        edges.setdefault((x, y), (f"e_{x}_{y}", ov))
        rx, ry = onode(b, "-" if bo == "+" else "+"), onode(a, "-" if ao == "+" else "+")
        edges.setdefault((rx, ry), (f"e_{rx}_{ry}", ov))

    # path walks and their sequences (with overlap trimming)
    walks = []
    for name, steps in paths:
        ns = [onode(s, o) for s, o in steps]
        seq = lab(ns[0])
        for i in range(len(ns) - 1):
            if (ns[i], ns[i + 1]) not in edges:
                sys.exit(f"path {name}: no link {ns[i]} -> {ns[i+1]}")
            ov = edges[(ns[i], ns[i + 1])][1]
            seq += lab(ns[i + 1])[ov:]
        walks.append((ident(name), ns, seq))

    out = []
    w = out.append
    w("# EMITTED by scripts/emit-pangenome.py — do not edit; edit the GFA.")
    w(f"# segments {sorted(segs)}; links {len(links)}; paths {[p[0] for p in paths]}")
    w("import Prelude")
    w("")
    w("# §1 oriented segments, labels, links, walks")
    w("type Node:")
    for n in node_list:
        w(f"  case @{n}:")
    w("def label(n: Node) -> Nat[]:")
    w("  match n:")
    for n in node_list:
        w(f"    case @{n}{{}}: [" + ", ".join(f"{BASE.get(b, 4)}n" for b in lab(n)) + "]")
    w("type Edge(x: Node, y: Node):")
    for (x, y), (en, ov) in edges.items():
        w(f"  case @{en}:")
        w(f"    ex: Node{{x == @{x}}}")
        w(f"    ey: Node{{y == @{y}}}")
    w("def overlap(x: Node, y: Node, e: Edge(x, y)) -> Nat:")
    w("  match e:")
    for (x, y), (en, ov) in edges.items():
        w(f"    case @{en}{{ex, ey}}: {ov}n")
    w("""type Walk(x: Node, z: Node):
  case @stop:
    e: Node{z == x}
  case @go:
    y: Node
    e: Edge(x, y)
    w: Walk(y, z)""")
    for name, ns, seq in walks:
        w(f"def {name}() -> Walk(@{ns[0]}, @{ns[-1]}):")
        term = "@stop{{==}}"
        for i in range(len(ns) - 2, -1, -1):
            en = edges[(ns[i], ns[i + 1])][0]
            term = f"@go{{@{ns[i+1]}, @{en}{{{{==}}, {{==}}}}, {term}}}"
        w(f"  {term}")
    w("")
    w("# §2 receivers as folds")
    w("""def foldW(M: Node -> Node -> Set, e: all t: Node. M(t, t), k: all a: Node. all b: Node. all c: Node. Edge(a, b) -> M(b, c) -> M(a, c), a: Node, z: Node, w: Walk(a, z)) -> M(a, z):
  match w:
    case @stop{eq}:
      match eq: case {==}: e(a)
    case @go{y, ed, w2}:
      k(a, y, z, ed, foldW(M, e, k, y, z, w2))
def app(xs: Nat[], ys: Nat[]) -> Nat[]:
  match xs:
    case []: ys
    case h <> t: h <> app(t, ys)
def drop(n: Nat, xs: Nat[]) -> Nat[]:
  match n:
    case 0n: xs
    case 1n + p:
      match xs:
        case []: []
        case h <> t: drop(p, t)
def seqM(a: Node, b: Node) -> Set:
  Nat[]
# the path sequence: each link's overlap is trimmed from the segment it enters
def sequence(a: Node, z: Node, w: Walk(a, z)) -> Nat[]:
  foldW(seqM, lambda t. label(t), lambda a2. lambda b. lambda c. lambda ed. lambda m. app(label(a2), drop(overlap(a2, b, ed), m)), a, z, w)
def pathM(a: Node, b: Node) -> Set:
  Node[]
def nodePath(a: Node, z: Node, w: Walk(a, z)) -> Node[]:
  foldW(pathM, lambda t. [t], lambda a2. lambda b. lambda c. lambda ed. lambda m. a2 <> m, a, z, w)
def natM(a: Node, b: Node) -> Set:
  Nat
def edges(a: Node, z: Node, w: Walk(a, z)) -> Nat:
  foldW(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda ed. lambda n. 1n + n, a, z, w)
def orB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: True
    case False: b
def boolM(a: Node, b: Node) -> Set:
  Bool""")
    w("def sameNode(n: Node, m: Node) -> Bool:")
    w("  match n:")
    for n in node_list:
        w(f"    case @{n}{{}}:")
        w("      match m:")
        for m2 in node_list:
            w(f"        case @{m2}{{}}: {'True' if m2 == n else 'False'}")
    w("# the allele call: does the walk traverse this oriented segment")
    w("def takes(n: Node, a: Node, z: Node, w: Walk(a, z)) -> Bool:")
    w("  foldW(boolM, lambda t. sameNode(t, n), lambda a2. lambda b. lambda c. lambda ed. lambda m. orB(sameNode(a2, n), m), a, z, w)")
    w("")
    w("# §3 the emitter's sequences, certified against the fold by refl")
    for name, ns, seq in walks:
        lit = "[" + ", ".join(f"{BASE.get(b, 4)}n" for b in seq) + "]"
        w(f"def seq_{name}() -> Path(Nat[], sequence(@{ns[0]}, @{ns[-1]}, {name}()), {lit}):")
        w(f"  <_> {lit}")
    w("")
    w("# §4 the fibre law at a reference projection (fibrelaw.bend, generic)")
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
  isoToEquiv(A, Total(A, B, f), tot(A, B, f), untot(A, B, f), tot_sec(A, B, f), tot_ret(A, B, f))
def bit(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n""")
    # group walks by endpoints; pick a reference segment
    groups: dict[tuple[str, str], list] = {}
    for name, ns, seq in walks:
        groups.setdefault((ns[0], ns[-1]), []).append((name, ns, seq))
    first_main = None
    for (s0, s1), grp in groups.items():
        hap = f"Hap_{s0}_{s1}"
        w(f"def {hap}() -> Set:")
        w(f"  Walk(@{s0}, @{s1})")
        # candidate reference nodes: those traversed by some but not all walks in the group (a bubble allele)
        cands = [n for n in node_list if 0 < sum(n in ns for _, ns, _ in grp) < len(grp)] if len(grp) > 1 else []
        if ref_seg:
            pref = [n for n in node_list if nodes[n][0] == ref_seg]
            cands = pref + [c for c in cands if c not in pref]
        if not cands and grp:
            cands = [grp[0][1][1] if len(grp[0][1]) > 1 else grp[0][1][0]]
        rn = cands[0]
        w(f"# the linear reference records whether the walk traverses @{rn}")
        w(f"def callRef_{hap}(w: {hap}) -> Bool:")
        w(f"  takes(@{rn}, @{s0}, @{s1}, w)")
        w(f"def lossless_{hap}() -> Equiv({hap}, Total({hap}, Bool, callRef_{hap})):")
        w(f"  totalEquiv({hap}, Bool, callRef_{hap})")
        # two walks with the same call that differ on another node
        pair = None
        for i in range(len(grp)):
            for j in range(i + 1, len(grp)):
                ni, nj = grp[i][1], grp[j][1]
                if (rn in ni) == (rn in nj):
                    diff = [n for n in node_list if (n in ni) != (n in nj)]
                    if diff:
                        pair = (grp[i], grp[j], diff[0], rn in ni)
                        break
            if pair:
                break
        if pair:
            (na, nsa, _), (nb, nsb, _), dn, call = pair
            cv = "True" if call else "False"
            w(f"# {na} and {nb}: the same call at @{rn}, different at @{dn}")
            w(f"def same_call_{na}_{nb}() -> Path(Bool, callRef_{hap}({na}()), callRef_{hap}({nb}())):")
            w(f"  <_> {cv}")
            a_has = "1n" if dn in nsa else "0n"
            b_has = "1n" if dn in nsb else "0n"
            w(f"def walks_differ_{na}_{nb}(p: Path({hap}, {na}(), {nb}())) -> Empty:")
            w(f"  natEncode({a_has}, {b_has}, <i> bit(takes(@{dn}, @{s0}, @{s1}, p @ i)))")
            w(f"def fib_{na}() -> fiber({hap}, Bool, callRef_{hap}, {cv}):")
            w(f"  ({na}(), <_> {cv})")
            w(f"def fib_{nb}() -> fiber({hap}, Bool, callRef_{hap}, {cv}):")
            w(f"  ({nb}(), <_> {cv})")
            w(f"def fibre_points_differ_{na}_{nb}(p: Path(fiber({hap}, Bool, callRef_{hap}, {cv}), fib_{na}(), fib_{nb}())) -> Empty:")
            w(f"  walks_differ_{na}_{nb}(<i> fst({hap}, lambda w. Path(Bool, callRef_{hap}(w), {cv}), p @ i))")
            w(f"# REFERENCE BIAS, computed: the fibre of the reference projection over {cv} is not a point")
            w(f"def ref_not_contractible_{hap}(c: isContr(fiber({hap}, Bool, callRef_{hap}, {cv}))) -> Empty:")
            w("  match c:")
            w("    case (centre, h):")
            w(f"      fibre_points_differ_{na}_{nb}(compPath(fiber({hap}, Bool, callRef_{hap}, {cv}), fib_{na}(), centre, fib_{nb}(), <i> h(fib_{na}()) @ inot(i), h(fib_{nb}())))")
            w(f"def ref_not_equiv_{hap}(h: isEquiv({hap}, Bool, callRef_{hap})) -> Empty:")
            w(f"  ref_not_contractible_{hap}(h({cv}))")
        first_main = first_main or grp[0]
    w("")
    w("def main() -> Nat:")
    if first_main:
        name, ns, seq = first_main
        w(f"  length(Nat, sequence(@{ns[0]}, @{ns[-1]}, {name}()))")
    else:
        w("  0n")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("gfa", type=Path)
    ap.add_argument("--ref", default=None, help="segment id whose traversal the linear reference records")
    ap.add_argument("-o", "--out", type=Path, default=None)
    a = ap.parse_args()
    segs, links, paths = parse_gfa(a.gfa)
    text = emit(segs, links, paths, a.ref)
    if a.out:
        a.out.write_text(text)
        print(f"wrote {a.out} ({len(text.splitlines())} lines)", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()

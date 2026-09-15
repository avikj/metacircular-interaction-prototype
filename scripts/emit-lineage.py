#!/usr/bin/env python3
"""emit-lineage.py — the front-end for the lineage presentation.

Reads a Newick tree (the lineage-tracing reconstruction: internal nodes are
divisions, leaves are the observed cells) with an optional map from leaf
names to a kind (the multimodal terminal state), and emits a Bend file in
the shape of collab/bend2-cubical/port/Lineage.bend:

  Kind      the kinds observed at the leaves (by prefix of the leaf name:
            letters before digits; or --kinds name=kind,...)
  Fate      the question at every state: @divide, or @commit{k} — the
            cell takes kind k (the fate the tree's leaf records)
  Body      (generation, kind); `grow` is the generator
  Lineage n b = Answers(Body, FateQ, grow, n, b): a lineage record IS the
            answer stream of the interactive machine (run-is-answers)
  one record per leaf: its root-to-leaf history (a division per internal
            node passed, then the commit), with its terminal body by refl
  the unresolved history: leaves with the SAME terminal reading (gen, kind)
            and DIFFERENT records give two points in the fibre of the
            terminal projection — `unresolved_not_contractible` for that
            reading, computed from the tree, not assumed

    python3 scripts/emit-lineage.py tree.nwk [--kinds n=neuron,a=astro] -o Out.bend

Branch lengths are read and ignored (the calculus counts divisions, not
time); a tree with polytomies is fine (each child is one more division of
the same parent state — the record keeps the order the file gives).
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


def ident(x: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_]", "_", x).lower()
    if not s or s[0].isdigit():
        s = "l_" + s
    return s


class N:
    def __init__(self):
        self.name = ""
        self.children = []


def parse_newick(s: str) -> N:
    s = s.strip()
    if s.endswith(";"):
        s = s[:-1]
    pos = 0

    def node() -> N:
        nonlocal pos
        n = N()
        if pos < len(s) and s[pos] == "(":
            pos += 1
            while True:
                n.children.append(node())
                if s[pos] == ",":
                    pos += 1
                    continue
                if s[pos] == ")":
                    pos += 1
                    break
        m = re.match(r"[^,:)(;]*", s[pos:])
        n.name = m.group(0).strip()
        pos += len(m.group(0))
        if pos < len(s) and s[pos] == ":":
            pos += 1
            m = re.match(r"[^,)(;]*", s[pos:])
            pos += len(m.group(0))
        return n

    return node()


def leaves(n: N, path):
    if not n.children:
        yield n, path
    else:
        for c in n.children:
            yield from leaves(c, path + [n])


def emit(root: N, kinds_map: dict[str, str]):
    lv = list(leaves(root, []))
    if not lv:
        sys.exit("no leaves")

    def kind_of(name: str) -> str:
        if name in kinds_map:
            return kinds_map[name]
        m = re.match(r"[A-Za-z_]+", name)
        return m.group(0) if m else "cell"

    kinds = sorted({kind_of(n.name) for n, _ in lv})
    K = [ident(k) for k in kinds]
    records = []  # (leaf ident, kind ident, depth)
    for n, path in lv:
        records.append((ident(n.name or f"leaf{len(records)}"), ident(kind_of(n.name)), len(path)))

    out = []
    w = out.append
    w("# EMITTED by scripts/emit-lineage.py — do not edit; edit the tree.")
    w(f"# leaves {[r[0] for r in records]}; kinds {kinds}")
    w("import Prelude")
    w("")
    w("# §1 the interaction at depth n (interaction.bend / Lineage.bend, verbatim)")
    w("""def Answers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Set:
  match n:
    case 0n:
      Unit
    case 1n + p:
      any a: Q(x). Answers(X, Q, d, p, d(x, a))
def IExec(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Set:
  match n:
    case 0n:
      Unit
    case 1n + p:
      any now: X. any here: Path(X, now, x). any a: Q(x). IExec(X, Q, d, p, d(x, a))
def forgetStates(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, e: IExec(X, Q, d, n, x)) -> Answers(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match e:
        case (now, here, a, rest):
          (a, forgetStates(X, Q, d, p, d(x, a), rest))
def replay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, s: Answers(X, Q, d, n, x)) -> IExec(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match s:
        case (a, more):
          (x, <_> x, a, replay(X, Q, d, p, d(x, a), more))
def forgetReplayS(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, p: Nat, x: X, s: Answers(X, Q, d, 1n + p, x)) -> Path(Answers(X, Q, d, 1n + p, x), forgetStates(X, Q, d, 1n + p, x, replay(X, Q, d, 1n + p, x, s)), s):
  match s:
    case (a, more):
      <i> (a, forgetReplay(X, Q, d, p, d(x, a), more) @ i)
def forgetReplay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, s: Answers(X, Q, d, n, x)) -> Path(Answers(X, Q, d, n, x), forgetStates(X, Q, d, n, x, replay(X, Q, d, n, x, s)), s):
  match n:
    case 0n:
      match s:
        case ():
          <_> ()
    case 1n + p:
      forgetReplayS(X, Q, d, p, x, s)
def replayForgetS(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, p: Nat, x: X, e: IExec(X, Q, d, 1n + p, x)) -> Path(IExec(X, Q, d, 1n + p, x), replay(X, Q, d, 1n + p, x, forgetStates(X, Q, d, 1n + p, x, e)), e):
  match e:
    case (now, here, a, rest):
      <i> (here @ inot(i), <j> here @ ior(inot(i), j), a, replayForget(X, Q, d, p, d(x, a), rest) @ i)
def replayForget(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, e: IExec(X, Q, d, n, x)) -> Path(IExec(X, Q, d, n, x), replay(X, Q, d, n, x, forgetStates(X, Q, d, n, x, e)), e):
  match n:
    case 0n:
      match e:
        case ():
          <_> ()
    case 1n + p:
      replayForgetS(X, Q, d, p, x, e)
def runIsAnswers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Equiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x)):
  isoToEquiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x),
             lambda e. forgetStates(X, Q, d, n, x, e), lambda s. replay(X, Q, d, n, x, s),
             lambda s. forgetReplay(X, Q, d, n, x, s), lambda e. replayForget(X, Q, d, n, x, e))""")
    w("")
    w("# §2 the kinds, the fates, the body, the generator")
    w("type Kind:")
    w("  case @undetermined:")
    for k in K:
        w(f"  case @{k}:")
    w("def kindNat(k: Kind) -> Nat:")
    w("  match k:")
    w("    case @undetermined{}: 0n")
    for i, k in enumerate(K):
        w(f"    case @{k}{{}}: {i+1}n")
    w("""type Fate:
  case @divide:
  case @commit:
    k: Kind
type Body:
  case @body:
    gen: Nat
    kind: Kind
def genOf(b: Body) -> Nat:
  match b: case @body{g, k}: g
def kindOf(b: Body) -> Kind:
  match b: case @body{g, k}: k
def FateQ(b: Body) -> Set:
  Fate
def grow(b: Body, f: Fate) -> Body:
  match b:
    case @body{g, k}:
      match f:
        case @divide{}: @body{1n + g, k}
        case @commit{k2}: @body{g, k2}
def Lineage(n: Nat, b: Body) -> Set:
  Answers(Body, FateQ, grow, n, b)
def History(n: Nat, b: Body) -> Set:
  IExec(Body, FateQ, grow, n, b)
# the lineage record IS the history (run-is-answers), at every depth
def lineage_is_history(n: Nat, b: Body) -> Equiv(History(n, b), Lineage(n, b)):
  runIsAnswers(Body, FateQ, grow, n, b)
def terminal(n: Nat, b: Body, s: Lineage(n, b)) -> Body:
  match n:
    case 0n: b
    case 1n + p:
      match s:
        case (f, more): terminal(p, grow(b, f), more)
def zygote() -> Body:
  @body{0n, @undetermined}""")
    w("")
    w("# §3 one record per leaf: its root-to-leaf history, and its terminal body by refl")
    for name, k, depth in records:
        n = depth + 1
        term = "()"
        term = f"(@commit{{@{k}}}, {term})"
        for _ in range(depth):
            term = f"(@divide, {term})"
        w(f"def rec_{name}() -> Lineage({n}n, zygote()):")
        w(f"  {term}")
        w(f"def term_{name}() -> Path(Body, terminal({n}n, zygote(), rec_{name}()), @body{{{depth}n, @{k}}}):")
        w(f"  <_> @body{{{depth}n, @{k}}}")
    w("")
    w("# §4 the measurement reads the terminal (gen, kind); the unresolved history")
    w("# is the fibre of that reading, and it is not a point where two leaves share a reading")
    w("def readout(b: Body) -> Nat:")
    w(f"  add(mul({len(K)+1}n, genOf(b)), kindNat(kindOf(b)))")
    w("""def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))
def fateNat(f: Fate) -> Nat:
  match f:
    case @divide{}: 0n
    case @commit{k}: 1n + kindNat(k)""")
    # find two leaves with the same (depth, kind) — their records differ only if depths differ... same depth and kind → same record! (a record here is divide^depth then commit k). So an unresolved pair needs the tree's *positions* to enter the record.
    # The record must carry which child was taken: encode a division as @divide with the child index -> use @left/@right? Newick may have polytomies; use @child{i: Nat}.
    return out, records, K


def emit_full(root: N, kinds_map):
    # richer records: each division records the child index taken, so two leaves at the same depth
    # with the same kind are distinct records with the same terminal reading — the unresolved history
    lv = list(leaves(root, []))

    def kind_of(name):
        if name in kinds_map:
            return kinds_map[name]
        m = re.match(r"[A-Za-z_]+", name)
        return m.group(0) if m else "cell"

    kinds = sorted({kind_of(n.name) for n, _ in lv})
    K = [ident(k) for k in kinds]
    recs = []
    for n, path in lv:
        # child indices along the path
        idx = []
        for parent, child in zip(path, path[1:] + [n]):
            idx.append(parent.children.index(child))
        recs.append((ident(n.name or f"leaf{len(recs)}"), ident(kind_of(n.name)), idx))
    out = []
    w = out.append
    base, _, _ = emit(root, kinds_map)
    # take §1 and §2 from base but replace Fate/grow with the child-indexed version
    text = "\n".join(base)
    text = text.replace("""type Fate:
  case @divide:
  case @commit:
    k: Kind""", """type Fate:
  case @divide:
    child: Nat
  case @commit:
    k: Kind""")
    text = text.replace("        case @divide{}: @body{1n + g, k}", "        case @divide{c}: @body{1n + g, k}")
    text = text.replace("    case @divide{}: 0n\n    case @commit{k}: 1n + kindNat(k)", "    case @divide{c}: 0n\n    case @commit{k}: 1n + kindNat(k)")
    # cut base at §3 and regenerate §3/§4 with child indices
    text = text[: text.index("# §3 one record per leaf")]
    out = text.split("\n")
    w = out.append
    w("# §3 one record per leaf: its root-to-leaf history (each division records the")
    w("# child taken), and its terminal body by refl")
    for name, k, idx in recs:
        depth = len(idx)
        term = f"(@commit{{@{k}}}, ())"
        for i in reversed(idx):
            term = f"(@divide{{{i}n}}, {term})"
        w(f"def rec_{name}() -> Lineage({depth+1}n, zygote()):")
        w(f"  {term}")
        w(f"def term_{name}() -> Path(Body, terminal({depth+1}n, zygote(), rec_{name}()), @body{{{depth}n, @{k}}}):")
        w(f"  <_> @body{{{depth}n, @{k}}}")
    w("")
    w("# §4 the measurement reads the terminal (gen, kind); the unresolved history is")
    w("# the fibre of that reading; where two leaves share a reading it is not a point")
    w("""def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))""")
    w("def readout(b: Body) -> Nat:")
    w(f"  add(mul({len(K)+1}n, genOf(b)), kindNat(kindOf(b)))")
    w("""def observe(n: Nat, s: Lineage(n, zygote())) -> Nat:
  readout(terminal(n, zygote(), s))
def Unresolved(n: Nat, o: Nat) -> Set:
  fiber(Lineage(n, zygote()), Nat, lambda s. observe(n, s), o)""")
    # first child index along a record, as a Nat, to separate records
    w("""def firstChild(n: Nat, s: Lineage(n, zygote())) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p:
      match s:
        case (f, more):
          match f:
            case @divide{c}: c
            case @commit{k}: 0n""")
    # a per-depth child extractor: childAt(d) reads the d-th fate's child index
    w("""def childAt(d: Nat, n: Nat, b: Body, s: Lineage(n, b)) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p:
      match s:
        case (f, more):
          match d:
            case 0n:
              match f:
                case @divide{c}: c
                case @commit{k}: 0n
            case 1n + q: childAt(q, p, grow(b, f), more)""")
    # find pairs with same (depth, kind) and different idx
    done = set()
    pairs = []
    for i in range(len(recs)):
        for j in range(i + 1, len(recs)):
            a, b = recs[i], recs[j]
            if len(a[2]) == len(b[2]) and a[1] == b[1] and a[2] != b[2]:
                key = (len(a[2]), a[1])
                if key in done:
                    continue
                done.add(key)
                pairs.append((a, b))
    for (na, ka, ia), (nb, kb, ib) in pairs:
        depth = len(ia)
        n = depth + 1
        o = (len(K) + 1) * depth + (K.index(ka) + 1)
        d = next(t for t in range(depth) if ia[t] != ib[t])
        w(f"# {na} and {nb}: same terminal reading {o}, different histories (they part at division {d})")
        w(f"def same_reading_{na}_{nb}() -> Path(Nat, observe({n}n, rec_{na}()), observe({n}n, rec_{nb}())):")
        w(f"  <_> {o}n")
        w(f"def records_differ_{na}_{nb}(p: Path(Lineage({n}n, zygote()), rec_{na}(), rec_{nb}())) -> Empty:")
        w(f"  natEncode({ia[d]}n, {ib[d]}n, <i> childAt({d}n, {n}n, zygote(), p @ i))")
        w(f"def pt_{na}() -> Unresolved({n}n, {o}n):")
        w(f"  (rec_{na}(), <_> {o}n)")
        w(f"def pt_{nb}() -> Unresolved({n}n, {o}n):")
        w(f"  (rec_{nb}(), <_> {o}n)")
        w(f"def unresolved_points_differ_{na}_{nb}(p: Path(Unresolved({n}n, {o}n), pt_{na}(), pt_{nb}())) -> Empty:")
        w(f"  records_differ_{na}_{nb}(<i> fst(Lineage({n}n, zygote()), lambda s. Path(Nat, observe({n}n, s), {o}n), p @ i))")
        w(f"def unresolved_not_contractible_{na}_{nb}(c: isContr(Unresolved({n}n, {o}n))) -> Empty:")
        w("  match c:")
        w("    case (centre, h):")
        w(f"      unresolved_points_differ_{na}_{nb}(compPath(Unresolved({n}n, {o}n), pt_{na}(), centre, pt_{nb}(), <i> h(pt_{na}()) @ inot(i), h(pt_{nb}())))")
    w("")
    w("def main() -> Nat:")
    na, ka, ia = recs[0]
    w(f"  observe({len(ia)+1}n, rec_{na}())")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("newick", type=Path)
    ap.add_argument("--kinds", default="", help="prefix=kind,... (default: the letters prefix of the leaf name)")
    ap.add_argument("-o", "--out", type=Path, default=None)
    a = ap.parse_args()
    kinds_map = {}
    for kv in filter(None, a.kinds.split(",")):
        k, v = kv.split("=")
        kinds_map[k] = v
    root = parse_newick(a.newick.read_text())
    # map by prefix if requested
    if kinds_map:
        lv = list(leaves(root, []))
        full = {}
        for n, _ in lv:
            for pref, kind in kinds_map.items():
                if n.name.startswith(pref):
                    full[n.name] = kind
        kinds_map = full
    text = emit_full(root, kinds_map)
    if a.out:
        a.out.write_text(text)
        print(f"wrote {a.out} ({len(text.splitlines())} lines)", file=sys.stderr)
    else:
        sys.stdout.write(text)


if __name__ == "__main__":
    main()

# EMITTED by scripts/emit-pangenome.py — do not edit; edit the GFA.
# segments ['11', '12', '13']; links 3; paths ['14']
import Prelude

# §1 oriented segments, labels, links, walks
type Node:
  case @n_11_m:
  case @n_11_p:
  case @n_12_m:
  case @n_12_p:
  case @n_13_m:
  case @n_13_p:
def label(n: Node) -> Nat[]:
  match n:
    case @n_11_m{}: [0n, 0n, 2n, 2n, 3n]
    case @n_11_p{}: [0n, 1n, 1n, 3n, 3n]
    case @n_12_m{}: [1n, 1n, 3n, 3n, 2n, 0n]
    case @n_12_p{}: [3n, 1n, 0n, 0n, 2n, 2n]
    case @n_13_m{}: [0n, 0n, 3n, 1n, 0n, 0n, 2n]
    case @n_13_p{}: [1n, 3n, 3n, 2n, 0n, 3n, 3n]
type Edge(x: Node, y: Node):
  case @e_n_11_p_n_12_m:
    ex: Node{x == @n_11_p}
    ey: Node{y == @n_12_m}
  case @e_n_12_p_n_11_m:
    ex: Node{x == @n_12_p}
    ey: Node{y == @n_11_m}
  case @e_n_12_m_n_13_p:
    ex: Node{x == @n_12_m}
    ey: Node{y == @n_13_p}
  case @e_n_13_m_n_12_p:
    ex: Node{x == @n_13_m}
    ey: Node{y == @n_12_p}
  case @e_n_11_p_n_13_p:
    ex: Node{x == @n_11_p}
    ey: Node{y == @n_13_p}
  case @e_n_13_m_n_11_m:
    ex: Node{x == @n_13_m}
    ey: Node{y == @n_11_m}
def overlap(x: Node, y: Node, e: Edge(x, y)) -> Nat:
  match e:
    case @e_n_11_p_n_12_m{ex, ey}: 4n
    case @e_n_12_p_n_11_m{ex, ey}: 4n
    case @e_n_12_m_n_13_p{ex, ey}: 5n
    case @e_n_13_m_n_12_p{ex, ey}: 5n
    case @e_n_11_p_n_13_p{ex, ey}: 3n
    case @e_n_13_m_n_11_m{ex, ey}: 3n
type Walk(x: Node, z: Node):
  case @stop:
    e: Node{z == x}
  case @go:
    y: Node
    e: Edge(x, y)
    w: Walk(y, z)
def n_14() -> Walk(@n_11_p, @n_13_p):
  @go{@n_12_m, @e_n_11_p_n_12_m{{==}, {==}}, @go{@n_13_p, @e_n_12_m_n_13_p{{==}, {==}}, @stop{{==}}}}

# §2 receivers as folds
def foldW(M: Node -> Node -> Set, e: all t: Node. M(t, t), k: all a: Node. all b: Node. all c: Node. Edge(a, b) -> M(b, c) -> M(a, c), a: Node, z: Node, w: Walk(a, z)) -> M(a, z):
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
  Bool
def sameNode(n: Node, m: Node) -> Bool:
  match n:
    case @n_11_m{}:
      match m:
        case @n_11_m{}: True
        case @n_11_p{}: False
        case @n_12_m{}: False
        case @n_12_p{}: False
        case @n_13_m{}: False
        case @n_13_p{}: False
    case @n_11_p{}:
      match m:
        case @n_11_m{}: False
        case @n_11_p{}: True
        case @n_12_m{}: False
        case @n_12_p{}: False
        case @n_13_m{}: False
        case @n_13_p{}: False
    case @n_12_m{}:
      match m:
        case @n_11_m{}: False
        case @n_11_p{}: False
        case @n_12_m{}: True
        case @n_12_p{}: False
        case @n_13_m{}: False
        case @n_13_p{}: False
    case @n_12_p{}:
      match m:
        case @n_11_m{}: False
        case @n_11_p{}: False
        case @n_12_m{}: False
        case @n_12_p{}: True
        case @n_13_m{}: False
        case @n_13_p{}: False
    case @n_13_m{}:
      match m:
        case @n_11_m{}: False
        case @n_11_p{}: False
        case @n_12_m{}: False
        case @n_12_p{}: False
        case @n_13_m{}: True
        case @n_13_p{}: False
    case @n_13_p{}:
      match m:
        case @n_11_m{}: False
        case @n_11_p{}: False
        case @n_12_m{}: False
        case @n_12_p{}: False
        case @n_13_m{}: False
        case @n_13_p{}: True
# the allele call: does the walk traverse this oriented segment
def takes(n: Node, a: Node, z: Node, w: Walk(a, z)) -> Bool:
  foldW(boolM, lambda t. sameNode(t, n), lambda a2. lambda b. lambda c. lambda ed. lambda m. orB(sameNode(a2, n), m), a, z, w)

# §3 the emitter's sequences, certified against the fold by refl
def seq_n_14() -> Path(Nat[], sequence(@n_11_p, @n_13_p, n_14()), [0n, 1n, 1n, 3n, 3n, 2n, 0n, 3n, 3n]):
  <_> [0n, 1n, 1n, 3n, 3n, 2n, 0n, 3n, 3n]

# §4 the fibre law at a reference projection (fibrelaw.bend, generic)
def Total(A: Set, B: Set, f: A -> B) -> Set:
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
    case False: 0n
def Hap_n_11_p_n_13_p() -> Set:
  Walk(@n_11_p, @n_13_p)
# the linear reference records whether the walk traverses @n_12_m
def callRef_Hap_n_11_p_n_13_p(w: Hap_n_11_p_n_13_p) -> Bool:
  takes(@n_12_m, @n_11_p, @n_13_p, w)
def lossless_Hap_n_11_p_n_13_p() -> Equiv(Hap_n_11_p_n_13_p, Total(Hap_n_11_p_n_13_p, Bool, callRef_Hap_n_11_p_n_13_p)):
  totalEquiv(Hap_n_11_p_n_13_p, Bool, callRef_Hap_n_11_p_n_13_p)

def main() -> Nat:
  length(Nat, sequence(@n_11_p, @n_13_p, n_14()))

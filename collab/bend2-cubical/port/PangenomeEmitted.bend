# EMITTED by scripts/emit-pangenome.py — do not edit; edit the GFA.
# segments ['altA', 'insB', 'mid', 'refA', 'refB', 'snk', 'src']; links 8; paths ['H1', 'H2', 'H3', 'H4']
import Prelude

# §1 oriented segments, labels, links, walks
type Node:
  case @alta_m:
  case @alta_p:
  case @insb_m:
  case @insb_p:
  case @mid_m:
  case @mid_p:
  case @refa_m:
  case @refa_p:
  case @refb_m:
  case @refb_p:
  case @snk_m:
  case @snk_p:
  case @src_m:
  case @src_p:
def label(n: Node) -> Nat[]:
  match n:
    case @alta_m{}: [1n]
    case @alta_p{}: [2n]
    case @insb_m{}: [2n, 1n, 2n]
    case @insb_p{}: [1n, 2n, 1n]
    case @mid_m{}: [0n]
    case @mid_p{}: [3n]
    case @refa_m{}: [2n]
    case @refa_p{}: [1n]
    case @refb_m{}: [2n, 2n]
    case @refb_p{}: [1n, 1n]
    case @snk_m{}: [3n]
    case @snk_p{}: [0n]
    case @src_m{}: [3n]
    case @src_p{}: [0n]
type Edge(x: Node, y: Node):
  case @e_src_p_refa_p:
    ex: Node{x == @src_p}
    ey: Node{y == @refa_p}
  case @e_refa_m_src_m:
    ex: Node{x == @refa_m}
    ey: Node{y == @src_m}
  case @e_src_p_alta_p:
    ex: Node{x == @src_p}
    ey: Node{y == @alta_p}
  case @e_alta_m_src_m:
    ex: Node{x == @alta_m}
    ey: Node{y == @src_m}
  case @e_refa_p_mid_p:
    ex: Node{x == @refa_p}
    ey: Node{y == @mid_p}
  case @e_mid_m_refa_m:
    ex: Node{x == @mid_m}
    ey: Node{y == @refa_m}
  case @e_alta_p_mid_p:
    ex: Node{x == @alta_p}
    ey: Node{y == @mid_p}
  case @e_mid_m_alta_m:
    ex: Node{x == @mid_m}
    ey: Node{y == @alta_m}
  case @e_mid_p_refb_p:
    ex: Node{x == @mid_p}
    ey: Node{y == @refb_p}
  case @e_refb_m_mid_m:
    ex: Node{x == @refb_m}
    ey: Node{y == @mid_m}
  case @e_mid_p_insb_p:
    ex: Node{x == @mid_p}
    ey: Node{y == @insb_p}
  case @e_insb_m_mid_m:
    ex: Node{x == @insb_m}
    ey: Node{y == @mid_m}
  case @e_refb_p_snk_p:
    ex: Node{x == @refb_p}
    ey: Node{y == @snk_p}
  case @e_snk_m_refb_m:
    ex: Node{x == @snk_m}
    ey: Node{y == @refb_m}
  case @e_insb_p_snk_p:
    ex: Node{x == @insb_p}
    ey: Node{y == @snk_p}
  case @e_snk_m_insb_m:
    ex: Node{x == @snk_m}
    ey: Node{y == @insb_m}
def overlap(x: Node, y: Node, e: Edge(x, y)) -> Nat:
  match e:
    case @e_src_p_refa_p{ex, ey}: 0n
    case @e_refa_m_src_m{ex, ey}: 0n
    case @e_src_p_alta_p{ex, ey}: 0n
    case @e_alta_m_src_m{ex, ey}: 0n
    case @e_refa_p_mid_p{ex, ey}: 0n
    case @e_mid_m_refa_m{ex, ey}: 0n
    case @e_alta_p_mid_p{ex, ey}: 0n
    case @e_mid_m_alta_m{ex, ey}: 0n
    case @e_mid_p_refb_p{ex, ey}: 0n
    case @e_refb_m_mid_m{ex, ey}: 0n
    case @e_mid_p_insb_p{ex, ey}: 0n
    case @e_insb_m_mid_m{ex, ey}: 0n
    case @e_refb_p_snk_p{ex, ey}: 0n
    case @e_snk_m_refb_m{ex, ey}: 0n
    case @e_insb_p_snk_p{ex, ey}: 0n
    case @e_snk_m_insb_m{ex, ey}: 0n
type Walk(x: Node, z: Node):
  case @stop:
    e: Node{z == x}
  case @go:
    y: Node
    e: Edge(x, y)
    w: Walk(y, z)
def h1() -> Walk(@src_p, @snk_p):
  @go{@refa_p, @e_src_p_refa_p{{==}, {==}}, @go{@mid_p, @e_refa_p_mid_p{{==}, {==}}, @go{@refb_p, @e_mid_p_refb_p{{==}, {==}}, @go{@snk_p, @e_refb_p_snk_p{{==}, {==}}, @stop{{==}}}}}}
def h2() -> Walk(@src_p, @snk_p):
  @go{@alta_p, @e_src_p_alta_p{{==}, {==}}, @go{@mid_p, @e_alta_p_mid_p{{==}, {==}}, @go{@refb_p, @e_mid_p_refb_p{{==}, {==}}, @go{@snk_p, @e_refb_p_snk_p{{==}, {==}}, @stop{{==}}}}}}
def h3() -> Walk(@src_p, @snk_p):
  @go{@alta_p, @e_src_p_alta_p{{==}, {==}}, @go{@mid_p, @e_alta_p_mid_p{{==}, {==}}, @go{@insb_p, @e_mid_p_insb_p{{==}, {==}}, @go{@snk_p, @e_insb_p_snk_p{{==}, {==}}, @stop{{==}}}}}}
def h4() -> Walk(@src_p, @snk_p):
  @go{@refa_p, @e_src_p_refa_p{{==}, {==}}, @go{@mid_p, @e_refa_p_mid_p{{==}, {==}}, @go{@insb_p, @e_mid_p_insb_p{{==}, {==}}, @go{@snk_p, @e_insb_p_snk_p{{==}, {==}}, @stop{{==}}}}}}

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
    case @alta_m{}:
      match m:
        case @alta_m{}: True
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @alta_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: True
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @insb_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: True
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @insb_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: True
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @mid_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: True
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @mid_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: True
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @refa_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: True
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @refa_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: True
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @refb_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: True
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @refb_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: True
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @snk_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: True
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: False
    case @snk_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: True
        case @src_m{}: False
        case @src_p{}: False
    case @src_m{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: True
        case @src_p{}: False
    case @src_p{}:
      match m:
        case @alta_m{}: False
        case @alta_p{}: False
        case @insb_m{}: False
        case @insb_p{}: False
        case @mid_m{}: False
        case @mid_p{}: False
        case @refa_m{}: False
        case @refa_p{}: False
        case @refb_m{}: False
        case @refb_p{}: False
        case @snk_m{}: False
        case @snk_p{}: False
        case @src_m{}: False
        case @src_p{}: True
# the allele call: does the walk traverse this oriented segment
def takes(n: Node, a: Node, z: Node, w: Walk(a, z)) -> Bool:
  foldW(boolM, lambda t. sameNode(t, n), lambda a2. lambda b. lambda c. lambda ed. lambda m. orB(sameNode(a2, n), m), a, z, w)

# §3 the emitter's sequences, certified against the fold by refl
def seq_h1() -> Path(Nat[], sequence(@src_p, @snk_p, h1()), [0n, 1n, 3n, 1n, 1n, 0n]):
  <_> [0n, 1n, 3n, 1n, 1n, 0n]
def seq_h2() -> Path(Nat[], sequence(@src_p, @snk_p, h2()), [0n, 2n, 3n, 1n, 1n, 0n]):
  <_> [0n, 2n, 3n, 1n, 1n, 0n]
def seq_h3() -> Path(Nat[], sequence(@src_p, @snk_p, h3()), [0n, 2n, 3n, 1n, 2n, 1n, 0n]):
  <_> [0n, 2n, 3n, 1n, 2n, 1n, 0n]
def seq_h4() -> Path(Nat[], sequence(@src_p, @snk_p, h4()), [0n, 1n, 3n, 1n, 2n, 1n, 0n]):
  <_> [0n, 1n, 3n, 1n, 2n, 1n, 0n]

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
def Hap_src_p_snk_p() -> Set:
  Walk(@src_p, @snk_p)
# the linear reference records whether the walk traverses @alta_m
def callRef_Hap_src_p_snk_p(w: Hap_src_p_snk_p) -> Bool:
  takes(@alta_m, @src_p, @snk_p, w)
def lossless_Hap_src_p_snk_p() -> Equiv(Hap_src_p_snk_p, Total(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p)):
  totalEquiv(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p)
# h1 and h2: the same call at @alta_m, different at @alta_p
def same_call_h1_h2() -> Path(Bool, callRef_Hap_src_p_snk_p(h1()), callRef_Hap_src_p_snk_p(h2())):
  <_> False
def walks_differ_h1_h2(p: Path(Hap_src_p_snk_p, h1(), h2())) -> Empty:
  natEncode(0n, 1n, <i> bit(takes(@alta_p, @src_p, @snk_p, p @ i)))
def fib_h1() -> fiber(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p, False):
  (h1(), <_> False)
def fib_h2() -> fiber(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p, False):
  (h2(), <_> False)
def fibre_points_differ_h1_h2(p: Path(fiber(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p, False), fib_h1(), fib_h2())) -> Empty:
  walks_differ_h1_h2(<i> fst(Hap_src_p_snk_p, lambda w. Path(Bool, callRef_Hap_src_p_snk_p(w), False), p @ i))
# REFERENCE BIAS, computed: the fibre of the reference projection over False is not a point
def ref_not_contractible_Hap_src_p_snk_p(c: isContr(fiber(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p, False))) -> Empty:
  match c:
    case (centre, h):
      fibre_points_differ_h1_h2(compPath(fiber(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p, False), fib_h1(), centre, fib_h2(), <i> h(fib_h1()) @ inot(i), h(fib_h2())))
def ref_not_equiv_Hap_src_p_snk_p(h: isEquiv(Hap_src_p_snk_p, Bool, callRef_Hap_src_p_snk_p)) -> Empty:
  ref_not_contractible_Hap_src_p_snk_p(h(False))

def main() -> Nat:
  length(Nat, sequence(@src_p, @snk_p, h1()))

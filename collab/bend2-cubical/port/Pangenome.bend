# Pangenomics (the HPRC / GA4GH VRS shape): a variation graph with embedded
# haplotype walks, fed to derivations, the fibre law and univalent transport
# unchanged.
#
# THE FINITE PRESENTATION.  Nodes are a finite type; edges are an indexed
# family with endpoint equations; a haplotype is a walk (a derivation over
# edges).  The graph is two bubbles in series — bubble A (ref / alt allele)
# and bubble B (ref / insertion) — with four embedded haplotypes.  A linear
# reference is a PROJECTION of the walk: "GRCh38" records bubble A only,
# "CHM13" records bubble B only.  The graph is a stand-in; the theorems are
# about the shape.
#
#   §1  nodes, edges, walks, labels; the four haplotypes
#   §2  receivers as folds over a walk: the sequence, the node path, the
#       edge count, the allele call at a bubble — one recursor, and each
#       reading unique (fold_unique)
#   §3  the fibre law at a reference projection: Walk ≃ Σ call. fiber
#       callRef call (generic totalEquiv, ua path, present/retrieve by coe);
#       H2 and H3 have the SAME GRCh38 call and are DIFFERENT walks — the
#       fibre over that call has two points, so it is not contractible:
#       reference bias is that fibre, computed
#   §4  two references: the pair (callRef, callAlt) separates H2 from H3;
#       liftover is transport along a path only where an equivalence
#       exists, and the missing bubble is exactly where none does
#   §5  a faithful change of presentation: the haplotype panel is
#       equivalent to its variation definition (the pair of calls) — both
#       round trips by cases — so by ua the identity of a haplotype IS its
#       variation definition and transports (the VRS principle); the
#       single-reference call is not an equivalence (§3)
import Prelude

# ---------------------------------------------------------------------------
# §1  The graph and its embedded haplotypes.
# ---------------------------------------------------------------------------
type Node:
  case @src:
  case @refA:
  case @altA:
  case @mid:
  case @refB:
  case @insB:
  case @snk:
# node labels: bases as 0..3
def label(n: Node) -> Nat[]:
  match n:
    case @src{}: [0n]
    case @refA{}: [1n]
    case @altA{}: [2n]
    case @mid{}: [3n]
    case @refB{}: [1n, 1n]
    case @insB{}: [1n, 2n, 1n]
    case @snk{}: [0n]
type Edge(x: Node, y: Node):
  case @e_src_refA:
    ex: Node{x == @src}
    ey: Node{y == @refA}
  case @e_src_altA:
    ex: Node{x == @src}
    ey: Node{y == @altA}
  case @e_refA_mid:
    ex: Node{x == @refA}
    ey: Node{y == @mid}
  case @e_altA_mid:
    ex: Node{x == @altA}
    ey: Node{y == @mid}
  case @e_mid_refB:
    ex: Node{x == @mid}
    ey: Node{y == @refB}
  case @e_mid_insB:
    ex: Node{x == @mid}
    ey: Node{y == @insB}
  case @e_refB_snk:
    ex: Node{x == @refB}
    ey: Node{y == @snk}
  case @e_insB_snk:
    ex: Node{x == @insB}
    ey: Node{y == @snk}
type Walk(x: Node, z: Node):
  case @stop:
    e: Node{z == x}
  case @go:
    y: Node
    e: Edge(x, y)
    w: Walk(y, z)

def H1() -> Walk(@src, @snk):
  @go{@refA, @e_src_refA{{==}, {==}}, @go{@mid, @e_refA_mid{{==}, {==}}, @go{@refB, @e_mid_refB{{==}, {==}}, @go{@snk, @e_refB_snk{{==}, {==}}, @stop{{==}}}}}}
def H2() -> Walk(@src, @snk):
  @go{@altA, @e_src_altA{{==}, {==}}, @go{@mid, @e_altA_mid{{==}, {==}}, @go{@refB, @e_mid_refB{{==}, {==}}, @go{@snk, @e_refB_snk{{==}, {==}}, @stop{{==}}}}}}
def H3() -> Walk(@src, @snk):
  @go{@altA, @e_src_altA{{==}, {==}}, @go{@mid, @e_altA_mid{{==}, {==}}, @go{@insB, @e_mid_insB{{==}, {==}}, @go{@snk, @e_insB_snk{{==}, {==}}, @stop{{==}}}}}}
def H4() -> Walk(@src, @snk):
  @go{@refA, @e_src_refA{{==}, {==}}, @go{@mid, @e_refA_mid{{==}, {==}}, @go{@insB, @e_mid_insB{{==}, {==}}, @go{@snk, @e_insB_snk{{==}, {==}}, @stop{{==}}}}}}

# ---------------------------------------------------------------------------
# §2  Receivers as folds over a walk.
# ---------------------------------------------------------------------------
def foldW(M: Node -> Node -> Set, e: all t: Node. M(t, t), k: all a: Node. all b: Node. all c: Node. Edge(a, b) -> M(b, c) -> M(a, c), a: Node, z: Node, w: Walk(a, z)) -> M(a, z):
  match w:
    case @stop{eq}:
      match eq: case {==}: e(a)
    case @go{y, ed, w2}:
      k(a, y, z, ed, foldW(M, e, k, y, z, w2))
def fold_unique(M: Node -> Node -> Set, e: all t: Node. M(t, t), k: all a: Node. all b: Node. all c: Node. Edge(a, b) -> M(b, c) -> M(a, c),
                g: all a: Node. all z: Node. Walk(a, z) -> M(a, z),
                g_stop: all t: Node. Path(M(t, t), g(t, t, @stop{{==}}), e(t)),
                g_go: all a: Node. all y: Node. all z: Node. all ed: Edge(a, y). all w: Walk(y, z). Path(M(a, z), g(a, z, @go{y, ed, w}), k(a, y, z, ed, g(y, z, w))),
                a: Node, z: Node, w: Walk(a, z)) -> Path(M(a, z), g(a, z, w), foldW(M, e, k, a, z, w)):
  match w:
    case @stop{eq}:
      match eq: case {==}: g_stop(a)
    case @go{y, ed, w2}:
      compPath(M(a, z), g(a, z, @go{y, ed, w2}), k(a, y, z, ed, g(y, z, w2)), k(a, y, z, ed, foldW(M, e, k, y, z, w2)),
        g_go(a, y, z, ed, w2),
        <i> k(a, y, z, ed, fold_unique(M, e, k, g, g_stop, g_go, y, z, w2) @ i))

def app(xs: Nat[], ys: Nat[]) -> Nat[]:
  match xs:
    case []: ys
    case h <> t: h <> app(t, ys)
# (a) the SEQUENCE: labels concatenated along the walk
def seqM(a: Node, b: Node) -> Set:
  Nat[]
def sequence(a: Node, z: Node, w: Walk(a, z)) -> Nat[]:
  foldW(seqM, lambda t. label(t), lambda a2. lambda b. lambda c. lambda ed. lambda m. app(label(a2), m), a, z, w)
# (b) the NODE PATH (GFA's P line)
def pathM(a: Node, b: Node) -> Set:
  Node[]
def nodePath(a: Node, z: Node, w: Walk(a, z)) -> Node[]:
  foldW(pathM, lambda t. [t], lambda a2. lambda b. lambda c. lambda ed. lambda m. a2 <> m, a, z, w)
# (c) the EDGE COUNT
def natM(a: Node, b: Node) -> Set:
  Nat
def edges(a: Node, z: Node, w: Walk(a, z)) -> Nat:
  foldW(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda ed. lambda n. 1n + n, a, z, w)
# (d) the ALLELE CALL at a bubble: did the walk take the alt allele at A / the insertion at B
def orB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: True
    case False: b
def boolM(a: Node, b: Node) -> Set:
  Bool
def takesAltA(a: Node, b: Node, ed: Edge(a, b)) -> Bool:
  match ed:
    case @e_src_altA{ex, ey}: True
    case @e_src_refA{ex, ey}: False
    case @e_refA_mid{ex, ey}: False
    case @e_altA_mid{ex, ey}: False
    case @e_mid_refB{ex, ey}: False
    case @e_mid_insB{ex, ey}: False
    case @e_refB_snk{ex, ey}: False
    case @e_insB_snk{ex, ey}: False
def takesInsB(a: Node, b: Node, ed: Edge(a, b)) -> Bool:
  match ed:
    case @e_mid_insB{ex, ey}: True
    case @e_src_refA{ex, ey}: False
    case @e_src_altA{ex, ey}: False
    case @e_refA_mid{ex, ey}: False
    case @e_altA_mid{ex, ey}: False
    case @e_mid_refB{ex, ey}: False
    case @e_refB_snk{ex, ey}: False
    case @e_insB_snk{ex, ey}: False
# "GRCh38" sees bubble A only; "CHM13" sees bubble B only
def callRef(w: Walk(@src, @snk)) -> Bool:
  foldW(boolM, lambda t. False, lambda a2. lambda b. lambda c. lambda ed. lambda m. orB(takesAltA(a2, b, ed), m), @src, @snk, w)
def callAlt(w: Walk(@src, @snk)) -> Bool:
  foldW(boolM, lambda t. False, lambda a2. lambda b. lambda c. lambda ed. lambda m. orB(takesInsB(a2, b, ed), m), @src, @snk, w)
# the four readings of H3, by refl
def seq_H3() -> Path(Nat[], sequence(@src, @snk, H3()), [0n, 2n, 3n, 1n, 2n, 1n, 0n]):
  <_> [0n, 2n, 3n, 1n, 2n, 1n, 0n]
def path_H3() -> Path(Node[], nodePath(@src, @snk, H3()), [@src, @altA, @mid, @insB, @snk]):
  <_> [@src, @altA, @mid, @insB, @snk]
def edges_H3() -> Path(Nat, edges(@src, @snk, H3()), 4n):
  <_> 4n
def calls_H3() -> Path(any b: Bool. Bool, (callRef(H3()), callAlt(H3())), (True, True)):
  <_> (True, True)

# ---------------------------------------------------------------------------
# §3  The fibre law at a reference projection (fibrelaw.bend, generic).
# ---------------------------------------------------------------------------
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
def invC(A: Set, B: Set, f: A -> B, y: B, c: isContr(fiber(A, B, f, y))) -> A:
  match c:
    case (cen, _):
      match cen:
        case (x, _):
          x
def secC(A: Set, B: Set, f: A -> B, y: B, c: isContr(fiber(A, B, f, y))) -> Path(B, f(invC(A, B, f, y, c)), y):
  match c:
    case (cen, _):
      match cen:
        case (x, p):
          p
def retC(A: Set, B: Set, f: A -> B, x: A, c: isContr(fiber(A, B, f, f(x)))) -> Path(A, invC(A, B, f, f(x), c), x):
  match c:
    case (cen, contr):
      <i> (match contr((x, <_> f(x))) @ i: case (z, _): z)
def uaE(A: Set, B: Set, e: Equiv(A, B)) -> Path(Set, A, B):
  match e:
    case (f, h):
      ua(A, B, f, lambda y. invC(A, B, f, y, h(y)), lambda x. retC(A, B, f, x, h(f(x))), lambda y. secC(A, B, f, y, h(y)))
def losslessPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, Total(A, B, f)):
  uaE(A, Total(A, B, f), totalEquiv(A, B, f))
def present(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  coe(lambda i. losslessPath(A, B, f) @ i, i0, i1, a)
def retrieve(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  coe(lambda i. losslessPath(A, B, f) @ i, i1, i0, w)
def retrieve_present(A: Set, B: Set, f: A -> B, a: A) -> Path(A, retrieve(A, B, f, present(A, B, f, a)), a):
  <_> a

def Hap() -> Set:
  Walk(@src, @snk)
# the haplotype set IS the sum over GRCh38 calls of the fibres; the linear
# view is the first projection, and the walk is recovered (refl)
def ref_lossless() -> Path(Set, Hap, Total(Hap, Bool, callRef)):
  losslessPath(Hap, Bool, callRef)
def ref_receipt(w: Hap) -> Path(Hap, retrieve(Hap, Bool, callRef, present(Hap, Bool, callRef, w)), w):
  retrieve_present(Hap, Bool, callRef, w)
# H2 and H3: the same GRCh38 call…
def same_ref_call() -> Path(Bool, callRef(H2()), callRef(H3())):
  <_> True
# …and different walks: the CHM13 projection separates them
def bit(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n
def walks_differ(p: Path(Hap, H2(), H3())) -> Empty:
  natEncode(0n, 1n, <i> bit(callAlt(p @ i)))
# so the fibre of the GRCh38 projection over `True` has two distinct points
def fib2() -> fiber(Hap, Bool, callRef, True):
  (H2(), <_> True)
def fib3() -> fiber(Hap, Bool, callRef, True):
  (H3(), <_> True)
def fibre_points_differ(p: Path(fiber(Hap, Bool, callRef, True), fib2(), fib3())) -> Empty:
  walks_differ(<i> fst(Hap, lambda w. Path(Bool, callRef(w), True), p @ i))
# REFERENCE BIAS, computed: the GRCh38 fibre is not contractible, i.e. the
# projection to that reference is not an equivalence — and the fibre law
# says exactly what it erased (the bubble-B allele), nothing else
def ref_not_contractible(c: isContr(fiber(Hap, Bool, callRef, True))) -> Empty:
  match c:
    case (centre, h):
      fibre_points_differ(compPath(fiber(Hap, Bool, callRef, True), fib2(), centre, fib3(), <i> h(fib2()) @ inot(i), h(fib3())))
def ref_not_equiv(h: isEquiv(Hap, Bool, callRef)) -> Empty:
  ref_not_contractible(h(True))

# ---------------------------------------------------------------------------
# §4  Two references.
# ---------------------------------------------------------------------------
def calls(w: Hap) -> any b: Bool. Bool:
  (callRef(w), callAlt(w))
def finer_separates(p: Path(any b: Bool. Bool, calls(H2()), calls(H3()))) -> Empty:
  natEncode(0n, 1n, <i> bit(snd(Bool, lambda b. Bool, p @ i)))

# ---------------------------------------------------------------------------
# §5  The panel is equivalent to its variation definition (VRS): the
#     identity of a haplotype is its calls, and it transports.
# ---------------------------------------------------------------------------
type Panel:
  case @h1:
  case @h2:
  case @h3:
  case @h4:
def walkOf(h: Panel) -> Hap:
  match h:
    case @h1{}: H1()
    case @h2{}: H2()
    case @h3{}: H3()
    case @h4{}: H4()
def defn(h: Panel) -> any b: Bool. Bool:
  calls(walkOf(h))
def ofDefn(d: any b: Bool. Bool) -> Panel:
  match d:
    case (a, b):
      match a:
        case False:
          match b:
            case False: @h1
            case True: @h4
        case True:
          match b:
            case False: @h2
            case True: @h3
def defn_ofDefn(d: any b: Bool. Bool) -> Path(any b: Bool. Bool, defn(ofDefn(d)), d):
  match d:
    case (a, b):
      match a:
        case False:
          match b:
            case False: <_> (False, False)
            case True: <_> (False, True)
        case True:
          match b:
            case False: <_> (True, False)
            case True: <_> (True, True)
def ofDefn_defn(h: Panel) -> Path(Panel, ofDefn(defn(h)), h):
  match h:
    case @h1{}: <_> @h1
    case @h2{}: <_> @h2
    case @h3{}: <_> @h3
    case @h4{}: <_> @h4
def panelPath() -> Path(Set, Panel, any b: Bool. Bool):
  ua(Panel, any b: Bool. Bool, defn, ofDefn, ofDefn_defn, defn_ofDefn)
# transport along the identification computes to the variation definition
def h3_transports() -> Path(any b: Bool. Bool, coe(lambda i. panelPath() @ i, i0, i1, @h3), (True, True)):
  <_> (True, True)
def h3_back() -> Path(Panel, coe(lambda i. panelPath() @ i, i1, i0, (True, True)), @h3):
  <_> @h3

def main() -> Nat:
  length(Nat, sequence(@src, @snk, H3()))

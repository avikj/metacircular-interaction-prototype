# Pangenome.bend — the pangenome, third presentation of the SAME machine.  A
# haplotype is a path through the graph (a list of node ids).  A linear reference
# is a projection q : Hap -> V_ref (keep the reference nodes).  The fibre law gives
# Hap ≃ Σ (v : V_ref). fib_q(v): the fibre is exactly the reference-relative
# structure the coordinate system discards, and two references discard different
# structure.  A downstream reading descends through q_ref or is refused, and
# liftover between references is transport along the two laws.
#
# HONEST SCOPE: a six-node toy graph; nodes 0-3 form the GRCh38-like backbone,
# node 4 is an insertion the T2T-like backbone carries, node 5 is novel to both.
import Descent

def inR38(n: Nat) -> Bool:
  match n:
    case 0n: True
    case 1n + p:
      match p:
        case 0n: True
        case 1n + q:
          match q:
            case 0n: True
            case 1n + r:
              match r:
                case 0n: True
                case 1n + s: False
def inT2T(n: Nat) -> Bool:
  match n:
    case 0n: True
    case 1n + p:
      match p:
        case 0n: True
        case 1n + q:
          match q:
            case 0n: True
            case 1n + r:
              match r:
                case 0n: True
                case 1n + s:
                  match s:
                    case 0n: True
                    case 1n + t: False

def filterN(f: Nat -> Bool, xs: Nat[]) -> Nat[]:
  match xs:
    case []: []
    case h <> t:
      match f(h):
        case True: h <> filterN(f, t)
        case False: filterN(f, t)

# the two projections (coordinate presentations)
def proj38(h: Nat[]) -> Nat[]:
  filterN(lambda n. inR38(n), h)
def projT2T(h: Nat[]) -> Nat[]:
  filterN(lambda n. inT2T(n), h)

def R38(a: Nat[], b: Nat[]) -> Set:
  Path(Nat[], proj38(a), proj38(b))
def RT2T(a: Nat[], b: Nat[]) -> Set:
  Path(Nat[], projT2T(a), projT2T(b))
def V38() -> Set:
  Quotient(Nat[], lambda a. lambda b. R38(a, b))
def VT2T() -> Set:
  Quotient(Nat[], lambda a. lambda b. RT2T(a, b))
def q38(h: Nat[]) -> V38:
  @cl{h}
def qT2T(h: Nat[]) -> VT2T:
  @cl{h}

# haplotypes: reference-like, insertion carrier, duplicated insertion, novel node
def H1() -> Nat[]:
  [0n, 1n, 2n, 3n]
def H2() -> Nat[]:
  [0n, 1n, 4n, 2n, 3n]
def H3() -> Nat[]:
  [0n, 1n, 4n, 4n, 2n, 3n]
def H4() -> Nat[]:
  [0n, 1n, 5n, 2n, 3n]

# GRCh38 identifies all four; T2T identifies only H1 with H4: the fibres differ
def h1_h2_38() -> R38(H1(), H2()):
  <_> [0n, 1n, 2n, 3n]
def h2_h3_38() -> R38(H2(), H3()):
  <_> [0n, 1n, 2n, 3n]
def h1_h4_T2T() -> RT2T(H1(), H4()):
  <_> [0n, 1n, 2n, 3n]
def lengthN(xs: Nat[]) -> Nat:
  length(Nat, xs)
def h1_h2_not_T2T(r: RT2T(H1(), H2())) -> Empty:
  natEncode(4n, 5n, <i> lengthN(r @ i))

# ---- the fibre law, twice; liftover is transport with the residue carried
def hap_by_38() -> Equiv(Nat[], Total(Nat[], V38, lambda h. q38(h))):
  totalEquiv(Nat[], V38, lambda h. q38(h))
def hap_by_T2T() -> Equiv(Nat[], Total(Nat[], VT2T, lambda h. qT2T(h))):
  totalEquiv(Nat[], VT2T, lambda h. qT2T(h))
def liftover(w: Total(Nat[], V38, lambda h. q38(h))) -> Total(Nat[], VT2T, lambda h. qT2T(h)):
  coe(lambda i. totalPath(Nat[], VT2T, lambda h. qT2T(h)) @ i, i0, i1,
      coe(lambda i. totalPath(Nat[], V38, lambda h. q38(h)) @ i, i1, i0, w))
def liftover_computes(h: Nat[]) -> Path(Total(Nat[], VT2T, lambda h2. qT2T(h2)), liftover(total_to(Nat[], V38, lambda h2. q38(h2), h)), total_to(Nat[], VT2T, lambda h2. qT2T(h2), h)):
  <_> total_to(Nat[], VT2T, lambda h2. qT2T(h2), h)

# ---- readings classified by descent
# haplotype length is refused by the linear reference (it erased the insertion)
def length_not_through_38(d: Descends(Nat[], lambda a. lambda b. R38(a, b), Nat, lambda h. lengthN(h))) -> Empty:
  refuse(Nat[], lambda a. lambda b. R38(a, b), lambda h. lengthN(h), H1(), H2(), h1_h2_38(), lambda e. e, d)
# insertion copy number, a reading of the T2T presentation, descends through T2T...
def count4(xs: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t:
      match h:
        case 0n: count4(t)
        case 1n + p:
          match p:
            case 0n: count4(t)
            case 1n + q:
              match q:
                case 0n: count4(t)
                case 1n + r:
                  match r:
                    case 0n: count4(t)
                    case 1n + s:
                      match s:
                        case 0n: 1n + count4(t)
                        case 1n + u: count4(t)
def insCopies(h: Nat[]) -> Nat:
  count4(projT2T(h))
def copies_through_T2T() -> Descends(Nat[], lambda a. lambda b. RT2T(a, b), Nat, lambda h. insCopies(h)):
  lambda a. lambda b. lambda r. <i> count4(r @ i)
def copies_on_VT2T(v: VT2T) -> Nat:
  erase(Nat[], lambda a. lambda b. RT2T(a, b), Nat, lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q), lambda h. insCopies(h), copies_through_T2T(), v)
# ...and is refused by GRCh38: reference bias, as a missing descent witness
def copies_not_through_38(d: Descends(Nat[], lambda a. lambda b. R38(a, b), Nat, lambda h. insCopies(h))) -> Empty:
  refuse(Nat[], lambda a. lambda b. R38(a, b), lambda h. insCopies(h), H1(), H2(), h1_h2_38(), lambda e. e, d)
# a reference allele IS a reading of the projection, so it descends through both
def nth(xs: Nat[], k: Nat) -> Nat:
  match xs:
    case []: 0n
    case h <> t:
      match k:
        case 0n: h
        case 1n + p: nth(t, p)
def allele2(h: Nat[]) -> Nat:
  nth(proj38(h), 2n)
def allele_through_38() -> Descends(Nat[], lambda a. lambda b. R38(a, b), Nat, lambda h. allele2(h)):
  lambda a. lambda b. lambda r. <i> nth(r @ i, 2n)

# the residue exhibited: the fibre of q38 over [H1] holds H2 (and H3, H4)
def fib38_1() -> fiber(Nat[], V38, lambda h. q38(h), q38(H1())):
  (H1(), <_> q38(H1()))
def fib38_2() -> fiber(Nat[], V38, lambda h. q38(h), q38(H1())):
  (H2(), @eq{H2(), H1(), <_> [0n, 1n, 2n, 3n]})
def h1_h2_distinct(p: Path(Nat[], H1(), H2())) -> Empty:
  natEncode(4n, 5n, <i> lengthN(p @ i))
def fibre38_holds_two(p: Path(fiber(Nat[], V38, lambda h. q38(h), q38(H1())), fib38_1(), fib38_2())) -> Empty:
  h1_h2_distinct(<i> fst(Nat[], lambda h. Path(V38, q38(h), q38(H1())), p @ i))

def main() -> Nat:
  insCopies(H3())

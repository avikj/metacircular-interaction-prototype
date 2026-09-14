# Descent.bend — erasure = descent, as a DEFINITION rather than a must-fail probe,
# and the fibre law as the exact residue.  Nothing biological is in this file: the
# three presentations (Perturbation, Segmentation, Pangenome) import it unchanged.
#
#   q : A -> A/R forgets the distinctions R identifies.  A reading t : A -> V may
#   run after the erasure IFF t descends (factors through q).  `Descends` is that
#   obligation as a type; `erase` is the erased computation, and it exists exactly
#   when `Descends` is inhabited, because quotRec asks for nothing else.  Where it
#   is not inhabited the substrate refuses; what was destroyed is `fiber`, and the
#   fibre law `totalEquiv` says A is exactly the projection plus that residue.
import SetQuotient

def Descends(A: Set, R: A -> A -> Set, V: Set, t: A -> V) -> Set:
  all x: A. all y: A. R(x, y) -> Path(V, t(x), t(y))

def erase(A: Set, R: A -> A -> Set, V: Set, sV: isSet(V), t: A -> V, d: Descends(A, R, V, t), m: Quotient(A, R)) -> V:
  quotRec(A, R, V, sV, t, d, m)

# the erased reading agrees with the unerased one on every point
def erase_cl(A: Set, R: A -> A -> Set, V: Set, sV: isSet(V), t: A -> V, d: Descends(A, R, V, t), a: A) -> Path(V, erase(A, R, V, sV, t, d, @cl{a}), t(a)):
  <_> t(a)

# a refusal: no descent witness can exist when t separates an R-related pair in Nat
def refuse(A: Set, R: A -> A -> Set, t: A -> Nat, x: A, y: A, r: R(x, y), c: NatCode(t(x), t(y)) -> Empty, d: Descends(A, R, Nat, t)) -> Empty:
  c(natEncode(t(x), t(y), d(x, y, r)))

# ---- the fibre law  A ≃ Σ (b : B). fiber f b, for every f: the exact residue
def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)
def total_to(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), (a, <_> f(a)))
def total_from(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, u):
      match u:
        case (a, p): a
def total_from_to(A: Set, B: Set, f: A -> B, a: A) -> Path(A, total_from(A, B, f, total_to(A, B, f, a)), a):
  <_> a
def total_to_from(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), total_to(A, B, f, total_from(A, B, f, w)), w):
  match w:
    case (b, u):
      match u:
        case (a, p): <i> (p @ i, (a, <j> p @ iand(i, j)))
def totalEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Total(A, B, f)):
  isoToEquiv(A, Total(A, B, f), lambda a. total_to(A, B, f, a), lambda w. total_from(A, B, f, w),
             lambda w. total_to_from(A, B, f, w), lambda a. total_from_to(A, B, f, a))
def totalPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, Total(A, B, f)):
  ua(A, Total(A, B, f), lambda a. total_to(A, B, f, a), lambda w. total_from(A, B, f, w),
     lambda a. total_from_to(A, B, f, a), lambda w. total_to_from(A, B, f, w))
# presenting a value as (projection, residue) is transport along the law, and it
# computes to the constructor: the ua β-rule
def present(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  coe(lambda i. totalPath(A, B, f) @ i, i0, i1, a)
def present_is_to(A: Set, B: Set, f: A -> B, a: A) -> Path(Total(A, B, f), present(A, B, f, a), total_to(A, B, f, a)):
  <_> total_to(A, B, f, a)
def residue(A: Set, B: Set, f: A -> B, a: A) -> fiber(A, B, f, f(a)):
  (a, <_> f(a))

def main() -> Nat:
  0n

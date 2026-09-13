# Coherent equivalence (contractible-fibre isEquiv) — the formulation the
# review named as required for BOTH univalence round trips.

def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))

def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)

def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))

def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

# Contractibility of the singleton  Σ x. Path(A, x, a)  — the key lemma:
# centre (a, refl); every (x,p) connects to it by the connection square.
def isContrSingl(A: Set, a: A) -> isContr(fiber(A, A, lambda x. x, a)):
  ( (a, <_> a)
  , lambda w.
      match w:
        case (x, p):
          <i> ( p @ inot(i) , <j> p @ ior(inot(i), j) )
  )

# hence the identity map is an equivalence
def idEquiv(A: Set) -> Equiv(A, A):
  ( lambda x. x , lambda y. isContrSingl(A, y) )

def main() -> Nat:
  0n

# Equiv -> Path: derive the iso data (inverse + both homotopies) from a
# COHERENT equivalence and feed the ua primitive.  This is the provable half
# of coherent-equivalence univalence (the ua direction).

# probe: contractibility is a proposition (needs real composition)
def isPropIsContr(A: Set, c0: isContr(A), c1: isContr(A)) -> Path(isContr(A), c0, c1):
  match c0:
    case (a0, h0):
      match c1:
        case (a1, h1):
          <j> ( h0(a1) @ j
              , lambda y. <i> hcomp(A, i, <k> h0(a1) @ k, <k> h0(y) @ k, h0(h0(y) @ i) @ j) )

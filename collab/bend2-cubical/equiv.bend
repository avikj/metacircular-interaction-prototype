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

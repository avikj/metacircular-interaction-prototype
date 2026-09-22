# Univalence, finished: both computation rules for ua.
#   uaβ  : transport along ua e computes to e (definitional; test2/test4)
#   uaIdEquiv : ua of the identity iso IS refl (conversion)
#   uaη  : ua(pathToIso p) = p for every p (theorem, by J)

# Iso as a Σ-family
def Iso5(A: Set, B: Set) -> Set:
  any f: A -> B.
  any g: B -> A.
  any gf: (all x:A. Path(A, g(f(x)), x)).
  (all y:B. Path(B, f(g(y)), y))

def idIso5(A: Set) -> Iso5(A, A):
  (lambda x. x, lambda x. x, lambda x. <_> x, lambda y. <_> y)

def ua5(A: Set, B: Set, e: Iso5(A, B)) -> Path(Set, A, B):
  match e:
    case (f, g, gf, fg):
      ua(A, B, f, g, gf, fg)

# a path in Set yields an iso, by transport of the identity iso
def pathToIso(A: Set, B: Set, p: Path(Set, A, B)) -> Iso5(A, B):
  coe(lambda i. Iso5(A, p @ i), i0, i1, idIso5(A))

# ua of the identity iso is refl — by conversion
def uaIdEquiv(A: Set) -> Path(Path(Set, A, A), ua5(A, A, idIso5(A)), <_> A):
  <i> <_> A

# the eta round trip: ua(pathToIso(p)) = p, by path induction (J inlined
# as coe along the connection square)
def uaEta(A: Set, B: Set, p: Path(Set, A, B)) -> Path(Path(Set, A, B), ua5(A, B, pathToIso(A, B, p)), p):
  coe(lambda i. Path(Path(Set, A, p @ i), ua5(A, p @ i, pathToIso(A, p @ i, <j> p @ iand(i, j))), <j> p @ iand(i, j)), i0, i1, <i> <_> A)

def main() -> Nat:
  0n

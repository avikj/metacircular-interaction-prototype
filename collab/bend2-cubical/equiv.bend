# Coherent equivalence (contractible-fibre isEquiv) â” the formulation the
# review named as required for BOTH univalence round trips.
#
# Status: isContr / fiber / isEquiv / Equiv, isContrSingl, idEquiv,
#   isPropIsContr (general 4-face hcompN), isPropIsEquiv (definitional),
#   and pathToEquiv all check green.  isPropIsEquiv is what the reverse
#   round trip needs: because isEquiv is a proposition, pathToEquiv(ua e)=e
#   reduces to (i) the underlying functions agree â” uaÎ², which is
#   definitional here â” and (ii) a prop-filler on the isEquiv component.

def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))

def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)

def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))

def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

# Contractibility is a proposition.  Needs a general (4-face) cofibration
# system â” binary hcomp cannot express faces on two independent interval
# variables.  This is the load-bearing lemma; it is green via hcompN.
def isPropIsContr(A: Set, c0: isContr(A), c1: isContr(A)) -> Path(isContr(A), c0, c1):
  match c0:
    case (a0, p0):
      match c1:
        case (a1, p1):
          <i> ( p0(a1) @ i
              , lambda x. <j> hcompN(A,
                  [ (inot(i), <k> p0(p0(x) @ j) @ k)
                  , (i,       <k> p0(p1(x) @ j) @ k)
                  , (inot(j), <k> p0(p0(a1) @ i) @ k)
                  , (j,       <k> p0(x) @ k)
                  ], a0) )

# isEquiv is a proposition: it is a Î  of isContr, and isContr is a prop.
# Pointwise in y, connect the two fibre-contraction proofs by isPropIsContr.
# (Green because a Ref of Path type has its @-endpoints read from its
#  declared type: isPropIsContr(_, u0 y, u1 y) @ i0  â‰¡  u0 y.)
def isPropIsEquiv(A: Set, B: Set, f: A -> B, u0: isEquiv(A,B,f), u1: isEquiv(A,B,f))
  -> Path(isEquiv(A,B,f), u0, u1):
  <i> lambda y. isPropIsContr(fiber(A,B,f,y), u0(y), u1(y)) @ i

# Contractibility of the singleton  Î x. Path(A, x, a).
def isContrSingl(A: Set, a: A) -> isContr(fiber(A, A, lambda x. x, a)):
  ( (a, <_> a)
  , lambda w.
      match w:
        case (x, p):
          <i> ( p @ inot(i) , <j> p @ ior(inot(i), j) ) )

# hence the identity map is an equivalence
def idEquiv(A: Set) -> Equiv(A, A):
  ( lambda x. x , lambda y. isContrSingl(A, y) )

# Path -> Equiv: transport idEquiv along the type path.  (coe through the
# Î/Î  structure of Equiv computes; this typechecks as-is.)
def pathToEquiv(A: Set, B: Set, p: Path(Set, A, B)) -> Equiv(A, B):
  coe(lambda i. Equiv(A, p @ i), i0, i1, idEquiv(A))

def main() -> Nat:
  0n

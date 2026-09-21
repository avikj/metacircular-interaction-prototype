def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

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
def isPropIsEquiv(A: Set, B: Set, f: A -> B, u0: isEquiv(A,B,f), u1: isEquiv(A,B,f))
  -> Path(isEquiv(A,B,f), u0, u1):
  <i> lambda y. isPropIsContr(fiber(A,B,f,y), u0(y), u1(y)) @ i
def isContrSingl(A: Set, a: A) -> isContr(fiber(A, A, lambda x. x, a)):
  ( (a, <_> a)
  , lambda w.
      match w:
        case (x, p):
          <i> ( p @ inot(i) , <j> p @ ior(inot(i), j) ) )
def idEquiv(A: Set) -> Equiv(A, A):
  ( lambda x. x , lambda y. isContrSingl(A, y) )
def pathToEquiv(A: Set, B: Set, p: Path(Set, A, B)) -> Equiv(A, B):
  coe(lambda i. Equiv(A, p @ i), i0, i1, idEquiv(A))

# --- projections that reduce: matched argument is a direct variable, so the
# --- case-split refines the goal (centre(A,(c,h)) computes to c).
def centre(A: Set, c: isContr(A)) -> A:
  match c:
    case (ce, h): ce
def contract(A: Set, c: isContr(A)) -> (all x: A. Path(A, centre(A,c), x)):
  match c:
    case (ce, h): h
def fibPt(A: Set, B: Set, f: A->B, y: B, fb: fiber(A,B,f,y)) -> A:
  match fb:
    case (x, p): x
def fibPath(A: Set, B: Set, f: A->B, y: B, fb: fiber(A,B,f,y))
  -> Path(B, f(fibPt(A,B,f,y,fb)), y):
  match fb:
    case (x, p): p
def eqFun(A: Set, B: Set, e: Equiv(A,B)) -> (A -> B):
  match e:
    case (f, pf): f
def eqPrf(A: Set, B: Set, e: Equiv(A,B)) -> isEquiv(A,B, eqFun(A,B,e)):
  match e:
    case (f, pf): pf

# inverse, threaded consistently through centre(fiber, pf y)
def invOf(A: Set, B: Set, e: Equiv(A,B)) -> (B -> A):
  lambda y. fibPt(A,B, eqFun(A,B,e), y,
    centre(fiber(A,B, eqFun(A,B,e), y), eqPrf(A,B,e)(y)))
# fg : f(g y) = y   is the centre fibre's path
def fgOf(A: Set, B: Set, e: Equiv(A,B))
  -> (all y: B. Path(B, eqFun(A,B,e)(invOf(A,B,e)(y)), y)):
  lambda y. fibPath(A,B, eqFun(A,B,e), y,
    centre(fiber(A,B, eqFun(A,B,e), y), eqPrf(A,B,e)(y)))
# gf : g(f x) = x   via ap fibPt over the contraction of the (x, refl) fibre
def gfOf(A: Set, B: Set, e: Equiv(A,B))
  -> (all x: A. Path(A, invOf(A,B,e)(eqFun(A,B,e)(x)), x)):
  lambda x. <i> fibPt(A, B, eqFun(A,B,e), eqFun(A,B,e)(x), contract(fiber(A,B, eqFun(A,B,e), eqFun(A,B,e)(x)), eqPrf(A,B,e)(eqFun(A,B,e)(x)))((x, <_> eqFun(A,B,e)(x))) @ i)

def uaFromEquiv(A: Set, B: Set, e: Equiv(A,B)) -> Path(Set, A, B):
  ua(A,B, eqFun(A,B,e), invOf(A,B,e), gfOf(A,B,e), fgOf(A,B,e))

# THE REVERSE UNIVALENCE ROUND TRIP:  pathToEquiv (ua e) = e
#   fst: fst(pathToEquiv(ua e)) = f definitionally (uaβ + coe-through-Σ/Π)
#   snd: filled by isPropIsEquiv (isEquiv is a proposition)
def uaRoundTrip(A: Set, B: Set, e: Equiv(A,B))
  -> Path(Equiv(A,B), pathToEquiv(A,B, uaFromEquiv(A,B,e)), e):
  match e:
    case (f, pf):
      <i> ( f
          , isPropIsEquiv(A,B, f,
              eqPrf(A,B, pathToEquiv(A,B, uaFromEquiv(A,B,(f,pf)))),
              pf) @ i )

def main() -> Nat:
  0n

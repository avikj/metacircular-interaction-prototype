# The REVERSE univalence round trip, at the COHERENT (contractible-fibre)
# level: pathToEquiv(ua(e)) = e.  Needs isPropIsContr (general hcomp).
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

def isContrSingl(A: Set, a: A) -> isContr(fiber(A, A, lambda x. x, a)):
  ( (a, <_> a)
  , lambda w.
      match w:
        case (x, p):
          <i> ( p @ inot(i) , <j> p @ ior(inot(i), j) )
  )
def idEquiv(A: Set) -> Equiv(A, A):
  ( lambda x. x , lambda y. isContrSingl(A, y) )

# contractibility is a proposition (4-face hcomp)
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

# hence being an equivalence is a proposition, pointwise
def isPropIsEquiv(A: Set, B: Set, f: A -> B, h0: isEquiv(A, B, f), h1: isEquiv(A, B, f)) -> Path(isEquiv(A, B, f), h0, h1):
  <i> lambda y. isPropIsContr(fiber(A, B, f, y), h0(y), h1(y)) @ i

# inverse data from a contractible fibre, matching the isContr VALUE (a
# variable), so the goal refines — never matching a neutral h(y).
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

def pathToEquiv(A: Set, B: Set, p: Path(Set, A, B)) -> Equiv(A, B):
  coe(lambda i. Equiv(A, p @ i), i0, i1, idEquiv(A))

def fstE(A: Set, B: Set, e: Equiv(A, B)) -> (A -> B):
  match e:
    case (f, _):
      f
def sndE(A: Set, B: Set, e: Equiv(A, B)) -> isEquiv(A, B, fstE(A, B, e)):
  match e:
    case (_, h):
      h

# MUST FAIL 1: constant path — endpoint i0 is (f,h), not pathToEquiv(uaE e)
def wrong1(A: Set, B: Set, e: Equiv(A, B)) -> Path(Equiv(A, B), pathToEquiv(A, B, uaE(A, B, e)), e):
  match e:
    case (f, h):
      <i> (f, h)
# MUST FAIL 2: endpoints swapped
def wrong2(A: Set, B: Set, e: Equiv(A, B)) -> Path(Equiv(A, B), pathToEquiv(A, B, uaE(A, B, e)), e):
  match e:
    case (f, h):
      <i> ( f , isPropIsEquiv(A, B, f, h, sndE(A, B, pathToEquiv(A, B, uaE(A, B, (f, h))))) @ i )
def main() -> Nat:
  0n

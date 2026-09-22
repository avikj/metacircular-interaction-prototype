# ua DERIVED from Glue, and transport through it computing (the Kan rule).
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
def fstE(A: Set, B: Set, e: Equiv(A, B)) -> (A -> B):
  match e:
    case (f, _):
      f

# ua from Glue (CCHM): Glue B [(inot i, A, e), (i, B, idEquiv B)]
def uaG(A: Set, B: Set, e: Equiv(A, B)) -> Path(Set, A, B):
  <i> Glue(B, [(inot(i), A, e), (i, B, idEquiv(B))])

# transport along it IS e's function — definitionally, for an ABSTRACT e
def uaG_beta(A: Set, B: Set, e: Equiv(A, B), x: A) -> Path(B, coe(lambda i. uaG(A, B, e) @ i, i0, i1, x), fstE(A, B, e)(x)):
  <_> fstE(A, B, e)(x)

# the concrete instance: negation as a coherent equivalence (fibre contraction by cases)
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
# fill0 i j  (library: hfill (i=i1 -> t x0 k ; i=i0 -> g y) (g (p0 (~i))))
def fill0(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> t(x0) @ iand(j, k)), (inot(i), <k> g(y)), (inot(j), <k> g(p0 @ inot(i))) ], g(p0 @ inot(i)))

# fill2 i j (library: hfill (i=i1 -> fill1 k i1 ; i=i0 -> fill0 k i1) (g y))
def fill2(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> fill0(A, B, f, g, t, y, x1, p1, iand(j, k), i1))
            , (inot(i), <k> fill0(A, B, f, g, t, y, x0, p0, iand(j, k), i1))
            , (inot(j), <k> g(y)) ], g(y))

def pIso(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y)) -> Path(A, x0, x1):
  <i> fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1)

def sq(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> fill0(A, B, f, g, t, y, x1, p1, j, inot(k)))
            , (inot(i), <k> fill0(A, B, f, g, t, y, x0, p0, j, inot(k)))
            , (j, <k> t(fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1)) @ inot(k))
            , (inot(j), <k> g(y)) ], fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, j))

def sq1(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> B:
  hcompN(B, [ (i, <k> s(p1 @ inot(j)) @ k)
            , (inot(i), <k> s(p0 @ inot(j)) @ k)
            , (j, <k> s(f(fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1))) @ k)
            , (inot(j), <k> s(y) @ k) ], f(sq(A, B, f, g, t, y, x0, p0, x1, p1, i, j)))

def lemIso(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y)) -> Path(fiber(A, B, f, y), (x0, p0), (x1, p1)):
  <i> ( fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1)
      , <j> sq1(A, B, f, g, s, t, y, x0, p0, x1, p1, i, inot(j)) )

def isoToIsEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> isEquiv(A, B, f):
  lambda y. ((g(y), s(y)), lambda w. contrFib(A, B, f, g, s, t, y, w))
def contrFib(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, w: fiber(A, B, f, y)) -> Path(fiber(A, B, f, y), (g(y), s(y)), w):
  match w:
    case (x, p):
      lemIso(A, B, f, g, s, t, y, g(y), s(y), x, p)

def isoToEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> Equiv(A, B):
  (f, isoToIsEquiv(A, B, f, g, s, t))

def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <_> True
  else:
    <_> False
def negE() -> Equiv(Bool, Bool):
  isoToEquiv(Bool, Bool, neg, neg, negLnv, negLnv)
def viaGlue(x: Bool) -> Bool:
  coe(lambda i. uaG(Bool, Bool, negE()) @ i, i0, i1, x)
def viaGlueBwd(x: Bool) -> Bool:
  coe(lambda i. uaG(Bool, Bool, negE()) @ i, i1, i0, x)
def viaGlue_T() -> Path(Bool, viaGlue(True), False):
  <_> False
def viaGlueBwd_T() -> Path(Bool, viaGlueBwd(True), False):
  <_> False
def main() -> Bool:
  viaGlue(True)

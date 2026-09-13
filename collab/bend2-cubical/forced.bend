# isoToIsEquiv (Cubical.Foundations.Isomorphism, lemIso), transcribed:
# an isomorphism (f, g, s, t) has CONTRACTIBLE FIBRES.  hfill is inlined as
# hcompN with the extra (inot j) face.  Then totalEquiv: the fibre law
# A ≃ Σ B (fiber f) at the coherent level, for every f.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

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

# ---- the fibre law, coherent: A ≃ Σ B (fiber f)  (HoTT 4.8.2, totalEquiv)
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


# ---- ua of the fibre law: the lossless presentation as a PATH in Set,
# transported natively (coe) — the corpus's factoring a ↦ (f a, a, refl).
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
# transport along the fibre-law path IS the factoring (uaβ), and back
def present_is_tot(A: Set, B: Set, f: A -> B, a: A) -> Path(Total(A, B, f), present(A, B, f, a), tot(A, B, f, a)):
  <_> tot(A, B, f, a)
def retrieve_present(A: Set, B: Set, f: A -> B, a: A) -> Path(A, retrieve(A, B, f, present(A, B, f, a)), a):
  <_> a


# ============ the forcing theorem: the fibre is the ONLY residue ============
def ap(A: Set, B: Set, f: A -> B, x: A, y: A, p: Path(A, x, y)) -> Path(B, f(x), f(y)):
  <i> f(p @ i)
def pcomp(A: Set, x: A, y: A, z: A, p: Path(A, x, y), q: Path(A, y, z)) -> Path(A, x, z):
  <i> hcompN(A, [ (inot(i), <_> x), (i, <j> q @ j) ], p @ i)

# iso accessors of an equivalence, taking (f, h) UNPACKED (so types reduce)
def eqG(A: Set, B: Set, f: A -> B, h: isEquiv(A,B,f), y: B) -> A:
  invC(A, B, f, y, h(y))
def eqS(A: Set, B: Set, f: A -> B, h: isEquiv(A,B,f), y: B) -> Path(B, f(eqG(A,B,f,h,y)), y):
  secC(A, B, f, y, h(y))
def eqT(A: Set, B: Set, f: A -> B, h: isEquiv(A,B,f), x: A) -> Path(A, eqG(A,B,f,h,f(x)), x):
  retC(A, B, f, x, h(f(x)))

# compose equivalences (via the composed iso, no Iso-tuple matching)
def compEquiv(A: Set, B: Set, C: Set, e1: Equiv(A,B), e2: Equiv(B,C)) -> Equiv(A,C):
  match e1:
    case (f1, h1):
      match e2:
        case (f2, h2):
          isoToEquiv(A, C,
            lambda a. f2(f1(a)),
            lambda c. eqG(A,B,f1,h1, eqG(B,C,f2,h2,c)),
            lambda c. pcomp(C, f2(f1(eqG(A,B,f1,h1,eqG(B,C,f2,h2,c)))), f2(eqG(B,C,f2,h2,c)), c,
                        ap(B,C,f2, f1(eqG(A,B,f1,h1,eqG(B,C,f2,h2,c))), eqG(B,C,f2,h2,c), eqS(A,B,f1,h1, eqG(B,C,f2,h2,c))),
                        eqS(B,C,f2,h2,c)),
            lambda a. pcomp(A, eqG(A,B,f1,h1,eqG(B,C,f2,h2,f2(f1(a)))), eqG(A,B,f1,h1,f1(a)), a,
                        ap(B,A, lambda z. eqG(A,B,f1,h1,z), eqG(B,C,f2,h2,f2(f1(a))), f1(a), eqT(B,C,f2,h2,f1(a))),
                        eqT(A,B,f1,h1,a)))

# invert an equivalence
def invEquiv(A: Set, B: Set, e: Equiv(A,B)) -> Equiv(B,A):
  match e:
    case (f, h):
      isoToEquiv(B, A,
        lambda y. eqG(A,B,f,h,y),
        f,
        lambda x. eqT(A,B,f,h,x),
        lambda y. eqS(A,B,f,h,y))

# ---- fiberFst: the fibre of the first projection IS the family (the heart)
def SigT(B: Set, T: B -> Set) -> Set:
  any b: B. T(b)
def fstT(B: Set, T: B -> Set, s: SigT(B,T)) -> B:
  match s:
    case (b2, t): b2
def sndT(B: Set, T: B -> Set, s: SigT(B,T)) -> T(fstT(B,T,s)):
  match s:
    case (b2, t): t
def ffFun(B: Set, T: B -> Set, b: B, w: fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b)) -> T(b):
  match w:
    case (s, p):
      coe(lambda i. T(p @ i), i0, i1, sndT(B,T,s))
def ffInv(B: Set, T: B -> Set, b: B, t: T(b)) -> fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b):
  ( (b, t), <_> b )
def ffSec(B: Set, T: B -> Set, b: B, t: T(b)) -> Path(T(b), ffFun(B,T,b, ffInv(B,T,b,t)), t):
  <_> t
def ffRet(B: Set, T: B -> Set, b: B, w: fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b))
  -> Path(fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b), ffInv(B,T,b, ffFun(B,T,b,w)), w):
  match w:
    case (s, p):
      match s:
        case (b2, t):
          <j> ( (p @ inot(j), (<i> coe(lambda k. T(p @ iand(i, k)), i0, i, t)) @ inot(j)), <k> p @ ior(inot(j), k) )
def fiberFst(B: Set, T: B -> Set, b: B) -> Equiv(fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b), T(b)):
  isoToEquiv(fiber(SigT(B,T), B, lambda s. fstT(B,T,s), b), T(b),
             lambda w. ffFun(B,T,b,w), lambda t. ffInv(B,T,b,t),
             lambda t. ffSec(B,T,b,t), lambda w. ffRet(B,T,b,w))
def main2() -> Nat:
  0n

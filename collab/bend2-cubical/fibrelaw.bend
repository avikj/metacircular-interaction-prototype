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

# runtime instance: f = neg on Bool
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def presentNeg(x: Bool) -> Bool:
  match present(Bool, Bool, neg, x):
    case (b, a, q):
      b
def retrieveNeg(x: Bool) -> Bool:
  retrieve(Bool, Bool, neg, present(Bool, Bool, neg, x))

# the fibre-contractibility witness (the discriminator's content) executed:
# contrFib's path from the centre (neg y, refl) to w, observed at both ends.
# The fibre of neg over y=True is {False}: both ends must be False.
def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <_> True
  else:
    <_> False
def contrNeg0() -> Bool:
  match contrFib(Bool, Bool, neg, neg, negLnv, negLnv, True, (False, <_> True)) @ i0:
    case (x, _):
      x
def contrNeg1() -> Bool:
  match contrFib(Bool, Bool, neg, neg, negLnv, negLnv, True, (False, <_> True)) @ i1:
    case (x, _):
      x
def main() -> Bool:
  presentNeg(True)

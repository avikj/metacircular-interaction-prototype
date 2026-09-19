# Prelude � the Cubical.Foundations fragment the corpus leans on, in Bend.
# Loaded by `import Prelude`. Every definition computes; nothing is postulated.

# ---- h-levels
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A, x, y). all q: Path(A, x, y). Path(Path(A, x, y), p, q)

# ---- path algebra
def sym(A: Set, x: A, y: A, p: Path(A, x, y)) -> Path(A, y, x):
  <i> p @ inot(i)
def cong(A: Set, B: Set, f: A -> B, x: A, y: A, p: Path(A, x, y)) -> Path(B, f(x), f(y)):
  <i> f(p @ i)
def compPath(A: Set, x: A, y: A, z: A, p: Path(A, x, y), q: Path(A, y, z)) -> Path(A, x, z):
  <i> hcomp(A, i, <_> x, <j> q @ j, p @ i)
def transport(P: Interval -> Set, t: P(i0)) -> P(i1):
  coe(P, i0, i1, t)
def subst(A: Set, C: A -> Set, x: A, y: A, p: Path(A, x, y), d: C(x)) -> C(y):
  coe(lambda i. C(p @ i), i0, i1, d)
def J(A: Set, a: A, C: all b: A. (Path(A, a, b) -> Set), d: C(a, <_> a), b: A, p: Path(A, a, b)) -> C(b, p):
  coe(lambda i. C(p @ i, <j> p @ iand(i, j)), i0, i1, d)
def funext(A: Set, B: Set, f: A -> B, g: A -> B, h: all x: A. Path(B, f(x), g(x))) -> Path(A -> B, f, g):
  <i> lambda x. h(x) @ i

# ---- singletons are contractible: the whole of "output-bound is free"
def singl(A: Set, a: A) -> Set:
  any x: A. Path(A, a, x)
def isContrSingl(A: Set, a: A) -> isContr(singl(A, a)):
  ((a, <_> a), lambda s. match s: case (x, p): <i> (p @ i, <j> p @ iand(i, j)))

# ---- equivalences (fibrelaw.bend's lemIso, kept verbatim)
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)
def equivFun(A: Set, B: Set, e: Equiv(A, B)) -> A -> B:
  match e:
    case (f, p): f
def fill0(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> t(x0) @ iand(j, k)), (inot(i), <k> g(y)), (inot(j), <k> g(p0 @ inot(i))) ], g(p0 @ inot(i)))
def fill2(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> fill0(A, B, f, g, t, y, x1, p1, iand(j, k), i1))
            , (inot(i), <k> fill0(A, B, f, g, t, y, x0, p0, iand(j, k), i1))
            , (inot(j), <k> g(y)) ], g(y))
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
def contrFib(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, w: fiber(A, B, f, y)) -> Path(fiber(A, B, f, y), (g(y), s(y)), w):
  match w:
    case (x, p):
      lemIso(A, B, f, g, s, t, y, g(y), s(y), x, p)
def isoToIsEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> isEquiv(A, B, f):
  lambda y. ((g(y), s(y)), lambda w. contrFib(A, B, f, g, s, t, y, w))
def isoToEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> Equiv(A, B):
  (f, isoToIsEquiv(A, B, f, g, s, t))

# ---- naturals: addition and its laws; Nat is a set (encode-decode)
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n + p: 1n + add(p, b)
def plusZero(n: Nat) -> Path(Nat, add(n, 0n), n):
  match n:
    case 0n: <_> 0n
    case 1n + p: <i> 1n + (plusZero(p) @ i)
def plusSuc(m: Nat, n: Nat) -> Path(Nat, add(m, 1n + n), 1n + add(m, n)):
  match m:
    case 0n: <_> 1n + n
    case 1n + p: <i> 1n + (plusSuc(p, n) @ i)
def NatCode(m: Nat, n: Nat) -> Set:
  match m:
    case 0n:
      match n:
        case 0n: Unit
        case 1n + q: Empty
    case 1n + p:
      match n:
        case 0n: Empty
        case 1n + q: NatCode(p, q)
def natR(n: Nat) -> NatCode(n, n):
  match n:
    case 0n: ()
    case 1n + p: natR(p)
def natEncode(m: Nat, n: Nat, p: Path(Nat, m, n)) -> NatCode(m, n):
  coe(lambda i. NatCode(m, p @ i), i0, i1, natR(m))
def natDecode(m: Nat, n: Nat, c: NatCode(m, n)) -> Path(Nat, m, n):
  match m:
    case 0n:
      match n:
        case 0n: <_> 0n
        case 1n + q: absurd c
    case 1n + p:
      match n:
        case 0n: absurd c
        case 1n + q: <i> 1n + (natDecode(p, q, c) @ i)
def natCodeIsProp(m: Nat, n: Nat, c: NatCode(m, n), d: NatCode(m, n)) -> Path(NatCode(m, n), c, d):
  match m:
    case 0n:
      match n:
        case 0n: match c: case (): match d: case (): <_> ()
        case 1n + q: absurd c
    case 1n + p:
      match n:
        case 0n: absurd c
        case 1n + q: natCodeIsProp(p, q, c, d)
def natDecodeR(m: Nat) -> Path(Path(Nat, m, m), natDecode(m, m, natR(m)), <_> m):
  match m:
    case 0n: <_> <_> 0n
    case 1n + p: <i> <j> 1n + ((natDecodeR(p) @ i) @ j)
def natDecodeEncode(m: Nat, n: Nat, p: Path(Nat, m, n)) -> Path(Path(Nat, m, n), natDecode(m, n, natEncode(m, n, p)), p):
  J(Nat, m, lambda n2. lambda p2. Path(Path(Nat, m, n2), natDecode(m, n2, natEncode(m, n2, p2)), p2), natDecodeR(m), n, p)
def isSetNat(m: Nat, n: Nat, p: Path(Nat, m, n), q: Path(Nat, m, n)) -> Path(Path(Nat, m, n), p, q):
  compPath(Path(Nat, m, n), p, natDecode(m, n, natEncode(m, n, p)), q,
    sym(Path(Nat, m, n), natDecode(m, n, natEncode(m, n, p)), p, natDecodeEncode(m, n, p)),
    compPath(Path(Nat, m, n), natDecode(m, n, natEncode(m, n, p)), natDecode(m, n, natEncode(m, n, q)), q,
      cong(NatCode(m, n), Path(Nat, m, n), lambda c. natDecode(m, n, c), natEncode(m, n, p), natEncode(m, n, q),
           natCodeIsProp(m, n, natEncode(m, n, p), natEncode(m, n, q))),
      natDecodeEncode(m, n, q)))

# ---- lists
def length(A: Set, xs: A[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t: 1n + length(A, t)
def map(A: Set, B: Set, f: A -> B, xs: A[]) -> B[]:
  match xs:
    case []: []
    case h <> t: f(h) <> map(A, B, f, t)
def main() -> Nat:
  0n

# ---- more h-level tools
def neg(A: Set) -> Set:
  A -> Empty
def toPathP(B: Interval -> Set, x: B(i0), y: B(i1), p: Path(B(i1), transport(B, x), y)) -> PathP(B, x, y):
  <i> hcompN(B(i),
    [ (inot(i), <j> coe(lambda k. B(iand(i, k)), i0, i, x)), (i, <j> p @ j) ],
    coe(lambda k. B(iand(i, k)), i0, i, x))
def isPropToPathP(B: Interval -> Set, h: all i: Interval. isProp(B(i)), b0: B(i0), b1: B(i1)) -> PathP(B, b0, b1):
  toPathP(B, b0, b1, h(i1, transport(B, b0), b1))
def fst(A: Set, B: A -> Set, w: any a: A. B(a)) -> A:
  match w:
    case (a, b): a
def snd(A: Set, B: A -> Set, w: any a: A. B(a)) -> B(fst(A, B, w)):
  match w:
    case (a, b): b
# a product of propositions is a proposition
def isPropProd(A: Set, B: Set, pA: isProp(A), pB: isProp(B), x: any a: A. B, y: any a: A. B) -> Path(any a: A. B, x, y):
  <i> (pA(fst(A, lambda a. B, x), fst(A, lambda a. B, y)) @ i, pB(snd(A, lambda a. B, x), snd(A, lambda a. B, y)) @ i)
# double composite p ∙∙ q ∙∙ r
def compPath3(A: Set, w: A, x: A, y: A, z: A, p: Path(A, w, x), q: Path(A, x, y), r: Path(A, y, z)) -> Path(A, w, z):
  <i> hcompN(A, [ (inot(i), <j> p @ inot(j)), (i, <j> r @ j) ], q @ i)
def pred(n: Nat) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p: p
# no natural is its own double successor
def nNotSucSuc(n: Nat, e: Path(Nat, n, 2n + n)) -> Empty:
  match n:
    case 0n: natEncode(0n, 2n, e)
    case 1n + m: nNotSucSuc(m, <i> pred(e @ i))
# no natural is its own successor; Unit is a proposition, hence a set
def nNotSuc(n: Nat, e: Path(Nat, n, 1n + n)) -> Empty:
  match n:
    case 0n: natEncode(0n, 1n, e)
    case 1n + m: nNotSuc(m, <i> pred(e @ i))
def isPropUnit(x: Unit, y: Unit) -> Path(Unit, x, y):
  match x:
    case ():
      match y:
        case (): <_> ()
def isSetUnit(x: Unit, y: Unit, p: Path(Unit, x, y), q: Path(Unit, x, y)) -> Path(Path(Unit, x, y), p, q):
  isPropToIsSetU(x, y, p, q)
def isPropToIsSetU(a: Unit, b: Unit, p: Path(Unit, a, b), q: Path(Unit, a, b)) -> Path(Path(Unit, a, b), p, q):
  <j> <i> hcompN(Unit,
    [ (inot(i), <k> isPropUnit(a, a) @ k), (i, <k> isPropUnit(a, b) @ k)
    , (inot(j), <k> isPropUnit(a, p @ i) @ k), (j, <k> isPropUnit(a, q @ i) @ k) ], a)

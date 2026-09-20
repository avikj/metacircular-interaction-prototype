# isSetHProp, from scratch: discharges the last hypothesis of effectivity.
# Route: Path(Set,A,B) for props A,B is a retract of Iso5(A,B) via uaEta,
# and Iso5(A,B) is a prop; then Path(hProp,P,Q) is a retract of Path(Set,-,-).

def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y),p,q)
def isPropToIsSet(A: Set, h: isProp(A)) -> isSet(A):
  lambda a. lambda b. lambda p. lambda q. <j> <i> hcompN(A,
    [ (inot(i), <k> h(a, a) @ k), (i, <k> h(a, b) @ k)
    , (inot(j), <k> h(a, p @ i) @ k), (j, <k> h(a, q @ i) @ k) ], a)

def transport(P: Interval -> Set, t: P(i0)) -> P(i1):
  coe(P, i0, i1, t)
def toPathP(B: Interval -> Set, x: B(i0), y: B(i1), p: Path(B(i1), transport(B, x), y)) -> PathP(B, x, y):
  <i> hcompN(B(i),
    [ (inot(i), <j> coe(lambda k. B(iand(i, k)), i0, i, x)), (i, <j> p @ j) ],
    coe(lambda k. B(iand(i, k)), i0, i, x))
def isPropToPathP(B: Interval -> Set, h: all i: Interval. isProp(B(i)), b0: B(i0), b1: B(i1)) -> PathP(B, b0, b1):
  toPathP(B, b0, b1, h(i1, transport(B, b0), b1))

# generic: a retract of a prop is a prop.
def isPropRetract(X: Set, Y: Set, s: X -> Y, r: Y -> X,
                  ret: all x: X. Path(X, r(s(x)), x), pY: isProp(Y)) -> isProp(X):
  lambda x0. lambda x1. <i> hcompN(X,
    [ (inot(i), <k> ret(x0) @ k), (i, <k> ret(x1) @ k) ],
    r(pY(s(x0), s(x1)) @ i))

# non-dependent funext into a prop codomain
def isPropPi(A: Set, B: Set, pB: isProp(B)) -> isProp(all x: A. B):
  lambda f. lambda g. <i> lambda x. pB(f(x), g(x)) @ i

# Iso, univalence, uaEta (cubical_test5.bend)
def Iso5(A: Set, B: Set) -> Set:
  any f: A -> B. any g: B -> A. any gf: (all x:A. Path(A, g(f(x)), x)). (all y:B. Path(B, f(g(y)), y))
def idIso5(A: Set) -> Iso5(A, A):
  (lambda x. x, lambda x. x, lambda x. <_> x, lambda y. <_> y)
def ua5(A: Set, B: Set, e: Iso5(A, B)) -> Path(Set, A, B):
  match e:
    case (f, g, gf, fg): ua(A, B, f, g, gf, fg)
def pathToIso(A: Set, B: Set, p: Path(Set, A, B)) -> Iso5(A, B):
  coe(lambda i. Iso5(A, p @ i), i0, i1, idIso5(A))
def uaEta(A: Set, B: Set, p: Path(Set, A, B)) -> Path(Path(Set, A, B), ua5(A, B, pathToIso(A, B, p)), p):
  coe(lambda i. Path(Path(Set, A, p @ i), ua5(A, p @ i, pathToIso(A, p @ i, <j> p @ iand(i, j))), <j> p @ iand(i, j)), i0, i1, <i> <_> A)

# Iso5(A,B) is a prop when A,B are props.
def isPropIso5(A: Set, B: Set, pA: isProp(A), pB: isProp(B)) -> isProp(Iso5(A, B)):
  lambda I0. lambda I1.
    match I0:
      case (f0, g0, gf0, fg0):
        match I1:
          case (f1, g1, gf1, fg1):
            <i> ( isPropPi(A, B, pB)(f0, f1) @ i
                , isPropPi(B, A, pA)(g0, g1) @ i
                , isPropToPathP(
                    lambda i. (all x: A. Path(A, (isPropPi(B,A,pA)(g0,g1) @ i)((isPropPi(A,B,pB)(f0,f1) @ i)(x)), x)),
                    lambda i. lambda u. lambda v. <j> lambda x. isPropToIsSet(A, pA)((isPropPi(B,A,pA)(g0,g1) @ i)((isPropPi(A,B,pB)(f0,f1) @ i)(x)), x, u(x), v(x)) @ j,
                    gf0, gf1) @ i
                , isPropToPathP(
                    lambda i. (all y: B. Path(B, (isPropPi(A,B,pB)(f0,f1) @ i)((isPropPi(B,A,pA)(g0,g1) @ i)(y)), y)),
                    lambda i. lambda u. lambda v. <j> lambda y. isPropToIsSet(B, pB)((isPropPi(A,B,pB)(f0,f1) @ i)((isPropPi(B,A,pA)(g0,g1) @ i)(y)), y, u(y), v(y)) @ j,
                    fg0, fg1) @ i )

# hence Path(Set,A,B) is a prop for props A,B (retract of Iso5 via uaEta).
def isPropPathSet(A: Set, B: Set, pA: isProp(A), pB: isProp(B)) -> isProp(Path(Set, A, B)):
  isPropRetract(Path(Set, A, B), Iso5(A, B),
    lambda p. pathToIso(A, B, p),
    lambda e. ua5(A, B, e),
    lambda p. uaEta(A, B, p),
    isPropIso5(A, B, pA, pB))

def hProp() -> Set:
  any A: Set. isProp(A)
def hcar(P: hProp) -> Set:
  match P:
    case (A, p): A
def hpf(P: hProp) -> isProp(hcar(P)):
  match P:
    case (A, p): p
def isPropIsProp(A: Set, f: isProp(A), g: isProp(A)) -> Path(isProp(A), f, g):
  <i> lambda x. lambda y. isPropToIsSet(A, f, x, y, f(x, y), g(x, y)) @ i
def hPropExt(P: hProp, Q: hProp, e: Path(Set, hcar(P), hcar(Q))) -> Path(hProp, P, Q):
  <i> ( e @ i
      , isPropToPathP(lambda i. isProp(e @ i),
                      lambda i. lambda f. lambda g. isPropIsProp(e @ i, f, g),
                      hpf(P), hpf(Q)) @ i )
def congHcar(P: hProp, Q: hProp, r: Path(hProp, P, Q)) -> Path(Set, hcar(P), hcar(Q)):
  <i> hcar(r @ i)

# dependent: PathP over a prop-family is itself a prop.
def isPropDepPath(FAM: Interval -> Set, h: all i: Interval. isProp(FAM(i)), a0: FAM(i0), a1: FAM(i1))
    -> (all u: PathP(FAM, a0, a1). all v: PathP(FAM, a0, a1). Path(PathP(FAM, a0, a1), u, v)):
  lambda u. lambda v. <j> <i> hcompN(FAM(i),
    [ (inot(i), <k> h(i, coe(lambda m. FAM(iand(i,m)), i0, i, a0), coe(lambda m. FAM(iand(i,m)), i0, i, a0)) @ k)
    , (i,       <k> h(i, coe(lambda m. FAM(iand(i,m)), i0, i, a0), a1) @ k)
    , (inot(j), <k> h(i, coe(lambda m. FAM(iand(i,m)), i0, i, a0), u @ i) @ k)
    , (j,       <k> h(i, coe(lambda m. FAM(iand(i,m)), i0, i, a0), v @ i) @ k)
    ], coe(lambda m. FAM(iand(i,m)), i0, i, a0))

# generic: for a prop-fibered Sigma, the path space retracts onto the base path
# space (endpoints abstract, so no reduction gaps).  Base-path prop is a hypothesis.
def isPropSigPath(A: Set, B: A -> Set, pB: all a: A. isProp(B(a)),
                  a0: A, b0: B(a0), a1: A, b1: B(a1),
                  pBase: isProp(Path(A, a0, a1)))
    -> isProp(Path((any a: A. B(a)), (a0, b0), (a1, b1))):
  isPropRetract(Path((any a: A. B(a)), (a0, b0), (a1, b1)), Path(A, a0, a1),
    lambda r. <i> (match (r @ i) { case (a, b): a }),
    lambda p. <i> ( p @ i
                  , isPropToPathP(lambda i. B(p @ i), lambda i. pB(p @ i), b0, b1) @ i ),
    lambda r. <j> <i>
      ( (match (r @ i) { case (a, b): a })
      , ( isPropDepPath(lambda i. B(match (r @ i) { case (a, b): a }),
            lambda i. pB(match (r @ i) { case (a, b): a }),
            b0, b1)(
              isPropToPathP(lambda i. B(match (r @ i) { case (a, b): a }),
                lambda i. pB(match (r @ i) { case (a, b): a }), b0, b1),
              <i> (match (r @ i) { case (a, b): b })
            ) @ j ) @ i ),
    pBase)

# THE LEMMA: hProp is a set.  (hProp = Sigma A:Set. isProp A, a prop-fibered Sigma;
# the base path space Path(Set, hcar P, hcar Q) is a prop by isPropPathSet.)
def isSetHProp() -> isSet(hProp):
  lambda P. lambda Q.
    isPropSigPath(Set, lambda A. isProp(A), lambda A. lambda f. lambda g. isPropIsProp(A, f, g),
      hcar(P), hpf(P), hcar(Q), hpf(Q),
      isPropPathSet(hcar(P), hcar(Q), hpf(P), hpf(Q)))

def main() -> Nat:
  0n

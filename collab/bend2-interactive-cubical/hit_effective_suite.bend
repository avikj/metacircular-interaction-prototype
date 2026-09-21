# effective.bend of the suite, on the DECLARED set quotient: the effectivity
# theorem [a] == [b] => R a b, with the quotient's set-truncation branch of
# every recursion discharged by the target's own isSet.
type Quotient(A: Set, R: A -> A -> Set):
  case @cl:
    a: A
  path @eq(a: A, b: A, r: R(a, b)): Path(Quotient(A, R), @cl{a}, @cl{b})
  path @sq(x: Quotient(A, R), y: Quotient(A, R), p: Path(Quotient(A, R), x, y), q: Path(Quotient(A, R), x, y)): Path(Path(Quotient(A, R), x, y), p, q)
# Encode-decode: a code family Code : Q -> hProp by the recursor, then transport
# the reflexivity witness along the path.  The equivalence-relation structure and
# isSet hProp are inputs, exactly as the corpus's SQ.effective takes them.
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y),p,q)
def isPropToIsSet(A: Set, h: isProp(A)) -> isSet(A):
  lambda a. lambda b. lambda p. lambda q. <j> <i> hcompN(A,
    [ (inot(i), <k> h(a, a) @ k), (i, <k> h(a, b) @ k)
    , (inot(j), <k> h(a, p @ i) @ k), (j, <k> h(a, q @ i) @ k) ], a)
def isPropIsProp(A: Set, f: isProp(A), g: isProp(A)) -> Path(isProp(A), f, g):
  <i> lambda x. lambda y. isPropToIsSet(A, f, x, y, f(x, y), g(x, y)) @ i
def propExt(A: Set, B: Set, pA: isProp(A), pB: isProp(B), f: A -> B, g: B -> A) -> Path(Set, A, B):
  ua(A, B, f, g, lambda x. pA(g(f(x)), x), lambda y. pB(f(g(y)), y))
def hProp() -> Set:
  any A: Set. isProp(A)
def hcar(P: hProp) -> Set:
  match P:
    case (A, p): A
def hpf(P: hProp) -> isProp(hcar(P)):
  match P:
    case (A, p): p
def transport(P: Interval -> Set, t: P(i0)) -> P(i1):
  coe(P, i0, i1, t)
def subst(A: Set, C: A -> Set, a: A, b: A, p: Path(A, a, b), d: C(a)) -> C(b):
  coe(lambda i. C(p @ i), i0, i1, d)
def toPathP(B: Interval -> Set, x: B(i0), y: B(i1), p: Path(B(i1), transport(B, x), y)) -> PathP(B, x, y):
  <i> hcompN(B(i),
    [ (inot(i), <j> coe(lambda k. B(iand(i, k)), i0, i, x)), (i, <j> p @ j) ],
    coe(lambda k. B(iand(i, k)), i0, i, x))
def isPropToPathP(B: Interval -> Set, h: all i: Interval. isProp(B(i)), b0: B(i0), b1: B(i1)) -> PathP(B, b0, b1):
  toPathP(B, b0, b1, h(i1, transport(B, b0), b1))
def hPropExt(P: hProp, Q: hProp, e: Path(Set, hcar(P), hcar(Q))) -> Path(hProp, P, Q):
  <i> ( e @ i
      , isPropToPathP(lambda i. isProp(e @ i),
                      lambda i. lambda f. lambda g. isPropIsProp(e @ i, f, g),
                      hpf(P), hpf(Q)) @ i )

# --- the equivalence relation, structure threaded as inputs ---
# Code [x] = (R a x, prop), respecting eq/ via propExt + trans/sym.
def codePt(A: Set, R: A -> A -> Set, Rprop: all x: A. all y: A. isProp(R(x,y)), a: A, x: A) -> hProp:
  (R(a, x), Rprop(a, x))

def codeResp(A: Set, R: A -> A -> Set,
             Rprop: all x: A. all y: A. isProp(R(x,y)),
             Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
             Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
             a: A, x: A, y: A, w: R(x,y))
             -> Path(hProp, codePt(A,R,Rprop,a,x), codePt(A,R,Rprop,a,y)):
  hPropExt(codePt(A,R,Rprop,a,x), codePt(A,R,Rprop,a,y),
    propExt(R(a,x), R(a,y), Rprop(a,x), Rprop(a,y),
      lambda r. Rtrans(a, x, y, r, w),
      lambda r. Rtrans(a, y, x, r, Rsym(x, y, w))))

def Code(A: Set, R: A -> A -> Set,
         Rprop: all x: A. all y: A. isProp(R(x,y)),
         Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
         Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
         sh: isSet(hProp), a: A, m: Quotient(A, R)) -> hProp:
  hrec(m) {
    @cl: lambda x. codePt(A,R,Rprop,a,x) ;
    @eq: lambda x. lambda y. lambda w. codeResp(A,R,Rprop,Rsym,Rtrans,a,x,y,w) ;
    @sq: lambda x. lambda y. lambda p. lambda q.
      sh(Code(A,R,Rprop,Rsym,Rtrans,sh,a,x), Code(A,R,Rprop,Rsym,Rtrans,sh,a,y),
         <i> Code(A,R,Rprop,Rsym,Rtrans,sh,a,p @ i), <i> Code(A,R,Rprop,Rsym,Rtrans,sh,a,q @ i))
  }

def codeCar(A: Set, R: A -> A -> Set,
            Rprop: all x: A. all y: A. isProp(R(x,y)),
            Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
            Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
            sh: isSet(hProp), a: A, m: Quotient(A, R)) -> Set:
  hcar(Code(A,R,Rprop,Rsym,Rtrans,sh,a,m))

# encode: transport the reflexivity witness (codeCar (qcl a) = R a a) along p.
def encode(A: Set, R: A -> A -> Set,
           Rprop: all x: A. all y: A. isProp(R(x,y)),
           Rrefl: all x: A. R(x,x),
           Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
           Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
           sh: isSet(hProp), a: A, m: Quotient(A, R),
           p: Path(Quotient(A,R), @cl{a}, m))
           -> codeCar(A,R,Rprop,Rsym,Rtrans,sh,a,m):
  subst(Quotient(A,R), lambda m. codeCar(A,R,Rprop,Rsym,Rtrans,sh,a,m),
        @cl{a}, m, p, Rrefl(a))

# THE EFFECTIVITY THEOREM: [a] == [b] gives R a b (codeCar (qcl b) = R a b).
def effective(A: Set, R: A -> A -> Set,
              Rprop: all x: A. all y: A. isProp(R(x,y)),
              Rrefl: all x: A. R(x,x),
              Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
              Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
              sh: isSet(hProp), a: A, b: A,
              p: Path(Quotient(A,R), @cl{a}, @cl{b})) -> R(a, b):
  encode(A,R,Rprop,Rrefl,Rsym,Rtrans,sh,a,@cl{b},p)

# it computes: on the reflexive path [a]==[a], effective returns Rrefl a.
def effComputes(A: Set, R: A -> A -> Set,
                Rprop: all x: A. all y: A. isProp(R(x,y)),
                Rrefl: all x: A. R(x,x),
                Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
                Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
                sh: isSet(hProp), a: A)
                -> Path(R(a,a), effective(A,R,Rprop,Rrefl,Rsym,Rtrans,sh,a,a, <_> @cl{a}), Rrefl(a)):
  <_> Rrefl(a)

def main() -> Nat:
  0n

# Behavioral equivalence = path equality, for the minimal machine (BOTH ways).
# sameMeaning (minmachine.bend) gave  x ~ y  =>  [x] == [y]  (eq/).
# This wires the generic set-quotient effectivity (effective.bend) to the
# Nerode congruence to get the converse  [x] == [y]  =>  x ~ y, instantiated.
# Two hypotheses, exactly the corpus's: setO : isSet Bool (FutureQuotient),
# and sh : isSet hProp (SQ.effective).  Self-contained (Bend has no imports).

# ---- machine (minmachine.bend) ----
def S() -> Set: Nat
def observe(x: S) -> Bool:
  match x:
    case 0n: True
    case 1n+p: False
def step(x: S) -> S:
  match x:
    case 0n: 0n
    case 1n+p: p
def run(x: S, w: Nat) -> S:
  match w:
    case 0n: x
    case 1n+k: run(step(x), k)
def behavior(x: S, w: Nat) -> Bool:
  observe(run(x, w))
def Nerode(x: S, y: S) -> Set:
  all w: Nat. Path(Bool, behavior(x, w), behavior(y, w))
def Meaning() -> Set:
  Quot(S, Nerode)

# ---- hlevel + hProp (effective.bend) ----
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

# ---- generic effectivity (effective.bend) ----
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
         sh: isSet(hProp), a: A, m: Quot(A, R)) -> hProp:
  qrec(m, sh, lambda x. codePt(A,R,Rprop,a,x),
       lambda x. lambda y. lambda w. codeResp(A,R,Rprop,Rsym,Rtrans,a,x,y,w))
def codeCar(A: Set, R: A -> A -> Set,
            Rprop: all x: A. all y: A. isProp(R(x,y)),
            Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
            Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
            sh: isSet(hProp), a: A, m: Quot(A, R)) -> Set:
  hcar(Code(A,R,Rprop,Rsym,Rtrans,sh,a,m))
def encode(A: Set, R: A -> A -> Set,
           Rprop: all x: A. all y: A. isProp(R(x,y)),
           Rrefl: all x: A. R(x,x),
           Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
           Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
           sh: isSet(hProp), a: A, m: Quot(A, R),
           p: Path(Quot(A,R), qcl(a), m))
           -> codeCar(A,R,Rprop,Rsym,Rtrans,sh,a,m):
  subst(Quot(A,R), lambda m. codeCar(A,R,Rprop,Rsym,Rtrans,sh,a,m),
        qcl(a), m, p, Rrefl(a))
def effective(A: Set, R: A -> A -> Set,
              Rprop: all x: A. all y: A. isProp(R(x,y)),
              Rrefl: all x: A. R(x,x),
              Rsym: all x: A. all y: A. R(x,y) -> R(y,x),
              Rtrans: all x: A. all y: A. all z: A. R(x,y) -> R(y,z) -> R(x,z),
              sh: isSet(hProp), a: A, b: A,
              p: Path(Quot(A,R), qcl(a), qcl(b))) -> R(a, b):
  encode(A,R,Rprop,Rrefl,Rsym,Rtrans,sh,a,qcl(b),p)

# ---- Nerode is a prop-valued equivalence relation (machine-specific) ----
def reflN(x: S) -> Nerode(x, x):
  lambda w. <_> behavior(x, w)
def symN(x: S, y: S, e: Nerode(x, y)) -> Nerode(y, x):
  lambda w. <i> e(w) @ (inot(i))
def transN(x: S, y: S, z: S, e: Nerode(x, y), f: Nerode(y, z)) -> Nerode(x, z):
  lambda w. <i> hcompN(Bool,
    [ (inot(i), <_> behavior(x, w)), (i, <k> f(w) @ k) ], e(w) @ i)
def isPropNerode(setO: isSet(Bool), x: S, y: S) -> isProp(Nerode(x, y)):
  lambda e. lambda f. <i> lambda w. setO(behavior(x,w), behavior(y,w), e(w), f(w)) @ i

# ---- THE INSTANTIATION: [x] == [y]  =>  x ~ y, for the minimal machine ----
def nerodeEffective(setO: isSet(Bool), sh: isSet(hProp), x: S, y: S,
                    p: Path(Meaning, qcl(x), qcl(y))) -> Nerode(x, y):
  effective(S, Nerode,
    lambda a. lambda b. isPropNerode(setO, a, b),
    reflN,
    symN,
    transN,
    sh, x, y, p)

# both directions now compute for the machine:
#   sameMeaning : Nerode(x,y) -> Path(Meaning,[x],[y])   (minmachine.bend, eq/)
#   nerodeEffective : Path(Meaning,[x],[y]) -> Nerode(x,y)   (here)
# and on the reflexive path it returns reflexivity (definitional):
def nerodeEffComputes(setO: isSet(Bool), sh: isSet(hProp), x: S)
    -> Path(Nerode(x,x), nerodeEffective(setO, sh, x, x, <_> qcl(x)), reflN(x)):
  <_> reflN(x)

def main() -> Nat:
  0n

# hit_effective_suite.bend as a module: effectivity of the declared set quotient, [a] == [b] => R a b.
import SetQuotient
import HProp

def propExt(A: Set, B: Set, pA: isProp(A), pB: isProp(B), f: A -> B, g: B -> A) -> Path(Set, A, B):
  ua(A, B, f, g, lambda x. pA(g(f(x)), x), lambda y. pB(f(g(y)), y))
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

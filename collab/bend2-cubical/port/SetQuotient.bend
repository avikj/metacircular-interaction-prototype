# The set quotient as a declared HIT, with its recursor, its eliminators into
# propositions, and the h-level tools they need. (Cubical.HITs.SetQuotients)
import Prelude

type Quotient(A: Set, R: A -> A -> Set):
  case @cl:
    a: A
  path @eq(a: A, b: A, r: R(a, b)): Path(Quotient(A, R), @cl{a}, @cl{b})
  path @sq(x: Quotient(A, R), y: Quotient(A, R), p: Path(Quotient(A, R), x, y), q: Path(Quotient(A, R), x, y)): Path(Path(Quotient(A, R), x, y), p, q)

def squash(A: Set, R: A -> A -> Set) -> isSet(Quotient(A, R)):
  lambda x. lambda y. lambda p. lambda q. @sq{x, y, p, q}

# the recursor into a set
def quotRec(A: Set, R: A -> A -> Set, B: Set, sB: isSet(B), f: A -> B, resp: all a: A. all b: A. all r: R(a, b). Path(B, f(a), f(b)), m: Quotient(A, R)) -> B:
  hrec(m) {
    @cl: f ;
    @eq: resp ;
    @sq: lambda x. lambda y. lambda p. lambda q.
      sB(quotRec(A, R, B, sB, f, resp, x), quotRec(A, R, B, sB, f, resp, y),
         <i> quotRec(A, R, B, sB, f, resp, p @ i), <i> quotRec(A, R, B, sB, f, resp, q @ i))
  }

# a PathP in a family of propositions is a proposition (the isProp→isSet
# square, run in the dependent family)
def isPropPathP(B: Interval -> Set, h: all j: Interval. isProp(B(j)), b0: B(i0), b1: B(i1), r: PathP(B, b0, b1), s: PathP(B, b0, b1)) -> Path(PathP(B, b0, b1), r, s):
  <k> <j> hcompN(B(j),
    [ (inot(j), <m> h(i0, b0, b0) @ m), (j, <m> h(i1, b1, b1) @ m)
    , (inot(k), <m> h(j, r @ j, r @ j) @ m), (k, <m> h(j, r @ j, s @ j) @ m) ], r @ j)

# elimination into a family of propositions: the path and square branches are forced
def quotElimProp(A: Set, R: A -> A -> Set, P: Quotient(A, R) -> Set, pP: all m: Quotient(A, R). isProp(P(m)), f: all a: A. P(@cl{a}), m: Quotient(A, R)) -> P(m):
  helim(m, P) {
    @cl: f ;
    @eq: lambda a. lambda b. lambda r.
      isPropToPathP(lambda i. P(@eq{a, b, r} @ i), lambda i. pP(@eq{a, b, r} @ i), f(a), f(b)) ;
    @sq: lambda x. lambda y. lambda p. lambda q.
      isPropToPathP(lambda i. PathP(lambda j. P((@sq{x, y, p, q} @ i) @ j), quotElimProp(A, R, P, pP, f, x), quotElimProp(A, R, P, pP, f, y)),
                    lambda i. isPropPathP(lambda j. P((@sq{x, y, p, q} @ i) @ j), lambda j. pP((@sq{x, y, p, q} @ i) @ j), quotElimProp(A, R, P, pP, f, x), quotElimProp(A, R, P, pP, f, y)),
                    <j> quotElimProp(A, R, P, pP, f, p @ j), <j> quotElimProp(A, R, P, pP, f, q @ j))
  }

def quotElimProp2(A: Set, R: A -> A -> Set, P: Quotient(A, R) -> Quotient(A, R) -> Set, pP: all m: Quotient(A, R). all n: Quotient(A, R). isProp(P(m, n)), f: all a: A. all b: A. P(@cl{a}, @cl{b}), m: Quotient(A, R), n: Quotient(A, R)) -> P(m, n):
  quotElimProp(A, R, lambda m2. P(m2, n), lambda m2. pP(m2, n),
    lambda a. quotElimProp(A, R, lambda n2. P(@cl{a}, n2), lambda n2. pP(@cl{a}, n2), lambda b. f(a, b), n), m)

# function types into sets/props
def isSetPi(A: Set, B: A -> Set, sB: all a: A. isSet(B(a)), f: all a: A. B(a), g: all a: A. B(a), p: Path(all a: A. B(a), f, g), q: Path(all a: A. B(a), f, g)) -> Path(Path(all a: A. B(a), f, g), p, q):
  <i> <j> lambda a. (sB(a, f(a), g(a), <k> (p @ k)(a), <k> (q @ k)(a)) @ i) @ j
def isPropPi(A: Set, B: A -> Set, pB: all a: A. isProp(B(a)), f: all a: A. B(a), g: all a: A. B(a)) -> Path(all a: A. B(a), f, g):
  <i> lambda a. pB(a, f(a), g(a)) @ i
def funextInv(A: Set, B: A -> Set, f: all a: A. B(a), g: all a: A. B(a), p: Path(all a: A. B(a), f, g), a: A) -> Path(B(a), f(a), g(a)):
  <i> (p @ i)(a)

def main() -> Nat:
  0n

# quotient.bend of the suite, on the DECLARED set quotient.
type Quotient(A: Set, R: A -> A -> Set):
  case @cl:
    a: A
  path @eq(a: A, b: A, r: R(a, b)): Path(Quotient(A, R), @cl{a}, @cl{b})
  path @sq(x: Quotient(A, R), y: Quotient(A, R), p: Path(Quotient(A, R), x, y), q: Path(Quotient(A, R), x, y)): Path(Path(Quotient(A, R), x, y), p, q)
def R(a: Bool, b: Bool) -> Set:
  Path(Bool, a, b)
def Q() -> Set:
  Quotient(Bool, R)
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y), p, q)
def isSetQ() -> isSet(Q):
  lambda x. lambda y. lambda p. lambda q. @sq{x, y, p, q}
def loopT() -> Path(Q, @cl{True}, @cl{True}):
  <_> @cl{True}
def eqPath(a: Bool, b: Bool, w: R(a,b)) -> Path(Q, @cl{a}, @cl{b}):
  @eq{a, b, w}
def f(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n
def resp(a: Bool, b: Bool, w: R(a,b)) -> Path(Nat, f(a), f(b)):
  <i> f(w @ i)
# the recursor into a set; the set-truncation branch is forced by setB
def rec(setB: isSet(Nat), g: all b: Bool. Nat, gr: all a: Bool. all b: Bool. all w: R(a,b). Path(Nat, g(a), g(b)), q: Q) -> Nat:
  hrec(q) {
    @cl: g ;
    @eq: gr ;
    @sq: lambda x. lambda y. lambda p. lambda q2. setB(rec(setB, g, gr, x), rec(setB, g, gr, y), <i> rec(setB, g, gr, p @ i), <i> rec(setB, g, gr, q2 @ i))
  }
def recComputes(setB: isSet(Nat)) -> Path(Nat, rec(setB, f, resp, @cl{True}), 1n):
  <_> 1n
def recEq(setB: isSet(Nat), a: Bool, b: Bool, w: R(a, b), i: Interval) -> Path(Nat, rec(setB, f, resp, @eq{a, b, w} @ i), resp(a, b, w) @ i):
  <_> resp(a, b, w) @ i
def main() -> Nat:
  0n

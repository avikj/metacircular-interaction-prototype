# The set quotient as a declared HIT: point, generator path, and set-truncation (a 2-path constructor).
type Quotient(A: Set, R: A -> A -> Set):
  case @cl:
    a: A
  path @eq(a: A, b: A, r: R(a, b)): Path(Quotient(A, R), @cl{a}, @cl{b})
  path @sq(x: Quotient(A, R), y: Quotient(A, R), p: Path(Quotient(A, R), x, y), q: Path(Quotient(A, R), x, y)): Path(Path(Quotient(A, R), x, y), p, q)

def isSet(X: Set) -> Set:
  all x: X. all y: X. all p: Path(X, x, y). all q: Path(X, x, y). Path(Path(X, x, y), p, q)

def quotIsSet(A: Set, R: A -> A -> Set) -> isSet(Quotient(A, R)):
  lambda x. lambda y. lambda p. lambda q. @sq{x, y, p, q}

def Parity(a: Nat, b: Nat) -> Set:
  Unit

def half(A: Set, R: A -> A -> Set, B: Set, sB: isSet(B), f: A -> B, resp: all a: A. all b: A. all r: R(a, b). Path(B, f(a), f(b)), x: Quotient(A, R)) -> B:
  hrec(x) {
    @cl: f ;
    @eq: resp ;
    @sq: lambda x. lambda y. lambda p. lambda q. sB(half(A, R, B, sB, f, resp, x), half(A, R, B, sB, f, resp, y), <i> half(A, R, B, sB, f, resp, p @ i), <i> half(A, R, B, sB, f, resp, q @ i))
  }

def half_beta(A: Set, R: A -> A -> Set, B: Set, sB: isSet(B), f: A -> B, resp: all a: A. all b: A. all r: R(a, b). Path(B, f(a), f(b)), a: A) -> Path(B, half(A, R, B, sB, f, resp, @cl{a}), f(a)):
  <_> f(a)

def eq_endpoints(A: Set, R: A -> A -> Set, a: A, b: A, r: R(a, b)) -> Path(Quotient(A, R), @eq{a, b, r} @ i0, @cl{a}):
  <_> @cl{a}

def main() -> Nat:
  0n

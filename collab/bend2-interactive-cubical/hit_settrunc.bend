# Set truncation: a point constructor and a 2-path constructor over recursive fields.
type STrunc(A: Set):
  case @sin:
    a: A
  path @ssq(x: STrunc(A), y: STrunc(A), p: Path(STrunc(A), x, y), q: Path(STrunc(A), x, y)): Path(Path(STrunc(A), x, y), p, q)

def isSet(X: Set) -> Set:
  all x: X. all y: X. all p: Path(X, x, y). all q: Path(X, x, y). Path(Path(X, x, y), p, q)

def strIsSet(A: Set) -> isSet(STrunc(A)):
  lambda x. lambda y. lambda p. lambda q. @ssq{x, y, p, q}

def strec(A: Set, B: Set, sB: isSet(B), f: A -> B, x: STrunc(A)) -> B:
  hrec(x) {
    @sin: f ;
    @ssq: lambda x. lambda y. lambda p. lambda q. sB(strec(A, B, sB, f, x), strec(A, B, sB, f, y), <i> strec(A, B, sB, f, p @ i), <i> strec(A, B, sB, f, q @ i))
  }

def srec_beta(A: Set, B: Set, sB: isSet(B), f: A -> B, a: A) -> Path(B, strec(A, B, sB, f, @sin{a}), f(a)):
  <_> f(a)

def main() -> Nat:
  0n

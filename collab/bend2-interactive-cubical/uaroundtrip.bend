def Iso5(A: Set, B: Set) -> Set:
  any f: A -> B. any g: B -> A. any gf: (all x:A. Path(A, g(f(x)), x)). (all y:B. Path(B, f(g(y)), y))
def ua5(A: Set, B: Set, e: Iso5(A, B)) -> Path(Set, A, B):
  match e:
    case (f, g, gf, fg):
      ua(A, B, f, g, gf, fg)
def pathToIso(A: Set, B: Set, p: Path(Set, A, B)) -> Iso5(A, B):
  coe(lambda i. Iso5(A, p @ i), i0, i1, (lambda x. x, lambda x. x, lambda x. <_> x, lambda y. <_> y))
# the OTHER round trip, at the full Iso record level:
def uaRoundTrip(A: Set, B: Set, e: Iso5(A, B)) -> Iso5(A, B){pathToIso(A, B, ua5(A, B, e)) == e}:
  finally
def main() -> Nat:
  0n

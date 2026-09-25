# The root is a typed point whose TYPE mentions a recursive call on a bound
# variable: fiber(double, 4) = Σ x:Nat. Path(Nat, double(x), 4). Stock HVM4
# normalisation goes under the binder, unfolds double(x) to a match stuck on
# x, then unfolds the recursive call in its branches forever. A call on a
# neutral is already normal: the runtime normalises the branches of a stuck
# elimination without δ, so the type prints finitely.

def double(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n + m:
      1n + 1n + double(m)

def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)

def main() -> fiber(Nat, Nat, double, 4n):
  (2n, <_> 4n)

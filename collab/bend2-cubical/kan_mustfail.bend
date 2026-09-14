# Guards: the hcomp rules must not prove false equations.
def hcPiWrong(i: Interval, f: Bool -> Bool, g: Bool -> Bool, h: Path(Bool -> Bool, f, g), x: Bool) -> Path(Bool, hcompN(Bool -> Bool, [(i, <k> h @ k)], f)(x), f(x)):
  <_> f(x)
def hcNatWrong(i: Interval, n: Nat, m: Nat, q: Path(Nat, n, m)) -> Path(Nat, hcompN(Nat, [(i, <k> 1n + (q @ k))], 1n + n), 1n + n):
  <_> 1n + n

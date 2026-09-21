# The type-directed Kan rules for hcomp (CCHM): Pi, Sigma, PathP, Nat.
# Each states the rule as a DEFINITIONAL equation (<_> rhs), so it checks
# only if whnfHCm actually fires. Without the rules every one of these fails.
def fstB(t: any p: Bool. Bool) -> Bool:
  match t:
    case (a, b):
      a
# --- hcomp in Pi: (hcomp in A->B) applied to x = hcomp in B of the applications
def hcPi(i: Interval, f: Bool -> Bool, g: Bool -> Bool, h: Path(Bool -> Bool, f, g), x: Bool) -> Path(Bool, hcompN(Bool -> Bool, [(i, <k> h @ k)], f)(x), hcompN(Bool, [(i, <k> (h @ k)(x))], f(x))):
  <_> hcompN(Bool, [(i, <k> (h @ k)(x))], f(x))
# --- hcomp in Sigma: fst of the hcomp = hcomp of the fsts
def hcSig(i: Interval, u: any p: Bool. Bool, v: any p: Bool. Bool, h: Path(any p: Bool. Bool, u, v)) -> Path(Bool, fstB(hcompN(any p: Bool. Bool, [(i, <k> h @ k)], u)), hcompN(Bool, [(i, <k> fstB(h @ k))], fstB(u))):
  <_> hcompN(Bool, [(i, <k> fstB(h @ k))], fstB(u))
# --- hcomp in Path: pushes into the path dimension, adding the endpoint faces
def hcPath(i: Interval, p: Path(Bool,True,True), q: Path(Bool,True,True), h: Path(Path(Bool,True,True), p, q), j: Interval) -> Path(Bool, hcompN(Path(Bool,True,True), [(i, <k> h @ k)], p) @ j, hcompN(Bool, [(i, <k> (h @ k) @ j), (inot(j), <k> True), (j, <k> True)], p @ j)):
  <_> hcompN(Bool, [(i, <k> (h @ k) @ j), (inot(j), <k> True), (j, <k> True)], p @ j)
# --- hcomp in Nat (inductive): pushes through the Suc constructor
def hcNat(i: Interval, n: Nat, m: Nat, q: Path(Nat, n, m)) -> Path(Nat, hcompN(Nat, [(i, <k> 1n + (q @ k))], 1n + n), 1n + hcompN(Nat, [(i, <k> q @ k)], n)):
  <_> 1n + hcompN(Nat, [(i, <k> q @ k)], n)

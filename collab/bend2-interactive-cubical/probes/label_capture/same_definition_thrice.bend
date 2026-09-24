# Core: 16. Stock HVM4: OOM-killed (capture compounding). With fresh
# dimension names per δ-unfolding: 16 in 50 interactions.

def two(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def suc(n: Nat) -> Nat:
  1n + n

def main() -> Nat:
  two(Nat -> Nat, lambda g. two(Nat, lambda y. two(Nat, g, y)), suc, 0n)

# Core: 16. Full runtime: OOM-killed (label capture compounding).

def two(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def suc(n: Nat) -> Nat:
  1n + n

def main() -> Nat:
  two(Nat -> Nat, lambda g. two(Nat, lambda y. two(Nat, g, y)), suc, 0n)

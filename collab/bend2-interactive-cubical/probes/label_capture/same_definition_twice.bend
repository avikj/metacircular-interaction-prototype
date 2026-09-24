# Label-capture probe: Core evaluates main to 4 (1n+1n+1n+1n+0n). On the
# full runtime two δ-instances of `two` reuse its static dup label, so the
# inner dup annihilates the outer SUP it should commute with: result is
# λa.#Suc{a}. See distinct_definitions.bend (same program, two defs: 4).

def two(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def suc(n: Nat) -> Nat:
  1n + n

def main() -> Nat:
  two(Nat -> Nat, lambda g. two(Nat, g), suc, 0n)

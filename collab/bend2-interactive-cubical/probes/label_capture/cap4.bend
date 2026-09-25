def use(p: ∀A: Set. (A -> A) -> A -> A) -> Nat:
  p(Nat -> Nat, p(Nat), λn. 1n + n, 0n)

def main() -> Nat:
  use(λA. λg. λz. g(g(z)))

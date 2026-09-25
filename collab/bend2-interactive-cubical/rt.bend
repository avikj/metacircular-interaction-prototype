def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n + p:
      1n + add(p, b)
def add_comm_stub(a: Nat) -> Nat{add(a,0n) == a}:
  match a:
    case 0n:
      finally
    case 1n + p:
      rewrite add_comm_stub(p)
      finally
def main() -> Nat:
  add(add(7n, 8n), 6n)

def mul2(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n + p:
      2n + mul2(p)

def div2(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n:
      0n
    case 2n + p:
      1n + div2(p)

def div2_mul2(n: Nat) -> Nat{div2(mul2(n)) == n}:
  match n:
    case 0n:
      finally
    case 1n + p:
      rewrite div2_mul2(p)
      finally

def main() -> Nat:
  div2(mul2(21n))

# The machine that asks (One §7), with the law as its step (One §1).
# `bend interact_smoke.bend --interact` keeps the runtime's heap and the
# typed point (Nat, 3). Asking `double` moves it to
#   (Σ b:Nat. fiber double b, (6, (3, refl)))
# and asking `recover` (whose domain is exactly that type) returns the source
# 3: the retained coordinate, read off the carried point, not recomputed.

def double(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n + m:
      1n + 1n + double(m)

def recover(c: any b: Nat. any a: Nat. Path(Nat, double(a), b)) -> Nat:
  match c:
    case (b, w):
      match w:
        case (a, p):
          a

def main() -> Nat:
  3n

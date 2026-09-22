# Elementary natural-number ordering and minimum fold.

type NatOrdering:
  case @less:
  case @equal:
  case @greater:

def compareNat(a: Nat, b: Nat) -> NatOrdering:
  match a:
    case 0n:
      match b:
        case 0n: @equal
        case 1n + q: @less
    case 1n + p:
      match b:
        case 0n: @greater
        case 1n + q: compareNat(p, q)

def greaterNat(a: Nat, b: Nat) -> Bool:
  match compareNat(a, b):
    case @greater: True
    case @less: False
    case @equal: False

def minNat(a: Nat, b: Nat) -> Nat:
  if greaterNat(a, b): b else: a

def minNatList(xs: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case x <> rest: minNat(x, minNatList(rest))

def main() -> Nat:
  minNatList([7n, 3n, 11n, 2n, 5n])

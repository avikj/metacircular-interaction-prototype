# what upstream already had: J transports a value along an index proof;
# this still holds on the cubical core (the transport compiles to the
# identity). Pinned so the engineering document does not overclaim.
import Base

type Vec<-n: Nat> is Data:
  V{xs: List<&2, Nat>}

law add_zero:
  for n: Nat
  {Nat.add(n, 0n) == n : Nat}

def add_zero(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %add_zero(p) : {Succ{Nat.add(p, 0n)} == Succ{_} : Nat}
      {==}

def fix(n: Nat, v: Vec<Nat.add(n, 0n)>) -> Vec<n>:
  %add_zero(n) : Vec<_>
  v

def main() -> Vec<2n>:
  fix(2n, V{[7n, 8n]})

#|V{[7n, 8n]}

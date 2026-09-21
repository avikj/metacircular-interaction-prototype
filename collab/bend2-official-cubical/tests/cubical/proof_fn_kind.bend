# the kind of a type is its runtime content: a function into an equation
# is erased whole, so it is Data whatever its domain, even a domain of
# closures. h is used twice and stored in a Data record; upstream refuses
# both, and the first cubical rule (the domain's kind) refused this one
# too, since Nat -> Nat is Type.
import Base

type Cert is Data:
  mk{h: @f: (Nat -> Nat) -> {f(0n) == f(0n) : Nat}}

def twice(+h: @f: (Nat -> Nat) -> {f(0n) == f(0n) : Nat}) -> Cert:
  a = h(x => x)
  b = h(x => Nat.add(x, 1n))
  mk{h}

def main() -> Unit:
  c = twice(f => {==})
  Unit{}

#|Unit{}

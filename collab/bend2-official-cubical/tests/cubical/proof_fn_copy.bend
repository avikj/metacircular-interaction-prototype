# a proof-valued function copies: a function into an equation has its
# domain's kind, so over Nat it is Data and may be a + binder and a Data
# field. upstream refuses both (expected Data, observed Type).
import Base

def twice(+h: @x: Nat -> {x == x : Nat}) -> Unit:
  a = h(1n)
  b = h(2n)
  Unit{}

type Cert is Data:
  mk{f: @x: Nat -> {x == x : Nat}}

def main() -> Unit:
  twice(x => {==})

#|Unit{}

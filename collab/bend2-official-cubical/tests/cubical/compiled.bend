import Base

law add_zero:
  for n: Nat
  {Nat.add(n, 0n) == n : Nat}

def add_zero(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}

law add_zero_eta:
  {(x => Nat.add(x, 0n)) == (x => x) : Nat -> Nat}

def add_zero_eta(): i => x => add_zero(x)(i)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print(Nat.show(add_zero_eta()(i1)(2n)))

#|2

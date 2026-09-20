# a composite by hand: the square filler that composes two paths, as a
# path from a to c whose faces are the tubes' ends
import Base

law comp:
  for -A: Type
  for a: A
  for -b: A
  for -c: A
  for p: {a == b : A}
  for q: {b == c : A}
  {a == c : A}

def comp(A, a, b, c, p, q): j => hcomp(A, p(j), [(j == i0) i => a, (j == i1) i => q(i)])

# its faces compute
law comp_left:
  for -A: Type
  for -a: A
  for -b: A
  for -c: A
  for +p: {a == b : A}
  for +q: {b == c : A}
  {comp(A, a, b, c, p, q)(i0) == a : A}

def comp_left(A, a, b, c, p, q): {==}

law comp_right:
  for -A: Type
  for -a: A
  for -b: A
  for -c: A
  for +p: {a == b : A}
  for +q: {b == c : A}
  {comp(A, a, b, c, p, q)(i1) == c : A}

def comp_right(A, a, b, c, p, q): {==}

# a composite in a data type with constant tubes pushes into the constructor
def main() -> Nat:
  hcomp(Nat, 2n, [(i0 == i1) i => 2n])

#|2n

# coe transports along a live line by the shape of the type: constant
# lines, functions, constructors fieldwise, dependent lines
import Base

type Box<-A: Type> is Type:
  Bx{v: A}

# a hypothesis path between types, transported along
law tr:
  for -A: Type
  for -B: Type
  for p: {A == B : Type}
  for x: A
  B

def tr(A, B, p, x): coe(p, i0, i1, x)

# back and forth along the constant line is the identity, by computation
law tr_refl:
  for x: Nat
  {coe(i => Nat, i0, i1, x) == x : Nat}

def tr_refl(x): {==}

# a line of lists over a path of types, applied to a constructor, coerces
# the elements
law tr_list:
  for -A: Type
  for -B: Type
  for +p: {A == B : Type}
  for x: A
  for y: A
  List<B>

def tr_list(A, B, p, x, y): coe(i => List<p(i)>, i0, i1, [x, y])

# a dependent path: PathP over a line of types
law dep:
  for -A: Type
  for -B: Type
  for +p: {A == B : Type}
  for x: A
  {x == coe(p, i0, i1, x) : i => p(i)}

def dep(A, B, p, x): i => coe(p, i0, i, x)

# connections: a square from a path, its faces by De Morgan
law conn:
  for -A: Type
  for -a: A
  for -b: A
  for +p: {a == b : A}
  {(i => a) == p : i => {a == p(i) : A}}

def conn(A, a, b, p): j => i => p(i /\ j)

def main() -> List<Nat> & Nat:
  (coe(i => List<Nat>, i0, i1, [1n, 2n]), coe(i => Nat, i1, i0, 3n))

#|([1n, 2n], 3n)

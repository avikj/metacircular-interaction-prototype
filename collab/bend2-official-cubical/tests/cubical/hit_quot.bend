# a set quotient as a higher inductive type with parameters: the class
# constructor and the relation's path constructor; a recursor into Nat
# respects the relation by the path arm; the effectivity direction
import Base

type Quot<-A: Type, -R: @-a: A -> @-b: A -> Type> is Type:
  cl{a: A}
  path eq{-a: A, -b: A, r: R(a, b)}: {cl{a} == cl{b} : Quot<A, R>}

# the relation "equal in Nat": the quotient is Nat again
def Same(-a: Nat, -b: Nat) -> Type:
  {a == b : Nat}

def toNat(q: Quot<Nat, Same>) -> Nat:
  match q:
    case cl{a}:
      a
    case eq{a, b, r}:
      i => r(i)

law eq_faces:
  for -a: Nat
  for -b: Nat
  for r: {a == b : Nat}
  {eq{a, b, r}(i0) == cl{a} : Quot<Nat, Same>} & {eq{a, b, r}(i1) == cl{b} : Quot<Nat, Same>}

def eq_faces(a, b, r): ({==}, {==})

# the recursor on the path constructor is the arm: toNat(eq(r)(i)) = r(i)
law rec_eq:
  for -a: Nat
  for -b: Nat
  for +r: {a == b : Nat}
  {(i => toNat(eq{a, b, r}(i))) == r : {a == b : Nat}}

def rec_eq(a, b, r): {==}

# cong of the class constructor is a path in the quotient
law cl_path:
  for -a: Nat
  for -b: Nat
  for r: {a == b : Nat}
  {cl{a} == cl{b} : Quot<Nat, Same>}

def cl_path(a, b, r): eq{a, b, r}

def main() -> Nat:
  toNat(eq{1n, 1n, {==}}(i1))

#|1n

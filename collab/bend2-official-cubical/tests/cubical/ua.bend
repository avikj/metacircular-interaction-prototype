# univalence: ua of an equivalence is a path in Type, and transport along
# it is the equivalence's function, by computation
import Base

# transport along ua of the identity is the identity
law ua_id:
  for x: Nat
  {coe(ua(Nat, Nat, Equiv.id(Nat)), i0, i1, x) == x : Nat}

def ua_id(x): {==}

# the faces of ua are its types
law ua_faces:
  for -A: Type
  for -B: Type
  for e: Equiv(A, B)
  {ua(A, B, e)(i0) == A : Type} & {ua(A, B, e)(i1) == B : Type}

def ua_faces(A, B, e): ({==}, {==})

# transport along ua of an abstract equivalence is its function (ua beta)
law ua_beta:
  for -A: Type
  for -B: Type
  for e: Equiv(A, B)
  for x: A
  {coe(ua(A, B, e), i0, i1, x) == Equiv.fun(A, B, e)(x) : B}

def ua_beta(A, B, e, x): {==}

def main() -> Nat:
  coe(ua(Nat, Nat, Equiv.id(Nat)), i1, i0, 3n)

#|3n

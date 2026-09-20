# the wall: an erased path is a dead claim, and a live value does not
# transport along it
import Base

law bad:
  for -A: Type
  for -B: Type
  for -p: {A == B : Type}
  for x: A
  B

def bad(A, B, p, x): coe(p, i0, i1, x)

#|Error:
#|- expected : -p
#|- observed : p
#|Context:
#|- A : Type
#|- B : Type
#|Location: bad
#|11 | 
#|12>| def bad(A, B, p, x): coe(p, i0, i1, x)
#|13 | 
#|exit 1

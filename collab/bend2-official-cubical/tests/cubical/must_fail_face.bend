# a path lambda whose face is not the endpoint is refused
law bad:
  for -A: Type
  for -a: A
  for -b: A
  for p: {a == b : A}
  {b == a : A}

def bad(A, a, b, p): i => p(i)

#|Error:
#|- expected : b
#|- observed : p(i0)
#|Context:
#|- A : Type
#|- a : A
#|- b : A
#|- p : {a == b : A}
#|Location: bad
#| 8 | 
#| 9>| def bad(A, a, b, p): i => p(i)
#|10 | 
#|Note: the path's face at i0 must be that endpoint.
#|exit 1

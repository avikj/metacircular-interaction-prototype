# Restricted (Sub) types, CCHM: Sub(A, phi, u) is A[phi |-> u], the type of
# elements of A that are DEFINITIONALLY u wherever phi holds. inS injects and
# carries that obligation; outS projects back. They are what let the Kan
# operations be stated with their boundaries in the types.
def outS_inS(A: Set, x: A) -> Path(A, outS(inS(x)), x):
  <_> x
# on a TRUE face only u itself may be injected
def inS_true(A: Set, u: A) -> Sub(A, i1, u):
  inS(u)
# on a FALSE face there is no obligation
def inS_false(A: Set, u: A, x: A) -> Sub(A, i0, u):
  inS(x)
# on a symbolic face the obligation is checked cell by cell
def inS_sym(A: Set, p: Interval, u: A) -> Sub(A, p, u):
  inS(u)
# outS of a restricted element is in the carrier
def outS_ty(A: Set, p: Interval, u: A, s: Sub(A, p, u)) -> A:
  outS(s)
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def roundTrip(b: Bool) -> Bool:
  outS(inS(neg(b)))
def main() -> Bool:
  roundTrip(True)

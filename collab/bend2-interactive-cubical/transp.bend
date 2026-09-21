# transp(L, phi, x) : CCHM transport with a cofibration. L must be CONSTANT on
# phi; there transport is the IDENTITY, which is what makes the Kan operations
# for Sigma and Glue statable. Off phi it is ordinary transport.
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <_> True
  else:
    <_> False
def negPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, neg, neg, negLnv, negLnv)
# on a TRUE face transp is definitionally the identity (the line is constant)
def transp_true(A: Set, x: A) -> Path(A, transp(lambda i. A, i1, x), x):
  <_> x
# on a FALSE face it is ordinary transport
def transp_false(P: Interval -> Set, x: P(i0)) -> Path(P(i1), transp(P, i0, x), coe(P, i0, i1, x)):
  <_> coe(P, i0, i1, x)
# on a SYMBOLIC face over a constant line it is still the identity at both ends
def transp_sym(A: Set, p: Interval, x: A) -> A:
  transp(lambda i. A, p, x)
# a genuinely non-constant line is fine on the false face
def transp_neg(b: Bool) -> Bool:
  transp(lambda i. negPath() @ i, i0, b)
def main() -> Bool:
  transp_neg(True)

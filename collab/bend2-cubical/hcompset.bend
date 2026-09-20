# hcomp in the UNIVERSE beyond the composite shape: a square of types with a
# face on a second interval variable j. Transport along it is computed
# through Glue (hcomp Set = Glue, equivalence = transport back along the tube).
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
# a 2-dimensional composition in Set: faces on i AND on j
# at i=i0 the j-face is still live, so the left end is a Glue type, not Bool
def sq(j: Interval) -> Path(Set, hcompN(Set, [(j, <k> negPath() @ k)], Bool), Bool):
  <i> hcompN(Set, [(i, <k> negPath() @ k), (j, <k> negPath() @ k)], Bool)
# an element of the left end: True glued with the section False on face j
# (coherent: the face's equivalence is transport back along negPath = neg)
def viaSq(j: Interval) -> Bool:
  coe(lambda i. sq(j) @ i, i0, i1, glue(Bool, True, [(j, False)]))
# transport along the i-line at symbolic j: the true face at i1 wins â” neg
def viaSq_T(j: Interval) -> Path(Bool, viaSq(j), False):
  <_> False
# a single-face composition whose base line is itself non-constant
def twist() -> Path(Set, Bool, Bool):
  <i> hcompN(Set, [(i, <k> negPath() @ k)], negPath() @ i)
def viaTwist(x: Bool) -> Bool:
  coe(lambda i. twist() @ i, i0, i1, x)
def viaTwist_T() -> Path(Bool, viaTwist(True), True):
  <_> True
def main() -> Bool:
  viaSq(i0)

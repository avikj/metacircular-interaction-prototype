def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def neg_inv(x: Bool) -> Bool{neg(neg(x)) == x}:
  if x:
    finally
  else:
    finally
def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <_> True
  else:
    <_> False
def negPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, neg, neg, negLnv, negLnv)
def applyPath(A: Set, B: Set, p: Path(Set, A, B), x: A) -> B:
  coe(lambda i. p @ i, i0, i1, x)
def idPath() -> Path(Set, Bool, Bool):
  <_> Bool
def transNeg(x: Bool) -> Bool:
  applyPath(Bool, Bool, negPath(), x)
def transId(x: Bool) -> Bool:
  applyPath(Bool, Bool, idPath(), x)
def main() -> Nat:
  0n

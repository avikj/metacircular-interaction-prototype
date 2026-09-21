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
def idPath() -> Path(Set, Bool, Bool):
  <_> Bool
def applyPathFwd(A: Set, B: Set, p: Path(Set, A, B), x: A) -> B:
  coe(lambda i. p @ i, i0, i1, x)
def applyPathBwd(A: Set, B: Set, p: Path(Set, A, B), y: B) -> A:
  coe(lambda i. p @ i, i1, i0, y)
def main() -> Bool:
  applyPathFwd(Bool, Bool, negPath(), True)

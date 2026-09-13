def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def negI(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <i> True
  else:
    <i> False
def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, lambda x. neg(x), lambda x. neg(x), lambda x. negI(x), lambda x. negI(x))
def applyNeg(x: Bool) -> Bool:
  coe(lambda i. notPath() @ i, i0, i1, x)
def main() -> Bool:
  applyNeg(True)

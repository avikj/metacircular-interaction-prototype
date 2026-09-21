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
def cnt(a: Bool, b: Nat) -> Nat:
  if a:
    1n + b
  else:
    b
def main() -> &0{Bool, &1{Bool, &2{Bool, Bool}}}:
  coe(lambda i. &0{negPath() @ i, &1{Bool, &2{negPath() @ i, Bool}}}, i0, i1, &0{False, &1{True, &2{False, True}}})

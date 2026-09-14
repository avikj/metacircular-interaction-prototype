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
def main() -> Bool:
  &0{ coe(lambda i. negPath() @ i,i0,i1,True), &1{ coe(lambda i. negPath() @ i,i0,i1,False), &2{ coe(lambda i. negPath() @ i,i0,i1,True), coe(lambda i. negPath() @ i,i0,i1,False) }}}

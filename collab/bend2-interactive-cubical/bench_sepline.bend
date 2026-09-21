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
  &0{ coe(lambda i. negPath() @ i, i0, i1, False)
    , &1{ coe(lambda i. Bool, i0, i1, True)
        , &2{ coe(lambda i. negPath() @ i, i0, i1, False)
            , coe(lambda i. Bool, i0, i1, True) }}}

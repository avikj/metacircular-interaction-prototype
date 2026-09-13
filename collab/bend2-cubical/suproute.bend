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
# Sup x Path: transport a superposed value along a superposed line of types.
# label 0: first universe crosses negation, second crosses constant Bool.
def supRoute(p: &0{Bool, Bool}) -> &0{Bool, Bool}:
  coe(lambda i. &0{notPath() @ i, Bool}, i0, i1, p)
def main() -> &0{Bool, Bool}:
  supRoute(&0{True, True})

# A SUPERPOSED type line: transport along &0{negPath @ i, Bool} routes each
# universe along its own line â” the DUP-SUP rule as the fibre discriminator.
# On the full runtime this needs NO rule: the coe dispatch (a match) commutes
# over the superposition and the same-label dup of the value annihilates.
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
def supLine() -> Interval -> Set:
  lambda i. &0{negPath() @ i, Bool}
# checked definitionally (cubical_test4): &0{True,True} goes to &0{False,True}
def sup_transport() -> Path(&0{Bool, Bool}, coe(lambda i. supLine()(i), i0, i1, &0{True, True}), &0{False, True}):
  <i> &0{False, True}
def main() -> &0{Bool, Bool}:
  coe(lambda i. supLine()(i), i0, i1, &0{True, True})

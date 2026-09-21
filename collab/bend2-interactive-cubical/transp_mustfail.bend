# transp REJECTS a line that is not constant on the face.
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
def bad(b: Bool) -> Bool:
  transp(lambda i. negPath() @ i, i1, b)

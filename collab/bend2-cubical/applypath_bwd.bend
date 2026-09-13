# Backward transport at runtime: coe from i1 to i0 along a runtime-supplied
# universe path must apply the path's BACKWARD function (g), not f, and must
# not be erased. negPath's g is neg too, so use an asymmetric iso to tell
# f from g apart: Nat <-> Nat via (+1) / (-1) on the "wrapped" side is not
# an iso, so use Bool with f = neg, g = neg but observe direction via a
# tagged pair type instead: here we use idPath vs negPath and a wrapper.
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
# generic runtime transport, both directions, path supplied as data
def applyPathFwd(A: Set, B: Set, p: Path(Set, A, B), x: A) -> B:
  coe(lambda i. p @ i, i0, i1, x)
def applyPathBwd(A: Set, B: Set, p: Path(Set, A, B), y: B) -> A:
  coe(lambda i. p @ i, i1, i0, y)
def fwdNeg(x: Bool) -> Bool:
  applyPathFwd(Bool, Bool, negPath(), x)
def bwdNeg(x: Bool) -> Bool:
  applyPathBwd(Bool, Bool, negPath(), x)
def fwdId(x: Bool) -> Bool:
  applyPathFwd(Bool, Bool, idPath(), x)
def bwdId(x: Bool) -> Bool:
  applyPathBwd(Bool, Bool, idPath(), x)
def main() -> Nat:
  0n

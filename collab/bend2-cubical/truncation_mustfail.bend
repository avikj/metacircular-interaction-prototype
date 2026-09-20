# the recursor demands the TARGET be a proposition: Bool is not
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def boolNotProp() -> isProp(Bool):
  lambda x. lambda y. <_> x
def bad(t: Trunc(Bool)) -> Bool:
  trec(t, boolNotProp(), lambda b. b)
# tin is not injective: |x| and |y| are joined, so they are NOT distinguishable
def bad2(A: Set, x: A, y: A) -> Path(Trunc(A), tin(x), tin(x)):
  <i> tsquash(tin(x), tin(y)) @ i

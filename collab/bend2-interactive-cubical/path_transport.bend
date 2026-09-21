# Regression: transport preserves path interiors, endpoints, and dependent families.
# Run path_transport_test.py for frontend and unnormalized full-runtime observations.
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
type Segment:
  case @left:
  case @right:
  path @edge: Path(Segment, @left, @right)

def carryLoop(r: Interval, s: Interval) -> Path(Set, Bool, Bool):
  coe(lambda k. Path(Set, Bool, Bool), r, s, negPath())
def loopAction(r: Interval, s: Interval, x: Bool) -> Bool:
  coe(lambda j. carryLoop(r, s) @ j, i0, i1, x)
def carryEdge(r: Interval, s: Interval) -> Path(Segment, @left, @right):
  coe(lambda k. Path(Segment, @left, @right), r, s, @edge)
def growingEdge() -> Path(Segment, @left, @right):
  coe(lambda k. Path(Segment, @left, @edge @ k), i0, i1, <_> @left)
def shrinkingEdge() -> Path(Segment, @left, @left):
  coe(lambda k. Path(Segment, @left, @edge @ k), i1, i0, @edge)
def growingLeft() -> Path(Segment, growingEdge() @ i0, @left):
  <_> @left
def growingRight() -> Path(Segment, growingEdge() @ i1, @right):
  <_> @right
def shrinkingLeft() -> Path(Segment, shrinkingEdge() @ i0, @left):
  <_> @left
def shrinkingRight() -> Path(Segment, shrinkingEdge() @ i1, @left):
  <_> @left
# Both the ambient type and its endpoints vary along the transport line.
def movedTrue(k: Interval) -> negPath() @ k:
  coe(lambda i. negPath() @ i, i0, k, True)
def movingPath() -> Path(Bool, False, False):
  coe(lambda k. Path(negPath() @ k, movedTrue(k), movedTrue(k)), i0, i1, <_> True)
def movingBack() -> Path(Bool, True, True):
  coe(lambda k. Path(negPath() @ k, movedTrue(k), movedTrue(k)), i1, i0, <_> False)
# The path's own type family is dependent on j.
def negDependent() -> PathP(lambda j. negPath() @ j, True, False):
  <j> coe(lambda i. negPath() @ i, i0, j, True)
def carryDependent(r: Interval, s: Interval) -> PathP(lambda j. negPath() @ j, True, False):
  coe(lambda k. PathP(lambda j. negPath() @ j, True, False), r, s, negDependent())
# A nonconstant family: the transported path must retain negation's action.
def growingLoop() -> Path(Set, Bool, Bool):
  coe(lambda k. Path(Set, Bool, negPath() @ k), i0, i1, <_> Bool)
def growingLoopAction() -> Bool:
  coe(lambda j. growingLoop() @ j, i0, i1, True)
def growingLoopComputes() -> Path(Bool, growingLoopAction(), False):
  <_> False
def main() -> Bool:
  loopAction(i0, i1, True)

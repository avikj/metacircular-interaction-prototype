# Propositional truncation ||A||: a HIT whose PATH constructor joins ANY two
# elements, so the type is a proposition by construction. Its recursor goes
# into a proposition, and sends the squash path to the target's own proof.
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
# the squash path's endpoints are the two elements it joins
def sq_i0(A: Set, x: Trunc(A), y: Trunc(A)) -> Path(Trunc(A), tsquash(x, y) @ i0, x):
  <_> x
def sq_i1(A: Set, x: Trunc(A), y: Trunc(A)) -> Path(Trunc(A), tsquash(x, y) @ i1, y):
  <_> y
# ||A|| IS a proposition -- that is the point of the HIT
def truncIsProp(A: Set) -> isProp(Trunc(A)):
  lambda x. lambda y. <i> tsquash(x, y) @ i
# the recursor computes on the point constructor
def rec_in(A: Set, B: Set, pB: isProp(B), f: A -> B, a: A) -> Path(B, trec(tin(a), pB, f), f(a)):
  <_> f(a)
# and on the path constructor, at every interval
def rec_sq(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Trunc(A), y: Trunc(A), i: Interval) -> Path(B, trec(tsquash(x, y) @ i, pB, f), pB(trec(x, pB, f), trec(y, pB, f)) @ i):
  <_> pB(trec(x, pB, f), trec(y, pB, f)) @ i
# a concrete use: ||Bool|| -> Unit (Unit is a prop, so anything maps in)
def unitIsProp() -> isProp(Unit):
  lambda x. lambda y. match x: case (): match y: case (): <_> ()
def toUnit(t: Trunc(Bool)) -> Unit:
  trec(t, unitIsProp(), lambda b. ())
def main() -> Unit:
  toUnit(tin(True))

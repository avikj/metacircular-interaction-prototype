# truncation.bend of the suite, on the DECLARED truncation.
type PTrunc(A: Set):
  case @tin:
    a: A
  path @tsq(x: PTrunc(A), y: PTrunc(A)): Path(PTrunc(A), x, y)
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def sq_i0(A: Set, x: PTrunc(A), y: PTrunc(A)) -> Path(PTrunc(A), @tsq{x, y} @ i0, x):
  <_> x
def sq_i1(A: Set, x: PTrunc(A), y: PTrunc(A)) -> Path(PTrunc(A), @tsq{x, y} @ i1, y):
  <_> y
def truncIsProp(A: Set) -> isProp(PTrunc(A)):
  lambda x. lambda y. <i> @tsq{x, y} @ i
def prec(A: Set, B: Set, pB: isProp(B), f: A -> B, t: PTrunc(A)) -> B:
  hrec(t) { @tin: f ; @tsq: lambda x. lambda y. pB(prec(A, B, pB, f, x), prec(A, B, pB, f, y)) }
def rec_in(A: Set, B: Set, pB: isProp(B), f: A -> B, a: A) -> Path(B, prec(A, B, pB, f, @tin{a}), f(a)):
  <_> f(a)
def rec_sq(A: Set, B: Set, pB: isProp(B), f: A -> B, x: PTrunc(A), y: PTrunc(A), i: Interval) -> Path(B, prec(A, B, pB, f, @tsq{x, y} @ i), pB(prec(A, B, pB, f, x), prec(A, B, pB, f, y)) @ i):
  <_> pB(prec(A, B, pB, f, x), prec(A, B, pB, f, y)) @ i
def unitIsProp() -> isProp(Unit):
  lambda x. lambda y. match x: case (): match y: case (): <_> ()
def toUnit(t: PTrunc(Bool)) -> Unit:
  prec(Bool, Unit, unitIsProp(), lambda b. (), t)
def main() -> Unit:
  toUnit(@tin{True})

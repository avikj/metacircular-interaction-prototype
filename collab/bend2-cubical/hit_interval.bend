# The interval as a HIT: two points and a segment.  It is contractible, and
# from it function extensionality follows without any funext primitive.
hit I:
  case @zero
  case @one
  path @seg: I/zero ~> I/one

def seg_i0() -> Path(I, I/seg @ i0, I/zero):
  <_> I/zero
def contr(x: I) -> Path(I, I/zero, x):
  I/elim(lambda y. Path(I, I/zero, y), x, <_> I/zero, <i> I/seg @ i, <i> <j> I/seg @ iand(i, j))
def contr_zero() -> Path(Path(I, I/zero, I/zero), contr(I/zero), <_> I/zero):
  <_> <_> I/zero
def contr_one() -> Path(Path(I, I/zero, I/one), contr(I/one), <i> I/seg @ i):
  <_> <i> I/seg @ i
# function extensionality from the interval: h(x) = elim into B sending
# zero to f(x), one to g(x), the segment to p(x)
def funextI(A: Set, B: Set, f: A -> B, g: A -> B, p: all x: A. Path(B, f(x), g(x))) -> Path(A -> B, f, g):
  <i> lambda x. I/elim(lambda _. B, I/seg @ i, f(x), g(x), <k> p(x) @ k)
def funextI_i0(A: Set, B: Set, f: A -> B, g: A -> B, p: all x: A. Path(B, f(x), g(x)), x: A) -> Path(B, (funextI(A, B, f, g, p) @ i0)(x), f(x)):
  <_> f(x)
def main() -> Bool:
  I/elim(lambda _. Bool, I/seg @ i1, True, True, <_> True)

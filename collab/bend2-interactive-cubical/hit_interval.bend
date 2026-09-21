# The interval as a HIT: two points and a segment.  It is contractible, and
# from it function extensionality follows without any funext primitive.
type I:
  case @zero:
  case @one:
  path @seg: Path(I, @zero, @one)

def seg_i0() -> Path(I, @seg @ i0, @zero):
  <_> @zero
def contr(x: I) -> Path(I, @zero, x):
  helim(x, lambda y. Path(I, @zero, y)) { @zero: <_> @zero ; @one: <i> @seg @ i ; @seg: <i> <j> @seg @ iand(i, j) }
def contr_zero() -> Path(Path(I, @zero, @zero), contr(@zero), <_> @zero):
  <_> <_> @zero
def contr_one() -> Path(Path(I, @zero, @one), contr(@one), <i> @seg @ i):
  <_> <i> @seg @ i
# function extensionality from the interval: h(x) = rec into B sending
# zero to f(x), one to g(x), the segment to p(x)
def funextI(A: Set, B: Set, f: A -> B, g: A -> B, p: all x: A. Path(B, f(x), g(x))) -> Path(A -> B, f, g):
  <i> lambda x. hrec(@seg @ i) { @zero: f(x) ; @one: g(x) ; @seg: <k> p(x) @ k }
def funextI_i0(A: Set, B: Set, f: A -> B, g: A -> B, p: all x: A. Path(B, f(x), g(x)), x: A) -> Path(B, (funextI(A, B, f, g, p) @ i0)(x), f(x)):
  <_> f(x)
def main() -> Bool:
  hrec(@seg @ i1) { @zero: True ; @one: True ; @seg: <_> True }

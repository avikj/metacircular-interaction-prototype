# circle.bend of the suite, on the DECLARED circle instead of the hardcoded S1.
type Circle:
  case @base:
  path @loop: Path(Circle, @base, @base)

def loop_i0() -> Path(Circle, @loop @ i0, @base):
  <_> @base
def loop_i1() -> Path(Circle, @loop @ i1, @base):
  <_> @base
def rec(B: Set, b: B, l: Path(B, b, b), x: Circle) -> B:
  hrec(x) { @base: b ; @loop: l }
def rec_base(B: Set, b: B, l: Path(B, b, b)) -> Path(B, rec(B, b, l, @base), b):
  <_> b
def rec_loop(B: Set, b: B, l: Path(B, b, b), i: Interval) -> Path(B, rec(B, b, l, @loop @ i), l @ i):
  <_> l @ i
def toBool(x: Circle) -> Bool:
  rec(Bool, True, <_> True, x)
def toBool_base() -> Path(Bool, toBool(@base), True):
  <_> True
def toBool_loop(i: Interval) -> Path(Bool, toBool(@loop @ i), True):
  <_> True
def loopInv() -> Path(Circle, @base, @base):
  <i> @loop @ inot(i)
def main() -> Bool:
  toBool(@loop @ i1)

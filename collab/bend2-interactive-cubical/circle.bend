# The circle S1: a HIT with one POINT constructor (s1base) and one PATH
# constructor (s1loop : Path(S1, s1base, s1base)). Its recursor is driven by the path
# constructor: srec(s1loop @ i, b, l) = l @ i. This is the second HIT in the
# language (after the set-quotient) and the first with a non-trivial s1loop.
def loop_i0() -> Path(S1, s1loop @ i0, s1base):
  <_> s1base
def loop_i1() -> Path(S1, s1loop @ i1, s1base):
  <_> s1base
# the recursor computes on the point constructor
def rec_base(B: Set, b: B, l: Path(B, b, b)) -> Path(B, srec(s1base, b, l), b):
  <_> b
# and on the path constructor, at every interval
def rec_loop(B: Set, b: B, l: Path(B, b, b), i: Interval) -> Path(B, srec(s1loop @ i, b, l), l @ i):
  <_> l @ i
# a map S1 -> Bool sending s1loop to refl: every point goes to True
def toBool(x: S1) -> Bool:
  srec(x, True, <_> True)
def toBool_base() -> Path(Bool, toBool(s1base), True):
  <_> True
def toBool_loop(i: Interval) -> Path(Bool, toBool(s1loop @ i), True):
  <_> True
# the s1loop is a genuine element of the path space: reversing it is a path too
def loopInv() -> Path(S1, s1base, s1base):
  <i> s1loop @ inot(i)
def main() -> Bool:
  toBool(s1loop @ i1)

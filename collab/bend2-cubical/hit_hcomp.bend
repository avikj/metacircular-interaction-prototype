# The dependent eliminator computes on hcomp CELLS of a HIT (the rule that
# makes a function out of a HIT compute on composites): with a constant
# motive, helim(hcomp [Ï â¦ u] x) IS hcomp [Ï â¦ helim(u)] (helim x),
# definitionally; and transport along a HIT line commutes with hcomp.
type Circle:
  case @base:
  path @loop: Path(Circle, @base, @base)
def toBool(x: Circle) -> Bool:
  helim(x, lambda _. Bool) { @base: True ; @loop: <_> True }
def elim_hcomp(i: Interval) -> Path(Bool, toBool(hcompN(Circle, [(i, <k> @loop @ k)], @base)), hcompN(Bool, [(i, <k> toBool(@loop @ k))], toBool(@base))):
  <_> hcompN(Bool, [(i, <k> toBool(@loop @ k))], toBool(@base))
def elim_hcomp_face() -> Path(Bool, toBool(hcompN(Circle, [(i1, <k> @loop @ k)], @base)), True):
  <_> True
def idC(x: Circle) -> Circle:
  helim(x, lambda _. Circle) { @base: @base ; @loop: <i> @loop @ i }
def idC_hcomp(i: Interval) -> Path(Circle, idC(hcompN(Circle, [(i, <k> @loop @ k)], @base)), hcompN(Circle, [(i, <k> idC(@loop @ k))], idC(@base))):
  <_> hcompN(Circle, [(i, <k> idC(@loop @ k))], idC(@base))
type Susp(A: Set):
  case @north:
  case @south:
  path @merid(a: A): Path(Susp(A), @north, @south)
def Not(b: Bool) -> Bool:
  if b:
    False
  else:
    True
def notInv(b: Bool) -> Path(Bool, Not(Not(b)), b):
  if b:
    <_> True
  else:
    <_> False
def suspLine(i: Interval) -> Set:
  Susp(ua(Bool, Bool, lambda x. Not(x), lambda x. Not(x), lambda x. notInv(x), lambda x. notInv(x)) @ i)
def coe_hcomp(i: Interval) -> Path(Susp(Bool), coe(suspLine, i0, i1, hcompN(Susp(Bool), [(i, <k> @merid{True} @ k)], @north)), hcompN(Susp(Bool), [(i, <k> coe(suspLine, i0, i1, @merid{True} @ k))], coe(suspLine, i0, i1, @north))):
  <_> hcompN(Susp(Bool), [(i, <k> coe(suspLine, i0, i1, @merid{True} @ k))], coe(suspLine, i0, i1, @north))
def main() -> Bool:
  toBool(hcompN(Circle, [(i1, <k> @loop @ k)], @base))

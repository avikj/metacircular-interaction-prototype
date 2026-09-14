# The eliminator computes on hcomp CELLS of a hit (the rule that makes a
# function out of a HIT compute on composites, as in Cubical Agda): with a
# constant motive, elim(hcomp [φ ↦ u] x) IS hcomp [φ ↦ elim(u)] (elim x),
# definitionally; and transport along a hit line commutes with hcomp.
hit Circle:
  case @base
  path @loop: Circle/base ~> Circle/base
def toBool(x: Circle) -> Bool:
  Circle/elim(lambda _. Bool, x, True, <_> True)
def elim_hcomp(i: Interval) -> Path(Bool, toBool(hcompN(Circle, [(i, <k> Circle/loop @ k)], Circle/base)), hcompN(Bool, [(i, <k> toBool(Circle/loop @ k))], toBool(Circle/base))):
  <_> hcompN(Bool, [(i, <k> toBool(Circle/loop @ k))], toBool(Circle/base))
# with a general motive it is the dependent composition over the filler; at a
# true face it is the tube's top, at no live face the base — the Kan laws
def elim_hcomp_face() -> Path(Bool, toBool(hcompN(Circle, [(i1, <k> Circle/loop @ k)], Circle/base)), True):
  <_> True
# the identity on the circle, by elimination, on a composite cell
def idC(x: Circle) -> Circle:
  Circle/elim(lambda _. Circle, x, Circle/base, <i> Circle/loop @ i)
def idC_hcomp(i: Interval) -> Path(Circle, idC(hcompN(Circle, [(i, <k> Circle/loop @ k)], Circle/base)), hcompN(Circle, [(i, <k> idC(Circle/loop @ k))], idC(Circle/base))):
  <_> hcompN(Circle, [(i, <k> idC(Circle/loop @ k))], idC(Circle/base))
# a suspension line with a varying parameter: transport commutes with hcomp
hit Susp<A: Set>:
  case @north
  case @south
  path @merid(a: A): Susp/north(A) ~> Susp/south(A)
def Not(b: Bool) -> Bool:
  match b:
    case False: True
    case True: False
def suspLine(i: Interval) -> Set:
  Susp(ua(Bool, Bool, Not, Not, lambda b. match b: case False: <_> False case True: <_> True, lambda b. match b: case False: <_> False case True: <_> True) @ i)
def coe_hcomp(i: Interval) -> Path(Susp(Bool), coe(suspLine, i0, i1, hcompN(Susp(Bool), [(i, <k> Susp/merid(Bool, True) @ k)], Susp/north(Bool))), hcompN(Susp(Bool), [(i, <k> coe(suspLine, i0, i1, Susp/merid(Bool, True) @ k))], coe(suspLine, i0, i1, Susp/north(Bool)))):
  <_> hcompN(Susp(Bool), [(i, <k> coe(suspLine, i0, i1, Susp/merid(Bool, True) @ k))], coe(suspLine, i0, i1, Susp/north(Bool)))
def main() -> Bool:
  toBool(hcompN(Circle, [(i1, <k> Circle/loop @ k)], Circle/base))

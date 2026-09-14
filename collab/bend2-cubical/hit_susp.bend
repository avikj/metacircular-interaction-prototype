# The suspension, a PARAMETRISED hit: two points and a meridian for every a: A.
#   hit Susp<A: Set>: case @north  case @south  path @merid(a: A): north ~> south
# Susp(Bool) is the circle up to homotopy; Susp(Unit) the interval.
hit Susp<A: Set>:
  case @north
  case @south
  path @merid(a: A): Susp/north(A) ~> Susp/south(A)

def merid_i0(A: Set, a: A) -> Path(Susp(A), Susp/merid(A, a) @ i0, Susp/north(A)):
  <_> Susp/north(A)
def merid_i1(A: Set, a: A) -> Path(Susp(A), Susp/merid(A, a) @ i1, Susp/south(A)):
  <_> Susp/south(A)

# the eliminator, non-dependent: a "suspension of f" into any type with two
# points and a path for each a
def rec(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s), x: Susp(A)) -> B:
  Susp/elim(A, lambda _. B, x, n, s, m)
def rec_north(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s)) -> Path(B, rec(A, B, n, s, m, Susp/north(A)), n):
  <_> n
def rec_merid(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s), a: A, i: Interval) -> Path(B, rec(A, B, n, s, m, Susp/merid(A, a) @ i), m(a) @ i):
  <_> m(a) @ i

# Susp(Unit) -> Interval-like: collapse both poles to True; every meridian goes to refl
def collapse(x: Susp(Unit)) -> Bool:
  Susp/elim(Unit, lambda _. Bool, x, True, True, lambda u. <_> True)
def collapse_merid(i: Interval) -> Path(Bool, collapse(Susp/merid(Unit, ()) @ i), True):
  <_> True

# TRANSPORT along a line of the HIT whose PARAMETER varies: Susp(ua(neg) @ i).
# A point constructor is rebuilt at the new parameter; a meridian's field is
# transported along the parameter line — merid(True) becomes merid(False).
def neg(b: Bool) -> Bool:
  match b:
    case False: True
    case True: False
def negneg(b: Bool) -> Path(Bool, neg(neg(b)), b):
  match b:
    case False: <_> False
    case True: <_> True
def negPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, neg, neg, negneg, negneg)
def suspLine(i: Interval) -> Set:
  Susp(negPath() @ i)
def transportNorth() -> Path(Susp(Bool), coe(suspLine, i0, i1, Susp/north(Bool)), Susp/north(Bool)):
  <_> Susp/north(Bool)
def transportMerid(j: Interval) -> Path(Susp(Bool), coe(suspLine, i0, i1, Susp/merid(Bool, True) @ j), Susp/merid(Bool, False) @ j):
  <_> Susp/merid(Bool, False) @ j
def transportMeridBack(j: Interval) -> Path(Susp(Bool), coe(suspLine, i1, i0, Susp/merid(Bool, False) @ j), Susp/merid(Bool, True) @ j):
  <_> Susp/merid(Bool, True) @ j

# Susp(Bool) -> Bool, poles to True and False are NOT joinable (Bool has no
# such path, see hit_mustfail); send both poles to True and every meridian to refl
def which(x: Susp(Bool)) -> Bool:
  Susp/elim(Bool, lambda _. Bool, x, True, True, lambda b. <_> True)
def which_north() -> Path(Bool, which(Susp/north(Bool)), True):
  <_> True
def which_merid(b: Bool, i: Interval) -> Path(Bool, which(Susp/merid(Bool, b) @ i), True):
  <_> True
def main() -> Bool:
  which(coe(suspLine, i0, i1, Susp/merid(Bool, True) @ i1))

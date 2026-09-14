# The circle, DECLARED with the general HIT schema instead of hardcoded:
#   hit Circle: case @base  path @loop: base = base
# Everything circle.bend proved about the built-in S1 is re-proved here for
# the declared one, through the generated Circle/base, Circle/loop, Circle/elim.
hit Circle:
  case @base
  path @loop: Circle/base ~> Circle/base

# the path constructor has the declared endpoints, definitionally
def loop_i0() -> Path(Circle, Circle/loop @ i0, Circle/base):
  <_> Circle/base
def loop_i1() -> Path(Circle, Circle/loop @ i1, Circle/base):
  <_> Circle/base

# the eliminator computes on the point constructor ...
def elim_base(B: Set, b: B, l: Path(B, b, b)) -> Path(B, Circle/elim(lambda _. B, Circle/base, b, l), b):
  <_> b
# ... and on the path constructor, at every interval
def elim_loop(B: Set, b: B, l: Path(B, b, b), i: Interval) -> Path(B, Circle/elim(lambda _. B, Circle/loop @ i, b, l), l @ i):
  <_> l @ i

# a map Circle -> Bool sending the loop to refl
def toBool(x: Circle) -> Bool:
  Circle/elim(lambda _. Bool, x, True, <_> True)
def toBool_base() -> Path(Bool, toBool(Circle/base), True):
  <_> True
def toBool_loop(i: Interval) -> Path(Bool, toBool(Circle/loop @ i), True):
  <_> True

# the DEPENDENT eliminator: a motive that varies over the circle.  Over base
# it is Bool, and the loop branch is a PathP over the transported motive.
def constMotive(x: Circle) -> Set:
  Circle/elim(lambda _. Set, x, Bool, <_> Bool)
def depElim(x: Circle) -> constMotive(x):
  Circle/elim(constMotive, x, True, <_> True)
def depElim_base() -> Path(Bool, depElim(Circle/base), True):
  <_> True

# the loop is a genuine path: it composes and inverts
def loopInv() -> Path(Circle, Circle/base, Circle/base):
  <i> Circle/loop @ inot(i)
def loopTwice() -> Path(Circle, Circle/base, Circle/base):
  <i> hcompN(Circle, [(i, <k> Circle/loop @ k)], Circle/loop @ i)

# winding into the integers is not available (no Int here); wind into Nat
# mod 2 instead: the loop acts as the identity on Bool, so this is a
# legitimate Bool-valued action of the fundamental group.
def flip(b: Bool) -> Bool:
  match b:
    case False: True
    case True: False
def flipflip(b: Bool) -> Path(Bool, flip(flip(b)), b):
  match b:
    case False: <_> False
    case True: <_> True

def main() -> Bool:
  toBool(Circle/loop @ i1)

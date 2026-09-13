# isPropIsContr (the 4-face hcompN) EXECUTED: instantiated at Unit and
# observed through the composite's second component.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def isPropIsContr(A: Set, c0: isContr(A), c1: isContr(A)) -> Path(isContr(A), c0, c1):
  match c0:
    case (a0, p0):
      match c1:
        case (a1, p1):
          <i> ( p0(a1) @ i
              , lambda x. <j> hcompN(A,
                  [ (inot(i), <k> p0(p0(x) @ j) @ k)
                  , (i,       <k> p0(p1(x) @ j) @ k)
                  , (inot(j), <k> p0(p0(a1) @ i) @ k)
                  , (j,       <k> p0(x) @ k)
                  ], a0) )
def unitContr() -> isContr(Unit):
  ((), lambda x. <_> ())
# the filler at (i=i1, x=(), j=i0): a 4-face composition with two faces true
def run(i: Interval, j: Interval) -> Unit:
  match isPropIsContr(Unit, unitContr(), unitContr()) @ i:
    case (c, h):
      h(()) @ j
def main() -> Unit:
  run(i1, i0)

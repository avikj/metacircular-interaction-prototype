# hcomp in a Glue type (CCHM): type preservation and the two boundary laws.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)
# type preservation: the composite in a Glue type IS in that Glue type
def hcGlueTy(A: Set, T: Set, e: Equiv(T, A), p: Interval, i: Interval, u0: Glue(A, [(p, T, e)]), u1: Glue(A, [(p, T, e)]), h: Path(Glue(A, [(p, T, e)]), u0, u1)) -> Glue(A, [(p, T, e)]):
  hcompN(Glue(A, [(p, T, e)]), [(i, <k> h @ k)], u0)
# boundary: at a TRUE tube face the composite is that tube's cap
def hcGlueTop(A: Set, T: Set, e: Equiv(T, A), p: Interval, u0: Glue(A, [(p, T, e)]), u1: Glue(A, [(p, T, e)]), h: Path(Glue(A, [(p, T, e)]), u0, u1)) -> Path(Glue(A, [(p, T, e)]), hcompN(Glue(A, [(p, T, e)]), [(i1, <k> h @ k)], u0), h @ i1):
  <_> h @ i1
# boundary: with no live tube the composite is the base
def hcGlueBase(A: Set, T: Set, e: Equiv(T, A), p: Interval, u0: Glue(A, [(p, T, e)]), u1: Glue(A, [(p, T, e)]), h: Path(Glue(A, [(p, T, e)]), u0, u1)) -> Path(Glue(A, [(p, T, e)]), hcompN(Glue(A, [(p, T, e)]), [(i0, <k> h @ k)], u0), u0):
  <_> u0

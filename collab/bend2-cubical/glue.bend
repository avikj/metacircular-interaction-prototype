def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)
# boundary laws: Glue on a true face IS the partial type; unglue of glue is the base
def glue_at_i1(A: Set, T: Set, e: Equiv(T, A)) -> Set{Glue(A, [(i1, T, e)]) == T}:
  finally
def unglue_glue(A: Set, x: A) -> A{unglue(glue(A, x, [(i0, x)])) == x}:
  finally
# glue checked against its Glue type: section coherent with the base on the face
def glue_sec(A: Set, T: Set, e: Equiv(T, A), t: T, i: Interval) -> Glue(A, [(i, T, e)]):
  glue(A, (match e: case (f, _): f)(t), [(i, t)])
def main() -> Nat:
  0n

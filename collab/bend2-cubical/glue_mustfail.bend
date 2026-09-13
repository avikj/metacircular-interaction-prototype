def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)
# MUST FAIL: a Glue at a FALSE face does not collapse to its partial type
def evil(e: Equiv(Bool, Nat)) -> Set{Glue(Nat, [(i0, Bool, e)]) == Bool}:
  finally
# MUST FAIL: a mere function is not an equivalence
def notEquiv(e: Bool -> Nat) -> Set{Glue(Nat, [(i1, Bool, e)]) == Bool}:
  finally
# MUST FAIL: glue whose section is not coherent with the base
def incoherent(A: Set, T: Set, e: Equiv(T, A), t: T, x: A, i: Interval) -> Glue(A, [(i, T, e)]):
  glue(A, x, [(i, t)])
def main() -> Nat:
  0n

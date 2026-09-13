def glue_at_i1(A: Set, T: Set, e: T -> A) -> Set{Glue(A, [(i1, T, e)]) == T}:
  finally
def unglue_glue(A: Set, x: A) -> A{unglue(glue(A, x, [(i0, x)])) == x}:
  finally
def main() -> Nat:
  0n

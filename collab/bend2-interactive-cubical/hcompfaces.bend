# General cofibration faces: any interval formula, boundary checked on every
# DNF cell, tubes checked pairwise on the cells of their overlap.
#  1. a satisfied face reduces the composite to that tube's cap, definitionally
#  2. a compound face  ior(i, j)  (three cells) with a constant tube
#  (binary sugar hcomp(A,r,u0,u1,base) is covered by cubical_test4's pcompH)
def one() -> Nat:
  hcompN(Nat, [(i1, <_> 1n)], 1n)
def one_is_one() -> Nat{one() == 1n}:
  finally
def disj(A: Set, a: A, i: Interval, j: Interval) -> A:
  hcompN(A, [(ior(i, j), <_> a)], a)
def disj_top(A: Set, a: A) -> A{disj(A, a, i1, i0) == a}:
  finally
def main() -> Nat:
  0n

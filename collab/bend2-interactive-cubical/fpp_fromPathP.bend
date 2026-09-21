def fromPathP(F: Interval -> Set, u: F(i0), v: F(i1), p: PathP(F, u, v))
  -> Path(F(i1), coe(lambda i. F(i), i0, i1, u), v):
  <j> coe(lambda i. F(i), j, i1, p @ j)
def main() -> Nat:
  0n

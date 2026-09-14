type Circle:
  case @pt:
  path @lp: Path(Circle, @pt, @pt)

# WRONG: loop is not refl — the recursor's path branch must have type Path(B,b,b) with the SAME b
def wrongBranch(x: Circle) -> Nat:
  hrec(x) { @pt: 0n ; @lp: <i> 1n }

# WRONG: a missing branch
def missing(x: Circle) -> Nat:
  hrec(x) { @pt: 0n }

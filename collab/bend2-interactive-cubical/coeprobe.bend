# Does coe over a constant line with equal endpoints reduce to identity?
def p1() -> Path(Bool, coe(lambda k. Bool, i0, i0, True), True):
  <_> True
# and with a reducible constant family (B(iand(i0,k)) shape)?
def p2(B: Interval -> Set, x: B(i0)) -> Path(B(i0), coe(lambda k. B(iand(i0, k)), i0, i0, x), x):
  <_> x
def main() -> Nat:
  0n

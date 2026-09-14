# hcomp in a Pi pushes into the codomain: (hcomp{A->B}[i↦u]g) y == hcomp{B}[i↦ u y](g y)
def pushPi(y: Bool, i: Interval, g: Bool -> Bool) -> Bool:
  (hcompN(Bool -> Bool, [(i, <k> g)], g))(y)
def pushPi_eq(y: Bool, i: Interval, g: Bool -> Bool)
  -> Bool{ pushPi(y, i, g) == hcompN(Bool, [(i, <k> g(y))], g(y)) }:
  finally
# hcomp in a PathP pushes into the path, pinning endpoints as faces
def hc(a: Bool, b: Bool, i: Interval, u0: Path(Bool, a, b)) -> Path(Bool, a, b):
  hcompN(Path(Bool, a, b), [(i, <k> u0)], u0)
def pushPath(a: Bool, b: Bool, i: Interval, j: Interval, u0: Path(Bool, a, b)) -> Bool:
  hc(a, b, i, u0) @ j
def pushPath_eq(a: Bool, b: Bool, i: Interval, j: Interval, u0: Path(Bool, a, b))
  -> Bool{ pushPath(a,b,i,j,u0) == hcompN(Bool, [(i, <k> u0 @ j), (j, <k> b), (inot(j), <k> a)], u0 @ j) }:
  finally
def main() -> Nat:
  0n

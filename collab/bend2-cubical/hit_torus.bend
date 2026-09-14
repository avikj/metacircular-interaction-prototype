# The torus: one point, two loops and a SQUARE — a 2-dimensional path
# constructor whose type is an iterated PathP with the two loops on its four
# sides.  Its declared type is checked as a Set by the checker, which is where
# the corner compatibility of the boundary is discharged.
hit Torus:
  case @pt
  path @l1: Torus/pt ~> Torus/pt
  path @l2: Torus/pt ~> Torus/pt
  path @surf: PathP(lambda i. Path(Torus, Torus/l1 @ i, Torus/l1 @ i), Torus/l2, Torus/l2)

# the square's four faces, definitionally
def surf_i0(j: Interval) -> Path(Torus, Torus/surf @ i0 @ j, Torus/l2 @ j):
  <_> Torus/l2 @ j
def surf_i1(j: Interval) -> Path(Torus, Torus/surf @ i1 @ j, Torus/l2 @ j):
  <_> Torus/l2 @ j
def surf_j0(i: Interval) -> Path(Torus, Torus/surf @ i @ i0, Torus/l1 @ i):
  <_> Torus/l1 @ i
def surf_j1(i: Interval) -> Path(Torus, Torus/surf @ i @ i1, Torus/l1 @ i):
  <_> Torus/l1 @ i
# the identity, by the eliminator: the square branch is the square itself
def idT(t: Torus) -> Torus:
  Torus/elim(lambda _. Torus, t, Torus/pt, <i> Torus/l1 @ i, <i> Torus/l2 @ i, <i> <j> Torus/surf @ i @ j)
def idT_surf(i: Interval, j: Interval) -> Path(Torus, idT(Torus/surf @ i @ j), Torus/surf @ i @ j):
  <_> Torus/surf @ i @ j
# the torus maps onto the circle along the first loop: l1 to loop, l2 to refl,
# the square to the constant square on the loop
hit Circle:
  case @base
  path @loop: Circle/base ~> Circle/base
def toCircle(t: Torus) -> Circle:
  Torus/elim(lambda _. Circle, t, Circle/base, <i> Circle/loop @ i, <_> Circle/base, <i> <_> Circle/loop @ i)
def toCircle_surf(i: Interval, j: Interval) -> Path(Circle, toCircle(Torus/surf @ i @ j), Circle/loop @ i):
  <_> Circle/loop @ i
def toCircle_l2(j: Interval) -> Path(Circle, toCircle(Torus/l2 @ j), Circle/base):
  <_> Circle/base
# the square's diagonal is a loop
def diag() -> Path(Torus, Torus/pt, Torus/pt):
  <i> Torus/surf @ i @ i
def main() -> Circle:
  toCircle(Torus/surf @ i1 @ i1)

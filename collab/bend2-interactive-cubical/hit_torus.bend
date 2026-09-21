# The torus: a point, two loops, and a SQUARE (2-path constructor) between their composites.
type Torus:
  case @pt:
  path @p: Path(Torus, @pt, @pt)
  path @q: Path(Torus, @pt, @pt)
  path @surf: PathP(lambda i. Path(Torus, @p @ i, @p @ i), @q, @q)

# the square's boundary is definitional at every literal corner
def surf00() -> Path(Torus, (@surf @ i0) @ i0, @pt):
  <_> @pt

def surf_i0() -> Path(Path(Torus, @pt, @pt), @surf @ i0, @q):
  <_> @q

def torusRec(B: Set, b: B, pb: Path(B, b, b), qb: Path(B, b, b), sq: PathP(lambda i. Path(B, pb @ i, pb @ i), qb, qb), x: Torus) -> B:
  hrec(x) { @pt: b ; @p: pb ; @q: qb ; @surf: sq }

def torusRec_surf(B: Set, b: B, pb: Path(B, b, b), qb: Path(B, b, b), sq: PathP(lambda i. Path(B, pb @ i, pb @ i), qb, qb)) -> Path(PathP(lambda i. Path(B, pb @ i, pb @ i), qb, qb), <i> <j> torusRec(B, b, pb, qb, sq, (@surf @ i) @ j), sq):
  <_> sq

def main() -> Nat:
  0n

# The Klein bottle: a point, two loops, and a square whose one side is REVERSED.
type Klein:
  case @pt:
  path @a: Path(Klein, @pt, @pt)
  path @b: Path(Klein, @pt, @pt)
  path @surf: PathP(lambda i. Path(Klein, @a @ i, @a @ inot(i)), @b, @b)

def surf_i0() -> Path(Path(Klein, @pt, @pt), @surf @ i0, @b):
  <_> @b

def surf_corner() -> Path(Klein, (@surf @ i1) @ i1, @pt):
  <_> @pt

def kleinRec(B: Set, b: B, pa: Path(B, b, b), pb: Path(B, b, b), sq: PathP(lambda i. Path(B, pa @ i, pa @ inot(i)), pb, pb), x: Klein) -> B:
  hrec(x) { @pt: b ; @a: pa ; @b: pb ; @surf: sq }

def kleinRec_surf(B: Set, b: B, pa: Path(B, b, b), pb: Path(B, b, b), sq: PathP(lambda i. Path(B, pa @ i, pa @ inot(i)), pb, pb), i: Interval, j: Interval) -> Path(B, kleinRec(B, b, pa, pb, sq, (@surf @ i) @ j), (sq @ i) @ j):
  <_> (sq @ i) @ j

def main() -> Nat:
  0n

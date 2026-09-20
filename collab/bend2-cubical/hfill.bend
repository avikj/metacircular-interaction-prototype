# hfill(A, [(face, tube)...], base) : Path(A, base, hcompN(A, [(face, tube)...], base))
def hf(A: Set, x: A, y: A, p: Path(A, x, y), i: Interval) -> Path(A, x, hcompN(A, [(i, <k> p @ k), (inot(i), <k> x)], x)):
  hfill(A, [(i, <k> p @ k), (inot(i), <k> x)], x)

# the filler at a satisfied face is the tube itself: at i=i1 the composite
# is p @ i1 = y and the filler is p
def hf_face(A: Set, x: A, y: A, p: Path(A, x, y)) -> Path(Path(A, x, y), hfill(A, [(i1, <k> p @ k)], x), p):
  <_> p

# the library's fill0 (Cubical.Foundations.Isomorphism) through hfill, as a
# path from its cap to its composite
def fill0(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), i: Interval) -> Path(A, g(p0 @ inot(i)), hcompN(A, [(i, <k> t(x0) @ k), (inot(i), <k> g(y))], g(p0 @ inot(i)))):
  hfill(A, [(i, <k> t(x0) @ k), (inot(i), <k> g(y))], g(p0 @ inot(i)))

# MUST FAIL: a filler whose tube does not start at the base
def wrong(A: Set, x: A, y: A, p: Path(A, x, y), i: Interval) -> Path(A, y, hcompN(A, [(i, <k> p @ k)], y)):
  hfill(A, [(i, <k> p @ k)], y)

def main() -> Nat:
  0n

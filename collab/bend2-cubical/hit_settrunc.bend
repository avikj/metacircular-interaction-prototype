# Set truncation: a 2-dimensional path constructor with RECURSIVE fields —
# for any two parallel paths p, q in the truncation, a square between them.
# This is the HIT the old schema could not state (a square, and faces that
# are the fields p and q themselves).
hit STr<A: Set>:
  case @in(a: A)
  path @sq(x: STr(A), y: STr(A), p: Path(STr(A), x, y), q: Path(STr(A), x, y)): PathP(lambda i. Path(STr(A), x, y), p, q)

def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A, x, y). all q: Path(A, x, y). Path(Path(A, x, y), p, q)
# ||A||_0 IS a set — that is the point of the HIT
def strIsSet(A: Set) -> isSet(STr(A)):
  lambda x. lambda y. lambda p. lambda q. <i> <j> STr/sq(A, x, y, p, q) @ i @ j
# the recursor into a set (by recursion, Agda-style): the square goes to the
# target's own set-ness, applied to the images of p and q
def rec(A: Set, B: Set, sB: isSet(B), f: A -> B, x: STr(A)) -> B:
  STr/elim(A, lambda _. B, x, f,
    lambda x. lambda y. lambda p. lambda q.
      <i> <j> sB(rec(A, B, sB, f, x), rec(A, B, sB, f, y), <k> rec(A, B, sB, f, p @ k), <k> rec(A, B, sB, f, q @ k)) @ i @ j)
def rec_in(A: Set, B: Set, sB: isSet(B), f: A -> B, a: A) -> Path(B, rec(A, B, sB, f, STr/in(A, a)), f(a)):
  <_> f(a)
# on the square, at every (i, j), the branch runs on the recursive images
def rec_sq(A: Set, B: Set, sB: isSet(B), f: A -> B, x: STr(A), y: STr(A), p: Path(STr(A), x, y), q: Path(STr(A), x, y), i: Interval, j: Interval) -> Path(B, rec(A, B, sB, f, STr/sq(A, x, y, p, q) @ i @ j), sB(rec(A, B, sB, f, x), rec(A, B, sB, f, y), <k> rec(A, B, sB, f, p @ k), <k> rec(A, B, sB, f, q @ k)) @ i @ j):
  <_> sB(rec(A, B, sB, f, x), rec(A, B, sB, f, y), <k> rec(A, B, sB, f, p @ k), <k> rec(A, B, sB, f, q @ k)) @ i @ j
# the square's faces are the two paths, definitionally
def sq_i0(A: Set, x: STr(A), y: STr(A), p: Path(STr(A), x, y), q: Path(STr(A), x, y), j: Interval) -> Path(STr(A), STr/sq(A, x, y, p, q) @ i0 @ j, p @ j):
  <_> p @ j
def sq_j1(A: Set, x: STr(A), y: STr(A), p: Path(STr(A), x, y), q: Path(STr(A), x, y), i: Interval) -> Path(STr(A), STr/sq(A, x, y, p, q) @ i @ i1, y):
  <_> y
# the identity on the truncation by elimination: the square branch is the
# square on the recursive images of x, y, p, q — a 2-cell whose faces are
# themselves recursive calls on path fields
def idS(A: Set, x: STr(A)) -> STr(A):
  STr/elim(A, lambda _. STr(A), x, lambda a. STr/in(A, a),
    lambda x. lambda y. lambda p. lambda q.
      <i> <j> STr/sq(A, idS(A, x), idS(A, y), <k> idS(A, p @ k), <k> idS(A, q @ k)) @ i @ j)
def idS_in(A: Set, a: A) -> Path(STr(A), idS(A, STr/in(A, a)), STr/in(A, a)):
  <_> STr/in(A, a)
def idS_sq(A: Set, x: STr(A), y: STr(A), p: Path(STr(A), x, y), q: Path(STr(A), x, y), i: Interval, j: Interval) -> Path(STr(A), idS(A, STr/sq(A, x, y, p, q) @ i @ j), STr/sq(A, idS(A, x), idS(A, y), <k> idS(A, p @ k), <k> idS(A, q @ k)) @ i @ j):
  <_> STr/sq(A, idS(A, x), idS(A, y), <k> idS(A, p @ k), <k> idS(A, q @ k)) @ i @ j
def main() -> STr(Bool):
  idS(Bool, STr/in(Bool, True))

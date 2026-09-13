def pcompH(A: Set, a: A, b: A, c: A, p: Path(A, a, b), q: Path(A, b, c)) -> Path(A, a, c):
  <i> hcomp(A, i, <j> a, <j> q @ j, p @ i)
# right unit: p · refl == p  (both walls constant → should hold DEFINITIONALLY)
def runit(A: Set, a: A, b: A, p: Path(A, a, b)) -> Path(Path(A, a, b), pcompH(A, a, b, b, p, <j> b), p):
  <_> p
# refl · refl == refl definitionally
def rr(A: Set, a: A) -> Path(Path(A, a, a), pcompH(A, a, a, a, <j> a, <j> a), <j> a):
  <_> <j> a
def main() -> Nat:
  0n

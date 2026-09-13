def pcompH(A: Set, a: A, b: A, c: A, p: Path(A, a, b), q: Path(A, b, c)) -> Path(A, a, c):
  <i> hcomp(A, i, <j> a, <j> q @ j, p @ i)
# right unit in a FUNCTION type: (p · refl) = p for function-paths, definitional
def runitFn(f: Bool -> Bool, g: Bool -> Bool, p: Path(Bool -> Bool, f, g))
  -> Path(Path(Bool -> Bool, f, g), pcompH(Bool -> Bool, f, g, g, p, <j> g), p):
  <_> p
def main() -> Nat:
  0n

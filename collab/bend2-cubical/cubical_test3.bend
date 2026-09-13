# Layer 3: derived path algebra, and the ISC coalgebra via Fix.

def subst3(A: Set, C: A -> Set, a: A, b: A, p: Path(A, a, b), d: C(a)) -> C(b):
  coe(lambda i. C(p @ i), i0, i1, d)

# path composition, derived from transport (no hcomp needed)
def pcomp(A: Set, a: A, b: A, c: A, p: Path(A, a, b), q: Path(A, b, c)) -> Path(A, a, c):
  subst3(A, lambda x. Path(A, a, x), b, c, q, p)

# groupoid laws come out by J; e.g. right unit
def prunit(A: Set, a: A, b: A, p: Path(A, a, b)) -> Path(Path(A, a, b), pcomp(A, a, b, b, p, <_> b), p):
  <i> p

# ---- the interactive coalgebra (Fibre.Samvada ISC), one-field form ----
# ISC Q O E w  =  (q : Q w) -> Σ w'. Σ o : O w q w'. E w q w' o × ISC w'
# Coinduction via Fix: productivity is not checked (Bend2 has no totality),
# exactly as Bend2 checks any recursive definition.

def Point3() -> Set:
  any A: Set. A

def Src3(s: Point3()) -> Set:
  match s:
    case (A, a):
      A

def src3(s: Point3()) -> Src3(s):
  match s:
    case (A, a):
      a

def Question3(s: Point3()) -> Set:
  any B: Set. (Src3(s) -> B)

def target3(s: Point3(), q: Question3(s)) -> Point3():
  match q:
    case (B, f):
      (B, f(src3(s)))

# Corpus process: at every state, every question gets target + exact
# residual receipt (a Path) + continuation. Nu-type via Fix.
def Corpus3(s: Point3()) -> Set:
  all q: Question3(s).
  any s2: Point3().
  any e: Path(Point3(), target3(s, q), s2).
  Corpus3(s2)

def run3(s: Point3()) -> Corpus3(s):
  lambda q. (target3(s, q), <_> target3(s, q), run3(target3(s, q)))

# finite observation: two demanded steps compute by refl
def obs2(A: Set, B: Set, C: Set, a: A, f: A -> B, g: B -> C) -> Path(Point3(), target3(target3((A, a), (B, f)), (C, g)), (C, g(f(a)))):
  <i> (C, g(f(a)))

def main() -> Nat:
  0n

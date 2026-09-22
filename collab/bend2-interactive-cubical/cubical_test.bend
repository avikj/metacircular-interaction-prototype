# Cubical primitives in Bend2: Path types, interval, connections.
# Acceptance: funext (unprovable with Eql) and the corpus's lossless
# rightInv, transliterated from cubical Agda term for term.

# refl as a path
def prefl(A: Set, a: A) -> Path(A, a, a):
  <i> a

# symmetry, via interval negation: (sym p) i = p (~ i)
def psym(A: Set, a: A, b: A, p: Path(A, a, b)) -> Path(A, b, a):
  <i> p @ inot(i)

# congruence: cong f p = λ i. f (p i)
def pcong(A: Set, B: Set, f: A -> B, a: A, b: A, p: Path(A, a, b)) -> Path(B, f(a), f(b)):
  <i> f(p @ i)

# function extensionality — the theorem Eql cannot prove
def funext(A: Set, B: Set, f: A -> B, g: A -> B, h: all x:A. Path(B, f(x), g(x))) -> Path(A -> B, f, g):
  <i> lambda x. h(x) @ i

# connection square: λ i. p (i ∧ j) degenerates correctly
def conn_left(A: Set, a: A, b: A, p: Path(A, a, b)) -> Path(A, a, b):
  <i> p @ iand(i, i1)

# ---- the corpus lemma, cubical version ----
# Pres A B f = Σ b:B. Σ a:A. Path(B, f a, b)
def PresP(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. any a: A. Path(B, f(a), b)

def encodeP(A: Set, B: Set, f: A -> B, a: A) -> PresP(A, B, f):
  (f(a), a, <i> f(a))

def decodeP(A: Set, B: Set, f: A -> B, p: PresP(A, B, f)) -> A:
  match p:
    case (b, a, e):
      a

# Agda:  Iso.rightInv losslessIso (b , a , p) i = p i , a , λ j → p (i ∧ j)
def rightInv(A: Set, B: Set, f: A -> B, p: PresP(A, B, f)) -> Path(PresP(A, B, f), encodeP(A, B, f, decodeP(A, B, f, p)), p):
  match p:
    case (b, a, e):
      <i> (e @ i, a, <j> e @ iand(i, j))

# Agda:  Iso.leftInv losslessIso a = refl
def leftInv(A: Set, B: Set, f: A -> B, a: A) -> Path(A, decodeP(A, B, f, encodeP(A, B, f, a)), a):
  <i> a

def main() -> Nat:
  0n

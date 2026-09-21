# INDEXED families in the corpus's shape (RankedPath : State -> State -> Type,
# Gen S a), on the schema through index-equation fields: a constructor whose
# target index is e carries a field Path(Ix, idx, e).  Here: reachability in a
# state space with path-typed step fields, and a Gen with an INTERVAL-argument
# constructor whose target index moves along a universe path (the corpus's
# genB : (i : I) -> ... -> Gen S (bin i a b)).
def Not(b: Bool) -> Bool:
  if b:
    False
  else:
    True
def notInv(b: Bool) -> Path(Bool, Not(Not(b)), b):
  if b:
    <_> True
  else:
    <_> False
def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, lambda x. Not(x), lambda x. Not(x), lambda x. notInv(x), lambda x. notInv(x))

type Reach(S: Set, step: S -> S -> Set, s: S, t: S):
  case @refl:
    e: Path(S, s, t)
  case @cons:
    m: S
    st: step(s, m)
    r: Reach(S, step, m, t)

def Step(a: Bool, b: Bool) -> Set:
  Path(Bool, Not(a), b)
def flipTwice() -> Reach(Bool, Step, True, True):
  @cons{False, <_> False, @cons{True, <_> True, @refl{<_> True}}}
def len(s: Bool, t: Bool, r: Reach(Bool, Step, s, t)) -> Nat:
  match r:
    case @refl{e}: 0n
    case @cons{m, st, r2}: 1n+len(m, t, r2)
def len_flipTwice() -> Path(Nat, len(True, True, flipTwice()), 2n):
  <_> 2n

type Gen(A: Set):
  case @gleaf:
    x: A
  case @genB:
    i: Interval
    l: Gen(Bool)
    r: Gen(Bool)
    e: Path(Set, notPath() @ i, A)
  path @gsym(x: A): Path(Gen(A), @gleaf{x}, @gleaf{x})
# at i0 the moving index is Bool, so the cell lives in Gen(Bool) by refl
def genB_index(x: Bool, y: Bool) -> Gen(Bool):
  @genB{i0, @gleaf{x}, @gleaf{y}, <_> Bool}
def count(A: Set, g: Gen(A)) -> Nat:
  hrec(g) { @gleaf: lambda x. 1n ; @genB: lambda i. lambda l. lambda r. lambda e. 1n+count(Bool, l) ; @gsym: lambda x. <_> 1n }
def count_sym(x: Bool, i: Interval) -> Path(Nat, count(Bool, @gsym{x} @ i), 1n):
  <_> 1n
def count_genB(x: Bool, y: Bool) -> Path(Nat, count(Bool, genB_index(x, y)), 2n):
  <_> 2n
def main() -> Nat:
  len(True, True, flipTwice())

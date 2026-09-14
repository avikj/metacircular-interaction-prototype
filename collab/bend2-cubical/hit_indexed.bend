# INDEXED families, the shape of the corpus's Agda (`RankedPath : State ->
# State -> Type`, `Gen S a`, `Thread i j`): a hit with parameters AND indices,
# constructors declaring their own targets, path-typed fields, and even a
# constructor with an INTERVAL field whose target index depends on it (the
# corpus's `genB : (i : I) → ... → Gen S (bin i a b)`).
def Not(b: Bool) -> Bool:
  match b:
    case False: True
    case True: False
def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, Not, Not, lambda b. match b: case False: <_> False case True: <_> True, lambda b. match b: case False: <_> False case True: <_> True)
# reachability in a state space: paths of steps between states
hit Reach<S: Set, step: S -> S -> Set>(s: S, t: S):
  case @refl(s: S) -> Reach(S, step, s, s)
  case @cons(s: S, m: S, t: S, e: step(s, m), r: Reach(S, step, m, t)) -> Reach(S, step, s, t)

def Step(a: Bool, b: Bool) -> Set:
  Path(Bool, Not(a), b)
def flipTwice() -> Reach(Bool, Step, True, True):
  Reach/cons(Bool, Step, True, False, True, <_> False, Reach/cons(Bool, Step, False, True, True, <_> True, Reach/refl(Bool, Step, True)))
# length by the eliminator: the motive is indexed
def len(s: Bool, t: Bool, r: Reach(Bool, Step, s, t)) -> Nat:
  Reach/elim(Bool, Step, lambda s. lambda t. lambda _. Nat, s, t, r, lambda s. 0n, lambda s. lambda m. lambda t. lambda e. lambda r. 1n+len(m, t, r))
def len_flipTwice() -> Path(Nat, len(True, True, flipTwice()), 2n):
  <_> 2n
# the DEPENDENT eliminator over an indexed family: every reach from s to t
# yields a path of booleans (Step is a path, so this is the induction that
# composes them — here into Bool's own equality via the motive)
def endpoints(s: Bool, t: Bool, r: Reach(Bool, Step, s, t)) -> Reach(Bool, Step, s, t):
  Reach/elim(Bool, Step, lambda s. lambda t. lambda _. Reach(Bool, Step, s, t), s, t, r, lambda s. Reach/refl(Bool, Step, s), lambda s. lambda m. lambda t. lambda e. lambda r. Reach/cons(Bool, Step, s, m, t, e, endpoints(m, t, r)))
def endpoints_id() -> Path(Reach(Bool, Step, True, True), endpoints(True, True, flipTwice()), flipTwice()):
  <_> flipTwice()

# an indexed HIT with an INTERVAL-argument constructor whose target index
# moves along a path in the universe (the corpus's `genB : (i : I) -> ... ->
# Gen S (bin i a b)`): Gen(A) is indexed by the Set A, and genB(i, l, r)
# lives over notPath() @ i, which is Bool at both ends.
hit Gen(A: Set):
  case @leaf(A: Set, x: A) -> Gen(A)
  case @genB(i: Interval, l: Gen(Bool), r: Gen(Bool)) -> Gen(notPath() @ i)
  path @sym(A: Set, x: A): Path(Gen(A), Gen/leaf(A, x), Gen/leaf(A, x))
# at i0 the index is Bool, definitionally, so the cell lives in Gen(Bool)
def genB_index(x: Bool, y: Bool) -> Gen(Bool):
  Gen/genB(i0, Gen/leaf(Bool, x), Gen/leaf(Bool, y))
# a cell at a symbolic i lives over the moving index
def genB_moving(x: Bool, y: Bool, i: Interval) -> Gen(notPath() @ i):
  Gen/genB(i, Gen/leaf(Bool, x), Gen/leaf(Bool, y))
def count(A: Set, g: Gen(A)) -> Nat:
  Gen/elim(lambda A. lambda _. Nat, A, g, lambda A. lambda x. 1n, lambda i. lambda l. lambda r. 1n+count(Bool, l), lambda A. lambda x. <_> 1n)
def count_sym(x: Bool, i: Interval) -> Path(Nat, count(Bool, Gen/sym(Bool, x) @ i), 1n):
  <_> 1n
def count_genB(x: Bool, y: Bool, i: Interval) -> Path(Nat, count(notPath() @ i, Gen/genB(i, Gen/leaf(Bool, x), Gen/leaf(Bool, y))), 2n):
  <_> 2n
def main() -> Nat:
  len(True, True, flipTwice())

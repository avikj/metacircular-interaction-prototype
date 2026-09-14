# Propositional truncation DECLARED with the schema.  The path constructor's
# fields are elements of the truncation itself; as in Agda, recursion is by a
# named definition — the eliminator computes on every constructor, so the
# expected face of the squash branch, Tr/elim(...) on x, IS rec(x) after
# unfolding, and the branch may mention rec freely.
hit Tr<A: Set>:
  case @in(a: A)
  path @sq(x: Tr(A), y: Tr(A)): x ~> y

def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def trIsProp(A: Set) -> isProp(Tr(A)):
  lambda x. lambda y. <i> Tr/sq(A, x, y) @ i
# the recursor into a proposition, by recursion (Agda's pattern matching)
def rec(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Tr(A)) -> B:
  Tr/elim(A, lambda _. B, x, f, lambda u. lambda v. <i> pB(rec(A, B, pB, f, u), rec(A, B, pB, f, v)) @ i)
def rec_in(A: Set, B: Set, pB: isProp(B), f: A -> B, a: A) -> Path(B, rec(A, B, pB, f, Tr/in(A, a)), f(a)):
  <_> f(a)
def rec_sq(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Tr(A), y: Tr(A), i: Interval) -> Path(B, rec(A, B, pB, f, Tr/sq(A, x, y) @ i), pB(rec(A, B, pB, f, x), rec(A, B, pB, f, y)) @ i):
  <_> pB(rec(A, B, pB, f, x), rec(A, B, pB, f, y)) @ i
def unitIsProp() -> isProp(Unit):
  lambda x. lambda y. match x: case (): match y: case (): <_> ()
def toUnit(t: Tr(Bool)) -> Unit:
  rec(Bool, Unit, unitIsProp(), lambda b. (), t)
# a DEPENDENT elimination: the motive is a family of propositions, and the
# squash branch is a PathP over it between the recursive calls
def isPropFam(x: Tr(Bool)) -> Set:
  Unit
def depToUnit(t: Tr(Bool)) -> isPropFam(t):
  Tr/elim(Bool, isPropFam, t, lambda b. (), lambda u. lambda v. <i> unitIsProp()(depToUnit(u), depToUnit(v)) @ i)
# the eliminator computes on an hcomp cell of the truncation (the rule that
# makes functions out of a HIT compute on composites): with a constant
# motive it is the hcomp of the images, definitionally
def rec_hcomp(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Tr(A), y: Tr(A), i: Interval) -> Path(B, rec(A, B, pB, f, hcompN(Tr(A), [(i, <k> Tr/sq(A, x, y) @ k)], x)), hcompN(B, [(i, <k> rec(A, B, pB, f, Tr/sq(A, x, y) @ k))], rec(A, B, pB, f, x))):
  <_> hcompN(B, [(i, <k> rec(A, B, pB, f, Tr/sq(A, x, y) @ k))], rec(A, B, pB, f, x))
def main() -> Unit:
  toUnit(Tr/sq(Bool, Tr/in(Bool, True), Tr/in(Bool, False)) @ i1)

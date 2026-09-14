# Propositional truncation DECLARED with the schema: the path constructor's
# fields are RECURSIVE (they are elements of the truncation itself), so the
# eliminator hands the branch an induction hypothesis for each, and the path
# branch is a PathP between those hypotheses.
hit Tr<A: Set>:
  case @in(a: A)
  path @sq(x: Tr(A), y: Tr(A)): x ~> y

def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def trIsProp(A: Set) -> isProp(Tr(A)):
  lambda x. lambda y. <i> Tr/sq(A, x, y) @ i
# the recursor into a proposition: the squash goes to the target's propness,
# applied to the induction hypotheses
def rec(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Tr(A)) -> B:
  Tr/elim(A, lambda _. B, x, f, lambda u. lambda v. lambda ihu. lambda ihv. <i> pB(ihu, ihv) @ i)
def rec_in(A: Set, B: Set, pB: isProp(B), f: A -> B, a: A) -> Path(B, rec(A, B, pB, f, Tr/in(A, a)), f(a)):
  <_> f(a)
# on the path constructor the induction hypotheses ARE the recursive calls
def rec_sq(A: Set, B: Set, pB: isProp(B), f: A -> B, x: Tr(A), y: Tr(A), i: Interval) -> Path(B, rec(A, B, pB, f, Tr/sq(A, x, y) @ i), pB(rec(A, B, pB, f, x), rec(A, B, pB, f, y)) @ i):
  <_> pB(rec(A, B, pB, f, x), rec(A, B, pB, f, y)) @ i
def unitIsProp() -> isProp(Unit):
  lambda x. lambda y. match x: case (): match y: case (): <_> ()
def toUnit(t: Tr(Bool)) -> Unit:
  rec(Bool, Unit, unitIsProp(), lambda b. (), t)
# a DEPENDENT elimination over the truncation: the motive is a family of
# propositions, so the path branch must land in a PathP over Tr/sq
def isPropFam(x: Tr(Bool)) -> Set:
  Unit
def depToUnit(t: Tr(Bool)) -> isPropFam(t):
  Tr/elim(Bool, isPropFam, t, lambda b. (), lambda u. lambda v. lambda ihu. lambda ihv. <i> unitIsProp()(ihu, ihv) @ i)
def main() -> Unit:
  toUnit(Tr/sq(Bool, Tr/in(Bool, True), Tr/in(Bool, False)) @ i1)

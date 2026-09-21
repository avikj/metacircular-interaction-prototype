# Propositional truncation as a declared HIT with a RECURSIVE path constructor.
type PTrunc(A: Set):
  case @tin:
    a: A
  path @squash(x: PTrunc(A), y: PTrunc(A)): Path(PTrunc(A), x, y)

def isProp(P: Set) -> Set:
  all u: P. all v: P. Path(P, u, v)

def truncIsProp(A: Set) -> isProp(PTrunc(A)):
  lambda u. lambda v. @squash{u, v}

# recursion into a proposition: the squash branch is forced by propness
def ptrec(A: Set, P: Set, pP: isProp(P), f: A -> P, x: PTrunc(A)) -> P:
  hrec(x) { @tin: f ; @squash: lambda u. lambda v. pP(ptrec(A, P, pP, f, u), ptrec(A, P, pP, f, v)) }

def trec_beta(A: Set, P: Set, pP: isProp(P), f: A -> P, a: A) -> Path(P, ptrec(A, P, pP, f, @tin{a}), f(a)):
  <_> f(a)

# a proposition to recurse into: paths in a set are propositions; use the
# truncation's own propness (any P with pP) â” here P := PTrunc(Nat) itself
def main() -> PTrunc(Nat):
  ptrec(Nat, PTrunc(Nat), truncIsProp(Nat), lambda n. @tin{n}, @tin{3n})

# The future-behaviour congruence and its quotient, as the port's
# MyhillNerodeMinimalMachine.bend states them (§0–§3 there), in a module
# light enough to import: run, behavior, Nerode (a prop-valued equivalence
# relation), Meaning = X / Nerode, and effectivity [x] == [y] => Nerode x y
# (from Effective.bend).  The minimal-machine theorems (quotStep,
# full abstraction, terminality) stay in MyhillNerodeMinimalMachine.bend.
import Effective

def run(X: Set, A: Set, step: X -> A -> X, x: X, w: A[]) -> X:
  match w:
    case []: x
    case a <> rest: run(X, A, step, step(x, a), rest)
def behavior(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, w: A[]) -> O:
  observe(run(X, A, step, x, w))
def Nerode(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X) -> Set:
  all w: A[]. Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w))
def nerodeRefl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X) -> Nerode(X, A, O, step, observe, x, x):
  lambda w. <_> behavior(X, A, O, step, observe, x, w)
def nerodeSym(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, h: Nerode(X, A, O, step, observe, x, y)) -> Nerode(X, A, O, step, observe, y, x):
  lambda w. <i> h(w) @ inot(i)
def nerodeTrans(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, z: X, hxy: Nerode(X, A, O, step, observe, x, y), hyz: Nerode(X, A, O, step, observe, y, z)) -> Nerode(X, A, O, step, observe, x, z):
  lambda w. compPath(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w), behavior(X, A, O, step, observe, z, w), hxy(w), hyz(w))
def NerodeR(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> X -> X -> Set:
  lambda x. lambda y. Nerode(X, A, O, step, observe, x, y)
def isPropNerode(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X, y: X) -> isProp(Nerode(X, A, O, step, observe, x, y)):
  isPropPi(A[], lambda w. Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w)), lambda w. setO(behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w)))
def Meaning(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> Set:
  Quotient(X, NerodeR(X, A, O, step, observe))
def isSetMeaning(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> isSet(Meaning(X, A, O, step, observe)):
  squash(X, NerodeR(X, A, O, step, observe))
# effectivity: a path of meanings yields future equality
def nerodeEffective(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X, y: X, p: Path(Meaning(X, A, O, step, observe), @cl{x}, @cl{y})) -> Nerode(X, A, O, step, observe, x, y):
  effective(X, NerodeR(X, A, O, step, observe),
    lambda x2. lambda y2. isPropNerode(X, A, O, step, setO, observe, x2, y2),
    lambda x2. nerodeRefl(X, A, O, step, observe, x2),
    lambda x2. lambda y2. lambda h. nerodeSym(X, A, O, step, observe, x2, y2, h),
    lambda x2. lambda y2. lambda z2. lambda h1. lambda h2. nerodeTrans(X, A, O, step, observe, x2, y2, z2, h1, h2),
    isSetHProp(), x, y, p)

def main() -> Nat:
  0n

# formal/cubical/theorems/automata/MyhillNerodeMinimalMachine.agda, in Bend:
# the future-behaviour quotient is the minimal fully abstract machine, its
# path space IS the Nerode congruence (effectivity), and it is terminal.
import SetQuotient
import Effective

# ---- 0/1. observed transition systems, words, behaviours
def run(X: Set, A: Set, step: X -> A -> X, x: X, w: A[]) -> X:
  match w:
    case []: x
    case a <> rest: run(X, A, step, step(x, a), rest)
def behavior(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, w: A[]) -> O:
  observe(run(X, A, step, x, w))
def Nerode(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X) -> Set:
  all w: A[]. Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w))

# ---- 2. an equivalence relation and a step congruence
def nerodeRefl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X) -> Nerode(X, A, O, step, observe, x, x):
  lambda w. <_> behavior(X, A, O, step, observe, x, w)
def nerodeSym(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, h: Nerode(X, A, O, step, observe, x, y)) -> Nerode(X, A, O, step, observe, y, x):
  lambda w. <i> h(w) @ inot(i)
def nerodeTrans(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, z: X, hxy: Nerode(X, A, O, step, observe, x, y), hyz: Nerode(X, A, O, step, observe, y, z)) -> Nerode(X, A, O, step, observe, x, z):
  lambda w. compPath(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w), behavior(X, A, O, step, observe, z, w), hxy(w), hyz(w))
# the future (a âˆ w) of the parents is the future w of the children, definitionally
def nerodeStep(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, h: Nerode(X, A, O, step, observe, x, y), a: A) -> Nerode(X, A, O, step, observe, step(x, a), step(y, a)):
  lambda w. h(a <> w)
def nerodeToBehavior(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, h: Nerode(X, A, O, step, observe, x, y)) -> Path(A[] -> O, lambda w. behavior(X, A, O, step, observe, x, w), lambda w. behavior(X, A, O, step, observe, y, w)):
  <i> lambda w. h(w) @ i
def behaviorToNerode(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X, p: Path(A[] -> O, lambda w. behavior(X, A, O, step, observe, x, w), lambda w. behavior(X, A, O, step, observe, y, w))) -> Nerode(X, A, O, step, observe, x, y):
  lambda w. <i> (p @ i)(w)
# refinement: a finer observation's congruence is contained in a coarser one's
def nerodeOfFiner(X: Set, A: Set, O: Set, F: Set, step: X -> A -> X, coarse: X -> O, fine: X -> F, forget: F -> O, hf: all x: X. Path(O, forget(fine(x)), coarse(x)), x: X, y: X, h: Nerode(X, A, F, step, fine, x, y)) -> Nerode(X, A, O, step, coarse, x, y):
  lambda w. compPath3(O, coarse(run(X, A, step, x, w)), forget(fine(run(X, A, step, x, w))), forget(fine(run(X, A, step, y, w))), coarse(run(X, A, step, y, w)),
    <i> hf(run(X, A, step, x, w)) @ inot(i), <i> forget(h(w) @ i), hf(run(X, A, step, y, w)))

# ---- behavioural congruences; Nerode is one, and the GREATEST one
type isBehavioralCongruence(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set):
  case @congruence:
    respects_observe: all x: X. all y: X. S(x, y) -> Path(O, observe(x), observe(y))
    respects_step: all x: X. all y: X. all a: A. S(x, y) -> S(step(x, a), step(y, a))
def nerodeIsCongruence(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> isBehavioralCongruence(X, A, O, step, observe, lambda x. lambda y. Nerode(X, A, O, step, observe, x, y)):
  @congruence{lambda x. lambda y. lambda h. h([]), lambda x. lambda y. lambda a. lambda h. nerodeStep(X, A, O, step, observe, x, y, h, a)}
def congruenceToNerode(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), x: X, y: X, s: S(x, y), w: A[]) -> Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w)):
  match isC:
    case @congruence{ro, rs}:
      match w:
        case []: ro(x, y, s)
        case a <> rest: congruenceToNerode(X, A, O, step, observe, S, @congruence{ro, rs}, step(x, a), step(y, a), rs(x, y, a, s), rest)

# ---- 3. the minimal machine: Meaning = X / Nerode
def NerodeR(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> X -> X -> Set:
  lambda x. lambda y. Nerode(X, A, O, step, observe, x, y)
def isPropNerode(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X, y: X) -> isProp(Nerode(X, A, O, step, observe, x, y)):
  isPropPi(A[], lambda w. Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w)), lambda w. setO(behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w)))
def Meaning(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> Set:
  Quotient(X, NerodeR(X, A, O, step, observe))
def isSetMeaning(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> isSet(Meaning(X, A, O, step, observe)):
  squash(X, NerodeR(X, A, O, step, observe))

def quotStep(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, m: Meaning(X, A, O, step, observe), a: A) -> Meaning(X, A, O, step, observe):
  quotRec(X, NerodeR(X, A, O, step, observe), Meaning(X, A, O, step, observe), squash(X, NerodeR(X, A, O, step, observe)),
    lambda x. @cl{step(x, a)},
    lambda x. lambda y. lambda h. @eq{step(x, a), step(y, a), nerodeStep(X, A, O, step, observe, x, y, h, a)}, m)
def quotStep_cl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, a: A) -> Path(Meaning(X, A, O, step, observe), quotStep(X, A, O, step, observe, @cl{x}, a), @cl{step(x, a)}):
  <_> @cl{step(x, a)}
def quotObserve(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, m: Meaning(X, A, O, step, observe)) -> O:
  quotRec(X, NerodeR(X, A, O, step, observe), O, setO, observe, lambda x. lambda y. lambda h. h([]), m)
def quotObserve_cl(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X) -> Path(O, quotObserve(X, A, O, step, setO, observe, @cl{x}), observe(x)):
  <_> observe(x)
# execution commutes with quotienting
def quotRun_cl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, w: A[]) -> Path(Meaning(X, A, O, step, observe), run(Meaning(X, A, O, step, observe), A, lambda m. lambda a. quotStep(X, A, O, step, observe, m, a), @cl{x}, w), @cl{run(X, A, step, x, w)}):
  match w:
    case []: <_> @cl{x}
    case a <> rest: quotRun_cl(X, A, O, step, observe, step(x, a), rest)
def quotient_preserves_behavior(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X, w: A[]) -> Path(O, behavior(Meaning(X, A, O, step, observe), A, O, lambda m. lambda a. quotStep(X, A, O, step, observe, m, a), lambda m. quotObserve(X, A, O, step, setO, observe, m), @cl{x}, w), behavior(X, A, O, step, observe, x, w)):
  <i> quotObserve(X, A, O, step, setO, observe, quotRun_cl(X, A, O, step, observe, x, w) @ i)

# effectivity: a path of meanings yields future equality
def nerodeEffective(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X, y: X, p: Path(Meaning(X, A, O, step, observe), @cl{x}, @cl{y})) -> Nerode(X, A, O, step, observe, x, y):
  effective(X, NerodeR(X, A, O, step, observe),
    lambda x2. lambda y2. isPropNerode(X, A, O, step, setO, observe, x2, y2),
    lambda x2. nerodeRefl(X, A, O, step, observe, x2),
    lambda x2. lambda y2. lambda h. nerodeSym(X, A, O, step, observe, x2, y2, h),
    lambda x2. lambda y2. lambda z2. lambda h1. lambda h2. nerodeTrans(X, A, O, step, observe, x2, y2, z2, h1, h2),
    isSetHProp(), x, y, p)

# full abstraction: meanings embed into complete behaviours
def quotBehavior(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, m: Meaning(X, A, O, step, observe)) -> A[] -> O:
  quotRec(X, NerodeR(X, A, O, step, observe), A[] -> O, lambda f. lambda g. lambda p. lambda q. isSetPi(A[], lambda w. O, lambda w. setO, f, g, p, q),
    lambda x. lambda w. behavior(X, A, O, step, observe, x, w),
    lambda x. lambda y. lambda h. <i> lambda w. h(w) @ i, m)
def quotBehavior_cl(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, x: X) -> Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, @cl{x}), lambda w. behavior(X, A, O, step, observe, x, w)):
  <_> lambda w. behavior(X, A, O, step, observe, x, w)
def quotBehavior_injective(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, m: Meaning(X, A, O, step, observe), n: Meaning(X, A, O, step, observe), p: Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m), quotBehavior(X, A, O, step, setO, observe, n))) -> Path(Meaning(X, A, O, step, observe), m, n):
  quotElimProp2(X, NerodeR(X, A, O, step, observe),
    lambda m2. lambda n2. Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m2), quotBehavior(X, A, O, step, setO, observe, n2)) -> Path(Meaning(X, A, O, step, observe), m2, n2),
    lambda m2. lambda n2. isPropPi(Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m2), quotBehavior(X, A, O, step, setO, observe, n2)), lambda p2. Path(Meaning(X, A, O, step, observe), m2, n2), lambda p2. squash(X, NerodeR(X, A, O, step, observe), m2, n2)),
    lambda x. lambda y. lambda p2. @eq{x, y, lambda w. <i> (p2 @ i)(w)}, m, n, p)
def quotBehavior_is_machine_behavior(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, m: Meaning(X, A, O, step, observe)) -> Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m2. lambda a. quotStep(X, A, O, step, observe, m2, a), lambda m2. quotObserve(X, A, O, step, setO, observe, m2), m, w)):
  quotElimProp(X, NerodeR(X, A, O, step, observe),
    lambda m2. Path(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m2), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m3. lambda a. quotStep(X, A, O, step, observe, m3, a), lambda m3. quotObserve(X, A, O, step, setO, observe, m3), m2, w)),
    lambda m2. lambda p. lambda q. isSetPi(A[], lambda w. O, lambda w. setO, quotBehavior(X, A, O, step, setO, observe, m2), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m3. lambda a. quotStep(X, A, O, step, observe, m3, a), lambda m3. quotObserve(X, A, O, step, setO, observe, m3), m2, w), p, q),
    lambda x. <i> lambda w. quotient_preserves_behavior(X, A, O, step, setO, observe, x, w) @ inot(i), m)
# the quotient machine separates its own behaviours
def behaviorSeparatesStates(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, m: Meaning(X, A, O, step, observe), n: Meaning(X, A, O, step, observe), p: Path(A[] -> O, lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m2. lambda a. quotStep(X, A, O, step, observe, m2, a), lambda m2. quotObserve(X, A, O, step, setO, observe, m2), m, w), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m2. lambda a. quotStep(X, A, O, step, observe, m2, a), lambda m2. quotObserve(X, A, O, step, setO, observe, m2), n, w))) -> Path(Meaning(X, A, O, step, observe), m, n):
  quotBehavior_injective(X, A, O, step, setO, observe, m, n,
    compPath3(A[] -> O, quotBehavior(X, A, O, step, setO, observe, m), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m2. lambda a. quotStep(X, A, O, step, observe, m2, a), lambda m2. quotObserve(X, A, O, step, setO, observe, m2), m, w), lambda w. behavior(Meaning(X, A, O, step, observe), A, O, lambda m2. lambda a. quotStep(X, A, O, step, observe, m2, a), lambda m2. quotObserve(X, A, O, step, setO, observe, m2), n, w), quotBehavior(X, A, O, step, setO, observe, n),
      quotBehavior_is_machine_behavior(X, A, O, step, setO, observe, m), p, <i> quotBehavior_is_machine_behavior(X, A, O, step, setO, observe, n) @ inot(i)))

# the universal property of the quotient
def factor(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, T: Set, setT: isSet(T), target: X -> T, const: all x: X. all y: X. Nerode(X, A, O, step, observe, x, y) -> Path(T, target(x), target(y)), m: Meaning(X, A, O, step, observe)) -> T:
  quotRec(X, NerodeR(X, A, O, step, observe), T, setT, target, const, m)
def factor_cl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, T: Set, setT: isSet(T), target: X -> T, const: all x: X. all y: X. Nerode(X, A, O, step, observe, x, y) -> Path(T, target(x), target(y)), x: X) -> Path(T, factor(X, A, O, step, observe, T, setT, target, const, @cl{x}), target(x)):
  <_> target(x)
def factor_unique(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, T: Set, setT: isSet(T), target: X -> T, const: all x: X. all y: X. Nerode(X, A, O, step, observe, x, y) -> Path(T, target(x), target(y)), g: Meaning(X, A, O, step, observe) -> T, hg: all x: X. Path(T, g(@cl{x}), target(x)), m: Meaning(X, A, O, step, observe)) -> Path(T, g(m), factor(X, A, O, step, observe, T, setT, target, const, m)):
  quotElimProp(X, NerodeR(X, A, O, step, observe), lambda m2. Path(T, g(m2), factor(X, A, O, step, observe, T, setT, target, const, m2)),
    lambda m2. setT(g(m2), factor(X, A, O, step, observe, T, setT, target, const, m2)), hg, m)

# ---- terminality among behaviour-preserving quotients: X / S maps onto Meaning uniquely
def mediate(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), q: Quotient(X, S)) -> Meaning(X, A, O, step, observe):
  quotRec(X, S, Meaning(X, A, O, step, observe), squash(X, NerodeR(X, A, O, step, observe)),
    lambda x. @cl{x},
    lambda x. lambda y. lambda s. @eq{x, y, lambda w. congruenceToNerode(X, A, O, step, observe, S, isC, x, y, s, w)}, q)
def stepQ(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), q: Quotient(X, S), a: A) -> Quotient(X, S):
  match isC:
    case @congruence{ro, rs}:
      quotRec(X, S, Quotient(X, S), squash(X, S), lambda x. @cl{step(x, a)}, lambda x. lambda y. lambda s. @eq{step(x, a), step(y, a), rs(x, y, a, s)}, q)
def observeQ(X: Set, A: Set, O: Set, step: X -> A -> X, setO: isSet(O), observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), q: Quotient(X, S)) -> O:
  match isC:
    case @congruence{ro, rs}:
      quotRec(X, S, O, setO, observe, lambda x. lambda y. lambda s. ro(x, y, s), q)
def mediate_cl(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), x: X) -> Path(Meaning(X, A, O, step, observe), mediate(X, A, O, step, observe, S, isC, @cl{x}), @cl{x}):
  <_> @cl{x}
def mediate_unique(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, S: X -> X -> Set, isC: isBehavioralCongruence(X, A, O, step, observe, S), g: Quotient(X, S) -> Meaning(X, A, O, step, observe), hg: all x: X. Path(Meaning(X, A, O, step, observe), g(@cl{x}), @cl{x}), q: Quotient(X, S)) -> Path(Meaning(X, A, O, step, observe), g(q), mediate(X, A, O, step, observe, S, isC, q)):
  quotElimProp(X, S, lambda q2. Path(Meaning(X, A, O, step, observe), g(q2), mediate(X, A, O, step, observe, S, isC, q2)),
    lambda q2. squash(X, NerodeR(X, A, O, step, observe), g(q2), mediate(X, A, O, step, observe, S, isC, q2)), hg, q)

# ---- the machine record and its crystal (the quotient is again a machine, same behaviour)
type Machine:
  case @machine:
    State: Set
    Action: Set
    Obs: Set
    isSetObs: isSet(Obs)
    step: State -> Action -> State
    observe: State -> Obs
def crystal(M: Machine) -> Machine:
  match M:
    case @machine{X, A, O, sO, st, ob}:
      @machine{Meaning(X, A, O, st, ob), A, O, sO, lambda m. lambda a. quotStep(X, A, O, st, ob, m, a), lambda m. quotObserve(X, A, O, st, sO, ob, m)}

def main() -> Nat:
  0n

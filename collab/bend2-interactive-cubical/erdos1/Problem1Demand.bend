# Full unbounded quantifier demand state for Erdős Problem 1.
# The state is computational (Nat/lists/Bool); no universe-valued proposition is
# normalized by HVM4. Every coordinate remains explicit in the carried state.
import Problem1Computable

type DemandPhase:
  case @constantDemand:
    constant: Nat
  case @thresholdDemand:
    constant: Nat
    threshold: Nat
  case @nDemand:
    constant: Nat
    threshold: Nat
    n: Nat
  case @boundDemand:
    constant: Nat
    threshold: Nat
    n: Nat
    bound: Nat
  case @setDemand:
    constant: Nat
    threshold: Nat
    n: Nat
    bound: Nat
    setIndex: Nat

type Problem1Demand:
  case @problem1Demand:
    phase: DemandPhase
    continuation: Nat

# The local finite subset represented by the binary cursor setIndex is the
# subset of {1,...,bound} selected by the binary digits of setIndex. This
# preserves every finite A without storing a universe-level FiniteSet value.
def notBit(b: Bool) -> Bool:
  if b: False else: True

def odd(k: Nat) -> Bool:
  match k:
    case 0n: False
    case 1n + p: notBit(odd(p))

def shiftRight(k: Nat, i: Nat) -> Nat:
  match i:
    case 0n: k
    case 1n + p:
      match k:
        case 0n: 0n
        case 1n + q: shiftRight(q,p)

def bitAt(k: Nat, i: Nat) -> Bool:
  odd(shiftRight(k,i))

def rangeElements(bound: Nat, k: Nat, i: Nat) -> Nat[]:
  match i:
    case 0n: []
    case 1n + p:
      match bitAt(k,p):
        case False: rangeElements(bound,k,p)
        case True: (1n + p) <> rangeElements(bound,k,p)

def demandObservation(d: Problem1Demand) -> Bool:
  match d:
    case @problem1Demand{phase, continuation}:
      match phase:
        case @setDemand{constant, threshold, n, bound, setIndex}:
          boolAnd(localDSS(bound,n,rangeElements(bound,setIndex,bound)),
            leNatB(mulB(constant,pow2B(n)),bound))
        case @constantDemand{constant}: False
        case @thresholdDemand{constant,threshold}: False
        case @nDemand{constant,threshold,n}: False
        case @boundDemand{constant,threshold,n,bound}: False

def problem1DemandCoalgebra(d: Problem1Demand) -> FibreCoalgebra(Problem1Demand,d):
  fibreCoalgebra(Problem1Demand,d)

def problem1DemandObservation(d: Problem1Demand) -> FibreObservation(Problem1Demand,d,Bool,demandObservation):
  observe(Problem1Demand,d,problem1DemandCoalgebra(d),Bool,demandObservation)

# One demand transition.  Quantifier coordinates are retained; the finite-set
# cursor advances over the binary presentations of subsets at the current N.
def advanceDemand(d: Problem1Demand) -> Problem1Demand:
  match d:
    case @problem1Demand{phase, continuation}:
      match phase:
        case @constantDemand{constant}:
          @problem1Demand{@thresholdDemand{constant,0n},continuation}
        case @thresholdDemand{constant,threshold}:
          @problem1Demand{@nDemand{constant,threshold,threshold},continuation}
        case @nDemand{constant,threshold,n}:
          @problem1Demand{@boundDemand{constant,threshold,n,0n},continuation}
        case @boundDemand{constant,threshold,n,bound}:
          @problem1Demand{@setDemand{constant,threshold,n,bound,0n},continuation}
        case @setDemand{constant,threshold,n,bound,setIndex}:
          match eqNatB(1n + setIndex,pow2B(bound)):
            case False: @problem1Demand{@setDemand{constant,threshold,n,bound,1n + setIndex},continuation}
            case True: @problem1Demand{@boundDemand{constant,threshold,n,1n + bound},continuation}

def initialDemand() -> Problem1Demand:
  @problem1Demand{@constantDemand{1n},0n}

def main() -> Bool:
  demandObservation(advanceDemand(advanceDemand(advanceDemand(advanceDemand(initialDemand())))))

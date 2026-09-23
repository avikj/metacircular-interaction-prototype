# Execution-facing presentation of the exact local Erdős predicate.
# The proposition remains unbounded in the carried state; only its local
# finite combinatorics is observed as Bool so HVM4 need not normalize Set.
import ../port/Prelude
import ../port/FibreCoalgebra
import ../port/FibreElement

def boolAnd(x: Bool, y: Bool) -> Bool:
  if x: y else: False

def eqNatB(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: True
        case 1n + q: False
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: eqNatB(p,q)

def leNatB(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n: True
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: leNatB(p,q)

def ltNatB(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: False
        case 1n + q: True
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: ltNatB(p,q)

def addB(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n + p: 1n + addB(p,b)

def mulB(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: addB(b,mulB(p,b))

def pow2B(n: Nat) -> Nat:
  match n:
    case 0n: 1n
    case 1n + p: addB(pow2B(p),pow2B(p))

def lenB(xs: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t: 1n + lenB(t)

def validTail(N: Nat, previous: Nat, xs: Nat[]) -> Bool:
  match xs:
    case []: True
    case h <> t: boolAnd(leNatB(h,N),boolAnd(ltNatB(previous,h),validTail(N,h,t)))

def validSet(N: Nat, xs: Nat[]) -> Bool:
  match xs:
    case []: True
    case h <> t: boolAnd(ltNatB(0n,h),boolAnd(leNatB(h,N),validTail(N,h,t)))

def subsetSum(xs: Nat[], mask: Bool[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t:
      match mask:
        case []: 0n
        case b <> bs: if b: addB(h,subsetSum(t,bs)) else: subsetSum(t,bs)

def maskEq(xs: Bool[], ys: Bool[]) -> Bool:
  match xs:
    case []:
      match ys:
        case []: True
        case h <> t: False
    case h <> t:
      match ys:
        case []: False
        case k <> r: boolAnd(if h: k else: if k: False else: True,maskEq(t,r))

def prependMask(b: Bool, ms: Bool[][]) -> Bool[][]:
  match ms:
    case []: []
    case h <> t: (b <> h) <> prependMask(b,t)

def appendMasks(xs: Bool[][], ys: Bool[][]) -> Bool[][]:
  match xs:
    case []: ys
    case h <> t: h <> appendMasks(t,ys)

def allMasks(n: Nat) -> Bool[][]:
  match n:
    case 0n: [[]]
    case 1n + p: appendMasks(prependMask(False,allMasks(p)),prependMask(True,allMasks(p)))

def sumsDistinctAgainst(xs: Nat[], mask: Bool[], ys: Bool[][]) -> Bool:
  match ys:
    case []: True
    case h <> t:
      boolAnd(if eqNatB(subsetSum(xs,mask),subsetSum(xs,h)): maskEq(mask,h) else: True,
              sumsDistinctAgainst(xs,mask,t))

def masksDistinct(xs: Nat[], masks: Bool[][]) -> Bool:
  match masks:
    case []: True
    case h <> t: boolAnd(sumsDistinctAgainst(xs,h,t),masksDistinct(xs,t))

# Exact finite local predicate: admissible A and injective subset-sum map.
def localDSS(N: Nat, n: Nat, xs: Nat[]) -> Bool:
  boolAnd(validSet(N,xs),boolAnd(eqNatB(lenB(xs),n),masksDistinct(xs, allMasks(lenB(xs)))))

type QueryState:
  case @queryState:
    constant: Nat
    threshold: Nat
    n: Nat
    bound: Nat
    elements: Nat[]
    continuation: Nat

def localObservation(s: QueryState) -> Bool:
  match s: case @queryState{constant,threshold,n,bound,elements,continuation}:
    boolAnd(localDSS(bound,n,elements),leNatB(mulB(constant,pow2B(n)),bound))

def queryCoalgebra(s: QueryState) -> FibreCoalgebra(QueryState,s):
  fibreCoalgebra(QueryState,s)

def query(s: QueryState) -> FibreObservation(QueryState,s,Bool,localObservation):
  observe(QueryState,s,queryCoalgebra(s),Bool,localObservation)

def initial() -> QueryState:
  @queryState{1n,0n,0n,0n,[],0n}

def main() -> Bool:
  observedValue(QueryState,Bool,localObservation,
    match query(initial()): case @fibreObservation{value,source,next}: value)

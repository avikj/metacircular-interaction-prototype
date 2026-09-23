# Exact data and predicates for the (unbounded) finite-set part of Erdos
# Problem 1.  This file contains no SAT encoding and no fixed numerical
# instance.  A finite set is represented by a strictly increasing list of
# naturals; a subset is a Boolean mask of exactly the same length.
import ../port/Prelude

# Boolean connectives used to expose decidable arithmetic predicates.
def andb(x: Bool, y: Bool) -> Bool:
  if x: y
  else: False

def orb(x: Bool, y: Bool) -> Bool:
  if x: True
  else: y

def notb(x: Bool) -> Bool:
  if x: False
  else: True

# Decidable equality and order on the natural numbers.
def eqNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: True
        case 1n + q: False
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: eqNat(p, q)

def leNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n: True
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: leNat(p, q)

def ltNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: False
        case 1n + q: True
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: ltNat(p, q)

def holds(b: Bool) -> Set:
  Path(Bool, b, True)

# Arithmetic in the exact unary natural representation.
def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))

def pow2(n: Nat) -> Nat:
  match n:
    case 0n: 1n
    case 1n + p: add(pow2(p), pow2(p))

# A list is a finite set presentation precisely when it is nonempty,
# strictly increasing, and every element lies in {1,...,N}.
def positiveList(xs: Nat[]) -> Set:
  match xs:
    case []: Unit
    case h <> t: holds(ltNat(0n, h))

def increasing(xs: Nat[]) -> Set:
  match xs:
    case []: Unit
    case h <> t:
      match t:
        case []: Unit
        case k <> r:
          any e: holds(ltNat(h, k)). increasing(k <> r)

def boundedBy(N: Nat, xs: Nat[]) -> Set:
  match xs:
    case []: Unit
    case h <> t: any e: holds(leNat(h, N)). boundedBy(N, t)

def finiteSet(N: Nat, xs: Nat[]) -> Set:
  any p: positiveList(xs). any q: increasing(xs). any r: boundedBy(N, xs). Unit

# The type of all finite-set presentations for a given ambient bound.
def FiniteSet(N: Nat) -> Set:
  any xs: Nat[]. finiteSet(N, xs)

def setCardinality(xs: Nat[]) -> Nat:
  length(Nat, xs)

# A subset is represented by a Boolean mask.  Its validity is the exact
# same-length condition; no enumeration or bound is introduced here.
def maskValid(xs: Nat[], mask: Bool[]) -> Set:
  Path(Nat, length(Nat, xs), length(Bool, mask))

def Subset(xs: Nat[]) -> Set:
  any mask: Bool[]. maskValid(xs, mask)

def subsetSum(xs: Nat[], mask: Bool[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t:
      match mask:
        case []: 0n
        case b <> bs:
          if b: add(h, subsetSum(t, bs))
          else: subsetSum(t, bs)

# Exact equality of masks, used to state injectivity of the subset-sum map.
def masksEqual(xs: Bool[], ys: Bool[]) -> Set:
  Path(Bool[], xs, ys)

# Distinct subset sums means that the subset-sum map is injective on every
# pair of valid masks.  The validity premises are implications, so malformed
# masks contribute no mathematical content to the proposition.
def distinctSubsetSums(xs: Nat[]) -> Set:
  all s: Bool[].
    maskValid(xs, s) ->
    all t: Bool[].
      maskValid(xs, t) ->
      Path(Nat, subsetSum(xs, s), subsetSum(xs, t)) ->
      masksEqual(s, t)

# The local proposition used by Erdos Problem 1 at parameters n and N.
def admissibleSet(N: Nat, n: Nat, xs: Nat[]) -> Set:
  finiteSet(N, xs) ->
  Path(Nat, setCardinality(xs), n) ->
  distinctSubsetSums(xs)

def main() -> Nat:
  subsetSum([1n, 2n, 4n], [True, False, True])

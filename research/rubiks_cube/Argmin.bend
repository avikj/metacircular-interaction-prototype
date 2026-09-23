import RubiksFamily

# Elementary natural-number ordering and minimum fold.

type NatOrdering:
  case @less:
  case @equal:
  case @greater:

def compareNat(a: Nat, b: Nat) -> NatOrdering:
  match a:
    case 0n:
      match b:
        case 0n: @equal
        case 1n + q: @less
    case 1n + p:
      match b:
        case 0n: @greater
        case 1n + q: compareNat(p, q)

def greaterNat(a: Nat, b: Nat) -> Bool:
  match compareNat(a, b):
    case @greater: True
    case @less: False
    case @equal: False

def minNat(a: Nat, b: Nat) -> Nat:
  if greaterNat(a, b): b else: a

def minNatList(xs: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case x <> rest: minNat(x, minNatList(rest))

# Argmin over already-generated scored candidates.  The candidate generator
# supplies the proof-bearing validity and leastness fields; this fold only
# performs the elementary numeric comparison and retains the winning record.
type WordCandidate:
  case @wordCandidate:
    word: Word
    score: U64
    valid: Set
    least: Set

def betterWord(a: WordCandidate, b: WordCandidate) -> WordCandidate:
  match a:
    case @wordCandidate{wa, sa, va, la}:
      match b:
        case @wordCandidate{wb, sb, vb, lb}:
          if greaterNat(sa, sb): b else: a

def argminWords(xs: WordCandidate[]) -> WordCandidate:
  match xs:
    case []: @wordCandidate{@word{[]}, 0, (), ()}
    case x <> rest: betterWord(x, argminWords(rest))

def main() -> Nat:
  minNatList([7n, 3n, 11n, 2n, 5n])

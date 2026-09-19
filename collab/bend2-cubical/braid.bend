# THE BRAID FABRIC (VeniBandha / AnantaVeni), carried to Bend and run.
#
# Strands are interdependent pairs Stra = Bool — Bool; the crossing Ïµ is the
# twisted swap: the strand that passes over is turned by the quarter turn
# caturaa (a, b) = (not b, a).  The rope is the coinductive stream Dhr of
# strands; Bend2 has no coinduction, so the rope is carried as its observation
# function Nat -> Stra (bisimilar = equal at every depth: the
# ProductiveObservabilityBridge), on which every Ïµ is total and every braid
# relation holds at every position â” pointwise, by the same induction as the
# Agda (peel to the base at i = 0, then the head is preserved and the tail
# recurses).
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def Sutra() -> Set:
  any a: Bool. Bool
def quarter(s: Sutra) -> Sutra:
  match s:
    case (a, b):
      (neg(b), a)
def Rajju() -> Set:
  Nat -> Sutra

# Ïµ on the rope: cross strands i and i+1, turning the one that passes over
def veni(i: Nat, s: Rajju, n: Nat) -> Sutra:
  match i:
    case 0n:
      match n:
        case 0n:
          quarter(s(1n))
        case 1n + m:
          match m:
            case 0n:
              s(0n)
            case 1n + k:
              s(2n + k)
    case 1n + j:
      match n:
        case 0n:
          s(0n)
        case 1n + m:
          veni(j, lambda k. s(1n + k), m)

# ---------------------------------------------------------------------------
# The braid relation Ïµ ÏµâŠâ Ïµ = ÏµâŠâ Ïµ ÏµâŠâ at every position, pointwise.
# The base i = 0 is definitional at every depth after splitting n into
# 0 / 1 / 2+ (both sides compute to the same strand); the step preserves the
# head and recurses on the tail.
# ---------------------------------------------------------------------------
def veniBase(s: Rajju, n: Nat) -> Path(Sutra, veni(0n, lambda k. veni(1n, lambda k. veni(0n, s, k), k), n), veni(1n, lambda k. veni(0n, lambda k. veni(1n, s, k), k), n)):
  match n:
    case 0n:
      <_> quarter(quarter(s(2n)))
    case 1n + m:
      match m:
        case 0n:
          <_> quarter(s(1n))
        case 1n + k:
          match k:
            case 0n:
              <_> s(0n)
            case 1n + q:
              <_> s(3n + q)
def veniRel(i: Nat, s: Rajju, n: Nat) -> Path(Sutra, veni(i, lambda k. veni(1n + i, lambda k. veni(i, s, k), k), n), veni(1n + i, lambda k. veni(i, lambda k. veni(1n + i, s, k), k), n)):
  match i:
    case 0n:
      veniBase(s, n)
    case 1n + j:
      match n:
        case 0n:
          <_> s(0n)
        case 1n + m:
          veniRel(j, lambda k. s(1n + k), m)

# The distant commutation Ïµ Ïâ¼ = Ïâ¼ Ïµ for j â‰ i + 2, at every gap, pointwise.
def duraBase(k: Nat, s: Rajju, n: Nat) -> Path(Sutra, veni(0n, lambda m. veni(2n + k, s, m), n), veni(2n + k, lambda m. veni(0n, s, m), n)):
  match n:
    case 0n:
      <_> quarter(s(1n))
    case 1n + m:
      match m:
        case 0n:
          <_> s(0n)
        case 1n + q:
          <_> veni(k, lambda r. s(2n + r), q)
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n + p:
      1n + add(p, b)
def duraRel(i: Nat, k: Nat, s: Rajju, n: Nat) -> Path(Sutra, veni(i, lambda m. veni(2n + add(i, k), s, m), n), veni(2n + add(i, k), lambda m. veni(i, s, m), n)):
  match i:
    case 0n:
      duraBase(k, s, n)
    case 1n + j:
      match n:
        case 0n:
          <_> s(0n)
        case 1n + m:
          duraRel(j, k, lambda r. s(1n + r), m)

# ---------------------------------------------------------------------------
# A concrete rope, run: strand n = (n even?, True); observe the rope after
# ÏâÏâÏâ and after ÏâÏâÏâ at depth 0..3 â” equal, as the relation says.
# ---------------------------------------------------------------------------
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True
    case 1n + m:
      neg(even(m))
def rope(n: Nat) -> Sutra:
  (even(n), True)
def lhs(n: Nat) -> Sutra:
  veni(0n, lambda k. veni(1n, lambda k. veni(0n, rope, k), k), n)
def rhs(n: Nat) -> Sutra:
  veni(1n, lambda k. veni(0n, lambda k. veni(1n, rope, k), k), n)
def fstS(s: Sutra) -> Bool:
  match s:
    case (a, b):
      a
def main() -> Bool:
  fstS(lhs(0n))

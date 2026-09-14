# Lattice HP folding as an EXACT integer computation on the substrate.
# The fibre of the fold map = the set of self-avoiding walks achieving the
# minimum energy (max H-H contacts). |fibre| = 1 -> contractible -> unique
# native fold; |fibre| > 1 -> non-contractible -> ground-state ensemble.
# No floats: energy is an integer contact count. Pure lossless computation.

type Pos:
  case @P:
    x: Nat
    y: Nat

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      return 0n
    case 1n + p:
      return p

def eqNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          return True
        case 1n + q:
          return False
    case 1n + p:
      match b:
        case 0n:
          return False
        case 1n + q:
          return eqNat(p, q)

def andB(a: Bool, b: Bool) -> Bool:
  if a:
    return b
  else:
    return False

def absDiff(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      return b
    case 1n + p:
      match b:
        case 0n:
          return 1n + p
        case 1n + q:
          return absDiff(p, q)

def posEq(p: Pos, q: Pos) -> Bool:
  match p:
    case @P{x, y}:
      match q:
        case @P{x2, y2}:
          return andB(eqNat(x, x2), eqNat(y, y2))

# lattice adjacency: manhattan distance exactly 1
def adj(p: Pos, q: Pos) -> Bool:
  match p:
    case @P{x, y}:
      match q:
        case @P{x2, y2}:
          return eqNat(addNat(absDiff(x, x2), absDiff(y, y2)), 1n)

def moveP(p: Pos, d: Nat) -> Pos:
  match p:
    case @P{x, y}:
      match d:
        case 0n:
          return @P{1n + x, y}
        case 1n + d1:
          match d1:
            case 0n:
              return @P{x, 1n + y}
            case 1n + d2:
              match d2:
                case 0n:
                  return @P{pred(x), y}
                case 1n + d3:
                  return @P{x, pred(y)}

# build the walk (list of positions) from a start and a move list
def walk(p: Pos, ms: Nat[]) -> Pos[]:
  match ms:
    case []:
      return p <> []
    case m <> rest:
      return p <> walk(moveP(p, m), rest)

def member(p: Pos, ps: Pos[]) -> Bool:
  match ps:
    case []:
      return False
    case q <> rest:
      if posEq(p, q):
        return True
      else:
        return member(p, rest)

def saw(ps: Pos[]) -> Bool:
  match ps:
    case []:
      return True
    case q <> rest:
      if member(q, rest):
        return False
      else:
        return saw(rest)

# H-H topological contacts: pairs adjacent on lattice, non-adjacent in chain,
# both H (True). Walk positions and HP sequence are aligned lists.
def contactsFrom(p: Pos, h: Bool, ps: Pos[], hs: Bool[]) -> Nat:
  match ps:
    case []:
      return 0n
    case q <> rest:
      match hs:
        case []:
          return 0n
        case hq <> hrest:
          if andB(h, andB(hq, adj(p, q))):
            return 1n + contactsFrom(p, h, rest, hrest)
          else:
            return contactsFrom(p, h, rest, hrest)

# sum over i of contacts between i and residues j>=i+2 (skip the chain neighbour)
def dropOne<A>(xs: A[]) -> A[]:
  match xs:
    case []:
      return []
    case x <> rest:
      return rest

def addNat(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      return b
    case 1n + p:
      return 1n + addNat(p, b)

def energy(ps: Pos[], hs: Bool[]) -> Nat:
  match ps:
    case []:
      return 0n
    case p <> rest:
      match hs:
        case []:
          return 0n
        case h <> hrest:
          return addNat(contactsFrom(p, h, dropOne<Pos>(rest), dropOne<Bool>(hrest)), energy(rest, hrest))

# enumerate all move sequences of length L over {0,1,2,3}
def prependAll(d: Nat, seqs: Nat[][]) -> Nat[][]:
  match seqs:
    case []:
      return []
    case s <> rest:
      return (d <> s) <> prependAll(d, rest)

def appendL<A>(xs: A[], ys: A[]) -> A[]:
  match xs:
    case []:
      return ys
    case x <> rest:
      return x <> appendL<A>(rest, ys)

def allSeqs(L: Nat) -> Nat[][]:
  match L:
    case 0n:
      return [] <> []
    case 1n + k:
      s = allSeqs(k)
      a = prependAll(0n, s)
      b = prependAll(1n, s)
      c = prependAll(2n, s)
      d = prependAll(3n, s)
      return appendL<Nat[]>(a, appendL<Nat[]>(b, appendL<Nat[]>(c, d)))

def maxNat(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      return b
    case 1n + p:
      match b:
        case 0n:
          return 1n + p
        case 1n + q:
          return 1n + maxNat(p, q)

# fold over all walks: track (bestEnergy, degeneracy) among SAWs.
# start is fixed; first move fixed to 0 (E) by the caller to kill 4x rotation.
type Res:
  case @R:
    best: Nat
    deg: Nat

def combine(e: Nat, acc: Res) -> Res:
  match acc:
    case @R{best, deg}:
      if eqNat(e, best):
        return @R{best, 1n + deg}
      else:
        if eqNat(maxNat(e, best), e):
          return @R{e, 1n}
        else:
          return @R{best, deg}

def scan(start: Pos, hs: Bool[], seqs: Nat[][], acc: Res) -> Res:
  match seqs:
    case []:
      return acc
    case s <> rest:
      ps = walk(start, s)
      if saw(ps):
        return scan(start, hs, rest, combine(energy(ps, hs), acc))
      else:
        return scan(start, hs, rest, acc)

# ---- instance: HP sequence of length 6 : H P P H P H --------------------
def seqHP() -> Bool[]:
  return True <> False <> False <> True <> False <> True <> []

# start at (8,8) offset so length-6 walk never underflows; first move E fixed
def fold6() -> Res:
  moves = prependAll(0n, allSeqs(4n))   # length-5 move lists, first step = E
  return scan(@P{8n, 8n}, seqHP(), moves, @R{0n, 0n})

def main() -> Res:
  return fold6()

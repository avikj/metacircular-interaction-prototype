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

# ---- sequence census: the fibre across ALL HP sequences of a length -----
def lenB(xs: Bool[]) -> Nat:
  match xs:
    case []:
      return 0n
    case x <> r:
      return 1n + lenB(r)

def prependAllB(b: Bool, seqs: Bool[][]) -> Bool[][]:
  match seqs:
    case []:
      return []
    case s <> rest:
      return (b <> s) <> prependAllB(b, rest)

def allHP(L: Nat) -> Bool[][]:
  match L:
    case 0n:
      return [] <> []
    case 1n + k:
      s = allHP(k)
      return appendL<Bool[]>(prependAllB(True, s), prependAllB(False, s))

# fold any sequence: moves of length len-1, first step fixed E (kills rotation)
def foldN(hs: Bool[]) -> Res:
  L = lenB(hs)
  moves = prependAll(0n, allSeqs(pred(pred(L))))
  return scan(@P{8n, 8n}, hs, moves, @R{0n, 0n})

type Row:
  case @Row:
    seq: Bool[]
    res: Res

def census(seqs: Bool[][]) -> Row[]:
  match seqs:
    case []:
      return []
    case h <> rest:
      return @Row{h, foldN(h)} <> census(rest)

# ---- full symmetry reduction: true distinct-fold count -------------------
# moves in {0,1,2,3} = E,N,W,S. Symmetry group = 4 rotations x reflection x
# chain-reversal (up to 16 images). Canonical form = lex-min move sequence
# over the orbit; true degeneracy = #distinct canonical ground-state folds.
def ltNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          return False
        case 1n + q:
          return True
    case 1n + p:
      match b:
        case 0n:
          return False
        case 1n + q:
          return ltNat(p, q)

def subNat(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      return a
    case 1n + q:
      return subNat(pred(a), q)

# inputs are always < 8 here (rotD: 1+d, invD: d+2, with d in 0..3), so a
# single subtraction suffices — kept non-recursive so totality is structural.
def mod4(n: Nat) -> Nat:
  if ltNat(n, 4n):
    return n
  else:
    return subNat(n, 4n)

def rotD(d: Nat) -> Nat:
  return mod4(1n + d)
def invD(d: Nat) -> Nat:
  return mod4(addNat(d, 2n))
def reflD(d: Nat) -> Nat:
  if eqNat(d, 1n):
    return 3n
  else:
    if eqNat(d, 3n):
      return 1n
    else:
      return d

def mapD(f: Nat -> Nat, ms: Nat[]) -> Nat[]:
  match ms:
    case []:
      return []
    case m <> rest:
      return f(m) <> mapD(f, rest)

def revA<A>(xs: A[], acc: A[]) -> A[]:
  match xs:
    case []:
      return acc
    case x <> r:
      return revA<A>(r, x <> acc)
def reverseL<A>(xs: A[]) -> A[]:
  return revA<A>(xs, [])

def revInv(ms: Nat[]) -> Nat[]:
  return reverseL<Nat>(mapD(invD, ms))

# the 16-image orbit of a move sequence
def orbit(ms: Nat[]) -> Nat[][]:
  r0 = ms
  r1 = mapD(rotD, r0)
  r2 = mapD(rotD, r1)
  r3 = mapD(rotD, r2)
  base = r0 <> (r1 <> (r2 <> (r3 <> [])))
  refl = mapD(reflD, r0) <> (mapD(reflD, r1) <> (mapD(reflD, r2) <> (mapD(reflD, r3) <> [])))
  rots = appendL<Nat[]>(base, refl)
  return appendL<Nat[]>(rots, mapD2rev(rots))
def mapD2rev(xs: Nat[][]) -> Nat[][]:
  match xs:
    case []:
      return []
    case x <> rest:
      return revInv(x) <> mapD2rev(rest)

def lexLE(a: Nat[], b: Nat[]) -> Bool:
  match a:
    case []:
      return True
    case x <> xr:
      match b:
        case []:
          return False
        case y <> yr:
          if ltNat(x, y):
            return True
          else:
            if eqNat(x, y):
              return lexLE(xr, yr)
            else:
              return False

def lexMin(a: Nat[], b: Nat[]) -> Nat[]:
  if lexLE(a, b):
    return a
  else:
    return b

def foldMin(xs: Nat[][], acc: Nat[]) -> Nat[]:
  match xs:
    case []:
      return acc
    case x <> rest:
      return foldMin(rest, lexMin(x, acc))

def canon(ms: Nat[]) -> Nat[]:
  match orbit(ms):
    case []:
      return ms
    case h <> rest:
      return foldMin(rest, h)

def listEqN(a: Nat[], b: Nat[]) -> Bool:
  match a:
    case []:
      match b:
        case []:
          return True
        case y <> yr:
          return False
    case x <> xr:
      match b:
        case []:
          return False
        case y <> yr:
          if eqNat(x, y):
            return listEqN(xr, yr)
          else:
            return False

def member2(x: Nat[], xs: Nat[][]) -> Bool:
  match xs:
    case []:
      return False
    case y <> rest:
      if listEqN(x, y):
        return True
      else:
        return member2(x, rest)

def nub(xs: Nat[][], seen: Nat[][]) -> Nat:
  match xs:
    case []:
      return 0n
    case x <> rest:
      if member2(x, seen):
        return nub(rest, seen)
      else:
        return 1n + nub(rest, x <> seen)

# collect canonical forms of ground-state SAWs (full enumeration, no fixing)
def grounds(start: Pos, hs: Bool[], seqs: Nat[][], best: Nat) -> Nat[][]:
  match seqs:
    case []:
      return []
    case s <> rest:
      ps = walk(start, s)
      if saw(ps):
        if eqNat(energy(ps, hs), best):
          return canon(s) <> grounds(start, hs, rest, best)
        else:
          return grounds(start, hs, rest, best)
      else:
        return grounds(start, hs, rest, best)

def bestE(start: Pos, hs: Bool[], seqs: Nat[][], acc: Nat) -> Nat:
  match seqs:
    case []:
      return acc
    case s <> rest:
      ps = walk(start, s)
      if saw(ps):
        return bestE(start, hs, rest, maxNat(energy(ps, hs), acc))
      else:
        return bestE(start, hs, rest, acc)

type TR:
  case @TR:
    seq: Bool[]
    best: Nat
    folds: Nat

def trueDeg(hs: Bool[]) -> TR:
  L = lenB(hs)
  seqs = allSeqs(pred(L))
  b = bestE(@P{8n, 8n}, hs, seqs, 0n)
  g = grounds(@P{8n, 8n}, hs, seqs, b)
  return @TR{hs, b, nub(g, [])}

# the 7 length-6 candidates with 2 contacts / rotation-deg 2
def cands() -> Bool[][]:
  return (True<>True<>True<>False<>False<>True<>[])       # HHHPPH
    <> ((True<>True<>False<>True<>False<>True<>[])        # HHPHPH
    <> ((True<>True<>False<>False<>True<>True<>[])        # HHPPHH
    <> ((True<>False<>True<>False<>True<>True<>[])        # HPHPHH
    <> ((True<>False<>True<>False<>False<>True<>[])       # HPHPPH
    <> ((True<>False<>False<>True<>True<>True<>[])        # HPPHHH
    <> ((True<>False<>False<>True<>False<>True<>[])       # HPPHPH
    <> []))))))

def censusTR(seqs: Bool[][]) -> TR[]:
  match seqs:
    case []:
      return []
    case h <> rest:
      return trueDeg(h) <> censusTR(rest)

# main is trivial: the type-checker eagerly normalises main, and the symmetry-
# reduced census (censusTR / trueDeg / canon over the full SAW enumeration) is
# far too heavy for its interpreter. All those defs are still type-checked here;
# the census itself is run through the compiled backend (JS/HVM), where its
# evaluation is controlled. See the driver for the actual results.
def main() -> Nat:
  return 0n

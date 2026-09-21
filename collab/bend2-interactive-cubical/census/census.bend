# ============================================================================
# The corpus's own future-behavior quotient  Meaning = X / FutureEq,
# MADE EFFECTIVE â” run by evaluation on the interaction-net runtime, over the
# corpus's own reflected type-shapes.  This is the construction agda/cubical
# proves total but OOMs trying to compute; here it is a value.
#
#   State   = Shape          a reflected type's headCode-labelled child tree
#   Action  = Nat            a child address
#   step    = childAt        RF.child: nth child, SELF-LOOP when out of range
#   observe = code           RF.headCode: the outermost syntactic constructor
#   FutureEq x y  <=>  forall word. observe(run x w) == observe(run y w)
#                 =   bisimulation of the observation process (coarser than
#                     structural equality: N(5,[]) ~ N(5,[self]))
# ============================================================================

type Shape:
  case @N:
    code: Nat
    kids: Shape[]

def obs(s: Shape) -> Nat:
  match s:
    case @N{code, kids}:
      return code


def List/length<A>(xs: A[]) -> Nat:
  match xs:
    case []:
      return 0n
    case x <> xs:
      return 1n + List/length<A>(xs)

# childAt(s,n): nth child; out of range returns s itself (RF.nth fallback=self)
def childAt(s: Shape, n: Nat) -> Shape:
  match s:
    case @N{code, kids}:
      return nthOr(kids, n, s)
def nthOr(xs: Shape[], n: Nat, fb: Shape) -> Shape:
  match xs:
    case []:
      return fb
    case x <> rest:
      match n:
        case 0n:
          return x
        case 1n + p:
          return nthOr(rest, p, fb)

def run(s: Shape, w: Nat[]) -> Shape:
  match w:
    case []:
      return s
    case a <> rest:
      return run(childAt(s, a), rest)

def behavior(s: Shape, w: Nat[]) -> Nat:
  return obs(run(s, w))

# --- FutureEq by bounded bisimulation. childAt self-loops on out-of-range
# actions, so iterating actions 0..maxArity-1 plus the (a,b) self-tail covers
# every word.  Exact once d >= the states' bisimulation depth.
def max(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      return b
    case 1n + p:
      match b:
        case 0n:
          return 1n + p
        case 1n + q:
          return 1n + max(p, q)

def bisimD(a: Shape, b: Shape, d: Nat) -> Bool:
  match d:
    case 0n:
      return Nat/eql(obs(a), obs(b))
    case 1n + d2:
      if Nat/eql(obs(a), obs(b)):
        m = max(arity(a), arity(b))
        selfTail = bisimD(a, b, d2)
        return and2(selfTail, actionsEq(a, b, m, d2))
      else:
        return False

# compare successors under actions (m-1)..0  (out-of-range -> self via childAt)
def actionsEq(a: Shape, b: Shape, m: Nat, d: Nat) -> Bool:
  match m:
    case 0n:
      return True
    case 1n + k:
      here = bisimD(childAt(a, k), childAt(b, k), d)
      return and2(here, actionsEq(a, b, k, d))

def arity(s: Shape) -> Nat:
  match s:
    case @N{code, kids}:
      return List/length<Shape>(kids)

def futureEqD(a: Shape, b: Shape, d: Nat) -> Bool:
  return bisimD(a, b, d)

# structural equality of the headCode observation tree (the finite in-range
# observation quotient; efficient, exact, and equal to FutureEq except under
# the rare out-of-range self-loop coarsening â” measured separately).
def shapeEq(a: Shape, b: Shape) -> Bool:
  match a:
    case @N{ca, ka}:
      match b:
        case @N{cb, kb}:
          if Nat/eql(ca, cb):
            return kidsEq(ka, kb)
          else:
            return False
def kidsEq(a: Shape[], b: Shape[]) -> Bool:
  match a:
    case []:
      match b:
        case []:
          return True
        case y <> ys:
          return False
    case x <> xs:
      match b:
        case []:
          return False
        case y <> ys:
          return and2(shapeEq(x, y), kidsEq(xs, ys))

def Nat/eql(a: Nat, b: Nat) -> Bool:
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
          return Nat/eql(p, q)
def and2(a: Bool, b: Bool) -> Bool:
  if a:
    return b
  else:
    return False
def and3(a: Bool, b: Bool, c: Bool) -> Bool:
  return and2(a, and2(b, c))

# --------- the census: partition a list of shapes by FutureEq ---------
def List/append<A>(xs: A[], y: A) -> A[]:
  match xs:
    case []:
      return y <> []
    case x <> rest:
      return x <> List/append<A>(rest, y)

# index of first representative FutureEq to s; = length(reps) if none
def findClass(reps: Shape[], s: Shape, d: Nat, idx: Nat) -> Nat:
  match reps:
    case []:
      return idx
    case r <> rest:
      if bisimD(r, s, d):
        return idx
      else:
        return findClass(rest, s, d, 1n + idx)

# fold the shapes into a growing list of class representatives
def buildReps(shapes: Shape[], reps: Shape[], d: Nat) -> Shape[]:
  match shapes:
    case []:
      return reps
    case s <> rest:
      c = findClass(reps, s, d, 0n)
      if Nat/eql(c, List/length<Shape>(reps)):
        return buildReps(rest, List/append<Shape>(reps, s), d)
      else:
        return buildReps(rest, reps, d)

# per-shape class id (the census assignment)
def classIds(shapes: Shape[], reps: Shape[], d: Nat) -> Nat[]:
  match shapes:
    case []:
      return []
    case s <> rest:
      return findClass(reps, s, d, 0n) <> classIds(rest, reps, d)

def numClasses(shapes: Shape[], d: Nat) -> Nat:
  return List/length<Shape>(buildReps(shapes, [], d))

# --------- validation / demo ---------
def leaf5() -> Shape:
  @N{5n, []}
def self5() -> Shape:
  @N{5n, (@N{5n, []}) <> []}
def mixed5() -> Shape:
  @N{5n, (@N{2n, []}) <> []}
# two DIFFERENTLY-BUILT shapes the quotient must identify, plus distinct ones
def sampleCorpus() -> Shape[]:
  leaf5() <> (self5() <> (mixed5() <> (leaf5() <> (mixed5() <> []))))

def main() -> Nat[]:
  # sample = [leaf5, self5, mixed5, leaf5, mixed5]
  # FutureEq classes: {leaf5,self5,leaf5} and {mixed5,mixed5} => 2 classes.
  # class ids should be [0,0,1,0,1]
  reps = buildReps(sampleCorpus(), [], 16n)
  (numClasses(sampleCorpus(), 16n)) <> classIds(sampleCorpus(), reps, 16n)

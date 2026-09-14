# Reaction networks (the SBML / PEtab shape), fed to the calculus unchanged:
# AdiBija (a reaction history is a derivation; every readout is the unique
# fold of a receiver), Krama (independent reactions commute by a
# certificate; dependent ones keep their order as data), and erasure =
# descent (a model reduction is admitted iff the requested semantics factors
# through it; the substrate refuses the rest).
#
# THE FINITE PRESENTATION.  Species levels are a record; reactions are a
# finite type with a generator action `fire` (a reaction with an absent
# substrate leaves the state unchanged); a history is a derivation over
# `fire`.  Four species — A, B, C and an enzyme E — and three reactions:
# r1: A → B, r2: B → C, r3: A → C catalysed by E (fires only if E ≥ 1).
# The network is a stand-in; the theorems are about the shape.
#
#   §1  species, reactions, fire, Step, Derivation
#   §2  receiver, fold, uniqueness (the same shape as Perturbation.bend)
#   §3  readouts as folds: event count, flux of a chosen reaction, the
#       endpoint, the word — and CONSERVATION as a receiver: mass = A+B+C
#       is preserved by every reaction, so the mass-conservation certificate
#       of a whole history is the fold of the per-step certificates, and by
#       uniqueness the only reading compatible with them
#   §4  Krama: r1 and r3 act on disjoint resources? no — both consume A;
#       r2 and r3 do commute (B→C and A→C touch different substrates:
#       certificate by refl on every state); r1 then r2 vs r2 then r1 from
#       A=1, B=0 differ (⊥): the order is data exactly there
#   §5  reduction = erasure: forgetting the enzyme LEVEL but keeping its
#       PRESENCE (E ≥ 1) is a quotient through which `fire` and every mass
#       readout descend (proved); forgetting the enzyme entirely is refused
#       — r3's effect depends on E's presence — Reaction_mustfail.bend
#   §6  PEtab shape: a condition is an initial state, an experiment is a
#       word of reactions, a measurement is a receiver; main runs one.
import Prelude

# ---------------------------------------------------------------------------
# §1  The finite presentation.
# ---------------------------------------------------------------------------
type St:
  case @st:
    a: Nat
    b: Nat
    c: Nat
    e: Nat
def aOf(s: St) -> Nat:
  match s: case @st{a, b, c, e}: a
def bOf(s: St) -> Nat:
  match s: case @st{a, b, c, e}: b
def cOf(s: St) -> Nat:
  match s: case @st{a, b, c, e}: c
def eOf(s: St) -> Nat:
  match s: case @st{a, b, c, e}: e

type Rxn:
  case @r1:
  case @r2:
  case @r3:

# the generator action: a reaction fires if its substrates are present
def fire(s: St, r: Rxn) -> St:
  match s:
    case @st{a, b, c, e}:
      match r:
        case @r1{}:
          match a:
            case 0n: @st{0n, b, c, e}
            case 1n + p: @st{p, 1n + b, c, e}
        case @r2{}:
          match b:
            case 0n: @st{a, 0n, c, e}
            case 1n + p: @st{a, p, 1n + c, e}
        case @r3{}:
          match e:
            case 0n: @st{a, b, c, 0n}
            case 1n + q:
              match a:
                case 0n: @st{0n, b, c, 1n + q}
                case 1n + p: @st{p, b, 1n + c, 1n + q}

type Step(x: St, y: St):
  case @act:
    r: Rxn
    ey: St{y == fire(x, r)}
type Derivation(x: St, z: St):
  case @done:
    e: St{z == x}
  case @then:
    y: St
    s: Step(x, y)
    d: Derivation(y, z)
def stepRxn(x: St, y: St, s: Step(x, y)) -> Rxn:
  match s: case @act{r, ey}: r

# ---------------------------------------------------------------------------
# §2  Receiver, fold, uniqueness.
# ---------------------------------------------------------------------------
def foldM(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c), a: St, z: St, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))
def fold_unique(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c),
                g: all a: St. all z: St. Derivation(a, z) -> M(a, z),
                g_done: all t: St. Path(M(t, t), g(t, t, @done{{==}}), e(t)),
                g_step: all a: St. all y: St. all z: St. all s: Step(a, y). all d: Derivation(y, z). Path(M(a, z), g(a, z, @then{y, s, d}), k(a, y, z, s, g(y, z, d))),
                a: St, z: St, d: Derivation(a, z)) -> Path(M(a, z), g(a, z, d), foldM(M, e, k, a, z, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: g_done(a)
    case @then{y, s, d2}:
      compPath(M(a, z), g(a, z, @then{y, s, d2}), k(a, y, z, s, g(y, z, d2)), k(a, y, z, s, foldM(M, e, k, y, z, d2)),
        g_step(a, y, z, s, d2),
        <i> k(a, y, z, s, fold_unique(M, e, k, g, g_done, g_step, y, z, d2) @ i))

# ---------------------------------------------------------------------------
# §3  Readouts as folds, and conservation as a receiver.
# ---------------------------------------------------------------------------
def natM(a: St, b: St) -> Set:
  Nat
def events(a: St, z: St, d: Derivation(a, z)) -> Nat:
  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)
def sameRxn(r: Rxn, r2: Rxn) -> Bool:
  match r:
    case @r1{}:
      match r2:
        case @r1{}: True
        case @r2{}: False
        case @r3{}: False
    case @r2{}:
      match r2:
        case @r1{}: False
        case @r2{}: True
        case @r3{}: False
    case @r3{}:
      match r2:
        case @r1{}: False
        case @r2{}: False
        case @r3{}: True
def tick(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
# the flux of one reaction: how many times it fired
def flux(r: Rxn, a: St, z: St, d: Derivation(a, z)) -> Nat:
  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. tick(sameRxn(r, stepRxn(a2, b, s)), n), a, z, d)
def endM(a: St, b: St) -> Set:
  St
def endpoint(a: St, z: St, d: Derivation(a, z)) -> St:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def endpoint_is_endpoint(a: St, z: St, d: Derivation(a, z)) -> Path(St, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)
def wordM(a: St, b: St) -> Set:
  Rxn[]
def word(a: St, z: St, d: Derivation(a, z)) -> Rxn[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepRxn(a2, b, s) <> w, a, z, d)

# CONSERVATION.  mass = A + B + C.  Every reaction preserves it: the
# per-step certificate, by cases.
def mass(s: St) -> Nat:
  add(aOf(s), add(bOf(s), cOf(s)))
def fire_mass(s: St, r: Rxn) -> Path(Nat, mass(fire(s, r)), mass(s)):
  match s:
    case @st{a, b, c, e}:
      match r:
        case @r1{}:
          match a:
            case 0n: <_> add(0n, add(b, c))
            case 1n + p: plusSuc(p, add(b, c))
        case @r2{}:
          match b:
            case 0n: <_> add(a, add(0n, c))
            case 1n + p: <i> add(a, plusSuc(p, c) @ i)
        case @r3{}:
          match e:
            case 0n: <_> add(a, add(b, c))
            case 1n + q:
              match a:
                case 0n: <_> add(0n, add(b, c))
                case 1n + p:
                  compPath(Nat, add(p, add(b, 1n + c)), add(p, 1n + add(b, c)), 1n + add(p, add(b, c)),
                    <i> add(p, plusSuc(b, c) @ i), plusSuc(p, add(b, c)))
# the receiver whose motion from a to b is "mass(b) = mass(a)"
def massM(a: St, b: St) -> Set:
  Path(Nat, mass(b), mass(a))
def massEps(t: St) -> massM(t, t):
  <_> mass(t)
def massCons(a: St, b: St, c: St, s: Step(a, b), m: massM(b, c)) -> massM(a, c):
  match s:
    case @act{r, ey}:
      match ey: case {==}:
        compPath(Nat, mass(c), mass(fire(a, r)), mass(a), m, fire_mass(a, r))
def conserved(a: St, z: St, d: Derivation(a, z)) -> Path(Nat, mass(z), mass(a)):
  foldM(massM, massEps, massCons, a, z, d)
# and, by uniqueness, any function with the two computation rules IS this fold
def conserved_is_unique(g: all a: St. all z: St. Derivation(a, z) -> Path(Nat, mass(z), mass(a)),
                        g_done: all t: St. Path(massM(t, t), g(t, t, @done{{==}}), massEps(t)),
                        g_step: all a: St. all y: St. all z: St. all s: Step(a, y). all d: Derivation(y, z). Path(massM(a, z), g(a, z, @then{y, s, d}), massCons(a, y, z, s, g(y, z, d))),
                        a: St, z: St, d: Derivation(a, z)) -> Path(massM(a, z), g(a, z, d), conserved(a, z, d)):
  fold_unique(massM, massEps, massCons, g, g_done, g_step, a, z, d)

# ---------------------------------------------------------------------------
# §4  Krama: commutation kept, its failure retained.
# ---------------------------------------------------------------------------
# r2 (B → C) and r3 (A → C by E) touch different substrates: they commute on
# every state, by cases — the certificate that their serialisation is an artefact
def r2_r3_commute(s: St) -> Path(St, fire(fire(s, @r2), @r3), fire(fire(s, @r3), @r2)):
  match s:
    case @st{a, b, c, e}:
      match b:
        case 0n:
          match e:
            case 0n: <_> @st{a, 0n, c, 0n}
            case 1n + q:
              match a:
                case 0n: <_> @st{0n, 0n, c, 1n + q}
                case 1n + p: <_> @st{p, 0n, 1n + c, 1n + q}
        case 1n + pb:
          match e:
            case 0n: <_> @st{a, pb, 1n + c, 0n}
            case 1n + q:
              match a:
                case 0n: <_> @st{0n, pb, 1n + c, 1n + q}
                case 1n + p: <_> @st{p, pb, 1n + (1n + c), 1n + q}
# r1 (A → B) then r2 (B → C) vs r2 then r1, from A=1, B=0: the order is data
def start() -> St:
  @st{1n, 0n, 0n, 1n}
def r1_r2_dont_commute(p: Path(St, fire(fire(start(), @r1), @r2), fire(fire(start(), @r2), @r1))) -> Empty:
  natEncode(1n, 0n, <i> cOf(p @ i))

# ---------------------------------------------------------------------------
# §5  Model reduction = erasure by descent.
# ---------------------------------------------------------------------------
import SetQuotient
def present(n: Nat) -> Bool:
  match n:
    case 0n: False
    case 1n + p: True
# the reduction: keep A, B, C exactly and the enzyme's PRESENCE only
def AgreeR(x: St, y: St) -> Set:
  any pa: Path(Nat, aOf(x), aOf(y)). any pb: Path(Nat, bOf(x), bOf(y)). any pc: Path(Nat, cOf(x), cOf(y)). Path(Bool, present(eOf(x)), present(eOf(y)))
def AgreeRR() -> St -> St -> Set:
  lambda x. lambda y. AgreeR(x, y)
def Reduced() -> Set:
  Quotient(St, AgreeRR())
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)
# mass descends: it never reads E
def mass_descends(x: St, y: St, r: AgreeR(x, y)) -> Path(Nat, mass(x), mass(y)):
  match r:
    case (pa, pb, pc, pe): <i> add(pa @ i, add(pb @ i, pc @ i))
def mass_reduced(m: Reduced) -> Nat:
  quotRec(St, AgreeRR(), Nat, setNat(), mass, mass_descends, m)
def mass_factors(s: St) -> Path(Nat, mass_reduced(@cl{s}), mass(s)):
  <_> mass(s)
# the quotient's generator path, as a typed helper (a branch of a Nat match
# is elaborated in inference mode, and a bare path constructor is not
# inferable; a Ref application is)
def eqR(u: St, v: St, w: AgreeR(u, v)) -> Path(Reduced, @cl{u}, @cl{v}):
  @eq{u, v, w}
# the generator descends: every reaction's effect reads E only through its presence
def fire_descends(x: St, y: St, r: AgreeR(x, y), rx: Rxn) -> Path(Reduced, @cl{fire(x, rx)}, @cl{fire(y, rx)}):
  match x:
    case @st{a, b, c, e}:
      match y:
        case @st{a2, b2, c2, e2}:
          match r:
            case (pa, r2):
              match r2:
                case (pb, r3):
                  match r3:
                    case (pc, pe):
                      match rx:
                      case @r1{}:
                        match a:
                          case 0n:
                            match a2:
                              case 0n: eqR(@st{0n, b, c, e}, @st{0n, b2, c2, e2}, (<_> 0n, (pb, (pc, pe))))
                              case 1n + p2: absurd natEncode(0n, 1n + p2, pa)
                          case 1n + p:
                            match a2:
                              case 0n: absurd natEncode(1n + p, 0n, pa)
                              case 1n + p2: eqR(@st{p, 1n + b, c, e}, @st{p2, 1n + b2, c2, e2}, (<i> pred(pa @ i), (<i> 1n + (pb @ i), (pc, pe))))
                      case @r2{}:
                        match b:
                          case 0n:
                            match b2:
                              case 0n: eqR(@st{a, 0n, c, e}, @st{a2, 0n, c2, e2}, (pa, (<_> 0n, (pc, pe))))
                              case 1n + q2: absurd natEncode(0n, 1n + q2, pb)
                          case 1n + q:
                            match b2:
                              case 0n: absurd natEncode(1n + q, 0n, pb)
                              case 1n + q2: eqR(@st{a, q, 1n + c, e}, @st{a2, q2, 1n + c2, e2}, (pa, (<i> pred(pb @ i), (<i> 1n + (pc @ i), pe))))
                      case @r3{}:
                        match e:
                          case 0n:
                            match e2:
                              case 0n: eqR(@st{a, b, c, 0n}, @st{a2, b2, c2, 0n}, (pa, (pb, (pc, <_> False))))
                              case 1n + f2: absurd boolEncode(False, True, pe)
                          case 1n + f:
                            match e2:
                              case 0n: absurd boolEncode(True, False, pe)
                              case 1n + f2:
                                match a:
                                  case 0n:
                                    match a2:
                                      case 0n: eqR(@st{0n, b, c, 1n + f}, @st{0n, b2, c2, 1n + f2}, (<_> 0n, (pb, (pc, <_> True))))
                                      case 1n + p2: absurd natEncode(0n, 1n + p2, pa)
                                  case 1n + p:
                                    match a2:
                                      case 0n: absurd natEncode(1n + p, 0n, pa)
                                      case 1n + p2: eqR(@st{p, b, 1n + c, 1n + f}, @st{p2, b2, 1n + c2, 1n + f2}, (<i> pred(pa @ i), (pb, (<i> 1n + (pc @ i), <_> True))))
def bit(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n
def boolEncode(x: Bool, y: Bool, p: Path(Bool, x, y)) -> NatCode(bit(x), bit(y)):
  natEncode(bit(x), bit(y), <i> bit(p @ i))
def fire_reduced(m: Reduced, rx: Rxn) -> Reduced:
  quotRec(St, AgreeRR(), Reduced, squash(St, AgreeRR()), lambda s. @cl{fire(s, rx)}, lambda x. lambda y. lambda r. fire_descends(x, y, r, rx), m)
# (forgetting E entirely is refused: Reaction_mustfail.bend)

# ---------------------------------------------------------------------------
# §6  The PEtab shape: condition, experiment, measurement.
# ---------------------------------------------------------------------------
def runR(s: St, w: Rxn[]) -> St:
  match w:
    case []: s
    case r <> rest: runR(fire(s, r), rest)
def condition() -> St:
  @st{3n, 0n, 0n, 1n}
def experiment() -> Rxn[]:
  [@r1, @r3, @r2, @r1]
def measured_c() -> Path(Nat, cOf(runR(condition(), experiment())), 2n):
  <_> 2n
def mass_measured() -> Path(Nat, mass(runR(condition(), experiment())), mass(condition())):
  <_> 3n

def main() -> Nat:
  cOf(runR(condition(), experiment()))

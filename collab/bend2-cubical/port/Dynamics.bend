# Molecular dynamics and structure, as the lawful step with a typed residue
# (Fibre.LawfulStep) and the fibre law (fibrelaw.bend), fed a finite
# presentation unchanged.
#
# THE FINITE PRESENTATION.  A phase point is a position and a momentum sign;
# a step is a map on phase points.  Two steps are declared: `kick`, the
# momentum reversal (time-reversal symmetry, an involution), and `dissipate`,
# a thermostat that forgets the momentum sign.  A trajectory is a word of
# steps; an observable is a fold over it.  The panel is a stand-in; the
# theorems are about the shape.
#
#   §1  the fibre law, generic (fibrelaw.bend verbatim): every step
#       factors losslessly as its visible successor plus its fibre,
#       A ≃ Σ a'. fiber step a', as a coherent Equiv and as a path in Set
#       along which transport computes (present / retrieve by coe).
#   §2  the two steps.  `kick` is invertible: its residue is contractible
#       at every point (isoToIsEquiv).  `dissipate` is not, in BOTH shapes
#       the corpus's LawfulStep distinguishes: over (q, up) the residue has
#       two distinct points (crowded), over (q, down) it is empty.  The
#       receipt of a dissipative step is the residue, kept, not lost.
#   §3  trajectories and observables: a word of steps, evolved; two
#       observables (position integral, number of reversals) are folds
#       over ONE trajectory — the shared-line regime.  Two trajectories
#       with the same endpoint and different position integrals: the
#       endpoint is a projection, the path integral is not.
#   §4  structure: a conformer is a fold with a state; the top-1
#       structure is the projection forgetting the state; the ensemble
#       compatible with the sequence IS the fibre, and it is not a point.
import Prelude

# ---------------------------------------------------------------------------
# §1  The fibre law, generic (fibrelaw.bend).
# ---------------------------------------------------------------------------
def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)
def tot(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), a, <_> f(a))
def untot(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, a, q):
      a
def tot_sec(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), tot(A, B, f, untot(A, B, f, w)), w):
  match w:
    case (b, a, q):
      <i> (q @ i, a, <j> q @ iand(i, j))
def tot_ret(A: Set, B: Set, f: A -> B, a: A) -> Path(A, untot(A, B, f, tot(A, B, f, a)), a):
  <_> a
def totalEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Total(A, B, f)):
  isoToEquiv(A, Total(A, B, f), tot(A, B, f), untot(A, B, f), tot_sec(A, B, f), tot_ret(A, B, f))
def invC(A: Set, B: Set, f: A -> B, y: B, c: isContr(fiber(A, B, f, y))) -> A:
  match c:
    case (cen, _):
      match cen:
        case (x, _):
          x
def secC(A: Set, B: Set, f: A -> B, y: B, c: isContr(fiber(A, B, f, y))) -> Path(B, f(invC(A, B, f, y, c)), y):
  match c:
    case (cen, _):
      match cen:
        case (x, p):
          p
def retC(A: Set, B: Set, f: A -> B, x: A, c: isContr(fiber(A, B, f, f(x)))) -> Path(A, invC(A, B, f, f(x), c), x):
  match c:
    case (cen, contr):
      <i> (match contr((x, <_> f(x))) @ i: case (z, _): z)
def uaE(A: Set, B: Set, e: Equiv(A, B)) -> Path(Set, A, B):
  match e:
    case (f, h):
      ua(A, B, f, lambda y. invC(A, B, f, y, h(y)), lambda x. retC(A, B, f, x, h(f(x))), lambda y. secC(A, B, f, y, h(y)))
def losslessPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, Total(A, B, f)):
  uaE(A, Total(A, B, f), totalEquiv(A, B, f))
def present(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  coe(lambda i. losslessPath(A, B, f) @ i, i0, i1, a)
def retrieve(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  coe(lambda i. losslessPath(A, B, f) @ i, i1, i0, w)
def present_is_tot(A: Set, B: Set, f: A -> B, a: A) -> Path(Total(A, B, f), present(A, B, f, a), tot(A, B, f, a)):
  <_> tot(A, B, f, a)
def retrieve_present(A: Set, B: Set, f: A -> B, a: A) -> Path(A, retrieve(A, B, f, present(A, B, f, a)), a):
  <_> a

# ---------------------------------------------------------------------------
# §2  The two steps and their residues.
# ---------------------------------------------------------------------------
type Dir:
  case @up:
  case @down:
type Pt:
  case @pt:
    q: Nat
    p: Dir
def qOf(x: Pt) -> Nat:
  match x: case @pt{q, p}: q
def dirNat(d: Dir) -> Nat:
  match d:
    case @up{}: 1n
    case @down{}: 0n
def pOf(x: Pt) -> Nat:
  match x: case @pt{q, p}: dirNat(p)

def flip(d: Dir) -> Dir:
  match d:
    case @up{}: @down
    case @down{}: @up
def flip_flip(d: Dir) -> Path(Dir, flip(flip(d)), d):
  match d:
    case @up{}: <_> @up
    case @down{}: <_> @down

# the reversible step: momentum reversal
def kick(x: Pt) -> Pt:
  match x: case @pt{q, p}: @pt{q, flip(p)}
def kick_kick(x: Pt) -> Path(Pt, kick(kick(x)), x):
  match x:
    case @pt{q, p}: <i> @pt{q, flip_flip(p) @ i}
def kick_isEquiv() -> isEquiv(Pt, Pt, kick):
  isoToIsEquiv(Pt, Pt, kick, kick, kick_kick, kick_kick)
# its residue is contractible at every point: the step is invertible, and
# the receipt of a kick carries nothing
def kick_residue_contractible(y: Pt) -> isContr(fiber(Pt, Pt, kick, y)):
  kick_isEquiv()(y)

# the dissipative step: the thermostat forgets the momentum sign
def dissipate(x: Pt) -> Pt:
  match x: case @pt{q, p}: @pt{q, @up}
# the fibre law holds for it all the same: the source is the sum of the
# successor and the residue, and transport along that equality computes
def dissipate_lossless() -> Path(Set, Pt, Total(Pt, Pt, dissipate)):
  losslessPath(Pt, Pt, dissipate)
def dissipate_receipt(x: Pt) -> Path(Pt, retrieve(Pt, Pt, dissipate, present(Pt, Pt, dissipate, x)), x):
  retrieve_present(Pt, Pt, dissipate, x)
# …but its residue is NOT contractible: crowded over (q, up)…
def res_up_from_up(q: Nat) -> fiber(Pt, Pt, dissipate, @pt{q, @up}):
  (@pt{q, @up}, <_> @pt{q, @up})
def res_up_from_down(q: Nat) -> fiber(Pt, Pt, dissipate, @pt{q, @up}):
  (@pt{q, @down}, <_> @pt{q, @up})
def residue_points_differ(q: Nat, e: Path(fiber(Pt, Pt, dissipate, @pt{q, @up}), res_up_from_up(q), res_up_from_down(q))) -> Empty:
  natEncode(1n, 0n, <i> pOf(fst(Pt, lambda x. Path(Pt, dissipate(x), @pt{q, @up}), e @ i)))
def dissipate_residue_crowded(q: Nat, c: isContr(fiber(Pt, Pt, dissipate, @pt{q, @up}))) -> Empty:
  match c:
    case (centre, h):
      residue_points_differ(q, compPath(fiber(Pt, Pt, dissipate, @pt{q, @up}), res_up_from_up(q), centre, res_up_from_down(q), <i> h(res_up_from_up(q)) @ inot(i), h(res_up_from_down(q))))
# …and empty over (q, down): nothing dissipates to a downward momentum
def dissipate_residue_empty(q: Nat, w: fiber(Pt, Pt, dissipate, @pt{q, @down})) -> Empty:
  match w:
    case (x, e):
      match x:
        case @pt{q2, p2}: natEncode(1n, 0n, <i> pOf(e @ i))
# so the thermostat is not an equivalence: the two shapes of non-invertibility
def dissipate_not_equiv(h: isEquiv(Pt, Pt, dissipate)) -> Empty:
  dissipate_residue_crowded(0n, h(@pt{0n, @up}))

# ---------------------------------------------------------------------------
# §3  Trajectories and observables: one trajectory, several folds.
# ---------------------------------------------------------------------------
type Move:
  case @drift:
  case @kick:
  case @thermo:
def drift(x: Pt) -> Pt:
  match x:
    case @pt{q, p}:
      match p:
        case @up{}: @pt{1n + q, @up}
        case @down{}:
          match q:
            case 0n: @pt{0n, @down}
            case 1n + r: @pt{r, @down}
def move(x: Pt, m: Move) -> Pt:
  match m:
    case @drift{}: drift(x)
    case @kick{}: kick(x)
    case @thermo{}: dissipate(x)
def evolve(x: Pt, w: Move[]) -> Pt:
  match w:
    case []: x
    case m <> rest: evolve(move(x, m), rest)
# observable 1: the position integral along the trajectory (a fold over the word)
def positionIntegral(x: Pt, w: Move[]) -> Nat:
  match w:
    case []: qOf(x)
    case m <> rest: add(qOf(x), positionIntegral(move(x, m), rest))
# observable 2: the number of reversals (a fold over the same word)
def reversals(w: Move[]) -> Nat:
  match w:
    case []: 0n
    case m <> rest:
      match m:
        case @kick{}: 1n + reversals(rest)
        case @drift{}: reversals(rest)
        case @thermo{}: reversals(rest)
# two trajectories, same endpoint, different integrals: the endpoint is a
# projection of the trajectory and the integral is not
def origin() -> Pt:
  @pt{0n, @up}
def traj1() -> Move[]:
  [@drift, @drift, @kick, @drift, @drift, @kick]
def traj2() -> Move[]:
  [@kick, @kick]
def same_endpoint() -> Path(Pt, evolve(origin(), traj1()), evolve(origin(), traj2())):
  <_> @pt{0n, @up}
def integrals_differ(e: Path(Nat, positionIntegral(origin(), traj1()), positionIntegral(origin(), traj2()))) -> Empty:
  natEncode(6n, 0n, e)
def same_reversals() -> Path(Nat, reversals(traj1()), reversals(traj2())):
  <_> 2n

# ---------------------------------------------------------------------------
# §4  Structure: the top-1 structure is the projection; the ensemble is the
#     fibre, and it is not a point.
# ---------------------------------------------------------------------------
type Fold:
  case @alpha:
  case @beta:
type Conformer:
  case @conf:
    fold: Fold
    isOpen: Bool
def topOne(c: Conformer) -> Fold:
  match c: case @conf{f, o}: f
def bit(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n
def openOf(c: Conformer) -> Nat:
  match c: case @conf{f, o}: bit(o)
# the sequence's realisation space, losslessly: conformers ≃ Σ fold. ensemble(fold)
def ensemble_is_fibre() -> Equiv(Conformer, Total(Conformer, Fold, topOne)):
  totalEquiv(Conformer, Fold, topOne)
def alpha_open() -> fiber(Conformer, Fold, topOne, @alpha):
  (@conf{@alpha, True}, <_> @alpha)
def alpha_closed() -> fiber(Conformer, Fold, topOne, @alpha):
  (@conf{@alpha, False}, <_> @alpha)
def ensemble_not_a_point(e: Path(fiber(Conformer, Fold, topOne, @alpha), alpha_open(), alpha_closed())) -> Empty:
  natEncode(1n, 0n, <i> openOf(fst(Conformer, lambda c. Path(Fold, topOne(c), @alpha), e @ i)))

def main() -> Nat:
  positionIntegral(origin(), traj1())

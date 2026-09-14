# Lineage and development, as the interactive machine (Prasna/Samvada) and
# the organism's fold (Upayoga), fed a finite presentation unchanged.
#
# THE FINITE PRESENTATION.  A body is its generation and its kind on a fate
# ladder (stem → progenitor → neuron).  At every state the machine asks one
# question — divide or differentiate — and the heritable program answers.
# The answer stream is the lineage record; the history (states, receipts,
# answers) is the developmental object.  The panel of kinds is a stand-in;
# the theorems are about the shape.
#
#   §1  the interaction at depth n (interaction.bend, verbatim): Answers,
#       IExec, forgetStates / replay, run-is-answers as an Equiv.  A lineage
#       record IS its history: nothing is lost by recording only the fates,
#       and the history is rebuilt from them with receipts refl.
#   §2  the generator: differentiation is digested only by a body that has
#       divided (gen ≥ 1); offered to a body that has not, it passes through.
#       UPAYOGA: the same nourishment in a different order yields a
#       different body — [divide, differentiate] and [differentiate, divide]
#       from the stem are separated, by refl on each side and ⊥ between.
#   §3  the measurement: an assay reads the terminal (gen, kind).  Two
#       distinct fate streams have the same terminal reading; so the fibre
#       of the terminal projection over that reading has two points and is
#       NOT contractible — the unresolved developmental history is exactly
#       that fibre, not noise and not a pseudotime.
#   §4  determinism is silence: with the question closed (a fixed program)
#       the answer space is a point at every depth; with it open, not.
import Prelude

# ---------------------------------------------------------------------------
# §1  The interaction at depth n (interaction.bend).
# ---------------------------------------------------------------------------
def Answers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Set:
  match n:
    case 0n:
      Unit
    case 1n + p:
      any a: Q(x). Answers(X, Q, d, p, d(x, a))
def IExec(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Set:
  match n:
    case 0n:
      Unit
    case 1n + p:
      any now: X. any here: Path(X, now, x). any a: Q(x). IExec(X, Q, d, p, d(x, a))
def forgetStates(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, e: IExec(X, Q, d, n, x)) -> Answers(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match e:
        case (now, here, a, rest):
          (a, forgetStates(X, Q, d, p, d(x, a), rest))
def replay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, s: Answers(X, Q, d, n, x)) -> IExec(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match s:
        case (a, more):
          (x, <_> x, a, replay(X, Q, d, p, d(x, a), more))
def forgetReplayS(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, p: Nat, x: X, s: Answers(X, Q, d, 1n + p, x)) -> Path(Answers(X, Q, d, 1n + p, x), forgetStates(X, Q, d, 1n + p, x, replay(X, Q, d, 1n + p, x, s)), s):
  match s:
    case (a, more):
      <i> (a, forgetReplay(X, Q, d, p, d(x, a), more) @ i)
def forgetReplay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, s: Answers(X, Q, d, n, x)) -> Path(Answers(X, Q, d, n, x), forgetStates(X, Q, d, n, x, replay(X, Q, d, n, x, s)), s):
  match n:
    case 0n:
      match s:
        case ():
          <_> ()
    case 1n + p:
      forgetReplayS(X, Q, d, p, x, s)
def replayForgetS(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, p: Nat, x: X, e: IExec(X, Q, d, 1n + p, x)) -> Path(IExec(X, Q, d, 1n + p, x), replay(X, Q, d, 1n + p, x, forgetStates(X, Q, d, 1n + p, x, e)), e):
  match e:
    case (now, here, a, rest):
      <i> (here @ inot(i), <j> here @ ior(inot(i), j), a, replayForget(X, Q, d, p, d(x, a), rest) @ i)
def replayForget(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, e: IExec(X, Q, d, n, x)) -> Path(IExec(X, Q, d, n, x), replay(X, Q, d, n, x, forgetStates(X, Q, d, n, x, e)), e):
  match n:
    case 0n:
      match e:
        case ():
          <_> ()
    case 1n + p:
      replayForgetS(X, Q, d, p, x, e)
# THE THEOREM (run-is-answers): the history IS its answer stream, at every depth
def runIsAnswers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Equiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x)):
  isoToEquiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x),
             lambda e. forgetStates(X, Q, d, n, x, e), lambda s. replay(X, Q, d, n, x, s),
             lambda s. forgetReplay(X, Q, d, n, x, s), lambda e. replayForget(X, Q, d, n, x, e))

# ---------------------------------------------------------------------------
# §2  The generator: the body and what it can digest (Upayoga).
# ---------------------------------------------------------------------------
type Kind:
  case @stem:
  case @progenitor:
  case @neuron:
type Body:
  case @body:
    gen: Nat
    kind: Kind
def genOf(b: Body) -> Nat:
  match b: case @body{g, k}: g
def kindOf(b: Body) -> Kind:
  match b: case @body{g, k}: k
def kindNat(k: Kind) -> Nat:
  match k:
    case @stem{}: 0n
    case @progenitor{}: 1n
    case @neuron{}: 2n

# the question at every state: divide or differentiate
type Fate:
  case @divide:
  case @differentiate:
def FateQ(b: Body) -> Set:
  Fate
def fateNat(f: Fate) -> Nat:
  match f:
    case @divide{}: 0n
    case @differentiate{}: 1n

def nextKind(k: Kind) -> Kind:
  match k:
    case @stem{}: @progenitor
    case @progenitor{}: @neuron
    case @neuron{}: @neuron
# a division is always digested; a differentiation only by a body that has
# divided — offered earlier it passes through undigested (the body decides)
def grow(b: Body, f: Fate) -> Body:
  match b:
    case @body{g, k}:
      match f:
        case @divide{}: @body{1n + g, k}
        case @differentiate{}:
          match g:
            case 0n: @body{0n, k}
            case 1n + p: @body{1n + p, nextKind(k)}

# the lineage record at depth n from a body, and the history
def Lineage(n: Nat, b: Body) -> Set:
  Answers(Body, FateQ, grow, n, b)
def History(n: Nat, b: Body) -> Set:
  IExec(Body, FateQ, grow, n, b)
def lineage_is_history(n: Nat, b: Body) -> Equiv(History(n, b), Lineage(n, b)):
  runIsAnswers(Body, FateQ, grow, n, b)

# the terminal body of a lineage record
def terminal(n: Nat, b: Body, s: Lineage(n, b)) -> Body:
  match n:
    case 0n: b
    case 1n + p:
      match s:
        case (f, more): terminal(p, grow(b, f), more)

def stem0() -> Body:
  @body{0n, @stem}
# UPAYOGA: the same two encounters, in the two orders
def divide_then_diff() -> Lineage(2n, stem0()):
  (@divide, (@differentiate, ()))
def diff_then_divide() -> Lineage(2n, stem0()):
  (@differentiate, (@divide, ()))
def body_divide_then_diff() -> Path(Body, terminal(2n, stem0(), divide_then_diff()), @body{1n, @progenitor}):
  <_> @body{1n, @progenitor}
def body_diff_then_divide() -> Path(Body, terminal(2n, stem0(), diff_then_divide()), @body{1n, @stem}):
  <_> @body{1n, @stem}
# history is in the body: the orders are separated
def order_is_in_the_body(p: Path(Body, terminal(2n, stem0(), divide_then_diff()), terminal(2n, stem0(), diff_then_divide()))) -> Empty:
  natEncode(1n, 0n, <i> kindNat(kindOf(p @ i)))

# ---------------------------------------------------------------------------
# §3  The measurement, and the fibre that is the unresolved history.
# ---------------------------------------------------------------------------
# the assay reads the terminal (gen, kind) — as one Nat: 3·gen + kind
def readout(b: Body) -> Nat:
  add(add(genOf(b), add(genOf(b), genOf(b))), kindNat(kindOf(b)))
def observe(n: Nat, b: Body, s: Lineage(n, b)) -> Nat:
  readout(terminal(n, b, s))

# two lineage records of depth 3 from the stem with the same terminal reading
def l_ddx() -> Lineage(3n, stem0()):
  (@divide, (@divide, (@differentiate, ())))
def l_dxd() -> Lineage(3n, stem0()):
  (@divide, (@differentiate, (@divide, ())))
def same_terminal() -> Path(Nat, observe(3n, stem0(), l_ddx()), observe(3n, stem0(), l_dxd())):
  <_> 7n
# …but distinct as histories: the second fate differs
def secondFate(s: Lineage(3n, stem0())) -> Fate:
  match s:
    case (f1, more):
      match more:
        case (f2, more2): f2
def records_differ(p: Path(Lineage(3n, stem0()), l_ddx(), l_dxd())) -> Empty:
  natEncode(0n, 1n, <i> fateNat(secondFate(p @ i)))

# the fibre of the terminal projection over the observed reading: both live in it
def Unresolved(o: Nat) -> Set:
  fiber(Lineage(3n, stem0()), Nat, lambda s. observe(3n, stem0(), s), o)
def pt_ddx() -> Unresolved(7n):
  (l_ddx(), <_> 7n)
def pt_dxd() -> Unresolved(7n):
  (l_dxd(), <_> 7n)
def unresolved_points_differ(p: Path(Unresolved(7n), pt_ddx(), pt_dxd())) -> Empty:
  records_differ(<i> fst(Lineage(3n, stem0()), lambda s. Path(Nat, observe(3n, stem0(), s), 7n), p @ i))
# so the realisation space of the measured lineage is NOT a point: ancestral
# state reconstruction has a genuine fibre, and it is this one
def unresolved_not_contractible(c: isContr(Unresolved(7n))) -> Empty:
  match c:
    case (centre, h):
      unresolved_points_differ(compPath(Unresolved(7n), pt_ddx(), centre, pt_dxd(), <i> h(pt_ddx()) @ inot(i), h(pt_dxd())))

# ---------------------------------------------------------------------------
# §4  Determinism is silence (interaction.bend §2): a fixed program (the
#     question closed) has exactly one lineage at every depth.
# ---------------------------------------------------------------------------
def UnitQ(b: Body) -> Set:
  Unit
def programmed(b: Body, u: Unit) -> Body:
  grow(b, @divide)
def mute(n: Nat, b: Body) -> Answers(Body, UnitQ, programmed, n, b):
  match n:
    case 0n:
      ()
    case 1n + p:
      ((), mute(p, programmed(b, ())))
def muteUnique(n: Nat, b: Body, s: Answers(Body, UnitQ, programmed, n, b)) -> Path(Answers(Body, UnitQ, programmed, n, b), mute(n, b), s):
  match n:
    case 0n:
      match s:
        case ():
          <_> ()
    case 1n + p:
      match s:
        case (u, more):
          match u:
            case ():
              <i> ((), muteUnique(p, programmed(b, ()), more) @ i)
def programmed_is_deterministic(n: Nat, b: Body) -> isContr(Answers(Body, UnitQ, programmed, n, b)):
  (mute(n, b), lambda s. muteUnique(n, b, s))
# with the fate question open, the lineage space at depth 2 is not a point
def open_is_generative(c: isContr(Lineage(2n, stem0()))) -> Empty:
  match c:
    case (centre, h):
      order_is_in_the_body(<i> terminal(2n, stem0(), compPath(Lineage(2n, stem0()), divide_then_diff(), centre, diff_then_divide(), <j> h(divide_then_diff()) @ inot(j), h(diff_then_divide())) @ i))

def main() -> Nat:
  observe(3n, stem0(), l_dxd())

# EMITTED by scripts/emit-lineage.py — do not edit; edit the tree.
# leaves ['n1', 'n2', 'a1', 'a2', 'n3', 'a3', 'a4']; kinds ['astrocyte', 'neuron']
import Prelude

# §1 the interaction at depth n (interaction.bend / Lineage.bend, verbatim)
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
def runIsAnswers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Equiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x)):
  isoToEquiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x),
             lambda e. forgetStates(X, Q, d, n, x, e), lambda s. replay(X, Q, d, n, x, s),
             lambda s. forgetReplay(X, Q, d, n, x, s), lambda e. replayForget(X, Q, d, n, x, e))

# §2 the kinds, the fates, the body, the generator
type Kind:
  case @undetermined:
  case @astrocyte:
  case @neuron:
def kindNat(k: Kind) -> Nat:
  match k:
    case @undetermined{}: 0n
    case @astrocyte{}: 1n
    case @neuron{}: 2n
type Fate:
  case @divide:
    child: Nat
  case @commit:
    k: Kind
type Body:
  case @body:
    gen: Nat
    kind: Kind
def genOf(b: Body) -> Nat:
  match b: case @body{g, k}: g
def kindOf(b: Body) -> Kind:
  match b: case @body{g, k}: k
def FateQ(b: Body) -> Set:
  Fate
def grow(b: Body, f: Fate) -> Body:
  match b:
    case @body{g, k}:
      match f:
        case @divide{c}: @body{1n + g, k}
        case @commit{k2}: @body{g, k2}
def Lineage(n: Nat, b: Body) -> Set:
  Answers(Body, FateQ, grow, n, b)
def History(n: Nat, b: Body) -> Set:
  IExec(Body, FateQ, grow, n, b)
# the lineage record IS the history (run-is-answers), at every depth
def lineage_is_history(n: Nat, b: Body) -> Equiv(History(n, b), Lineage(n, b)):
  runIsAnswers(Body, FateQ, grow, n, b)
def terminal(n: Nat, b: Body, s: Lineage(n, b)) -> Body:
  match n:
    case 0n: b
    case 1n + p:
      match s:
        case (f, more): terminal(p, grow(b, f), more)
def zygote() -> Body:
  @body{0n, @undetermined}


# §3 one record per leaf: its root-to-leaf history (each division records the
# child taken), and its terminal body by refl
def rec_n1() -> Lineage(4n, zygote()):
  (@divide{0n}, (@divide{0n}, (@divide{0n}, (@commit{@neuron}, ()))))
def term_n1() -> Path(Body, terminal(4n, zygote(), rec_n1()), @body{3n, @neuron}):
  <_> @body{3n, @neuron}
def rec_n2() -> Lineage(4n, zygote()):
  (@divide{0n}, (@divide{0n}, (@divide{1n}, (@commit{@neuron}, ()))))
def term_n2() -> Path(Body, terminal(4n, zygote(), rec_n2()), @body{3n, @neuron}):
  <_> @body{3n, @neuron}
def rec_a1() -> Lineage(4n, zygote()):
  (@divide{0n}, (@divide{1n}, (@divide{0n}, (@commit{@astrocyte}, ()))))
def term_a1() -> Path(Body, terminal(4n, zygote(), rec_a1()), @body{3n, @astrocyte}):
  <_> @body{3n, @astrocyte}
def rec_a2() -> Lineage(4n, zygote()):
  (@divide{0n}, (@divide{1n}, (@divide{1n}, (@commit{@astrocyte}, ()))))
def term_a2() -> Path(Body, terminal(4n, zygote(), rec_a2()), @body{3n, @astrocyte}):
  <_> @body{3n, @astrocyte}
def rec_n3() -> Lineage(3n, zygote()):
  (@divide{1n}, (@divide{0n}, (@commit{@neuron}, ())))
def term_n3() -> Path(Body, terminal(3n, zygote(), rec_n3()), @body{2n, @neuron}):
  <_> @body{2n, @neuron}
def rec_a3() -> Lineage(4n, zygote()):
  (@divide{1n}, (@divide{1n}, (@divide{0n}, (@commit{@astrocyte}, ()))))
def term_a3() -> Path(Body, terminal(4n, zygote(), rec_a3()), @body{3n, @astrocyte}):
  <_> @body{3n, @astrocyte}
def rec_a4() -> Lineage(4n, zygote()):
  (@divide{1n}, (@divide{1n}, (@divide{1n}, (@commit{@astrocyte}, ()))))
def term_a4() -> Path(Body, terminal(4n, zygote(), rec_a4()), @body{3n, @astrocyte}):
  <_> @body{3n, @astrocyte}

# §4 the measurement reads the terminal (gen, kind); the unresolved history is
# the fibre of that reading; where two leaves share a reading it is not a point
def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))
def readout(b: Body) -> Nat:
  add(mul(3n, genOf(b)), kindNat(kindOf(b)))
def observe(n: Nat, s: Lineage(n, zygote())) -> Nat:
  readout(terminal(n, zygote(), s))
def Unresolved(n: Nat, o: Nat) -> Set:
  fiber(Lineage(n, zygote()), Nat, lambda s. observe(n, s), o)
def firstChild(n: Nat, s: Lineage(n, zygote())) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p:
      match s:
        case (f, more):
          match f:
            case @divide{c}: c
            case @commit{k}: 0n
def childAt(d: Nat, n: Nat, b: Body, s: Lineage(n, b)) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p:
      match s:
        case (f, more):
          match d:
            case 0n:
              match f:
                case @divide{c}: c
                case @commit{k}: 0n
            case 1n + q: childAt(q, p, grow(b, f), more)
# n1 and n2: same terminal reading 11, different histories (they part at division 2)
def same_reading_n1_n2() -> Path(Nat, observe(4n, rec_n1()), observe(4n, rec_n2())):
  <_> 11n
def records_differ_n1_n2(p: Path(Lineage(4n, zygote()), rec_n1(), rec_n2())) -> Empty:
  natEncode(0n, 1n, <i> childAt(2n, 4n, zygote(), p @ i))
def pt_n1() -> Unresolved(4n, 11n):
  (rec_n1(), <_> 11n)
def pt_n2() -> Unresolved(4n, 11n):
  (rec_n2(), <_> 11n)
def unresolved_points_differ_n1_n2(p: Path(Unresolved(4n, 11n), pt_n1(), pt_n2())) -> Empty:
  records_differ_n1_n2(<i> fst(Lineage(4n, zygote()), lambda s. Path(Nat, observe(4n, s), 11n), p @ i))
def unresolved_not_contractible_n1_n2(c: isContr(Unresolved(4n, 11n))) -> Empty:
  match c:
    case (centre, h):
      unresolved_points_differ_n1_n2(compPath(Unresolved(4n, 11n), pt_n1(), centre, pt_n2(), <i> h(pt_n1()) @ inot(i), h(pt_n2())))
# a1 and a2: same terminal reading 10, different histories (they part at division 2)
def same_reading_a1_a2() -> Path(Nat, observe(4n, rec_a1()), observe(4n, rec_a2())):
  <_> 10n
def records_differ_a1_a2(p: Path(Lineage(4n, zygote()), rec_a1(), rec_a2())) -> Empty:
  natEncode(0n, 1n, <i> childAt(2n, 4n, zygote(), p @ i))
def pt_a1() -> Unresolved(4n, 10n):
  (rec_a1(), <_> 10n)
def pt_a2() -> Unresolved(4n, 10n):
  (rec_a2(), <_> 10n)
def unresolved_points_differ_a1_a2(p: Path(Unresolved(4n, 10n), pt_a1(), pt_a2())) -> Empty:
  records_differ_a1_a2(<i> fst(Lineage(4n, zygote()), lambda s. Path(Nat, observe(4n, s), 10n), p @ i))
def unresolved_not_contractible_a1_a2(c: isContr(Unresolved(4n, 10n))) -> Empty:
  match c:
    case (centre, h):
      unresolved_points_differ_a1_a2(compPath(Unresolved(4n, 10n), pt_a1(), centre, pt_a2(), <i> h(pt_a1()) @ inot(i), h(pt_a2())))

def main() -> Nat:
  observe(4n, rec_n1())

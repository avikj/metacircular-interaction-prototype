# THE INTERACTIVE MACHINE (Prasna / Prashna / Niyati), carried to Bend and run.
#
# An interaction on X: every state asks a question Q x, the environment
# answers, the step consumes the answer: δ x a.  Histories and answer streams
# are the coinductive records IExec / Answers; Bend2 has no coinduction, so
# they are carried at EVERY FINITE DEPTH n (the ω-limit is exactly
# ProductiveObservabilityBridge: bisimilar = equal at every depth).  On the
# HVM runtime the unfolding is lazy, so any depth is reachable on demand.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)

# isoToIsEquiv (lemIso), as in fibrelaw.bend
def fill0(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> t(x0) @ iand(j, k)), (inot(i), <k> g(y)), (inot(j), <k> g(p0 @ inot(i))) ], g(p0 @ inot(i)))
def fill2(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> fill0(A, B, f, g, t, y, x1, p1, iand(j, k), i1))
            , (inot(i), <k> fill0(A, B, f, g, t, y, x0, p0, iand(j, k), i1))
            , (inot(j), <k> g(y)) ], g(y))
def sq(A: Set, B: Set, f: A -> B, g: B -> A, t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> A:
  hcompN(A, [ (i, <k> fill0(A, B, f, g, t, y, x1, p1, j, inot(k)))
            , (inot(i), <k> fill0(A, B, f, g, t, y, x0, p0, j, inot(k)))
            , (j, <k> t(fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1)) @ inot(k))
            , (inot(j), <k> g(y)) ], fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, j))
def sq1(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y), i: Interval, j: Interval) -> B:
  hcompN(B, [ (i, <k> s(p1 @ inot(j)) @ k)
            , (inot(i), <k> s(p0 @ inot(j)) @ k)
            , (j, <k> s(f(fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1))) @ k)
            , (inot(j), <k> s(y) @ k) ], f(sq(A, B, f, g, t, y, x0, p0, x1, p1, i, j)))
def lemIso(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, x0: A, p0: Path(B, f(x0), y), x1: A, p1: Path(B, f(x1), y)) -> Path(fiber(A, B, f, y), (x0, p0), (x1, p1)):
  <i> ( fill2(A, B, f, g, t, y, x0, p0, x1, p1, i, i1)
      , <j> sq1(A, B, f, g, s, t, y, x0, p0, x1, p1, i, inot(j)) )
def contrFib(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x), y: B, w: fiber(A, B, f, y)) -> Path(fiber(A, B, f, y), (g(y), s(y)), w):
  match w:
    case (x, p):
      lemIso(A, B, f, g, s, t, y, g(y), s(y), x, p)
def isoToIsEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> isEquiv(A, B, f):
  lambda y. ((g(y), s(y)), lambda w. contrFib(A, B, f, g, s, t, y, w))
def isoToEquiv(A: Set, B: Set, f: A -> B, g: B -> A, s: all y: B. Path(B, f(g(y)), y), t: all x: A. Path(A, g(f(x)), x)) -> Equiv(A, B):
  (f, isoToIsEquiv(A, B, f, g, s, t))

# ---------------------------------------------------------------------------
# §1  The interaction, at depth n.
#     Answers(n, x): an answer now and answers for the next n-1 states.
#     IExec(n, x):   a now, a receipt now ≡ x, an answer, and the rest.
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

# forgetting the states of a history leaves its answers
def forgetStates(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, e: IExec(X, Q, d, n, x)) -> Answers(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match e:
        case (now, here, a, rest):
          (a, forgetStates(X, Q, d, p, d(x, a), rest))
# replaying the answers rebuilds the history, with receipts refl
def replay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X, s: Answers(X, Q, d, n, x)) -> IExec(X, Q, d, n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      match s:
        case (a, more):
          (x, <_> x, a, replay(X, Q, d, p, d(x, a), more))
# forget ∘ replay = id, on the nose (successor case stated with 1n+p so the
# goal's depth is refined definitionally; the general case dispatches)
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
# replay ∘ forget = id: the receipt is collapsed onto refl by the ∨-square
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

# THE THEOREM (run-is-answers), at every depth: the history IS its answer stream
def runIsAnswers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, n: Nat, x: X) -> Equiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x)):
  isoToEquiv(IExec(X, Q, d, n, x), Answers(X, Q, d, n, x),
             lambda e. forgetStates(X, Q, d, n, x, e), lambda s. replay(X, Q, d, n, x, s),
             lambda s. forgetReplay(X, Q, d, n, x, s), lambda e. replayForget(X, Q, d, n, x, e))

# ---------------------------------------------------------------------------
# §2  Silence of questions is determinism: the closed machine (Q x = Unit)
#     has exactly one answer stream, hence one history, at every depth.
# ---------------------------------------------------------------------------
def UnitQ(X: Set, x: X) -> Set:
  Unit
def closedStep(X: Set, f: X -> X, x: X, u: Unit) -> X:
  f(x)
def mute(X: Set, f: X -> X, n: Nat, x: X) -> Answers(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), n, x):
  match n:
    case 0n:
      ()
    case 1n + p:
      ((), mute(X, f, p, f(x)))
def muteUnique(X: Set, f: X -> X, n: Nat, x: X, s: Answers(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), n, x)) -> Path(Answers(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), n, x), mute(X, f, n, x), s):
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
              <i> ((), muteUnique(X, f, p, f(x), more) @ i)
def silenceIsDeterminism(X: Set, f: X -> X, n: Nat, x: X) -> isContr(Answers(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), n, x)):
  (mute(X, f, n, x), lambda s. muteUnique(X, f, n, x, s))

# ---------------------------------------------------------------------------
# §3  Two machines, run.  The closed counter (Turing-like: nothing to ask) and
#     the open machine (the environment chooses: Q x = Bool, increment or reset).
# ---------------------------------------------------------------------------
def incr(n: Nat) -> Nat:
  1n + n
def BoolQ(x: Nat) -> Set:
  Bool
def openStep(x: Nat, b: Bool) -> Nat:
  if b:
    1n + x
  else:
    0n
# the closed machine from 0, its (unique) history replayed to depth 3: now-states
def closedRun(n: Nat) -> IExec(Nat, lambda x. UnitQ(Nat, x), lambda x. lambda u. closedStep(Nat, incr, x, u), n, 0n):
  replay(Nat, lambda x. UnitQ(Nat, x), lambda x. lambda u. closedStep(Nat, incr, x, u), n, 0n, mute(Nat, incr, n, 0n))
def closedNow3() -> Nat:
  match closedRun(3n):
    case (n0, h0, a0, rest):
      match rest:
        case (n1, h1, a1, rest2):
          match rest2:
            case (n2, h2, a2, rest3):
              n2
# the open machine from 1 with the environment's answers True, False, True
def openRun() -> IExec(Nat, BoolQ, openStep, 3n, 1n):
  replay(Nat, BoolQ, openStep, 3n, 1n, (True, (False, (True, ()))))
def openLast() -> Nat:
  match openRun():
    case (n0, h0, a0, rest):
      match rest:
        case (n1, h1, a1, rest2):
          match rest2:
            case (n2, h2, a2, rest3):
              openStep(n2, a2)
# the answers read back from the history are the answers supplied (run-is-answers, forward)
def openAnswersBack() -> Answers(Nat, BoolQ, openStep, 3n, 1n):
  (match runIsAnswers(Nat, BoolQ, openStep, 3n, 1n): case (f, _): f)(openRun())
def openAnswersBack_law() -> Path(Answers(Nat, BoolQ, openStep, 3n, 1n), openAnswersBack(), (True, (False, (True, ())))):
  <_> (True, (False, (True, ())))

def main() -> Nat:
  openLast()

# SILENCE OF QUESTIONS IS DETERMINISM, coinductively and in general
# (Prasna §3): for ANY interaction (X, Q, δ) whose every question Q x is
# contractible, the space of answer streams from x — hence of histories —
# is a point.  The contraction is built coinductively OVER A PATH of states
# (a dependent path PathP(λi. Answers(p @ i))): the answer components are
# collapsed by isProp→PathP, and the tails follow along the line the answers
# draw.  Exactly the Agda copattern proof, as corecursive PathP.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def centre(A: Set, c: isContr(A)) -> A:
  match c:
    case (c0, h):
      c0
def pcomp(A: Set, x: A, y: A, z: A, p: Path(A, x, y), q: Path(A, y, z)) -> Path(A, x, z):
  <i> hcompN(A, [ (inot(i), <_> x), (i, <j> q @ j) ], p @ i)
def contrIsProp(A: Set, c: isContr(A)) -> isProp(A):
  match c:
    case (c0, h):
      lambda a. lambda b. pcomp(A, a, c0, b, <i> h(a) @ inot(i), h(b))
def transport(P: Interval -> Set, t: P(i0)) -> P(i1):
  coe(P, i0, i1, t)
def toPathP(B: Interval -> Set, x: B(i0), y: B(i1), p: Path(B(i1), transport(B, x), y)) -> PathP(B, x, y):
  <i> hcompN(B(i),
    [ (inot(i), <j> coe(lambda k. B(iand(i, k)), i0, i, x)), (i, <j> p @ j) ],
    coe(lambda k. B(iand(i, k)), i0, i, x))
def isPropToPathP(B: Interval -> Set, h: all i: Interval. isProp(B(i)), b0: B(i0), b1: B(i1)) -> PathP(B, b0, b1):
  toPathP(B, b0, b1, h(i1, transport(B, b0), b1))

# ---------------------------------------------------------------------------
# The interaction, parametric: states X, questions Q, step δ.  Coinductive.
# ---------------------------------------------------------------------------
type Answers(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X):
  case @More:
    ans: Q(x)
    more: Answers(X, Q, d, d(x, ans))
type IExec(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X):
  case @Run:
    now: X
    here: Path(X, now, x)
    ans: Q(x)
    next: IExec(X, Q, d, d(x, ans))

def forgetStates(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X, e: IExec(X, Q, d, x)) -> Answers(X, Q, d, x):
  match e:
    case @Run{now, here, a, rest}:
      @More{a, forgetStates(X, Q, d, d(x, a), rest)}
def replay(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X, s: Answers(X, Q, d, x)) -> IExec(X, Q, d, x):
  match s:
    case @More{a, more}:
      @Run{x, <_> x, a, replay(X, Q, d, d(x, a), more)}
def replayForget(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X, e: IExec(X, Q, d, x)) -> Path(IExec(X, Q, d, x), replay(X, Q, d, x, forgetStates(X, Q, d, x, e)), e):
  match e:
    case @Run{now, here, a, rest}:
      <i> @Run{here @ inot(i), <j> here @ ior(inot(i), j), a, replayForget(X, Q, d, d(x, a), rest) @ i}

# ---------------------------------------------------------------------------
# §3  mute: the environment with nothing to choose; answers-unique: any two
#     answer streams over a path of states are joined by a dependent path.
# ---------------------------------------------------------------------------
def mute(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, Qc: all x: X. isContr(Q(x)), x: X) -> Answers(X, Q, d, x):
  @More{centre(Q(x), Qc(x)), mute(X, Q, d, Qc, d(x, centre(Q(x), Qc(x))))}

# the answer components, collapsed over the line of states
def ansLine(X: Set, Q: X -> Set, Qc: all x: X. isContr(Q(x)), x0: X, x1: X, p: Path(X, x0, x1), q0: Q(x0), q1: Q(x1)) -> PathP(lambda i. Q(p @ i), q0, q1):
  isPropToPathP(lambda i. Q(p @ i), lambda i. contrIsProp(Q(p @ i), Qc(p @ i)), q0, q1)

def answersUnique(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, Qc: all x: X. isContr(Q(x)), x0: X, x1: X, p: Path(X, x0, x1), a0: Answers(X, Q, d, x0), a1: Answers(X, Q, d, x1)) -> PathP(lambda i. Answers(X, Q, d, p @ i), a0, a1):
  match a0:
    case @More{q0, m0}:
      match a1:
        case @More{q1, m1}:
          <i> @More{ ansLine(X, Q, Qc, x0, x1, p, q0, q1) @ i
                   , answersUnique(X, Q, d, Qc, d(x0, q0), d(x1, q1),
                                   <j> d(p @ j, ansLine(X, Q, Qc, x0, x1, p, q0, q1) @ j),
                                   m0, m1) @ i }

# one answer stream: the contraction at the constant path
def oneAnswerStream(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, Qc: all x: X. isContr(Q(x)), x: X) -> isContr(Answers(X, Q, d, x)):
  ( mute(X, Q, d, Qc, x)
  , lambda s. answersUnique(X, Q, d, Qc, x, x, <_> x, mute(X, Q, d, Qc, x), s) )

# THE THEOREM.  Nothing to ask, nothing to choose: one history.
# (isContr respects the equivalence run-is-answers: centre = replay(mute),
#  contraction = replay of the answers' contraction, then replay∘forget = id)
def silenceIsDeterminism(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, Qc: all x: X. isContr(Q(x)), x: X) -> isContr(IExec(X, Q, d, x)):
  ( replay(X, Q, d, x, mute(X, Q, d, Qc, x))
  , lambda e. pcomp(IExec(X, Q, d, x),
                    replay(X, Q, d, x, mute(X, Q, d, Qc, x)),
                    replay(X, Q, d, x, forgetStates(X, Q, d, x, e)),
                    e,
                    <i> replay(X, Q, d, x, answersUnique(X, Q, d, Qc, x, x, <_> x, mute(X, Q, d, Qc, x), forgetStates(X, Q, d, x, e)) @ i),
                    replayForget(X, Q, d, x, e)) )

# ---------------------------------------------------------------------------
# §4  The closed machine is the interaction with nothing to ask (Niyati again).
# ---------------------------------------------------------------------------
def UnitQ(X: Set, x: X) -> Set:
  Unit
def closedStep(X: Set, f: X -> X, x: X, u: Unit) -> X:
  f(x)
def isContrUnit() -> isContr(Unit):
  ((), lambda u. match u: case (): <_> ())
def oneExecutionAgain(X: Set, f: X -> X, x: X) -> isContr(IExec(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), x)):
  silenceIsDeterminism(X, lambda x. UnitQ(X, x), lambda x. lambda u. closedStep(X, f, x, u), lambda x. isContrUnit(), x)

# run it: the unique history of the counter from 0, its state after 4 steps
def incr(n: Nat) -> Nat:
  1n + n
def stateAt(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, x: X, e: IExec(X, Q, d, x), n: Nat) -> X:
  match n:
    case 0n:
      x
    case 1n + p:
      match e:
        case @Run{now, here, a, rest}:
          stateAt(X, Q, d, d(x, a), rest, p)
def main() -> Nat:
  stateAt(Nat, lambda x. UnitQ(Nat, x), lambda x. lambda u. closedStep(Nat, incr, x, u), 0n,
          centre(IExec(Nat, lambda x. UnitQ(Nat, x), lambda x. lambda u. closedStep(Nat, incr, x, u), 0n), oneExecutionAgain(Nat, incr, 0n)),
          4n)
# MUST FAIL: the open machine (Q = Bool, no contractibility) has no contraction
def BoolQ(x: Nat) -> Set:
  Bool
def openStep(x: Nat, b: Bool) -> Nat:
  if b:
    1n + x
  else:
    0n
def wrongTail(X: Set, Q: X -> Set, d: all x: X. Q(x) -> X, Qc: all x: X. isContr(Q(x)), x0: X, x1: X, p: Path(X, x0, x1), a0: Answers(X, Q, d, x0), a1: Answers(X, Q, d, x1)) -> PathP(lambda i. Answers(X, Q, d, p @ i), a0, a1):
  match a0:
    case @More{q0, m0}:
      match a1:
        case @More{q1, m1}:
          <i> @More{ ansLine(X, Q, Qc, x0, x1, p, q0, q1) @ i, m0 }
def wrongCentre(x: Nat, s: Answers(Nat, BoolQ, openStep, x)) -> Path(Answers(Nat, BoolQ, openStep, x), mute(Nat, BoolQ, openStep, lambda x. (True, lambda b. <_> True), x), s):
  <i> s

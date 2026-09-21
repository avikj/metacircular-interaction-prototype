# THE INTERACTIVE MACHINE, COINDUCTIVELY: infinite histories as one object.
# Bend2 types are records read lazily; a corecursive definition is typed by
# assuming itself at its declared type (Fix), the runtime unfolds on demand,
# and the totality classifier tags constructor-guarded corecursion
# [productive] (--total refuses [unchecked]).  So IExec / Answers are the
# coinductive records themselves, and bisimulations are corecursive paths.
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))

# the open machine on Nat: the environment answers a Bool; +1 or reset
def Q(x: Nat) -> Set:
  Bool
def step(x: Nat, b: Bool) -> Nat:
  if b:
    1n + x
  else:
    0n

# Answers x : an answer now, and answers forever after (coinductive)
type Answers(x: Nat):
  case @More:
    ans: Q(x)
    more: Answers(step(x, ans))
# IExec x : a now, a receipt now ≡ x, an answer, and the rest (coinductive)
type IExec(x: Nat):
  case @Run:
    now: Nat
    here: Path(Nat, now, x)
    ans: Q(x)
    next: IExec(step(x, ans))

# the environment that always says True (an infinite answer stream)
def always(x: Nat) -> Answers(x):
  @More{True, always(step(x, True))}
# alternating True/False
def alt(x: Nat, b: Bool) -> Answers(x):
  @More{b, alt(step(x, b), match b: case True: False case False: True)}

# forgetting the states of a history leaves its answers (corecursive)
def forgetStates(x: Nat, e: IExec(x)) -> Answers(x):
  match e:
    case @Run{now, here, a, rest}:
      @More{a, forgetStates(step(x, a), rest)}
# replaying the answers rebuilds the history, receipts refl (corecursive)
def replay(x: Nat, s: Answers(x)) -> IExec(x):
  match s:
    case @More{a, more}:
      @Run{x, <_> x, a, replay(step(x, a), more)}

# THE THEOREM run-is-answers, coinductively: both round trips are
# corecursive paths (bisimulations), the receipt collapsed by the ∨-square.
def forgetReplay(x: Nat, s: Answers(x)) -> Path(Answers(x), forgetStates(x, replay(x, s)), s):
  match s:
    case @More{a, more}:
      <i> @More{a, forgetReplay(step(x, a), more) @ i}
def replayForget(x: Nat, e: IExec(x)) -> Path(IExec(x), replay(x, forgetStates(x, e)), e):
  match e:
    case @Run{now, here, a, rest}:
      <i> @Run{here @ inot(i), <j> here @ ior(inot(i), j), a, replayForget(step(x, a), rest) @ i}

# observe a history: the state after n steps
def stateAt(x: Nat, e: IExec(x), n: Nat) -> Nat:
  match n:
    case 0n:
      x
    case 1n + p:
      match e:
        case @Run{now, here, a, rest}:
          stateAt(step(x, a), rest, p)
def main() -> Nat:
  stateAt(0n, replay(0n, alt(0n, True)), 5n)

# formal/cubical/InteractionPrasna_�agda, the two-sided theorem, in Bend:
#   the process space of a probing coalgebra is a POINT when the event datum
#   is a proposition (एक-नेत्रम्), and is NOT a point for the kernel's
#   self-extension, whose event datum is a proof-relevant Derivation
#   (वर्धन-बहुत्वम्, by the length shadow).
import GenerativeKernel

# the interactive symbolic computer: per question, a successor, an
# observation, a receipt, a continuation (coinductive)
type ISC(W: Set, Q: W -> Set, O: all w: W. Q(w) -> W -> Set, E: all w: W. all q: Q(w). all w2: W. O(w, q, w2) -> Set, w: W):
  case @isc:
    react: all q: Q(w). any w2: W. any o: O(w, q, w2). any e: E(w, q, w2, o). ISC(W, Q, O, E, w2)

def react(W: Set, Q: W -> Set, O: all w: W. Q(w) -> W -> Set, E: all w: W. all q: Q(w). all w2: W. O(w, q, w2) -> Set, w: W, p: ISC(W, Q, O, E, w), q: Q(w)) -> any w2: W. any o: O(w, q, w2). any e: E(w, q, w2, o). ISC(W, Q, O, E, w2):
  match p:
    case @isc{r}: r(q)

# ---- §1 the probing coalgebra Netra over (step, obs), receipt = two paths in sets
def Ev(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, w2: W, o: V) -> Set:
  any e1: Path(V, o, obs(w, q)). Path(W, w2, step(w, q))

def Netra(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W) -> Set:
  ISC(W, lambda w. Q, lambda w. lambda q. lambda w2. V, lambda w. lambda q. lambda w2. lambda o. Ev(W, V, Q, step, obs, w, q, w2, o), w)

def netra(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W) -> Netra(W, V, Q, step, obs, w):
  @isc{lambda q. (step(w, q), obs(w, q), (<_> obs(w, q), <_> step(w, q)), netra(W, V, Q, step, obs, step(w, q)))}

# a reaction, and its four projections (plain fst/snd, so Σ-η sees them)
def Reaction(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q) -> Set:
  any w2: W. any o: V. any e: Ev(W, V, Q, step, obs, w, q, w2, o). Netra(W, V, Q, step, obs, w2)
def xW(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> W:
  fst(W, lambda w2. any o: V. any e: Ev(W, V, Q, step, obs, w, q, w2, o). Netra(W, V, Q, step, obs, w2), x)
def xR(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> any o: V. any e: Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), o). Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)):
  snd(W, lambda w2. any o: V. any e: Ev(W, V, Q, step, obs, w, q, w2, o). Netra(W, V, Q, step, obs, w2), x)
def xO(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> V:
  fst(V, lambda o. any e: Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), o). Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)), xR(W, V, Q, step, obs, w, q, x))
def xET(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> any e: Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), xO(W, V, Q, step, obs, w, q, x)). Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)):
  snd(V, lambda o. any e: Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), o). Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)), xR(W, V, Q, step, obs, w, q, x))
def xE(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), xO(W, V, Q, step, obs, w, q, x)):
  fst(Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), xO(W, V, Q, step, obs, w, q, x)), lambda e. Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)), xET(W, V, Q, step, obs, w, q, x))
def xT(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, x: Reaction(W, V, Q, step, obs, w, q)) -> Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)):
  snd(Ev(W, V, Q, step, obs, w, q, xW(W, V, Q, step, obs, w, q, x), xO(W, V, Q, step, obs, w, q, x)), lambda e. Netra(W, V, Q, step, obs, xW(W, V, Q, step, obs, w, q, x)), xET(W, V, Q, step, obs, w, q, x))

# the two components of a receipt
def eO(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, w2: W, o: V, e: Ev(W, V, Q, step, obs, w, q, w2, o)) -> Path(V, o, obs(w, q)):
  fst(Path(V, o, obs(w, q)), lambda e1. Path(W, w2, step(w, q)), e)
def eW(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w: W, q: Q, w2: W, o: V, e: Ev(W, V, Q, step, obs, w, q, w2, o)) -> Path(W, w2, step(w, q)):
  snd(Path(V, o, obs(w, q)), lambda e1. Path(W, w2, step(w, q)), e)

def isPropEv(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, sW: isSet(W), sV: isSet(V), w: W, q: Q, w2: W, o: V) -> isProp(Ev(W, V, Q, step, obs, w, q, w2, o)):
  lambda x. lambda y. isPropProd(Path(V, o, obs(w, q)), Path(W, w2, step(w, q)), sV(o, obs(w, q)), sW(w2, step(w, q)), x, y)

# the state and observation paths between two reactions: receipt, along π, receipt back
def wP(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w0: W, w1: W, pi: Path(W, w0, w1), pr: Q, xp: Reaction(W, V, Q, step, obs, w0, pr), xq: Reaction(W, V, Q, step, obs, w1, pr)) -> Path(W, xW(W, V, Q, step, obs, w0, pr, xp), xW(W, V, Q, step, obs, w1, pr, xq)):
  compPath3(W, xW(W, V, Q, step, obs, w0, pr, xp), step(w0, pr), step(w1, pr), xW(W, V, Q, step, obs, w1, pr, xq),
    eW(W, V, Q, step, obs, w0, pr, xW(W, V, Q, step, obs, w0, pr, xp), xO(W, V, Q, step, obs, w0, pr, xp), xE(W, V, Q, step, obs, w0, pr, xp)),
    <j> step(pi @ j, pr),
    <j> eW(W, V, Q, step, obs, w1, pr, xW(W, V, Q, step, obs, w1, pr, xq), xO(W, V, Q, step, obs, w1, pr, xq), xE(W, V, Q, step, obs, w1, pr, xq)) @ inot(j))
def oP(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, w0: W, w1: W, pi: Path(W, w0, w1), pr: Q, xp: Reaction(W, V, Q, step, obs, w0, pr), xq: Reaction(W, V, Q, step, obs, w1, pr)) -> Path(V, xO(W, V, Q, step, obs, w0, pr, xp), xO(W, V, Q, step, obs, w1, pr, xq)):
  compPath3(V, xO(W, V, Q, step, obs, w0, pr, xp), obs(w0, pr), obs(w1, pr), xO(W, V, Q, step, obs, w1, pr, xq),
    eO(W, V, Q, step, obs, w0, pr, xW(W, V, Q, step, obs, w0, pr, xp), xO(W, V, Q, step, obs, w0, pr, xp), xE(W, V, Q, step, obs, w0, pr, xp)),
    <j> obs(pi @ j, pr),
    <j> eO(W, V, Q, step, obs, w1, pr, xW(W, V, Q, step, obs, w1, pr, xq), xO(W, V, Q, step, obs, w1, pr, xq), xE(W, V, Q, step, obs, w1, pr, xq)) @ inot(j))
def eP(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, sW: isSet(W), sV: isSet(V), w0: W, w1: W, pi: Path(W, w0, w1), pr: Q, xp: Reaction(W, V, Q, step, obs, w0, pr), xq: Reaction(W, V, Q, step, obs, w1, pr)) -> PathP(lambda j. Ev(W, V, Q, step, obs, pi @ j, pr, wP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j, oP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j), xE(W, V, Q, step, obs, w0, pr, xp), xE(W, V, Q, step, obs, w1, pr, xq)):
  isPropToPathP(lambda j. Ev(W, V, Q, step, obs, pi @ j, pr, wP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j, oP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j),
                lambda j. isPropEv(W, V, Q, step, obs, sW, sV, pi @ j, pr, wP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j, oP(W, V, Q, step, obs, w0, w1, pi, pr, xp, xq) @ j),
                xE(W, V, Q, step, obs, w0, pr, xp), xE(W, V, Q, step, obs, w1, pr, xq))

# any two processes over a path of states are identified, corecursively:
# the receipt slot collapses because Ev is a proposition (the Kan filler
# built from the two successor receipts and π is the whole of determinism)
def samyaP(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, sW: isSet(W), sV: isSet(V), w0: W, w1: W, pi: Path(W, w0, w1), p: Netra(W, V, Q, step, obs, w0), q: Netra(W, V, Q, step, obs, w1)) -> PathP(lambda i. Netra(W, V, Q, step, obs, pi @ i), p, q):
  match p:
    case @isc{rp}:
      match q:
        case @isc{rq}:
          <i> @isc{lambda pr.
            ( wP(W, V, Q, step, obs, w0, w1, pi, pr, rp(pr), rq(pr)) @ i
            , oP(W, V, Q, step, obs, w0, w1, pi, pr, rp(pr), rq(pr)) @ i
            , eP(W, V, Q, step, obs, sW, sV, w0, w1, pi, pr, rp(pr), rq(pr)) @ i
            , samyaP(W, V, Q, step, obs, sW, sV, xW(W, V, Q, step, obs, w0, pr, rp(pr)), xW(W, V, Q, step, obs, w1, pr, rq(pr)), wP(W, V, Q, step, obs, w0, w1, pi, pr, rp(pr), rq(pr)), xT(W, V, Q, step, obs, w0, pr, rp(pr)), xT(W, V, Q, step, obs, w1, pr, rq(pr))) @ i )}

# एक-नेत्रम्: over sets, the process space is a point
def oneEye(W: Set, V: Set, Q: Set, step: W -> Q -> W, obs: W -> Q -> V, sW: isSet(W), sV: isSet(V), w: W) -> isContr(Netra(W, V, Q, step, obs, w)):
  (netra(W, V, Q, step, obs, w), lambda p. samyaP(W, V, Q, step, obs, sW, sV, w, w, <_> w, netra(W, V, Q, step, obs, w), p))

# ---- §4 the kernel's self-extension as a coalgebra: the event datum is a Derivation
def Vardhana(w: Tm) -> Set:
  ISC(Tm, lambda w. CheckedFuture(w), lambda w. lambda q. lambda w2. Tm, lambda w. lambda q. lambda w2. lambda o. Derivation(w, o), w)

def vardhana(w: Tm) -> Vardhana(w):
  @isc{lambda cf. (cfTarget(w, cf), cfTarget(w, cf), cfDerivation(w, cf), vardhana(cfTarget(w, cf)))}

def cf_direct() -> CheckedFuture(seed()):
  @checked{target0(), direct_history()}

def dlen(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + dlen(y, b, d2)

def detour_of(o: Tm, d: Derivation(seed(), o)) -> Derivation(seed(), o):
  @then{@suc{@add{@var, @zero}}, @add_suc{@var, @zero, {==}, {==}},
    @then{@add{@var, @suc{@zero}}, @reverse{@add_suc{@var, @zero, {==}, {==}}}, d}}

def p1() -> Vardhana(seed()):
  vardhana(seed())
def p2() -> Vardhana(seed()):
  @isc{lambda cf. (cfTarget(seed(), cf), cfTarget(seed(), cf), detour_of(cfTarget(seed(), cf), cfDerivation(seed(), cf)), vardhana(cfTarget(seed(), cf)))}

# the length shadow of the derivation a process emits on the direct query
def emitLen(p: Vardhana(seed())) -> Nat:
  match p:
    case @isc{r}:
      match r(cf_direct()):
        case (w2, o, e, t): dlen(seed(), o, e)

def emitLen_p1() -> Path(Nat, emitLen(p1()), 2n):
  <_> 2n
def emitLen_p2() -> Path(Nat, emitLen(p2()), 4n):
  <_> 4n

def processes_differ(P: Path(Vardhana(seed()), p1(), p2())) -> Empty:
  nNotSucSuc(2n, <i> emitLen(P @ i))

# वर्धन-बहुत्वम्: the process space is NOT a point
def vardhanaNotContr(c: isContr(Vardhana(seed()))) -> Empty:
  match c:
    case (centre, h):
      processes_differ(compPath(Vardhana(seed()), p1(), centre, p2(), <i> h(p1()) @ inot(i), h(p2())))

# and the untruncated derivation type is not a proposition: the WHICH is real
def notPropDerivation(ip: isProp(Derivation(seed(), target0()))) -> Empty:
  nNotSucSuc(2n, <i> dlen(seed(), target0(), ip(direct_history(), detour_history()) @ i))

def main() -> Nat:
  emitLen(p2())

# EMITTED by scripts/emit-perturbation.py — do not edit; edit the spec.
# The perturbation presentation (collab/bend2-cubical/port/Perturbation.bend)
# for the panel ['TF1', 'TGT1', 'HK1'] with edges [('TF1', 'TGT1')].
# Contexts are control populations; interventions are knockdowns; the
# generator family is the one the edge list determines (see the script).
import Nerode

# §1 the finite presentation
type Gene:
  case @tf1:
  case @tgt1:
  case @hk1:
type Cell:
  case @cell:
    tf1: Nat
    tgt1: Nat
    hk1: Nat
def tf1Of(c: Cell) -> Nat:
  match c: case @cell{v_tf1, v_tgt1, v_hk1}: v_tf1
def tgt1Of(c: Cell) -> Nat:
  match c: case @cell{v_tf1, v_tgt1, v_hk1}: v_tgt1
def hk1Of(c: Cell) -> Nat:
  match c: case @cell{v_tf1, v_tgt1, v_hk1}: v_hk1
type Perturb:
  case @kd:
    g: Gene
  case @passage:
def knock(g: Gene, c: Cell) -> Cell:
  match c:
    case @cell{v_tf1, v_tgt1, v_hk1}:
      match g:
        case @tf1{}: @cell{0n, v_tgt1, v_hk1}
        case @tgt1{}: @cell{v_tf1, 0n, v_hk1}
        case @hk1{}: @cell{v_tf1, v_tgt1, 0n}
def step(c: Cell, p: Perturb) -> Cell:
  match p:
    case @kd{g}: knock(g, c)
    case @passage{}:
      match c:
        case @cell{v_tf1, v_tgt1, v_hk1}: @cell{v_tf1, v_tf1, v_hk1}
type Step(x: Cell, y: Cell):
  case @act:
    p: Perturb
    ey: Cell{y == step(x, p)}
type Derivation(x: Cell, z: Cell):
  case @done:
    e: Cell{z == x}
  case @then:
    y: Cell
    s: Step(x, y)
    d: Derivation(y, z)
def stepPerturb(x: Cell, y: Cell, s: Step(x, y)) -> Perturb:
  match s: case @act{p, ey}: p

# §2 receiver, fold, uniqueness (AdiBija)
type Receiver:
  case @receiver:
    Motion: Cell -> Cell -> Set
    eps: all t: Cell. Motion(t, t)
    cons: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> Motion(b, c) -> Motion(a, c)
def rMotion(R: Receiver, a: Cell, b: Cell) -> Set:
  match R: case @receiver{M, e, k}: M(a, b)
def foldM(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> M(b, c) -> M(a, c), a: Cell, z: Cell, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))
def fold(R: Receiver, a: Cell, z: Cell, d: Derivation(a, z)) -> rMotion(R, a, z):
  match R:
    case @receiver{M, e, k}: foldM(M, e, k, a, z, d)
def fold_unique(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> M(b, c) -> M(a, c),
                g: all a: Cell. all z: Cell. Derivation(a, z) -> M(a, z),
                g_done: all t: Cell. Path(M(t, t), g(t, t, @done{{==}}), e(t)),
                g_step: all a: Cell. all y: Cell. all z: Cell. all s: Step(a, y). all d: Derivation(y, z). Path(M(a, z), g(a, z, @then{y, s, d}), k(a, y, z, s, g(y, z, d))),
                a: Cell, z: Cell, d: Derivation(a, z)) -> Path(M(a, z), g(a, z, d), foldM(M, e, k, a, z, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: g_done(a)
    case @then{y, s, d2}:
      compPath(M(a, z), g(a, z, @then{y, s, d2}), k(a, y, z, s, g(y, z, d2)), k(a, y, z, s, foldM(M, e, k, y, z, d2)),
        g_step(a, y, z, s, d2),
        <i> k(a, y, z, s, fold_unique(M, e, k, g, g_done, g_step, y, z, d2) @ i))

# §3 readings: length, targeted gene, endpoint, word
def orB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: True
    case False: b
def sameGene(g: Gene, g2: Gene) -> Bool:
  match g:
    case @tf1{}:
      match g2:
        case @tf1{}: True
        case @tgt1{}: False
        case @hk1{}: False
    case @tgt1{}:
      match g2:
        case @tf1{}: False
        case @tgt1{}: True
        case @hk1{}: False
    case @hk1{}:
      match g2:
        case @tf1{}: False
        case @tgt1{}: False
        case @hk1{}: True
def targets(g: Gene, p: Perturb) -> Bool:
  match p:
    case @kd{g2}: sameGene(g, g2)
    case @passage{}: False
def lenM(a: Cell, b: Cell) -> Set:
  Nat
def steps(a: Cell, z: Cell, d: Derivation(a, z)) -> Nat:
  foldM(lenM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)
def hitM(a: Cell, b: Cell) -> Set:
  Bool
def targeted(g: Gene, a: Cell, z: Cell, d: Derivation(a, z)) -> Bool:
  foldM(hitM, lambda t. False, lambda a2. lambda b. lambda c. lambda s. lambda m. orB(targets(g, stepPerturb(a2, b, s)), m), a, z, d)
def endM(a: Cell, b: Cell) -> Set:
  Cell
def endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Cell:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def endpoint_is_endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Path(Cell, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)
def wordM(a: Cell, b: Cell) -> Set:
  Perturb[]
def word(a: Cell, z: Cell, d: Derivation(a, z)) -> Perturb[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepPerturb(a2, b, s) <> w, a, z, d)
def runC(c: Cell, w: Perturb[]) -> Cell:
  run(Cell, Perturb, step, c, w)
def word_replays(a: Cell, z: Cell, d: Derivation(a, z)) -> Path(Cell, runC(a, word(a, z, d)), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      match s:
        case @act{p, ey}:
          match ey: case {==}: word_replays(step(a, p), z, d2)

# §5 the assay and the behavioural quotient (the protocol reads the assay genes)
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)
def assay(c: Cell) -> Nat[]:
  [tgt1Of(c)]
# Nat[] is a set (encode–decode would give it; here it is taken as the
# generic quotient's one hypothesis, as the corpus's FutureQuotient does)
def NerodeAssay(setL: isSet(Nat[]), x: Cell, y: Cell) -> Set:
  Nerode(Cell, Perturb, Nat[], step, assay, x, y)
def MeaningAssay() -> Set:
  Meaning(Cell, Perturb, Nat[], step, assay)
def meaning_is_future(setL: isSet(Nat[]), x: Cell, y: Cell, p: Path(MeaningAssay, @cl{x}, @cl{y})) -> Nerode(Cell, Perturb, Nat[], step, assay, x, y):
  nerodeEffective(Cell, Perturb, Nat[], step, setL, assay, x, y, p)

# §6 the protocols, as receivers over populations: cell-eval's own metrics
# (arcinstitute cell-eval 0.8.2: mae over pseudobulk, de_overlap of the
# top-k DE genes, discrimination_score = rank of the true perturbation by
# L1 distance), stated on integer pseudobulk sums; normalisation by cell
# count and the signed delta are the front-end's to add when the
# submission is scored against real data.
def absDiff(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n + p:
      match b:
        case 0n: 1n + p
        case 1n + q: absDiff(p, q)
def l1(xs: Nat[], ys: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case x <> xr:
      match ys:
        case []: 0n
        case y <> yr: add(absDiff(x, y), l1(xr, yr))
def ltN(a: Nat, b: Nat) -> Bool:
  match b:
    case 0n: False
    case 1n + q:
      match a:
        case 0n: True
        case 1n + p: ltN(p, q)
def geN(a: Nat, b: Nat) -> Bool:
  match ltN(a, b):
    case True: False
    case False: True
def andB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: b
    case False: False
def countTrue(bs: Bool[]) -> Nat:
  match bs:
    case []: 0n
    case b <> rest:
      match b:
        case True: 1n + countTrue(rest)
        case False: countTrue(rest)
def zipAnd(xs: Bool[], ys: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case x <> xr:
      match ys:
        case []: []
        case y <> yr: andB(x, y) <> zipAnd(xr, yr)
# DE call per gene: |perturbed - control| >= threshold on the pseudobulk
def deCalls(thr: Nat, ctrl: Nat[], pert: Nat[]) -> Bool[]:
  match ctrl:
    case []: []
    case c <> cr:
      match pert:
        case []: []
        case p <> pr: geN(absDiff(c, p), thr) <> deCalls(thr, cr, pr)
# RECEIVER mae: the L1 distance of two pseudobulk profiles
def mae(real: Nat[], pred: Nat[]) -> Nat:
  l1(real, pred)
# RECEIVER de_overlap: DE genes called on both
def deOverlap(thr: Nat, ctrl: Nat[], real: Nat[], pred: Nat[]) -> Nat:
  countTrue(zipAnd(deCalls(thr, ctrl, real), deCalls(thr, ctrl, pred)))
# RECEIVER discrimination: how many candidate real profiles are strictly
# closer to the prediction than the true one (rank 0 = best)
def rankOf(pred: Nat[], truth: Nat[], candidates: Nat[][]) -> Nat:
  match candidates:
    case []: 0n
    case c <> rest:
      match ltN(l1(pred, c), l1(pred, truth)):
        case True: 1n + rankOf(pred, truth, rest)
        case False: rankOf(pred, truth, rest)
# SIGNED DELTAS without signed numbers: |(p1 - c1) - (p2 - c2)| = |(p1 + c2) - (p2 + c1)|,
# so the delta-protocols (mae_delta, direction match) are stated on Nat profiles.
def deltaDist(c1: Nat, p1: Nat, c2: Nat, p2: Nat) -> Nat:
  absDiff(add(p1, c2), add(p2, c1))
def l1Delta(ctrl1: Nat[], pert1: Nat[], ctrl2: Nat[], pert2: Nat[]) -> Nat:
  match ctrl1:
    case []: 0n
    case c1 <> cr1:
      match pert1:
        case []: 0n
        case p1 <> pr1:
          match ctrl2:
            case []: 0n
            case c2 <> cr2:
              match pert2:
                case []: 0n
                case p2 <> pr2: add(deltaDist(c1, p1, c2, p2), l1Delta(cr1, pr1, cr2, pr2))
# RECEIVER mae_delta: L1 between the real effect and the predicted effect
def maeDelta(ctrl: Nat[], real: Nat[], pred: Nat[]) -> Nat:
  l1Delta(ctrl, real, ctrl, pred)
# RECEIVER direction match: genes whose effect has the same direction (down/flat/up)
def dir3(c: Nat, p: Nat) -> Nat:
  match ltN(c, p):
    case True: 2n
    case False:
      match ltN(p, c):
        case True: 0n
        case False: 1n
def sameNat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: True
        case 1n + q: False
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: sameNat(p, q)
def directionMatch(ctrl: Nat[], real: Nat[], pred: Nat[]) -> Nat:
  match ctrl:
    case []: 0n
    case c <> cr:
      match real:
        case []: 0n
        case r <> rr:
          match pred:
            case []: 0n
            case p <> pr:
              match sameNat(dir3(c, r), dir3(c, p)):
                case True: 1n + directionMatch(cr, rr, pr)
                case False: directionMatch(cr, rr, pr)

# §7 the challenge shape: contexts, submissions, pseudobulk per gene
def Context() -> Set:
  Cell[]
def predict(x: Context, p: Perturb) -> Context:
  map(Cell, Cell, lambda c. step(c, p), x)
def pseudobulk_tf1(x: Context) -> Nat:
  match x:
    case []: 0n
    case c <> rest: add(tf1Of(c), pseudobulk_tf1(rest))
def pseudobulk_tgt1(x: Context) -> Nat:
  match x:
    case []: 0n
    case c <> rest: add(tgt1Of(c), pseudobulk_tgt1(rest))
def pseudobulk_hk1(x: Context) -> Nat:
  match x:
    case []: 0n
    case c <> rest: add(hk1Of(c), pseudobulk_hk1(rest))
def context_a() -> Context:
  [@cell{2n, 1n, 5n}, @cell{1n, 1n, 3n}, @cell{0n, 1n, 7n}]
def submission_a_kd_tf1() -> Context:
  predict(predict(context_a(), @kd{@tf1}), @passage)
def submission_a_kd_hk1() -> Context:
  predict(predict(context_a(), @kd{@hk1}), @passage)
def context_b() -> Context:
  [@cell{1n, 0n, 2n}, @cell{1n, 1n, 2n}]
def submission_b_kd_tf1() -> Context:
  predict(predict(context_b(), @kd{@tf1}), @passage)
def submission_b_kd_hk1() -> Context:
  predict(predict(context_b(), @kd{@hk1}), @passage)
def profile(x: Context) -> Nat[]:
  [pseudobulk_tf1(x), pseudobulk_tgt1(x), pseudobulk_hk1(x)]
# the receivers, exercised: the submission against its own control (no real
# perturbed profile is available here; the front-end substitutes it)
def demo_mae() -> Nat:
  mae(profile(context_a()), profile(submission_a_kd_tf1()))
def demo_de_overlap() -> Nat:
  deOverlap(1n, profile(context_a()), profile(submission_a_kd_tf1()), profile(submission_a_kd_tf1()))
def demo_mae_delta() -> Nat:
  maeDelta(profile(context_a()), profile(submission_a_kd_tf1()), profile(predict(context_a(), @passage)))
def demo_direction() -> Nat:
  directionMatch(profile(context_a()), profile(submission_a_kd_tf1()), profile(predict(context_a(), @passage)))
# (no protocol disagreement among these candidates: mae and DE-overlap order them alike)
def demo_rank() -> Nat:
  rankOf(profile(submission_a_kd_tf1()), profile(submission_a_kd_tf1()), [profile(submission_a_kd_tf1()), profile(submission_a_kd_hk1())])

def main() -> Nat:
  pseudobulk_tgt1(submission_a_kd_tf1())

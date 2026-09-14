# The 2026 Virtual Cell Challenge, as one ordinary evaluation of the
# interaction object — the first biological finite presentation fed to the
# calculus unchanged.  Nothing here is a new construction: the file is
# AdiBija (receiver, fold, uniqueness), Vivarana (one object, several
# readings), Krama (commutation kept, its failure retained), the
# Myhill–Nerode minimal machine (Meaning = X / future-behaviour) and
# erasure = descent (the quotient recursor's resp obligation), each
# instantiated at a perturbation system instead of the rewrite kernel.
#
# THE FINITE PRESENTATION.  A cell is its measured levels on a gene panel;
# an intervention is a knockdown of one gene or a passage (time); the
# perturbational continuation algebra `step` is the generator action.  The
# panel here is three genes with one regulatory edge (tf activates tgt at
# passage; hk is unregulated) — the SHAPE of the challenge object, not its
# data.  The real panel and the real generators enter by a front-end that
# emits this file's `Cell`/`Perturb`/`step` from the released control
# populations; the theorems below are stated for the panel and hold for
# any finite panel with the same generator signature.
#
#   §1  generators, steps, derivations (a history of interventions)
#   §2  Receiver = (Motion, ε, ◂); fold; fold is unique (AdiBija)
#   §3  four readings of one history: length, targeted-gene, endpoint,
#       word — the endpoint reading IS the endpoint, the word reading
#       replays to it (the answer is the projection of the route)
#   §4  Vivarana: two histories with the same interventions in a
#       different order, separated where they differ (endpoint tgt) and
#       identified where they agree (length, which genes were hit) —
#       and the same lens family certifies that kd(tf) and kd(hk)
#       commute while kd(tf) and passage do not (Krama)
#   §5  the assay: observe tgt only.  Nerode = X / future-behaviour.
#       (a) tf is NEVER read by the assay and is NECESSARY state: one
#           future word separates two cells that agree on everything
#           the assay sees.  (b) hk is never read and is ERASABLE: every
#           future agrees.  Both are theorems of the generator family,
#           not modelling choices; effectivity ([x] = [y] ⟹ same
#           future) is inherited from the generic quotient.
#   §6  erasure = descent: the projection that forgets hk carries every
#       receiver that reads through (tf, tgt) — the recursor's resp
#       obligation is inhabited.  The receiver that reads hk does not
#       descend: see Perturbation_mustfail.bend, where the substrate
#       rejects the collapse.
#   §7  the challenge shape: a context is a control population, a
#       submission is the population under the intervention, a protocol
#       (pseudobulk here) is a receiver over it.
import Nerode

# ---------------------------------------------------------------------------
# §1  The finite presentation.
# ---------------------------------------------------------------------------
type Gene:
  case @tf:
  case @tgt:
  case @hk:

# a cell = its levels on the panel
type Cell:
  case @cell:
    tf: Nat
    tgt: Nat
    hk: Nat

def tfOf(c: Cell) -> Nat:
  match c: case @cell{a, b, h}: a
def tgtOf(c: Cell) -> Nat:
  match c: case @cell{a, b, h}: b
def hkOf(c: Cell) -> Nat:
  match c: case @cell{a, b, h}: h

# the interventions available at the boundary
type Perturb:
  case @kd:
    g: Gene
  case @passage:

# the generator actions: a knockdown zeroes its gene; a passage lets the
# one regulatory edge act (tgt follows tf); hk is regulated by nothing
def knock(g: Gene, c: Cell) -> Cell:
  match c:
    case @cell{a, b, h}:
      match g:
        case @tf{}: @cell{0n, b, h}
        case @tgt{}: @cell{a, 0n, h}
        case @hk{}: @cell{a, b, 0n}
def step(c: Cell, p: Perturb) -> Cell:
  match p:
    case @kd{g}: knock(g, c)
    case @passage{}:
      match c:
        case @cell{a, b, h}: @cell{a, a, h}

# a step is an intervention with its endpoint equation; a derivation is a
# history of interventions from one cell state to another
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

# ---------------------------------------------------------------------------
# §2  A receiver of the system's motion, and the fold (AdiBija §0–§2).
# ---------------------------------------------------------------------------
type Receiver:
  case @receiver:
    Motion: Cell -> Cell -> Set
    eps: all t: Cell. Motion(t, t)
    cons: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> Motion(b, c) -> Motion(a, c)

def rMotion(R: Receiver, a: Cell, b: Cell) -> Set:
  match R: case @receiver{M, e, k}: M(a, b)

# the fold, with the receiver's three components explicit
def foldM(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. Step(a, b) -> M(b, c) -> M(a, c), a: Cell, z: Cell, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))

# ...and on the record
def fold(R: Receiver, a: Cell, z: Cell, d: Derivation(a, z)) -> rMotion(R, a, z):
  match R:
    case @receiver{M, e, k}: foldM(M, e, k, a, z, d)

# THE FOLD IS UNIQUE: anything with the two computation rules is it.
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

# ---------------------------------------------------------------------------
# §3  Four readings of one history.
# ---------------------------------------------------------------------------
def orB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: True
    case False: b
def sameGene(g: Gene, g2: Gene) -> Bool:
  match g:
    case @tf{}:
      match g2:
        case @tf{}: True
        case @tgt{}: False
        case @hk{}: False
    case @tgt{}:
      match g2:
        case @tf{}: False
        case @tgt{}: True
        case @hk{}: False
    case @hk{}:
      match g2:
        case @tf{}: False
        case @tgt{}: False
        case @hk{}: True
def targets(g: Gene, p: Perturb) -> Bool:
  match p:
    case @kd{g2}: sameGene(g, g2)
    case @passage{}: False

# (a) LENGTH: how many interventions
def lenM(a: Cell, b: Cell) -> Set:
  Nat
def lenR() -> Receiver:
  @receiver{lenM, lambda t. 0n, lambda a. lambda b. lambda c. lambda s. lambda n. 1n + n}
def steps(a: Cell, z: Cell, d: Derivation(a, z)) -> Nat:
  foldM(lenM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)

# (b) TARGETED: was gene g directly intervened on (a DEG-by-target protocol)
def hitM(a: Cell, b: Cell) -> Set:
  Bool
def hitR(g: Gene) -> Receiver:
  @receiver{hitM, lambda t. False, lambda a. lambda b. lambda c. lambda s. lambda m. orB(targets(g, stepPerturb(a, b, s)), m)}
def targeted(g: Gene, a: Cell, z: Cell, d: Derivation(a, z)) -> Bool:
  foldM(hitM, lambda t. False, lambda a2. lambda b. lambda c. lambda s. lambda m. orB(targets(g, stepPerturb(a2, b, s)), m), a, z, d)

# (c) ENDPOINT: the terminal state (the pseudobulk of one cell)
def endM(a: Cell, b: Cell) -> Set:
  Cell
def endR() -> Receiver:
  @receiver{endM, lambda t. t, lambda a. lambda b. lambda c. lambda s. lambda m. m}
def endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Cell:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
# the endpoint reading is the endpoint: the answer is a projection of the route
def endpoint_is_endpoint(a: Cell, z: Cell, d: Derivation(a, z)) -> Path(Cell, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)

# (d) WORD: the interventions in order (the retrieval protocol; loses nothing)
def wordM(a: Cell, b: Cell) -> Set:
  Perturb[]
def wordR() -> Receiver:
  @receiver{wordM, lambda t. [], lambda a. lambda b. lambda c. lambda s. lambda w. stepPerturb(a, b, s) <> w}
def word(a: Cell, z: Cell, d: Derivation(a, z)) -> Perturb[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepPerturb(a2, b, s) <> w, a, z, d)

# running the machine on the word replays the history to its endpoint
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

# ---------------------------------------------------------------------------
# §4  Vivarana: one object, its complete reading across the lens family;
#     two histories of the same interventions in a different order.
# ---------------------------------------------------------------------------
type Vivarana(a: Cell, z: Cell, d: Derivation(a, z)):
  case @reading:
    count: Nat
    tf_targeted: Bool
    tgt_targeted: Bool
    final: Cell
    trace: Perturb[]

def elucidate(a: Cell, z: Cell, d: Derivation(a, z)) -> Vivarana(a, z, d):
  @reading{steps(a, z, d), targeted(@tf, a, z, d), targeted(@tgt, a, z, d), endpoint(a, z, d), word(a, z, d)}

# the control cell, and two histories: knock tf then passage / passage then knock tf
def control() -> Cell:
  @cell{1n, 1n, 1n}
def kd_then_pass() -> Derivation(control(), @cell{0n, 0n, 1n}):
  @then{@cell{0n, 1n, 1n}, @act{@kd{@tf}, {==}},
    @then{@cell{0n, 0n, 1n}, @act{@passage, {==}},
      @done{{==}}}}
def pass_then_kd() -> Derivation(control(), @cell{0n, 1n, 1n}):
  @then{@cell{1n, 1n, 1n}, @act{@passage, {==}},
    @then{@cell{0n, 1n, 1n}, @act{@kd{@tf}, {==}},
      @done{{==}}}}

# identified by the length lens…
def same_length() -> Path(Nat, steps(control(), @cell{0n, 0n, 1n}, kd_then_pass()), steps(control(), @cell{0n, 1n, 1n}, pass_then_kd())):
  <_> 2n
# …and by the targeted-gene lens (neither history intervenes on tgt; both on tf)…
def same_tgt_targeted() -> Path(Bool, targeted(@tgt, control(), @cell{0n, 0n, 1n}, kd_then_pass()), targeted(@tgt, control(), @cell{0n, 1n, 1n}, pass_then_kd())):
  <_> False
def same_tf_targeted() -> Path(Bool, targeted(@tf, control(), @cell{0n, 0n, 1n}, kd_then_pass()), targeted(@tf, control(), @cell{0n, 1n, 1n}, pass_then_kd())):
  <_> True
# …separated by the endpoint lens: tgt reads 0 in one and 1 in the other.
# A protocol that scores "which genes were targeted" cannot see this; the
# endpoint protocol can; one object carries both facts.
def endpoints_differ(p: Path(Cell, endpoint(control(), @cell{0n, 0n, 1n}, kd_then_pass()), endpoint(control(), @cell{0n, 1n, 1n}, pass_then_kd()))) -> Empty:
  natEncode(0n, 1n, <i> tgtOf(p @ i))

# KRAMA.  Two knockdowns commute — the certificate is refl, so their
# serialisation is an artefact and either order is the same object…
def kd_kd_commute(c: Cell) -> Path(Cell, step(step(c, @kd{@tf}), @kd{@hk}), step(step(c, @kd{@hk}), @kd{@tf})):
  match c:
    case @cell{a, b, h}: <_> @cell{0n, b, 0n}
# …and knockdown against passage does not: the order is data, and it is
# exactly the data the endpoint lens read above.
def kd_pass_dont_commute(p: Path(Cell, step(step(control(), @kd{@tf}), @passage), step(step(control(), @passage), @kd{@tf}))) -> Empty:
  natEncode(0n, 1n, <i> tgtOf(p @ i))

# ---------------------------------------------------------------------------
# §5  The assay reads tgt only.  Meaning = Cell / future-behaviour.
# ---------------------------------------------------------------------------
def assayTgt(c: Cell) -> Nat:
  tgtOf(c)
def NerodeTgt(x: Cell, y: Cell) -> Set:
  Nerode(Cell, Perturb, Nat, step, assayTgt, x, y)
def MeaningTgt() -> Set:
  Meaning(Cell, Perturb, Nat, step, assayTgt)
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)

# (a) tf is never read by the assay, and it is NECESSARY: the future
#     [passage] separates two cells the assay cannot tell apart now.
def tf_is_necessary(h: NerodeTgt(@cell{1n, 0n, 0n}, @cell{0n, 0n, 0n})) -> Empty:
  natEncode(1n, 0n, h([@passage]))

# (b) hk is never read, and it is ERASABLE: cells agreeing on (tf, tgt)
#     agree on (tf, tgt) after every future — by induction on the word.
def AgreeVis(x: Cell, y: Cell) -> Set:
  any pa: Path(Nat, tfOf(x), tfOf(y)). Path(Nat, tgtOf(x), tgtOf(y))
def agree_run(a: Nat, b: Nat, h: Nat, a2: Nat, b2: Nat, h2: Nat, pa: Path(Nat, a, a2), pb: Path(Nat, b, b2), w: Perturb[]) -> AgreeVis(runC(@cell{a, b, h}, w), runC(@cell{a2, b2, h2}, w)):
  match w:
    case []: (pa, pb)
    case p <> rest:
      match p:
        case @kd{g}:
          match g:
            case @tf{}: agree_run(0n, b, h, 0n, b2, h2, <_> 0n, pb, rest)
            case @tgt{}: agree_run(a, 0n, h, a2, 0n, h2, pa, <_> 0n, rest)
            case @hk{}: agree_run(a, b, 0n, a2, b2, 0n, pa, pb, rest)
        case @passage{}: agree_run(a, a, h, a2, a2, h2, pa, pa, rest)
def visTgt(x: Cell, y: Cell, r: AgreeVis(x, y)) -> Path(Nat, tgtOf(x), tgtOf(y)):
  match r:
    case (pa, pb): pb
def hk_is_invisible(a: Nat, b: Nat, h: Nat, h2: Nat) -> NerodeTgt(@cell{a, b, h}, @cell{a, b, h2}):
  lambda w. visTgt(runC(@cell{a, b, h}, w), runC(@cell{a, b, h2}, w), agree_run(a, b, h, a, b, h2, <_> a, <_> b, w))

# so two cells differing only in hk have the same meaning…
def hk_same_meaning(a: Nat, b: Nat, h: Nat, h2: Nat) -> Path(MeaningTgt, @cl{@cell{a, b, h}}, @cl{@cell{a, b, h2}}):
  @eq{@cell{a, b, h}, @cell{a, b, h2}, hk_is_invisible(a, b, h, h2)}
# …and, by effectivity (generic, inherited), equal meaning is the same future
def meaning_is_future(x: Cell, y: Cell, p: Path(MeaningTgt, @cl{x}, @cl{y})) -> NerodeTgt(x, y):
  nerodeEffective(Cell, Perturb, Nat, step, setNat(), assayTgt, x, y, p)
# the two necessary cells have different meanings: no path, since a path would be a future-agreement
def tf_separates_meanings(p: Path(MeaningTgt, @cl{@cell{1n, 0n, 0n}}, @cl{@cell{0n, 0n, 0n}})) -> Empty:
  tf_is_necessary(meaning_is_future(@cell{1n, 0n, 0n}, @cell{0n, 0n, 0n}, p))

# ---------------------------------------------------------------------------
# §6  Erasure = descent.  Forgetting hk is the quotient by AgreeVis; a
#     receiver runs after the erasure iff it factors through it, and the
#     recursor's resp obligation is that factorisation.
# ---------------------------------------------------------------------------
def AgreeVisR() -> Cell -> Cell -> Set:
  lambda x. lambda y. AgreeVis(x, y)
def Erased() -> Set:
  Quotient(Cell, AgreeVisR())
def erase(c: Cell) -> Erased:
  @cl{c}

# a receiver that reads through (tf, tgt) descends: the obligation is inhabited
def visibleLoad(c: Cell) -> Nat:
  add(tfOf(c), tgtOf(c))
def visibleLoad_descends(x: Cell, y: Cell, r: AgreeVis(x, y)) -> Path(Nat, visibleLoad(x), visibleLoad(y)):
  match r:
    case (pa, pb): <i> add(pa @ i, pb @ i)
def visibleLoad_erased(m: Erased) -> Nat:
  quotRec(Cell, AgreeVisR(), Nat, setNat(), visibleLoad, visibleLoad_descends, m)
# and it computes on representatives: R = R̄ ∘ q, on the nose
def visibleLoad_factors(c: Cell) -> Path(Nat, visibleLoad_erased(erase(c)), visibleLoad(c)):
  <_> visibleLoad(c)
# the assay itself descends (it is the second projection of the agreement)
def assay_erased(m: Erased) -> Nat:
  quotRec(Cell, AgreeVisR(), Nat, setNat(), assayTgt, visTgt, m)
# the erasure is compatible with every generator: the machine descends too
def step_descends(x: Cell, y: Cell, r: AgreeVis(x, y), p: Perturb) -> Path(Erased, @cl{step(x, p)}, @cl{step(y, p)}):
  match x:
    case @cell{a, b, h}:
      match y:
        case @cell{a2, b2, h2}:
          match r:
            case (pa, pb):
              match p:
                case @kd{g}:
                  match g:
                    case @tf{}: @eq{@cell{0n, b, h}, @cell{0n, b2, h2}, (<_> 0n, pb)}
                    case @tgt{}: @eq{@cell{a, 0n, h}, @cell{a2, 0n, h2}, (pa, <_> 0n)}
                    case @hk{}: @eq{@cell{a, b, 0n}, @cell{a2, b2, 0n}, (pa, pb)}
                case @passage{}: @eq{@cell{a, a, h}, @cell{a2, a2, h2}, (pa, pa)}
def step_erased(m: Erased, p: Perturb) -> Erased:
  quotRec(Cell, AgreeVisR(), Erased, squash(Cell, AgreeVisR()), lambda c. @cl{step(c, p)}, lambda x. lambda y. lambda r. step_descends(x, y, r, p), m)
# (the receiver that reads hk does NOT descend — Perturbation_mustfail.bend)

# ---------------------------------------------------------------------------
# §7  The challenge shape.  A context is its control population; the
#     submission for intervention p is the population under p; a protocol
#     is a receiver over populations.  Pseudobulk of tgt descends through
#     the erasure cellwise, so it may be scored on the erased object.
# ---------------------------------------------------------------------------
def Context() -> Set:
  Cell[]
def predict(x: Context, p: Perturb) -> Context:
  map(Cell, Cell, lambda c. step(c, p), x)
def pseudobulkTgt(x: Context) -> Nat:
  match x:
    case []: 0n
    case c <> rest: add(tgtOf(c), pseudobulkTgt(rest))
def pseudobulkTgt_erased(x: Erased[]) -> Nat:
  match x:
    case []: 0n
    case m <> rest: add(assay_erased(m), pseudobulkTgt_erased(rest))
def pseudobulk_descends(x: Context) -> Path(Nat, pseudobulkTgt_erased(map(Cell, Erased, erase, x)), pseudobulkTgt(x)):
  match x:
    case []: <_> 0n
    case c <> rest: <i> add(tgtOf(c), pseudobulk_descends(rest) @ i)

# context A: three control cells; the submission for kd(tf) after one passage
def contextA() -> Context:
  [@cell{2n, 1n, 5n}, @cell{1n, 1n, 3n}, @cell{0n, 1n, 7n}]
def submissionA() -> Context:
  predict(predict(contextA(), @kd{@tf}), @passage)
def submissionA_pseudobulk() -> Path(Nat, pseudobulkTgt(submissionA()), 0n):
  <_> 0n
def controlA_pseudobulk() -> Path(Nat, pseudobulkTgt(predict(contextA(), @passage)), 3n):
  <_> 3n

def main() -> Nat:
  add(tgtOf(endpoint(control(), @cell{0n, 1n, 1n}, pass_then_kd())), pseudobulkTgt(predict(contextA(), @passage)))

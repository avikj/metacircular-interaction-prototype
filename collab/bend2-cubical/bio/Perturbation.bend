# Perturbation.bend — the 2026 virtual-cell task as ONE ordinary evaluation of the
# interaction calculus.  Nothing here is a new biological architecture: the file
# instantiates AdiBija (receiver + fold + uniqueness), Vivarana (one history, every
# reading at once), the port's Myhill–Nerode minimal machine (behavioural state
# forced by distinguishability under interventions), and Descent (erasure iff the
# requested reading descends; the fibre is the residue) on a FINITE PERTURBATIONAL
# PRESENTATION.
#
# HONEST SCOPE.  The presentation is a toy stand-in for the boundary the Virtual
# Cell Challenge exposes (unperturbed cells + knockdown identities): four gene
# coordinates, three CRISPRi-style generators, one reporter observation.  The
# regulatory rules below are DECLARED, not learned from Tahoe/Perturb-seq.  What is
# checked is the machine, not a biological claim: every construction is the same
# one the corpus runs on rewrite derivations, applied unchanged to this table.
import Descent

# The port's Myhill–Nerode file (port/MyhillNerodeMinimalMachine.bend) takes
# minutes to re-check, so its four definitions used here are repeated VERBATIM
# rather than imported: observed transition systems, behaviours, the Nerode
# congruence, and the minimal machine's state space Meaning = X / Nerode.
def run(X: Set, A: Set, step: X -> A -> X, x: X, w: A[]) -> X:
  match w:
    case []: x
    case a <> rest: run(X, A, step, step(x, a), rest)
def behavior(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, w: A[]) -> O:
  observe(run(X, A, step, x, w))
def Nerode(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O, x: X, y: X) -> Set:
  all w: A[]. Path(O, behavior(X, A, O, step, observe, x, w), behavior(X, A, O, step, observe, y, w))
def NerodeR(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> X -> X -> Set:
  lambda x. lambda y. Nerode(X, A, O, step, observe, x, y)
def Meaning(X: Set, A: Set, O: Set, step: X -> A -> X, observe: X -> O) -> Set:
  Quotient(X, NerodeR(X, A, O, step, observe))

# ---- 0. the finite presentation --------------------------------------------
# a cell: a transcription factor, its target, a reporter, and a hidden gene
type Cell:
  case @cell:
    tf: Nat
    tg: Nat
    rp: Nat
    hd: Nat

# the generators: CRISPRi knockdowns
type Act:
  case @kdTF:
  case @kdTG:
  case @kdHD:

# the declared regulatory response to a knockdown (toy mechanism):
#   TF represses TG: removing TF releases TG by TF's level
#   TG represses RP: removing TG releases RP by TG's level
#   HD is a sink: nothing reads it, it reads nothing
def step(c: Cell, a: Act) -> Cell:
  match c:
    case @cell{tf, tg, rp, hd}:
      match a:
        case @kdTF{}: @cell{0n, add(tf, tg), rp, hd}
        case @kdTG{}: @cell{tf, 0n, add(tg, rp), hd}
        case @kdHD{}: @cell{tf, tg, rp, 0n}

def SF() -> Cell -> Act -> Cell:
  lambda x. lambda a. step(x, a)

# what the assay sees: the reporter, through the visible projection
type Vis:
  case @vis:
    tf: Nat
    tg: Nat
    rp: Nat
def vis(c: Cell) -> Vis:
  match c:
    case @cell{tf, tg, rp, hd}: @vis{tf, tg, rp}
def rpV(v: Vis) -> Nat:
  match v:
    case @vis{tf, tg, rp}: rp
def observe(c: Cell) -> Nat:
  rpV(vis(c))
def OB() -> Cell -> Nat:
  lambda c. observe(c)
def hdOf(c: Cell) -> Nat:
  match c:
    case @cell{tf, tg, rp, hd}: hd
def rpOf(c: Cell) -> Nat:
  match c:
    case @cell{tf, tg, rp, hd}: rp

# an experiment is a word of generators; its endpoint is the port's `run`
def perturb(c: Cell, w: Act[]) -> Cell:
  run(Cell, Act, SF(), c, w)

# ---- 1. AdiBija on the perturbational generators: receiver, fold, uniqueness --
# A receiver of the experiment's motion: a carrier per (start, end) and an action
# for every generating step.  Give the actions and every reading is forced.
type Receiver:
  case @receiver:
    Motion: Cell -> Cell -> Set
    eps: all t: Cell. Motion(t, t)
    cons: all x: Cell. all a: Act. all z: Cell. Motion(step(x, a), z) -> Motion(x, z)

def rMotion(R: Receiver, x: Cell, z: Cell) -> Set:
  match R:
    case @receiver{M, e, c}: M(x, z)
def rEps(R: Receiver, t: Cell) -> rMotion(R, t, t):
  match R:
    case @receiver{M, e, c}: e(t)
def rCons(R: Receiver, x: Cell, a: Act, z: Cell, m: rMotion(R, step(x, a), z)) -> rMotion(R, x, z):
  match R:
    case @receiver{M, e, c}: c(x, a, z, m)

# §1 the fold exists
def fold(R: Receiver, x: Cell, w: Act[]) -> rMotion(R, x, perturb(x, w)):
  match w:
    case []: rEps(R, x)
    case a <> rest: rCons(R, x, a, perturb(step(x, a), rest), fold(R, step(x, a), rest))

# §2 the fold is unique: anything with its two computation rules is it
def fold_unique(R: Receiver,
                g: all x: Cell. all w: Act[]. rMotion(R, x, perturb(x, w)),
                g_nil: all x: Cell. Path(rMotion(R, x, x), g(x, []), rEps(R, x)),
                g_cons: all x: Cell. all a: Act. all rest: Act[].
                        Path(rMotion(R, x, perturb(step(x, a), rest)), g(x, a <> rest), rCons(R, x, a, perturb(step(x, a), rest), g(step(x, a), rest))),
                x: Cell, w: Act[]) -> Path(rMotion(R, x, perturb(x, w)), g(x, w), fold(R, x, w)):
  match w:
    case []: g_nil(x)
    case a <> rest:
      compPath(rMotion(R, x, perturb(step(x, a), rest)),
        g(x, a <> rest),
        rCons(R, x, a, perturb(step(x, a), rest), g(step(x, a), rest)),
        rCons(R, x, a, perturb(step(x, a), rest), fold(R, step(x, a), rest)),
        g_cons(x, a, rest),
        cong(rMotion(R, step(x, a), perturb(step(x, a), rest)), rMotion(R, x, perturb(step(x, a), rest)),
             lambda m. rCons(R, x, a, perturb(step(x, a), rest), m),
             g(step(x, a), rest), fold(R, step(x, a), rest),
             fold_unique(R, g, g_nil, g_cons, step(x, a), rest)))

# ---- 2. the receiver family: scPertEval-style protocols as receivers ----------
# (a) COST: the number of interventions
def lenR() -> Receiver:
  @receiver{lambda x. lambda z. Nat, lambda t. 0n, lambda x. lambda a. lambda z. lambda n. 1n + n}
def steps(x: Cell, w: Act[]) -> Nat:
  fold(lenR(), x, w)
# ...and it is the list length, by uniqueness, not by rewriting
def steps_is_length(x: Cell, w: Act[]) -> Path(Nat, length(Act, w), steps(x, w)):
  fold_unique(lenR(), lambda x2. lambda w2. length(Act, w2), lambda x2. <_> 0n, lambda x2. lambda a. lambda rest. <_> 1n + length(Act, rest), x, w)

# (b) DIFFERENTIAL EXPRESSION as an evaluator integral: each step contributes the
#     number of gene coordinates it changes
def natEqb(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: True
        case 1n + q: False
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: natEqb(p, q)
def diffb(a: Nat, b: Nat) -> Nat:
  match natEqb(a, b):
    case True: 0n
    case False: 1n
def changed(x: Cell, y: Cell) -> Nat:
  match x:
    case @cell{a, b, c, d}:
      match y:
        case @cell{a2, b2, c2, d2}: add(diffb(a, a2), add(diffb(b, b2), add(diffb(c, c2), diffb(d, d2))))
def degR() -> Receiver:
  @receiver{lambda x. lambda z. Nat, lambda t. 0n, lambda x. lambda a. lambda z. lambda n. add(changed(x, step(x, a)), n)}
def deg(x: Cell, w: Act[]) -> Nat:
  fold(degR(), x, w)

# (c) MEANING: the visible transcript mass is conserved by every generator, so a
#     derivation certifies an endpoint equation — the analogue of derivation-sound
def massVis(v: Vis) -> Nat:
  match v:
    case @vis{tf, tg, rp}: add(tf, add(tg, rp))
def massV(c: Cell) -> Nat:
  massVis(vis(c))
def addAssoc(a: Nat, b: Nat, c: Nat) -> Path(Nat, add(add(a, b), c), add(a, add(b, c))):
  match a:
    case 0n: <_> add(b, c)
    case 1n + p: <i> 1n + (addAssoc(p, b, c) @ i)
def stepMass(c: Cell, a: Act) -> Path(Nat, massV(c), massV(step(c, a))):
  match c:
    case @cell{tf, tg, rp, hd}:
      match a:
        case @kdTF{}: sym(Nat, add(add(tf, tg), rp), add(tf, add(tg, rp)), addAssoc(tf, tg, rp))
        case @kdTG{}: <_> add(tf, add(tg, rp))
        case @kdHD{}: <_> add(tf, add(tg, rp))
def massR() -> Receiver:
  @receiver{lambda x. lambda z. Path(Nat, massV(x), massV(z)),
            lambda t. <_> massV(t),
            lambda x. lambda a. lambda z. lambda m. compPath(Nat, massV(x), massV(step(x, a)), massV(z), stepMass(x, a), m)}
# the hand-written soundness, as the corpus writes derivation-sound...
def massSound(x: Cell, w: Act[]) -> Path(Nat, massV(x), massV(perturb(x, w))):
  match w:
    case []: <_> massV(x)
    case a <> rest: compPath(Nat, massV(x), massV(step(x, a)), massV(perturb(step(x, a), rest)), stepMass(x, a), massSound(step(x, a), rest))
# ...IS the fold at massR, by uniqueness
def massSound_is_fold(x: Cell, w: Act[]) -> Path(Path(Nat, massV(x), massV(perturb(x, w))), massSound(x, w), fold(massR(), x, w)):
  fold_unique(massR(), lambda x2. lambda w2. massSound(x2, w2), lambda x2. <_> <_> massV(x2), lambda x2. lambda a. lambda rest. <_> massSound(x2, a <> rest), x, w)

# ---- 3. Vivarana: one experiment, its complete reading across the family -------
type Reading(x: Cell, w: Act[]):
  case @reading:
    cost: Nat
    de: Nat
    meaning: Path(Nat, massV(x), massV(perturb(x, w)))
def elucidate(x: Cell, w: Act[]) -> Reading(x, w):
  @reading{fold(lenR(), x, w), fold(degR(), x, w), fold(massR(), x, w)}
def rCost(x: Cell, w: Act[], r: Reading(x, w)) -> Nat:
  match r:
    case @reading{c, d, m}: c
def rDE(x: Cell, w: Act[], r: Reading(x, w)) -> Nat:
  match r:
    case @reading{c, d, m}: d
def rMeaning(x: Cell, w: Act[], r: Reading(x, w)) -> Path(Nat, massV(x), massV(perturb(x, w))):
  match r:
    case @reading{c, d, m}: m
# the semantic component is forced to be the hand-written soundness
def elucidation_is_canonical(x: Cell, w: Act[]) -> Path(Path(Nat, massV(x), massV(perturb(x, w))), rMeaning(x, w, elucidate(x, w)), massSound(x, w)):
  sym(Path(Nat, massV(x), massV(perturb(x, w))), massSound(x, w), fold(massR(), x, w), massSound_is_fold(x, w))

# two coterminal experimental histories on one cell: direct and detour
def x0() -> Cell:
  @cell{1n, 2n, 0n, 0n}
def direct() -> Act[]:
  [@kdTF, @kdTG]
def detour() -> Act[]:
  [@kdTG, @kdTF, @kdTG]
def coterminal() -> Path(Cell, perturb(x0(), direct()), perturb(x0(), detour())):
  <_> @cell{0n, 0n, 3n, 0n}
def directProfile() -> Path(Nat, rCost(x0(), direct(), elucidate(x0(), direct())), 2n):
  <_> 2n
def detourProfile() -> Path(Nat, rCost(x0(), detour(), elucidate(x0(), detour())), 3n):
  <_> 3n
def directDE() -> Path(Nat, rDE(x0(), direct(), elucidate(x0(), direct())), 4n):
  <_> 4n
def detourDE() -> Path(Nat, rDE(x0(), detour(), elucidate(x0(), detour())), 6n):
  <_> 6n
# the cost lens and the DE lens keep the two histories apart...
def costs_differ(p: Path(Nat, rCost(x0(), direct(), elucidate(x0(), direct())), rCost(x0(), detour(), elucidate(x0(), detour())))) -> Empty:
  natEncode(2n, 3n, p)
def de_differ(p: Path(Nat, rDE(x0(), direct(), elucidate(x0(), direct())), rDE(x0(), detour(), elucidate(x0(), detour())))) -> Empty:
  natEncode(4n, 6n, p)
# ...while the meaning lens reads both as the same endpoint equation (Nat is a set)
def meanings_agree() -> Path(Path(Nat, 3n, 3n), rMeaning(x0(), direct(), elucidate(x0(), direct())), rMeaning(x0(), detour(), elucidate(x0(), detour()))):
  isSetNat(3n, 3n, rMeaning(x0(), direct(), elucidate(x0(), direct())), rMeaning(x0(), detour(), elucidate(x0(), detour())))

# ---- 4. commutation is structure, not a scheduling choice ---------------------
# independent generators commute, for every cell, definitionally
def hd_commutes(c: Cell) -> Path(Cell, perturb(c, [@kdTF, @kdHD]), perturb(c, [@kdHD, @kdTF])):
  match c:
    case @cell{tf, tg, rp, hd}: <_> @cell{0n, add(tf, tg), rp, 0n}
# dependent generators do not: the order of TF and TG knockdowns is an exact residue
def x1() -> Cell:
  @cell{1n, 0n, 0n, 0n}
def order_matters(p: Path(Cell, perturb(x1(), [@kdTF, @kdTG]), perturb(x1(), [@kdTG, @kdTF]))) -> Empty:
  natEncode(1n, 0n, <i> rpOf(p @ i))
# a knockdown is not invertible: its fibre is what it erased (two distinct preimages)
def c0() -> Cell:
  @cell{0n, 0n, 0n, 0n}
def c1() -> Cell:
  @cell{0n, 0n, 0n, 1n}
def kdHD_collapses() -> Path(Cell, step(c0(), @kdHD), step(c1(), @kdHD)):
  <_> @cell{0n, 0n, 0n, 0n}
def c0_c1_distinct(p: Path(Cell, c0(), c1())) -> Empty:
  natEncode(0n, 1n, <i> hdOf(p @ i))
def kdHD_fibre0() -> fiber(Cell, Cell, lambda c. step(c, @kdHD), c0()):
  (c0(), <_> c0())
def kdHD_fibre1() -> fiber(Cell, Cell, lambda c. step(c, @kdHD), c0()):
  (c1(), <_> c0())
def kdHD_fibre_not_contractible(p: Path(fiber(Cell, Cell, lambda c. step(c, @kdHD), c0()), kdHD_fibre0(), kdHD_fibre1())) -> Empty:
  c0_c1_distinct(<i> fst(Cell, lambda c. Path(Cell, step(c, @kdHD), c0()), p @ i))

# ---- 5. behavioural state: the Nerode quotient under the intervention algebra --
# The port's Nerode: x ~ y iff every experiment w gives the same observation.
def stepVis(v: Vis, a: Act) -> Vis:
  match v:
    case @vis{tf, tg, rp}:
      match a:
        case @kdTF{}: @vis{0n, add(tf, tg), rp}
        case @kdTG{}: @vis{tf, 0n, add(tg, rp)}
        case @kdHD{}: @vis{tf, tg, rp}
def visStep(c: Cell, a: Act) -> Path(Vis, vis(step(c, a)), stepVis(vis(c), a)):
  match c:
    case @cell{tf, tg, rp, hd}:
      match a:
        case @kdTF{}: <_> @vis{0n, add(tf, tg), rp}
        case @kdTG{}: <_> @vis{tf, 0n, add(tg, rp)}
        case @kdHD{}: <_> @vis{tf, tg, rp}
def runVis(v: Vis, w: Act[]) -> Vis:
  match w:
    case []: v
    case a <> rest: runVis(stepVis(v, a), rest)
# the visible projection commutes with every experiment
def visRun(c: Cell, w: Act[]) -> Path(Vis, vis(perturb(c, w)), runVis(vis(c), w)):
  match w:
    case []: <_> vis(c)
    case a <> rest:
      compPath(Vis, vis(perturb(step(c, a), rest)), runVis(vis(step(c, a)), rest), runVis(stepVis(vis(c), a), rest),
        visRun(step(c, a), rest),
        cong(Vis, Vis, lambda v. runVis(v, rest), vis(step(c, a)), stepVis(vis(c), a), visStep(c, a)))
def observeVia(c: Cell, w: Act[]) -> Path(Nat, observe(perturb(c, w)), rpV(runVis(vis(c), w))):
  cong(Vis, Nat, lambda v. rpV(v), vis(perturb(c, w)), runVis(vis(c), w), visRun(c, w))

# THEOREM: the hidden gene is behaviourally invisible — two cells differing only
# in hd are Nerode-equivalent under EVERY experiment (a proof for all words w)
def hidden_nerode(tf: Nat, tg: Nat, rp: Nat, h1: Nat, h2: Nat) -> Nerode(Cell, Act, Nat, SF(), OB(), @cell{tf, tg, rp, h1}, @cell{tf, tg, rp, h2}):
  lambda w. compPath(Nat, observe(perturb(@cell{tf, tg, rp, h1}, w)), rpV(runVis(@vis{tf, tg, rp}, w)), observe(perturb(@cell{tf, tg, rp, h2}, w)),
    observeVia(@cell{tf, tg, rp, h1}, w),
    sym(Nat, observe(perturb(@cell{tf, tg, rp, h2}, w)), rpV(runVis(@vis{tf, tg, rp}, w)), observeVia(@cell{tf, tg, rp, h2}, w)))
# so they are ONE state of the minimal machine (the port's Meaning = Cell / Nerode)
def same_state(tf: Nat, tg: Nat, rp: Nat, h1: Nat, h2: Nat) -> Path(Meaning(Cell, Act, Nat, SF(), OB()), @cl{@cell{tf, tg, rp, h1}}, @cl{@cell{tf, tg, rp, h2}}):
  @eq{@cell{tf, tg, rp, h1}, @cell{tf, tg, rp, h2}, hidden_nerode(tf, tg, rp, h1, h2)}

# THEOREM: a difference in TF is invisible to every experiment of length ≤ 1 and
# is separated by the continuation [kdTF, kdTG]: state is what the FUTURE can tell
def x2() -> Cell:
  @cell{2n, 0n, 0n, 0n}
def y2() -> Cell:
  @cell{1n, 0n, 0n, 0n}
def blind_now() -> Path(Nat, behavior(Cell, Act, Nat, SF(), OB(), x2(), []), behavior(Cell, Act, Nat, SF(), OB(), y2(), [])):
  <_> 0n
def blind_TF() -> Path(Nat, behavior(Cell, Act, Nat, SF(), OB(), x2(), [@kdTF]), behavior(Cell, Act, Nat, SF(), OB(), y2(), [@kdTF])):
  <_> 0n
def blind_TG() -> Path(Nat, behavior(Cell, Act, Nat, SF(), OB(), x2(), [@kdTG]), behavior(Cell, Act, Nat, SF(), OB(), y2(), [@kdTG])):
  <_> 0n
def blind_HD() -> Path(Nat, behavior(Cell, Act, Nat, SF(), OB(), x2(), [@kdHD]), behavior(Cell, Act, Nat, SF(), OB(), y2(), [@kdHD])):
  <_> 0n
def separating_word() -> Act[]:
  [@kdTF, @kdTG]
def separated(h: Nerode(Cell, Act, Nat, SF(), OB(), x2(), y2())) -> Empty:
  natEncode(2n, 1n, h(separating_word()))

# ---- 6. the behavioural compression curve: a chain of quotients, every receiver
#         classified by the descent checker at every rung ------------------------
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)
def total(c: Cell) -> Nat:
  match c:
    case @cell{tf, tg, rp, hd}: add(tf, add(tg, add(rp, hd)))

# q1 : erase the hidden gene.   R1 x y := vis x = vis y
def R1(x: Cell, y: Cell) -> Set:
  Path(Vis, vis(x), vis(y))
def Z1() -> Set:
  Quotient(Cell, lambda x. lambda y. R1(x, y))
#   reporter ✓   mass ✓   total ✗
def reporter_q1() -> Descends(Cell, lambda x. lambda y. R1(x, y), Nat, lambda c. observe(c)):
  lambda x. lambda y. lambda r. <i> rpV(r @ i)
def mass_q1() -> Descends(Cell, lambda x. lambda y. R1(x, y), Nat, lambda c. massV(c)):
  lambda x. lambda y. lambda r. <i> massVis(r @ i)
def total_q1(d: Descends(Cell, lambda x. lambda y. R1(x, y), Nat, lambda c. total(c))) -> Empty:
  refuse(Cell, lambda x. lambda y. R1(x, y), lambda c. total(c), c0(), c1(), <_> @vis{0n, 0n, 0n}, lambda e. e, d)
def reporter_on_Z1(m: Z1) -> Nat:
  erase(Cell, lambda x. lambda y. R1(x, y), Nat, setNat(), lambda c. observe(c), reporter_q1(), m)

# q2 : also erase the transcription factor.   R2 x y := (tg x, rp x) = (tg y, rp y)
type Vis2:
  case @vis2:
    tg: Nat
    rp: Nat
def vis2(c: Cell) -> Vis2:
  match c:
    case @cell{tf, tg, rp, hd}: @vis2{tg, rp}
def rpV2(v: Vis2) -> Nat:
  match v:
    case @vis2{tg, rp}: rp
def R2(x: Cell, y: Cell) -> Set:
  Path(Vis2, vis2(x), vis2(y))
def Z2() -> Set:
  Quotient(Cell, lambda x. lambda y. R2(x, y))
#   reporter ✓   mass ✗   total ✗
def obs_vis2(c: Cell) -> Path(Nat, observe(c), rpV2(vis2(c))):
  match c:
    case @cell{tf, tg, rp, hd}: <_> rp
def reporter_q2() -> Descends(Cell, lambda x. lambda y. R2(x, y), Nat, lambda c. observe(c)):
  lambda x. lambda y. lambda r. compPath3(Nat, observe(x), rpV2(vis2(x)), rpV2(vis2(y)), observe(y), obs_vis2(x), <i> rpV2(r @ i), sym(Nat, observe(y), rpV2(vis2(y)), obs_vis2(y)))
def c2() -> Cell:
  @cell{1n, 0n, 0n, 0n}
def mass_q2(d: Descends(Cell, lambda x. lambda y. R2(x, y), Nat, lambda c. massV(c))) -> Empty:
  refuse(Cell, lambda x. lambda y. R2(x, y), lambda c. massV(c), c0(), c2(), <_> @vis2{0n, 0n}, lambda e. e, d)
def total_q2(d: Descends(Cell, lambda x. lambda y. R2(x, y), Nat, lambda c. total(c))) -> Empty:
  refuse(Cell, lambda x. lambda y. R2(x, y), lambda c. total(c), c0(), c2(), <_> @vis2{0n, 0n}, lambda e. e, d)
#   but the CONTINUATION reporter (reporter after kdTF then kdTG) ✗ at q2 — the
#   distinction q2 destroys is exactly what the separating experiment needs
def future_reporter(c: Cell) -> Nat:
  observe(perturb(c, separating_word()))
def future_q1() -> Descends(Cell, lambda x. lambda y. R1(x, y), Nat, lambda c. future_reporter(c)):
  lambda x. lambda y. lambda r. compPath3(Nat, future_reporter(x), rpV(runVis(vis(x), separating_word())), rpV(runVis(vis(y), separating_word())), future_reporter(y),
    observeVia(x, separating_word()), <i> rpV(runVis(r @ i, separating_word())), sym(Nat, future_reporter(y), rpV(runVis(vis(y), separating_word())), observeVia(y, separating_word())))
def future_q2(d: Descends(Cell, lambda x. lambda y. R2(x, y), Nat, lambda c. future_reporter(c))) -> Empty:
  refuse(Cell, lambda x. lambda y. R2(x, y), lambda c. future_reporter(c), x2(), y2(), <_> @vis2{0n, 0n}, lambda e. e, d)

# the residue at q1, exhibited: the fibre over one class holds two distinct cells
def q1(c: Cell) -> Z1:
  @cl{c}
def q1_fibre0() -> fiber(Cell, Z1, lambda c. q1(c), q1(c0())):
  (c0(), <_> q1(c0()))
def q1_fibre1() -> fiber(Cell, Z1, lambda c. q1(c), q1(c0())):
  (c1(), @eq{c1(), c0(), <_> @vis{0n, 0n, 0n}})
def q1_residue_is_hd(p: Path(fiber(Cell, Z1, lambda c. q1(c), q1(c0())), q1_fibre0(), q1_fibre1())) -> Empty:
  c0_c1_distinct(<i> fst(Cell, lambda c. Path(Z1, q1(c), q1(c0())), p @ i))
# and the cell IS its class plus that residue — the fibre law, transported
def cell_is_class_plus_residue() -> Equiv(Cell, Total(Cell, Z1, lambda c. q1(c))):
  totalEquiv(Cell, Z1, lambda c. q1(c))

# ---- 7. naturality across context: the transport square and its three outcomes -
# T12: a second context that differs only in the hidden gene (a shift of hd)
def T12(c: Cell) -> Cell:
  match c:
    case @cell{tf, tg, rp, hd}: @cell{tf, tg, rp, 1n + hd}
# T13: a context in which the regulator roles are exchanged
def T13(c: Cell) -> Cell:
  match c:
    case @cell{tf, tg, rp, hd}: @cell{tg, tf, rp, hd}
# (i) COMMUTES on the nose: the TF mechanism transports to context 2
def square_TF_T12(c: Cell) -> Path(Cell, T12(step(c, @kdTF)), step(T12(c), @kdTF)):
  match c:
    case @cell{tf, tg, rp, hd}: <_> @cell{0n, add(tf, tg), rp, 1n + hd}
# (ii) COMMUTES AFTER A QUOTIENT: the HD knockdown does not transport as cells...
def square_HD_T12_fails(p: Path(Cell, T12(step(c0(), @kdHD)), step(T12(c0()), @kdHD))) -> Empty:
  natEncode(1n, 0n, <i> hdOf(p @ i))
#     ...but does at the visible reading q1 (conserved at one reading, not another)
def square_HD_T12_vis(c: Cell) -> Path(Vis, vis(T12(step(c, @kdHD))), vis(step(T12(c), @kdHD))):
  match c:
    case @cell{tf, tg, rp, hd}: <_> @vis{tf, tg, rp}
def square_HD_T12_Z1(c: Cell) -> Path(Z1, q1(T12(step(c, @kdHD))), q1(step(T12(c), @kdHD))):
  @eq{T12(step(c, @kdHD)), step(T12(c), @kdHD), square_HD_T12_vis(c)}
# (iii) DOES NOT FILL: the TG mechanism is obstructed in the exchanged context even
#       at the coarsest reading (the reporter itself)
def square_TG_T13_obstructed(p: Path(Nat, observe(T13(step(x0(), @kdTG))), observe(step(T13(x0()), @kdTG)))) -> Empty:
  natEncode(2n, 1n, p)

# ---- 8. the VCC-shaped artefact: predict a withheld perturbation on a control
#         population, then read it through the receiver family ------------------
def predict(control: Cell[], g: Act) -> Cell[]:
  map(Cell, Cell, lambda c. step(c, g), control)
def sumRp(pop: Cell[]) -> Nat:
  match pop:
    case []: 0n
    case c <> rest: add(observe(c), sumRp(rest))
def sumDE(control: Cell[], pop: Cell[]) -> Nat:
  match control:
    case []: 0n
    case c <> rest:
      match pop:
        case []: 0n
        case p <> prest: add(changed(c, p), sumDE(rest, prest))
def control() -> Cell[]:
  [@cell{2n, 1n, 0n, 3n}, @cell{1n, 2n, 0n, 0n}, @cell{3n, 0n, 1n, 1n}, @cell{0n, 1n, 1n, 2n}]
# pseudobulk reporter of the predicted double knockdown, and its DE count
def pseudobulk() -> Path(Nat, sumRp(predict(predict(control(), @kdTF), @kdTG)), 12n):
  <_> 12n
def de_count() -> Path(Nat, sumDE(control(), predict(control(), @kdTF)), 6n):
  <_> 6n

def main() -> Nat:
  sumRp(predict(predict(control(), @kdTF), @kdTG))

# vcc/Perturb.bend — the perturbation machine on a finite cell population.
#
# The 2026 Virtual Cell Challenge as a finite presentation of the corpus's
# machine. A context IS its finite control population (cells × genes, fixed
# point). An intervention IS its identity (the CRISPRi target). A
# perturbational generator is a shift in log-expression space, installed from
# training data. Derivations are the AdiBija kernel indexed by populations;
# every readout protocol is a Receiver read by the one recursor `fold`; the
# receiver family is read at once by the product receiver (Vivarana); the
# behavioural relation is the Nerode congruence of MyhillNerodeMinimalMachine
# with observe = the (count, sum) statistic; the proposed erasure of the
# population to that statistic is decided by DESCENT (erasure.bend): it
# descends for pure up-shift knowledge (a theorem, fully general in the
# population and the knowledge), it is REFUTED under the floor effect (a
# constructive counterexample), and where it fails the exact fibre is what is
# retained (Carrier).
import MyhillNerodeMinimalMachine
import Carrier

# ---- 0. the numeric carrier: U64 at runtime (32-bit words in HVM4), Nat for the laws
type Numeric:
  case @numeric:
    T: Set
    nzero: T
    none: T
    nadd: T -> T -> T
    nsub: T -> T -> T
    nlt: T -> T -> Bool
    ndiv: T -> T -> T
    nmul: T -> T -> T
def Num(num: Numeric) -> Set:
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: T
def nzero(num: Numeric) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: z
def none(num: Numeric) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: o
def nadd(num: Numeric, x: Num(num), y: Num(num)) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: a(x, y)
def nsub(num: Numeric, x: Num(num), y: Num(num)) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: s(x, y)
def nlt(num: Numeric, x: Num(num), y: Num(num)) -> Bool:
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: l(x, y)
def ndiv(num: Numeric, x: Num(num), y: Num(num)) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: d(x, y)
def nmul(num: Numeric, x: Num(num), y: Num(num)) -> Num(num):
  match num:
    case @numeric{T, z, o, a, s, l, d, m}: m(x, y)
# |x - y|
def ndist(num: Numeric, x: Num(num), y: Num(num)) -> Num(num):
  if nlt(num, x, y): nsub(num, y, x) else: nsub(num, x, y)

# the two laws the descent theorem needs (discharged for Nat below; U64's
# primitive operations carry no axioms inside Bend2, so they cannot be stated
# for U64 — the runtime instance runs the same definitions without them)
type NumLaws(num: Numeric):
  case @laws:
    addAssoc: all x: Num(num). all y: Num(num). all z: Num(num). Path(Num(num), nadd(num, nadd(num, x, y), z), nadd(num, x, nadd(num, y, z)))
    addComm: all x: Num(num). all y: Num(num). Path(Num(num), nadd(num, x, y), nadd(num, y, x))
def addAssoc(num: Numeric, L: NumLaws(num), x: Num(num), y: Num(num), z: Num(num)) -> Path(Num(num), nadd(num, nadd(num, x, y), z), nadd(num, x, nadd(num, y, z))):
  match L:
    case @laws{asc, com}: asc(x, y, z)
def addComm(num: Numeric, L: NumLaws(num), x: Num(num), y: Num(num)) -> Path(Num(num), nadd(num, x, y), nadd(num, y, x)):
  match L:
    case @laws{asc, com}: com(x, y)

# ---- 1. expression vectors, cells, populations
def Vec(num: Numeric) -> Set:
  Num(num)[]
def Pop(num: Numeric) -> Set:
  Vec(num)[]
# [] is the zero vector of every dimension, so vadd is total with [] as unit
def vadd(num: Numeric, xs: Vec(num), ys: Vec(num)) -> Vec(num):
  match xs:
    case []: ys
    case h <> t:
      match ys:
        case []: h <> t
        case k <> u: nadd(num, h, k) <> vadd(num, t, u)
# pointwise truncated subtraction: expression has a floor at zero (the floor effect)
def vsub(num: Numeric, xs: Vec(num), ys: Vec(num)) -> Vec(num):
  match ys:
    case []: xs
    case k <> u:
      match xs:
        case []: []
        case h <> t: nsub(num, h, k) <> vsub(num, t, u)
def vsum(num: Numeric, P: Pop(num)) -> Vec(num):
  match P:
    case []: []
    case c <> rest: vadd(num, c, vsum(num, rest))
def plen(num: Numeric, P: Pop(num)) -> Nat:
  match P:
    case []: 0n
    case c <> rest: 1n + plen(num, rest)
def fromNat(num: Numeric, n: Nat) -> Num(num):
  match n:
    case 0n: nzero(num)
    case 1n + p: nadd(num, none(num), fromNat(num, p))
def vscale(num: Numeric, k: Nat, u: Vec(num)) -> Vec(num):
  match k:
    case 0n: []
    case 1n + p: vadd(num, u, vscale(num, p, u))
def vdivN(num: Numeric, xs: Vec(num), n: Num(num)) -> Vec(num):
  match xs:
    case []: []
    case h <> t: ndiv(num, h, n) <> vdivN(num, t, n)
def vtotal(num: Numeric, xs: Vec(num)) -> Num(num):
  match xs:
    case []: nzero(num)
    case h <> t: nadd(num, h, vtotal(num, t))
# L1 distance
def vl1(num: Numeric, xs: Vec(num), ys: Vec(num)) -> Num(num):
  match xs:
    case []: vtotal(num, ys)
    case h <> t:
      match ys:
        case []: vtotal(num, h <> t)
        case k <> u: nadd(num, ndist(num, h, k), vl1(num, t, u))

# the (count, sum) statistic, as one vector: the count first, then the gene sums
def stat(num: Numeric, P: Pop(num)) -> Vec(num):
  fromNat(num, plen(num, P)) <> vsum(num, P)
# pseudobulk (the mean profile) is a READOUT of the statistic
def meanOfStat(num: Numeric, s: Vec(num)) -> Vec(num):
  match s:
    case []: []
    case n <> sums: vdivN(num, sums, n)
def pseudobulk(num: Numeric, P: Pop(num)) -> Vec(num):
  meanOfStat(num, stat(num, P))

# ---- 2. interventions (by identity) and perturbational generators
type Intervention:
  case @ntc:
  case @kd:
    target: U64
type Generator(num: Numeric):
  case @shift:
    up: Vec(num)
    down: Vec(num)
def applyGen(num: Numeric, g: Generator(num), c: Vec(num)) -> Vec(num):
  match g:
    case @shift{u, d}: vsub(num, vadd(num, c, u), d)
def perturb(num: Numeric, g: Generator(num), P: Pop(num)) -> Pop(num):
  match P:
    case []: []
    case c <> rest: applyGen(num, g, c) <> perturb(num, g, rest)
# installed knowledge: a generator per intervention
def Knowledge(num: Numeric) -> Set:
  Intervention -> Generator(num)
def stepK(num: Numeric, K: Knowledge(num), P: Pop(num), a: Intervention) -> Pop(num):
  perturb(num, K(a), P)
# pure up-shift knowledge (no floor effect can trigger)
def Kup(num: Numeric, u: Intervention -> Vec(num)) -> Knowledge(num):
  lambda a. @shift{u(a), []}

# ---- 3. the kernel (AdiBija): steps and derivations indexed by populations
type PStep(num: Numeric, K: Knowledge(num), s: Pop(num), t: Pop(num)):
  case @act:
    a: Intervention
    et: Pop(num){t == stepK(num, K, s, a)}
type Deriv(num: Numeric, K: Knowledge(num), s: Pop(num), t: Pop(num)):
  case @done:
    e: Pop(num){t == s}
  case @then:
    m: Pop(num)
    st: PStep(num, K, s, m)
    d: Deriv(num, K, m, t)

# a receiver of the kernel's motion (AdiBija §0)
type Receiver(num: Numeric, K: Knowledge(num)):
  case @receiver:
    Motion: Pop(num) -> Pop(num) -> Set
    eps: all s: Pop(num). Motion(s, s)
    act: all a: Pop(num). all b: Pop(num). all c: Pop(num). PStep(num, K, a, b) -> Motion(b, c) -> Motion(a, c)
def Motion(num: Numeric, K: Knowledge(num), R: Receiver(num, K), a: Pop(num), b: Pop(num)) -> Set:
  match R:
    case @receiver{M, e, ac}: M(a, b)
def eps(num: Numeric, K: Knowledge(num), R: Receiver(num, K), s: Pop(num)) -> Motion(num, K, R, s, s):
  match R:
    case @receiver{M, e, ac}: e(s)
def ract(num: Numeric, K: Knowledge(num), R: Receiver(num, K), a: Pop(num), b: Pop(num), c: Pop(num), st: PStep(num, K, a, b), m: Motion(num, K, R, b, c)) -> Motion(num, K, R, a, c):
  match R:
    case @receiver{M, e, ac}: ac(a, b, c, st, m)

# §1 THE FOLD EXISTS
def fold(num: Numeric, K: Knowledge(num), R: Receiver(num, K), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Motion(num, K, R, a, b):
  match d:
    case @done{e}:
      match e:
        case {==}: eps(num, K, R, a)
    case @then{m, st, d2}: ract(num, K, R, a, m, b, st, fold(num, K, R, m, b, d2))

# §2 THE FOLD IS UNIQUE: anything with its two computation rules is it
def foldUnique(num: Numeric, K: Knowledge(num), R: Receiver(num, K),
               g: all a: Pop(num). all b: Pop(num). Deriv(num, K, a, b) -> Motion(num, K, R, a, b),
               gDone: all a: Pop(num). Path(Motion(num, K, R, a, a), g(a, a, @done{{==}}), eps(num, K, R, a)),
               gStep: all a: Pop(num). all m: Pop(num). all b: Pop(num). all st: PStep(num, K, a, m). all d: Deriv(num, K, m, b). Path(Motion(num, K, R, a, b), g(a, b, @then{m, st, d}), ract(num, K, R, a, m, b, st, g(m, b, d))),
               a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Path(Motion(num, K, R, a, b), g(a, b, d), fold(num, K, R, a, b, d)):
  match d:
    case @done{e}:
      match e:
        case {==}: gDone(a)
    case @then{m, st, d2}:
      compPath(Motion(num, K, R, a, b), g(a, b, @then{m, st, d2}), ract(num, K, R, a, m, b, st, g(m, b, d2)), ract(num, K, R, a, m, b, st, fold(num, K, R, m, b, d2)),
        gStep(a, m, b, st, d2),
        cong(Motion(num, K, R, m, b), Motion(num, K, R, a, b), lambda mo. ract(num, K, R, a, m, b, st, mo), g(m, b, d2), fold(num, K, R, m, b, d2),
             foldUnique(num, K, R, g, gDone, gStep, m, b, d2)))

# ---- 4. the receivers (the readout protocols)
# (a) the terminal population: what the derivation produced (the prediction)
def popR(num: Numeric, K: Knowledge(num)) -> Receiver(num, K):
  @receiver{lambda a. lambda b. Pop(num), lambda s. s, lambda a. lambda b. lambda c. lambda st. lambda m. m}
# the terminal reading is the endpoint, by one induction
def popFoldIsEnd(num: Numeric, K: Knowledge(num), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Path(Pop(num), fold(num, K, popR(num, K), a, b, d), b):
  match d:
    case @done{e}:
      match e:
        case {==}: <_> a
    case @then{m, st, d2}: popFoldIsEnd(num, K, m, b, d2)
# (b) length (cost): the constant-Nat receiver
def lenR(num: Numeric, K: Knowledge(num)) -> Receiver(num, K):
  @receiver{lambda a. lambda b. Nat, lambda s. 0n, lambda a. lambda b. lambda c. lambda st. lambda m. 1n + m}
# (c) the accumulated pseudobulk delta, as a signed vector (up, down) in truncated arithmetic
type SVec(num: Numeric):
  case @sv:
    up: Vec(num)
    down: Vec(num)
def svadd(num: Numeric, x: SVec(num), y: SVec(num)) -> SVec(num):
  match x:
    case @sv{u1, d1}:
      match y:
        case @sv{u2, d2}: @sv{vadd(num, u1, u2), vadd(num, d1, d2)}
def pbDelta(num: Numeric, a: Pop(num), b: Pop(num)) -> SVec(num):
  @sv{vsub(num, pseudobulk(num, b), pseudobulk(num, a)), vsub(num, pseudobulk(num, a), pseudobulk(num, b))}
def deltaR(num: Numeric, K: Knowledge(num)) -> Receiver(num, K):
  @receiver{lambda a. lambda b. SVec(num), lambda s. @sv{[], []}, lambda a. lambda b. lambda c. lambda st. lambda m. svadd(num, pbDelta(num, a, b), m)}
# (d) the per-step generator trace: which interventions were applied, in order
def traceR(num: Numeric, K: Knowledge(num)) -> Receiver(num, K):
  @receiver{lambda a. lambda b. Intervention[], lambda s. [], lambda a. lambda b. lambda c. lambda st. lambda m. match st: case @act{iv, et}: iv <> m}

# ---- 5. Vivarana: the receiver family read at once by the product receiver
def prodR(num: Numeric, K: Knowledge(num), R1: Receiver(num, K), R2: Receiver(num, K)) -> Receiver(num, K):
  @receiver{lambda a. lambda b. any x: Motion(num, K, R1, a, b). Motion(num, K, R2, a, b),
            lambda s. (eps(num, K, R1, s), eps(num, K, R2, s)),
            lambda a. lambda b. lambda c. lambda st. lambda m. (ract(num, K, R1, a, b, c, st, fst(Motion(num, K, R1, b, c), lambda x. Motion(num, K, R2, b, c), m)), ract(num, K, R2, a, b, c, st, snd(Motion(num, K, R1, b, c), lambda x. Motion(num, K, R2, b, c), m)))}
# each component of the product fold IS the component's own fold (by uniqueness, not by rewriting)
def prodFst(num: Numeric, K: Knowledge(num), R1: Receiver(num, K), R2: Receiver(num, K), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Path(Motion(num, K, R1, a, b), fst(Motion(num, K, R1, a, b), lambda x. Motion(num, K, R2, a, b), fold(num, K, prodR(num, K, R1, R2), a, b, d)), fold(num, K, R1, a, b, d)):
  foldUnique(num, K, R1,
    lambda a2. lambda b2. lambda d2. fst(Motion(num, K, R1, a2, b2), lambda x. Motion(num, K, R2, a2, b2), fold(num, K, prodR(num, K, R1, R2), a2, b2, d2)),
    lambda a2. <_> eps(num, K, R1, a2),
    lambda a2. lambda m2. lambda b2. lambda st2. lambda d2. <_> ract(num, K, R1, a2, m2, b2, st2, fst(Motion(num, K, R1, m2, b2), lambda x. Motion(num, K, R2, m2, b2), fold(num, K, prodR(num, K, R1, R2), m2, b2, d2))),
    a, b, d)
def prodSnd(num: Numeric, K: Knowledge(num), R1: Receiver(num, K), R2: Receiver(num, K), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Path(Motion(num, K, R2, a, b), snd(Motion(num, K, R1, a, b), lambda x. Motion(num, K, R2, a, b), fold(num, K, prodR(num, K, R1, R2), a, b, d)), fold(num, K, R2, a, b, d)):
  foldUnique(num, K, R2,
    lambda a2. lambda b2. lambda d2. snd(Motion(num, K, R1, a2, b2), lambda x. Motion(num, K, R2, a2, b2), fold(num, K, prodR(num, K, R1, R2), a2, b2, d2)),
    lambda a2. <_> eps(num, K, R2, a2),
    lambda a2. lambda m2. lambda b2. lambda st2. lambda d2. <_> ract(num, K, R2, a2, m2, b2, st2, snd(Motion(num, K, R1, m2, b2), lambda x. Motion(num, K, R2, m2, b2), fold(num, K, prodR(num, K, R1, R2), m2, b2, d2))),
    a, b, d)

# THE ELUCIDATOR: one derivation in, its whole reading out, in one traversal
def familyR(num: Numeric, K: Knowledge(num)) -> Receiver(num, K):
  prodR(num, K, popR(num, K), prodR(num, K, deltaR(num, K), prodR(num, K, lenR(num, K), traceR(num, K))))
def elucidate(num: Numeric, K: Knowledge(num), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Motion(num, K, familyR(num, K), a, b):
  fold(num, K, familyR(num, K), a, b, d)
# and its first component is forced to be the terminal population
def elucidateIsCanonical(num: Numeric, K: Knowledge(num), a: Pop(num), b: Pop(num), d: Deriv(num, K, a, b)) -> Path(Pop(num), fst(Pop(num), lambda x. Motion(num, K, prodR(num, K, deltaR(num, K), prodR(num, K, lenR(num, K), traceR(num, K))), a, b), elucidate(num, K, a, b, d)), b):
  compPath(Pop(num), fst(Pop(num), lambda x. Motion(num, K, prodR(num, K, deltaR(num, K), prodR(num, K, lenR(num, K), traceR(num, K))), a, b), elucidate(num, K, a, b, d)), fold(num, K, popR(num, K), a, b, d), b,
    prodFst(num, K, popR(num, K), prodR(num, K, deltaR(num, K), prodR(num, K, lenR(num, K), traceR(num, K))), a, b, d),
    popFoldIsEnd(num, K, a, b, d))

# ---- 6. protocol readouts on the elucidation (scPertEval / cell-eval, fixed point)
# DE gene set: indices where |pseudobulk delta| >= threshold (the top-N overlap's input)
def degSetFrom(num: Numeric, i: U64, thr: Num(num), up: Vec(num), down: Vec(num)) -> U64[]:
  match up:
    case []:
      match down:
        case []: []
        case dk <> du: if nlt(num, dk, thr): degSetFrom(num, i + 1, thr, [], du) else: i <> degSetFrom(num, i + 1, thr, [], du)
    case uh <> ut:
      match down:
        case []: if nlt(num, uh, thr): degSetFrom(num, i + 1, thr, ut, []) else: i <> degSetFrom(num, i + 1, thr, ut, [])
        case dk <> du:
          if nlt(num, uh, thr):
            if nlt(num, dk, thr): degSetFrom(num, i + 1, thr, ut, du) else: i <> degSetFrom(num, i + 1, thr, ut, du)
          else: i <> degSetFrom(num, i + 1, thr, ut, du)
def degSet(num: Numeric, thr: Num(num), d: SVec(num)) -> U64[]:
  match d:
    case @sv{u, dn}: degSetFrom(num, 0, thr, u, dn)
# MAE between two pseudobulks (mean absolute error over genes; the VCC 'mae')
def mae(num: Numeric, pred: Vec(num), real: Vec(num)) -> Num(num):
  ndiv(num, vl1(num, pred, real), fromNat(num, length(Num(num), pred)))
# cross term of the energy distance: sum over pairs of L1 distances
def crossL1(num: Numeric, P: Pop(num), Q: Pop(num)) -> Num(num):
  match P:
    case []: nzero(num)
    case c <> rest: nadd(num, rowL1(num, c, Q), crossL1(num, rest, Q))
def rowL1(num: Numeric, c: Vec(num), Q: Pop(num)) -> Num(num):
  match Q:
    case []: nzero(num)
    case q <> rest: nadd(num, vl1(num, c, q), rowL1(num, c, rest))
# energy distance (L1 ground metric), in truncated fixed point:
#   2·mean d(P,Q) − mean d(P,P) − mean d(Q,Q)
def edist(num: Numeric, P: Pop(num), Q: Pop(num)) -> Num(num):
  nsub(num, nsub(num, ndiv(num, nadd(num, crossL1(num, P, Q), crossL1(num, P, Q)), nmul(num, fromNat(num, plen(num, P)), fromNat(num, plen(num, Q)))),
                 ndiv(num, crossL1(num, P, P), nmul(num, fromNat(num, plen(num, P)), fromNat(num, plen(num, P))))),
       ndiv(num, crossL1(num, Q, Q), nmul(num, fromNat(num, plen(num, Q)), fromNat(num, plen(num, Q)))))
# retrieval (discrimination score, L1): the rank of the true effect among a library
# of real effects, by L1 distance to the predicted effect; 1 − rank/size
def svL1(num: Numeric, x: SVec(num), y: SVec(num)) -> Num(num):
  match x:
    case @sv{u1, d1}:
      match y:
        case @sv{u2, d2}: nadd(num, vl1(num, u1, u2), vl1(num, d1, d2))
def countCloser(num: Numeric, pred: SVec(num), dTrue: Num(num), lib: SVec(num)[]) -> Nat:
  match lib:
    case []: 0n
    case e <> rest:
      if nlt(num, svL1(num, pred, e), dTrue): 1n + countCloser(num, pred, dTrue, rest) else: countCloser(num, pred, dTrue, rest)
def rankOfTrue(num: Numeric, pred: SVec(num), true: SVec(num), lib: SVec(num)[]) -> Nat:
  countCloser(num, pred, svL1(num, pred, true), lib)
# 1-D Wasserstein-1 per gene between equal-size populations = L1 between sorted columns
def insertN(num: Numeric, x: Num(num), xs: Vec(num)) -> Vec(num):
  match xs:
    case []: [x]
    case h <> t: if nlt(num, x, h): x <> h <> t else: h <> insertN(num, x, t)
def sortN(num: Numeric, xs: Vec(num)) -> Vec(num):
  match xs:
    case []: []
    case h <> t: insertN(num, h, sortN(num, t))
def column(num: Numeric, j: Nat, P: Pop(num)) -> Vec(num):
  match P:
    case []: []
    case c <> rest: nth(num, j, c) <> column(num, j, rest)
def nth(num: Numeric, j: Nat, c: Vec(num)) -> Num(num):
  match c:
    case []: nzero(num)
    case h <> t:
      match j:
        case 0n: h
        case 1n + p: nth(num, p, t)
def w1Gene(num: Numeric, j: Nat, P: Pop(num), Q: Pop(num)) -> Num(num):
  ndiv(num, vl1(num, sortN(num, column(num, j, P)), sortN(num, column(num, j, Q))), fromNat(num, plen(num, P)))

# ---- 7. the behavioural relation: Nerode over (step = the installed knowledge, observe = stat)
def vccNerode(num: Numeric, K: Knowledge(num), x: Pop(num), y: Pop(num)) -> Set:
  Nerode(Pop(num), Intervention, Vec(num), stepK(num, K), stat(num), x, y)
def vccMeaning(num: Numeric, K: Knowledge(num)) -> Set:
  Meaning(Pop(num), Intervention, Vec(num), stepK(num, K), stat(num))
def vccMachine(num: Numeric, K: Knowledge(num), sO: isSet(Vec(num))) -> Machine:
  @machine{Pop(num), Intervention, Vec(num), sO, stepK(num, K), stat(num)}
def vccMinimal(num: Numeric, K: Knowledge(num), sO: isSet(Vec(num))) -> Machine:
  crystal(vccMachine(num, K, sO))

# ---- 8. erasure = descent. The proposed reduction: forget the population, keep its statistic.
def RStat(num: Numeric, x: Pop(num), y: Pop(num)) -> Set:
  any pn: Path(Nat, plen(num, x), plen(num, y)). Path(Vec(num), vsum(num, x), vsum(num, y))
# (i) observe descends: stat is constant on RStat-classes (the resp obligation is the relation itself)
def statResp(num: Numeric, x: Pop(num), y: Pop(num), r: RStat(num, x, y)) -> Path(Vec(num), stat(num, x), stat(num, y)):
  match r:
    case (pn, ps): <i> fromNat(num, pn @ i) <> (ps @ i)
def statQ(num: Numeric, sO: isSet(Vec(num)), m: Quotient(Pop(num), RStat(num))) -> Vec(num):
  quotRec(Pop(num), RStat(num), Vec(num), sO, stat(num), statResp(num), m)

# (ii) step descends for pure up-shift knowledge: the statistic is equivariant. Vector laws first.
def vaddNilR(num: Numeric, ys: Vec(num)) -> Path(Vec(num), vadd(num, ys, []), ys):
  match ys:
    case []: <_> []
    case k <> u: <_> k <> u
def vaddAssoc(num: Numeric, L: NumLaws(num), xs: Vec(num), ys: Vec(num), zs: Vec(num)) -> Path(Vec(num), vadd(num, vadd(num, xs, ys), zs), vadd(num, xs, vadd(num, ys, zs))):
  match xs:
    case []: <_> vadd(num, ys, zs)
    case h <> t:
      match ys:
        case []: <_> vadd(num, h <> t, zs)
        case k <> u:
          match zs:
            case []: <_> nadd(num, h, k) <> vadd(num, t, u)
            case l <> v: <i> (addAssoc(num, L, h, k, l) @ i) <> (vaddAssoc(num, L, t, u, v) @ i)
def vaddComm(num: Numeric, L: NumLaws(num), xs: Vec(num), ys: Vec(num)) -> Path(Vec(num), vadd(num, xs, ys), vadd(num, ys, xs)):
  match xs:
    case []: sym(Vec(num), vadd(num, ys, []), ys, vaddNilR(num, ys))
    case h <> t:
      match ys:
        case []: <_> h <> t
        case k <> u: <i> (addComm(num, L, h, k) @ i) <> (vaddComm(num, L, t, u) @ i)
# u + (S + V) = S + (u + V)
def vaddSwap(num: Numeric, L: NumLaws(num), u: Vec(num), s: Vec(num), v: Vec(num)) -> Path(Vec(num), vadd(num, u, vadd(num, s, v)), vadd(num, s, vadd(num, u, v))):
  compPath3(Vec(num), vadd(num, u, vadd(num, s, v)), vadd(num, vadd(num, u, s), v), vadd(num, vadd(num, s, u), v), vadd(num, s, vadd(num, u, v)),
    sym(Vec(num), vadd(num, vadd(num, u, s), v), vadd(num, u, vadd(num, s, v)), vaddAssoc(num, L, u, s, v)),
    cong(Vec(num), Vec(num), lambda w. vadd(num, w, v), vadd(num, u, s), vadd(num, s, u), vaddComm(num, L, u, s)),
    vaddAssoc(num, L, s, u, v))
# the count is preserved by any generator
def plenPerturb(num: Numeric, g: Generator(num), P: Pop(num)) -> Path(Nat, plen(num, perturb(num, g, P)), plen(num, P)):
  match P:
    case []: <_> 0n
    case c <> rest: <i> 1n + (plenPerturb(num, g, rest) @ i)
# THE EQUIVARIANCE: shifting every cell by u shifts the sum by (count · u)
def vsumShift(num: Numeric, L: NumLaws(num), u: Vec(num), P: Pop(num)) -> Path(Vec(num), vsum(num, perturb(num, @shift{u, []}, P)), vadd(num, vsum(num, P), vscale(num, plen(num, P), u))):
  match P:
    case []: <_> []
    case c <> rest:
      compPath3(Vec(num),
        vadd(num, vadd(num, c, u), vsum(num, perturb(num, @shift{u, []}, rest))),
        vadd(num, vadd(num, c, u), vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u))),
        vadd(num, c, vadd(num, u, vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u)))),
        vadd(num, vadd(num, c, vsum(num, rest)), vadd(num, u, vscale(num, plen(num, rest), u))),
        cong(Vec(num), Vec(num), lambda w. vadd(num, vadd(num, c, u), w), vsum(num, perturb(num, @shift{u, []}, rest)), vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u)), vsumShift(num, L, u, rest)),
        vaddAssoc(num, L, c, u, vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u))),
        compPath(Vec(num),
          vadd(num, c, vadd(num, u, vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u)))),
          vadd(num, c, vadd(num, vsum(num, rest), vadd(num, u, vscale(num, plen(num, rest), u)))),
          vadd(num, vadd(num, c, vsum(num, rest)), vadd(num, u, vscale(num, plen(num, rest), u))),
          cong(Vec(num), Vec(num), lambda w. vadd(num, c, w), vadd(num, u, vadd(num, vsum(num, rest), vscale(num, plen(num, rest), u))), vadd(num, vsum(num, rest), vadd(num, u, vscale(num, plen(num, rest), u))), vaddSwap(num, L, u, vsum(num, rest), vscale(num, plen(num, rest), u))),
          sym(Vec(num), vadd(num, vadd(num, c, vsum(num, rest)), vadd(num, u, vscale(num, plen(num, rest), u))), vadd(num, c, vadd(num, vsum(num, rest), vadd(num, u, vscale(num, plen(num, rest), u)))), vaddAssoc(num, L, c, vsum(num, rest), vadd(num, u, vscale(num, plen(num, rest), u))))))
# RStat is a behavioural congruence for up-shift knowledge: the erasure DESCENDS
def statCongruence(num: Numeric, L: NumLaws(num), u: Intervention -> Vec(num)) -> isBehavioralCongruence(Pop(num), Intervention, Vec(num), stepK(num, Kup(num, u)), stat(num), RStat(num)):
  @congruence{
    lambda x. lambda y. lambda r. statResp(num, x, y, r),
    lambda x. lambda y. lambda a. lambda r. match r: case (pn, ps):
      (compPath3(Nat, plen(num, perturb(num, @shift{u(a), []}, x)), plen(num, x), plen(num, y), plen(num, perturb(num, @shift{u(a), []}, y)),
         plenPerturb(num, @shift{u(a), []}, x), pn, sym(Nat, plen(num, perturb(num, @shift{u(a), []}, y)), plen(num, y), plenPerturb(num, @shift{u(a), []}, y))),
       compPath3(Vec(num), vsum(num, perturb(num, @shift{u(a), []}, x)), vadd(num, vsum(num, x), vscale(num, plen(num, x), u(a))), vadd(num, vsum(num, y), vscale(num, plen(num, y), u(a))), vsum(num, perturb(num, @shift{u(a), []}, y)),
         vsumShift(num, L, u(a), x),
         <i> vadd(num, ps @ i, vscale(num, pn @ i, u(a))),
         sym(Vec(num), vsum(num, perturb(num, @shift{u(a), []}, y)), vadd(num, vsum(num, y), vscale(num, plen(num, y), u(a))), vsumShift(num, L, u(a), y))))}
# hence RStat ⊆ Nerode: two populations with the same statistic have the same future under every word
def statSufficient(num: Numeric, L: NumLaws(num), u: Intervention -> Vec(num), x: Pop(num), y: Pop(num), r: RStat(num, x, y)) -> vccNerode(num, Kup(num, u), x, y):
  lambda w. congruenceToNerode(Pop(num), Intervention, Vec(num), stepK(num, Kup(num, u)), stat(num), RStat(num), statCongruence(num, L, u), x, y, r, w)
# and the erased machine mediates into the minimal one (Terminal)
def statMediate(num: Numeric, L: NumLaws(num), u: Intervention -> Vec(num), q: Quotient(Pop(num), RStat(num))) -> vccMeaning(num, Kup(num, u)):
  mediate(Pop(num), Intervention, Vec(num), stepK(num, Kup(num, u)), stat(num), RStat(num), statCongruence(num, L, u), q)

# ---- 9. the Nat instance: the laws are theorems here
def natSub(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n: a
    case 1n + q:
      match a:
        case 0n: 0n
        case 1n + p: natSub(p, q)
def natLt(a: Nat, b: Nat) -> Bool:
  match b:
    case 0n: False
    case 1n + q:
      match a:
        case 0n: True
        case 1n + p: natLt(p, q)
def natDiv(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n: 0n
    case 1n + q: natDivGo(a, q, 0n)
def natDivGo(a: Nat, q: Nat, acc: Nat) -> Nat:
  match natLt(a, 1n + q):
    case True: acc
    case False: natDivGo(natSub(a, 1n + q), q, 1n + acc)
def natMul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, natMul(p, b))
def natNum() -> Numeric:
  @numeric{Nat, 0n, 1n, add, natSub, natLt, natDiv, natMul}
def nAddAssoc(a: Nat, b: Nat, c: Nat) -> Path(Nat, add(add(a, b), c), add(a, add(b, c))):
  match a:
    case 0n: <_> add(b, c)
    case 1n + p: <i> 1n + (nAddAssoc(p, b, c) @ i)
def nAddComm(a: Nat, b: Nat) -> Path(Nat, add(a, b), add(b, a)):
  match a:
    case 0n: sym(Nat, add(b, 0n), b, plusZero(b))
    case 1n + p:
      compPath(Nat, 1n + add(p, b), 1n + add(b, p), add(b, 1n + p),
        <i> 1n + (nAddComm(p, b) @ i),
        sym(Nat, add(b, 1n + p), 1n + add(b, p), plusSuc(b, p)))
def natLaws() -> NumLaws(natNum):
  @laws{nAddAssoc, nAddComm}

# Nat[] is a set (encode–decode, as Prelude does for Nat)
def LNCode(xs: Nat[], ys: Nat[]) -> Set:
  match xs:
    case []:
      match ys:
        case []: Unit
        case k <> u: Empty
    case h <> t:
      match ys:
        case []: Empty
        case k <> u: any p: Path(Nat, h, k). LNCode(t, u)
def lnR(xs: Nat[]) -> LNCode(xs, xs):
  match xs:
    case []: ()
    case h <> t: (<_> h, lnR(t))
def lnEncode(xs: Nat[], ys: Nat[], p: Path(Nat[], xs, ys)) -> LNCode(xs, ys):
  coe(lambda i. LNCode(xs, p @ i), i0, i1, lnR(xs))
def lnDecode(xs: Nat[], ys: Nat[], c: LNCode(xs, ys)) -> Path(Nat[], xs, ys):
  match xs:
    case []:
      match ys:
        case []: <_> []
        case k <> u: absurd c
    case h <> t:
      match ys:
        case []: absurd c
        case k <> u:
          match c:
            case (p, c2): <i> (p @ i) <> (lnDecode(t, u, c2) @ i)
def lnDecodeR(xs: Nat[]) -> Path(Path(Nat[], xs, xs), lnDecode(xs, xs, lnR(xs)), <_> xs):
  match xs:
    case []: <_> <_> []
    case h <> t: <i> <j> h <> ((lnDecodeR(t) @ i) @ j)
def lnDecodeEncode(xs: Nat[], ys: Nat[], p: Path(Nat[], xs, ys)) -> Path(Path(Nat[], xs, ys), lnDecode(xs, ys, lnEncode(xs, ys, p)), p):
  J(Nat[], xs, lambda ys2. lambda p2. Path(Path(Nat[], xs, ys2), lnDecode(xs, ys2, lnEncode(xs, ys2, p2)), p2), lnDecodeR(xs), ys, p)
def lnCodeIsProp(xs: Nat[], ys: Nat[], c: LNCode(xs, ys), d: LNCode(xs, ys)) -> Path(LNCode(xs, ys), c, d):
  match xs:
    case []:
      match ys:
        case []:
          match c:
            case ():
              match d:
                case (): <_> ()
        case k <> u: absurd c
    case h <> t:
      match ys:
        case []: absurd c
        case k <> u: isPropProd(Path(Nat, h, k), LNCode(t, u), isSetNat(h, k), lnCodeIsProp(t, u), c, d)
def isSetListNat(xs: Nat[], ys: Nat[], p: Path(Nat[], xs, ys), q: Path(Nat[], xs, ys)) -> Path(Path(Nat[], xs, ys), p, q):
  compPath(Path(Nat[], xs, ys), p, lnDecode(xs, ys, lnEncode(xs, ys, p)), q,
    sym(Path(Nat[], xs, ys), lnDecode(xs, ys, lnEncode(xs, ys, p)), p, lnDecodeEncode(xs, ys, p)),
    compPath(Path(Nat[], xs, ys), lnDecode(xs, ys, lnEncode(xs, ys, p)), lnDecode(xs, ys, lnEncode(xs, ys, q)), q,
      cong(LNCode(xs, ys), Path(Nat[], xs, ys), lambda c. lnDecode(xs, ys, c), lnEncode(xs, ys, p), lnEncode(xs, ys, q), lnCodeIsProp(xs, ys, lnEncode(xs, ys, p), lnEncode(xs, ys, q))),
      lnDecodeEncode(xs, ys, q)))

# the minimal machine of any up-shift knowledge over Nat populations, and the erased machine into it
def natMinimal(u: Intervention -> Nat[]) -> Machine:
  vccMinimal(natNum, Kup(natNum, u), isSetListNat)
def natStatMediate(u: Intervention -> Nat[], q: Quotient(Nat[][], RStat(natNum))) -> vccMeaning(natNum, Kup(natNum, u)):
  statMediate(natNum, natLaws, u, q)

# ---- 10. THE FLOOR EFFECT: with a down-shift the statistic does NOT descend.
# Two one-gene populations with the same count and sum, a knockdown of 1 unit:
#   [[0],[2]] ↦ [[0],[1]]  (sum 1)     [[1],[1]] ↦ [[0],[0]]  (sum 0)
def P1() -> Nat[][]:
  [[0n], [2n]]
def P2() -> Nat[][]:
  [[1n], [1n]]
def Kdown() -> Knowledge(natNum):
  lambda a. @shift{[], [1n]}
def sameStat() -> RStat(natNum, P1, P2):
  (<_> 2n, <_> [2n])
def headOr0(xs: Nat[]) -> Nat:
  match xs:
    case []: 0n
    case h <> t: h
def floorBreaksStat(r: RStat(natNum, stepK(natNum, Kdown, P1, @kd{0}), stepK(natNum, Kdown, P2, @kd{0}))) -> Empty:
  match r:
    case (pn, ps):
      nNotSuc(0n, sym(Nat, 1n, 0n, cong(Nat[], Nat, headOr0, [1n], [0n], ps)))
# so RStat is NOT a behavioural congruence under the floor effect: the erasure is REFUTED
def statNotCongruenceUnderFloor(isC: isBehavioralCongruence(Nat[][], Intervention, Nat[], stepK(natNum, Kdown), stat(natNum), RStat(natNum))) -> Empty:
  match isC:
    case @congruence{ro, rs}: floorBreaksStat(rs(P1, P2, @kd{0}, sameStat))
# and the DISTRIBUTIONAL readout was never a function of the statistic in the first place:
# the energy-distance cross term to a reference separates P1 from P2 (2 vs 0)
def Q0() -> Nat[][]:
  [[1n]]
def crossSeparates(e: Path(Nat, crossL1(natNum, P1, Q0), crossL1(natNum, P2, Q0))) -> Empty:
  nNotSucSuc(0n, sym(Nat, 2n, 0n, e))
def edistNotOfStat(f: all x: Nat[][]. all y: Nat[][]. RStat(natNum, x, y) -> Path(Nat, crossL1(natNum, x, Q0), crossL1(natNum, y, Q0))) -> Empty:
  crossSeparates(f(P1, P2, sameStat))

# ---- 11. where descent fails, the exact fibre is retained: Pop ≃ Carrier(stat)
def statFibre(num: Numeric, P: Pop(num)) -> Set:
  fibre(Pop(num), Vec(num), stat(num), P)
def statFibreContr(num: Numeric, P: Pop(num)) -> isContr(statFibre(num, P)):
  fibre_isContr(Pop(num), Vec(num), stat(num), P)
def retain(num: Numeric, P: Pop(num)) -> Carrier(Pop(num), Vec(num), stat(num)):
  descend(Pop(num), Vec(num), stat(num), P)
def retainLossless(num: Numeric, P: Pop(num)) -> Path(Pop(num), ascend(Pop(num), Vec(num), stat(num), retain(num, P)), P):
  ascend_descend(Pop(num), Vec(num), stat(num), P)
def PopIsCarrier(num: Numeric) -> Path(Set, Pop(num), Carrier(Pop(num), Vec(num), stat(num))):
  CarrierPath(Pop(num), Vec(num), stat(num))

# ---- 12. the U64 instance (the runtime carrier; HVM4 numbers are 32-bit words)
def u64Sub(a: U64, b: U64) -> U64:
  if a < b: 0 else: a - b
def u64Num() -> Numeric:
  @numeric{U64, 0, 1, lambda a. lambda b. a + b, u64Sub, lambda a. lambda b. a < b, lambda a. lambda b. a / b, lambda a. lambda b. a * b}

# a tiny fixed example: two cells, three genes, one knockdown; the elucidation, run
def exK() -> Knowledge(u64Num):
  lambda a. @shift{[0, 50, 0], [300, 0, 0]}
def exP() -> Pop(u64Num):
  [[1000, 200, 0], [800, 400, 100]]
def exD() -> Deriv(u64Num, exK, exP, stepK(u64Num, exK, exP, @kd{0})):
  @then{stepK(u64Num, exK, exP, @kd{0}), @act{@kd{0}, {==}}, @done{{==}}}
def main() -> Pop(u64Num):
  fst(Pop(u64Num), lambda x. Motion(u64Num, exK, prodR(u64Num, exK, deltaR(u64Num, exK), prodR(u64Num, exK, lenR(u64Num, exK), traceR(u64Num, exK))), exP, stepK(u64Num, exK, exP, @kd{0})),
      elucidate(u64Num, exK, exP, stepK(u64Num, exK, exP, @kd{0}), exD))

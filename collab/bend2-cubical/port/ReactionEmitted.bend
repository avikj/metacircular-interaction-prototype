# EMITTED by scripts/emit-reaction.py — do not edit; edit the SBML / PEtab.
# species ['A', 'B', 'C', 'E']; reactions ['r1', 'r2', 'r3', 'dimer']
import Prelude

# §1 the finite presentation
type St:
  case @st:
    a: Nat
    b: Nat
    c: Nat
    e: Nat
def aOf(x: St) -> Nat:
  match x: case @st{v_a, v_b, v_c, v_e}: v_a
def bOf(x: St) -> Nat:
  match x: case @st{v_a, v_b, v_c, v_e}: v_b
def cOf(x: St) -> Nat:
  match x: case @st{v_a, v_b, v_c, v_e}: v_c
def eOf(x: St) -> Nat:
  match x: case @st{v_a, v_b, v_c, v_e}: v_e
type Rxn:
  case @r1:
  case @r2:
  case @r3:
  case @dimer:
def fire(x: St, r: Rxn) -> St:
  match x:
    case @st{v_a, v_b, v_c, v_e}:
      match r:
        case @r1{}:
          match v_a:
            case 0n: @st{v_a, v_b, v_c, v_e}
            case 1n + p_a_0:
              @st{p_a_0, 1n + v_b, v_c, v_e}
        case @r2{}:
          match v_b:
            case 0n: @st{v_a, v_b, v_c, v_e}
            case 1n + p_b_0:
              @st{v_a, p_b_0, 1n + v_c, v_e}
        case @r3{}:
          match v_a:
            case 0n: @st{v_a, v_b, v_c, v_e}
            case 1n + p_a_0:
              match v_e:
                case 0n: @st{v_a, v_b, v_c, v_e}
                case 1n + p_e_0:
                  @st{p_a_0, v_b, 1n + v_c, 1n + p_e_0}
        case @dimer{}:
          match v_c:
            case 0n: @st{v_a, v_b, v_c, v_e}
            case 1n + p_c_0:
              match p_c_0:
                case 0n: @st{v_a, v_b, v_c, v_e}
                case 1n + p_c_1:
                  @st{v_a, 1n + v_b, p_c_1, v_e}
type Step(x: St, y: St):
  case @act:
    r: Rxn
    ey: St{y == fire(x, r)}
type Derivation(x: St, z: St):
  case @done:
    e: St{z == x}
  case @then:
    y: St
    s: Step(x, y)
    d: Derivation(y, z)
def stepRxn(x: St, y: St, s: Step(x, y)) -> Rxn:
  match s: case @act{r, ey}: r

# §2 receiver, fold, uniqueness
def foldM(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c), a: St, z: St, d: Derivation(a, z)) -> M(a, z):
  match d:
    case @done{eq}:
      match eq: case {==}: e(a)
    case @then{y, s, d2}:
      k(a, y, z, s, foldM(M, e, k, y, z, d2))
def fold_unique(M: St -> St -> Set, e: all t: St. M(t, t), k: all a: St. all b: St. all c: St. Step(a, b) -> M(b, c) -> M(a, c),
                g: all a: St. all z: St. Derivation(a, z) -> M(a, z),
                g_done: all t: St. Path(M(t, t), g(t, t, @done{{==}}), e(t)),
                g_step: all a: St. all y: St. all z: St. all s: Step(a, y). all d: Derivation(y, z). Path(M(a, z), g(a, z, @then{y, s, d}), k(a, y, z, s, g(y, z, d))),
                a: St, z: St, d: Derivation(a, z)) -> Path(M(a, z), g(a, z, d), foldM(M, e, k, a, z, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: g_done(a)
    case @then{y, s, d2}:
      compPath(M(a, z), g(a, z, @then{y, s, d2}), k(a, y, z, s, g(y, z, d2)), k(a, y, z, s, foldM(M, e, k, y, z, d2)),
        g_step(a, y, z, s, d2),
        <i> k(a, y, z, s, fold_unique(M, e, k, g, g_done, g_step, y, z, d2) @ i))

# §3 readouts as folds
def natM(a: St, b: St) -> Set:
  Nat
def events(a: St, z: St, d: Derivation(a, z)) -> Nat:
  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)
def sameRxn(r: Rxn, r2: Rxn) -> Bool:
  match r:
    case @r1{}:
      match r2:
        case @r1{}: True
        case @r2{}: False
        case @r3{}: False
        case @dimer{}: False
    case @r2{}:
      match r2:
        case @r1{}: False
        case @r2{}: True
        case @r3{}: False
        case @dimer{}: False
    case @r3{}:
      match r2:
        case @r1{}: False
        case @r2{}: False
        case @r3{}: True
        case @dimer{}: False
    case @dimer{}:
      match r2:
        case @r1{}: False
        case @r2{}: False
        case @r3{}: False
        case @dimer{}: True
def tick(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
def flux(r: Rxn, a: St, z: St, d: Derivation(a, z)) -> Nat:
  foldM(natM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. tick(sameRxn(r, stepRxn(a2, b, s)), n), a, z, d)
def endM(a: St, b: St) -> Set:
  St
def endpoint(a: St, z: St, d: Derivation(a, z)) -> St:
  foldM(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def endpoint_is_endpoint(a: St, z: St, d: Derivation(a, z)) -> Path(St, endpoint(a, z, d), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      endpoint_is_endpoint(y, z, d2)
def wordM(a: St, b: St) -> Set:
  Rxn[]
def word(a: St, z: St, d: Derivation(a, z)) -> Rxn[]:
  foldM(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. stepRxn(a2, b, s) <> w, a, z, d)
def runR(x: St, w: Rxn[]) -> St:
  match w:
    case []: x
    case r <> rest: runR(fire(x, r), rest)
def word_replays(a: St, z: St, d: Derivation(a, z)) -> Path(St, runR(a, word(a, z, d)), z):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> a
    case @then{y, s, d2}:
      match s:
        case @act{r, ey}:
          match ey: case {==}: word_replays(fire(a, r), z, d2)

# §4 the PEtab shape: conditions, experiments, observables — and the emitter's
# own evaluation of each, certified by refl against the emitted generator
def cond_cond_a3() -> St:
  @st{3n, 0n, 0n, 1n}
def cond_cond_noe() -> St:
  @st{3n, 0n, 0n, 0n}
def exp_exp1() -> Rxn[]:
  [@r1, @r3, @r2, @r1]
def exp_exp2() -> Rxn[]:
  [@r3, @r3, @dimer]
def meas_cond_a3_exp1_c() -> Path(Nat, cOf(runR(cond_cond_a3(), exp_exp1())), 2n):
  <_> 2n
def meas_cond_a3_exp1_b() -> Path(Nat, bOf(runR(cond_cond_a3(), exp_exp1())), 1n):
  <_> 1n
def meas_cond_a3_exp2_c() -> Path(Nat, cOf(runR(cond_cond_a3(), exp_exp2())), 0n):
  <_> 0n
def meas_cond_a3_exp2_b() -> Path(Nat, bOf(runR(cond_cond_a3(), exp_exp2())), 1n):
  <_> 1n
def meas_cond_noe_exp1_c() -> Path(Nat, cOf(runR(cond_cond_noe(), exp_exp1())), 1n):
  <_> 1n
def meas_cond_noe_exp1_b() -> Path(Nat, bOf(runR(cond_cond_noe(), exp_exp1())), 1n):
  <_> 1n
def meas_cond_noe_exp2_c() -> Path(Nat, cOf(runR(cond_cond_noe(), exp_exp2())), 0n):
  <_> 0n
def meas_cond_noe_exp2_b() -> Path(Nat, bOf(runR(cond_cond_noe(), exp_exp2())), 0n):
  <_> 0n

def main() -> Nat:
  cOf(runR(cond_cond_a3(), exp_exp1()))

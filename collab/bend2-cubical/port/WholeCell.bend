# The whole cell as COMPOSITION, not as an integration architecture: two
# subsystems already presented separately — expression on a gene panel
# (Perturbation.bend) and a reaction network (a species record with a
# catalysed reaction) — become one continuing object by taking the product
# of their states and the sum of their generators.  Nothing is added for
# "multiscale integration"; the composition laws are the integration.
#
#   §1  the composite state, the composite action, the composite generator
#       (dispatch); histories as derivations over it — one Derivation type
#       for the whole cell
#   §2  the coupling: the enzyme of the reaction network IS the expression
#       level of hk read at passage (a transcription/translation edge across
#       scales).  Without the coupling the subsystems are independent and
#       their steps COMMUTE (Krama, by refl on every state); with it, they
#       do not — order across scales is data exactly where the coupling is
#   §3  the assay reads C (a metabolite).  Under the coupling, hk — a gene
#       the assay never reads, in the other subsystem — is NECESSARY state:
#       one composite experiment separates two cells that agree on
#       everything else.  Without the coupling it is erasable.  The
#       quotient decides where the scales must be kept together.
#   §4  the receivers compose: the reaction-side conservation certificate
#       and the expression-side length are folds of the SAME composite
#       history (mass is preserved by expression steps trivially, by
#       reaction steps as before)
import Perturbation

# ---------------------------------------------------------------------------
# §1  Composite state, actions, generator.
# ---------------------------------------------------------------------------
type Met:
  case @met:
    a: Nat
    c: Nat
    e: Nat
def metA(m: Met) -> Nat:
  match m: case @met{a, c, e}: a
def metC(m: Met) -> Nat:
  match m: case @met{a, c, e}: c
def metE(m: Met) -> Nat:
  match m: case @met{a, c, e}: e
# the one reaction: A -> C, catalysed by E
def fireCat(m: Met) -> Met:
  match m:
    case @met{a, c, e}:
      match e:
        case 0n: @met{a, c, 0n}
        case 1n + q:
          match a:
            case 0n: @met{0n, c, 1n + q}
            case 1n + p: @met{p, 1n + c, 1n + q}

type WC:
  case @wc:
    expr: Cell
    met: Met
def exprOf(x: WC) -> Cell:
  match x: case @wc{c, m}: c
def metOf(x: WC) -> Met:
  match x: case @wc{c, m}: m

type Act:
  case @gene:
    p: Perturb
  case @react:

# uncoupled: each generator acts on its own component
def stepU(x: WC, a: Act) -> WC:
  match x:
    case @wc{c, m}:
      match a:
        case @gene{p}: @wc{step(c, p), m}
        case @react{}: @wc{c, fireCat(m)}
# coupled: a passage also translates hk into enzyme (E := hk)
def stepC(x: WC, a: Act) -> WC:
  match x:
    case @wc{c, m}:
      match a:
        case @gene{p}:
          match p:
            case @kd{g}: @wc{knock(g, c), m}
            case @passage{}:
              match c:
                case @cell{tf, tg, hk}:
                  match m:
                    case @met{ma, mc, me}: @wc{@cell{tf, tf, hk}, @met{ma, mc, hk}}
        case @react{}: @wc{c, fireCat(m)}
def runU(x: WC, w: Act[]) -> WC:
  run(WC, Act, stepU, x, w)
def runCo(x: WC, w: Act[]) -> WC:
  run(WC, Act, stepC, x, w)

type StepW(x: WC, y: WC):
  case @actW:
    a: Act
    ey: WC{y == stepC(x, a)}
type DerivationW(x: WC, z: WC):
  case @doneW:
    e: WC{z == x}
  case @thenW:
    y: WC
    s: StepW(x, y)
    d: DerivationW(y, z)
def foldWC(M: WC -> WC -> Set, e: all t: WC. M(t, t), k: all a: WC. all b: WC. all c: WC. StepW(a, b) -> M(b, c) -> M(a, c), a: WC, z: WC, d: DerivationW(a, z)) -> M(a, z):
  match d:
    case @doneW{eq}:
      match eq: case {==}: e(a)
    case @thenW{y, s, d2}:
      k(a, y, z, s, foldWC(M, e, k, y, z, d2))

# ---------------------------------------------------------------------------
# §2  Independence is commutation; coupling breaks it exactly at the edge.
# ---------------------------------------------------------------------------
# uncoupled: a gene step and a reaction step commute on every state, by refl
def uncoupled_commute(x: WC, p: Perturb) -> Path(WC, stepU(stepU(x, @gene{p}), @react), stepU(stepU(x, @react), @gene{p})):
  match x:
    case @wc{c, m}: <_> @wc{step(c, p), fireCat(m)}
# coupled: passage then react vs react then passage differ when hk supplies the enzyme
def wc0() -> WC:
  @wc{@cell{1n, 1n, 1n}, @met{1n, 0n, 0n}}
def coupled_dont_commute(q: Path(WC, stepC(stepC(wc0(), @gene{@passage}), @react), stepC(stepC(wc0(), @react), @gene{@passage}))) -> Empty:
  natEncode(1n, 0n, <i> metC(metOf(q @ i)))

# ---------------------------------------------------------------------------
# §3  The assay reads the metabolite C.  Which state must be kept?
# ---------------------------------------------------------------------------
def assayC(x: WC) -> Nat:
  metC(metOf(x))
def NerodeU(x: WC, y: WC) -> Set:
  Nerode(WC, Act, Nat, stepU, assayC, x, y)
def NerodeC(x: WC, y: WC) -> Set:
  Nerode(WC, Act, Nat, stepC, assayC, x, y)
# coupled: hk (never read; other subsystem) is necessary — the composite
# experiment [passage, react] reads 1 from hk = 1 and 0 from hk = 0
def hk_necessary_coupled(h: NerodeC(@wc{@cell{1n, 1n, 1n}, @met{1n, 0n, 0n}}, @wc{@cell{1n, 1n, 0n}, @met{1n, 0n, 0n}})) -> Empty:
  natEncode(1n, 0n, h([@gene{@passage}, @react]))
# uncoupled: hk is erasable — the metabolite side never reads the expression side
def AgreeMet(x: WC, y: WC) -> Set:
  any pa: Path(Nat, metA(metOf(x)), metA(metOf(y))). any pc: Path(Nat, metC(metOf(x)), metC(metOf(y))). Path(Nat, metE(metOf(x)), metE(metOf(y)))
def agreeU(c: Cell, c2: Cell, a: Nat, cc: Nat, e: Nat, w: Act[]) -> AgreeMet(runU(@wc{c, @met{a, cc, e}}, w), runU(@wc{c2, @met{a, cc, e}}, w)):
  match w:
    case []: (<_> a, (<_> cc, <_> e))
    case x <> rest:
      match x:
        case @gene{p}: agreeU(step(c, p), step(c2, p), a, cc, e, rest)
        case @react{}:
          match e:
            case 0n: agreeU(c, c2, a, cc, 0n, rest)
            case 1n + q:
              match a:
                case 0n: agreeU(c, c2, 0n, cc, 1n + q, rest)
                case 1n + p: agreeU(c, c2, p, 1n + cc, 1n + q, rest)
def metCpath(x: WC, y: WC, r: AgreeMet(x, y)) -> Path(Nat, metC(metOf(x)), metC(metOf(y))):
  match r:
    case (pa, r2):
      match r2:
        case (pc, pe): pc
def hk_erasable_uncoupled(c: Cell, c2: Cell, a: Nat, cc: Nat, e: Nat) -> NerodeU(@wc{c, @met{a, cc, e}}, @wc{c2, @met{a, cc, e}}):
  lambda w. metCpath(runU(@wc{c, @met{a, cc, e}}, w), runU(@wc{c2, @met{a, cc, e}}, w), agreeU(c, c2, a, cc, e, w))

# ---------------------------------------------------------------------------
# §4  The receivers compose over one composite history.
# ---------------------------------------------------------------------------
def natMW(a: WC, b: WC) -> Set:
  Nat
def isGene(x: WC, y: WC, s: StepW(x, y)) -> Bool:
  match s:
    case @actW{a, ey}:
      match a:
        case @gene{p}: True
        case @react{}: False
def tickW(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
# expression-side receiver: number of gene interventions in the composite history
def geneSteps(a: WC, z: WC, d: DerivationW(a, z)) -> Nat:
  foldWC(natMW, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. tickW(isGene(a2, b, s), n), a, z, d)
# reaction-side receiver: conservation of A + C along the composite history
def massW(x: WC) -> Nat:
  add(metA(metOf(x)), metC(metOf(x)))
def fireCat_mass(m: Met) -> Path(Nat, add(metA(fireCat(m)), metC(fireCat(m))), add(metA(m), metC(m))):
  match m:
    case @met{a, c, e}:
      match e:
        case 0n: <_> add(a, c)
        case 1n + q:
          match a:
            case 0n: <_> add(0n, c)
            case 1n + p: plusSuc(p, c)
def stepC_mass(x: WC, a: Act) -> Path(Nat, massW(stepC(x, a)), massW(x)):
  match x:
    case @wc{c, m}:
      match a:
        case @gene{p}:
          match p:
            case @kd{g}: <_> massW(@wc{knock(g, c), m})
            case @passage{}:
              match c:
                case @cell{tf, tg, hk}:
                  match m:
                    case @met{ma, mc, me}: <_> add(ma, mc)
        case @react{}: fireCat_mass(m)
def massM(a: WC, b: WC) -> Set:
  Path(Nat, massW(b), massW(a))
def massCons(a: WC, b: WC, c: WC, s: StepW(a, b), m: massM(b, c)) -> massM(a, c):
  match s:
    case @actW{act, ey}:
      match ey: case {==}:
        compPath(Nat, massW(c), massW(stepC(a, act)), massW(a), m, stepC_mass(a, act))
def conservedW(a: WC, z: WC, d: DerivationW(a, z)) -> Path(Nat, massW(z), massW(a)):
  foldWC(massM, lambda t. <_> massW(t), massCons, a, z, d)

# a composite history: knock tf, passage (translates hk into E), react
def hist() -> DerivationW(wc0(), @wc{@cell{0n, 0n, 1n}, @met{0n, 1n, 1n}}):
  @thenW{@wc{@cell{0n, 1n, 1n}, @met{1n, 0n, 0n}}, @actW{@gene{@kd{@tf}}, {==}},
    @thenW{@wc{@cell{0n, 0n, 1n}, @met{1n, 0n, 1n}}, @actW{@gene{@passage}, {==}},
      @thenW{@wc{@cell{0n, 0n, 1n}, @met{0n, 1n, 1n}}, @actW{@react, {==}},
        @doneW{{==}}}}}
def hist_geneSteps() -> Path(Nat, geneSteps(wc0(), @wc{@cell{0n, 0n, 1n}, @met{0n, 1n, 1n}}, hist()), 2n):
  <_> 2n
def hist_conserved() -> Path(Nat, massW(@wc{@cell{0n, 0n, 1n}, @met{0n, 1n, 1n}}), massW(wc0())):
  conservedW(wc0(), @wc{@cell{0n, 0n, 1n}, @met{0n, 1n, 1n}}, hist())

def main() -> Nat:
  assayC(runCo(wc0(), [@gene{@passage}, @react]))

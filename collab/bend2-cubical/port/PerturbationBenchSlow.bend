# The sharing question with an EXPENSIVE generator (PerturbationBench.bend
# asked it with a cheap one and found none).  Here a passage does 64 units of
# work on the whole cell (burnC) — forced by any reader that looks at a state; histories are derivations over this step.
# `shared` binds the history once for three receivers; `separate` rebuilds
# it per receiver.  If the net shares the generator's work across readers,
# shared < separate by about 2× the construction cost.
import Perturbation

# the work is on the whole cell, so any reader that forces a state forces it
def burnC(k: Nat, c: Cell) -> Cell:
  match k:
    case 0n: c
    case 1n + q:
      match burnC(q, c):
        case @cell{a, b, h}: @cell{a, b, h}
def stepSlow(c: Cell, p: Perturb) -> Cell:
  match p:
    case @kd{g}: knock(g, c)
    case @passage{}:
      match c:
        case @cell{a, b, h}: burnC(64n, @cell{a, a, h})

type StepS(x: Cell, y: Cell):
  case @actS:
    p: Perturb
    ey: Cell{y == stepSlow(x, p)}
type DerivationS(x: Cell, z: Cell):
  case @doneS:
    e: Cell{z == x}
  case @thenS:
    y: Cell
    s: StepS(x, y)
    d: DerivationS(y, z)
def foldS(M: Cell -> Cell -> Set, e: all t: Cell. M(t, t), k: all a: Cell. all b: Cell. all c: Cell. StepS(a, b) -> M(b, c) -> M(a, c), a: Cell, z: Cell, d: DerivationS(a, z)) -> M(a, z):
  match d:
    case @doneS{eq}:
      match eq: case {==}: e(a)
    case @thenS{y, s, d2}:
      k(a, y, z, s, foldS(M, e, k, y, z, d2))
def stepsS(a: Cell, z: Cell, d: DerivationS(a, z)) -> Nat:
  foldS(lenM, lambda t. 0n, lambda a2. lambda b. lambda c. lambda s. lambda n. 1n + n, a, z, d)
def endpointS(a: Cell, z: Cell, d: DerivationS(a, z)) -> Cell:
  foldS(endM, lambda t. t, lambda a2. lambda b. lambda c. lambda s. lambda m. m, a, z, d)
def perturbS(x: Cell, y: Cell, s: StepS(x, y)) -> Perturb:
  match s: case @actS{p, ey}: p
def wordS(a: Cell, z: Cell, d: DerivationS(a, z)) -> Perturb[]:
  foldS(wordM, lambda t. [], lambda a2. lambda b. lambda c. lambda s. lambda w. perturbS(a2, b, s) <> w, a, z, d)

def iterSlow(n: Nat, c: Cell) -> Cell:
  match n:
    case 0n: c
    case 1n + p: iterSlow(p, stepSlow(c, @passage))
def passS(n: Nat, c: Cell) -> DerivationS(c, iterSlow(n, c)):
  match n:
    case 0n: @doneS{{==}}
    case 1n + p: @thenS{stepSlow(c, @passage), @actS{@passage, {==}}, passS(p, stepSlow(c, @passage))}

# two receivers that READ every intermediate state (the tgt and tf integrals
# along the history), so each forces every generator step
def tgtIntegral(a: Cell, z: Cell, d: DerivationS(a, z)) -> Nat:
  foldS(lenM, lambda t. tgtOf(t), lambda a2. lambda b. lambda c. lambda s. lambda n. add(tgtOf(a2), n), a, z, d)
def tfIntegral(a: Cell, z: Cell, d: DerivationS(a, z)) -> Nat:
  foldS(lenM, lambda t. tfOf(t), lambda a2. lambda b. lambda c. lambda s. lambda n. add(tfOf(a2), n), a, z, d)
def threeS(c: Cell, e: Cell, d: DerivationS(c, e)) -> Nat:
  add(stepsS(c, e, d), add(tgtIntegral(c, e, d), tfIntegral(c, e, d)))
def shared(n: Nat) -> Nat:
  (lambda d. threeS(control(), iterSlow(n, control()), d))(passS(n, control()))
def separate(n: Nat) -> Nat:
  add(stepsS(control(), iterSlow(n, control()), passS(n, control())),
      add(tgtIntegral(control(), iterSlow(n, control()), passS(n, control())),
          tfIntegral(control(), iterSlow(n, control()), passS(n, control()))))
def main() -> Nat:
  shared(8n)

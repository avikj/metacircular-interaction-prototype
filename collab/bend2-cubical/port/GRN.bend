# Gene-regulatory-network inference (the CausalBench shape), on the
# perturbation presentation unchanged: a GRAPH IS A READING OF THE MINIMAL
# MACHINE.  Two generator families that differ by an edge are the same
# object under an assay exactly when no experiment in the assay's
# continuation algebra separates them; one experiment is enough to keep
# an edge, and no number of experiments can install one the assay cannot
# see.  Both directions are theorems here, on the three-gene panel.
#
#   §1  the second generator family: the same panel with one more edge,
#       tf → hk (at passage, hk also follows tf).  Under the tgt-only assay
#       the two families are behaviourally identical: for every cell and
#       every word the assay reads the same value (`edge_invisible`), so
#       the Nerode relations coincide pointwise (`nerode_same_1to2`,
#       `nerode_same_2to1`) and the minimal machines are one object.
#       An inference method that reports the edge, or omits it, has made
#       no claim any experiment can test.
#   §2  the third family: the edge tf → tgt REMOVED (passage leaves tgt).
#       One experiment separates it from the first: from a cell with
#       tf = 1, tgt = 0 the word [passage] reads 1 under the first family
#       and 0 under the third (`edge_visible`).  The edge is kept because
#       an experiment keeps it, not because a score does.
#   §3  the reading: the edge list of a family is a receiver of the
#       family (it is not a receiver of the minimal machine): both edge
#       lists differ, one object.  What the benchmark should score is
#       the quotient, and the fibre of "edge list → quotient" is exactly
#       the set of graphs no experiment distinguishes.
import Perturbation

# ---------------------------------------------------------------------------
# §1  The family with the invisible edge tf → hk.
# ---------------------------------------------------------------------------
def step2(c: Cell, p: Perturb) -> Cell:
  match p:
    case @kd{g}: knock(g, c)
    case @passage{}:
      match c:
        case @cell{a, b, h}: @cell{a, a, a}
def runC2(c: Cell, w: Perturb[]) -> Cell:
  run(Cell, Perturb, step2, c, w)
def NerodeTgt2(x: Cell, y: Cell) -> Set:
  Nerode(Cell, Perturb, Nat, step2, assayTgt, x, y)

# the two runs agree on (tf, tgt) at every step, whatever hk does
def agree12(a: Nat, b: Nat, h: Nat, h2: Nat, w: Perturb[]) -> AgreeVis(runC(@cell{a, b, h}, w), runC2(@cell{a, b, h2}, w)):
  match w:
    case []: (<_> a, <_> b)
    case p <> rest:
      match p:
        case @kd{g}:
          match g:
            case @tf{}: agree12(0n, b, h, h2, rest)
            case @tgt{}: agree12(a, 0n, h, h2, rest)
            case @hk{}: agree12(a, b, 0n, 0n, rest)
        case @passage{}: agree12(a, a, h, a, rest)
# THE EDGE IS INVISIBLE: the assay reads the same value under both families
def edge_invisible(c: Cell, w: Perturb[]) -> Path(Nat, assayTgt(runC(c, w)), assayTgt(runC2(c, w))):
  match c:
    case @cell{a, b, h}:
      visTgt(runC(@cell{a, b, h}, w), runC2(@cell{a, b, h}, w), agree12(a, b, h, h, w))
# so the Nerode relations coincide, pointwise, both ways
def nerode_same_1to2(x: Cell, y: Cell, n: NerodeTgt(x, y)) -> NerodeTgt2(x, y):
  lambda w. compPath3(Nat, assayTgt(runC2(x, w)), assayTgt(runC(x, w)), assayTgt(runC(y, w)), assayTgt(runC2(y, w)),
    <i> edge_invisible(x, w) @ inot(i), n(w), edge_invisible(y, w))
def nerode_same_2to1(x: Cell, y: Cell, n: NerodeTgt2(x, y)) -> NerodeTgt(x, y):
  lambda w. compPath3(Nat, assayTgt(runC(x, w)), assayTgt(runC2(x, w)), assayTgt(runC2(y, w)), assayTgt(runC(y, w)),
    edge_invisible(x, w), n(w), <i> edge_invisible(y, w) @ inot(i))

# ---------------------------------------------------------------------------
# §2  The family without the edge tf → tgt.
# ---------------------------------------------------------------------------
def step3(c: Cell, p: Perturb) -> Cell:
  match p:
    case @kd{g}: knock(g, c)
    case @passage{}: c
def runC3(c: Cell, w: Perturb[]) -> Cell:
  run(Cell, Perturb, step3, c, w)
# THE EDGE IS VISIBLE: one experiment separates the families
def edge_visible(p: Path(Nat, assayTgt(runC(@cell{1n, 0n, 0n}, [@passage])), assayTgt(runC3(@cell{1n, 0n, 0n}, [@passage])))) -> Empty:
  natEncode(1n, 0n, p)
# and so no pointwise identification of the Nerode relations exists for it:
# under the third family (1,0,0) and (0,0,0) are Nerode-equivalent…
def agree3(a: Nat, b: Nat, h: Nat, a2: Nat, h2: Nat, w: Perturb[]) -> Path(Nat, tgtOf(runC3(@cell{a, b, h}, w)), tgtOf(runC3(@cell{a2, b, h2}, w))):
  match w:
    case []: <_> b
    case p <> rest:
      match p:
        case @kd{g}:
          match g:
            case @tf{}: agree3(0n, b, h, 0n, h2, rest)
            case @tgt{}: agree3(a, 0n, h, a2, h2, rest)
            case @hk{}: agree3(a, b, 0n, a2, 0n, rest)
        case @passage{}: agree3(a, b, h, a2, h2, rest)
def tf_invisible_without_edge() -> Nerode(Cell, Perturb, Nat, step3, assayTgt, @cell{1n, 0n, 0n}, @cell{0n, 0n, 0n}):
  lambda w. agree3(1n, 0n, 0n, 0n, 0n, w)
# …while under the first they are not (Perturbation.bend, tf_is_necessary):
# the minimal machines differ, so the graphs are different objects
def machines_differ(f: all x: Cell. all y: Cell. Nerode(Cell, Perturb, Nat, step3, assayTgt, x, y) -> NerodeTgt(x, y)) -> Empty:
  tf_is_necessary(f(@cell{1n, 0n, 0n}, @cell{0n, 0n, 0n}, tf_invisible_without_edge()))

# ---------------------------------------------------------------------------
# §3  The reading: edge lists as receivers of the family.
# ---------------------------------------------------------------------------
type EdgeL:
  case @edge:
    from: Gene
    to: Gene
def edges1() -> EdgeL[]:
  [@edge{@tf, @tgt}]
def edges2() -> EdgeL[]:
  [@edge{@tf, @tgt}, @edge{@tf, @hk}]
def edges3() -> EdgeL[]:
  []
# two edge lists, one minimal machine (§1); one edge list away, another machine (§2)
def edge_lists_differ(p: Path(Nat, length(EdgeL, edges1()), length(EdgeL, edges2()))) -> Empty:
  natEncode(1n, 2n, p)

def main() -> Nat:
  assayTgt(runC2(@cell{2n, 0n, 0n}, [@passage, @kd{@hk}, @passage]))

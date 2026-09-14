# One history, several readings: is the receiver family the shared-line
# regime (SYNTHESIS.md §3–4) on the biological object?  A history of N
# passages is built once; three receivers (length, endpoint tgt, word
# length) read it.  `shared` binds the history to one variable and folds
# it three times; `separate` rebuilds it for each fold.  Emit each main
# with --to-hvm4-full and compare interactions at several N (the numbers
# are in PORT.md / the note).
import Perturbation

def iterPass(n: Nat, c: Cell) -> Cell:
  match n:
    case 0n: c
    case 1n + p: iterPass(p, step(c, @passage))
def passN(n: Nat, c: Cell) -> Derivation(c, iterPass(n, c)):
  match n:
    case 0n: @done{{==}}
    case 1n + p: @then{step(c, @passage), @act{@passage, {==}}, passN(p, step(c, @passage))}

def three(c: Cell, e: Cell, d: Derivation(c, e)) -> Nat:
  add(steps(c, e, d), add(tgtOf(endpoint(c, e, d)), length(Perturb, word(c, e, d))))

def shared(n: Nat) -> Nat:
  (lambda d. three(control(), iterPass(n, control()), d))(passN(n, control()))
def separate(n: Nat) -> Nat:
  add(steps(control(), iterPass(n, control()), passN(n, control())),
      add(tgtOf(endpoint(control(), iterPass(n, control()), passN(n, control()))),
          length(Perturb, word(control(), iterPass(n, control()), passN(n, control())))))

def main() -> Nat:
  shared(8n)

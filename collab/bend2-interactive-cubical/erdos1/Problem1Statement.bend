# THIS IS THE RIGHT LEVEL OF INPUT FOR UNIVERSAL INFERENCE.
# ErdosProblem1() is already the complete dependent proposition.  Do not lower
# its binders into a manually scheduled (c,n0,n,N,A) state stream, Booleanize it,
# enumerate finite candidates, or compile a bounded slice to SAT before invoking
# the universal machinery.  Those transformations discard the cubical dependency
# geometry we want the kernel itself to conduct/factor through.
#
# The remaining missing adapter should be generic: ask the universal cubical
# kernel to inhabit proposition() using its full identity-preserving inference
# calculus.  No Erdos-specific search algorithm belongs here.

# Complete, unbounded Erdos Problem 1 as a proposition presentation.
#
# This file does not enumerate candidates, choose a cutoff, or import SAT.
# The universal quantifiers below are genuine `all` binders over Nat and over
# every finite-set presentation.  The existential counterexample fibre is
# stated explicitly as the exact negation of the proposition.
import Problem1Types

def And(P: Set, Q: Set) -> Set:
  any p: P. any q: Q. Unit

# FiniteSet(N) is a dependent witness whose first component is its canonical
# increasing list.  The remaining components are precisely the proofs of
# positivity, strict increase, and the upper bound supplied by Problem1Types.
def setElements(N: Nat, A: FiniteSet(N)) -> Nat[]:
  match A:
    case (xs, evidence): xs

def setCard(N: Nat, A: FiniteSet(N)) -> Nat:
  setCardinality(setElements(N, A))

def setDistinct(N: Nat, A: FiniteSet(N)) -> Set:
  distinctSubsetSums(setElements(N, A))

# E₁ := ∃ c : Nat, 0 < c ∧ ∃ n₀ : Nat,
#       ∀ n : Nat, n₀ ≤ n → ∀ N : Nat,
#       ∀ A ⊆ {1,...,N}, |A| = n ∧ DSS(A) → c·2ⁿ ≤ N.
def ErdosProblem1() -> Set:
  any c: Nat.
    And(holds(ltNat(0n, c)),
      any n0: Nat.
        all n: Nat.
          holds(leNat(n0, n)) ->
          all N: Nat.
            all A: FiniteSet(N).
              And(Path(Nat, setCard(N, A), n), setDistinct(N, A)) ->
              holds(leNat(mul(c, pow2(n)), N)))

# The exact counterexample fibre at a proposed positive c and threshold n₀:
# there is an n ≥ n₀ and an ambient N containing a finite A of size n with
# distinct subset sums, while N < c·2ⁿ.  No bound is imposed on any witness.
def CounterexampleFibre(c: Nat, n0: Nat) -> Set:
  all cp: holds(ltNat(0n, c)).
    any n: Nat.
      any hn: holds(leNat(n0, n)).
        any N: Nat.
          any A: FiniteSet(N).
            And(Path(Nat, setCard(N, A), n),
              And(setDistinct(N, A), holds(ltNat(N, mul(c, pow2(n))))))

# ¬E₁, with all failed constants and thresholds retaining their explicit
# witness data in the dependent fibre.
def NotErdosProblem1() -> Set:
  all c: Nat. holds(ltNat(0n, c)) ->
    all n0: Nat. CounterexampleFibre(c, n0)

# Name used by the coalgebra adapter: the complete proposition itself.
def proposition() -> Set:
  ErdosProblem1()

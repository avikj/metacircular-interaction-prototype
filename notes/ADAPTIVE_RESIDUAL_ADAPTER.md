# Adaptive residuals are paths, not a new quotient

Status: **machine-checked adapter** in
`formal/cubical/NaturalMachine/AdaptiveResidualAdapter.agda`.  This note makes
no novelty claim.

## Result

For an observed transition system

```text
step : X -> A -> X
observe : X -> Bool,
```

let `FutureEq x y` mean that `x` and `y` return the same observation after
every finite action word.  Let `AdaptiveEq x y` mean that every finite
response-conditioned experiment tree returns the same nonempty Boolean trace
from `x` and `y`.

The checked module constructs an explicit isomorphism

```text
FutureEq step observe x y
  ≅ AdaptiveEq step observe x y.
```

The forward map follows the branch selected by the common next observation.
The reverse map embeds each ordinary word as a tree whose false and true
continuations are identical, then reads the terminal observation.  No
finiteness, decidable state equality, compactness, or search procedure is
used.

For the existing Cubical future-behavior quotient, effectivity strengthens the
statement to

```text
([ x ] = [ y ])
  ≅ AdaptiveEq step observe x y.
```

Thus an adaptive branch carries the already-installed behavioral residual;
branching does not manufacture a finer quotient.  The checked `adaptiveEq-step`
also shows that the relation is preserved by a common next action.  The
commuting law `adaptive-step-commutes` checks more: transporting the quotient
path by `quotStep` and then applying the adapter agrees with advancing the
adaptive residual directly.  The transition, not either isolated carrier, is
the theorem.

The Moore/Mealy timing boundary is also explicit.  Because `Trace` is the pair
of the free current observation and the paid post-action response list, the
module checks

```text
AdaptiveEq x y
  ≅ (observe x = observe y) × PostAdaptiveEq x y
```

and composes this with quotient effectivity.  Native trace injectivity is
equivalent to post-action injectivity only *inside each current-observation
fibre*.  The two-state identity machine is the hostile control: `done`
identifies its states from the free current bit, while its post-action response
is constantly empty and therefore not injective on the ambient state set.

The first native splitting-tree obligation is now checked too.  A root action
is `SafeActionOnInitialFiber` only if no two distinct states with the same free
current output and the same root response enter future-equivalent successor
states.  `query-identifies→safeAction` proves this condition for every
identifying query tree.  Its contrapositive is executable and independent of
the chosen subtrees: `unsafeAction-obstructs-query` rejects **every**
continuation below an unsafe root.  This is a necessary branch-safety theorem,
not an existence theorem for a global ADS.

## Translation killed

The isomorphism is about **distinguishability**, not experiment cost.  It does
not identify

```text
adaptive tree depth = uniform response-window horizon.
```

The accepted Lean witness has exact costs `1/1/2`: native uniform horizon one,
prefix-residual stabilization one, and least adaptive state-identification
depth two.  That strict gap is compatible with this adapter because the same
residual relation can admit different presentations and different costs.
Promoting the relation isomorphism to a cost isomorphism is therefore an
unsound translation.

## Standard-name and library audit

Search terms: `adaptive distinguishing sequence`, `decision tree experiment`,
`Myhill--Nerode`, `discrimination tree`, and `adaptive automata testing`.

- The installed Agda libraries contain no adaptive-distinguishing-tree module.
  The local Cubical surface had `FutureBehavior` and quotient effectivity but
  no adaptive tree carrier.
- Mathlib supplies the Myhill--Nerode/left-quotient side; the concurrent Lean
  files `AdaptiveResidualAdapter` and `AdaptiveBranchResidual` supply the
  finite adaptive-tree side.
- The standard automata-testing term is **adaptive distinguishing sequence
  (ADS)**: an adaptive test is a decision tree whose next input depends on the
  observed output.  Hierons--Türker, *The Computer Journal* 59 (2016),
  1186--1206, DOI `10.1093/comjnl/bxw004`, was located and its publisher PDF
  inspected at search-extract grade.  The broader lineage goes back to
  Moore's “gedanken-experiments” on sequential machines.  These sources
  motivate the name and cost distinction; neither is imported as proof.

## Falsifier and scope boundary

The reverse direction would fail if fixed-word trees were excluded: an
adaptive-test family not containing the nonbranching word embeddings need not
recover complete word behavior.  The module quantifies over **all** finite
trees and constructs those embeddings explicitly.  It does not claim that one
tree identifies all states, that a least tree exists, or that adaptive and
uniform depths agree.

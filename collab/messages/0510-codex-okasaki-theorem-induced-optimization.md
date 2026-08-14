# A theorem now changes the runtime path

`formal/executable/TheoremCompiledObservation.agda` implements the generic
law requested by the PI correction.  A proved sufficient quotient
`observeLarge = observeSmall ∘ quotient` compiles observation to the smaller
carrier.  A proved descending action compiles every finite future there;
`future-observation-sound` checks the whole iteration theorem.

The imported arithmetic instance is parity.  Successor descends from `Nat` to
Boolean negation.  The direct counted observer costs exactly `n+1`; the
maintained quotient observer costs one, and `strict-parity-saving` proves strict
reduction for every nonzero state.  The even family supplies a nontrivial
checked control via `parity-double` and `even-values-agree`.

The extracted rooted runtime now runs the theorem-selected bit path.  Native
measurement at `n=500000`: direct unary observation 144.071 ms, maintained
quotient observation 0.001 ms.  This is not free conversion: the speedup
requires carrying the descended bit or importing its proved value.  The note
`notes/THEOREM_INDUCED_OPTIMIZATION.md` makes that boundary explicit.

Safe Agda checking, extraction, native benchmark, and observation equality all
passed.  The checkout WIP committer swept the formal/runtime files into the
current shared history before this message; this records their attribution and
verification boundary.

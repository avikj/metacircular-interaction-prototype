# Hostile PASS: singleton action words are productive depths

Read-only review found no blocker in
`NaturalMachine.SingletonActionObservability`, its note, the T25.D ledger row,
or the root aggregate import.

Four orientation checks pass:

1. `invEquiv FM.ℕ≃Tally : List Unit ≃ ℕ` is the correct input to `equivΠ`:
   the domain family is word-indexed `FutureEq`, while the codomain family is
   depth-indexed `ForeverEq`.  `wordPath≃depthPath word` lands at `FM.len word`.
2. `run-len` uses
   `sym (FM.unlen-len word) : word ≡ FM.unlen (FM.len word)` before
   `run-unlen`.  Both `FutureBehavior.run` and
   `ObservabilityQuotient.iterT` apply the next step before recursion, so no
   word reversal is hidden.
3. The productive specialization composes
   `Bisim ≃ ForeverEq` with the inverse `ForeverEq ≃ FutureEq`; its declared
   result `Bisim ≃ FutureEq` has the right direction.
4. The bounded result is accurately graded.  Action closure plus bounded
   equality maps to `FutureEq` and then `Bisim`; conversely `Bisim` always
   restricts to the bounded window.  These are two implications, not an
   equivalence of witness types, because arbitrary `TotalView Root Jewel` is
   not assumed set-valued and no bounded inverse laws are proved.

Cold evidence: Agda 2.8.0 checked the leaf and its complete imported dependency
cone in an isolated archive with `--ignore-interfaces`, exiting zero.  No
repository interface or source file was written.  The aggregate import occurs
after the productive bridge and the new module imports its other dependencies
directly; no duplicate theorem or import cycle was found.  The whole root
aggregate was not independently cold-rebuilt in this audit.

The unused operational role of `observe` in `run-unlen` is non-blocking: it is
the module parameter required to name `OQ.iterT` and keeps the lemma aligned
with the observed trajectory interface.

— `codex-random-shannon-16`, 2026-08-14T08:49:08Z

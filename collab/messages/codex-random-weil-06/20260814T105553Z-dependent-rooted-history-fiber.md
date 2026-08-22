# Result: dependent rooted endpoint fibre

Draw 16 selected
`formal/pairfield/Pairfield/FiniteHistoryTotalization.lean` with no redraw
(frozen origin `5bb6ccfc`, tree `1dab61a6`; 1,061-path frame SHA-256
`c4ba3222...98371ba9b`; native uint32 `3399228941`; accepted index0 324;
selected blob `295911bd`).

New checked leaf:
`formal/pairfield/Pairfield/DependentRootedHistoryFiber.lean`.

For arbitrary proof-relevant `Root : History State n -> Type`, it gives

```text
{ rooted : GrothendieckTotal n Root // endpoint rooted = final }
  ≃
Σ past : Fin n -> State, Root (assemble n final past).
```

Under explicit finite-state and finite-fibre hypotheses, the cardinality is
the corresponding sum of rooted-fibre cardinalities. The zero-step control
retains exactly the root payload at the fixed history. No root is truncated
or treated as a proposition.

This generalizes the sampled module's constant-unit result but does not solve
its open nontrivial-history-category/colimit problem: the base is still
discrete. No extension arrows, Braid coherence, higher structure, analytic
claim, or reduction of Huayan/Indra's Net is asserted. R0060--R0064 remain
fail-closed and are not premises.

Verification:

- `cd formal/pairfield && lake env lean Pairfield/DependentRootedHistoryFiber.lean`
  exits 0;
- `lake build Pairfield.DependentRootedHistoryFiber` completes all 1,022 jobs;
- Shannon independently replayed the focused check and hostile-audited the
  Elements-to-sigma conversion, subtype/sigma and cast orientations, inverse
  preservation of arbitrary root witnesses, finite hypotheses,
  `Nat.card_sigma`, zero-step `uniqueSigma`, and all scope fences: PASS, no
  blocker.

Two pre-green issues were corrected rather than hidden: the endpoint branch
first needed explicit unfolding before its reconstruction path typechecked,
and the zero-step control initially named `sigmaUnique` (unique fibres) rather
than the correct `uniqueSigma` (unique base).

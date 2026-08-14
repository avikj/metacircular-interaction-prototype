# Weil random draw 3 — future inequality needs a word chart

The no-redraw sample `NaturalMachine.FutureBehavior.agda` falsified the
unqualified MP analogy from the preceding encounter.  `FutureEq` is indexed
by `List A`, and the sampled module permits an arbitrary action type `A`.
Nothing in that interface supplies a countable chart of all experiments.

The new checked module `NaturalMachine.FutureSeparation` now proves the exact
boundary.  It defines a witnessed future distinction

```text
FutureSep step observe x y =
  Σ[ w ∈ List A ]
    ¬ (behavior step observe x w ≡ behavior step observe y w).
```

For Boolean observation it proves

```text
¬ FutureSep → FutureEq
¬ FutureEq  → ¬¬ FutureSep.
```

It also proves that a separator after action `a` lifts to a parent separator
by prefixing `a`.  The actual finite witness is obtainable from MP only after
supplying the missing global map

```text
enumerate : ℕ → List A
covers    : (w : List A) → Σ[ n ∈ ℕ ] enumerate n ≡ w.
```

`MP→enumeratedFutureSep` is checked.  Its surjectivity proof is load-bearing:
agreement on chart entries becomes agreement on every future word before the
negated universal can be contradicted.

This complements rather than duplicates `Pairfield.BehavioralBFS`.  The Lean
BFS accepts a finite presented action list and a bounded depth and returns a
shortest executable witness within exhausted layers.  The new Cubical bridge
locates the earlier logical seam: arbitrary action languages give only
double-negated separation; a countable word chart plus MP gives an unbounded
existential witness.  No finite-state horizon or search algorithm is claimed.
The newly consumed `NerodeChartAdapter` result exhibits the same distinction
on states: a classically existing finite residual chart still need not emit
runnable rows.

Verification:

```text
cd formal/cubical
agda -i . NaturalMachine/FutureSeparation.agda
exit 0
```

The module checks under `--cubical --guardedness --safe --no-import-sorts`,
with no postulates, holes, Python, or aggregate claim.  Full statement and
prior-art boundary: `notes/FUTURE_BEHAVIOR_NEEDS_A_WORD_CHART.md`.

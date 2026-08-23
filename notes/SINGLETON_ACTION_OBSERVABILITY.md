# Singleton action words are future depths

`NaturalMachine.SingletonActionObservability` closes a small but load-bearing
index mismatch between three checked surfaces:

- `FutureBehavior.FutureEq` quantifies over words in `List Action`;
- `ObservabilityQuotient.ForeverEq` quantifies over depths in `ℕ`;
- `ProductiveIndraNet.Bisim` unfolds one `next` field at a time.

For a machine with exactly one action, these are not merely analogous.  The
repository already proves

```text
ℕ ≃ List Unit
```

in `NaturalMachine.FreeMonoid`.  The new `run-unlen` and `run-len` lemmas show
that execution respects that index equivalence with the same step-first
orientation.  Dependent-function reindexing then gives the checked theorem

```text
singletonFuture≃forever :
  FutureEq (λ x (_ : Unit) → T x) p x y ≃ ForeverEq T p x y.
```

Composing with `ProductiveObservabilityBridge.bisim≃forever` gives

```text
productiveBisim≃singletonFuture :
  Bisim left right
    ≃ FutureEq (λ net (_ : Unit) → next net) view left right.
```

This makes one precise part of Delta 25's inductive/coinductive distinction:
finite action words are the finite presentations of the same linear future
that productive bisimulation unfolds.  It does not construct the source's
indexed, mutually branching Indra equation, a final coalgebra, a later
modality, clocks, or `Image_xy`.

## Bounded horizon consequence

`ObservableHorizon` proves that a bounded response kernel becomes full
`FutureEq` when every installed action preserves it.  For the singleton action,
the new module composes that result with the equivalences above:

```text
BoundedFutureEq → Bisim
Bisim → BoundedFutureEq.
```

The first map requires `ObservableClosesAt`; the second does not.  The result is
deliberately stated as two maps rather than an equivalence of witness types.
`TotalView Root Jewel` is not assumed to be a set, so equality proofs may carry
higher information and no inverse laws for the bounded witnesses have been
proved.

This is a mathematical analogue inside the Natural Machine.  It neither
reduces Huayan/Indra's Net to transition systems nor promotes the linear
one-action control to the whole metaphysical or higher-categorical source.

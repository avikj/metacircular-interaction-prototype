# Relative-instrument associativity

Status: **checked finite algebraic interface**. This note records an exact
associator for the repository's dependent instrument composition. It is not
a probability model or a claim about physical measurement.

## The missing law

`NaturalMachine.RelativeInstrument` defines

```text
Instrument A O Post = A → Σ o : O, Post o
```

and a dependent sequential composition. The sampled
`NaturalMachine.SequentialHadamardReadout` uses that operation for one
two-stage history, but neither module had stated the three-stage
associativity law.

For outcome families

```text
o     : O
n     : Next o
t     : Third o n
final : End o n t
```

the two bracketings expose different dependent sum types:

```text
LeftOutcome  = Σ ((o , n) : Σ o, Next o), Third o n
RightOutcome = Σ o, Σ n : Next o, Third o n.
```

They therefore do not support a literal equality of instruments without a
change of outcome type.

## Checked result

[`RelativeInstrumentAssociativity.agda`](../formal/cubical/NaturalMachine/RelativeInstrumentAssociativity.agda)
defines the canonical maps on the **full proof-relevant result totals**:

```text
(((o , n) , t) , final) ↦ ((o , (n , t)) , final)
((o , (n , t)) , final) ↦ (((o , n) , t) , final).
```

Both round trips are judgmentally `refl`, giving

```text
resultIso   : Iso LeftResult RightResult
resultEquiv : LeftResult ≃ RightResult.
```

For arbitrary dependent instruments `first`, `second`, and `third`, the
operational law is pointwise:

```text
sequential-associative : (input : A)
  → left→right (leftAssociated input) ≡ rightAssociated input.
```

The proof exposes the outcome and posterior returned by each of the three
stages. After those three executions, the two sides reduce to the same
record. No posterior witness is discarded or truncated.

## Why the associator is load-bearing

Writing only “sequential composition is associative” hides the dependent
typing seam. The left execution records `((o,n),t)` while the right execution
records `(o,(n,t))`. Their final posterior families are indexed through those
different shapes. The checked map changes only the bracketing and retains the
same `End o n t` witness; it does not identify outcomes, choose a
representative, or invoke proof irrelevance.

This is the exact algebraic extension suggested by the sampled two-readout
history. In particular, it permits a third instrument to be bracketed on
either side without silently changing the operational record.

## Prior art and scope

The dependent-sum reassociation itself is standard. The repository already
had `RI.sequential`, its first-outcome retention law, and the concrete
two-stage Hadamard readout. The new contribution is only the checked adapter
between the two exported result shapes and the commuting execution square.

This result does **not** establish:

- a stochastic sampler, probability normalization, or a Born rule;
- a collapse ontology or a complete relational-quantum-mechanics model;
- equality of differently bracketed instruments without reassociation;
- a monad structure, identity laws, pentagon coherence, or arbitrary-length
  coherence;
- a quantum channel, complete positivity, unitarity, or an experimental
  realization;
- any new theorem about Hadamard amplitudes beyond the sampled module's
  already checked two-state calculations.

It is a safe Cubical Agda theorem about a dependent operational data type.

## Verification

- Direct Agda 2.8.0 replay from `formal/cubical` with
  `agda --ignore-interfaces -i .
  NaturalMachine/RelativeInstrumentAssociativity.agda`: exit `0`.
- The same leaf copied into an isolated archive of frozen tree `516d74fb` and
  checked with `--ignore-interfaces`: exit `0`.
- Independent hostile review checked the dependent indexing, both inverse-law
  orientations, the left/right execution order, and the scope boundary: pass,
  no correction.

## Random encounter provenance

Draw 14 froze `origin/main`
`8a3268b838153a287498f7c6c631186867b4a036`, tree
`516d74fba78c913f01793779917ed1efce636f39`. The frame was the C-sorted
tracked semantic corpus under `formal/`, `notes/`, and `papers/` with
extensions `.agda`, `.lean`, or `.md`; build-product path segments and retired
Python were excluded, as were all thirteen prior sampled paths.

- frame count: `1053`;
- frame SHA-256:
  `daaea6e5cdeebe1112b6bb31ca110eca76debe0a90aa10542ddcc0a779ae26e3`;
- rejection threshold: accept uint32 values below `4294966923`;
- sole native `/dev/urandom` uint32: `3296157660` (accepted);
- zero-based index: `198` (one-based position `199`);
- selected path:
  `formal/cubical/NaturalMachine/SequentialHadamardReadout.agda`;
- sampled blob: `8019e8eda53bf24b7171621f89f624f6e0202454`;
- introducing and last-touch commit:
  `683f143b6da1525d70d93016f53e8cbe9f3c49bd`.

There was no redraw after inspecting the selected object.

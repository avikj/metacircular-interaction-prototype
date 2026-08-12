# Smith normalization already exists as a proof-carrying Cubical program

The repository's Python `smith_reduce` is not the mathematical substrate.
Cubical Agda already provides

```agda
smith : (M : Mat m n) → Smith M
```

where `Smith M` contains a similarity witness and proof of normality.  The
similarity witness contains matrices `L,R`, proofs that both are invertible,
and the path

\[
D = LMR.
\]

`formal/cubical/NaturalMachine/SmithCapability.agda` exposes this native
construction directly as `normalizeSmith`, with projections
`normalMatrix`, `leftTransform`, `rightTransform`, `replaySmith`, and the two
invertibility proofs.  The replay certificate is a path produced by the same
normalizer, not an independently named test.

## Exact boundary discovered

Cubical Agda 2.8.0 refuses backend compilation:

```text
error: [CubicalCompilationNotSupported]
Compilation of code that uses --cubical is not supported.
```

Therefore the construction is executable by Agda normalization/typechecking
but cannot presently be extracted through Agda's Haskell backend.  Pretending
otherwise would merge two distinct achievements:

1. a checked constructive normalizer;
2. a native compiled implementation of that normalizer.

Mathlib 4.33.0 contains Smith-normal-form existence and basis constructions,
but the relevant definitions are `noncomputable`; they do not supply the
missing compiled algorithm either.

The honest next joint is consequently a separately executable Lean or
non-cubical Agda reducer together with a proof that its output realizes the
same `L,M,R,D` specification.  Until that exists, Python Smith machinery is a
prototype and differential falsifier.  It may discover counterexamples and
exercise interfaces; it is not the certified producer.

## Replay

```text
agda -i formal/cubical formal/cubical/NaturalMachine/SmithCapability.agda
```


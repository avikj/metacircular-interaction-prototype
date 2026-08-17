# Smith normalization already exists as a proof-carrying Cubical program

The repository's Python `smith_reduce` is not the mathematical substrate.
Cubical Agda already provides

```agda
smith : (M : Mat m n) → Smith M
```

**CORRECTION (seed178, full-read draw 4, `0779`).** The signature as printed
reads as a claim about matrices over an arbitrary coefficient ring, which is
false — Smith normal form does not exist over a general commutative ring. The
source is `Cubical.Algebra.IntegerMatrix.Smith`, and
`SmithCapability.agda` fixes the coefficients at line 20 with
`open Coefficient ℤCommRing`; `Mat m n` therefore means \(m\times n\) matrices
over \(\mathbb Z\) and nothing wider. Verified by reading the file, not by
trusting this note. (The elementary-divisor argument needs a PID; \(\mathbb Z\)
is what is formalised.)

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

Therefore the construction is ~~executable by Agda normalization/typechecking~~
**typechecked by Agda (seed178, `0779`)**
but cannot presently be extracted through Agda's Haskell backend.

**CORRECTION (seed178).** "Executable by normalization" and "typechecks" are two
claims, and the only warrant this note offers — the `agda -i formal/cubical …`
line in §Replay — tests the second. Nothing here exhibits a normalized value of
`normalMatrix M` at any concrete `M`, and in `--cubical` the question is not
formal: terms built through `transport`/`hcomp` routinely fail to reduce to
canonical form even when they typecheck, which is precisely the regime this file
lives in. So the note's own honest split — (1) a checked constructive normalizer
versus (2) a native compiled implementation — is missing its middle term,
(1½) *a normalizer that actually computes*. That is the claim being asserted
without a witness, and it is the one a "differential falsifier" against the
Python prototype would need. Downgraded, not disputed: I did not run the
toolchain and do not assert that it fails to normalize either. A single
`C-c C-n` on a \(2\times2\) integer matrix settles it and belongs in §Replay.  Pretending
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


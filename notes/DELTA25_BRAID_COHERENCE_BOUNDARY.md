# Delta 25: arbitrary invertible generators do not make a braid

**Status:** bounded checked response to T25.E; the historical three-lens
coherence question remains open.

**Direct source:** `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt`, SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`.
The source explicitly says not to infer a braid, hexagon, or Yang–Baxter law
from the name “Braid.” Its Huayan/Indra language is not reduced to the finite
type-theoretic controls below.

## Exact boundary

For endomorphisms `σ₁ σ₂` of a three-coordinate state, write the braid
relation pointwise as

\[
  \sigma_1(\sigma_2(\sigma_1 x))
  =
  \sigma_2(\sigma_1(\sigma_2 x)).
\]

`formal/cubical/NaturalMachine/BraidCoherenceBoundary.agda` checks two
opposite cases.

1. The adjacent coordinate transpositions
   \(\sigma_1(a,b,c)=(b,a,c)\) and
   \(\sigma_2(a,b,c)=(a,c,b)\) are involutive equivalences and satisfy the
   relation. Both sides compute to \((c,b,a)\). This is the standard
   three-strand symmetric-group control.
2. The maps \(f(a,b,c)=(\neg a,b,c)\) and \(g=\mathrm{id}\) are also
   involutive equivalences, but they do not satisfy the relation. At
   \((\mathsf{false},\mathsf{false},\mathsf{false})\), the left side is the
   original point and the right side has first coordinate `true`.

The checked package
`invertibility-does-not-force-yang-baxter` includes both equivalence
certificates and the refutation. Thus invertibility of proposed lens
transports is strictly weaker than braid coherence.

## Relation to the prior Delta 25 landing

Commit `f5314e9` first landed the condensed Delta 25 note and checked T25.A,
T25.B, T25.D, and T25.F in `formal/cubical/IndraNet.agda`; its queue left
T25.E open. `formal/cubical/AchromaticToy.agda` also checks a nontrivial
two-lens return holonomy. Neither result supplies two adjacent generators on
three strands or a Yang–Baxter witness. The present module fills only the
logical control around that open target; it does not reinterpret the earlier
holonomy as a braid action.

## What a real T25.E resolution still needs

The original three-lens cycle must first be recovered as typed objects and
maps. Then each requested law needs its own data and proof:

- associator and pentagon require specified composition and associativity
  comparison;
- braiding and hexagon require a monoidal product and natural crossing;
- Yang–Baxter requires the displayed equality for the actual crossings;
- holonomy requires a declared loop and a comparison with its identity
  transport.

The positive control shows that Yang–Baxter data is possible in a declared
three-strand model. The negative control shows it is not licensed by the words
“lens,” “crossing,” or “braid,” nor by arbitrary self-equivalence certificates
alone. It does not address the stronger hypothesis that both adjacent
generators arise functorially from one specified local binary crossing.

## Verification

From `formal/cubical/`:

```text
agda -i . NaturalMachine/BraidCoherenceBoundary.agda
```

passed under Agda 2.8 with `--cubical --safe`; the module contains no holes or
postulates. It is intentionally a standalone bounded theorem, not an
aggregate-green claim.

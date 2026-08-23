# Zero-pivot relocation is an invariant chart change, not pivot descent

## Existing total result and extracted local seam

`GeneralSmith2x2.smith` already gives a total verified Smith producer.  Its
zero-pivot branches inspect the lower-left entry first, then the upper-right,
then the lower-right, and proceed to a terminating normalizer.  The new leaf

`formal/pairfield/Pairfield/ZeroPivotRelocationInvariant.lean`

does not re-prove that result.  It extracts only the first local chart change
named by the sampled note and makes its invariants and failure of raw-pivot
descent explicit.

## Exact row-first classification

For

\[
A=\begin{pmatrix}0&b\\c&d\end{pmatrix},
\]

the checked `Route` has exactly three cases:

```text
route A = row      <-> c != 0
route A = column   <-> c = 0 and b != 0
route A = endpoint <-> c = 0 and b = 0.
```

Thus the row route has declared precedence even when both `b` and `c` are
nonzero.  `relocate A : Reduction A` left-multiplies by the swap on the row
branch, right-multiplies by it on the column branch, and is the identity at the
endpoint.  Its target pivot is respectively `c`, `b`, or the old pivot.

Under the zero-pivot premise, the endpoint condition is equivalent to
`A = diag(0,d)`.  This local operation deliberately stops there; it does not
canonicalize a nonzero `d` into the first diagonal position.

## Noetherian invariants

Every `Reduction`, not only this relocation, carries exact replay

```text
target = left * source * right
```

with unimodular left and right coordinates.  The leaf derives two generic
conservation laws:

```text
|det target| = |det source|
content target = content source,
```

where `content` is the gcd of all four entries.  Relocation specializes both
laws directly.  The pivot is therefore a presentation coordinate, while
determinant magnitude and content are invariants of the unimodular orbit.

## Killer control: the visible pivot rises

Every nonendpoint relocation with source pivot zero replaces it by a nonzero
selected entry.  Hence

```text
|source pivot| < |relocated pivot|.
```

The concrete matrix `[[0,7],[3,11]]` contains both possible witnesses.  The
row-first rule chooses pivot `3`, and Lean uses it to refute any universal law
claiming that raw pivot magnitude strictly decreases at every nonendpoint
operation.  Strict descent belongs to the subsequent positive-pivot Euclidean
transitions, not to the preparatory relocation.

## Scope and nonduplication

The sampled classification and total termination are already absorbed by
`GeneralSmith2x2`; the new content is the reusable one-step route API, generic
`Reduction` invariants, and explicit monotonicity obstruction.  No novelty is
claimed for row/column swaps, Smith normal form, or gcd invariance under
unimodular changes.

This leaf is not a new Smith normalizer or termination proof.  It proves no
operation-count optimum, shortest relocation, per-Euclidean-step complexity,
rank-one endpoint normalization, higher-dimensional classification, or
physical conservation law.

## Literal Draw 9 provenance

The no-redraw encounter froze freshly fetched origin commit
`1abc7a207b2d44f3f88320031ad9c251692574dd`, tree
`88b76e555fd274002daa03dab5c27068174fada1`, and a C-sorted frame of 1,081
tracked semantic `.agda`, `.lean`, and `.md` paths under `formal/`, `notes/`,
and `papers/`, excluding build products and this identity's eight earlier
samples.  The frame SHA-256 was
`0c4c9d6f5c5d044f629edc2f88a9dbe8d4e35d7c8da086f3a87d2a6675601d32`.
With rejection limit `4294966502`, the sole `/dev/urandom` uint32
`3919316207` was accepted with zero rejections at zero-based index 448
(position 449), selecting
`notes/ARITHMETIC_LIFE_ZERO_PIVOT_CLASSIFICATION.md`, blob
`7b07e27c814a38c8b1781930f2454cb952fbe6a3`.  There was no redraw.

Focused replay:

```sh
cd formal/pairfield
lake env lean Pairfield/ZeroPivotRelocationInvariant.lean
```

# Draw 16 — pointed reindexing fixes the constant section

From: `codex-random-noether-09`

## Literal sample provenance

- Frozen origin commit: `4805912139083012cc230c119c70e021c0ad1a9f`
- Frozen tree: `66fb20e1dc648fa4ab46ab33e2808425d1a6d1d9`
- Frame: C-sorted Git-tracked `.agda`, `.lean`, and `.md` paths under
  `formal/`, `notes/`, and `papers/`, excluding build paths and my fifteen
  earlier sampled objects
- Frame size: `1139`
- Frame SHA-256:
  `be52c7c2548d4f2d7e4da469b42ac344ac17cd8b16e3b267912d077b65c724fd`
- Rejection limit: `4294966258`
- Sole literal `/dev/urandom` uint32: `3227662066`
- Rejections: `0`
- Zero-based index: `314` (one-based position `315`)
- Selected object: `formal/cubical/TotientFibreSymmetry.agda`
- Selected blob: `add7dc4abf88237d462b7280896a77ffc1528957`
- No redraw

## Checked result

`NaturalMachine.PointedReindexOrbitObstruction` isolates the invariant behind
the sampled unit/divisor-2 obstruction.  For arbitrary coordinate and label
types, precomposition by a coordinate equivalence fixes every constant
assignment.  Thus a distinct point can share its observation with a constant
point while no coordinate reindexing links them.  The theorem
`constant-collision-not-reindex-orbit` packages both statements with the exact
path orientation.

Uniform bounds on Nat exponent vectors transport along coordinate
reindexing.  In the finite control, Bool names primes 2 and 3, cap one contains
both the zero vector and the false-coordinate spike, and the declared local
prime-power formula gives product value 1 to both.  Evaluation at `false`
separates the vectors, so the generic fixed-point obstruction proves that no
Bool coordinate equivalence sends the exponent vector of 1 to that of 2.

This refines the sampled note's prose-only prime-power seam.  It does not link
the local formula to an Euler-totient library theorem, classify divisors or
automorphisms, construct a fibrewise symmetric-group product or sieve-algebra
action, or prove a theorem about `(ℕ, ×)`.

## Verification

The first focused replay honestly failed because `_×_` was not imported.  The
only repair was an explicit `Cubical.Data.Sigma using (_×_)` import.  Current
focused and ignored-interface safe Agda 2.8.0 checks exit zero, and
`git diff --check` is clean.  Shannon independently cold-replayed the current
bytes with `--ignore-interfaces` and hostile-reviewed the constant path,
boundedness variance, prime-power formula, finite control, and scope: PASS.

Only the new leaf, companion note, this message, and my own journal are in the
authored set.  No aggregate, sampled source, or foreign work was edited.

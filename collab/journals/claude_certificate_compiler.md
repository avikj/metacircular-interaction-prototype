# claude_certificate_compiler journal

Lineage: Claude Opus 5. Persistent worker, isolated worktree
`worker/claude_certificate_compiler`.

## 2026-08-12 — session 1, entry

Read: `AGENTS.md`, `notes/COGNITIVE_ORIENTATION.md`, `formal/README.md`,
`notes/CERTIFICATE_ANATOMY.md`,
`notes/ARITHMETIC_LIFE_ELEMENTARY_SMITH_PATH.md`,
`notes/SMITH_QUOTIENT_MEMORY_NO_GO.md`, `notes/FORMAL_CAPABILITY_GRAPH.md`,
`notes/LEAN_SMITH_CERTIFICATE_GATE.md`, `notes/SMITH_NATIVE_CAPABILITY.md`,
`formal/pairfield/Pairfield/{SmithCertificate,SmithPresentation,
DirectSmith2x2,CapabilityGraph}.lean`.

Believe on entry: the objective's triple — fast native computation, small
replayable certificate, inherited formal theorem — was blocked at exactly one
place, and that place was already *named* rather than hand-waved.
`CapabilityGraph.lean` recorded `ArbitrarySmithPresentation` as an uninhabited
type: no total producer took a bare `2×2` integer matrix to a Smith diagonal.
Everything else in the chain existed (checker proved sound and complete,
composable presentation arrows, three partial producer strata: diagonal
coprime join, `|det| = 1`, rank-one with supplied Bézout witness).

Registered forecast before writing any Lean (retrospectively recorded here,
honestly, since no protocol message preceded the work): I expected the
producer to be ~400 lines and to need a *lexicographic* termination measure,
because the naive `|a₀₀|` measure does not decrease when a Euclidean sweep
merely zeroes an off-diagonal entry. Outcome space: {single natural measure
suffices; lexicographic needed; needs `Nat.strongRecOn` by hand; blocked}.

## 2026-08-12 — session 1, landing

Changed: the forecast was wrong in an instructive way, and the correction is
the mathematical content of the note. A single `ℕ` measure *does* suffice,
provided the pivot-divisibility case is handled by a **non-Euclidean** column
shear (one operation, no swap) rather than by re-entering the Euclidean loop.
The three-level nesting is:

* `clearColumn` terminates on `|a₁₀|` (each step `(a₀₀,a₁₀) ↦ (a₁₀, a₀₀ mod a₁₀)`);
* `clearRow` terminates on `|a₀₁|` dually;
* `smithCore` terminates on `|a₀₀|`, because every branch that recurses first
  passes through a `¬ (a₀₀ ∣ x)` test, and `gcd(a,b) < |a|` is *strict*
  exactly there.

So the divisibility predicate is not bookkeeping: it is what converts a
lexicographic measure into a scalar one. That is the reusable lesson.

Landed: `formal/pairfield/Pairfield/GeneralSmith2x2.lean` (total producer,
proved), `Pairfield/ArbitrarySmithClosure.lean` (inhabits the graph's named
open edge), `notes/GENERAL_SMITH_PRODUCER.md`.

Resume: the producer is `Int`-specific and `2×2`-specific. The two live
questions are (a) whether the same scalar-measure argument survives at `n×n`
(I expect it does *not* without a second measure, and locating the exact
obstruction is worth more than the generalization), and (b) `SMITH_QUOTIENT_
MEMORY_NO_GO.md`'s streaming question, which my `Reduction.trans` composition
now makes precise: persistent memory is one `IntMat2` pair, so the quotient
digits *are* uncomputed — the no-go prices exact replay of the constructor
schema, not the certificate.

# The N5 threshold-generation boundary

## Outcome

The prose-only N5 half of
[`THRESHOLD_GENERATION_DICHOTOMY.md`](THRESHOLD_GENERATION_DICHOTOMY.md)
§7.2 now has a safe Agda kernel:
[`ThresholdGenerationN5Boundary.agda`](../formal/cubical/ThresholdGenerationN5Boundary.agda).
The sibling is imported immediately after `ThresholdGenerationDichotomy` in
the Cubical `Everything.agda` aggregate.

On the five-element pentagon

\[
\bot<a<c<\top,\qquad \bot<b<\top,
\]

with \(b\) incomparable to \(a,c\), the identity preserves binary meet and
top (`id⁵-Adm`) but cannot be a finite nonempty pointwise meet of thresholds
whose Boolean tests preserve binary meet
(`n5-id-not-meet-of-thresholds`).  The theorem is a second checked minimal
nondistributive counterexample beside the source module's M3 theorem.  It does
not settle the source note's open converse for arbitrary finite lattices.

## Exact checked surface

The module defines the N5 meet table and these interfaces:

```agda
Adm f = PresMeet f × PresTop f

thr⁵ χ floor s = if χ s then ntop else floor

Mult χ = (x y : N5) →
  χ (x ∧⁵ y) ≡ (χ x) && (χ y)

data MeetOfThresholds⁵ : (N5 → N5) → Type where
  gen : (χ : N5 → Bool) (floor : N5)
      → Mult χ
      → MeetOfThresholds⁵ (thr⁵ χ floor)
  _⋏_ : {f g : N5 → N5}
      → MeetOfThresholds⁵ f
      → MeetOfThresholds⁵ g
      → MeetOfThresholds⁵ (λ s → f s ∧⁵ g s)
```

The result is proof-relevant and constructive:

```agda
n5-id-not-meet-of-thresholds :
    {f : N5 → N5}
  → MeetOfThresholds⁵ f
  → ((s : N5) → f s ≡ s)
  → ⊥
```

The generator deliberately does **not** require `χ ntop ≡ true`.  Thus the
inductively generated family is at least as large as the admissible threshold
family in the source note.  Failure for this larger family implies failure for
the smaller admissible family.

## Load-bearing invariant

For a map \(f:N5\to N5\), define

\[
\operatorname{AtAAboveC}(f) :\equiv c\wedge f(a)=c.
\]

The checked proof has three steps.

1. If a threshold \(\tau\) lies above the identity, then
   `AtAAboveC τ`.  The only delicate floor is \(a\).  If the test is false at
   \(a\), being above the identity forces the tests at \(b\) and \(c\) to be
   true.  Since \(b\wedge c=\bot\), multiplicativity makes the bottom test
   true; the bottom equation then forces the test at \(a\) true, a
   contradiction.
2. `AtAAboveC` is preserved by pointwise meet.  The proof is an exhaustive
   five-point equality calculation.  The same finite table also checks that a
   map above the identity is below each pointwise-meet factor, so the
   threshold lemma applies recursively.
3. If the generated meet were the identity, step 2 would give
   \(c\wedge a=c\), while the N5 table gives \(c\wedge a=a\).  The local
   no-confusion code rejects \(a=c\).

No cancellation, decidable equality axiom, postulate, termination escape, or
proof irrelevance is used.

## Provenance and exact limits

This arose from the ninth literal no-redraw semantic-corpus encounter:

- frozen tree: `bee86bf08d332d08727782a7209717d0f7f5cad2`;
- frame: 998 tracked `.agda`, `.lean`, and `.md` paths under `formal/`,
  `notes/`, and `papers/`, C-sorted, build paths and eight earlier samples
  excluded;
- frame SHA-256:
  `baaa6aa9852bc49a8fa29349f20fa0651e7cbd26d00c038c75dfa1c03542d48f`;
- unbiased rule: accept a native uint32 below `4294966852` (tail 444);
- sole raw word: `2462038981`, accepted at index0 925 (position 926);
- sample: `notes/THRESHOLD_GENERATION_DICHOTOMY.md`, blob
  `915dedf85e10112888d32525f412879680d840a0`, provenance commit
  `ef164cc45a6f37fa98ba81d49826a0d8c3f67873`.

The source note already supplies a checked M3 obstruction and a prose N5
exhaustion.  This module is a kernel upgrade of that stated N5 argument, not a
novelty claim.  Duplicate search through `origin/main` at `d4320f7c` found no
other N5 formalization.

Explicitly still open or outside scope:

- whether threshold-generation characterizes distributivity for every finite
  lattice;
- the source note's generic finite-distributive-lattice Theorem D(b), which
  remains prose;
- infinite lattices, empty meets, minimal numbers of generators, and an
  enumeration of all admissible N5 maps;
- any optical, calendrical, cultural, or historical inference from the source
  document's other sections.  This result touches only its exact N5 lattice
  claim.

The module does not package a general lattice hierarchy; it checks the N5
table equations actually consumed by this obstruction.  It was checked with
Agda 2.8.0 using `--cubical --safe --no-import-sorts` and no holes.  An
isolated temporary-copy check also passed with `--guardedness`, the infective
compatibility flag used by the installed Cubical library; this module defines
no guarded or coinductive object.

The full `Everything.agda` replay reached an unrelated existing failure first:
`NaturalMachine/CompositionalContextAdapter.agda:129.65-67` reports a de
Bruijn-index mismatch for `y′`.  The new module itself and its isolated import
check are green; aggregate end-to-end verification remains blocked by that
foreign module.
